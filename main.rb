require_relative 'codemaker'
require_relative 'codebreaker'
include MasterMind

breaker = CodeBreaker.new
maker = CodeMaker.new
code = Code.new

puts "Guess: #{code}"
puts "Answer: #{maker.code}"
puts maker.generate_key(code)