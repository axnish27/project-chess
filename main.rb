require_relative 'lib/peice'
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
    @find_co_ordinates = @board.hash
    @captured_peices = []
    @first_move = true
    @player_turn = "white"
    @check = true
    delete_this()



  end


  def call_turns

    2.times do
      turn

    end
  end

  def turn
    input = gets.chomp.split(",")
    move_peice(input[0],input[1])

  end

  def available_moves()
    start = start.split("?")[0]
    start_square = return_square(start)
    peice = start_square.peice
    peice.board = @play_board
    peice.all_moves
    available_moves = peice.available_moves.flatten.uniq
    return puts available_moves
  end
  def move_peice(start,destination=nil)

    if destination.nil? && start.include?("?") && in_board?(start.split("?")[0])
      return available_moves()
    elsif !in_board?(start) || !in_board?(destination)
      return p "invalid move"
    elsif return_square(start).nil?
      return puts "no peice at the square "
    elsif @first_move && return_square(start).peice.color == "black"
      return puts "white moves first "
    end


    start_square = return_square(start)
    destination_square = return_square(destination)


    return puts "no peice at the square " if start_square.peice.nil?
    peice = start_square.peice

    return puts "white moves first " if @first_move && peice.color == "black"
    @first_move = false




    peice.current_position = @find_co_ordinates[start]
    peice.destination = @find_co_ordinates[destination]
    peice.board = @play_board

    #checks if destination is possible
    return puts "#{@player_turn}'s moves"if peice.color != @player_turn
    return puts"invalid move for the peice check" if !peice.check_valid?

    available_moves = peice.available_moves.flatten.uniq

    return puts"invalid move for the peice" if !available_moves.include?(destination)

    if @check == true

      destination_square.peice = peice
      start_square.peice = nil
      #chek after the move is made all the opponent players can capture moves...to see if king is present if present tell to make another mve

      opponent = @player_turn  == "white" ? "black" : "white"
      opponent_peices = @play_board.flatten.find_all do |square|
        if square.peice.nil?

        else
          square.peice.color == opponent
        end

      end


      stil = nil
      opponent_peices.each do |square|

      peice = square.peice
      peice.board = @play_board
      peice.all_moves
      if !peice.can_capture.compact.empty?
        stil = peice.can_capture.any? {|move| move.peice.name == "King"}
        return puts "stiil in chek" if stil
      else
        @check = false
      end
    end




    end


    start_square = return_square(destination_square.name)

    peice = start_square.peice
    peice.current_position = @find_co_ordinates[destination_square.name]
    peice.board = @play_board

    peice.all_moves
    peice.can_capture
    @check = peice.can_capture.any?{|move| move.peice.name == "King"}
    puts "FUck check" if @check

    #current postion give when initialize and when the peice is moved change teh current postion


  end


  def return_square(square)

    index = @find_co_ordinates[square]
    @play_board[index[0]][index[1]]

  end


  def delete_this()

    square1 = @play_board[1][4] #e2
    square2 = @play_board[5][4] #b1
    square3 = @play_board[2][2] #b2

    square1.peice = nil

    knightbish1 = Rook.new("player2")
    knightbish1.color = "black"
    square2.peice = knightbish1
    knightbish1.current_position = square2.co_ordinate


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


