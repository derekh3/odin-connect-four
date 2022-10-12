require './lib/main.rb'

context "Test the input" do
  before do
    allow($stdin).to receive(:gets).and_return("1")
    allow(board).to receive(:won?).and_return(true)
    allow(board).to receive(:tie?).and_return(false)
    allow(board).to receive(:valid_input?).and_return(true)
  end
  it "gets input and then ends the game because someone won" do
    expect(board).to receive(:add_piece)
  end

end