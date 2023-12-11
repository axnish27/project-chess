class Square

  attr_accessor :piece,:name ,:co_ordinate

  def initialize(name,co_ordinate)
    @name = name
    @piece = nil
    @co_ordinate = co_ordinate
  end

end


class Board



  attr_accessor :hash, :board

  def initialize(player1,player2)
    @first = true
    @hash = {}
    @board = create_board()
    @player1 = player1
    @player2 = player2
    initialize_board(@player1)
    initialize_board(@player2)
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
      array.each_with_index do |object,column|
        @hash[object.name] = [row,column]
      end
    end
  end



  def initialize_board(player)
    @player = player
    @color = @first ? "white" : "black"
    if @first
      three_piece(0,0,"+")
      three_piece(0,7,"-")
      king_queen(0)
      pawn(1)
      @first = false
    else
      three_piece(7,0,"+")
      three_piece(7,7,"-")
      king_queen(7)
      pawn(6)
      @first = true
    end

  end

  def three_piece(index1,index2,sym)

    square = @board[index1][index2]
    rook = Rook.new(@player,@color)
    square.piece = rook
    rook.current_position = square.co_ordinate

    square1 = @board[index1][sym == "+" ? index2+1 : index2-1]
    knight = Knight.new(@player,@color)
    square1.piece = knight
    knight.current_position = square1.co_ordinate

    square2 = @board[index1][sym == "+" ? index2+2 : index2-2]
    bishop = Bishop.new(@player,@color)
    square2.piece = bishop
    bishop.current_position = square2.co_ordinate

  end

  def king_queen(index1)

    square = @board[index1][3]
    queen = Queen.new(@player,@color)

    square.piece = queen
    queen.current_position = square.co_ordinate

    square = @board[index1][4]
    king = King.new(@player,@color)
    square.piece = king
    king.current_position = square.co_ordinate


  end

  def pawn(index1)
    for i in 0..7
      square = @board[index1][i]
      pawn = Pawn.new(@player,@color)
      square.piece = pawn
      pawn.current_position = square.co_ordinate

    end
  end


end




