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
            if(@locations[index] != nil)
                chance = self.anaylze_valid_colors(amount_guessed, valid_colors, white_pegs + red_pegs) # Tells us how likely any random peg would be to hit this color
                if(chance == 0) # Base case for no pegs
                    @exist = 0
                    @max_count = 0
                    adjust_count(0)
                    reset_locations(nil)
                    return false
                elsif(chance > @max_percentage) # Case that there is a lot of pegs and multiple of this color in the guess
                    @exist = 100
                    adjust_count(@count + 1)
                    disperse_percent(100)
                elsif(@exist < 100)
                    @exist = chance
                end

                if(red_pegs == 0) # Case for all white pegs, we know that the color can't be here
                    remove_location(index)
                else
                    if(red_pegs > white_pegs)
                        diff = red_pegs - white_pegs
                        if(diff < valid_colors)
                            delta_percent = (((diff * BASE_PROB) + 1) * @locations[index]) - @locations[index]
                            if(@available_locations != 1)
                                disperse_percent_from(index, delta_percent * -1)
                            end
                        else
                            # case where the number of red pegs equals the number of valid colors
                            # we know without a doubt that this color is in there and that it must be in this location
                            @locations[index] = 100
                            temp_avail = 0 # The amount of locations that are available besides the 100% locations
                            total_others = 0 # Total of those other locations
                            for i in 0..3
                                if(@locations[i] == nil || @locations[i] == 100)
                                    next
                                else
                                    temp_avail += 1
                                    total_others += @locations[i]
                                end
                            end
                            if total_others > 100
                                total_others = (total_others / 100).floor * 100
                                others_percent = total_others / temp_avail
                            else
                                others_percent = 0
                            end
                            for i in 0..3
                                if(@locations[i] == nil || @locations[i] == 100)
                                    next
                                else
                                    @locations[i] = others_percent.round(2)
                                end
                            end
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
        end

        def anaylze_valid_colors(amount_guessed, valid_colors, pegs) # We will take into consideration that each peg has a random chance of belonging to any valid color
            base_percents = [25, 33.34, 50, 100, 0]
            base = base_percents[4 - valid_colors] # This is our starting base that any color could belong to a peg
            if pegs == 0
                return 0
            end
            prob_of_not_being_picked = (100 - (amount_guessed * base)) / 100.0 # This will be our starting probability of the color NOT being selected by a peg
            pegs -= 1 # We assume that for each peg considered it can only associate with one color
            valid_colors -= 1 # Therefore the number of pegs to consider and the number of possible options to consider go down
            while pegs > 0
                base = base_percents[4 - valid_colors]
                next_prob = (100 - (amount_guessed * base)) / 100.0
                prob_of_not_being_picked *= next_prob
                pegs -= 1
                valid_colors -= 1
            end
            prob_of_not_being_picked *= 100
            return (100 - prob_of_not_being_picked).round(2) # Finally we return the probability that the color would have been chosen
        end

        private

        def check_percentages
            over_100 = nil
            under_0 = nil
            delta_percent = 0.1
            dispersed = false
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
                remainder = @locations[over_100] - 100
                @locations[over_100] = 100
                temp_avail = 0
                for i in 0..3
                    if(@locations[i] != nil && @locations[i] != 100)
                        temp_avail += 1
                    end
                end
                if temp_avail != 0
                    dispersed = true
                    percent = remainder / temp_avail.to_f
                    for i in 0..3
                        if(@locations[i] != nil && @locations[i] != 100)
                            @locations[i] = (@locations[i] + percent).round(2)
                        end
                    end
                end    
            end
            if(under_0 != nil)
                remainder = @locations[under_0] * -1
                @locations[under_0] = 0
                temp_avail = 0
                for i in 0..3
                    if(@locations[i] != nil && @locations[i] != 100 && @locations[i] != 0)
                        temp_avail += 1
                    end
                end
                if temp_avail != 0
                    dispersed = true
                    percent = remainder / temp_avail.to_f
                    for i in 0..3
                        if(@locations[i] != nil && @locations[i] != 100 && @locations[i] != 0)
                            @locations[i] = (@locations[i] - percent).round(2)
                        end
                    end
                end  
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
            if dispersed
                check_percentages
            end
        end

        def disperse_percent_from(index, percent)
            add = percent.to_f / (@available_locations - 1)
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
            add = percent.to_f / @available_locations
            for i in 0..3 do
                if(@locations[i] != nil)
                    @locations[i] = (@locations[i] + add).round(2)
                end
            end
            check_percentages
        end

        def remove_location(index)
            percentage = @locations[index]
            @locations[index] = nil
            @available_locations -= 1
            if(@available_locations == 0)
                @max_count = 0
                @exist = 0
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
                disperse_percent(percentage)
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