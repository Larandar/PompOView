-- ************************************
-- DATA ET PLATEAU PAR DEFAUT
-- ************************************

-- Type des cases
data Case = N|B|V deriving (Eq,Show)

type Position = (Int,Int)
type Direction = (Int,Int)
type Jeu = [[Case]]

-- liste des différentes direction possible
lesDirections = [(0,-1),(1,-1),(1,0),(1,1),(0,1),(-1,1),(-1,0),(-1,-1)]

plateauInitial =       [[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,B,N,V,V,V],
			[V,V,V,N,B,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V]]
plateauInitial2 =       [[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,N,N,V,V,V],
			[V,V,V,N,N,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V],
			[V,V,V,V,V,V,V,V]]
plateauTmp =   [[V,V,V,V,V,V,V,V],
		[V,V,V,V,V,V,V,V],
		[V,V,V,V,V,V,N,V],
		[V,V,V,B,N,B,V,V],
		[V,V,B,N,B,V,V,V],
		[N,B,B,N,B,B,V,V],
		[V,V,V,B,V,V,V,V],
		[V,V,V,V,V,V,V,V]]

plateauPlein = [[B,B,B,N,B,B,B,N],
		[B,B,B,N,B,B,B,B],
		[B,B,V,N,B,B,B,N],
		[B,B,B,B,B,N,B,N],
		[B,B,B,N,B,B,B,N],
		[B,B,B,N,B,N,B,N],
		[B,B,B,N,B,B,B,N],
		[B,B,B,N,B,B,B,N]]

valeurCase =	[[100,-20,10,5,5,10,-20,100],
		 [-20,-50,-2,-2,-2,-2,-50,-20],
		 [10,-2,-1,-1,-1,-1,-2,10],
		 [5,-2,-1,-1,-1,-1,-2,5],
		 [5,-2,-1,-1,-1,-1,-2,5],
		 [10,-2,-1,-1,-1,-1,-2,10],
		 [-20,-50,-2,-2,-2,-2,-50,-20],
		 [100,-20,10,5,5,10,-20,100]]
-- ************************************
-- AFFICHAGE
-- ************************************

-- affiche un plateau (8x8 cases)
sep = "+---+---+---+---+---+---+---+---+"

affichePlateau [] = sep
affichePlateau (l:ls) = sep ++ "\n" ++ (afficheLigne l) ++ "\n" ++ (affichePlateau ls)
			where
			afficheLigne [] = "|"
			afficheLigne (e:xs) = "|" ++ (afficheElem e) ++ (afficheLigne xs)
				where
				afficheElem V = "   "
				afficheElem N = " # "
				afficheElem B = " O "

-- ************************************
-- permet de récupérer la valeur de la case en position (x,y)
getCase :: Jeu -> Position -> Case
getCase (l:ls) (x,1)  = getCaseAux l x
	where
	getCaseAux (l:ls) 1 = l
	getCaseAux (l:ls) x = getCaseAux ls (x-1)
getCase (l:ls) (x,y)  = getCase ls (x,(y-1))

-- ************************************
-- modifie la valeur de la case en position (x,y) par la valeur donnée en paramètre
setCase :: Jeu -> Position -> Case -> Jeu
setCase (l:ls) (x,1) couleur  = (setCaseAux l x couleur):ls
	where
	setCaseAux (l:ls) 1 couleur = couleur:ls
	setCaseAux (l:ls) x couleur = l:(setCaseAux ls (x-1) couleur)
setCase (l:ls) (x,y) couleur = l:(setCase ls (x,(y-1)) couleur)

-- ************************************
-- retourne la valeur opposée de la valeur passée en paramètre
opposer :: Case -> Case
opposer couleur
	| couleur == B = N
	| couleur == N = B
	| couleur == V = V

-- ************************************
-- QUESTION 1.1
-- ************************************
-- retourne les coups admissible en position (x,y)
-- Jeu: le plateau du jeu
-- Position: la position (x,y)
-- Case: la valeur que les cases dont on va retournée la position
-- retourne la liste des positions
-- ex:	pour obtenir les positions de libre -> coupsAdmissibles jeu (x,y) V
--	pour connaitre si un pion peut etre placé il faut que qu'il y ai un 
--	pion de la meme couleur encadrant d'un ou des pions de la couleur opposée
--	ex pour le placement d'un pion noir -> coupsAdmissibles jeu (x,y) N
coupsAdmissibles :: Jeu -> Position -> Case -> [Position]
coupsAdmissibles plateau pos couleur = coupAdmissiblesAux plateau pos couleur lesDirections
	where
	coupAdmissiblesAux plateau pos couleur [] = []
	coupAdmissiblesAux plateau pos couleur (l:ls) = case directionAdmissible plateau pos l of
						True -> (position plateau pos l couleur):(coupAdmissiblesAux plateau pos couleur ls)
						False -> coupAdmissiblesAux plateau pos couleur ls


-- ************************************
-- permet de déterminer en fonction d'une position et d'une direction si celle ci est possible
-- le pions dans cette direction ne doit pas etre vide ou de la meme couleur que le pion en position (x,y)
directionAdmissible :: Jeu -> Position -> Direction -> Bool
directionAdmissible plateau (x,y) (dx,dy)
	| couleur == V = False
	| couleur == opposer(getCase plateau (x+dx,y+dy)) = True
	| otherwise = False
	where couleur = getCase plateau (x,y)

-- ************************************
-- retourne la position la plus eloignée
position :: Jeu -> Position -> Direction -> Case -> Position
position plateau (x,y) (dx,dy) couleur
	| x == 8 || x == 1 || y == 8 || y == 1 = (0,0)
	| getCase plateau (x+dx,y+dy) == couleur = (x+dx,y+dy)
	| otherwise = position plateau (x+dx,y+dy) (dx,dy) couleur

-- ************************************
-- QUESTION 1.2
-- ************************************
-- retourne tous les pions dans toutes les directions
retournePions :: Jeu -> Position -> Jeu
retournePions plateau pos = retournePionsAux plateau pos lesDirections
	where
	retournePionsAux plateau pos [] = plateau
	retournePionsAux plateau pos (l:ls) = retournePionsAux (retournePionsPourUneDirection plateau pos l) pos ls

-- ************************************
-- retourne les pions pour une direction
-- verifie que il y un bien un pion de la couleur opposée et a un pions de la meme couleur dans cette direction
retournePionsPourUneDirection :: Jeu -> Position -> Direction -> Jeu
retournePionsPourUneDirection plateau (x,y) (dx,dy)
	| couleur == opposer(getCase plateau (x+dx,y+dy)) && position plateau (x,y) (dx,dy) couleur /= (0,0) = retournePionsPourUneDirection (setCase plateau (x+dx,y+dy) couleur) (x+dx,y+dy) (dx,dy)
	| otherwise = plateau
	where couleur = getCase plateau (x,y)

-- ************************************
-- QUESTION 1.3
-- ************************************
-- affiche le score
score :: Jeu -> [Char]
score jeu = (show (scoreCouleur jeu N))++" Noir et "++(show (scoreCouleur jeu B))++" Blanc"

-- ************************************
-- calcul le score pour une couleur
scoreCouleur :: Jeu -> Case -> Int
scoreCouleur [] _ = 0
scoreCouleur (l:ls) couleur = (scoreCouleur ls couleur)+(scoreCouleurAux l couleur)
	where
	scoreCouleurAux [] _ = 0
	scoreCouleurAux (B:ls) B = 1+(scoreCouleurAux ls B)
	scoreCouleurAux (N:ls) N = 1+(scoreCouleurAux ls N)
	scoreCouleurAux (_:ls) x = (scoreCouleurAux ls x)

-- ************************************
-- QUESTION 1.4
-- ************************************
-- verifie si il reste de la place sur le plateau
plateauRempli :: Jeu -> Bool
plateauRempli [] = True
plateauRempli (l:ls) = (plateauRempliAux l)&&(plateauRempli ls)
	where
	plateauRempliAux [] = True
	plateauRempliAux (B:ls) = plateauRempliAux ls
	plateauRempliAux (N:ls) = plateauRempliAux ls
	plateauRempliAux (_:ls) = False

-- ************************************
-- QUESTION 1.5
-- ************************************
-- verifie si un coup est valide
coups :: Jeu -> Position -> Case -> Bool
coups plateau pos couleur =	if coupsAdmissibles(setCase plateau pos couleur) pos couleur == [(0,0)] || (getCase plateau pos /= V)
				then False
				else True

-- ************************************
jouerPartie plateau = do
	plateau <- (jouer plateau B)
	putStrLn ("Fin de la partie")
	putStrLn (affichePlateau plateau)
	putStrLn (score plateau)

-- ************************************
jouer plateau couleur = do
	putStrLn (affichePlateau plateau)
	if plateauRempli plateau 
		then do return plateau
		else do
			if couleur == B
				then putStrLn ("-- placement d'un pion Blanc --")
				else putStrLn ("-- placement d'un pion Noir --")
			putStrLn("x: ")
			x <- readLn
			putStrLn("y: ")
			y <- readLn
			case coups plateau (x,y) couleur of
				True ->	jouer (retournePions (setCase plateau (x,y) couleur) (x,y)) (opposer couleur)
				False -> jouer plateau couleur
			return plateau

-- ************************************
-- QUESTION 2.6
-- ************************************

-- ************************************
--getValeur :: [[Int]] -> Position -> Int
getValeur (l:ls) (x,1)  = getValeurAux l x
	where
	getValeurAux (l:ls) 1 = l
	getValeurAux (l:ls) x = getValeurAux ls (x-1)
getValeur (l:ls) (x,y)  = getValeur ls (x,(y-1))

-- ************************************
--ordinateur :: Jeu -> Case -> Jeu
--ordinateur plateau couleur = ordinateurAux plateau (ordinateurPosition plateau couleur) couleur
--	where ordinateurAux plateau (x,y) couleur = setCase plateau (x,y) couleur

-- ************************************
--ordinateurPosition :: Case -> Jeu -> Position


