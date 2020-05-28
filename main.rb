require_relative 'codemaker'
include MasterMind

my_maker = CodeMaker.new(["white", "white", "red", "blue"])
my_guess = Code.new(["black","black","black","black"])
puts my_maker.code
puts "\n"
puts my_maker.generate_key(my_guess)

