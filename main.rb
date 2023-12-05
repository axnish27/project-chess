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

  def check_input?(start,destination=nil)
    if start.nil?
      puts "Input Move"
      return false
    elsif destination.nil? && start.include?("?") && in_board?(start.split("?")[0])
      puts available_moves()
      return false
    elsif !in_board?(start) || !in_board?(destination)
      puts "invalid move"
      return false
    elsif return_square(start).nil?
      puts "no peice at the square "
      return false
    elsif @first_move && return_square(start).peice.color == "black"
      puts "white moves first"
      return false
    elsif return_square(start).peice.color != @player_turn
      puts "#{@player_turn}'s moves"
      return false
    end
    @first_move = false
    true
  end


  def still_check?()



    opponent = @player_turn  == "white" ? "black" : "white"

    opponent_peices = @play_board.flatten.find_all do |square|
      if !square.peice.nil?
        square.peice.color == opponent
      end
    end

    opponent_peices.each do |square|
      peice = square.peice
      peice.board = @play_board
      peice.all_moves
      if !peice.can_capture.compact.empty?
        stil = peice.can_capture.any? {|move| move.peice.name == "King"}
        return stil if stil
      end
    end
    return false
  end

  def is_check?(destination)

    start_square = return_square(destination)
    peice = start_square.peice
    peice.board = @play_board
    peice.all_moves
    peice.can_capture
    check = peice.can_capture.any?{|move| move.peice.name == "King"}
    check

  end

  def move_peice(start,destination=nil)

    # while
    #   turn
    # end
    return if !check_input?(start, destination)

    start_square = return_square(start)
    destination_square = return_square(destination)
    peice = start_square.peice



    peice.destination = @find_co_ordinates[destination]
    peice.board = @play_board

    return puts"invalid move for the peice check" if !peice.check_valid?

    available_moves = peice.available_moves.flatten.uniq

    return puts"invalid move for the peice" if !available_moves.include?(destination)

    #find a way to put all of this
    p "a",@check
    if @check == true
      return puts "still in check " if simulator_check(start_square,destination_square,peice)

    end

    destination_square.peice = peice
    start_square.peice = nil
    destination_square.peice.current_position = destination_square.co_ordinate



    @check = is_check?(destination_square.name)
    p @check
    #checking if checkmade
    if @check

      player_peices = @play_board.flatten.find_all do |square|
        if !square.peice.nil?
          square.peice.color == @player
        end
      end

      checkmate = true
      player_peices.each do |square|
        peice = square.peice
        peice.board = @play_board
        peice.all_moves.each do |destination|
          checkmate = simulator_check(square,square,return_square(destination),peice)
          break if !checkmate
        end
        puts(checkmate)
      end

    end


    puts "moved"

    @player_turn = @player_turn  == "white" ? "black" : "white"

  end

  def simulator_check(start_square,destination_square,peice)
    temp = destination_square.peice
    temp2 = start_square.peice
    temp3 = destination_square.peice.nil? ? nil : destination_square.peice.current_position

    destination_square.peice = peice
    start_square.peice = nil
    destination_square.peice.current_position = destination_square.co_ordinate

    check = still_check?()

    destination_square.peice = temp
      start_square.peice = temp2
      if !destination_square.peice.nil?
        destination_square.peice.current_position = temp3
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

    # square1 = @play_board[1][4]
    # square2 = @play_board[5][0]
    # square3 = @play_board[2][3]
    # square4 = @play_board[0][3]
    # square5 = @play_board[0][5]

    # square1.peice = nil
    # square4.peice = nil
    # square5.peice = nil

    # knightbish1 = Rook.new("player2")
    # knightbish1.color = "black"
    # square2.peice = knightbish1
    # knightbish1.current_position = square2.co_ordinate

    # knightbish2 = Rook.new("player1")
    # knightbish2.color = "white"
    # square3.peice = knightbish2
    # knightbish2.current_position = square2.co_ordinate

    @play_board[1][4].piece = nil
    @play_board[3][4].piece = nil
    @play_board[1][3].piece = nil
    @play_board[3][3].piece = nil

    #try fools mate if check mate u got it


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


