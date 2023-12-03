class Peice

  attr_accessor :player , :current_position , :destination , :can_capture, :board, :available_moves ,:name , :possible_moves, :color

  def initialize(player)

    @name = nil
    @player = player
    @current_position = nil
    @destination = nil
    @board = nil
    @color = nil

  end

  def our_peice?(peice)
    peice.player == @player ? true : false
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

    @possible_moves.each do |square|
      return true if square.co_ordinate == @destination
    end
    return false
  end

end


class Rook < Peice

  def initialize(player)
    super
    @name = "Rook"
  end

  def up()
    index = @current_position.dup
    square = nil

    while true
      index[0] = index[0] + 1
      begin
        square = return_square(index)
      rescue NoMethodError
        return false
      end
      return false if break_if?(square,index[0],8)
      @available_moves << square.name
    end

  end

  def down()
    index = @current_position.dup
    square = nil

    while true
      index[0] = index[0] - 1
      begin
        square = return_square(index)
      rescue NoMethodError
        return false
      end
      break if break_if?(square,index[0],-1)
      @available_moves << square.name
    end

  end

  def left()

    index = @current_position.dup
    square = nil

    while true
      index[1] = index[1] - 1
      begin
        square = return_square(index)
      rescue NoMethodError
        return false
      end
      return false if break_if?(square,index[1],-1)
      @available_moves << square.name
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
    end

  end

  def break_if?(square,index,stop)

    begin
      if !square.peice.nil?
        if !our_peice?(square.peice)
          @can_capture << square
        end
        return true
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
    @available_moves + @can_capture
  end

  def check_valid?()
    all_moves()
    #returns true or false
    @destination[1] != @current_position[1] && @destination[0] == @current_position[0] || @destination[1] == @current_position[1] && @destination[0] != @current_position[0] ? true : false

  end

end


class Knight < Peice

  def initialize(player)
    super
    @name = "knight"

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
  end

  def create_moves()

    moves = @possible_moves.dup
    moves.each do |square|
      if square.peice.nil?
        @available_moves << square.name
      elsif !our_peice?(square.peice)
        @available_moves << square.name
        @can_capture << square
      end
    end
  end

end

# class Bishop < Peice


#   def initialize(player)
#     super
#     @name = "Bishop"

#   end

#   def up
#     index = @current_position.dup
#     square = nil

#     while true
#       break if index[0] == 7
#       index = index.map{|index| index + 1}

#       square = return_square(index)
#       @possible_moves << square

#     end
#   end

#   def down
#     index = @current_position.dup
#     square = nil

#     while true
#       break if index[1] == 0
#       index = index.map{|index| index - 1}
#       square = return_square(index)
#       @possible_moves << square

#     end
#   end

#   def left()
#     index = @current_position.dup
#     square = nil

#     while true
#       break if index[1] == 0
#       index[0] = index[0] + 1
#       index[1] = index[1] - 1
#       break if index[0] == 8
#       square = return_square(index)
#       @possible_moves << square

#     end
#   end


#   def right()
#     index = @current_position.dup
#     square = nil

#     while true
#       break if index[0] == 0
#       index[1] = index[1] + 1
#       index[0] = index[0] - 1
#       square = return_square(index)
#       @possible_moves << square

#     end
#   end

#   def create_moves()
#     moves = @possible_moves.dup

#     moves.each do |square|
#       if square.peice.nil?
#         @available_moves << square.name
#       elsif !our_peice?(square.peice)
#         @available_moves << square.name
#         @can_capture << square
#       end
#     end
#   end

#   def all_moves()
#     @possible_moves = []
#     @available_moves = []
#     @can_capture = []
#     up()
#     down()
#     left()
#     right()
#     create_moves()
#   end

# end


class Queen < Peice

  def initialize(player)
    super
    @name = "Queen"
    @rook = Rook.new(@player)

  end

  def create_moves()
    @possible_moves = []
    @available_moves = []
    @can_capture = []

    # @bishop = Bishop.new(@player)
    # @bishop.current_position = @current_position
    # @bishop.destination = @destination
    # @bishop.board = @board
    # @bishop.check_valid?

    # @available_moves << @bishop.available_moves
    # @can_capture << @bishop.can_capture


    @rook.current_position = @current_position
    @rook.board = @board

    @available_moves << @rook.available_moves
    @can_capture << @rook.can_capture

    @available_moves = @available_moves.flatten
    @can_capture = @can_capture.flatten

  end

  def all_moves()
    create_moves()


  end


  def check_valid?
    @rook.destination = @destination
    @rook.check_valid?
    create_moves()
    return true if @bishop.check_valid? || @rook.check_valid?
    false
  end

end


class Pawn < Peice


  def initialize(player)
    super
    @name = "Pawn"

  end



  def create_moves()
    index = @current_position.dup
    if @color == "white" && index[1] == 1 || @color == "white" && index[1] == 7
      2.times do
        code()
      end
    else
      code()
    end

  end

  def code()
    index = @current_position.dup
    square = nil
    index[0] = @color == "white" ? index[0] + 1 : index[0] - 1
    square = return_square(index)
    @available_moves << square.name
    @possible_moves << square
  end


  def can_be_captured()

    index = @current_position.dup
    left = @color == "white" ? index.map{|index| index + 1} : index.map{|index| index - 1}
    square = return_square(left)
    if !square.nil?
      if !square.peice.nil?
        @can_capture << square if !our_peice?(square.peice)
        @possible_moves << square
      end
    end

    left[1] = left[1] - 2
    right = left
    square = return_square(right)
    if !square.peice.nil?
      @can_capture << square if !our_peice?(square.peice)
      @possible_moves << square
    end


  end

  def all_moves()
    @possible_moves = []
    @available_moves = []
    @can_capture = []
    create_moves()
    can_be_captured()
    @available_moves << @can_capture
  end

end

class King < Peice

  def initialize(player)
    super
    @name = "King"


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
          if square.peice.nil?
            @available_moves << square.name
          elsif !our_peice?(square.peice)
            @available_moves << square.name
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
    @available_moves << @can_capture

  end

end
