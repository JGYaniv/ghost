require_relative './lib/player.rb'
require_relative './lib/AI.rb'

class Game

    attr_reader :dictionary
    attr_accessor :fragment, :current_player

    def initialize

        #build dictionary hash, by opening it as an array then iterating through it (may be a better way?)
        @dictionary = {}
        dictionary_array = File.open("./lib/dictionary.txt").read.split("\n")
        dictionary_array.each_with_index {|entry, idx| @dictionary[entry] = idx}

        #setup human players hash
        puts "\n\nHow many human players do we have today?"
        @num_of_players = gets.to_i
        @players = {}
        @round_number = 1
        @num_of_players.times do |num|
            puts "\n\nWhat is your name player ##{(num+1).to_s}?"
            @players[gets] = 0
        end

        #setup AI players hash
        puts "\n\nHow many A.I. players would you like to add (if none enter 0)?"
        num_of_AIs = gets.to_i
        num_of_AIs.times do |num|
            @players["A.I. 0#{num_of_AIs}"] = 0
        end
        puts "\n\nAlright we added #{num_of_AIs.to_s} A.I. players to your game!"


        #game loops until there is only one player left
        while true

            #round data
            puts "\n\n----------------\n\n"
            puts "Lets get round ##{@round_number} started!\n"
            @players.each {|player,score| puts "#{player.chomp} is a... #{ghost_letter(score)}"}

            #iterates through hash to check if player is out or if there is only one player left
            @players.each do |player, score|
                if score >= 5
                    puts "\n\n#{player.chomp} is a M.F. GHOST now! You Lose!\n\n\n----------------\n\n\n"
                    @players.delete(player)
                    puts "Remaing players are: "
                    puts @players.keys
                    puts "\n\n"

                    #game_end condition
                    if @players.keys.length == 1
                        winner = @players.keys.to_a[0][0]
                        puts "\n\nCongrats #{winner.chomp}, you are the winner!!"
                        puts "\n\nThanks for playing."
                        puts "\n\nThat's all folks!"
                        puts "\n\n\n----------------\n\n\n"
                        abort
                    end
                    next
                end
            end



            #enter starting fragment, will loop until meets requirements below
            while true
                puts "\n\nEnter starting fragment:"
                @fragment = gets.chomp.downcase

                # to accept the starting frament, it must be part of a word, under 4 characters, and not a word itself
                break if valid_play?(@fragment) && @fragment.length < 4 && !@dictionary[@fragment]
                puts "\n\nNot a valid starting fragment, please keep it to 3 or less characters & PART of a real word!"
            end

            play_round
        end
    end

    def play_round

        turn_num = 0
        round = true
        while round
            turn_num += 1

            @players.each do |player, score|
                #turn data
                next if score >= 5
                puts "\n\n-------- Turn ##{turn_num} --------"
                puts "Current player: #{player.chomp}"
                puts "Current fragment: #{@fragment}\n\n"

                #takes turn
                take_turn(player) unless player[0...4] == "A.I."
                if player[0...4] == "A.I."
                    ai_instance = AI.new(@fragment, @players.keys.length)
                    @fragment += ai_instance.guess
                end

                #checks if a losing condition has been met, otherwise coninues to next player turn
                if @dictionary[@fragment]
                    puts "\n#{@fragment} is a word Mr. #{player.chomp}, you lose\n\n\n"
                    @players[player] += 1
                    round = false
                    break
                elsif valid_play?(@fragment) == false
                    puts "\n#{@fragment} is not a word, you lose Mr. #{player.chomp}\n\n\n"
                    @players[player] += 1
                    round = false
                    break
                end
            end
        end
    end

    def ghost_letter(score)
        return "" if score == 0
        return "GHOST"[0..score - 1]
    end

    def current_player
        @current_player
    end

    def previous_player
        @previous_player
    end

    def next_player!
        @current_player, @previous_player = @previous_player, @current_player
    end

    def take_turn(player)

        puts "\n\nEnter a single letter Mr. #{player.chomp}: "
            while true
                @new_letter = gets.chomp
                break if @new_letter.length == 1 && @new_letter.to_s == @new_letter
                puts "\n\nPlease enter just a single character Mr. #{player.chomp}."
            end
        @fragment += @new_letter
    end

    def valid_play?(string)
        @dictionary.keys.any? {|word| word[0...string.length] == string}
    end

end


if __FILE__ == $PROGRAM_NAME
    Game.new
end
