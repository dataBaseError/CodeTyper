class TextParser

    def initialize(char_per_key=3)
        @char_per_key = char_per_key
    end


    def parseText(text)

        index = 0
        text.each_char do |char|

            if block_given?
                if index % @char_per_key == 0
                    input = STDIN.getch

                    yield input
                    index = 0
                end
                index+=1
            else
                # Use sleeper   
                begin
                    sleep(10.0/60.0)
                rescue Interrupt => e
                    system "clear"
                    Kernel::exit()  
                end
            end

            print char
            
        end
    end
end