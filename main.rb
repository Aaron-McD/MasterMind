require_relative 'mastermind'
include MasterMind

$breaker = CodeBreaker.new
maker = CodeMaker.new
prob = ColorProb.new(3)

def print_breaker_info
    $breaker.colors.each do |key, value|
        if value == nil
            puts "#{key} is not in the code"
        elsif value == 0
            puts "#{key} has no data"
        else
            puts "#{key} = #{value.locations} there are at least #{value.count} in there and it is #{value.in_code}% likely to exist"
        end
    end
    puts "\n"
end

12.times do |i|
    puts "Guess number #{i + 1}"
    puts "Guess: #{$breaker.generate_guess}"
    puts "Answer: #{maker.code}"
    puts "Key: #{maker.generate_key($breaker.guess)}"
    $breaker.anaylze_key(maker.generate_key($breaker.guess))
    print_breaker_info
end
