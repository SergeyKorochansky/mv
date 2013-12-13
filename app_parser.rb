require 'optparse'

class AppParser
  def self.parse(options, args)
    option_parser = OptionParser.new do |opts|
      opts.on('-b', '--backup[=CONTROL]', 'make a backup of each existing destination file') { |control| options[:backup] = control.nil? ? true : control }
      opts.on('-f', '--force', 'do not prompt before overwriting') { options[:force] = true }
      opts.on('-i', '--interactive', 'prompt before overwrite') { options[:interactive] = true }
      opts.on('-n', '--no-clobber', 'do not overwrite an existing file') { options[:no_clobber] = true }
      opts.on('--strip-trailing-slashes', 'remove any trailing slashes from each SOURCE argument') { options[:strip_trailing_slashes] = true }
      opts.on('-S','--suffix=SUFFIX' 'override the usual backup suffix') { |suffix| options[:suffix] = suffix }
      opts.on('-t', '--target-directory=DIRECTORY', 'move all SOURCE arguments into DIRECTORY') { |dir| options[:target_directory] = dir }
      opts.on('-T', '--no-target-directory', 'treat DEST as a normal file') { options[:no_target_directory] = true }
      opts.on('-u', '--update', 'move only when the SOURCE file is newer than the ',
              'destination file or when the destination file is missing') { options[:update] = true }
      opts.on('-p', '--pattern=PATTERN', 'move only matched files') { |pattern| options[:pattern] = pattern }
      opts.on('-v', '--verbose', 'explain what is being done') { options[:verbose] = true }
      opts.on('-h', '--help', 'display this help and exit') { options[:help] = true }
      opts.on('--version', 'output version information and exit') { options[:version] = true }
    end
    option_parser.parse!(args)
    options
  end

  def self.env(env)
    options = {
        no_clobber: env['PROCESSING_MODE'] == 'NO_CLOBBER',
        interactive: env['PROCESSING_MODE'] == 'INTERACTIVE',
        force: env['PROCESSING_MODE'] == 'FORCE',
        backup: env['CONTROL'],
        strip_trailing_slashes: env['STRIP_TRAILING_SLASHES'] == 'TRUE',
        suffix: env['SUFFIX'].nil? ? '~' : env['SUFFIX'],
        target_directory: env['TARGET_DIRECTORY'],
        no_target_directory: env['NO_TARGET_DIRECTORY'] == 'TRUE',
        update: env['UPDATE'] == 'TRUE',
        pattern: env['PATTERN'].nil? ? '**' : env['PATTERN'],
        verbose: env['VERBOSE_MODE'] == 'TRUE',
        help: false,
        version: false
    }
    options
  end
end