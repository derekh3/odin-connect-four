class Board
  def initialize(starting_board = [[nil,nil,nil,nil,nil,nil,nil],
                                   [nil,nil,nil,nil,nil,nil,nil],
                                   [nil,nil,nil,nil,nil,nil,nil],
                                   [nil,nil,nil,nil,nil,nil,nil],
                                   [nil,nil,nil,nil,nil,nil,nil],
                                   [nil,nil,nil,nil,nil,nil,nil]])
    @board = starting_board
  end
  def valid_input?(player_input)
    if player_input.chomp.to_i.to_s == player_input.chomp && player_input.chomp.to_i.between?(1,7)
      if count_in_col(player_input.chomp.to_i - 1) < 6
        return true
      else
        puts "Column is full. Please choose another."
      end
    end
    return false
  end

  def add_piece(whose_turn, processed_input)
    topmost_occupied_row = get_col(processed_input-1).index { |x| x != nil }
    if topmost_occupied_row == nil
      @board[5][processed_input-1] = whose_turn
    else  
      @board[topmost_occupied_row-1][processed_input-1] = whose_turn
    end
  end

  def won?
    @board.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        if piece
          if horizontal_win?(piece, row_index, col_index) ||
          vertical_win?(piece, row_index, col_index) ||
          diagonal_win?(piece, row_index, col_index)
            return true
          end
        end
      end
    end
    return false
  end

  def horizontal_win?(piece, row, col)
    @board[row][col..col+3] == [piece, piece, piece, piece]
  end
  
  def vertical_win?(piece, row, col)
    get_col(col)[row..row+3] == [piece, piece, piece, piece]
  end

  def diagonal_win?(piece, row, col)
    #downward diagonal
    if row+3 <= 5 && [@board[row+1][col+1], @board[row+2][col+2], @board[row+3][col+3]] == [piece, piece, piece]
      return true
    end
    #upward diagonal
    if row-3 >= 0 && [@board[row-1][col+1], @board[row-2][col+2], @board[row-3][col+3]] == [piece, piece, piece]
      return true
    end
  end

  def tie?
    if !@board.flatten.include?(nil)
      return true
    end
    return false
  end

  def display
    @board.each { |row| p row }
  end

  def count_in_col(col_number)
    column = get_col(col_number)
    count = column.reduce(0) do |count, x| 
      if x != nil
        count + 1
      else
        count
      end
    end
    return count
  end

  def get_col(col_number)
    @board.map { |row| row[col_number] }
  end  
  

end