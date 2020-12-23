# frozen_string_literal: true

require 'pry'

require_relative 'chess_set'
require_relative 'board_utilities'

# creates, populates, and prints the board
class Board
  include ChessSet
  include BoardUtilities

  attr_accessor :board, :game_over 

  def initialize(start_pos = nil)
    @game_over = false

    # Create & populate the board if not provided
    if start_pos.nil?
      @board = Array.new(8) { Array.new(8) }
      populate('wht')
      populate('blk')
    else
      @board = start_pos
    end
  end

  def create_side(id_array)
    id_array.each do |id|
      create_piece(id)
    end
  end

  def populate(color_str)
    ChessSet.create_pawn_ids(color_str)
    keys = ChessSet::ID.keys.map { |e| e if e.start_with?(color_str) }
    create_side(keys.compact)
  end

  def duplicate
    array = @board.collect { |e| e.dup }
    Board.new(array)
  end

  def create_piece(id)
    sym = ChessSet::ID[id][0]
    pos = ChessSet::ID[id][1]
    class_name = ChessSet::ID[id][2]
    @board[pos[0]][pos[1]] = class_name.new(id, sym, pos)
  end

  def move_piece(piece, destination)
    @board[destination[0]][destination[1]] = piece
    @board[piece.current_pos[0]][piece.current_pos[1]] = nil
  end

  def print_board(command = 'print', available_moves = [], piece_pos = [])
    symbol_array = add_symbols(@board)
    squares_array = add_squares(symbol_array, available_moves)
    format_array = add_labels(squares_array)
    if command == 'print' # this is just for testing
      p format_array
    else
      system('clear') || system('cls')
      render_array(format_array, piece_pos)
    end
  end
end

