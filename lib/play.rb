# frozen_string_literal: true

require 'pry'

require_relative 'board'

class Interface
  attr_accessor :play

  DECODE = { 'h' => 0, 'g' => 1, 'f' => 2, 'e' => 3, 'd' => 4,
             'c' => 5, 'b' => 6, 'a' => 7,
             '1' => 7, '2' => 6, '3' => 5, '4' => 4, '5' => 3,
             '6' => 2, '7' => 1, '8' => 0 }.freeze

  ENCODE_CHAR = { '0' => 'h', '1' => 'g', '2' => 'f', '3' => 'e',
                  '4' => 'd', '5' => 'c', '6' => 'b', '7' => 'a' }.freeze

  ENCODE_NUM = { '7' => 1, '6' => 2, '5' => 3, '4' => 4,
                 '3' => 5, '2' => 6, '1' => 7, '0' => 8 }.freeze

  def initialize
    @play = Board.new
    @turn_number = 0
    @current_player = find_player
  end

  def render
    @play.print_board('render')
  end

  def decode(input)
    [DECODE[input[1]], DECODE[input[0]]]
  end

  def encode(input)
    "#{ENCODE_CHAR[input[1].to_s]}" "#{ENCODE_NUM[input[0].to_s]}"
  end

  def find_player
    @turn_number.even? ? 'white' : 'black'
  end

  def new_turn
    Turn.new(self, @current_player)
    @turn_number += 1
    @current_player = find_player
  end

  def game
    new_turn until @play.game_over
  end
end

class Turn < Interface
  attr_accessor :piece, :player

  def initialize(parent, player)
    @player = player
    @parent = parent
    @@board = parent.play.board
    @input = ask_for_move
    return if @castle
    return if @parent.play.game_over
    @piece = find_piece_on_board(@input)
    print_available_moves
    @destination = ask_for_move_2
    make_move(@destination)
  end

  # choose piece
  def ask_for_move(second_time = false)
    puts "#{@player}: Enter '--help' for more options or" unless second_time
    print "#{@player}: Enter the coordinates for the piece you'd like to move: "
    input = gets.chomp
    move = decode(input)
    move[0].nil? || move[1].nil? ? input_options(input) : move
  end

  def input_options(input)
    @castle = false
    case input
    when '--help'
      puts "help: format for coordinates is [letter number] with no spaces (ie 'b6')"
      puts "other options:"
      puts "\t'--castle-king' for a legal kingside castle"
      puts "\t'--castle-queen' for a legal queenside castle"
      puts "\t'--exit' to quit"
      puts "\t'--save' to save"
    when '--castle-king'
      return @castle = kingside_castle_check_white if @player.eql?('white')
      return @castle = kingside_castle_check_black if @player.eql?('black')
    when '--castle-queen'
      return @castle = queenside_castle_check_white if @player.eql?('white')
      return @castle = queenside_castle_check_black if @player.eql?('black')
    when '--exit'
      return @parent.play.game_over = true
    when '--save'
    end
    ask_for_move(true) 
  end

  def queenside_castle_check_white
    if @@board[7][1].nil? && @@board[7][2].nil? && @@board[7][3].nil?
      king = find_piece_on_board([7,4])
      rook = find_piece_on_board([7,0])
      if king.id.eql?('wht_kng_1') && rook.id.eql?('wht_rok_1')
        if king.move_tree.current == king.move_tree.root &&
            rook.move_tree.current == rook.move_tree.root
          queenside_castle_move(rook, king, 'white')
          return true
        else
          return illegal_choice
        end
      else
        return illegal_choice
      end
    end
  end

  def queenside_castle_check_black
      if @@board[0][1].nil? && @@board[0][2].nil? && @@board[0][3].nil?
      king = find_piece_on_board([0,4])
      rook = find_piece_on_board([0,0])
      if king.id.eql?('blk_kng_1') && rook.id.eql?('blk_rok_1')
        if king.move_tree.current == king.move_tree.root &&
            rook.move_tree.current == rook.move_tree.root
          queenside_castle_move(rook, king, 'black')
          return true
        else
          return illegal_choice
        end
      else
        return illegal_choice
      end
    end
  end
  

  def kingside_castle_check_white
    if @@board[7][5].nil? && @@board[7][6].nil?
      king = find_piece_on_board([7,4])
      rook = find_piece_on_board([7,7])
      if king.id.eql?('wht_kng_1') && rook.id.eql?('wht_rok_2')
        if king.move_tree.current == king.move_tree.root &&
            rook.move_tree.current == rook.move_tree.root
          kingside_castle_move(rook, king, 'white')
          return true
        else
          return illegal_choice
        end
      else
        return illegal_choice
      end
    end
  end

  def kingside_castle_check_black
    if @@board[0][5].nil? && @@board[0][6].nil?
      king = find_piece_on_board([0,4])
      rook = find_piece_on_board([0,7])
      if king.id.eql?('wht_kng_1') && rook.id.eql?('wht_rok_2')
        if king.move_tree.current == king.move_tree.root &&
              rook.move_tree.current == rook.move_tree.root
            kingside_castle_move(rook, king, 'black')
            return true
        else
            return illegal_choice
        end
      else
          return illegal_choice
      end
    end
  end
  
  def print_available_moves
    @parent.play.print_board('render',
                             @piece.available_moves,
                             @piece.current_pos)
    encoded_moves = []
    @piece.available_moves.map do |each|
      encoded_moves << encode(each)
    end
    if encoded_moves.empty?
      puts "That piece has no legal moves"
      @input = ask_for_move(true)
      @piece = find_piece_on_board(@input)
      print_available_moves
    else
      print 'Available moves: '
      p encoded_moves
    end
  end

  def find_piece_on_board(array)
    return if array.nil?
    piece = @@board[array[0]][array[1]]
    if piece.nil?
      illegal_choice
    elsif piece.id.start_with?('blk') && @player.eql?('black')
      piece
    elsif piece.id.start_with?('wht') && @player.eql?('white')
      piece
    else
      illegal_choice
    end
  end

  def illegal_choice
    puts "#{@player}: That isn't a valid choice!"
    find_piece_on_board(ask_for_move)
  end

  # choose move
  def ask_for_move_2
    print "#{@player}: Please enter the coordinates of where you'd like to move to: "
    decode(gets.chomp)
  end

  def make_move(destination)
    if @piece.available_moves.include?(destination)
      @piece.current_pos = destination
      @@board[destination[0]][destination[1]] = nil
      @@board[destination[0]][destination[1]] = @piece
      @@board[@input[0]][@input[1]] = nil
      @parent.play.print_board('render')
    else
      illegal_move
    end
  end

  def illegal_move
    puts "#{@player}: That move isn't legal!"
    make_move(ask_for_move_2)
  end

  def queenside_castle_move(rook, king, player)
    case player
    when 'white'
      @@board[7][3] = rook
      @@board[7][2] = king
      @@board[7][4] = nil
      @@board[7][0] = nil
    when 'black'
      @@board[0][3] = rook
      @@board[0][2] = king
      @@board[0][4] = nil
      @@board[0][0] = nil
    end
    @parent.play.print_board('render')
  end
  
  def kingside_castle_move(rook, king, player)
    case player
    when 'white'
      @@board[7][5] = rook
      @@board[7][6] = king
      @@board[7][4] = nil
      @@board[7][7] = nil
    when 'black'
      @@board[0][5] = rook
      @@board[0][6] = king
      @@board[0][4] = nil
      @@board[0][7] = nil
    end
    @parent.play.print_board('render')
  end
end

class Start
  def initialize
    start = Interface.new
    start.render
    start.game
  end
end

Start.new
