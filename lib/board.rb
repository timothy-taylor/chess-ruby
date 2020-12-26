# frozen_string_literal: true

require 'json'

require_relative 'chess_set'
require_relative 'board_utilities'

# creates, populates, and prints the board
class Board
  include ChessSet
  include BoardUtilities

  attr_accessor :board, :game_over 

  def initialize(start_pos = nil, loaded = nil)
    @game_over = false

    # Create & populate the board if not provided
    if start_pos.nil?
      @board = Array.new(8) { Array.new(8) }
      populate('wht')
      populate('blk')
    elsif loaded.eql?(true)
      @board = Array.new(8) { Array.new(8) }
      load_pieces(start_pos)
    else
      @board = start_pos
    end
  end

  def save_game(board, turn)
    array = format_for_serialization(board)
    game_state = JSON.dump ({
      :board => array,
      :turn => turn
    })
    File.open(".save", "w"){ |file| file.write(game_state) }
    puts "Game saved on turn #{turn}."
  end

  def format_for_serialization(array)
    new_array = []
    format = array.map { |row| 
      row.map { |square|
        new_array << [square.id, square.symbol, square.current_pos, square.previous_pos] unless square.nil?
      }
    }
    new_array
  end

  def load_pieces(array)
    ChessSet.create_pawn_ids('wht')
    ChessSet.create_pawn_ids('blk')
    array.each do |e|
      class_name = ChessSet::ID[e[0]][2]
      @board[e[2][0]][e[2][1]] = class_name.new(e[0], e[1], e[2], e[3])
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
    system('clear') || system('cls')
    render_array(format_array, piece_pos)
  end
end

