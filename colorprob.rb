require_relative 'mastermind'

# Add the Functionality to keep track of the number of the color

module MasterMind
    # This will be the data structure that contains the probability out of 100 for each location and whether it exists
    class ColorProb
        attr_reader :locations, :in_code, :exist, :count
        BASE_PROB = 0.1 # This is the base probability that likely or unlikely will be multiplied by to recalculate different probabilities
        def initialize(count = 1, starting_prob = 16.67)
            @locations = Array.new(4, 0)
            @in_code = (starting_prob * count).round(2)
            @available_locations = 4
            @count = count
            @base_location_prob = ((count * 100 )/ 4).round(2)
            self.reset_locations
        end

        def adjust_in_code(num, likely = 0)
            if @in_code == 0
                return false
            elsif likely > 0
                new_prob = (likely * BASE_PROB) * @in_code
                @in_code = (new_prob + @in_code).round(2)
                if(@in_code > (100 * @count))
                    @in_code = 100 * @count
                end
            else
                @in_code = (100.0 / num).round(2)
            end
        end

        def adjust_count(count)
            @count = count
            @in_code = (16.67 * count).round(2)
            if(@count > 0)
                self.reset_locations
            else
                @in_code = 0
            end
        end

        def reset_locations
            new_prob = (100 * @count) / @available_locations
            @base_location_prob = new_prob
            for i in 0..3 do
                if @locations[i] != nil
                    @locations[i] = new_prob.round(2)
                end
            end
        end

        def adjust_location_data(index, likely = 1, unlikely = 0, remove = false)
            if(@locations[index] == nil)
                return nil
            end
            if remove
                @available_locations -= 1
                new_prob = @locations[index] / @available_locations
                @locations[index] = nil
                i = 0
                if(@available_locations == 0)
                    self.adjust_count(@count - 1)
                else
                    while i < 4 do
                        if locations[i] != nil
                            locations[i] = (locations[i] + new_prob).round(2)
                        end
                        i += 1
                    end
                end
            else
                if(@available_locations == @count)
                    if(likely > 0)
                        @locations[index] = 100
                    else
                        self.adjust_location_data(index, 0, 0, true)
                        self.adjust_count(@count - 1)
                    end
                else
                    if(likely > 0)
                        new_prob = (1 + (likely * BASE_PROB))
                    else
                        new_prob = (1 - (unlikely * BASE_PROB))
                    end
                    new_prob = new_prob * @locations[index]
                    diff = new_prob - @locations[index]
                    i = 0
                    while i < 4 do
                        if index == i
                            @locations[i] = (@locations[i] + diff).round(2)
                        elsif @locations[i] != nil
                            @locations[i] = (@locations[i] - (diff / (@available_locations - 1))).round(2)
                        end
                        if(@locations[i] != nil)
                            if(@locations[i] < 1)
                                self.adjust_location_data(i, 0, 0, true)
                            end
                        end
                        i += 1
                    end
                end
            end
            anaylze_data
        end

        private

        def anaylze_data
            if @count > 2
                lower = 0
                for i in 0..3 do
                    if @locations[i] == nil
                        lower += 1
                    elsif @locations[i] < (@base_location_prob - 20)
                        lower += 1
                    end
                end
                if lower >= @count - 1
                    self.adjust_count(@count - 1)
                end
            end
            over_100 = nil
            for i in 0..3 do
                if(@locations[i] == nil)
                    next
                elsif(@locations[i] > 100)
                    over_100 = i
                end
            end
            if(over_100 != nil)
                if(@available_locations == 1)
                    @locations[over_100] = 100
                else
                    extra_value = @locations[over_100] - 100
                    divided = extra_value / (@available_locations - 1)
                    for i in 0..3 do
                        if(i = over_100)
                            @locations[i] = 100
                        else
                            @locations[i] = (@locations[i] + divided).round(2)
                        end
                    end
                    anaylze_data
                end
            end
        end
    end
end