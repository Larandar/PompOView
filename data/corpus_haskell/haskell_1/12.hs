--													PROGRAMMATION FONCTIONNELLE
--															
--														  L3 Informatique
--															
--														DEVOIR 2 - Othello

-- Chaque case sera remplie par une pièce
data Piece = Vide | Noir | Blanc | Extremite
	deriving (Eq, Show)
	
-- Le plateau sera une liste de liste de pièces
type Plateau = [[Piece]]

-- Un point est considéré comme des coordonnées (x,y)
type Points = (Int,Int)

-- La taille du plateau sera 8 (plateau 8 x 8 cases)
taillePlateau :: Int
taillePlateau = 8

-- Les différentes positions possibles à partir de la case C
-- 		Case au Nord -> (0, 1)	
-- 		Case au Nord-Est ->  (1, 1)								
-- 		Case à l'Est -> (1, 0)								
-- 		Case au Sud-Est -> (1,-1)							
-- 		Case au Sud -> (0, -1)								
-- 		Case au Sud-Ouest -> (-1, -1)						
-- 		Case à l'Ouest -> (-1, 0)							
-- 		Case au Nord-Ouest -> (-1, 1)						
positions :: [Points]
positions = [(0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (1, -1), (-1, 0), (-1, 1)]


-- L'initialisation du plateau se fait avec 9 colonnes et 9 lignes
-- On utilise 9 colonnes car les positions (0, 0), (9, 0), (0, 9) et (9, 9) marque les
-- extrémités de notre plateau
-- Par défaut, au lancement du jeu, nous aurons:
-- 		Un pion noir à la position (4, 5) et (5, 4)
-- 		Un pion blanc à la position (4, 4) et (5, 5)
initialisePlateau :: Plateau
initialisePlateau = [[ (f x y) | x <- [0..9]] | y <- [0..9]]
	where
		f x y
			| x == 0 || y == 0 || x == 9 || y == 9  = Extremite
			| x == 4 && y == 4  = Blanc
			| x == 5 && y == 5  = Blanc
			| x == 4 && y == 5  = Noir
			| x == 5 && y == 4  = Noir
			| otherwise = Vide

-- Le lecture d'un plateau. On prend en entrée le plateau et des coordonnées pour fabriquer une pièce
lecturePlateau :: Plateau -> Points -> Piece
lecturePlateau plateau (x,y) = plateau !! y !! x

-- On actualise notre liste de pièces disponibles sur notre plateau
actualisePlateau :: Plateau -> Points -> Piece -> Plateau
actualisePlateau plateau (x,y) val = 
    (take y plateau) ++ ((take x b) ++ val : (drop (x + 1) b)) : (drop (y + 1) plateau)
    where
        b = plateau !! y

-- Affichage de notre plateau (graphique)
affichePlateau :: Plateau -> IO ()
affichePlateau plateau = putStr (concat (map showLine plateau))
    where
        showLine line = concat (map getSymbol line) ++ "\n"
        getSymbol val = case val of
            Vide -> "- "
            Noir -> "N "
            Blanc -> "B "
            Extremite  -> "X "

-- L'adversaire d'un pion est soit Noir ou blanc (Piece vs Piece)
adversaire :: Piece -> Piece
adversaire adv 
	| adv == Blanc = Noir
	| otherwise = Blanc



-- Le nombre de pièces présentes sur notre plateau (nombre de pions blancs et nombre
-- de pions noirs)
piecesPresentes :: Plateau -> Piece -> Int
piecesPresentes plateau adv = length (filter (\val -> val == adv) (concat plateau))


-- Les voisins d'un point (d'une case)
voisin :: Points -> Points -> Points
voisin (x,y) (dx,dy) = (x + dx, y + dy)

-- Est-ce que la combinaison des points du joueur est correcte
lancement_decisif :: Points -> Points -> Piece -> Plateau -> Points
lancement_decisif points dir adv plateau =
    if lecturePlateau plateau p == adv
        then (lancement_decisif p dir adv plateau)
    else points
    where
        p = voisin points dir

-- Deux points égaux (P1 == P2)
point_identique :: Points -> Points -> Bool
point_identique (x1,y1) (x2,y2) = x1==x2 && y1==y2

-- Il faut aussi penser à vérifier que la direction choisie pour placer un pion est correcte
direction_valide :: Points -> Bool
direction_valide (dx,dy) = ((abs dx <= 1) && (abs dy <= 1)) && (not ((dx == 0)&&(dy == 0)))

-- Booléen qui vérifie que le joueur ne place pas des pions hors de la grille (environnement de la grille)
hors_environnement :: Points -> Bool
hors_environnement (x,y) = (x < 0) || (x >= taillePlateau) || (y < 0) || (y >= taillePlateau)


-- La rangée qui sera traitée. Si nous avons la disposition:
--			  0 1 2 3 4 5 6 7 8
--			0 X|X|X|X|X|X|X|X|X|X
-- 			1 X|-|-|-|-|-|-|-|-|X
-- 			2 X|-|-|-|-|-|-|-|-|X
-- 			3 X|-|-|-|-|-|-|-|-|X
-- 			4 X|-|-|Y|B|N|-|-|-|X
-- 			5 X|-|-|-|N|B|-|-|-|X
-- 			6 X|-|-|-|-|-|-|-|-|X 
-- 			7 X|-|-|-|-|-|-|-|-|X 
-- 			8 X|-|-|-|-|-|-|-|-|X
--			  X|X|X|X|X|X|X|X|X|X
-- 
-- Supposons que nous sommes un joueur Noir. On veut placer son pion à l'emplacement Y.
-- La méthode 'rangee_pions_interaction Noir [3,4] [1,0] initialisePlateau'
-- nous renvoie alors la liste des points qui seront 'victimes' au nouveau pion (en Y)
-- Cette méthode nous renvoie donc [[4,4],[5,4]]
rangee_pions_interaction :: Piece -> Points -> Points -> Plateau -> [Points]
rangee_pions_interaction adv emplacement dir plateau =
    if (lecturePlateau plateau emplacement == Vide) && (direction_valide dir)
    then
        if (point_identique s_end emplacement)
        then []
        else
            if (lecturePlateau plateau s_end_next) == adv
            then [(voisin emplacement dir), s_end_next]
            else []
    else
        []
    where
        s_end = (lancement_decisif emplacement dir (adversaire adv) plateau)
        s_end_next = (voisin s_end dir)


-- La fonction 'pion_adverse' nous permet de vérifier à chaque fois qu'on joue, on a bien un pion de couleur opposé, adjacent
-- au coordonées jouées.
-- La rangée qui sera traitée. Si nous avons la disposition:
--			  0 1 2 3 4 5 6 7 8
--			0 X|X|X|X|X|X|X|X|X|X
-- 			1 X|-|-|-|-|-|-|-|-|X
-- 			2 X|-|-|-|-|-|-|-|-|X
-- 			3 X|-|-|-|-|-|-|-|-|X
-- 			4 X|-|-|N|B|N|-|-|-|X
-- 			5 X|-|-|-|N|B|-|-|-|X
-- 			6 X|-|-|-|-|-|-|-|-|X 
-- 			7 X|-|-|-|-|-|-|-|-|X 
-- 			8 X|-|-|-|-|-|-|-|-|X
--			  X|X|X|X|X|X|X|X|X|X

-- Par exemple, 'pion_adverse Noir [3,4] initialisePlateau' nous "renvoie" [(1,0)]. Si
-- l'on considère la direction (1,0) à partir du point (3,4), on a bien un pion BLANC
-- donc, coup OK.
pion_adverse :: Piece -> Points -> Plateau -> [Points]
pion_adverse adv emplacement plateau =
    aux [] positions
    where
        aux p dirs
            | (null dirs) = p
            | null (rangee_pions_interaction adv emplacement (head dirs) plateau) = aux p (tail dirs)
            | otherwise = aux (p ++ [head dirs]) (tail dirs)

            
            
            
            
            
-- On traite le coup du jouer en vérifiant l'exactitude du coup (l'emplacement) et on actualise notre tableau;
-- sachant que si on joue un pion en (5,7), les pions en [(5,4),(5,5),(5,6)] sont victimes (d'après la méthode
-- rangee_pions_interaction), et ensuite convertis en pions blanc

--			  0 1 2 3 4 5 6 7 8  									  0 1 2 3 4 5 6 7 8  
--			0 X|X|X|X|X|X|X|X|X|X									0 X|X|X|X|X|X|X|X|X|X
-- 			1 X|-|-|-|-|-|-|-|-|X									1 X|-|-|-|-|-|-|-|-|X
-- 			2 X|-|-|-|-|-|-|-|-|X									2 X|-|-|-|-|-|-|-|-|X
-- 			3 X|-|-|-|-|B|-|-|-|X		Pion Blanc en (5,7)			3 X|-|-|-|-|B|-|-|-|X
-- 			4 X|-|-|N|N|N|-|-|-|X				+					4 X|-|-|N|N|B|-|-|-|X
-- 			5 X|-|-|-|N|N|-|-|-|X	  actualisation du Plateau		5 X|-|-|-|N|B|-|-|-|X
-- 			6 X|-|-|-|-|N|-|-|-|X	  ----------------------->		6 X|-|-|-|-|B|-|-|-|X 
-- 			7 X|-|-|-|-|-|-|-|-|X 									7 X|-|-|-|-|B|-|-|-|X
-- 			8 X|-|-|-|-|-|-|-|-|X									8 X|-|-|-|-|-|-|-|-|X
--			  X|X|X|X|X|X|X|X|X|X									  X|X|X|X|X|X|X|X|X|X
jouer_Et_actualiser :: Piece -> Points -> Points -> Plateau -> Plateau
jouer_Et_actualiser adv emplacement dir plateau =
    flip plateau (voisin emplacement dir)
    where
    	-- Les pions qui seront victimes. A travers 'seq', on force l'évaluation de la
    	-- fonction 'rangee_pions_interaction'
        seq = (rangee_pions_interaction adv emplacement dir plateau)
        seq_end = head(tail seq)
        flip plateau p =
            if point_identique p seq_end
            then plateau
            else (flip (actualisePlateau plateau p adv) (voisin p dir))


-- Peut-on effectuer tel ou tel déplacement
executer_deplacement :: Piece -> Points -> Plateau -> (Bool,Plateau)
executer_deplacement adv emplacement plateau =
    let
        d = (pion_adverse adv emplacement plateau)
    in
        if (null d)
        then (False, plateau)
        else (True, (executer_deplacement_aux plateau d))
    where
        executer_deplacement_aux plateau dirs =
            if null dirs
            then
                (actualisePlateau plateau emplacement adv)
            else
                (executer_deplacement_aux (jouer_Et_actualiser adv emplacement (head dirs) plateau) (tail dirs))



-- La fonction 'coup' nous renvoie une liste de listes de points où le joueur peut jouer.
-- Par exemple, à l'initialisation  de notre grille, on a:
-- 		Un pion noir à la position (4, 5) et (5, 4)
-- 		Un pion blanc à la position (4, 4) et (5, 5)
-- 
-- Les coups possibles sont alors:
-- 		coup Noir initialisePlateau => [[3,4],[4,3],[5,6],[6,5]]
-- 		coup Blanc initialisePlateau => [[3,5],[4,6],[5,3],[6,4]]
coups :: Piece -> Plateau -> [Points]
coups adv plateau =
    filter
        (\emplacement -> not $ null (pion_adverse adv emplacement plateau))
        [(x,y) | x<-[1..8], y<-[1..8]]



-- Le controlleur de l'application
jeu :: (Piece -> Plateau -> IO(Bool,Plateau)) -> (Piece -> Plateau -> IO(Bool,Plateau)) -> IO()
jeu joueur_pion_noir joueur_pion_blanc = jeu_aux joueur_pion_noir joueur_pion_blanc Noir initialisePlateau 4 False


-- La méthode 'jeu_aux' va à son tour vérifier les différents coups du joueur par rapport au plateau existant
jeu_aux :: (Piece -> Plateau -> IO(Bool,Plateau)) -> (Piece -> Plateau -> IO(Bool,Plateau)) -> Piece -> Plateau -> Int -> Bool -> IO()
jeu_aux joueur_pion_noir joueur_pion_blanc adv plateau count passed = do
    affichePlateau plateau
    -- Si toutes les cases sont remplies ou aucun des deux joueurs ne peut plus placer un pion (ce qui est fort improbable),
    -- le jeu se termine.
    if count == (taillePlateau * taillePlateau) || piecesPresentes plateau adv == 0
    	then
			msgFinPartie plateau
		else
			if null (coups adv plateau)
				then
					if passed
						then
							msgFinPartie plateau
						else do
							-- Si le joueur balnc ou noir ne peut placer son pion, il 'PASS'
							putStrLn (show adv ++ " PASS")
							jeu_aux joueur_pion_noir joueur_pion_blanc (adversaire adv) plateau count True
			else
				do
					(done,newBoard) <- (if adv == Noir then joueur_pion_noir else joueur_pion_blanc) adv plateau
					if done
						then
							jeu_aux joueur_pion_noir joueur_pion_blanc (adversaire adv) newBoard (1 + count) False
						else
							msgFinPartie plateau
	where
		msgFinPartie plateau = do
			putStrLn "*** PARTIE TERMINEE ***"
			putStrLn " "
			putStrLn " SCORE : "
			putStrLn ("Noir vs Blanc : " ++ show (piecesPresentes plateau Noir) ++ " " ++ show (piecesPresentes plateau Blanc))



-- Ici la fonction 'action_joueur' va traiter les positions des pions soumises par le joueur.
-- On va vérifier si les positions sont correctes (est-ce que le joueur prend au moins un pion
-- à chaque pose, est-ce que la case choisie pour placer un pion est déjà occupée)
action_joueur :: Piece -> Plateau -> IO (Bool,Plateau)
action_joueur adv plateau = do
	-- Attente de l'entrée du joueur pour le point x
    putStrLn (show adv ++ "->> ")
	-- Attente de l'entrée du joueur pour le point y
    x <- getLine >>= return . read
    y <- getLine >>= return . read
    if x == -1
    	-- Pour déclencher un abandon de la part du joueur. Si il rentre comme coordonnées (-1, -1), l'application se termine.
        then  return (False, plateau)
        -- On analyse ensuite les différents co-ordonnées entrées par l'utilisateur.
        else
            if hors_environnement (x,y)
                then do
                    putStrLn "Position illegale!!!"
                    action_joueur adv plateau
                else
                    let
                        (done,newBoard) = executer_deplacement adv (x,y) plateau
                    in
                        if done 
                            then return (done,newBoard)
                            else do
                                putStrLn "Position illegale!!!"
                                action_joueur adv plateau

--  Le 'main'
main :: IO ()
main = jeu action_joueur action_joueur
