require_relative 'code'

module MasterMind
    class CodeMaker
        attr_reader :code
        CORRECT_POS = "red"
        CORRECT_COLOR = "white"
        WRONG_COLOR = "blank"
        def initialize(colors = nil)
            @code = Code.new(colors)
        end

        def generate_color_hash(code)
            return code.pegs.reduce(Hash.new(0)) do |colors, peg|
                colors[peg.color] += 1
                colors
            end
        end

=begin  
        def generate_key(code_in)
            key = []
            possible_color = ''
            possible_pos = 0
            # We only want to count each peg_in once so we will skip pegs we have counted
            skip_indexes = []
            # If the code_in contains two of the same color but the code only contains one then the key will return one peg to correspond with it
            # In this scenario if one of the two colors fall in the correct position the key will show red instead of white
            self.code.pegs.each_with_index do |peg, i|
                red_found = false
                white_found = false
                code_in.pegs.each_with_index do |peg_in, j|
                    if(skip_indexes.include?(j))
                        next
                    end
                    if(peg.color == peg_in.color)
                        if(i == j)
                            key.push(CORRECT_POS)
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
                    key.push(possible_color)
                    skip_indexes.push(possible_pos)
                elsif(!red_found)
                    key.push(WRONG_COLOR)
                end
            end
            return Code.new(key).randomize_self!
        end

=end
    end
end