class Square

  attr_accessor :peice,:name ,:co_ordinate

  def initialize(name,co_ordinate)
    @name = name
    @peice = nil
    @co_ordinate = co_ordinate
  end

end


class Board

  attr_accessor :hash, :board

  def initialize
    @hash = {}
    @board = create_board()
  end


  def create_board()
    board = []
    # puts "         White"
    letters = ["a","b","c","d","e","f","g","h"]
    for i in -7..0
      row = []
      x = 0
      letters.each do |letter|
        name = "#{letter}#{i+8}"
        co_ordinate = [i+7,x]
        x += 1
        #print name," "
        square = Square.new(name,co_ordinate)
        row << square
      end
      board << row

    #   puts
    end
    # puts "         Black"
    create_hash(board)
    board
  end




  def create_hash(array_of_objects)
    array_of_objects.each_with_index do |array, row|
      array.each_with_index do |object, column|
        @hash[object.name] = [row,column]
      end
    end
  end


end





class Peice




end


class Rook < Peice

  attr_accessor :player , :name , :current_position , :destination , :can_be_captured

  def initialize(player)

    @name = "rook"
    @player = player
    @current_position = nil
    @destination = nil
    @available_moves = []
    @can_be_captured = []

  end



  def available_moves(play_board)
    @play_board = play_board
    up()
    down()
    left()
    right()
    @available_moves + @can_be_captured



  end


  def up()

    index = @current_position.dup
    square = nil

    while true

      index[0] = index[0] + 1
      square = return_square(index)


      return false if break_if?(square,index[0],7)
      @available_moves << square.name


    end

  end

  def down()
    index = @current_position.dup
    square = nil

    while true
      index[0] = index[0] - 1
      square = return_square(index)


      break if break_if?(square,index[0],0)
      @available_moves << square.name
    end

  end

  def left()

    index = @current_position.dup
    square = nil

    while true
      index[1] = index[1] - 1
      square = return_square(index)


      return false if break_if?(square,index[1],0)
      @available_moves << square.name
    end

  end


  def right()
    index = @current_position.dup
    square = nil
    while true
      index[1] = index[1] + 1
      square = return_square(index)



      return false if break_if?(square,index[1],7)
      @available_moves << square.name
    end

  end

  def break_if?(square,index,stop)
    if !square.peice.nil?
      if !our_peice?(square.peice)
        @can_be_captured << square.name
      end
      return true

    elsif index == stop
        return true
    end
    return false
  end



  def our_peice?(peice)
    peice.player == @player ? true : false
  end



  def return_square(index)

    square = @play_board[index[0]][index[1]]
    square

  end

  def check_valid?()
    #returns true or false
    @destination[1] != @current_position[1] && @destination[0] == @current_position[0] || @destination[1] == @current_position[1] && @destination[0] != @current_position[0] ? true : false

  end

end


class Knight
  attr_accessor :player , :name , :current_position , :destination , :can_be_captured , :board

  def initialize(player)

    @name = "knight"
    @player = player
    @current_position = nil
    @destination = nil
    @possible_moves = []
    @can_be_captured = []
    @available_moves = []
    @board = nil

  end



  def possible_moves()
    verticle_move("-")
    verticle_move("+")
    horizonatal_move("-")
    horizonatal_move("+")
  end


def return_square(index)

  @board[index[0]][index[1]]

end


def our_peice?(peice)
  peice.player == @player ? true : false
end

def verticle_move(up_or_down)
  index = @current_position.dup
  center = num_between(up_or_down == "-" ? index[0] - 2 : index[0] + 2)

  if !center.nil?
    left = num_between(index[1] - 1)
    if !left.nil?
      move_left = return_square([center,left])
      @possible_moves << move_left
    end

    right = num_between(index[1] + 1)
    if !right.nil?
      move_right = return_square([center,right])
      @possible_moves << move_right
    end
  end

end

  def horizonatal_move(up_or_down)
      index = @current_position.dup

      center =  num_between(up_or_down == "-" ? index[1] - 2 : index[1] + 2)

      if !center.nil?

        left = num_between(index[0] + 1)
        if !left.nil?
          move_down = return_square([left,center])
          @possible_moves << move_down
        end

        right = num_between(index[0] - 1)
        if !right.nil?
          move_up = return_square([right,center])
          @possible_moves << move_up
        end

      end


  end

  def num_between(num)
      if num >= 0 && num <= 7
          num
      else
          nil
      end
  end

  def available_moves()
    moves = @possible_moves.dup
    moves.each do |square|
      if square.peice.nil?
        @available_moves << square.name
      elsif !our_peice?(peice)
        @available_moves << square.name
        @can_be_captured << square.name
      end
    end


  end

  def check_valid?

    possible_moves()

    @possible_moves.each do |square|
      return square.co_ordinate == @destination ? true : false
    end
  end

end




class Game

  def initialize
    @board = Board.new()
    @play_board = @board.board
    @find_co_ordinates = @board.hash
    @captured_peices = []

    delete_this()




  end

  def move_peice(start,destination)

    return p "invalid move" if !in_board?(start) || !in_board?(destination)

    start_square = return_square(start)
    destination_square = return_square(destination)

    peice = start_square.peice
    peice.current_position = @find_co_ordinates[start]
    peice.destination = @find_co_ordinates[destination]
    peice.board = @play_board


    return puts"invalid move for the peice" if peice.check_valid? == false

    available_moves = peice.available_moves()


    return puts"invalid move for the peice" if !available_moves.include?(destination)

    @captured_peices << destination_square.peice if peice.can_be_captured.include?(destination)

    destination_square.peice = peice
    start_square.peice = nil

  end


  def capture_peice


  end

  def return_square(square)

    index = @find_co_ordinates[square]
    square = @play_board[index[0]][index[1]]

  end




  def delete_this()

    square1 = @play_board[3][3]
    square2 = @play_board[4][3]
    square3 = @play_board[5][3]
    knightbish = Knight.new("player1")
    square1.peice = knightbish

    knightbish1 = Knight.new("player2")
    square2.peice = knightbish1

    knightbish1 = Knight.new("player1")
    square3.peice = knightbish1

  end





  def in_board?(co_ordinate)

    begin
      index = co_ordinate.split("")
      return true if index.length == 2 && index[1].to_i.between?(1,7) && index[0] in "a".."h"
    rescue NoMethodError
      return false
    end
    false

  end

end


game = Game.new


board = Board.new()
b = board.board
knight = Knight.new("player1")
knight.current_position = [0,0]
knight.destination = [2,1]
knight.board = b
p knight.check_valid?
knight.available_moves
