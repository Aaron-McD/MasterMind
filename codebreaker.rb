require_relative 'colorprob'
require_relative 'code'

module MasterMind
    class CodeBreaker
        attr_reader :colors, :guess
        def initialize
            @colors = {'red' => [],
                       'green' => [],
                       'white' => [],
                       'blue' => [],
                       'yellow' => [],
                       'black' => []}
            @guess = Code.new
        end

        def anaylze_key(key)
            
        end
    end
end