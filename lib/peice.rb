class Peice

  attr_accessor :player , :current_position , :destination , :can_be_captured, :board

  def initialize(player)

    @player = player
    @current_position = nil
    @destination = nil
    @available_moves = []
    @can_be_captured = []
    @board = nil

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


end


class Rook < Peice

  attr_accessor :player , :name , :current_position , :destination , :can_be_captured

  def initialize(player)

    @name = "rook"
    super

  end



  def available_moves
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


      return false if break_if?(square,index[0],8)
      @available_moves << square.name


    end

  end

  def down()
    index = @current_position.dup
    square = nil

    while true
      index[0] = index[0] - 1
      square = return_square(index)


      break if break_if?(square,index[0],-1)
      @available_moves << square.name
    end

  end

  def left()

    index = @current_position.dup
    square = nil

    while true
      index[1] = index[1] - 1
      square = return_square(index)


      return false if break_if?(square,index[1],-1)
      @available_moves << square.name
    end

  end


  def right()
    index = @current_position.dup
    square = nil
    while true
      index[1] = index[1] + 1
      square = return_square(index)



      return false if break_if?(square,index[1],8)
      @available_moves << square.name
    end

  end

  def break_if?(square,index,stop)

    begin
    if !square.peice.nil?
      if !our_peice?(square.peice)
        @can_be_captured << square.name
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





  def check_valid?()
    #returns true or false
    @destination[1] != @current_position[1] && @destination[0] == @current_position[0] || @destination[1] == @current_position[1] && @destination[0] != @current_position[0] ? true : false

  end

end


class Knight < Peice

  def initialize(player)

    @name = "knight"
    @possible_moves = []

  end



  def possible_moves()
    verticle_move("-")
    verticle_move("+")
    horizonatal_move("-")
    horizonatal_move("+")
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

