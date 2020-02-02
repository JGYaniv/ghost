class Player
    attr_accessor :name, :new_letter

    def initialize
        @name = gets.chomp.capitalize
    end

    def guess
        puts "\n\nEnter a single letter Mr. #{@name}: "
        while true
            @new_letter = gets.chomp
            return @new_letter if @new_letter.length == 1
            puts "\n\nPlease enter just a single character Mr. #{@name}."
        end
    end

    def alert_invalid_guess
    end

end

