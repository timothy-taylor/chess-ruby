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
    checking_pieces = @parent.play.check(@player)
    in_check = checking_pieces.any?
    in_check_alert(checking_pieces) if in_check
    input = ask_for_move
    return if @castle
    return if @parent.play.game_over
    @piece = find_piece_on_board(input)
    print_available_moves
    @destination = ask_for_move_2
    in_check ? make_move_within_check : make_move
  end

  def in_check_alert(pieces, is_new = true)
    puts "#{@player}: You are#{is_new ? '' : ' still'} in check by #{pieces.collect(&:id)}!"
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
      return @castle = castle_chk('kingside')
    when '--castle-queen'
      return @castle = castle_chk('queenside')
    when '--exit'
      return @parent.play.game_over = true
    when '--save'
    when 'pry'
      binding.pry
    end
    ask_for_move(true) 
  end
  
  def print_available_moves
    @parent.play.print_board('render',
                             @piece.available_moves(@parent.play),
                             @piece.current_pos)
    encoded_moves = []
    @piece.available_moves(@parent.play).map do |each|
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
  
  def castle_chk(side)
    white_queenside = { 'in_between' => [[7,1], [7,2], [7,3]],
                        'king' => [[7,4], 'wht_kng_1'],
                        'rook' => [[7,0], 'wht_rok_1'] }
    black_queenside = { 'in_between' => [[0,1], [0,2], [0,3]],
                        'king' => [[0,4], 'blk_kng_1'],
                        'rook' => [[0,0], 'blk_rok_1'] }
    white_kingside = { 'in_between' => [[7,5], [7,6]],
                       'king' => [[7,4], 'wht_kng_1'],
                       'rook' => [[7,7], 'wht_rok_2'] }
    black_kingside = { 'in_between' => [[0,5], [0,6]],
                       'king' => [[0,4], 'blk_kng_1'],
                       'rook' => [[0,7], 'blk_rok_2'] }

    case side
    when 'queenside'
      king_info = ( @player.eql?('white') ? 
                   white_queenside.fetch_values('king') : 
                   black_queenside.fetch_values('king') )
      rook_info = ( @player.eql?('white') ?
                   white_queenside.fetch_values('rook') :
                   black_queenside.fetch_values('rook') )
      spaces = ( @player.eql?('white') ?
                white_queenside.fetch_values('in_between') :
                black_queenside.fetch_values('in_between') )
    when 'kingside'
      king_info = ( @player.eql?('white') ? 
                   white_kingside.fetch_values('king') : 
                   black_kingside.fetch_values('king') )
      rook_info = ( @player.eql?('white') ?
                   white_kingside.fetch_values('rook') :
                   black_kingside.fetch_values('rook') )
      spaces = ( @player.eql?('white') ?
                white_kingside.fetch_values('in_between') :
                black_kingside.fetch_values('in_between') )
    end
    
    if spaces.all? { |array| 
      array.all? { |space| 
        @@board[space[0]][space[1]].nil?
      }
    }
      rook = find_piece_on_board(rook_info[0][0])
      king = find_piece_on_board(king_info[0][0])
      if king.id.eql?(king_info[0][1]) && rook.id.eql?(rook_info[0][1])
        if king.previous_pos.nil? && rook.previous_pos.nil?
          case side
          when 'queenside'
            queenside_castle_move(rook, king, @player)
          when 'kingside'
            kingside_castle_move(rook, king, @player)
          end
          return true
        else
          puts 'previous'
          return illegal_choice
        end
      else
        puts 'ids'
        return illegal_choice
      end
    else
      puts 'spaces'
      return illegal_choice
    end
  end
  
# choose & make move
  def ask_for_move_2
    print "#{@player}: Please enter the coordinates of where you'd like to move to: "
    decode(gets.chomp)
  end
  
  def make_move
    if @piece.available_moves(@parent.play).include?(@destination)
      @parent.play.move_piece(@piece, @destination)
      @piece.previous_pos = @piece.current_pos
      @piece.current_pos = @destination
      @parent.play.print_board('render')
    else
      illegal_move
    end
  end

  def illegal_move
    puts "#{@player}: That move isn't legal!"
    @destination = ask_for_move_2
    make_move
  end

  def make_move_within_check
    test_board = @parent.play.duplicate
    test_board.move_piece(@piece, @destination) 
    if @piece.available_moves(@parent.play).include?(@destination)
      if (checking_pieces = test_board.check(@player)).any? 
        illegal_move_check(checking_pieces) 
      else
        make_move
      end
    else
      illegal_move
    end
  end

  def illegal_move_check(pieces)
    in_check_alert(pieces, false)
    @destination = ask_for_move_2
    make_move_within_check
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
    start.play.print_board('render')
    start.game
  end
end

Start.new
