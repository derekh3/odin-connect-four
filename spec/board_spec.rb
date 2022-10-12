require './lib/board.rb'

describe Board do
  subject(:board) { Board.new() }
  describe "#valid_input?" do
    context "given a player input for an empty board" do

      before do
        allow(board).to receive(:count_in_col).and_return(0)
      end
      it "treats '1' as a valid input" do
        player_input = "1"
        expect(board.valid_input?(player_input)).to eq(true)
      end
      it "treats '0' as invalid input" do
        player_input = "0"
        expect(board.valid_input?(player_input)).to eq(false)
      end
      it "treats 'a' as invalid input" do
        player_input = "a"
        expect(board.valid_input?(player_input)).to eq(false)
      end
      it "treats '8' as invalid input" do
        player_input = "8"
        expect(board.valid_input?(player_input)).to eq(false)
      end
      it "treats '1\n' as a valid input" do
        player_input = "1\n"
        expect(board.valid_input?(player_input)).to eq(true)
      end
    end

    context "when a column is full" do
      before do
        allow(board).to receive(:count_in_col).and_return(6)
      end
      it "treats '1\n' as invalid input and says column is full" do
        player_input = "1\n"
        expect(board.valid_input?(player_input)).to eq(false)
        expect { board.valid_input?(player_input) }.to output("Column is full. Please choose another.\n").to_stdout
      end
      it "treats '9\n' as invalid input and does not output anything" do
        player_input = "9\n"
        expect(board.valid_input?(player_input)).to eq(false)
        expect { board.valid_input?(player_input) }.to_not output.to_stdout
      end
    end

  end
  
  describe "#add_piece" do
    context "when adding to the last column of an empty board" do
      it "updates the @board variable" do
        board.add_piece(1, 7)
        expected_board_var = [[nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,1]]
        actual_board_var = board.instance_variable_get(:@board)
        expect(expected_board_var).to eq(actual_board_var)
      end
    end
    context "when adding to the first column of an empty board" do
      it "updates the @board variable" do
        board.add_piece(2, 1)
        expected_board_var = [[nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil],
                    [2,nil,nil,nil,nil,nil,nil]]
        actual_board_var = board.instance_variable_get(:@board)
        expect(expected_board_var).to eq(actual_board_var)
      end
    end
    context "when adding second piece to the first column" do
      before do
        board.add_piece(1,1)
      end
      it "updates the @board variable" do
        board.add_piece(2, 1)
        expected_board_var = [[nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil],
                    [2,nil,nil,nil,nil,nil,nil],
                    [1,nil,nil,nil,nil,nil,nil]]
        actual_board_var = board.instance_variable_get(:@board)
        expect(actual_board_var).to eq(expected_board_var)
      end
    end
    context "when adding multiple pieces to multiple columns" do
      before do
        board.add_piece(1,1)
        board.add_piece(2, 1)
        board.add_piece(1, 4)
        board.add_piece(2, 4)
        board.add_piece(1, 4)
        board.add_piece(2, 5)
      end
      it "updates the @board variable" do
        
        expected_board_var = [[nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,1,nil,nil,nil],
                    [2,nil,nil,2,nil,nil,nil],
                    [1,nil,nil,1,2,nil,nil]]
        actual_board_var = board.instance_variable_get(:@board)
        expect(actual_board_var).to eq(expected_board_var)
      end
    end
  end

  describe "#won?" do
    context "an empty board" do
      it "has not won" do
        expect(board.won?).to eq(false)
      end
    end

    context "four in a horizontal row of the same kind on the bottom" do
      before do
        board.add_piece(1, 2)
        board.add_piece(1, 3)
        board.add_piece(1, 4)
        board.add_piece(1, 5)
      end
      it "has won" do
        expect(board.won?).to eq(true)
      end
    end

    context "four in a horizontal row of different kinds on the bottom" do
      before do
        board.add_piece(1, 2)
        board.add_piece(2, 3)
        board.add_piece(1, 4)
        board.add_piece(2, 5)
      end
      it "has not won" do
        expect(board.won?).to eq(false)
      end
    end

    context "four in a vertical row of the same kind in first column" do
      before do
        board.add_piece(1, 1)
        board.add_piece(1, 1)
        board.add_piece(1, 1)
        board.add_piece(1, 1)
      end
      it "has won" do
        expect(board.won?).to eq(true)
      end
    end    

    context "four in a vertical row of the same kind in first column, stacked on top" do
      before do
        board.add_piece(2, 1)
        board.add_piece(2, 1)
        board.add_piece(1, 1)
        board.add_piece(1, 1)
        board.add_piece(1, 1)
        board.add_piece(1, 1)
      end
      it "has won" do
        expect(board.won?).to eq(true)
      end
    end    

    context "four in a vertical row of different kinds in first column" do
      before do
        board.add_piece(1, 1)
        board.add_piece(2, 1)
        board.add_piece(1, 1)
        board.add_piece(2, 1)
      end
      it "has won" do
        expect(board.won?).to eq(false)
      end
    end  

    context "four of a kind in a downward diagonal" do
      before do
        board.add_piece(2, 1)
        board.add_piece(2, 1)
        board.add_piece(2, 1)
        board.add_piece(1, 1)

        board.add_piece(2, 2)
        board.add_piece(2, 2)
        board.add_piece(1, 2)

        board.add_piece(2, 3)
        board.add_piece(1, 3)

        board.add_piece(1, 4)
      end
      it "has won" do
        expect(board.won?).to eq(true)
      end
    end

    context "four of a kind in an upward diagonal" do
      before do
        board.add_piece(2, 4)
        board.add_piece(2, 4)
        board.add_piece(2, 4)
        board.add_piece(1, 4)

        board.add_piece(2, 3)
        board.add_piece(2, 3)
        board.add_piece(1, 3)

        board.add_piece(2, 2)
        board.add_piece(1, 2)

        board.add_piece(1, 1)
      end
      it "has won" do
        expect(board.won?).to eq(true)
      end
    end

  end

  describe "#tie?" do
    context "an empty board" do
      it "is not a tie" do
        expect(board.tie?).to eq(false)
      end
    end

    context "a full board" do
      before do
        board.add_piece(1, 1)
        board.add_piece(2, 1)
        board.add_piece(1, 1)
        board.add_piece(2, 1)
        board.add_piece(1, 1)
        board.add_piece(2, 1)

        board.add_piece(2, 2)
        board.add_piece(1, 2)
        board.add_piece(2, 2)
        board.add_piece(1, 2)
        board.add_piece(2, 2)
        board.add_piece(1, 2)

        board.add_piece(1, 3)
        board.add_piece(2, 3)
        board.add_piece(1, 3)
        board.add_piece(2, 3)
        board.add_piece(1, 3)
        board.add_piece(2, 3)

        board.add_piece(2, 4)
        board.add_piece(1, 4)
        board.add_piece(2, 4)
        board.add_piece(1, 4)
        board.add_piece(2, 4)
        board.add_piece(1, 4)

        board.add_piece(1, 5)
        board.add_piece(2, 5)
        board.add_piece(1, 5)
        board.add_piece(2, 5)
        board.add_piece(1, 5)
        board.add_piece(2, 5)

        board.add_piece(2, 6)
        board.add_piece(1, 6)
        board.add_piece(2, 6)
        board.add_piece(1, 6)
        board.add_piece(2, 6)
        board.add_piece(1, 6)

        board.add_piece(1, 7)
        board.add_piece(2, 7)
        board.add_piece(1, 7)
        board.add_piece(2, 7)
        board.add_piece(1, 7)
        board.add_piece(2, 7)
      end
      it "is a tie" do
        expect(board.tie?).to eq(true)
      end
    end
  end


end