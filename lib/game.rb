require_relative 'piece'
require_relative 'board'
require_relative 'rules'
require_relative 'input_check'
require_relative 'message'
require 'yaml'
require 'psych'
require 'io/console'


class Game

  include Rules
  include Input_Check
  include Message

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


  end


  def turn
    @board.display(@play_board)
    while !@checkmate && !@stale_mate
      puts @hint
      begin
        puts "#{@player_turn.name}'s turn to move. | s - save | l - load | r - resign | q - exit |"
        input = gets.chomp.strip.split(",")
        redo unless check_input?(input[0], input[1])
        redo unless move_piece(input[0], input[1])
        @hint = nil
      rescue => e
       puts "Error: #{e.message}"
        retry
      end
    end

  end


  def move_piece(start,destination)

    start_square = return_square(start)
    destination_square = return_square(destination)
    piece = start_square.piece

    piece.destination = @find_co_ordinates[destination]
    piece.board = @play_board

    @hint = "Invalid move: the piece cannot be moved."
    return false  if !piece.check_valid?

    available_moves = piece.available_moves.flatten.uniq

    @hint = "Invalid move: destination is not within the piece's valid moves."
    return false if !available_moves.include?(destination)


    @hint = "Draw Game: Stale mate ,the King cannot move and is not in check."
    return false if piece.name == "King" && !@check && stale_mate(piece,start_square)


    @hint = "Invalid move: the piece is still in check."
    return false if @check && simulator_check(start_square,destination_square,piece)


    @captured = piece_captured?(destination_square)

    #finally moving the peice
    destination_square.piece = piece
    start_square.piece = nil
    destination_square.piece.current_position = destination_square.co_ordinate

    @check = is_check?(destination_square)
    return puts "The game has concluded. Checkmate! Your opponent has successfully cornered your king, and there are no legal moves left to escape. Well played!" if @check && is_checkmate?()

    @pawn_promoted = false
    destination_square.peice = pawn_promotion(destination_square) if piece.name == "Pawn" && destination.split("")[1] == 1 || destination.split("")[1] == 8


    switch_players() if !@captured || !@pawn_promoted

    @board.display(@play_board)
    true

  end


  def piece_captured?(destination_square)
    if !destination_square.piece.nil?
      @player_turn.captured << destination_square.piece.symbol
      return true
    else
      return false
    end
  end

  def switch_players()
    @player_turn = @player_turn  == @player1 ? @player2 : @player1
  end

  def return_square(square)

    index = @find_co_ordinates[square]
    @play_board[index[0]][index[1]]

  end


end



