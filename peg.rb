module MasterMind
    class Peg
        attr_reader :color
        COLORS = ["red", "black", "white", "blue", "green", "yellow", "blank"]
        def initialize(color = "blank")
            @color = color
        end

        def color=(value)
            if(COLORS.include?(value))
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