def create_board()
  board = []
  puts "         White"
  letters = ["a","b","c","d","e","f","g","h"]
  for i in 1..8
    row = []
    letters.each do |letter|
      print "#{letter}#{i} "
      row << "#{letter},#{i}"
    end
    board << row

    puts
  end
  puts "         Black"
  end

  create_board




