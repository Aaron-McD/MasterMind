require_relative 'peg'

module MasterMind
    class Code
        attr_reader :pegs
        COLORS = ["red", "black", "white", "blue", "green", "yellow"]
        def initialize(colors = nil)
            if(colors == nil)
                @pegs = self.generate_code
            elsif(colors.length == 4)
                @pegs = []
                colors.each do |color|
                    @pegs.push(Peg.new(color))
                end
            else
                raise ArgumentError
            end
        end

        def generate_code
            new_code = []
            #srand(Time.new.to_i)
            4.times do 
                index = rand(6)
                new_code.push(Peg.new(COLORS[index]))
            end
            return new_code
        end

        def randomize_self!
            @pegs = @pegs.shuffle
            return self
        end

        def to_s
            string_out = "[#{self.pegs[0]}"
            for i in 1..3 do
                string_out += ", #{self.pegs[i]}"
            end
            string_out += "]"
            return string_out
        end
    end
end