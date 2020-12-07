require_relative "board"

board = Board.new
board.black.create_pieces
board.white.create_pieces
board.print_board("render")
