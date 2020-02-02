require 'byebug'

class AI
    def initialize(fragment, remaining_players)
        @fragment = fragment
        @remaining_players = remaining_players

        #build dictionary hash, by opening it as an array then iterating through it (may be a better way?)
        @dictionary = {}
        dictionary_array = File.open("/Users/jonathanyaniv/Desktop/W1D1/ghost/lib/dictionary.txt").read.split("\n")
        dictionary_array.each_with_index {|entry, idx| @dictionary[entry] = idx}
    end

    def guess
        #guess

        @dictionary.keys.each do |word|
            @remaining_letters = word.length - @fragment.length
            # if word[0...(@fragment.length)] == @fragment
            #     return word[@fragment.length] if remaining_letters % @remaining_players != 1
            # end
            if word[0...(@fragment.length)] == @fragment
                byebug
                next if @remaining_letters % @remaining_players != 1
                break if @dictionary.keys.none? {|entry| (entry.length - @fragment.length) % @remaining_players != 1}
                return word[@fragment.length] 
            end
        end

        "abdfghijklmnopqrstuvwxyz".split("").sample
    end
end