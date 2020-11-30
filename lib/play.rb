require_relative "board"

move_2 = [ rand(8), rand(8) ]

board = Board.new
player = board.create_knight
player.knight_moves(move_2)
