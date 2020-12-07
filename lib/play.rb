require_relative "board"

board = Board.new
black = board.create_black_side
pawn = black.create_pawn("blk_pwn_1")
pawn.moves([3,0])
