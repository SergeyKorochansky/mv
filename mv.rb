#!/usr/bin/ruby
require './app_parser.rb'
require './files_move.rb'
require './information.rb'

default_options = AppParser.env(ENV)
options = AppParser.parse(default_options, ARGV)

if options[:help]
  Information.help
  exit 0
end
if options[:version]
  Information.version
  exit 0
end

mode = :force
mode = :no_clobber if options[:no_clobber]
mode = :interactive if options[:interactive]
mode = :force if options[:force]

arguments = ARGV.dup
if options[:target_directory]
  ErrorHandler.handle(ArgumentError.new('less than one source arguments')) if ARGV.size < 1
  destination_arg = options[:target_directory]
  source_arg = arguments
elsif options[:no_target_directory]
  ErrorHandler.handle(ArgumentError.new('more than two arguments')) if ARGV.size > 2
  destination_arg = arguments.last.dup
  source_arg = arguments[0..-2]
else
  ErrorHandler.handle(ArgumentError.new('less than 2 arguments')) if ARGV.size < 2
  destination_arg = arguments.last.dup
  source_arg = arguments[0..-2]
end
source_arg.sub!(/(\/)+$/, '') if options[:strip_trailing_slashes]

files_move = FilesMove.new(options[:pattern], options[:verbose], options[:update], options[:no_target_directory], mode,
                           options[:backup], options[:suffix])
files_move.move_files(source_arg, destination_arg)
