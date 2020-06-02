require_relative 'mastermind'
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
            @guess = Code.new
            @available_colors = 6
            @guess_count = 0
        end

        #temporary place holder
        def generate_guess
            @guess_count += 1
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
            valid_colors_used = count_valids
            reds = (key_hash[CORRECT_POS] == nil) ? 0 : key_hash[CORRECT_POS]
            whites = (key_hash[CORRECT_COLOR] == nil) ? 0 : key_hash[CORRECT_COLOR]
            @guess.pegs.each_with_index do |peg, index|
                amount_used = guess_hash[peg.color]
                if(@colors[peg.color] != nil)
                    @colors[peg.color].anaylze_data(whites, reds, index, amount_used, valid_colors_used)
                    if(@colors[peg.color].exist == 0)
                        @colors[peg.color] = nil
                    end
                end
            end
        end

        private

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