require_relative 'lib/peice'



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
    @play_board[index[0]][index[1]]

  end




  def delete_this()

    square1 = @play_board[3][3]
    square2 = @play_board[4][3]
    square3 = @play_board[5][3]
    knightbish = Rook.new("player1")
    square1.peice = knightbish

    knightbish1 = Rook.new("player2")
    square2.peice = knightbish1

    knightbish1 = Rook.new("player1")
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
game.move_peice("d4","d7")


# board = Board.new()
# b = board.board
# knight = Knight.new("player1")
# knight.current_position = [0,0]
# knight.destination = [2,1]
# knight.board = b
# p knight.check_valid?
# knight.available_moves
