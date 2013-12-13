require 'fileutils'
require './error_handler.rb'

class FilesMove

  attr_accessor :pattern, :verbose, :update, :no_target_directory, :mode, :backup, :suffix

  def move_files(sources, destination)
    check_target_on_some_rewrite(sources, destination)
    sources.each do |source|
      destination_full = get_full_destination(destination, source)
      if check_update_statement(source, destination_full)
        check_overwrite_file_with_dir(source, destination)
        check_overwrite_dir_with_file(source, destination)
        if @mode == :interactive
          next if File.exist?(destination_full) && interactive(destination_full)
        elsif @mode == :no_clobber
          next if File.exist?(destination_full)
        end
        begin
          @pattern == '**' ? file_move(source, destination_full) : pattern_process(source, destination_full)
        rescue Exception => ex
          ErrorHandler.handle(ex)
        end
      end
    end
  end

  def initialize(pattern, verbose, update, no_target_directory, mode, backup, suffix)
    @pattern = pattern
    @verbose = verbose
    @update = update
    @no_target_directory = no_target_directory
    @mode = mode
    @backup = backup
    @suffix = suffix
  end

  private

  def check_update_statement(source, destination)
    !@update || !File.exist?(destination) || File.mtime(source) > File.mtime(destination)
  end

  def check_overwrite_file_with_dir(source, destination)
    if File.directory?(source) && File.exist?(destination) && !File.directory?(destination)
      ErrorHandler.handle(ArgumentError.new("cannot overwrite non-directory '#{destination}' with directory '#{source}'"))
    end
  end

  def check_overwrite_dir_with_file(source, destination)
    if !File.directory?(source) && File.directory?(destination)
      if @no_target_directory
        ErrorHandler.handle(ArgumentError.new("cannot overwrite directory '#{destination}' with non-directory"))
      end
    end
  end

  def check_target_on_some_rewrite(sources, destination)
    if sources.size > 1 && !File.directory?(destination)
      ErrorHandler.handle(ArgumentError.new("target '#{destination}' is not a directory"))
    end
  end

  def get_full_destination(destination, source)
    destination + (File.directory?(destination) ? '/' + File.basename(source) : '')
  end

  def pattern_process(source, destination)
    if File.directory?(source)
      if rec_dir_move(source, source, destination) && Dir["#{Dir[source].last}/*"].empty?
        FileUtils.remove_dir(Dir[source].last, verbose: @verbose, force: (@mode == :force))
      end
    else
      if File.fnmatch(@pattern, File.basename(source), File::FNM_DOTMATCH)
        file_move(source, destination)
      end
    end
  end

  def interactive(destination)
    print "overwrite '#{destination}'?"
    begin
      answer = $stdin.gets.chomp.downcase
    rescue Exception => ex
      ErrorHandler.handle(ex)
    end
    answer != 'y' && answer != 'yes'
  end

  def file_move(source, destination)
    unless @backup.nil? || @backup == 'none' || @backup == 'off'
      new_name = set_backup_name(destination) #ACHTUNG!
      FileUtils.mv(destination, new_name, verbose: @verbose, force: (@mode == :force)) unless new_name.nil?
    end
    FileUtils.mv(source, destination, verbose: @verbose, force: (@mode == :force))
  end

  def set_backup_name(old_name)
    new_name = old_name
    if @backup == 'numbered' || @backup == 't'
      max_backup_num = search_max_existing_numbered(old_name)
      new_name = "#{old_name}.#{@suffix+(max_backup_num.to_i+1).to_s + @suffix}"
    elsif @backup == 'existing' || @backup == 'nil'
      max_backup_num = search_max_existing_numbered(old_name)
      new_name = max_backup_num.nil? ? "#{old_name + @suffix}" : "#{old_name}.#{@suffix+(max_backup_num.to_i+1).to_s + @suffix}"
    elsif @backup == 'simple' || @backup == 'never'
      new_name = "#{old_name + @suffix}"
    else
      ErrorHandler.handle(ArgumentError.new("incorrect backup type: #{backup}"))
    end
    new_name
  end

  def search_max_existing_numbered(name)
    Dir["#{name}.#{@suffix}[0-9]{1,}#{@suffix}"]
    .map { |x| x.scan(/#{Regexp.escape(name)}.#{Regexp.escape(@suffix)}(\d+)#{Regexp.escape(@suffix)}/)[0][0].to_i }
    .max
  end

  def rec_dir_move(path, source_arg, destination_arg)
    result = false
    Dir["#{path}/**"].each do |entry|
      if File.directory?(entry)
        rec_dir_move_deep_dir(entry, source_arg, destination_arg)
      elsif File.fnmatch(@pattern,  File.basename(entry), File::FNM_DOTMATCH)
        result = rec_dir_file_move(entry, source_arg, destination_arg)
      end
    end
    result
  end

  def rec_dir_file_move(entry, source_arg, destination_arg)
    destination = entry.sub(source_arg, destination_arg)
    destination_dir = File.dirname(destination)
    unless File.exist?(destination_dir)
      begin
        FileUtils.mkdir_p(destination_dir, verbose: @verbose)
      rescue Exception => ex
        ErrorHandler.handle(ex)
      end
    end
    begin
      file_move(entry, destination)
    rescue Exception => ex
      ErrorHandler.handle(ex)
    end
    true
  end

  def rec_dir_move_deep_dir(entry, source, destination)
    temp_result =  rec_dir_move(entry, source, destination)
    temp2_result = Dir["#{entry}/*"].empty?
    if temp_result && temp2_result
      begin
        FileUtils.remove_dir(entry, verbose: @verbose, force: (@mode == :force))
      rescue Exception => ex
        ErrorHandler.handle(ex)
      end
    end
  end
end
