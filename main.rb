require_relative 'codemaker'
require_relative 'codebreaker'
include MasterMind

breaker = CodeBreaker.new
maker = CodeMaker.new


p breaker.colors
puts breaker.guess
puts maker.code
puts maker.generate_key(breaker.guess)