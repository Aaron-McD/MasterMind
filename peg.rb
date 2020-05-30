module MasterMind
    class Peg
        attr_reader :color
        valid_colors = COLORS
        valid_colors.push(WRONG_COLOR)
        def initialize(color = WRONG_COLOR)
            @color = color
        end

        def color=(value)
            if(VALID_COLORS.include?(value))
                @color = value
            else
                raise NameError
            end
        end

        def to_s
            return self.color
        end
    end
end