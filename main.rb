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

  def move_peice(start,destination=nil)


    # @play_board.each do |array|
    #   array.each do |object|
    #     puts "#{object.peice.name} #{object.name} #{object.peice.color}" if !object.peice.nil?
    #   end
    # end

    if start.include?("?") && in_board?(start.split("?")[0])
      start = start.split("?")[0]
      start_square = return_square(start)
      peice = start_square.peice
      peice.current_position = @find_co_ordinates[start]
      peice.board = @play_board
      peice.all_moves
      available_moves = peice.available_moves.flatten.uniq
      return puts available_moves
    end


    return p "invalid move" if !in_board?(start) || !in_board?(destination)
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

    p available_moves = peice.available_moves.flatten.uniq

    return puts"invalid move for the peice" if !available_moves.include?(destination)

    puts peice.color

    if peice.can_capture.include?(destination)
      @captured_peices << destination_square.peice
      @player_turn = peice.color
    else
      @player_turn = peice.color == "white" ? "black" : "white"
    end


    destination_square.peice = peice
    start_square.peice = nil


  end


  def capture_peice


  end

  def return_square(square)

    index = @find_co_ordinates[square]
    @play_board[index[0]][index[1]]

  end


  # def delete_this()

  #   square1 = @play_board[0][0] #a1
  #   square2 = @play_board[5][5] #b1
  #   square3 = @play_board[2][2] #b2
  #   knightbish = Queen.new("player1")
  #   square1.peice = knightbish

  #   knightbish1 = Bishop.new("player1")
  #   square2.peice = knightbish1

  #   knightbish1 = Bishop.new("player2")
  #   square3.peice = knightbish1

  # end





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


