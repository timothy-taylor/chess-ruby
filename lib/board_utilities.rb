# frozen_string_literal: true

require 'tty-table'
require 'pastel'

require_relative 'board'

# provides the utilities that the board.rb file uses for its methods
module BoardUtilities
  def render_array(array, pos)
    pos_col = pos[1] + 1 unless pos.empty?
    pos_row = pos[0]
    pastel = Pastel.new
    table = TTY::Table.new(array)
    puts table.render(:unicode, padding: [0, 1]) { |renderer|
      renderer.border.separator = :each_row
      renderer.filter = lambda { |val, row, col|
        col == pos_col && row == pos_row ? pastel.red(val) : val
      }
    }
  end

  def add_symbols(array)
    array.map do |row|
      row.map { |element| element&.symbol }
    end
  end

  def add_labels(array)
    numbers = array.each_with_index do |row, i|
      numbers = (1..8).to_a.reverse
      row.unshift(numbers[i])
    end
    numbers << ('a'..'h').to_a.reverse.unshift('-')
  end

  def add_squares(array, moves)
    array.map.with_index do |row, i|
      row.map.with_index { |e, j| e || black_or_white?(i, j, moves) }
    end
  end

  def black_or_white?(row, column, moves)
    if (row + column).even?
      '■' if moves.include?([row, column])
    elsif (row + column).odd?
      '□' if moves.include?([row, column])
    end
  end
  
  def outside_board?(pos)
    if (pos[0]).negative? || (pos[1]).negative?
      true
    elsif pos[0] >= 8 || pos[1] >= 8
      true
    else
      false
    end
  end

  def same_team?(piece_one, piece_two)
   piece_one.id.chr == piece_two.id.chr
  end

  def pawn_move(pos, piece)
    pos[1] == piece.current_pos[1] ? true : false
  end

  def pawn_attack(pos, piece, space)
    return false if pos[1] == piece.current_pos[1]  
    return false if piece.id.chr == space.id.chr
    true
  end

  def check(player)
    piece_id = (player.eql?('white') ? 'wht_kng_1' : 'blk_kng_1')
    color_id = (player.eql?('white') ? 'blk' : 'wht')
    find_checking_pieces(piece_id, color_id)
  end

  def find_checking_pieces(piece_id, color_id)
    king = []
    pieces = []
    @board.each_with_index { |row, i| row.each_with_index do |square, j|
        unless square.nil?
          king << [i,j] if square.id.eql?(piece_id)
          pieces << square if square.id.include?(color_id)
        end
      end
    }
    return pieces.select { |piece|
      piece.available_moves(self).any? do |move|
        move == king[0]
      end
    }
  end
end
