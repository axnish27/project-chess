require 'yaml'
require 'psych'
require_relative 'lib/message'
require_relative 'lib/player'
require_relative 'lib/game'


def start()
  puts "Welcome to Chess Game!"
  puts "Let's play chess. Choose an option:"

  options = [
    "1. New Game",
    "2. Load Game",
    "3. Tutorial",
    "4. Exit"
  ]

  puts options

  begin
    print "Enter your choice (1-4): "
    input = gets.chomp
    raise StandardError unless input.match?(/\A[1-4]\z/)
  rescue StandardError
    puts "Invalid input. Please enter 1, 2, 3, or 4."
    retry
  end

  response(input.to_i)
end

def response(input)
  case input
    when 1
      puts "Enter Player 1's name (playing as white):"
      player1_name = gets.chomp
      player1 = Player.new(player1_name, "white")

      puts "Enter Player 2's name (playing as black):"
      player2_name = gets.chomp
      player2 = Player.new(player2_name, "black")

      game = Game.new(player1, player2)
      game.turn

    when 2
      begin
        load = Psych.safe_load(File.read('lib/save_games/save.dump'), permitted_classes: [Game, Board, Square, Piece, Player, Rook, Bishop, Knight, Pawn, Queen, King], aliases: true)
        load.turn
      rescue StandardError
        puts "Error loading the saved game. Please ensure the save file exists and is valid."
      end

    when 3
      Message::how_to_play
    when 4
      puts "Exiting the game. Goodbye!"
      exit
  end
end



start()
