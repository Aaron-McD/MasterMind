module MasterMind
    COLORS = ["red", "black", "white", "blue", "green", "yellow"]
    CORRECT_POS = "red"
    CORRECT_COLOR = "white"
    WRONG_COLOR = "blank"
    TURNS = 12
    
end

require_relative 'peg.rb'
require_relative 'code.rb'
require_relative 'colorprob.rb'
require_relative 'codemaker.rb'
require_relative 'codebreaker.rb'
require_relative 'ui.rb'