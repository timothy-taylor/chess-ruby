# frozen_string_literal: true

require_relative 'board_utilities'

# base functionality that is inherented by the individual pieces
class Piece
  include BoardUtilities

  attr_reader :symbol, :id
  attr_accessor :current_pos, :previous_pos

  def initialize(id, symbol, position, prev_pos = nil)
    @id = id
    @symbol = symbol
    @current_pos = position
    @previous_pos = prev_pos
  end 

  def available_moves(board, check = nil)
    x = @current_pos[0]
    y = @current_pos[1]
    allowable = []
    moves.each { |string|
      legal_move(x, y, allowable, string, board, check)
    }
    allowable
  end
 
  private

  def legal_move(x, y, array, key, parent, check = nil)
    n = 0
    legal_move = true
    while legal_move do
      move = move_key(x, y, key, n)
      n += 1
      array << move if allowable_move?(move, self, parent, check)
      legal_move = continue_moves?(move, self, parent)
    end
    array
  end
  
  def allowable_move?(pos, piece, parent, check = nil)
    return nil if pos.nil?
    return false if outside_board?(pos)
    unless check.nil?
      return false if try_to_move_into_check(pos, piece, parent)
      occupied = parent.board[pos[0]][pos[1]]
      if occupied.nil?
        return pawn_move(pos, piece) if piece.id.include? 'pwn'
        true
      else
        return pawn_attack(pos, piece, occupied) if piece.id.include? 'pwn'
        same_team?(occupied, piece) ? false : true
      end
    else
      occupied = parent.board[pos[0]][pos[1]]
      if occupied.nil?
        return pawn_move(pos, piece) if piece.id.include? 'pwn'
        true
      else
        return pawn_attack(pos, piece, occupied) if piece.id.include? 'pwn'
        same_team?(occupied, piece) ? false : true
      end
    end
  end

  def continue_moves?(pos, piece, parent)
    return false if pos.nil?
    return false if outside_board?(pos)
    parent.board[pos[0]][pos[1]].nil? ? true : false
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

class King < Piece
  def available_moves(board, check = nil)
    x = @current_pos[0]
    y = @current_pos[1]
    allowable = []
    possible_moves = [[x + 1, y + 0], [x + 1, y + 1],
                      [x - 1, y + 0], [x - 1, y - 1],
                      [x + 0, y + 1], [x + 0, y - 1],
                      [x + 1, y - 1], [x - 1, y + 1]]
    possible_moves.each do |e|
      allowable << e if allowable_move?(e, self, board, check)
    end
    allowable
  end
end

class Pawn < Piece
  def available_moves(board, check = nil)
    allowable = []
    possible_moves = []
    possible_moves << basic_move_direction(self.id, self.current_pos)
    possible_moves << diagonal_take_left(self.id, self.current_pos)
    possible_moves << diagonal_take_right(self.id, self.current_pos)
    possible_moves << first_move_direction(self.id, self.current_pos)
    possible_moves.each do |e|
      allowable << e if allowable_move?(e, self, board, check)
    end
    allowable
  end

  def basic_move_direction(id, position)
    x = position[0]
    y = position[1]
    id.start_with?('blk') ? [x + 1, y] : [x - 1, y]
  end

  def first_move_direction(id, position)
    return nil unless self.previous_pos.nil?
    x = position[0]
    y = position[1]
    id.start_with?('blk') ? [x + 2, y] : [x - 2, y]
  end

  def diagonal_take_left(id, position)
    x = position[0]
    y = position[1]
    id.start_with?('blk') ? [x + 1, y + 1] : [x - 1, y + 1]
  end

  def diagonal_take_right(id, position)
    x = position[0]
    y = position[1]
    id.start_with?('blk') ? [x + 1, y - 1] : [x - 1, y - 1]
  end
end

class Knight < Piece
  def available_moves(board, check = nil)
    x = @current_pos[0]
    y = @current_pos[1]
    allowable = []
    possible_moves = [[x + 2, y + 1], [x + 2, y - 1],
                      [x + 1, y + 2], [x + 1, y - 2],
                      [x - 2, y + 1], [x - 2, y - 1],
                      [x - 1, y + 2], [x - 1, y - 2]]
    possible_moves.each do |e|
      allowable << e if allowable_move?(e, self, board, check)
    end
    allowable
  end
end

# provides data to populate the chessboard with correct pieces
module ChessSet
  BP = { pawn: '♙', rook: '♖', knight: '♘',
         bishop: '♗', queen: '♕', king: '♔' }.freeze
  WP = { pawn: '♟︎', rook: '♜', knight: '♞',
         bishop: '♝', queen: '♛', king: '♚' }.freeze

  # the pawn IDs are created in the method below
  # so any changes here must be echoed in that method...
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
