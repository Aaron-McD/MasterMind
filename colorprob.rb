require_relative 'mastermind'

# Add the Functionality to keep track of the number of the color

module MasterMind
    # This will be the data structure that contains the probability out of 100 for each location and whether it exists
    class ColorProb
        attr_reader :locations, :exist, :count
        BASE_PROB = 0.1 # This is the base probability that changes what we know about location data
        def initialize(count = 1, starting_prob = 16.67)
            @locations = Array.new(4, 0)
            @exist = (starting_prob * count).round(2)
            @available_locations = 4
            @max_count = 4
            @max_percentage = count * 100
            @count = count
            @base_location_prob = ((count * 100 )/ 4).round(2)
            reset_locations
        end

        # Things to consider and handle:
        def anaylze_data(white_pegs, red_pegs, index, amount_guessed, valid_colors) # The main function that will determine all of the data from helper functions
            # white_pegs and red_pegs are the respective pegs for key of the guess
            # index is the colors location in this guess
            # amount_guessed is the amount of that color in this guess
            # valid_colors is the amount of colors that should even be considered in this guess
            chance = self.anaylze_valid_colors(amount_guessed, valid_colors) # Tells us how likely any random peg would be to hit this color
            chance *= (white_pegs + red_pegs) # Tells us based on the number of pegs how likely this color is in the code
            if(chance == 0) # Base case for no pegs
                @exist = 0
                @max_count = 0
                adjust_count(0)
                reset_locations(nil)
                return false
            elsif(chance > @max_percentage) # Case that there is a lot of pegs and multiple of this color in the guess
                @exist = 100
                @count_probability = chance
                adjust_count(@count + 1)
                disperse_percent(100)
            elsif(@exist < 100)
                @exist = chance
                @count_probability = chance
            end

            if(red_pegs == 0) # Case for all white pegs, we know that the color can't be here
                remove_location(index)
            else
                if(red_pegs > white_pegs)
                    diff = red_pegs - white_pegs
                    if(diff < 4)
                        delta_percent = (((diff * BASE_PROB) + 1) * @locations[index]) - @locations[index]
                        if(@available_locations != 1)
                            disperse_percent_from(index, delta_percent * -1)
                        end
                    else
                        delta_percent = 100 - @locations[index]
                        disperse_percent_from(index, delta_percent * -1) 
                    end
                elsif(red_pegs < white_pegs)
                    diff = white_pegs - red_pegs
                    delta_percent = @locations[index] - ((1 - (diff * BASE_PROB)) * @locations[index])
                    if(@available_locations != 1)
                        disperse_percent_from(index, diff)
                    end
                end
            end
        end

        def anaylze_valid_colors(amount_guessed, valid_colors)
            base_percents = [25, 33.34, 50, 100, 0]
            return amount_guessed * base_percents[4 - valid_colors]
        end

        private

        def check_percentages
            over_100 = nil
            under_0 = nil
            delta_percent = 0.1
            for i in 0..3
                if(@locations[i] == nil)
                    next
                else
                    if(@locations[i] > 100)
                        over_100 = i
                    elsif(@locations[i] < 0)
                        under_0 = i
                    end
                end
            end
            if(over_100 != nil)
                diff = @locations[over_100] - 100
                disperse_percent_from(over_100, diff)
            elsif(under_0 != nil)
                diff = @locations[under_0] * -1
                disperse_percent_from(under_0, diff)
            end
            for i in 0..3
                if(@locations[i] == nil)
                    next
                else
                    if(@locations[i] + delta_percent >= 100)
                        @locations[i] = 100
                    elsif(@locations[i] - delta_percent <= 0)
                        @locations[i] = 0
                    end
                end
            end
        end

        def disperse_percent_from(index, percent)
            add = percent / (@available_locations - 1)
            for i in 0..3 do
                if(index == i)
                    @locations[i] = (@locations[i] - percent).round(2)
                elsif(@locations[i] != nil)
                    @locations[i] = (@locations[i] + add).round(2)
                end
            end
            check_percentages
        end

        def disperse_percent(percent)
            add = percent / @available_locations
            for i in 0..3 do
                if(@locations[i] != nil)
                    @locations[i] = (@locations[i] + add).round(2)
                end
            end
        end

        def remove_location(index)
            percentage = @locations[index]
            @locations[index] = nil
            @available_locations -= 1
            if(@available_locations == 0)
                @max_count = 0
                adjust_count(0)
                return false
            elsif(@available_locations < @count)
                @max_count = @available_locations
                adjust_count(@available_locations)
            elsif(@available_locations == count)
                for i in 0..3 do
                    if(@locations[i] != nil)
                        @locations[i] = 100
                    end
                end
            else
                add = percentage / @available_locations
                for i in 0..3 do
                    if(@locations[i] != nil)
                        @locations[i] = (@locations[i] + add).round(2)
                    end
                end
            end
        end

        def adjust_count(new_amount)
            @count = new_amount
            reset_max_percentage
            reset_base_location_prob
        end

        def reset_max_percentage
            @max_percentage = count * 100
        end

        def reset_base_location_prob
            @base_location_prob = (@max_percentage/ 4).round(2)
        end

        def reset_locations(new_percent = 0) # Resets each location prob to be relative to the @count
            for i in 0..3 do
                if new_percent == 0
                    @locations[i] = @base_location_prob
                else
                    @locations[i] = new_percent
                end
            end
        end
    end
end