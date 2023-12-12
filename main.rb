require_relative 'lib/piece'
require_relative 'lib/board'
require 'yaml'
require 'psych'
require 'io/console'




class Player
  attr_accessor :name ,:captured,:color

  def initialize(player,color)
    @name = player
    @color = color
    @captured = []
  end

end


class Game

  def initialize(player1,player2)
    @board = Board.new(player1,player2)
    @play_board = @board.board
    @find_co_ordinates = @board.hash
    @first_move = true
    @player1 = player1
    @player2 = player2
    @player_turn = player1
    @check = false
    @checkmate = false
    print_board(@play_board)

    #delete_this()



  end



  def print_board(board)

    letters = ["a","b","c","d","e","f","g","h"]
    print nil
    for i in letters
      print "  #{i}"
    end
    print nil
    puts
    x = 8
    board.reverse.each do |arr|
      print x
      arr.each do |square|
        print square.piece.nil? ? " _ " : " #{square.piece.symbol} "
      end
      print x
      x -= 1
      puts
    end
    print nil
    for i in letters
      print "  #{i}"
    end
    puts nil
  end

  def call_turns
    while !@checkmate
      turn
    end
  end

  def turn
    loop do
      begin

        input = gets.chomp.strip.split(",")
        break unless check_input?(input[0], input[1])
        break p @hint unless move_piece(input[0], input[1])
      rescue => e
       puts "Error: #{e.message}"
        retry
      end
    end
  end

  def available_moves(start)

    start = start.split("?")[0]
    start_square = return_square(start)
    piece = start_square.piece
    piece.board = @play_board
    piece.all_moves
    available_moves = !piece.available_moves.nil? ? piece.available_moves.flatten.uniq : nil
    p available_moves

  end

  def check_input?(start,destination=nil)
    if start.nil?
      puts "Input Move"
      return false
    elsif destination.nil? && start.include?("?") && in_board?(start.split("?")[0])
      available_moves(start)
      return false
    elsif !in_board?(start) || !in_board?(destination)
      puts "invalid move"
      return false
    elsif return_square(start).piece.nil?
      puts "no piece at the square"
      return false
    elsif @first_move && return_square(start).piece.color == "black"
      puts "white moves first"
      return false
    elsif return_square(start).piece.color != @player_turn.color
      puts "#{@player_turn.name}'s move"
      return false
    elsif !return_square(destination).piece.nil? && return_square(destination).piece.name == "King"
      puts "King cannot be caputred"
      return false
    else
      @first_move = false
      true
    end
  end


  def still_check?()

    opponent_color = @player_turn == @player1 ? @player2.color : @player1.color
    opponent_pieces = @play_board.flatten.find_all do |square|
      if !square.piece.nil?
        square.piece.color == opponent_color
      end
    end

    opponent_pieces.each do |square|
      piece = square.piece
      piece.board = @play_board
      piece.all_moves
      if !piece.can_capture.compact.empty?
        stil = piece.can_capture.any? {|move| move.piece.name == "King"}
        return stil if stil
      end
    end
    return false
  end

  def is_check?(destination)
    piece = destination.piece
    piece.board = @play_board
    piece.all_moves
    piece.can_capture
    check = piece.can_capture.any?{|move| move.piece.name == "King"}
  end

  def move_piece(start,destination)


    start_square = return_square(start)
    destination_square = return_square(destination)
    piece = start_square.piece


    piece.destination = @find_co_ordinates[destination]
    piece.board = @play_board

    @hint = "invalid move for the piece check"

    return false  if !piece.check_valid?
    available_moves = piece.available_moves.flatten.uniq


    @hint = "invalid move for the piece"

    return false if !available_moves.include?(destination)


    @hint =  "stale Mate"
    return false if piece.name == "King" && !@check && stale_mate(piece,start_square)


    @hint = "still in check"

    return false if @check && simulator_check(start_square,destination_square,piece)

    if !destination_square.piece.nil?
        @captured = true
        @player_turn.captured << destination_square.piece.symbol
    else
      @captured = false
    end

    destination_square.piece = piece
    start_square.piece = nil
    destination_square.piece.current_position = destination_square.co_ordinate


    @check = is_check?(destination_square)

    return p "check mate ? #{@checkmate}" if @check && is_checkmate?()

    @pawn_promoted = false
    if piece.name == "Pawn" && destination.split("")[1] == 1 || destination.split("")[1] == 8
      destination_square.peice = pawn_promotion(destination_square)
      @pawn_promoted = true
    end

    if !@captured || !@pawn_promoted
        @player_turn = @player_turn  == @player1 ? @player2 : @player1
    end

    print_board(@play_board)
    save()

    true
  end


  def pawn_promotion(square)
    puts "Your Pawn can be promoted input the letter corresponding to the peice u want "
    name = ["r - Rook","k - Knight","b - Bishop","q - Queen"]
    puts name
    piece_classes = {
      'r' => Rook,
      'k' => Knight,
      'q' => Queen,
      'b' => Bishop
    }

    begin
      new_piece = gets.chomp
      piece = piece_classes[new_piece]
      if piece
        piece_instance = piece.new(square.piece.player,square.piece.color)
        piece_instance.current_position = square.co_ordinate
        puts "You selected #{name.find { |s| s.downcase.start_with?(new_piece) }.split(" - ").last}"
      else
        puts "Invalid piece selection"
      end
    rescue => e
      puts "Error: #{e.message}"
      retry
    end
    piece_instance

  end

  def stale_mate(piece,square)
    piece.all_moves.each do |destination|
      stale_mate = simulator_check(square,return_square(destination),piece)
      break if !stale_mate
    end
    stale_mate
  end

  def is_checkmate?()

    player_pieces = @play_board.flatten.find_all do |square|
      if !square.piece.nil?
        square.piece.color == @player_turn.color
      end
    end

    player_pieces.each do |square|
      piece = square.piece
      piece.board = @play_board
      next if piece.all_moves.nil?
      piece.all_moves.each do |destination|
        @checkmate = simulator_check(square,return_square(destination),piece)
        break if !@checkmate
      end
    end

    @checkmate

  end

  def simulator_check(start_square,destination_square,piece)
    temp = destination_square.piece
    temp2 = start_square.piece
    temp3 = destination_square.piece.nil? ? nil : destination_square.piece.current_position

    destination_square.piece = piece
    start_square.piece = nil
    destination_square.piece.current_position = destination_square.co_ordinate

    check = still_check?()

    destination_square.piece = temp
      start_square.piece = temp2
      if !destination_square.piece.nil?
        destination_square.piece.current_position = temp3
      end

    if check
      return true
    else
      return false
    end
  end


  def return_square(square)

    index = @find_co_ordinates[square]
    @play_board[index[0]][index[1]]

  end
  #/lib/save_games/
  def save()
    File.open('save.dump', 'w') { |f| f.write(YAML.dump(self)) }
  end

  def delete_this()

    @play_board[1][5].piece = nil
    @play_board[1][6].piece = nil
    @play_board[6][4].piece = nil


    pawn1 = Pawn.new("player1","white")

    @play_board[3][5].piece = pawn1
    pawn1.current_position = @play_board[3][5].co_ordinate

    pawn2 = Pawn.new("player1","white")
    @play_board[3][6].piece = pawn2
    pawn2.current_position = @play_board[3][6].co_ordinate

    pawn3 = Pawn.new("player2","black")

    @play_board[2][5].piece = pawn3
    pawn3.current_position = @play_board[2][5].co_ordinate
  end





  def in_board?(co_ordinate)

    begin
      index = co_ordinate.split("")
      return true if index.length == 2 && index[1].to_i.between?(1,8) && index[0] in "a".."h"
    rescue NoMethodError
      return false
    end
    false

  end


end

player1 = Player.new("Nuha","white")
player2 = Player.new("Aanish","black")
game = Game.new(player1,player2)
game.call_turns


#game.pawn_promotion(game.return_square("d8"))
# load = Psych.safe_load(File.read('save.dump'),permitted_classes: [Game,Board,Square,Piece,Player,Rook,Bishop,Knight,Pawn,Queen,King], aliases: true)
# load.call_turns



# bishop = King.new("player1")
# bishop.current_position = [4,3]
# bishop.destination = [2,1]
# bishop.board = b
# bishop.create_moves
# bishop.down
# bishop.left
# bishop.right
# bishop.check_valid?
# p bishop.available_moves


