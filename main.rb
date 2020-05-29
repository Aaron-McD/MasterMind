require_relative 'codemaker'
require_relative 'codebreaker'
include MasterMind

breaker = CodeBreaker.new
maker = CodeMaker.new
code = Code.new

puts code
puts maker.generate_color_hash(code)