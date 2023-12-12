class Piece

  attr_accessor :player , :current_position , :destination , :can_capture, :board, :available_moves ,:name , :possible_moves, :color , :symbol

  def initialize(player,color)

    @player = player
    @current_position = nil
    @destination = nil
    @board = nil
    @color = color
    @available_moves_co = []


  end

  def our_piece?(piece)
    piece.player == @player ? true : false
  end


  def return_square(index)
    @board[index[0]][index[1]]

  end


  def num_between(num)
    if num >= 0 && num <= 7
        num
    else
        nil
    end
  end

  def check_valid?()
    all_moves()

    @available_moves_co.each do |co_ordinate|
      return true if co_ordinate == @destination
    end
    return false
  end

end


class Rook < Piece

  def initialize(player,color)
    super
    @name = "Rook"
    @symbol = @color == "black" ? "♖" : "♜"


end

  def up()

    index = @current_position.dup
    square = nil

    while true
      index[0] = index[0] + 1
      begin
        square = return_square(index)
      rescue NoMethodError
        break
      end
      break if break_if?(square,index[0],8)
      @available_moves << square.name
      @available_moves_co << square.co_ordinate
    end

  end

  def down()
    index = @current_position.dup
    square = nil

    while true
      break if index[0] == 0
      index[0] = index[0] - 1
      begin
        square = return_square(index)
      rescue NoMethodError
        return false
      end
      break if break_if?(square,index[0],-1)
      @available_moves << square.name
      @available_moves_co << square.co_ordinate
    end

  end

  def left()

    index = @current_position.dup
    square = nil

    while true
      break if index[1] == 0
      index[1] = index[1] - 1
      begin
        square = return_square(index)
      rescue NoMethodError
        return false
      end
      return false if break_if?(square,index[1],-1)
      @available_moves << square.name
      @available_moves_co << square.co_ordinate
    end

  end


  def right()
    index = @current_position.dup
    square = nil

    while true
      index[1] = index[1] + 1
      begin
        square = return_square(index)
      rescue NoMethodError
        return false
      end
      return false if break_if?(square,index[1],8)
      @available_moves << square.name
      @available_moves_co << square.co_ordinate
    end

  end

  def break_if?(square,index,stop)

    begin
      if !square.piece.nil?
        if our_piece?(square.piece)
          return true
        else
          @can_capture << square
          return false
        end
      elsif index == stop
        return true
      end
    rescue NoMethodError
      return true
    else
      return false
    end


  end

  def all_moves()
    @possible_moves = []
    @available_moves = []
    @can_capture = []
    up()
    down()
    left()
    right()
    @available_moves
  end

  def check_valid?()
    all_moves()
    #returns true or false
    @destination[1] != @current_position[1] && @destination[0] == @current_position[0] || @destination[1] == @current_position[1] && @destination[0] != @current_position[0] ? true : false

  end

end


class Knight < Piece

  def initialize(player,color)
    super
    name = "knight"
    @symbol = @color == "black" ? "♘" : "♞"


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

  def all_moves()
    @possible_moves = []
    @available_moves = []
    @can_capture = []
    verticle_move("-")
    verticle_move("+")
    horizonatal_move("-")
    horizonatal_move("+")
    create_moves()
    @available_moves
  end

  def create_moves()

    moves = @possible_moves.dup
    moves.each do |square|
      if square.piece.nil?
        @available_moves << square.name
        @available_moves_co << square.co_ordinate
      elsif !our_piece?(square.piece)
        @available_moves << square.name
        @available_moves_co << square.co_ordinate
        @can_capture << square
      end
    end
  end

end

class Bishop < Piece

  def initialize(player,color)
    super
   @name = "Bishop"
   @symbol = @color == "black" ? "♗" : "♝"

  end

  def up
    index = @current_position.dup
    square = nil

    while true

      index = index.map{|index| index + 1}
      begin
        square = return_square(index)
      rescue NoMethodError
        return false
      end
      return false if break_if?(square, index[0], 8)
      @available_moves << square.name
      @available_moves_co << square.co_ordinate
    end

  end

  def down
    index = @current_position.dup
    square = nil

    while true
      break if index[1] == 0
      index = index.map{|index| index - 1}
      begin
        square = return_square(index)
      rescue NoMethodError
        return false
      end
      return false if break_if?(square, index[1], -1)
      @available_moves << square.name
      @available_moves_co << square.co_ordinate

    end
  end

  def left()
    index = @current_position.dup
    square = nil

    while true
      break if index[1] == 0
      index[0] = index[0] + 1
      index[1] = index[1] - 1
      begin
        square = return_square(index)
      rescue NoMethodError
        return false
      end
      return false if break_if?(square, index[1], -1)
      @available_moves << square.name
      @available_moves_co << square.co_ordinate

    end
  end


  def right()
    index = @current_position.dup
    square = nil

    while true
      break if index[0] == 0
      index[1] = index[1] + 1
      index[0] = index[0] - 1
      begin
        square = return_square(index)
      rescue NoMethodError
        return false
      end
      return false if break_if?(square, index[0],-1 )
      @available_moves << square.name
      @available_moves_co << square.co_ordinate

    end
  end

  def break_if?(square,index,stop)

    begin
      if !square.piece.nil?
        if !our_piece?(square.piece)
          @can_capture << square
          return false
        else
          return true
        end
      elsif index == stop
        return true
      end
    rescue NoMethodError
      return true
    else
      return false
    end

  end

  def all_moves()
    @possible_moves = []
    @available_moves = []
    @can_capture = []
    up()
    down()
    left()
    right()
    @available_moves

  end

end


class Queen < Piece

  def initialize(player,color)
    super
    name = "Queen"
    @symbol = @color == "black" ? "♕" : "♛"

    @rook = Rook.new(@player,@color)
    @bishop = Bishop.new(@player,@color)

  end

  def create_moves()
    @possible_moves = []
    @available_moves = []
    @can_capture = []


    @bishop.current_position = @current_position
    @bishop.board = @board
    @bishop.all_moves


    @available_moves << @bishop.available_moves
    @can_capture << @bishop.can_capture


    @rook.board = @board
    @rook.current_position = @current_position
    @rook.all_moves

    @available_moves << @rook.available_moves
    @can_capture << @rook.can_capture

    @available_moves = @available_moves.flatten.uniq
    @can_capture = @can_capture.flatten.uniq

  end

  def all_moves()
    create_moves()
    @available_moves

  end


  def check_valid?

    @rook.current_position = @current_position
    @rook.destination = @destination
    rook_check = @rook.check_valid?
    p rook_check

    @bishop.current_position = @current_position
    @bishop.destination = @destination


    create_moves()
    return true if @bishop.check_valid? || rook_check
    false
  end

end


class Pawn < Piece


  def initialize(player,color)
    super
    @name = "Pawn"
    @symbol = @color == "black" ? "♙" : "♟"

  end



  def create_moves()
    index = @current_position.dup
    if @color == "white" && index[0] == 1 || @color == "black" && index[0] == 6
      2.times do
        code(index)

      end
    else
      code(index)
    end

  end

  def code(index)
    square = nil
    index[0] = @color == "white" ? index[0] + 1 : index[0] - 1
    square = return_square(index)
    if square.piece.nil?
      @available_moves << square.name
      @available_moves_co << square.co_ordinate
    end
      # @possible_moves << square
  end


  def can_be_captured()

    index = @current_position.dup
    left = @color == "white" ? index.map{|index| index + 1} : index.map{|index| index - 1}
    square = return_square(left)
    if !square.nil?
      if !square.piece.nil?
        @can_capture << square if !our_piece?(square.piece)
        @available_moves << square.name
        @available_moves_co << square.co_ordinate

        # @possible_moves << square
      end
    end

    left[1] = left[1] - 2
    right = left
    square = return_square(right)
    if !square.piece.nil?
      @can_capture << square if !our_piece?(square.piece)
      @available_moves << square.name
      @available_moves_co << square.co_ordinate
      # @possible_moves << square
    end


  end

  def all_moves()
    @possible_moves = []
    @available_moves = []
    @can_capture = []
    create_moves()
    can_be_captured()
    @available_moves
  end

end

class King < Piece

  def initialize(player,color)
    super
    @name = "King"
    @symbol = @color == "black" ? "♔" : "♚"


  end

  def create_moves()
    square = nil
    index = @current_position.dup
    arr = []
    index.each { |num| arr << num}

    arr << index[0] + 1 #if index[0] + 1 >= 0 && index[0] + 1 <= 7


    while arr.any?

      for i in (index[1]-1..index[1]+1)
      move =[arr[0],i]
        if move[0].between?(0,7) && move[1].between?(0,7)
          square = return_square(move)
          @possible_moves << square
          if square.piece.nil?
            @available_moves << square.name
            @available_moves_co << square.co_ordinate
          elsif !our_piece?(square.piece)
            @available_moves << square.name
            @available_moves_co << square.co_ordinate
            @can_capture << square
          end
        end
      end
      arr.shift
    end

    @available_moves = @available_moves - [return_square(@current_position).name]

  end

  def all_moves()
    @possible_moves = []
    @available_moves = []
    @can_capture = []
    create_moves()
    @available_moves

  end

end
