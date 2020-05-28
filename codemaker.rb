require_relative 'peg'
include MasterMind

module MasterMind
    class CodeMaker
        attr_reader :code
        COLORS = ["red", "black", "white", "blue", "green", "yellow"]
        CORRECT_POS = "red"
        CORRECT_COLOR = "white"
        WRONG_COLOR = "blank"
        def initialize(colors = nil)
            if(colors == nil)
                @code = self.generate_code
            elsif(colors.length == 4)
                @code = []
                colors.each do |color|
                    @code.push(Peg.new(color))
                end
            else
                raise ArgumentError
            end
        end
        
        def generate_code
            new_code = []
            srand(Time.new.to_i)
            4.times do 
                index = rand(6)
                new_code.push(Peg.new(COLORS[index]))
            end
            return new_code
        end

        def generate_key(code_in)
            key = []
            possible_color = ''
            possible_pos = 0
            # We only want to count each peg_in once so we will skip pegs we have counted
            skip_indexes = []
            # If the code_in contains two of the same color but the code only contains one then the key will return one peg to correspond with it
            # In this scenario if one of the two colors fall in the correct position the key will show red instead of white
            self.code.each_with_index do |peg, i|
                red_found = false
                white_found = false
                code_in.each_with_index do |peg_in, j|
                    if(skip_indexes.include?(j))
                        next
                    end
                    if(peg.color == peg_in.color)
                        if(i == j)
                            key.push(Peg.new(CORRECT_POS))
                            skip_indexes.push(j)
                            white_found = false
                            red_found = true
                            break
                        else
                            # This is left for determining, if a red key is concluded then that will take precedence
                            white_found = true
                            possible_color = CORRECT_COLOR
                            possible_pos = j
                        end
                    end
                end
                if(white_found)
                    key.push(Peg.new(possible_color))
                    skip_indexes.push(possible_pos)
                elsif(!red_found)
                    key.push(Peg.new(WRONG_COLOR))
                end
            end
            return key
        end
    end
end