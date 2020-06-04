module MasterMind
    class CodeBreaker
        attr_reader :colors, :guess
        def initialize
            @colors = {COLORS[0] => ColorProb.new,
                       COLORS[1] => ColorProb.new,
                       COLORS[2] => ColorProb.new,
                       COLORS[3] => ColorProb.new,
                       COLORS[4] => ColorProb.new,
                       COLORS[5] => ColorProb.new}
            @guess = nil
            @available_colors = self.update_available_colors
            @guess_count = 0
            @guesses_made = []
            @wrong_colors = []
        end

        def generate_guess
            @guess_count += 1
            if(@guess_count == 1)
                color = @available_colors[rand(@available_colors.length)]
                code_colors = []
                4.times do
                    code_colors.push(color)
                end
            elsif(@guess_count == TURNS)
                code_colors = generate_last_guess
            else
                code_colors = []
                if(@guess_count % 2 == 0)
                    code_colors = generate_smart_guess
                else
                    code_colors = generate_normal_guess
                end
            end
            if(@guesses_made.include?(code_colors))
                return self.generate_guess
            else
                @guesses_made.push(code_colors)
                @guess = Code.new(code_colors)
                return @guess
            end
        end

        def update_available_colors
            new_colors = []
            @colors.each do |key, value|
                if value != nil
                    new_colors.push(key)
                end
            end
            return new_colors
        end

        def anaylze_key(key)
            key_hash = key.generate_color_hash
            guess_hash = self.guess.generate_color_hash
            valid_colors_used = count_valids
            reds = (key_hash[CORRECT_POS] == nil) ? 0 : key_hash[CORRECT_POS]
            whites = (key_hash[CORRECT_COLOR] == nil) ? 0 : key_hash[CORRECT_COLOR]
            @guess.pegs.each_with_index do |peg, index|
                amount_used = guess_hash[peg.color]
                if(@colors[peg.color] != nil)
                    @colors[peg.color].anaylze_data(whites, reds, index, amount_used, valid_colors_used)
                    if(@colors[peg.color].exist == 0)
                        @wrong_colors.push(peg.color)
                        @colors[peg.color] = nil
                    end
                end
            end
            @available_colors = self.update_available_colors
        end

        private

        def generate_smart_guess
            code_colors = Array.new(4, WRONG_COLOR)
            if(@wrong_colors.length >= 1)
                2.times do
                    code_colors[rand(4)] = @wrong_colors[rand(@wrong_colors.length)]
                end
                while code_colors.include?(WRONG_COLOR)
                    index = code_colors.index(WRONG_COLOR)
                    code_colors[index] = @available_colors[rand(@available_colors.length)]
                end
                return code_colors
            else
                return generate_normal_guess
            end
        end

        def generate_normal_guess
            code_colors = []
            4.times do
                code_colors.push(@available_colors[rand(@available_colors.length)])
            end
            return code_colors
        end

        def generate_last_guess
            code_colors = Array.new(4, WRONG_COLOR)
            most_probable_colors = @available_colors.sort_by { |color| @colors[color].exist }.reverse
            colors_hash = Hash.new(0)
            for i in 0..3
                most_probable_colors.each do |color|
                    if(colors_hash[color] == @colors[color].count)
                        next
                    else
                        if(@colors[color].most_probable_indicies.include?(i) && code_colors[i] == WRONG_COLOR)
                            code_colors[i] = color
                        end
                    end
                end
            end
            while code_colors.include?(WRONG_COLOR)
                index = code_colors.index(WRONG_COLOR)
                code_colors[index] = most_probable_colors[rand(most_probable_colors.length)]
            end
            return code_colors
        end

        def count_valids
            valids = 0
            @guess.pegs.each do |peg|
                if(@colors[peg.color] != nil)
                    valids += 1
                end
            end
            return valids
        end
    end
end