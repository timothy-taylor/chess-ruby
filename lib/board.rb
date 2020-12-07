# frozen_string_literal: true 

require "pry"
require "tty-table"
require "pastel"
require "pp"

require_relative "chess_set.rb"

class Board
  include ChessSet

  attr_accessor :board, :black, :white

  def initialize
    @board = make_board
    @black = create_black_side
    @white = create_white_side
  end

  def make_board
    Array.new(8) {Array.new(8)}
  end 

 def print_board(command = "print")
    array = @board.map { |row|
      row.map { |element| element.symbol unless element.nil? }
    }
    format = array.map.with_index { |row, i|
      row.map.with_index { |e, j| e || add_squares(i, j) }
    }
    if command == "print"
      pp format
    else
      render_array(format)
    end
  end

  def add_squares(row, column)
    if (row + column).even?
      "□"
    elsif (row + column).odd?
      "■"
    end
  end
  
  def render_array(array)
    table = TTY::Table.new(array)
    puts table.render(:unicode, padding: [0,1]) { |renderer|
      renderer.border.separator = :each_row
    }
  end
 
  def create_black_side
    BlackSide.new(self)
  end

  def create_white_side
    WhiteSide.new(self)
  end

  def allowable_move?(pos)
    if pos[0] < 0 || pos[1] < 0
      false
    elsif pos[0] > 8 || pos[1] > 8
      false
    else
      true
    end
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
