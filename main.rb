require_relative 'mastermind'
include MasterMind

$breaker = CodeBreaker.new
maker = CodeMaker.new

def print_breaker_info
    $breaker.colors.each do |key, value|
        if value == nil
            puts "#{key} is not in the code."
        elsif value.exist == 16.67
            puts "#{key} has no information."
        else
            puts "#{key} = #{value.locations} and is #{value.exist}% likely to exist with at most #{value.count}."
        end
    end
end
100000.times do
    $breaker = CodeBreaker.new
    maker = CodeMaker.new
    12.times do |i|
        puts "Guess number #{i + 1}"
        puts "Guess: #{$breaker.generate_guess}"
        puts "Answer: #{maker.code}"
        puts "Key: #{maker.generate_key($breaker.guess)}"
        $breaker.anaylze_key(maker.generate_key($breaker.guess))
        print_breaker_info
        puts "\n"
    end
end


