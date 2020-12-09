# frozen_string_literal: true 

require "pry"
require "tty-table"
require "pastel"
require "pp"

require_relative "chess_set.rb"

class Board
  include ChessSet

  attr_accessor :board, :game_over

  def initialize
    @game_over = false
    @board = make_board
    @black = create_black_side
    @white = create_white_side
  end

  def make_board
    Array.new(8) {Array.new(8)}
  end 

 def print_board(command = "print", highlights = [], piece_pos = [])
    symbol_array = add_symbols(@board) 
    squares_array = add_squares(symbol_array)
    format_array = add_labels(squares_array)
    if command == "print"
      pp format_array
    else
      system("clear") || system("cls")
      render_array(format_array, highlights, piece_pos)
    end
  end

  def add_symbols(array)
    array.map { |row|
      row.map { |element| element.symbol unless element.nil? }
    }
  end

  def add_labels(array)
    numbers = array.each_with_index { |row, i|
      numbers = (1..8).to_a.reverse
      row.unshift(numbers[i])
    }
    numbers << ('a'..'h').to_a.unshift("-")
  end

  def add_squares(array)
    array.map.with_index { |row, i|
      row.map.with_index { |e, j| e || black_or_white?(i, j) }
    }
  end

  def black_or_white?(row, column)
    if (row + column).even?
      "■" 
    elsif (row + column).odd?
      "□"
    end
  end
  
  def render_array(array, highlights, pos)
    pos_col = pos[1] + 1 unless pos.empty?
    pos_row = pos[0]
    pastel = Pastel.new
    table = TTY::Table.new(array)
    puts table.render(:unicode, padding: [0,1]) { |renderer|
      renderer.border.separator = :each_row
      renderer.filter = ->(val, row, col) do
        ( col == pos_col && row == pos_row ) ? pastel.red(val) : val
      end
     # renderer.filter = ->(val, row, col) do
     #   until highlights.empty? || highlights.nil?
     #     element = hightlights.shift
     #     e_col = element[1]
     #     e_row = element[0]
     #     if col == e_col && row == e_row
     #       pastel.red(val)
     #     end
     #   end
     # end
    }
  end
 
  def create_black_side
    BlackSide.new(self)
  end

  def create_white_side
    WhiteSide.new(self)
  end

  def allowable_move?(pos, piece)
    space = @board[pos[0]][pos[1]]
    if pos[0] < 0 || pos[1] < 0
      false
    elsif pos[0] > 8 || pos[1] > 8
      false
    elsif space != nil
      same_team?(space, piece) ? false : true
    else
      true
    end
  end  

  def same_team?(piece_one, piece_two)
    piece_one.id.chr == piece_two.id.chr ? true : false
  end
end

class BlackSide < Board
  include ChessSet

  def initialize(board)
    @parent = board
    create_pawn_ids("black")
    black_keys = ID.keys.map { |e| e if e.start_with?("blk") }
    create_side(black_keys.compact, @parent)
  end
end

class WhiteSide < Board
  include ChessSet

  def initialize(board)
    @parent = board
    create_pawn_ids("white")
    white_keys = ID.keys.map { |e| e if e.start_with?("wht") }
    create_side(white_keys.compact, @parent)
  end
end
