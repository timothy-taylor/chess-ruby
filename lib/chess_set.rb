module ChessSet
  WP = { :pawn => "♙", :rook => "♖", :knight => "♘",
                   :bishop => "♗", :queen => "♕", :king => "♔" }
  BP = { :pawn => "♟︎", :rook => "♜", :knight => "♞",
                   :bishop => "♝", :queen => "♛", :king => "♚" }
  ID = { "blk_kht_1" => BP[:knight] }

  def board_positions(hash, array)
    hash.each { |key, value|
      array[value[0]][value[1]] = ID[key]
    }
    return array
  end
end
