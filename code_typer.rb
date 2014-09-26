#!/usr/bin/ruby
require 'io/console'
require_relative 'utility'
require_relative 'valid_files'
require_relative 'text_parser'

class CodeTyper

    # Input exit keyword
    EXIT_KEY_WORD = "exit\r"

    # Control-C input character
    ESCAPE_CHAR = "\u0003"

    def initialize(hidden_files=false, char_per_key=3, auto_write=false)
        @text_parser = TextParser.new(char_per_key)
        @auto_write = auto_write
        @hidden_files = hidden_files
        @values = Array.new
    end

    def parseDirectory(path)

        if Dir.exist?(path)
            file_names = Dir.entries(path)
        else
            raise "Invalid folder"
        end

        path = checkForwardSlash(path)

        file_names.each do |name|

            if !File.directory?("#{path}#{name}")

                # Check if the its a hidden file 
                if !@hidden_files && name[0] != "."

                    if FilesValidator::validate(name) 
                        parseFile("#{path}#{name}")
                    end
                end
                
            elsif name != "." && name != ".."
                parseDirectory("#{path}#{name}")
            end
        end
    end

    def parseFile(path)

        # Actually read the file contents for each key stroke
        if File.size?(path) != nil
            File.open(path, "r").each_line do |line|

                block = ""

                if !@auto_write
                    block = " { |char| checkExit(char) }"
                end

                # Define a block given input args
                eval "@text_parser.parseText(line)#{block}" 
            end

            # Space between the files
            print "\n\n"
        end
    end

    def checkExit(input)

        if @values.size == EXIT_KEY_WORD.size
            @values.shift
        end
        
        @values << input

        if @values.join == EXIT_KEY_WORD || input == ESCAPE_CHAR
            system "clear"

            puts "Access Granted"
            Kernel::exit()
        end
    end
end

root_folder = "./"
hidden_files = false
char_per_key = 3
auto_writer = true

if ARGV.size >= 1
    root_folder = ARGV[0]

    if ARGV.size >= 2 
        hidden_files = ARGV[1]

        if ARGV.size == 3
            char_per_key = ARGV[2].to_i      
        end
    end
end

system "clear"

hacker = CodeTyper.new(hidden_files, char_per_key, false)
hacker.parseDirectory(checkForwardSlash(root_folder))
