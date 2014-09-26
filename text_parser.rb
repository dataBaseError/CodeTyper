class TextParser

    def initialize(char_per_key=3, auto_write=false)
        @char_per_key = char_per_key
        @auto_write = auto_write
    end


    def parseText(text)

        index = 0
        text.each_char do |char|

            if !@auto_write
                if index % @char_per_key == 0
                    input = STDIN.getch

                    yield input
                    index = 0
                end
                index+=1
            else
                # Use sleeper
                begin
                    sleep(1.0/20.0)
                rescue Exception => e
                    exit(1)
                end
            end

            print char
            
        end
    end
end