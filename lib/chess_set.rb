module ChessSet
  WP = { :pawn => "♙", :rook => "♖", :knight => "♘",
                   :bishop => "♗", :queen => "♕", :king => "♔" }
  BP = { :pawn => "♟︎", :rook => "♜", :knight => "♞",
                   :bishop => "♝", :queen => "♛", :king => "♚" }

                      # color[piece], [starting position]
  # example: ID["blk_kht_1"]
  ID = { "blk_kht_1" => [BP[:knight], [0,1]],
         "blk_kht_2" => [BP[:knight], [0,6]],
         "wht_kht_1" => [WP[:knight], [7,1]],
         "wht_kht_2" => [WP[:knight], [7,6]]
       }

end
