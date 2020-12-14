# frozen_string_literal: true

require 'pry'
require 'pp'

require_relative 'chess_set'
require_relative 'board_utilities'

# creates, populates, and prints the board
class Board
  include ChessSet
  include BoardUtilities

  attr_accessor :board, :game_over

  def initialize
    @game_over = false
    @board = make_board
    @black = create_black_side
    @white = create_white_side
  end

  def make_board
    Array.new(8) { Array.new(8) }
  end

  def print_board(command = 'print', available_moves = [], piece_pos = [])
    symbol_array = add_symbols(@board)
    squares_array = add_squares(symbol_array, available_moves)
    format_array = add_labels(squares_array)
    if command == 'print' # this is just for testing
      pp format_array
    else
      system('clear') || system('cls')
      render_array(format_array, piece_pos)
    end
  end

  def create_black_side
    BlackSide.new(self)
  end

  def create_white_side
    WhiteSide.new(self)
  end
 
  def move_key(x, y, key, n)
    case key
    when 'left'
      [x, y - (n + 1)]
    when 'right'
      [x, y + (n + 1)]
    when 'down'
      [x + (n + 1), y]
    when 'up'
      [x - (n + 1), y]
    when 'upleft'
      [x - (n + 1), y - (n + 1)]
    when 'upright'
      [x - (n + 1), y + (n + 1)]
    when 'downleft'
      [x + (n + 1), y - (n + 1)]
    when 'downright'
      [x + (n + 1), y + (n + 1)]
    end
  end

  def allowable_move?(pos, piece)
    return outside_board?(pos) ? false : true if outside_board?(pos)
    if @board[pos[0]][pos[1]].nil?
      true
    else
      occupied_space = @board[pos[0]][pos[1]]
      same_team?(occupied_space, piece) ? false : true
    end
  end
end

# create black pawn ids, instances of the black pieces, populate the board
class BlackSide < Board
  include ChessSet

  def initialize(board)
    @parent = board
    create_pawn_ids('black')
    black_keys = ID.keys.map { |e| e if e.start_with?('blk') }
    create_side(black_keys.compact, @parent)
  end
end

# create white pawn ids, instances of white pieces, populate the board
class WhiteSide < Board
  include ChessSet

  def initialize(board)
    @parent = board
    create_pawn_ids('white')
    white_keys = ID.keys.map { |e| e if e.start_with?('wht') }
    create_side(white_keys.compact, @parent)
  end
end
