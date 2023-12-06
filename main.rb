require_relative 'lib/piece'
require_relative 'lib/board'



class Player
  attr_accessor :board

  def initialize(player,board)
    @player = player
  end

end


class Game


  def initialize(player1,player2)
    @board = Board.new(player1,player2)
    @play_board = @board.board
    @find_co_ordinates = @board.hashy
    @captured_pieces = []
    @first_move = false
    @player_turn = "black"
    @check = false
    delete_this()



  end

  def call_turns
    2.times do
      turn
    end
  end



  def turn
    input = gets.chomp.split(",")
    move_piece(input[0],input[1])

  end

  def available_moves(start)
    start = start.split("?")[0]
    start_square = return_square(start)
    piece = start_square.piece
    piece.board = @play_board
    piece.all_moves
    available_moves = !piece.available_moves.nil? ? piece.available_moves.flatten.uniq : nil
    return p available_moves
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
    elsif return_square(start).nil?
      puts "no piece at the square "
      return false
    elsif @first_move && return_square(start).piece.color == "black"
      puts "white moves first"
      return false
    elsif return_square(start).piece.color != @player_turn
      puts "#{@player_turn}'s moves"
      return false
    end
    @first_move = false
    true
  end


  def still_check?()



    opponent = @player_turn  == "white" ? "black" : "white"

    opponent_pieces = @play_board.flatten.find_all do |square|
      if !square.piece.nil?
        square.piece.color == opponent
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

    start_square = return_square(destination)
    piece = start_square.piece
    piece.board = @play_board
    piece.all_moves
    piece.can_capture
    check = piece.can_capture.any?{|move| move.piece.name == "King"}
    check

  end

  def move_piece(start,destination=nil)

    # while
    #   turn
    # end
    return if !check_input?(start, destination)

    start_square = return_square(start)
    destination_square = return_square(destination)
    piece = start_square.piece



    piece.destination = @find_co_ordinates[destination]
    piece.board = @play_board

    return puts"invalid move for the piece check" if !piece.check_valid?

    available_moves = piece.available_moves.flatten.uniq

    return puts"invalid move for the piece" if !available_moves.include?(destination)

    #find a way to put all of this

    if @check == true
      return puts "still in check " if simulator_check(start_square,destination_square,piece)

    end

    destination_square.piece = piece
    start_square.piece = nil
    destination_square.piece.current_position = destination_square.co_ordinate



    @check = is_check?(destination_square.name)
    p @check
    #checking if checkmade
    if @check

      player_pieces = @play_board.flatten.find_all do |square|
        if !square.piece.nil?
          square.piece.color == @player
        end
      end

      @checkmate = true
      player_pieces.each do |square|
        piece = square.piece
        piece.board = @play_board
        piece.all_moves.each do |destination|
          @checkmate = simulator_check(square,square,return_square(destination),piece)
          break if !@checkmate
        end
      end
    end
    p "check mate ? #{@checkmate}"

    puts "moved"

    @player_turn = @player_turn  == "white" ? "black" : "white"

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


  def delete_this()
    # Assuming @play_board is a 2D array representing the chessboard

    # Set up the initial board

    @play_board[1][5].piece = nil
    @play_board[1][6].piece = nil
    @play_board[6][4].piece = nil


    # White moves
    pawn1 = Pawn.new("player1")
    pawn1.color = "white"
    @play_board[3][5].piece = pawn1
    pawn1.current_position = @play_board[3][5].co_ordinate

    # Black makes a mistake
    pawn2 = Pawn.new("player1")
    pawn2.color = "white"
    @play_board[3][6].piece = pawn2
    pawn2.current_position = @play_board[3][6].co_ordinate

    # White moves again

    # Black makes another mistake (Fool's Mate)
    pawn3 = Pawn.new("player2")
    pawn3.color = "black"
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


game = Game.new("player1","player2")
game.call_turns





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


