class Square

  attr_accessor :peice,:name

  def initialize(name)
    @name = name
    @peice = nil
  end


end



#array to algebric Notation hash



class Peice

  def in_board?(position)
    #use between
    return true if position[0].between?(0,7) && position[1].between?(0,7)
  end

end


class Rook < Peice

  def initialize(position)
    @current_position = [3,4]

  end

  def check_valid(end_position)

    return "invalid move" if end_position[1] != @current_position[1]
    return "invalid move" if end_position[0] != @current_position[0]

  end

  def available_moves()


  end

  def cut_peice()

  end


  def move(end_position)

    @current_position = end_position

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
    for i in 1..8
      row = []
      letters.each do |letter|
        name = "#{letter}#{i}"
        #print name," "
        name = Square.new(name)
        row << name
      end
      board << row

    #   puts
    end
    # puts "         Black"
    create_hash(board)
    #p board
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
    @find_hash = @board.hash



  end
  def move(start,destination)


    return p "invalid move" if vaid_move?(start) == false && vaid_move?(destination) == false

    start = return_square(start)
    destination = return_square(destination)


    destination.peice = start.peice if destination.peice.nil?

    p return_square("a2")
  end


  def return_square(square)

    index = @find_hash[square]
    square = @play_board[index[0]][index[1]]

  end

  def vaid_move?(cordinate)

    begin
      index = cordinate.split("")
      return true if index.length == 2 && index[1].to_i.between?(1,7) && index[0] in "a".."h"
    rescue NoMethodError
      return false
    end

  end

end


game = Game.new
game.move("a1","a2")
