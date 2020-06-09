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
            $computer_score = 0
            $player_score = 0
            while(continue)
                puts "\n\n"
                puts "Hello and Welcome to Master Mind on the console! An application built by Aaron."
                UI.show_score
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
                    UI.reset_score
                when 6
                    continue = false
                end
            end
        end

        def UI.show_score
            puts "Computer Score: #{$computer_score}                             Your Score: #{$player_score}"
        end

        def UI.reset_score
            $computer_score = 0; $player_score = 0
        end

        def UI.play_as_codemaker
            puts "\n\n\nAlright you will be playing as the Code Maker so you need to start by typing in your code."
            puts "Your code must be 4 colors long containing any number of these colors: #{COLORS}"
            puts "Please enter your code, separating each color by a comma, remember that the position of the color will matter: "
            input = UI.get_color_input
            correct = true
            turn = 1
            win = false
            breaker = CodeBreaker.new
            player_checker = CodeMaker.new(input)
            until turn > TURNS
                puts "\nTurn #{turn}:"
                puts "Your Code: #{player_checker.code}"
                guess = breaker.generate_guess
                puts "\nThe computer guesses: #{guess}"
                puts "\nPlease type your response below to tell the computer how acurate the guess was."
                puts "Options: (#{CORRECT_POS}, #{CORRECT_COLOR}, #{WRONG_COLOR}), again separate by commas, make sure for blanks you put the word blank:"
                while true
                    input = gets.chomp.downcase.split(',').map { |color| color.strip }
                    if(input.length == 4)
                        input.each do |color|
                            if(color == CORRECT_POS || color == CORRECT_COLOR || color == WRONG_COLOR)
                                next
                            else
                                correct = false
                            end
                        end
                    else
                        correct = false
                    end
                    until correct
                        correct = true
                        puts "Please enter 4 colors or blanks separated by commas to represent your response:"
                        input = gets.chomp.downcase.split(',').map { |color| color.strip }
                        if(input.length == 4)
                            input.each do |color|
                                if(color == CORRECT_POS || color == CORRECT_COLOR || color == WRONG_COLOR)
                                    next
                                else
                                    correct = false
                                end
                            end
                        else
                            correct = false
                        end
                    end
                    key_checker = player_checker.generate_key(guess).generate_color_hash
                    player_key = Code.new(input)
                    player_key_hash = player_key.generate_color_hash
                    if player_key_hash == key_checker
                        break
                    else
                        puts "Your answer should have the following amount of each: #{CORRECT_POS}: #{key_checker[CORRECT_POS]}    #{CORRECT_COLOR}: #{key_checker[CORRECT_COLOR]}    #{WRONG_COLOR}: #{key_checker[WRONG_COLOR]}"
                    end
                end
                if(player_key_hash[CORRECT_POS] == 4)
                    puts "The computer has cracked your code and gains a point!"
                    puts "Press enter to continue..."
                    input = gets
                    $computer_score += 1
                    break
                else
                    turn += 1
                    breaker.anaylze_key(player_key)
                end
            end
            if turn > TURNS
                puts "The computer was unable to break your code, you gain a point!"
                puts "Press enter to continue..."
                input = gets
                $player_score += 1
            end
        end

        def UI.play_as_codebreaker
            puts "\n\n\nAlright you will be playing as the Code Breaker."
            puts "The computer will allow you to have 12 guesses with a max of 2 being single colored."
            puts "The final guess may also be single colored if you believe the code to be one color."
            turn = 1
            maker = CodeMaker.new
            single_color_guesses = 0
            while true
                puts "\nTurn #{turn}:"
                puts "Please enter four colors from the following to represent your guess, separated by commas: #{COLORS}"
                input = UI.get_color_input
                input_code = Code.new(input)
                input_hash = input_code.generate_color_hash
                if(input_hash.length == 1)
                    single_color_guess = true
                else
                    single_color_guess = false
                end
                while single_color_guess && single_color_guesses >= 2 && turn != TURNS
                    puts "Sorry you have already used all of your single color guesses."
                    input = UI.get_color_input
                    input_code = Code.new(input)
                    input_hash = input_code.generate_color_hash
                    if(input_hash.length == 1)
                        single_color_guess = true
                    else
                        single_color_guess = false
                    end
                end
                if(single_color_guess)
                    single_color_guesses += 1
                end
                key = maker.generate_key(input_code)
                puts "\nThe Code Maker responds with: #{key}"
                if(maker.break_code?(input_code))
                    puts "You have cracked the code and gain a point!"
                    $player_score += 1
                    won = true
                    break
                else
                    if(turn == TURNS)
                        won = false
                        break
                    end
                    puts "Press enter to continue..."
                    input = gets
                end
                turn += 1
            end
            unless won
                puts "Sorry but you are all out of guesses and couldn't crack the code. The code was #{maker.code}. The computer gains a point!"
                $computer_score += 1
            end
            puts "Press enter to continue..."
            input = gets
        end

        def UI.play_x_games
            UI.reset_score
            puts "\n\nHow many games would you like to play?"
            games = gets.chomp.to_i
            while games <= 1
                puts "Please enter a number greater than 1."
                games = gets.chomp.to_i
            end
            game = 1
            puts "\n\nType to number for which position you want to start as:"
            puts "1. Code Breaker"
            puts "2. Code Maker"
            choice = gets.chomp.to_i
            while choice != 1 && choice != 2
                puts "Please only enter 1 or 2:"
                choice = gets.chomp.to_i
            end
            while game <= games
                puts "Game #{game}:"
                if(choice == 1)
                    UI.play_as_codebreaker
                    choice = 2
                else
                    UI.play_as_codemaker
                    choice = 1
                end
                puts "Game #{game} is over. The current scores are:"
                game += 1
                UI.show_score
                puts "Press enter to continue..."
                input = gets
            end
            if($computer_score > $player_score)
                puts "Looks like the computer beat you overall, better luck next time..."
            elsif($computer_score == $player_score)
                puts "Well you didn't lose but you also didn't win..."
            else
                puts "Well done, looks like you were able to beat the computer overall!"
            end
            puts "Press enter to return to the main menu..."
            input = gets
        end

        def UI.get_color_input
            correct = true
            input = gets.chomp.downcase.split(',').map { |color| color.strip }
            if(input.length == 4)
                input.each do |color|
                    if(COLORS.include?(color))
                        next
                    else
                        correct = false
                    end
                end
            else
                correct = false
            end
            until correct
                puts "Please enter only four colors, separated by commas and they must be one of these #{COLORS}:"
                input = gets.chomp.downcase.split(',').map { |color| color.strip }
                correct = true
                if(input.length == 4)
                    input.each do |color|
                        if(COLORS.include?(color))
                            next
                        else
                            correct = false
                        end
                    end
                else
                    correct = false
                end
            end
            return input
        end
    end
end