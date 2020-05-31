module MasterMind
    class CodeBreaker
        attr_reader :colors, :guess
        def initialize
            @colors = {COLORS[0] => 0,
                       COLORS[1] => 0,
                       COLORS[2] => 0,
                       COLORS[3] => 0,
                       COLORS[4] => 0,
                       COLORS[5] => 0}
            @guess = Code.new
            @available_colors = 6
        end

        #temporary place holder
        def generate_guess
            @guess = Code.new
        end

        def update_available_colors
            new_amount = 0
            @colors.each do |key, value|
                if value != nil
                    new_amount += 1
                end
            end
            @available_colors = new_amount
        end

        def anaylze_key(key)
            key_hash = key.generate_color_hash
            guess_hash = self.guess.generate_color_hash
            # Base cases: All blank, One White, One Red
            # All Blank = All of the colors in @colors should equal nil, none exist
            # Only White = All of the colors have a likely chance of existing however none are in the correct position
            # Only Red = All colors have a likely chance of existing and a likely chance of being in the correct position
            pos_likely = key_hash[CORRECT_POS]
            pos_unlikely = (key_hash[CORRECT_POS] > 0) ? 0 : key_hash[CORRECT_COLOR]
            ex_likely = key_hash[CORRECT_POS] + key_hash[CORRECT_COLOR]
            remove_location = false
            # Loop through each color of the code used
            @guess.pegs.each_with_index do |peg, index|
                # The base case where all of the keys are blank
                if(key_hash[WRONG_COLOR] == 4)
                    @colors[peg.color] = nil
                    self.update_available_colors
                    next
                elsif(key_hash[CORRECT_POS] == 0) # Handling for only white
                    remove_location = true
                #elsif(key_hash[CORRECT_COLOR] == 0) # Handling for only red

                end
                if(@colors[peg.color] == nil) # temp handling
                    next
                elsif(@colors[peg.color] == 0)
                    amount = (ex_likely >= guess_hash[peg.color]) ? guess_hash[peg.color] : ex_likely
                    color_prob = ColorProb.new(amount)
                    color_prob.adjust_in_code(@available_colors, ex_likely)
                    color_prob.adjust_location_data(index, pos_likely, pos_unlikely, remove_location)
                    @colors[peg.color] = color_prob
                else
                    if(ex_likely >= guess_hash[peg.color] && guess_hash[peg.color] > @colors[peg.color].count)
                        @colors[peg.color].adjust_count(guess_hash[peg.color])
                    end
                    @colors[peg.color].adjust_in_code(@available_colors, ex_likely)
                    @colors[peg.color].adjust_location_data(index, pos_likely, pos_unlikely, remove_location)
                end
            end
        end
    end
end