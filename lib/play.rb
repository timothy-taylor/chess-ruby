require 'pry'

require_relative "board.rb"

class Interface
  attr_accessor :play

  DECODE = { "a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4,
             "f" => 5, "g" => 6, "h" => 7,
             "1" => 7, "2" => 6, "3" => 5, "4" => 4, "5" => 3,
             "6" => 2, "7" => 1, "8" => 0 }

  ENCODE_CHAR = { "0" => "a", "1" => "b", "2" => "c", "3" => "d",
                  "4" => "e", "5" => "f", "6" => "g", "7" => "h" }

  ENCODE_NUM = { "7" => 1, "6" => 2, "5" => 3, "4" => 4, 
                 "3" => 5, "2" => 6, "1" => 7, "0" => 8 }

  def initialize
    @play = Board.new
    @turn_number = 0
    @current_player = find_player
  end

  def render
    @play.print_board("render")
  end
 
  def decode(input)
    coordinates = [DECODE[input[1]], DECODE[input[0]]]
  end
  
  def encode(input)
    "#{ENCODE_CHAR[input[1].to_s]}" "#{ENCODE_NUM[input[0].to_s]}"
  end


  def find_player
    @turn_number.even? ? "white" : "black"
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
    puts @piece = find_piece_on_board(@input)
    puts "#{@piece.current_pos} = #{encode(@piece.current_pos)}"
    print_available_moves
  end

  def print_available_moves
    @parent.play.print_board("render",
                             @piece.available_moves,
                             @piece.current_pos)
    encoded_moves = []
    @piece.available_moves.map { |each|
      encoded_moves << encode(each)
    }
    print "Available moves: "
    p encoded_moves
  end
  
  def ask_for_move
    print "#{@player}: Please enter the coordinate of the piece you'd like to move: "
    decode(gets.chomp)
  end

  def find_piece_on_board(array)
    piece = @@board[array[0]][array[1]]
    if piece.nil?
      illegal_choice
    elsif piece.id.start_with?("blk") && @player == "black"
      return piece
    elsif piece.id.start_with?("wht") && @player == "white"
      return piece
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
    start.new_turn
  end
end

Start.new
