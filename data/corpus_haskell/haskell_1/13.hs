{------------------------------------------------------------------------------
Reversi
Haskellの習得のため、Schemeで書かれたリバーシ（オセロ）をHaskellに移植してみる。
参考：
http://www.stdio.h.kyoto-u.ac.jp/~hioki/gairon-enshuu/kadai2005/7.html
盤面上のマスは(x,y)で指定する(1<= x,y <= 8)．
-------------------------------------------------------------------------------}
data Piece = Empty | Black | White | Wall deriving (Eq, Show)
type Board = [[Piece]]
type Pt = (Int,Int)

-------------------------------------------------------------------------------
-- 盤面サイズ
-------------------------------------------------------------------------------
boardSize :: Int
boardSize = 8

-------------------------------------------------------------------------------
-- 8方向(dx,dy)のリスト
-------------------------------------------------------------------------------
directions :: [Pt]
directions = [(0, 1),(-1, 1),(-1, 0),(-1, -1),(0, -1),(1,-1),(1, 0),(1, 1)]

-------------------------------------------------------------------------------
-- 盤面の初期化
-- 境界に「壁」をダミーとして置いてある．
-------------------------------------------------------------------------------
initBoard:: Board
initBoard = [[ (f x y) | x <- [0..9]] | y <- [0..9]]
    where f x y
        | x == 0 || y == 0 || x == 9 || y == 9  = Wall
        | x == 4 && y == 4  = White
        | x == 5 && y == 5  = White
        | x == 4 && y == 5  = Black
        | x == 5 && y == 4  = Black
        | otherwise         = Empty

-------------------------------------------------------------------------------
-- 盤面の指定された場所のコマを返す。
-------------------------------------------------------------------------------
getBoard:: Board -> Pt -> Piece
getBoard board (x,y) = board !! y !! x

-------------------------------------------------------------------------------
-- 盤面の指定された場所にコマを置いて、新しい盤面を返す。
-------------------------------------------------------------------------------
setBoard:: Board -> Pt -> Piece -> Board
setBoard board (x,y) val = 
    (take y board) ++ ((take x b) ++ val : (drop (x+1) b)) : (drop (y+1) board)
    where
        b = board !! y

-------------------------------------------------------------------------------
-- 盤面の内容を表示する
-------------------------------------------------------------------------------
showBoard:: Board -> IO ()
showBoard board = putStr (concat (map showLine board))
    where
        showLine line =
            concat (map getSymbol line) ++ "\n"
        getSymbol val = case val of
            Empty -> "- "
            Black -> "B "
            White -> "W "
            Wall  -> "X "

-------------------------------------------------------------------------------
-- 相手の色
-------------------------------------------------------------------------------
opponent:: Piece -> Piece
opponent bw = if bw==White then Black else White

-------------------------------------------------------------------------------
-- 盤面上の白黒いずれかの個数を返す．
-------------------------------------------------------------------------------
pcount:: Board -> Piece -> Int
pcount board bw =
    length (filter (\val -> val == bw) (concat board))

{-
-------------------------------------------------------------------------------
-- 盤面上の白黒の個数を返す．
-- (黒の個数 白の個数)というタプルを返す
-------------------------------------------------------------------------------
bw_count:: Board -> (Int,Int)
bw_count board = (pcount board Black, pcount board White)
-}

-------------------------------------------------------------------------------
-- 与えられた点のある方向の位置 neighbor (5,3) (-1,1) のとき (4,4) を返す
-------------------------------------------------------------------------------
neighbor:: Pt -> Pt -> Pt
neighbor (x,y) (dx,dy) = (x+dx, y+dy)

-------------------------------------------------------------------------------
-- 同一色のrunの終点を調べる．
-- pointのdir方向の隣接点から延びるbwのrunの終点を調べる．
-- そのようなrunがなければ，pointそのものを返す．
--   pt    調べ始める場所
--   dir   方向
--   bw    調べる色
--   board 局面
-------------------------------------------------------------------------------
run_end:: Pt -> Pt -> Piece -> Board -> Pt
run_end pt dir bw board =
    if getBoard board p == bw
        then (run_end p dir bw board)
        else pt
    where
        p = neighbor pt dir

-------------------------------------------------------------------------------
-- p1 と p2 は同一地点か??
-------------------------------------------------------------------------------
the_same_point:: Pt -> Pt -> Bool
the_same_point (x1,y1) (x2,y2) = x1==x2 && y1==y2

-------------------------------------------------------------------------------
-- dirは有効な方向の指定か?
-------------------------------------------------------------------------------
valid_direction:: Pt -> Bool
valid_direction (dx,dy) =
     ((abs dx <= 1) && (abs dy <= 1)) &&
     (not ((dx==0)&&(dy==0)))

-------------------------------------------------------------------------------
-- pointが盤面の境界を越えているか??
-------------------------------------------------------------------------------
out_of_bounds:: Pt -> Bool
out_of_bounds (x,y) =
    (y<0) || (x<0) || (y>=boardSize) || (x>=boardSize)

-------------------------------------------------------------------------------
-- flippable-range+-dir: 1方向に関して石の挟むことのできる範囲を返す．
-- bwの手番でpointのdir方向で挟むことのできる石の範囲を返す．
-- 挟める石がなければ[]を返す．
-- 範囲は，(反転できる始点 反転できる終点の隣)を返す
--   bw    手番
--   point 石を置く場所
--   dir   方向
--   board 局面
-- 例:
-- flippable_range_dir Black (1,1) (0,1) board => [(1,2),(1,6)]
-- (1,2) (1,3) (1,4) (1,5)が反転できることを意味する．
-- つまり，(1,2)--(1,5)は相手の石，(1,6)はbwの石である．
-------------------------------------------------------------------------------
flippable_range_dir:: Piece -> Pt -> Pt -> Board -> [Pt]
flippable_range_dir bw point dir board =
    if
        (getBoard board point == Empty) && (valid_direction dir)
    then
        if (the_same_point s_end point)
        then []
        else
            if (getBoard board s_end_next) == bw
            then [(neighbor point dir), s_end_next]
            else []
    else
        []
    where
        s_end = (run_end point dir (opponent bw) board)
        s_end_next = (neighbor s_end dir)
-- flippable_range_dir black [3,4] [1,0] initBoard => [[4,4],[5,4]]


-------------------------------------------------------------------------------
-- run-dirs: 石を挟める方向を列挙する
-- bwの手番でpointで石を挟める方向を列挙する
--   bw    手番
--   point 石を置く場所
--   board 局面
-------------------------------------------------------------------------------
run_dirs:: Piece -> Pt -> Board -> [Pt]
run_dirs bw point board =
    aux [] directions
    where
        aux p dirs
            | (null dirs) = p
            | null (flippable_range_dir bw point (head dirs) board) = aux p (tail dirs)
            | otherwise = aux (p ++ [head dirs]) (tail dirs)
-- run_dirs black [3,4] initBoard => [(1,0)]

-------------------------------------------------------------------------------
-- do-flip-dir: 1方向に関して石の反転処理を行う．
-- pointのdir方向にbwへの反転を実行する．
-- dir方向の隣接点から反転することに注意．
-- (point自体については操作しない)
--   bw    手番
--   point 石を置く場所
--   dir   方向
--   board 局面
-------------------------------------------------------------------------------
do_flip_dir:: Piece -> Pt -> Pt -> Board -> Board
do_flip_dir bw point dir board =
    flip board (neighbor point dir)
    where
        seq = (flippable_range_dir bw point dir board)
        seq_end = head(tail seq)
        flip board p =
            if the_same_point p seq_end
            then board
            else (flip (setBoard board p bw) (neighbor p dir))
-- do_flip_dir black [3,4] [1,0] initBoard => [[1,0]]
-- setBoard initBoard [3,4] black


-------------------------------------------------------------------------------
-- do-move: 石を置く
-- 引数
--   bw    手番
--   point 石を置く場所 (y x)
--   board 局面
-- bwの手番で，pointに石を置く．
-- 手が有効であれば，石を置く処理を行って#tを返す．
-- そうでなければ，#fを返す．
-------------------------------------------------------------------------------
do_move:: Piece -> Pt -> Board -> (Bool,Board)
do_move bw point board =
    let
        d = (run_dirs bw point board)
    in
        if (null d)
        then (False, board)
        else (True, (do_move_aux board d))
    where
        -- do-move-aux: 石を置く処理を行う
        -- 引数 
        --   dirs 反転処理を行う方向のリスト
        -- dirsが空であれば，石をpointに置く．
        -- そうでなければ，dirsに含まれる方向について石の反転処理を行う
        do_move_aux board dirs =
            if null dirs
            then
                (setBoard board point bw)
            else
                (do_move_aux (do_flip_dir bw point (head dirs) board) (tail dirs))
-- do_move black [3,4] initBoard

-------------------------------------------------------------------------------
-- 候補手のリストを生成する．
--   bw    手番
--   board 局面
-------------------------------------------------------------------------------
moves:: Piece -> Board -> [Pt]
moves bw board =
    filter
        (\point -> not $ null (run_dirs bw point board))
        [(x,y) | x<-[1..8], y<-[1..8]]
-- moves black initBoard => [[3,4],[4,3],[5,6],[6,5]]
-- moves white initBoard => [[3,5],[4,6],[5,3],[6,4]]


-------------------------------------------------------------------------------
-- ゲームの補助関数
-- 引数
--   bw     手番
--   board  現在の局面データ
--   count  盤面上の石の個数
--   passed 相手が直前にパスしたか(True/False)
-------------------------------------------------------------------------------
game_aux:: (Piece->Board->IO(Bool,Board)) -> (Piece->Board->IO(Bool,Board)) -> Piece -> Board -> Int -> Bool -> IO()
game_aux black_player white_player bw board count passed = do
    -- 局面の表示
    showBoard board
    if count == boardSize * boardSize || pcount board bw == 0
        then
            -- 盤面が全て埋めつくされているか，
            -- 手番のプレイヤbwの石がないなら終了
            game_end_message board
        else
            -- 一手進める
            if null (moves bw board)
            then
                -- bwの打つ手がない場合(PASS)
                if passed
                    -- 直前に相手もPASSをしていた場合
                    -- お互いに打つところがない→終了
                    then game_end_message board
                    -- そうでない場合は，相手の手番に移る
                    else do
                        putStrLn (show bw ++ " PASS")
                        -- 次の手番(bwはPASSした)
                        game_aux black_player white_player (opponent bw) board count True
            else
                -- bwに手を決めて石を置いてもらう
                do
                    (done,newBoard) <- (if bw == Black then black_player else white_player) bw board
                    -- 次の手番(*-player-moveが True を返した場合)
                    if done
                        then game_aux black_player white_player (opponent bw) newBoard (1 + count) False
                        -- 投了(*-player-moveが False を返した場合)
                        else game_end_message board
    where
        game_end_message board = do
            putStrLn "*** GAME OVER ***"
            putStrLn ("Black vs White " ++ show (pcount board Black) ++ " " ++ show (pcount board White))

-------------------------------------------------------------------------------
-- reversiの対戦を行う
-- 引数
--   black_player 黒番の操作を行う関数
--   white_player 白番の操作を行う関数
--   これらの関数は，手を決めて石を配置する処理を適宜行う
--   ものとする．また次のように真偽値を返すものとする．
--     1. ゲームを続行する場合は True
--     2. 投了する場合は False
-- man_moveを使うとユーザが操作を行うことになる．
-------------------------------------------------------------------------------
game:: (Piece->Board->IO(Bool,Board)) -> (Piece->Board->IO(Bool,Board)) -> IO()
game black_player white_player =
    -- gameの本体(game-auxの呼びだし)
    -- 現在の状態が与えられない場合は，初期状態からスタート
    game_aux black_player white_player Black initBoard 4 False


-------------------------------------------------------------------------------
-- man-move: MANプレイヤ操作関数
-- 引数
--   bw    手番
--   board 局面
-- 手を(y x)で入力して 局面を進めて，#tを返す．
-- 入力が^Dであった場合は，投了であるとして，#fを返す．
-------------------------------------------------------------------------------
man_move:: Piece -> Board -> IO (Bool,Board)
man_move bw board = do
    -- プロンプト
    putStrLn (show bw ++ ">> ")
    -- 手を読み込む
    x <- getLine >>= return . read
    y <- getLine >>= return . read
    if x == -1
        then  return (False, board) -- ^Dなら#fを返して終了
        else
            if out_of_bounds (x,y)
                then do
                    putStrLn "illegal position"
                    man_move bw board       -- 手が無効(盤の外)
                else
                    let
                        (done,newBoard) = do_move bw (x,y) board    -- 指定された石を置く
                    in
                        if done 
                            then return (done,newBoard)
                            else do
                                putStrLn "illegal position"
                                man_move bw board

-------------------------------------------------------------------------------
-- メイン
-------------------------------------------------------------------------------
main:: IO ()
main = game man_move man_move

{------------------------------------------------------------------------------
使用例：
C:\user\lisp\Haskell>ghc Reversi.hs -o Reversi.exe

C:\user\lisp\Haskell>Reversi
X X X X X X X X X X
X - - - - - - - - X
X - - - - - - - - X
X - - - - - - - - X
X - - - W B - - - X
X - - - B W - - - X
X - - - - - - - - X
X - - - - - - - - X
X - - - - - - - - X
X X X X X X X X X X
Black>>
3
4
X X X X X X X X X X
X - - - - - - - - X
X - - - - - - - - X
X - - - - - - - - X
X - - B B B - - - X
X - - - B W - - - X
X - - - - - - - - X
X - - - - - - - - X
X - - - - - - - - X
---------------------------------------------------------------------------------}