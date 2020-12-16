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
    return if @parent.play.game_over
    puts @piece = find_piece_on_board(@input)
    puts "log: #{@piece.current_pos} = #{encode(@piece.current_pos)}"
    print_available_moves
    @destination = ask_for_move_2
    make_move(@destination)
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
      @input = ask_for_move
      @piece = find_piece_on_board(@input)
      print_available_moves
    else
      print 'Available moves: '
      p encoded_moves
    end
  end

   def ask_for_move
    print "#{@player}: Please enter the coordinate of the piece you'd like to move: "
    input = gets.chomp
    return @parent.play.game_over = true if input == 'exit'
    puts "type 'exit' to quit, 'save' to save, coordinates are letter+number (ie a6)" if input == 'help'
    move = decode(input)
    move[0].nil? || move[1].nil? ? ask_for_move : move
  end

   def ask_for_move_2
    print "#{@player}: Please enter the coordinates of where you'd like to move to: "
    decode(gets.chomp)
  end

  def make_move(destination)
    if @piece.available_moves.include?(destination)
      @piece.current_pos = destination
      @@board[@input[0]][@input[1]] = nil
      @@board[destination[0]][destination[1]] = @piece
      @parent.play.print_board('render')
    else
      illegal_move
    end
  end

  def illegal_move
    puts "#{@player}: That move isn't legal!"
    make_move(ask_for_move_2)
  end

  def find_piece_on_board(array)
    piece = @@board[array[0]][array[1]]
    if piece.nil?
      illegal_choice
    elsif piece.id.start_with?('blk') && @player == 'black'
      piece
    elsif piece.id.start_with?('wht') && @player == 'white'
      piece
    else
      illegal_choice
    end
  end

  def illegal_choice
    puts "#{@player}: That isn't a valid choice!"
    find_piece_on_board(ask_for_move)
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
