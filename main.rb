require_relative 'codemaker'
include MasterMind

my_maker = CodeMaker.new(["white", "red", "blue", "yellow"])
my_guess = CodeMaker.new(["white","white","red","blue"])
p my_maker.code
puts "\n"
p my_maker.generate_key(my_guess.code)

