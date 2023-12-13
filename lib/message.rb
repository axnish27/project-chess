module Message

  def instructions(input)
    case input
      when "s"
        File.open('lib/save_games/save.dump', 'w') { |f| f.write(YAML.dump(self)) }
        puts "Game saved successfully."
      when "l"
        begin
          puts "Last saved game loaded successfully."
          load = Psych.safe_load(File.read('lib/save_games/save.dump'), permitted_classes: [Game, Board, Square, Piece, Player, Rook, Bishop, Knight, Pawn, Queen, King], aliases: true)
          load.turn
        rescue StandardError
          puts "Error loading the saved game. Please ensure the save file exists and is valid."
        end
      when "r"
        winner = (@player_turn.color == "black") ? player1 : player2
        puts "#{@player_turn.name} resigned. Therefore, #{winner.name} is the winner."
        # puts
        # print "Play again? [y/n] "
        # reply = gets.chomp
        # if reply.match?(/\A[ny]\z/i)
        #   if reply == "y"

        #do this
        exit
      when "q"
        puts "Exiting the game. Goodbye!"
        exit
    end
  end


  def how_to_play()

    puts "How to Play Tutorial: Chess Game"
    puts
    puts "Enter Moves:"
    puts
    puts "To make a move, input piece coordinates and destination (e.g., e2, e4).
    Commands: 's' (save), 'l' (load), 'r' (resign), 'q' (exit)."
    puts "Special Commands:"
    puts
    puts "'s' to save, 'l' to load, 'r' to resign, 'q' to exit."
    puts"Available Moves:"
    puts
    puts "Type piece coordinates + ? to view available moves (e.g., e2?)."
    puts "Valid Moves:"
    puts
    puts "Ensure moves are within board boundaries."
    puts "Confirm a piece is at the starting square."
    puts "Follow color restrictions (white moves first)."
    puts "Enjoy your chess game!"

  end

end
