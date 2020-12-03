module ChessSet
  BP = { :pawn => "♙", :rook => "♖", :knight => "♘",
                   :bishop => "♗", :queen => "♕", :king => "♔" }
  WP = { :pawn => "♟︎", :rook => "♜", :knight => "♞",
                   :bishop => "♝", :queen => "♛", :king => "♚" }

  ID = { "blk_kht_1" => [BP[:knight], [0,1]],
         "blk_kht_2" => [BP[:knight], [0,6]],
         "wht_kht_1" => [WP[:knight], [7,1]],
         "wht_kht_2" => [WP[:knight], [7,6]],
         "blk_rok_1" => [BP[:rook], [0,0]],
         "blk_rok_2" => [BP[:rook], [0,7]],
         "wht_rok_1" => [WP[:rook], [7,0]],
         "wht_rok_2" => [WP[:rook], [7,7]],
         "blk_bsh_1" => [BP[:bishop], [0,2]],
         "blk_bsh_2" => [BP[:bishop], [0,5]],
         "wht_bsh_1" => [WP[:bishop], [7,2]],
         "wht_bsh_2" => [WP[:bishop], [7,5]],
         "blk_que_1" => [BP[:queen], [0,3]],
         "wht_que_1" => [WP[:queen], [7,3]],
         "blk_kng_1" => [BP[:king], [0,4]],
         "wht_kng_1" => [WP[:king], [7,4]]
       }

  def create_pawn_ids(color)
    if color.eql?("black")
     str = "blk"
     id_clr = BP
     row = 1
    elsif color.eql?("white")
     str = "wht"
     id_clr = WP
     row = 6
    end
    8.times do |n|
      string = "#{str}_pwn_#{n}"
      ID[string] = [id_clr[:pawn], [row,n]]
    end
  end
end


