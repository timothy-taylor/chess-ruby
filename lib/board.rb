# frozen_string_literal: true 

require "pry"
require "tty-table"
require "pastel"

require_relative "chess_set.rb"
require_relative "pieces/knight.rb"
require_relative "pieces/rook.rb"
require_relative "pieces/bishop.rb"
require_relative "pieces/queen.rb"
require_relative "pieces/king.rb"
require_relative "pieces/pawn.rb"

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
      row.map { |e| e.symbol unless e.nil? }
    }
    format = array.map.with_index { |row, i|
      row.map.with_index { |e, j| e || format_board(i, j) }
    }
    if command == "print"
      p format
    else
      render_array(format)
    end
  end

  def format_board(row, element)
    if (row + element).even?
      "□"
    elsif (row + element).odd?
      "■"
    end
  end
  
  def render_array(array)
    pastel = Pastel.new
    table = TTY::Table.new(array)
    puts table.render(:unicode, padding: [0,1]) { |renderer|
      renderer.border.separator = :each_row
      #renderer.filter = ->(val, row_index, col_index) do
      #  col_index % 2 == 1 ? pastel.red.on_green(val) : val
      #end
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
  end

  def create_pieces
    create_knight("blk_kht_1")
    create_knight("blk_kht_2")
    create_rook("blk_rok_1")
    create_rook("blk_rok_2") 
    create_bishop("blk_bsh_1")
    create_bishop("blk_bsh_2")
    create_queen("blk_que_1")
    create_king("blk_kng_1")
    8.times do |n| 
      id = "blk_pwn_#{n+1}"
      create_pawn(id)
    end
  end

  def create_knight(id)
    sym = ID[id][0]
    pos = ID[id][1]
    @parent.board[pos[0]][pos[1]] = Knight.new(id, @parent, sym, pos)
  end

  def create_rook(id)
    sym = ID[id][0]
    pos = ID[id][1]
    @parent.board[pos[0]][pos[1]] = Rook.new(id, @parent, sym, pos)
  end

  def create_bishop(id)
    sym = ID[id][0]
    pos = ID[id][1]
    @parent.board[pos[0]][pos[1]] = Bishop.new(id, @parent, sym, pos)
  end

  def create_king(id)
    sym = ID[id][0]
    pos = ID[id][1]
    @parent.board[pos[0]][pos[1]] = King.new(id, @parent, sym, pos)
  end

  def create_queen(id)
    sym = ID[id][0]
    pos = ID[id][1]
    @parent.board[pos[0]][pos[1]] = Queen.new(id, @parent, sym, pos)
  end

  def create_pawn(id)
    sym = ID[id][0]
    pos = ID[id][1]
    @parent.board[pos[0]][pos[1]] = Pawn.new(id, @parent, sym, pos)
  end
end

class WhiteSide < Board
  include ChessSet

  def initialize(board)
    @parent = board
    create_pawn_ids("white")    
  end

  def create_pieces
    create_knight("wht_kht_1")
    create_knight("wht_kht_2")
    create_rook("wht_rok_1")
    create_rook("wht_rok_2") 
    create_bishop("wht_bsh_1")
    create_bishop("wht_bsh_2")
    create_queen("wht_que_1")
    create_king("wht_kng_1")
    8.times do |n| 
      id = "wht_pwn_#{n+1}"
      create_pawn(id)
    end
  end

  def create_knight(id)
    sym = ID[id][0]
    pos = ID[id][1]
    @parent.board[pos[0]][pos[1]] = Knight.new(id, @parent, sym, pos)
  end

  def create_rook(id)
    sym = ID[id][0]
    pos = ID[id][1]
    @parent.board[pos[0]][pos[1]] = Rook.new(id, @parent, sym, pos)
  end

  def create_bishop(id)
    sym = ID[id][0]
    pos = ID[id][1]
    @parent.board[pos[0]][pos[1]] = Bishop.new(id, @parent, sym, pos)
  end

  def create_king(id)
    sym = ID[id][0]
    pos = ID[id][1]
    @parent.board[pos[0]][pos[1]] = King.new(id, @parent, sym, pos)
  end

  def create_queen(id)
    sym = ID[id][0]
    pos = ID[id][1]
    @parent.board[pos[0]][pos[1]] = Queen.new(id, @parent, sym, pos)
  end

  def create_pawn(id)
    sym = ID[id][0]
    pos = ID[id][1]
    @parent.board[pos[0]][pos[1]] = Pawn.new(id, @parent, sym, pos)
  end
end
