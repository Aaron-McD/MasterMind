require_relative 'mastermind'
include MasterMind

$breaker = CodeBreaker.new
maker = CodeMaker.new

UI.display_rules

=begin
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
    puts "\n"
end
rounds = 1000
wins = 0
rounds.times do
    $breaker = CodeBreaker.new
    maker = CodeMaker.new
    TURNS.times do |i|
        guess = $breaker.generate_guess
        puts "Guess number #{i + 1}"
        puts "Guess: #{guess}"
        puts "Answer: #{maker.code}"
        puts "Key: #{maker.generate_key(guess)}"
        if(maker.break_code?(guess))
            wins += 1
            break
        end
        $breaker.anaylze_key(maker.generate_key(guess))
        print_breaker_info
        puts "\n"
    end
end

puts "The AI was able to break the code #{wins} times, meaning a win rate of #{((wins.to_f / rounds) * 100).round(2)}%."
=end

