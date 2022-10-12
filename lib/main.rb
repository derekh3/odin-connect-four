require './lib/board.rb'

board = Board.new()
whose_turn = 1
loop do
  puts "Player #{whose_turn}, please choose a column number from 1 to 7 to place your piece:"
  player_input = "invalid"
  while !board.valid_input?(player_input)
    player_input = gets
  end
  processed_input = player_input.chomp.to_i
  board.add_piece(whose_turn, processed_input)
  board.display
  if board.won?
    puts "Player #{whose_turn} won the game!"
    break
  end
  if board.tie?
    puts "It's a tie game!"
    break
  end
  whose_turn = whose_turn == 1 ? 2 : 1
end