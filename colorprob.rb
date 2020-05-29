require_relative 'mastermind'

module MasterMind
    # This will be the data structure that contains the probability out of 100 for each location and whether it exists
    class ColorProb
        attr_reader :locations, :in_code, :exist
        BASE_PROB = 0.1 # This is the base probability that likely or unlikely will be multiplied by to recalculate different probabilities
        def initialize(starting_prob = 16.67)
            @locations = [25, 25, 25, 25]
            @in_code = starting_prob
            @exist = true
            @available_locations = 4
        end

        def adjust_in_code(num, likely = 0, remove = false)
            if remove
                @in_code = 0
                @exist = false
            elsif likely > 0
                new_prob = (likely * BASE_PROB) * @in_code
                @in_code = (new_prob + @in_code).round(2)
                if(@in_code > 100)
                    @in_code = 100
                end
            else
                @in_code = (100.0 / num).round(2)
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
                    self.adjust_in_code(0, true)
                else
                    while i < 4 do
                        if locations[i] != nil
                            locations[i] = (locations[i] + new_prob).round(2)
                        end
                        i += 1
                    end
                end
            else
                if(@available_locations == 1)
                    if(likely > 0)
                        @locations[index] = 100
                    else
                        self.adjust_location_data(index, 0, 0, true)
                        self.adjust_in_code(0, true)
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
        end
    end
end