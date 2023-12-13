module Rules

  def pawn_promotion(square)
    puts "Your Pawn can be promoted input the letter corresponding to the peice u want "
    name = ["r - Rook","k - Knight","b - Bishop","q - Queen"]
    puts name
    piece_classes = {
      'r' => Rook,
      'k' => Knight,
      'q' => Queen,
      'b' => Bishop
    }

    begin
      new_piece = gets.chomp
      piece = piece_classes[new_piece]
      if piece
        piece_instance = piece.new(square.piece.player,square.piece.color)
        piece_instance.current_position = square.co_ordinate
        puts "You selected #{name.find { |s| s.downcase.start_with?(new_piece) }.split(" - ").last}"
      else
        puts "Invalid piece selection"
      end
    rescue => e
      puts "Error: #{e.message}"
      retry
    end
    @pawn_promoted = true
    piece_instance

  end

  def stale_mate(piece,square)
    piece.all_moves.each do |destination|
      stale_mate = simulator_check(square,return_square(destination),piece)
      break if !stale_mate
    end
    stale_mate
  end

  def is_checkmate?()

    player_pieces = @play_board.flatten.find_all do |square|
      if !square.piece.nil?
        square.piece.color == @player_turn.color
      end
    end

    player_pieces.each do |square|
      piece = square.piece
      piece.board = @play_board
      next if piece.all_moves.nil?
      piece.all_moves.each do |destination|
        @checkmate = simulator_check(square,return_square(destination),piece)
        break if !@checkmate
      end
    end

    @checkmate

  end

  def simulator_check(start_square,destination_square,piece)
    temp = destination_square.piece
    temp2 = start_square.piece
    temp3 = destination_square.piece.nil? ? nil : destination_square.piece.current_position

    destination_square.piece = piece
    start_square.piece = nil
    destination_square.piece.current_position = destination_square.co_ordinate

    check = still_check?()

    destination_square.piece = temp
      start_square.piece = temp2
      if !destination_square.piece.nil?
        destination_square.piece.current_position = temp3
      end

    if check
      return true
    else
      return false
    end
  end

  def is_check?(destination)
    piece = destination.piece
    piece.board = @play_board
    piece.all_moves
    piece.can_capture
    check = piece.can_capture.any?{|move| move.piece.name == "King"}
  end

  def still_check?()

    opponent_color = @player_turn == @player1 ? @player2.color : @player1.color
    opponent_pieces = @play_board.flatten.find_all do |square|
      if !square.piece.nil?
        square.piece.color == opponent_color
      end
    end

    opponent_pieces.each do |square|
      piece = square.piece
      piece.board = @play_board
      piece.all_moves
      if !piece.can_capture.compact.empty?
        stil = piece.can_capture.any? {|move| move.piece.name == "King"}
        return stil if stil
      end
    end
    return false
  end

end
