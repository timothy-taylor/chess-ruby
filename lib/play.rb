require_relative "board"

p board = Board.new
p black = board.create_black_side
#queen = black.create_queen("blk_que_1")
#queen.moves([0, 7])
bishop = black.create_bishop("blk_bsh_1")
bishop.moves

