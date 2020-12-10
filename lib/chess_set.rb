# frozen_string_literal: true

require 'pry'

require_relative 'pieces/knight'
require_relative 'pieces/rook'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'pieces/pawn'

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

  def create_pawn_ids(color)
    case color
    when 'black'
      str = 'blk'
      id_clr = BP
      row = 1
    when 'white'
      str = 'wht'
      id_clr = WP
      row = 6
    end
    8.times do |n|
      string = "#{str}_pwn_#{n + 1}"
      ID[string] = [id_clr[:pawn], [row, n], Pawn]
    end
  end

  def create_piece(id, parent)
    sym = ID[id][0]
    pos = ID[id][1]
    class_name = ID[id][2]
    parent.board[pos[0]][pos[1]] = class_name.new(id, parent, sym, pos)
  end

  def create_side(id_array, parent)
    id_array.each do |id|
      create_piece(id, parent)
    end
  end
end
