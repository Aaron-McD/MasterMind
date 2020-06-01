require_relative 'mastermind'
include MasterMind

$breaker = CodeBreaker.new
maker = CodeMaker.new
prob = ColorProb.new


p prob.locations
p prob.count
prob.anaylze_data(0,4,0,2,4)
p prob.locations
p prob.count
prob.anaylze_data(0,4,1,2,4)
p prob.locations
p prob.count



=begin
def print_breaker_info
    $breaker.colors.each do |key, value|
        if value == nil
            puts "All blank"
        elsif value.empty?
            next
        else
            puts "#{key} = #{value[0].locations} and is #{value[0].in_code}% likely to exist"
        end
    end
end

12.times do |i|
    puts "Guess number #{i}"
    puts "Guess: #{$breaker.generate_guess}"
    puts "Answer: #{maker.code}"
    puts "Key: #{maker.generate_key($breaker.guess)}"
    $breaker.anaylze_key(maker.generate_key($breaker.guess))
    print_breaker_info
end

=end
