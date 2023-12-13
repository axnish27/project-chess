
module Input_Check

  def available_moves(start)
    start = start.split("?")[0]
    start_square = return_square(start)
    piece = start_square.piece
    piece.board = @play_board
    piece.all_moves
    available_moves = !piece.available_moves.nil? ? piece.available_moves.flatten.uniq : "No available moves for #{peice.name} at #{start}"
    print available_moves
    puts
  end

  def check_input?(start,destination=nil)
    if start.nil?
      puts "Please provide a move."
    elsif start.match?(/\A[s|l|r|q]\z/)
      instructions(start)
    elsif destination.nil? && start.include?("?") && in_board?(start.split("?")[0])
      puts "Available moves for #{start.split("?")[0]}:"
      available_moves(start)
    elsif !in_board?(start) || !in_board?(destination)
      puts "Invalid move. Ensure your move is within the board."
    elsif return_square(start).piece.nil?
      puts "No piece at the specified square."
    elsif @first_move && return_square(start).piece.color == "black"
      puts "white moves first"
    elsif return_square(start).piece.color != @player_turn.color
      puts "#{@player_turn}'s turn to move."
    elsif !return_square(destination).piece.nil? && return_square(destination).piece.name == "King"
      puts "The King cannot be captured."
    else
      @first_move = false
      return true
    end
    return false
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
