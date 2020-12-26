# frozen_string_literal: true

require 'json'

require_relative 'board'

# provide input encoding/decoding, creates a game of turns
class Interface
  attr_accessor :play, :turn_number

  DECODE = { 'h' => 0, 'g' => 1, 'f' => 2, 'e' => 3, 'd' => 4,
             'c' => 5, 'b' => 6, 'a' => 7,
             '1' => 7, '2' => 6, '3' => 5, '4' => 4, '5' => 3,
             '6' => 2, '7' => 1, '8' => 0 }.freeze

  ENCODE_CHAR = { '0' => 'h', '1' => 'g', '2' => 'f', '3' => 'e',
                  '4' => 'd', '5' => 'c', '6' => 'b', '7' => 'a' }.freeze

  ENCODE_NUM = { '7' => 1, '6' => 2, '5' => 3, '4' => 4,
                 '3' => 5, '2' => 6, '1' => 7, '0' => 8 }.freeze

  def initialize(turn = nil, save = nil, loaded = nil)
    @play = ( save.nil? ? Board.new : Board.new(save, loaded) )
    @turn_number = ( turn.nil? ? 0 : turn )
    @current_player = find_player
    @play.print_board('render')
    play_game
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

  def play_game
    new_turn until @play.game_over
  end
end

# Main functionality for gameplay
class Turn < Interface
  attr_accessor :piece, :player

  def initialize(parent, player)
    @player = player
    @parent = parent
    @@board = parent.play.board
    check_methods
    choose_piece_methods
    choose_move_methods
  end

  def check_methods
    checking_pieces = @parent.play.check(@player, @parent.play)
    if checking_pieces.any?
      if @parent.play.checkmate(@player, @parent.play)
        puts "Checkmate!"
        return @parent.play.game_over = true
      else
        in_check_alert(checking_pieces)
      end
    end
  end

  def choose_piece_methods
    return if @parent.play.game_over
    input = ask_for_move
    return if @castle
    return if @parent.play.game_over
    @piece = find_piece_on_board(input)
    print_available_moves
  end

  def choose_move_methods
    return if @castle
    return if @parent.play.game_over
    @destination = ask_for_move_2
    make_move
  end

  def in_check_alert(pieces, is_new = true)
    puts "#{@player}: You are#{is_new ? '' : ' still'} in check by #{pieces.collect(&:id)}!"
  end

  def ask_for_move(second_time = false)
    puts "#{@player}: Enter '--help' for more options or" unless second_time
    print "#{@player}: Enter coordinates for the piece you'd like to move: "
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
    when '--undo'
      #return to the previous save
    when '--exit'
      return @parent.play.game_over = true
    when '--save'
      @parent.play.save_game(@@board, @parent.turn_number)
    end
    ask_for_move(true) 
  end

  def print_available_moves
    @parent.play.print_board('render',
                             @piece.available_moves(@parent.play, true),
                             @piece.current_pos)
    encoded_moves = []
    @piece.available_moves(@parent.play, true).map do |each|
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
                        'king' => [[7,4], 'wht_kng_1', [7,2]],
                        'rook' => [[7,0], 'wht_rok_1', [7,3]] }.freeze
    black_queenside = { 'in_between' => [[0,1], [0,2], [0,3]],
                        'king' => [[0,4], 'blk_kng_1', [0,2]],
                        'rook' => [[0,0], 'blk_rok_1', [0,3]] }.freeze
    white_kingside = { 'in_between' => [[7,5], [7,6]],
                       'king' => [[7,4], 'wht_kng_1', [7,6]],
                       'rook' => [[7,7], 'wht_rok_2', [7,5]] }.freeze
    black_kingside = { 'in_between' => [[0,5], [0,6]],
                       'king' => [[0,4], 'blk_kng_1', [0,6]],
                       'rook' => [[0,7], 'blk_rok_2', [0,5]] }.freeze

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
    
    if spaces.all? do |array| 
      array.all? { |space| @@board[space[0]][space[1]].nil? }
    end
      rook = find_piece_on_board(rook_info[0][0])
      king = find_piece_on_board(king_info[0][0])
      if king.id.eql?(king_info[0][1]) && rook.id.eql?(rook_info[0][1])
        if king.previous_pos.nil? && rook.previous_pos.nil?
          castle_move(rook, king, king_info[0][2], rook_info[0][2])
          return true
        else
          return illegal_choice
        end
      else
        return illegal_choice
      end
    else
      return illegal_choice
    end
  end
   
  def ask_for_move_2(second_time = false)
    return if @back
    puts "#{@player}: Enter '--help' for more options or" unless second_time
    print "#{@player}: Enter coordinates of where you'd like to move to: "
    input = gets.chomp
    move = decode(input)
    move[0].nil? || move[1].nil? ? input_options_2(input) : move
  end

  def input_options_2(input)
    @back = false
    case input
    when '--help'
      puts "help: format for coordinates is [letter number] with no spaces (ie 'b6')"
      puts "other options:"
      puts "\t'--back' to pick a different piece"
      puts "\t'--exit' to quit"
      puts "\t'--save' to save"
    when '--back'
      puts 'Returning...'
      choose_piece_methods
    when '--exit'
      return @parent.play.game_over = true
    end
    ask_for_move_2(true) 
  end

  def make_move
    if @piece.available_moves(@parent.play, true).include?(@destination)
      @parent.play.move_piece(@piece, @destination)
      @piece.previous_pos = @piece.current_pos
      @piece.current_pos = @destination
      @parent.play.print_board('render')
    else
      illegal_move
    end
  end

  def illegal_move(into_check = false)
    puts "#{@player}: That move isn't legal#{into_check ? ' due to check' : ''}!"
    @destination = ask_for_move_2
    make_move
  end
 
  def castle_move(rook, king, king_dest, rook_dest)
    rook.previous_pos = rook.current_pos
    rook.current_pos = rook_dest
    king.previous_pos = king.current_pos
    king.current_pos = king_dest
    @@board[rook.current_pos[0]][rook.current_pos[1]] = rook
    @@board[king.current_pos[0]][king.current_pos[1]] = king
    @@board[rook.previous_pos[0]][rook.previous_pos[1]] = nil
    @@board[king.previous_pos[0]][king.previous_pos[1]] = nil
    @parent.play.print_board('render')
  end
end

class Start
  def initialize
    if File.exist?('.save')
      check_for_save
    else
      new_game
    end
  end

  def check_for_save
    print "Welcome to chess, enter [0] to start a new game or [1] to load a game: "
    input = gets[0].to_i
    unless (0..1).include?(input)
      puts "Sorry, I didn't get that..."
      check_for_save
    else
      if input.eql?(0)
        new_game
      else
        load_game
      end
    end
  end

  def new_game
    start = Interface.new
  end

  def load_game
    game_state = File.open(".save", "r"){ |file| file.read }
    loaded = JSON.load(game_state)
    puts "Game loaded."
    puts turn = loaded['turn']
    p board = loaded['board']
    start = Interface.new(turn, board, true)
  end
end

Start.new
