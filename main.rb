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



#array to algebric Notation hash



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
    @available_moves



  end


  def up()

    index = @current_position.dup
    square = nil

    while true

      index[0] = index[0] + 1
      square = return_square(index)
      @available_moves << square.name

      return false if break_check?(square,index[0],7)

    end

  end

  def down()
    index = @current_position.dup
    square = nil

    while true
      index[0] = index[0] - 1
      square = return_square(index)
      @available_moves << square.name

      break if break_check?(square,index[0],0)
    end

  end

  def left()

    index = @current_position.dup
    square = nil

    while true
      index[1] = index[1] - 1
      square = return_square(index)
      @available_moves << square.name

      return false if break_check?(square,index[1],0)
    end

  end


  def right()
    index = @current_position.dup
    square = nil
    while true
      index[1] = index[1] + 1
      square = return_square(index)

      @available_moves << square.name

      return false if break_check?(square,index[1],7)
    end

  end

  def break_check?(square,index,stop)
    if square.peice.nil? == false && !our_peice?(square.peice)
      @can_be_captured << square.name
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

  def check_valid()

    return false if @destination[1] != @current_position[1] || @destination[0] != @current_position[0]

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

    return puts"invalid move for the peice" if !peice.check_valid

    available_moves = peice.available_moves(@play_board)

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
    square2 = @play_board[6][3]
    rookbish = Rook.new("player1")
    square1.peice = rookbish

    rookbish1 = Rook.new("player2")
    square2.peice = rookbish1

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


game.move_peice("d4","d7")
