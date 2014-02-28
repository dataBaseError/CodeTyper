#!/usr/bin/ruby
require 'io/console'
require_relative 'utility'

$values = ""

def parseDirectory(path)

    if Dir.exist?(path)
        file_names = Dir.entries(path)
    else
        Kernel::abort("Invalid folder")
    end

    file_names.each do |name|

        if !File.directory?("#{path}#{name}")

            # Check if the its a hidden file 
            if !$hidden_files || name[0] != "."
                parseFile("#{path}#{name}")
            end
            
        elsif name != "." || name != ".."
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

    if input == "e" && $values == ""
        $values += input
    elsif input == "x" && $values == "e"
        $values += input
    elsif input == "i" && $values == "ex"
        $values += input
    elsif input == "t" && $values == "exi"
        $values += input
    elsif input == "\r" && $values == "exit"
        $values = ""
        exitValue = true
    elsif input == "\u0003"
        exitValue = true
    else
        $values = ""
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

#system "clear"
root_folder = checkForwardSlash(root_folder)
parseDirectory(root_folder)