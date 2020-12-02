module ChessSet
  WP = { :pawn => "♙", :rook => "♖", :knight => "♘",
                   :bishop => "♗", :queen => "♕", :king => "♔" }
  BP = { :pawn => "♟︎", :rook => "♜", :knight => "♞",
                   :bishop => "♝", :queen => "♛", :king => "♚" }
  ID = { "blk_kht_1" => [BP[:knight], [0,1]],
         "blk_kht_2" => [BP[:knight], [0,6]],
         "wht_kht_1" => [WP[:knight], [7,1]],
         "wht_kht_2" => [WP[:knight], [7,6]]
       }

  def board_positions(hash, array)
    hash.each { |key, value|
      array[value[0]][value[1]] = ID[key]
    }
    return array
  end
end
