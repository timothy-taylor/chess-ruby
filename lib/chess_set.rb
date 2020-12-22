# frozen_string_literal: true

require 'pry'

require_relative 'pieces/knight'
require_relative 'pieces/king'
require_relative 'pieces/pawn'

class Piece
  attr_reader :symbol, :id
  attr_accessor :current_pos, :previous_pos

  def initialize(id, symbol, position)
    @id = id
    @symbol = symbol
    @current_pos = position
    @previous_pos = nil
  end 

  def available_moves(board)
    x = @current_pos[0]
    y = @current_pos[1]
    allowable = []
    moves.each { |string|
      legal_move(x, y, allowable, string, board)
    }
    allowable
  end
 
  private

  def legal_move(x, y, array, key, board)
    n = 0
    legal_move = true
    while legal_move do
      move = move_key(x, y, key, n)
      n += 1
      array << move if board.allowable_move?(move, self)
      legal_move = board.continue_moves?(move, self)
    end
    array
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
end

class Bishop < Piece
  def moves
    @moves ||= %w(upright upleft downright downleft).freeze
  end
end

class Rook < Piece
  def moves
    @moves ||= %w(down right up left).freeze
  end
end

class Queen < Piece
  def moves
    @moves ||= %w(down right up left upright upleft downright downleft).freeze
  end
end

module ChessSet
  BP = { pawn: '♙', rook: '♖', knight: '♘',
         bishop: '♗', queen: '♕', king: '♔' }.freeze
  WP = { pawn: '♟︎', rook: '♜', knight: '♞',
         bishop: '♝', queen: '♛', king: '♚' }.freeze

  # important to note: the pawn IDs are created in the method below
  # so any changes here must be echoed in the method...
  ID = { 'blk_kht_1' => [BP[:knight], [0, 1], Knight],
         'blk_kht_2' => [BP[:knight], [0, 6], Knight],
         'wht_kht_1' => [WP[:knight], [7, 1], Knight],
         'wht_kht_2' => [WP[:knight], [7, 6], Knight],
         'blk_rok_1' => [BP[:rook], [0, 0], Rook],
         'blk_rok_2' => [BP[:rook], [0, 7], Rook],
         'wht_rok_1' => [WP[:rook], [7, 0], Rook],
         'wht_rok_2' => [WP[:rook], [7, 7], Rook],
         'blk_bsh_1' => [BP[:bishop], [0, 2], Bishop],
         'blk_bsh_2' => [BP[:bishop], [0, 5], Bishop],
         'wht_bsh_1' => [WP[:bishop], [7, 2], Bishop],
         'wht_bsh_2' => [WP[:bishop], [7, 5], Bishop],
         'blk_que_1' => [BP[:queen], [0, 3], Queen],
         'wht_que_1' => [WP[:queen], [7, 3], Queen],
         'blk_kng_1' => [BP[:king], [0, 4], King],
         'wht_kng_1' => [WP[:king], [7, 4], King] }

  def self.create_pawn_ids(str)
    case str
    when 'blk'
      id_clr = BP
      row = 1
    when 'wht'
      id_clr = WP
      row = 6
    end
    8.times do |n|
      string = "#{str}_pwn_#{n + 1}"
      ID[string] = [id_clr[:pawn], [row, n], Pawn]
    end
  end
end
