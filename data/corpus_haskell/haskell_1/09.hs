-- *Les fonctions de test des différentes IA se trouvent à la fin de chaque parties concernée.
-- *Les fonctions permettant de jouer contre l'ordinateur se trouvent à la fin du fichier.

-- ************************************
-- PARTIE 0
-- ************************************
-- Fonctions générales.

-- ************************************
-- DATA ET PLATEAU PAR DEFAUT
-- ************************************
-- Type des cases.

data Case = N|B|V
	deriving (Show, Eq)

-- Position de depart du jeu.

plateauDepart =        [[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,B,N,V,V,V],
			[V,V,V,N,B,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V]]
plateau1 = 	[       [V,V,V,V,V,V,V,V],
			[V,N,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V]]
plateau2 = 	[       [V,B,N,V,V,V,V,V],
			[V,B,N,V,V,V,V,V],
			[V,V,N,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V]]
-- ************************************
-- AFFICHAGE
-- ************************************
-- Affiche un plateau (8x8 cases).

sep = " +---+---+---+---+---+---+---+---+"
afficherPlateau [] = sep ++ " ^\nX> 1   2   3   4   5   6   7   8   Y"
afficherPlateau (l:ls) = sep ++ "\n" ++ (afficheLigne l (8 - (length ls))) ++ "\n" ++ (afficherPlateau ls)
	where
	afficheLigne [] x = " | " ++ (show x)
	afficheLigne (e:xs) x = " | " ++ (afficheElem e) ++ (afficheLigne xs x)
		where
		afficheElem V = " "
		afficheElem N = "#"
		afficheElem B = "O"

-- ************************************
-- ACCESSEURS
-- ************************************
-- Retourne la valeur de la case en x y (x abscisse, y ordonnée).
valeurCase :: Int -> Int -> [[Case]] -> Case
valeurCase _ _ [] = V
valeurCase x 1 (l:ls) = valeurCaseLigne x l
	where
	valeurCaseLigne _ [] = V
	valeurCaseLigne 1 (l:ls) = l
	valeurCaseLigne x (l:ls) = valeurCaseLigne (x-1) ls
valeurCase x y (l:ls) = valeurCase x (y-1) ls

-- Place une valeur dans la case en x y (x abscisse, y ordonnée).
setCase :: Int -> Int -> Case -> [[Case]] -> [[Case]]
setCase _ _ _ [] = []
setCase x 1 couleur (l:ls) = (setCaseLigne x couleur l):ls
	where
	setCaseLigne _ _ [] = []
	setCaseLigne 1 couleur (l:ls) = couleur:ls
	setCaseLigne x couleur (l:ls) = l:(setCaseLigne (x-1) couleur ls)
setCase x y couleur (l:ls) = l:(setCase x (y-1) couleur ls)

-- Methode indiquant si une case en x y est vide.
caseVide :: Int -> Int -> [[Case]] -> Bool
caseVide _ _ [] = False
caseVide x 1 (l:ls) = caseVideLigne x l
	where
	caseVideLigne _ [] = False
	caseVideLigne 1 (V:ls) = True
	caseVideLigne 1 (l:ls) = False
	caseVideLigne x (l:ls) = caseVideLigne (x-1) ls
caseVide x y (l:ls) = caseVide x (y-1) ls

-- Methode retournant la couleur de l'adversaire.
couleurInverse :: Case -> Case
couleurInverse B = N
couleurInverse N = B

-- ************************************
-- PARTIE I
-- ************************************
-- 1.1) Liste des coups possibles pour un joueur.
-- On retourne une liste de tuples (x,y) correspondant aux coordonnées du coup possible.
-- Retourne la ligne des coups possibles.
coupsPossibles :: Case -> [[Case]] -> [(Int, Int)]
coupsPossibles x y = coupsPossibles2 8 8 x y y
	where
	coupsPossibles2 x y couleur [] grille = []
	coupsPossibles2 x y couleur (l:ls) grille = (coupsPossiblesLigne x y couleur l grille) ++ (coupsPossibles2 x (y-1) couleur ls grille)
	coupsPossiblesLigne _ _ _ [] _ = []
	coupsPossiblesLigne x y couleur (l:ls) grille
		| (coupValide x y couleur grille) = (x,y):(coupsPossiblesLigne (x-1) y couleur ls grille)
		| otherwise = (coupsPossiblesLigne (x-1) y couleur ls grille)

-- Methode indiquant si un coup est valide.
-- un coup est valide s'il est sur une case vide et qu'il prend des pions.		
coupValide :: Int -> Int -> Case -> [[Case]] -> Bool
coupValide x y n plateau = (caseVide x y plateau) && (prendPions x y n plateau)

-- Methode retournant si un coup joué en x/y prend des pions.
prendPions :: Int -> Int -> Case -> [[Case]] -> Bool
prendPions x y n plateau = prendPions2 x y n plateau 1
	where
	prendPions2 _ _ _ _ 10 = False
	prendPions2 a b c d 5 = prendPions2 a b c d 6
	prendPions2 x y n plateau dir = (prendPionsDirection x y ((mod (dir-1) 3)-1) ((div (dir-1) 3)-1) n plateau) || (prendPions2 x y n plateau (dir+1))

-- Methode retournant si un coup joué en x/y prend des pions dans la direction donnée par dx/dy.
prendPionsDirection :: Int -> Int -> Int -> Int -> Case -> [[Case]] -> Bool
prendPionsDirection x y dx dy couleur plateau = prendPionsDirection2 x y dx dy couleur plateau 0
	where
	prendPionsDirection2 x y dx dy couleur plateau pions
		| ((x + dx) < 1) || ((x + dx) > 8) || ((y + dy) < 1) || ((y + dy) > 8) = False
		| (caseVide (x+dx) (y+dy) plateau) = False
		| ((valeurCase (x+dx) (y+dy) plateau) == couleur) = if (pions > 0) then True else False
		| otherwise = prendPionsDirection2 (x+dx) (y+dy) dx dy couleur plateau (pions+1)

-- 1.2) Methode qui transforme le plateau selon un coup donné.
-- On passe en parametre les coordonnées x et y du coup, ainsi que la couleur de joueur et le plateau.
-- jouerCoup va vérifier si le coup est valide et ensuite retourner tous les pions que prends le joueur.
jouerCoup :: Int -> Int -> Case -> [[Case]] -> [[Case]]
jouerCoup x y couleur plateau
	| coupValide x y couleur plateau = setCase x y couleur (retournePions x y couleur plateau)
	| otherwise = plateau

-- Methode retournant les pions dans toutes les directions autour du pion joué.
retournePions :: Int -> Int -> Case -> [[Case]] -> [[Case]]
retournePions x y n plateau = retournePions2 x y n plateau 1
	where
	retournePions2 _ _ _ plateau 10 = plateau
	retournePions2 a b c d 5 = retournePions2 a b c d 6
	retournePions2 x y n plateau dir = retournePions2 x y n (retournePionsDirection x y ((mod (dir-1) 3)-1) ((div (dir-1) 3)-1) n plateau) (dir+1)

-- Methode retournant les pions a partir d'un coup en x/y, selon une direction donnee par dx/dy.
retournePionsDirection :: Int -> Int -> Int -> Int -> Case -> [[Case]] -> [[Case]]
retournePionsDirection x y dx dy couleur plateau
	| prendPionsDirection x y dx dy couleur plateau = retournePionsDirection (x+dx) (y+dy) dx dy couleur (setCase (x+dx) (y+dy) couleur plateau)
	| otherwise = plateau

-- 1.3) Afficher le score.
-- On retourne une chaine de caractere permettant d'afficher le score a l'ecran.
-- Pour cela, on compte le nombre de pions blancs a l'aide de la methode compterBlancs et le nombre de pions noirs a l'aide de la methode compterNoirs.
afficherScore :: [[Case]] -> [Char]
afficherScore x = "Blancs : " ++ (show (compterScore B x)) ++ "\nNoirs : " ++ (show (compterScore N x))

-- Methode permettant de calculer le score pour une certaine couleur.
compterScore _ [] = 0
compterScore c (x:xs) = (compterScoreLigne c x) + (compterScore c xs)
compterScoreLigne _ [] = 0
compterScoreLigne B (B:xs) = 1 + (compterScoreLigne B xs)
compterScoreLigne N (N:xs) = 1 + (compterScoreLigne N xs)
compterScoreLigne c (_:xs) = (compterScoreLigne c xs)
	
-- 1.4) Methode retournant si la partie est finie ou non.
-- La partie est finie si le plateau est plein, ou qu'il n'y a plus qu'une seule couleur.
-- Pour savoir s'il est recouvert d'une unique couleur, on recupere la premiere couleur apparaissant et on la compare a toutes les cases du plateau, si on trouve une couleur differente c'est faux.
-- Pour savoir si le plateau est plein, on verifie qu'il n'y ai pas une case de vide.
partieFinie :: [[Case]] -> Bool
partieFinie x = (estToutDeMemeCouleur x) || (estPlein x)
	where
	estPlein [] = True
	estPlein (x:xs) = (estPleinLigne x) && (estPlein xs)
	estPleinLigne [] = True
	estPleinLigne (V:xs) = False
	estPleinLigne (_:xs) = estPleinLigne xs
	estToutDeMemeCouleur x = estToutDeMemeCouleur2 (premiereCouleur x) x
	estToutDeMemeCouleur2 _ [] = True
	estToutDeMemeCouleur2 n (x:xs) = (estToutDeMemeCouleur2Ligne n x) && (estToutDeMemeCouleur2 n xs)
	estToutDeMemeCouleur2Ligne _ [] = True
	estToutDeMemeCouleur2Ligne B (N:xs) = False
	estToutDeMemeCouleur2Ligne N (B:xs) = False
	estToutDeMemeCouleur2Ligne n (x:xs) = estToutDeMemeCouleur2Ligne n xs
	premiereCouleur (x:xs) = if z == V then premiereCouleur xs else z
		where
		z = premiereCouleurLigne x
		premiereCouleurLigne [] = V
		premiereCouleurLigne (V:xs) = premiereCouleurLigne xs
		premiereCouleurLigne (x:xs) = x
		
-- 1.5) Programme permettant a 2 joueurs humains de jouer une partie.
-- Methode initialisant une partie.
jouerPartie = do
	putStrLn "Bienvenue dans Ote Hellos\n"
	p <- (jouerTourBlanc plateauDepart)
	putStrLn ("Partie Terminee!\n" ++ (afficherScore p))
	return p

-- Methode effectuant le tour du joueur Blanc (ou O).
jouerTourBlanc p = do
	putStrLn ((afficherPlateau p) ++ "\nC'est a O de jouer :")
	c <- getLine
	let coord = words c
	p2 <- if (coupValide (read (head coord)) (read (head (drop 1 coord))) B p) then (return (jouerCoup (read (head coord)) (read (head (drop 1 coord))) B p)) else (jouerTourBlanc p)
	p <- if (partieFinie p2) then (return p2) else (jouerTourNoir p2)
	return p

-- Methode effectuant le tour du joueur Noir (ou #).
jouerTourNoir p = do
	putStrLn ((afficherPlateau p) ++ "\nC'est a # de jouer :")
	c <- getLine
	let coord = words c
	p2 <- if (coupValide (read (head coord)) (read (head (drop 1 coord))) N p) then (return (jouerCoup (read (head coord)) (read (head (drop 1 coord))) N p)) else (jouerTourNoir p)
	p <- if (partieFinie p2) then (return p2) else (jouerTourBlanc p2)
	return p

-- Methode retounant un boolean indiquant si une couleur, a un moment donné, peut jouer.
peutJouer :: Case -> [[Case]] -> Bool
peutJouer n plateau = (length (coupsPossibles n plateau)) > 0

-- ************************************
-- PARTIE II
-- ************************************
-- Table des valeurs des cases.
grilleValeur = 	[[100,-20,10,5,5,10,-20,100],
			[-20,-50,-2,-2,-2,-2,-50,-20],
			[10,-2,-1,-1,-1,-1,-2,10],
			[5,-2,-1,-1,-1,-1,-2,5],
			[5,-2,-1,-1,-1,-1,-2,5],
			[10,-2,-1,-1,-1,-1,-2,10],
			[-20,-50,-2,-2,-2,-2,-50,-20],
			[100,-20,10,5,5,10,-20,100]]

-- Retourne la valeur affectée a la case x y.
getPoints :: Int -> Int -> [[Int]] -> Int
getPoints _ _ [] = -9999
getPoints x 1 (l:ls) = getPointsLigne x l
	where
	getPointsLigne _ [] = -9999
	getPointsLigne 1 (l:ls) = l
	getPointsLigne x (l:ls) = getPointsLigne (x-1) ls
getPoints x y (l:ls) = getPoints x (y-1) ls

-- 2.6) Joueur Maximisant.
-- Le but d'un tel joueur est de maximiser l'interet de son coup.
-- Pour cela on utilise la grille de valeurs fournie.
-- Joue le coup maximal.
jouerCoupMaximal :: Case -> [[Case]] -> [[Case]]
jouerCoupMaximal couleur plateau = jouerCoupMaximal2 (coupMaximal couleur plateau) couleur plateau
	where jouerCoupMaximal2 (x,y) couleur plateau = jouerCoup x y couleur plateau

-- Retourne le coup ayant la valeur maximale.
coupMaximal :: Case -> [[Case]] -> (Int, Int)
coupMaximal couleur plateau = coupMaximalDans (coupsPossibles couleur plateau)
	where
	coupMaximalDans [] = (0,0)
	coupMaximalDans (x:xs) = foldl (\a b -> if (getPointsCoup a) >= (getPointsCoup b) then a else b) x xs
		where
		getPointsCoup (x,y) = getPoints x y grilleValeur

-- Lance une partie entre deux joueurs maximisants.
testIAMaximal couleur p
	| partieFinie p = p
	| couleur == B = if (peutJouer N z) then testIAMaximal N z else testIAMaximal B z
	| otherwise = if (peutJouer B z) then testIAMaximal B z else testIAMaximal N z
	where
	z = jouerCoupMaximal couleur p

-- 2.7) Joueur MiniMax.
-- Pour trouver le meilleur coup, l'ordinateur evalue l'arbre de jeu complet.
-- Il etablit cet arbre en cherchant a maximiser sa performance, tout en evaluant que l'adversaire cherche a la minimiser (MiniMax).
-- Lorsqu'il est sur le noeud d'un de ses coups (noeud maximisant), il prend celui qui lui rapporte le plus, tandis que lorsqu'il est sur un des noeuds de l'adversaire (noeud minimisant) il prends la plus petite des valeurs disponibles.
-- Joue le coup maximal.
jouerCoupMinMax :: Case -> [[Case]] -> [[Case]]
jouerCoupMinMax couleur plateau = jouerCoupMinMax2 (coupMinMax couleur plateau) couleur plateau
	where jouerCoupMinMax2 (x,y) couleur plateau = jouerCoup x y couleur plateau

-- Retourne le coup maximal.
coupMinMax :: Case -> [[Case]] -> (Int, Int)
coupMinMax couleur plateau = coupMinMaxDans (coupsPossibles couleur plateau) plateau couleur couleur
	where
	coupMinMaxDans (x:ls) plateau couleur ordi = snd (foldl (\a b -> if ((fst a) >= (fst b)) then a else b) ((pointsCoupMinMax plateau couleur ordi x), x) (map (\g -> ((pointsCoupMinMax plateau couleur ordi g), g)) ls))
		where
		pointsCoupMinMax plateau couleur ordi (x,y)
			| (partieFinie z) = getPoints x y grilleValeur
			| (length cps) == 0 = pointsCoupMinMax z (couleurInverse couleur) ordi (0,0)
			| (couleur == ordi) = maximum (map (pointsCoupMinMax z (couleurInverse couleur) ordi) cps)
			| otherwise = minimum (map (pointsCoupMinMax z (couleurInverse couleur) ordi) cps)
			where
			z = jouerCoup x y couleur plateau
			cps = (coupsPossibles (couleurInverse couleur) z)

-- Lance une partie entre deux joueurs MiniMax (Interminable!).		
testIAMinMax couleur p
	| partieFinie p = p
	| couleur == B = if (peutJouer N z) then testIAMinMax N z else testIAMinMax B z
	| otherwise = if (peutJouer B z) then testIAMinMax B z else testIAMinMax N z
	where
	z = jouerCoupMinMax couleur p

-- 2.8) Joueur MiniMax avec profondeur.
-- Pour trouver le meilleur coup, l'ordinateur evalue l'arbre de jeu comme pour MiniMax, mais seulement sur une certaine profondeur.
-- Ceci a pour but d'accelerer les calculs, mais peut nuir a l'optimisation du choix du coup si la profondeur n'est pas suffisante.
-- Cela peut aussi permettre une moderation de l'IA. Avec une profondeur plus petite, l'ordinateur sera plus facile a vaincre.
-- Joue le coup maximal.
jouerCoupMinMaxProfondeur :: Case -> [[Case]] -> Int -> [[Case]]
jouerCoupMinMaxProfondeur couleur plateau profondeur = jouerCoupMinMaxProfondeur2 (coupMinMaxProfondeur couleur plateau profondeur) couleur plateau
	where jouerCoupMinMaxProfondeur2 (x,y) couleur plateau = jouerCoup x y couleur plateau

-- Retourne le coup maximal.
coupMinMaxProfondeur :: Case -> [[Case]] -> Int -> (Int, Int)
coupMinMaxProfondeur couleur plateau prof = coupMinMaxPDans (coupsPossibles couleur plateau) plateau couleur couleur prof
	where
	coupMinMaxPDans (x:ls) plateau couleur ordi prof = snd (foldl (\a b -> if ((fst a) >= (fst b)) then a else b) ((pointsCoupMinMaxP plateau couleur ordi prof x), x) (map (\g -> ((pointsCoupMinMaxP plateau couleur ordi prof g), g)) ls))
		where
		pointsCoupMinMaxP plateau couleur ordi prof (x,y)
			| (prof == 0) || (partieFinie z) = getPoints x y grilleValeur
			| (length cps) == 0 = pointsCoupMinMaxP z (couleurInverse couleur) ordi prof (0,0)
			| (couleur == ordi) = maximum (map (pointsCoupMinMaxP z (couleurInverse couleur) ordi (prof-1)) cps)
			| otherwise = minimum (map (pointsCoupMinMaxP z (couleurInverse couleur) ordi (prof-1)) cps)
			where
			z = jouerCoup x y couleur plateau
			cps = (coupsPossibles (couleurInverse couleur) z)

-- Lance une partie entre deux joueurs MiniMax (avec profondeur 3).
testIAMiniMaxProfondeur couleur p
	| partieFinie p = p
	| couleur == B = if (peutJouer N z) then testIAMiniMaxProfondeur N z else testIAMiniMaxProfondeur B z
	| otherwise = if (peutJouer B z) then testIAMiniMaxProfondeur B z else testIAMiniMaxProfondeur N z
	where
	z = jouerCoupMinMaxProfondeur couleur p 3
	
-- ************************************
-- PARTIE III
-- ************************************
-- 3.9) Joueur Alpha-Beta (avec profondeur).
-- Avec l'algorithme Alpha-Beta, l'ordinateur évalue l'arbre de jeu comme pour MiniMax mais en supprimant les noeuds (et sous-arbres correspondants) ne conduisant pas a des configurations dont la valeur contribuera au calcul du gain a la racine de l'arbre.
-- Cela nous donne un algorithme avec un temps d'éxecution largement superieur à MiniMax.
-- Joue le coup maximal.
jouerCoupAlphaBeta :: Case -> [[Case]] -> Int -> [[Case]]
jouerCoupAlphaBeta couleur plateau profondeur = jouerCoupAlphaBeta2 (coupAlphaBeta couleur plateau profondeur (-1000) 1000) couleur plateau
	where jouerCoupAlphaBeta2 (x,y) couleur plateau = jouerCoup x y couleur plateau

-- Retourne le coup maximal.
coupAlphaBeta :: Case -> [[Case]] -> Int -> Int -> Int -> (Int, Int)
coupAlphaBeta couleur plateau prof alpha beta = coupAlphaBetaDans (coupsPossibles couleur plateau) plateau couleur couleur prof alpha beta
	where
	coupAlphaBetaDans (x:ls) plateau couleur ordi prof alpha beta = snd (foldl (\a b -> if ((fst a) >= (fst b)) then a else b) ((pointsCoupAlphaBeta plateau couleur ordi prof alpha beta x), x) (map (\g -> ((pointsCoupAlphaBeta plateau couleur ordi prof alpha beta g), g)) ls))
		where
		pointsCoupAlphaBeta plateau couleur ordi prof alpha beta (x,y)
			| (prof == 0) || (partieFinie z) = getPoints x y grilleValeur
			| (length cps) == 0 = pointsCoupAlphaBeta z (couleurInverse couleur) ordi prof alpha beta (0,0)
			| (couleur == ordi) = maximumAlphaBeta cps alpha beta plateau couleur ordi prof
			| otherwise = minimumAlphaBeta cps alpha beta plateau couleur ordi prof
			where
			z = jouerCoup x y couleur plateau
			cps = (coupsPossibles (couleurInverse couleur) z)
			maximumAlphaBeta (cp:cps) alpha beta plateau couleur ordi prof
				| cps == [] = alpha2
				| alpha2 >= beta = alpha2
				| otherwise = maximumAlphaBeta cps alpha2 beta plateau couleur ordi prof
				where
				alpha2 = max alpha (pointsCoupAlphaBeta plateau (couleurInverse couleur) ordi (prof-1) alpha beta cp)
			minimumAlphaBeta (cp:cps) alpha beta plateau couleur ordi prof
				| cps == [] = beta2
				| alpha >= beta2 = beta2
				| otherwise = minimumAlphaBeta cps alpha beta2 plateau couleur ordi prof
				where
				beta2 = min beta (pointsCoupAlphaBeta plateau (couleurInverse couleur) ordi (prof-1) alpha beta cp)

-- Lance une partie entre deux joueurs AlphaBeta.			
testIAAlphaBeta couleur p
	| partieFinie p = p
	| couleur == B = if (peutJouer N z) then testIAAlphaBeta N z else testIAAlphaBeta B z
	| otherwise = if (peutJouer B z) then testIAAlphaBeta B z else testIAAlphaBeta N z
	where
	z = jouerCoupAlphaBeta couleur p 3

-- ********************************************
-- Jeu contre l'ordinateur en AlphaBeta
-- ********************************************
	-- Methode initialisant une partie.
jouerPartieAlphaBeta prof = do
	putStrLn "Bienvenue dans Ote Hellos\n"
	p <- (jouerTourBlancAlphaBeta plateauDepart prof)
	putStrLn ("Partie Terminee!\n" ++ (afficherScore p))
	return p

-- Methode effectuant le tour du joueur Blanc (ou O).
jouerTourBlancAlphaBeta p prof = do
	putStrLn ((afficherPlateau p) ++ "\nC'est a O de jouer :")
	c <- getLine
	let coord = words c
	p2 <- if (coupValide (read (head coord)) (read (head (drop 1 coord))) B p) then (return (jouerCoup (read (head coord)) (read (head (drop 1 coord))) B p)) else (jouerTourBlancAlphaBeta p prof)
	p <- if (partieFinie p2) then (return p2) else if (peutJouer N p2) then (jouerTourNoirAlphaBeta p2 prof) else (jouerTourBlancAlphaBeta p2 prof)
	return p

-- Methode effectuant le tour du joueur Noir (ou #).
jouerTourNoirAlphaBeta p prof = do
	putStrLn ((afficherPlateau p) ++ "\nC'est a # de jouer :")
	let p2 = jouerCoupAlphaBeta N p prof
	p <- if (partieFinie p2) then (return p2) else if (peutJouer B p2) then (jouerTourBlancAlphaBeta p2 prof) else (jouerTourNoirAlphaBeta p2 prof)
	return p

-- ********************************************
-- Jeu contre l'ordinateur en MinMax
-- ********************************************

-- Methode initialisant une partie.
jouerPartieMinMax prof = do
	putStrLn "Bienvenue dans Ote Hellos\n"
	p <- (jouerTourBlancMinMax plateauDepart prof)
	putStrLn ("Partie Terminee!\n" ++ (afficherScore p))
	return p

-- Methode effectuant le tour du joueur Blanc (ou O).
jouerTourBlancMinMax p prof = do
	putStrLn ((afficherPlateau p) ++ "\nC'est a O de jouer :")
	c <- getLine
	let coord = words c
	p2 <- if (coupValide (read (head coord)) (read (head (drop 1 coord))) B p) then (return (jouerCoup (read (head coord)) (read (head (drop 1 coord))) B p)) else (jouerTourBlancMinMax p prof)
	p <- if (partieFinie p2) then (return p2) else if (peutJouer N p2) then (jouerTourNoirMinMax p2 prof) else (jouerTourBlancMinMax p2 prof)
	return p

-- Methode effectuant le tour du joueur Noir (ou #).
jouerTourNoirMinMax p prof = do
	putStrLn ((afficherPlateau p) ++ "\nC'est a # de jouer :")
	let p2 = jouerCoupMinMaxProfondeur N p prof
	p <- if (partieFinie p2) then (return p2) else if (peutJouer B p2) then (jouerTourBlancMinMax p2 prof) else (jouerTourNoirMinMax p2 prof)
	return p
