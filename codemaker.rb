module MasterMind
    class CodeMaker
        attr_reader :code, :code_hash
        def initialize(colors = nil)
            @code = Code.new(colors)
            @code_hash = @code.generate_color_hash
        end 

        def generate_key(code_in)
            code_in_hash = code_in.generate_color_hash
            whites_hash = Hash.new(0)
            reds_hash = Hash.new(0)
            colors_out = []
            # Calculate the number of white pegs we would have
            code_in_hash.each do |key, value|
                if(self.code_hash[key] == 0)
                    next
                else
                    whites_hash[key] = (self.code_hash[key] > value) ? value : self.code_hash[key]
                end
            end
            # Calculate the number of red pegs we would have
            for i in 0..3 do
                if(code_in.pegs[i].color == self.code.pegs[i].color)
                    reds_hash[code_in.pegs[i].color] += 1
                end
            end
            # Subract the whites by the reds
            whites_hash.each_key do |key|
                if(reds_hash[key] > 0)
                    whites_hash[key] -= reds_hash[key]
                end
            end
            # Combine into a code, filling in 0's with "blanks"
            whites_hash.each_value do |value|
                value.times do
                    colors_out.push(CORRECT_COLOR)
                end
            end
            reds_hash.each_value do |value|
                value.times do
                    colors_out.push(CORRECT_POS)
                end
            end
            until colors_out.length == 4
                colors_out.push(WRONG_COLOR)
            end
            return Code.new(colors_out).randomize_self!
        end
    end
end