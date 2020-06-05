module MasterMind
    class UI
        # This is more of a utility class that will be used to wrap of of the info display in one location
        def UI.display_rules
            puts "This is the rules section for Master Mind:"
            puts "The general rules and guidelines are pretty straight forward, there are two roles you can play as, a code maker or code breaker. \n\n"
            puts "Code Maker:"
            puts "As a code maker you can create any four color code from the following colors #{COLORS}."
            puts "You are allowed to use as many of any color as you would like."
            puts "Once you have created your code the computer will then make 12 guesses to attempt to break that code."
            puts "For each guess you give feedback based on how close the guess was."
            puts "This feedback will be dependant on if a color was in the code and if it was in the correct spot."
            puts "So if a color in the guess is in the code but not in the right spot then your response would contain a #{CORRECT_COLOR} peg to represent that."
            puts "However if that color was also in the correct position you would instead add a #{CORRECT_POS} peg."
            puts "If the color they guessed doesn't represent any color in your code you would give a #{WRONG_COLOR} peg."
            puts "Make sure each peg only represents one of the colors in the guess."
            puts "For example if the guess had only one of a certain color but your code had two of that color you would only give one peg."
            puts "This works the other way around too, so if instead your code had one of that color but the guess had two, you'd still only give one peg."
            puts "Finally with these scenarios listed above you should always prioritize giving red pegs when possible."
            puts "So with the example above if the guess had two of a certain color in it and one of them are in the correct position then you should give the #{CORRECT_POS} peg rather than the #{CORRECT_COLOR} peg."
            puts "If this is all a little confusing and difficult to remember don't worry too much, the computer will check your answers to make sure they are what they should be."
            puts "Finally make sure to give your response in a random order to make it more difficult to crack!"
            puts "Example:"
            puts "Your Code: #{COLORS[1]}, #{COLORS[1]}, #{COLORS[0]}, #{COLORS[5]}"
            puts "Computer's Guess: #{COLORS[1]}, #{COLORS[2]}, #{COLORS[4]}, #{COLORS[0]}"
            puts "Your Response to this for each position should be:"
            puts "Response: #{CORRECT_POS}, #{WRONG_COLOR}, #{WRONG_COLOR}, #{CORRECT_COLOR}"
            puts "Just try to make the order more random than this.\n\n\n"

            puts "Code Breaker:"
            puts "You may be able to guess what you do hear by the above text but if you didn't read that then that's fine."
            puts "You will have 12 turns to make guesses for a four color code containing any number of these colors: #{COLORS}"
            puts "You may only use two of your guess as single color guesses and the final guess if you think the code is one color."
            puts "The computer will then generate a key for you to represent how well you guessed where each color in that key corresponds to a color in your guess."
            puts "#{CORRECT_POS} pegs represent that one of your colors is in the correct position and in the code."
            puts "#{CORRECT_COLOR} pegs represent that one of your colors is in the wrong position but is in the code."
            puts "#{WRONG_COLOR} pegs represents that one of your colors is not in the code."
            puts "Remember that the key will be given in a random order to make it more difficult to crack and don't forget there could be more than one of any color in the code!\n\n\n"
            puts "\n\n\nEnter any key to go back."
            input = gets.chomp
        end

        def UI.show_main_menu
            continue = true
            while(continue)
                puts "Hello and Welcome to Master Mind on the console! An application built by Aaron."
                puts "Please enter a number for what you would like to do."
                puts "1. See Rules"
                puts "2. Play a round as Code Maker"
                puts "3. Play a round as Code Breaker"
                puts "4. Play 'x' amount of alternating games"
                puts "5. Reset the scores"
                puts "6. Close Application"
                input = gets.chomp.to_i
                while input > 6 || input < 1
                    puts "Sorry that isn't an option."
                    input = gets.chomp.to_i
                end
                case input
                when 1
                    UI.display_rules
                when 2
                    UI.play_as_codemaker
                when 3
                    UI.play_as_codebreaker
                when 4
                    UI.play_x_games
                when 5
                    UI.reset_scores
                when 6
                    continue = false
                end
            end
        end

        def UI.show_score
            puts "Computer Score: #{computer_score}                             Your Score: #{player_score}"
        end
    end
end