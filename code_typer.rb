#!/usr/bin/ruby
require 'io/console'
require_relative 'utility'
require_relative 'valid_files'

$values = Array.new

EXIT_KEY_WORD = "exit\r"

def parseDirectory(path)

    if Dir.exist?(path)
        file_names = Dir.entries(path)
    else
        Kernel::abort("Invalid folder")
    end

    path = checkForwardSlash(path)

    file_names.each do |name|

        if !File.directory?("#{path}#{name}")

            # Check if the its a hidden file 
            if !$hidden_files && name[0] != "."

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

            index = 0

            line.each_char do |char|

                if index % $amount == 0
                    input = STDIN.getch

                    checkExit(input)
                    index = 0
                end

                print char

                index+=1
            end
        end
        print "\n\n"
    end
end

def checkExit(input)

    exitValue = false

    if $values.size == EXIT_KEY_WORD.size
        $values.shift
    end
    
    $values << input

    if $values.join == EXIT_KEY_WORD
        exitValue = true
    elsif input == "\u0003"
        exitValue = true
    end

    if exitValue
        system "clear"

        puts "Access Granted"
        Kernel::exit()
    end
end

root_folder = "./"
$hidden_files = false
$amount = 3

if ARGV.size >= 1
    root_folder = ARGV[0]

    if ARGV.size >= 2 
        $hidden_files = ARGV[1]

        if ARGV.size == 3
            $amount = ARGV[2].to_i      
        end
    end
end

system "clear"
root_folder = checkForwardSlash(root_folder)
parseDirectory(root_folder)
