--Donnees
data Case = N|B|V deriving Show
data Position = P Int Int deriving Show
data Coup = Coup Case Position Int Int deriving Show
data Joueur = Humain Case | Ordinateur Case Int deriving Show
data Tree = Node [(Tree, (Int,Int))] | Tip [[Case]] deriving Show

--Position de depart du jeu
plateauStart = [[V, V, V, V, V, V, V, V],
                [V, V, V, V, V, V, V, V],
                [V, V, V, V, V, V, V, V],
                [V, V, V, B, N, V, V, V],
                [V, V, V, N, B, V, V, V],
                [V, V, V, V, V, V, V, V],
                [V, V, V, V, V, V, V, V],
                [V, V, V, V, V, V, V, V]]
plateauTest = [[V, V, V, V, V, V, V, V],
                [V, V, V, V, V, V, V, V],
                [V, V, V, V, V, V, V, V],
                [N, N, N, B, B, N, N, N],
                [V, V, V, V, V, V, V, V],
                [V, V, V, V, V, V, V, V],
                [V, V, V, V, V, V, V, V],
                [V, V, V, V, V, V, V, V]]
grid = [[100, -20, 10,  5,  5, 10, -20, 100],
        [-20, -50, -2, -2, -2, -2, -50, -20],
        [ 10,  -2, -1, -1, -1, -1,  -2,  10],
        [  5,  -2, -1, -1, -1, -1,  -2,   5],
        [  5,  -2, -1, -1, -1, -1,  -2,   5],
        [ 10,  -2, -1, -1, -1, -1,  -2,  10],
        [-20, -50, -2, -2, -2, -2, -50, -20],
        [100, -20, 10,  5,  5, 10, -20, 100]]

dirs = [(0,1),(1,1),(1,0),(1,-1),(0,-1),(-1,-1),(-1,0),(-1,1)]

-- ************************************
-- AFFICHAGE
-- ************************************
--affiche un plateau ( 8x8 cases )
sep = "+---+---+---+---+---+---+---+---+"

affichePlateau [] = sep ++ "\n"
affichePlateau (l:ls) =
                sep ++ "\n" ++ (afficheLigne l) ++ "\n" ++ (affichePlateau ls)
                where
                afficheLigne [] =" |"
                afficheLigne (e:xs) = "| " ++ (afficheElem e) ++ (afficheLigne xs)
                                where
                                afficheElem V ="  "
                                afficheElem N ="# "
                                afficheElem B ="O "

-- FONCTION DE L'INTERFACE
-- Fonction prenant en paramètre deux joueurs et lancant le jeu avec ces joueurs
start j1 j2 = do
	putStr "Bienvenue dans Othello\n"
	jouer j1 j2 plateauStart
 
-- Fonction prenant en paramètre deux joueurs, un plateau et lancant le jeu
jouer j1 j2 plateau = do
			putStrLn (affichePlateau plateau)
			if (isFinish plateau)
				then do
					putStrLn (getGagnant (score plateau))
					putStrLn ("Score = " ++ show (score plateau))
				else do 
					if (peutJouer j1 plateau)
						then do 
						putStrLn ("C'est aux " ++ (couleurJoueur j1))
						p <- (tourDeJeu j1 plateau)
						jouer j2 j1  p
						else do
						putStrLn ("Les " ++ (couleurJoueur j1) ++ " ne peuvent pas jouer")	
						jouer j2 j1 plateau

-- Fonction représentant un tour de jeu d'un humain
-- Cette fonction demande des données à l'utilisateur et vérifie la validité du coup
tourDeJeu (Humain coul) plateau = do
				val <- getIndicesCase
				if (estUnCoup val plateau coul)
					then do
						return (jouerCoup val coul plateau)
					else do
						putStrLn "Ceci n'est pas un coup valide"
						p <- (tourDeJeu (Humain coul) plateau)
						return p

-- Fonction representant le tour de jeu d'un ordinateur
tourDeJeu (Ordinateur coul n) plateau = do
					if( n == 0 )
						then return (parcours (coups plateau coul) (0,0) (-100) plateau coul)
						else return (cpplay plateau coul n)

-- Fonction retournant le gagnant de la partie
getGagnant :: (Int, Int) -> String
getGagnant (a,b)
	| a > b = "Les blancs ont gagnes"
	| a < b = "Les noirs ont gagnes"
	| otherwise = "Egalite"

-- Fonction permettant d'acquerir un nombre
getNumber = do 	
		c <- getLine
		if ok c
			then return (toInt c)
			else do
				putStr "N'entrez que des chiffes : "
				val <- getNumber
				return val
-- Fonction permettant de recuperer la couleur d'un joueur sous forme de chaine de caracteres
couleurJoueur :: Joueur -> String
couleurJoueur (Humain B) = "Blancs"
couleurJoueur (Ordinateur B _) = "Blancs"
couleurJoueur (Humain N) = "Noirs"
couleurJoueur (Ordinateur N _) = "Noirs"

-- Fonctions du noyau du jeu
-- Fonction permettant de recuperer la liste des coups pour une couleur
coups :: [[Case]] -> Case -> [Coup]
coups plateau couleur = getCoups plateau 1 1 couleur plateau
	where
	getCoups [] _ _ _ _ = []
	getCoups (x:xs) nl nc coul plateau = getCoupsLigne x nl 1 coul plateau ++ getCoups xs (nl+1) 1 coul plateau
		where
		getCoupsLigne [] _ _ _ _ = []
		getCoupsLigne (y:ys) numligne numcol coul plateau
			| isEqual y coul = find numligne numcol coul plateau ++ getCoupsLigne ys numligne (numcol+1) coul plateau
			| otherwise = getCoupsLigne ys numligne (numcol+1) coul plateau

-- Fonction permettant de trouver des coups valide en partant d'une position donne dans toutes les directions
find :: Int -> Int -> Case -> [[Case]] -> [Coup]
find nl nc coul plateau = iterer nl nc dirs coul plateau

iterer :: Int -> Int -> [(Int,Int)] -> Case -> [[Case]] -> [Coup] 
iterer _ _ [] _ _= []
iterer numligne numcolon ((a,b):ys) coul plateau = parcourir (numligne+a) (numcolon+b) a b coul False plateau ++ iterer numligne numcolon ys coul plateau

-- Fonction permettant de parcourir une ligne (diagonale, verticale ...) à partir d'une position, pour trouver un coup jouable
parcourir :: Int -> Int -> Int -> Int -> Case -> Bool -> [[Case]] -> [Coup]
parcourir nl nc pasX pasY coul drop plateau
	| nl < 1 || nl>8 || nc<1 || nc>8 = []
	| isEqual coul (get nl nc plateau) = []
	| isEqual V (get nl nc plateau) && drop = [Coup coul (P nl nc) (-pasX) (-pasY)]
	| isEqual V (get nl nc plateau) && not drop = []
	| otherwise = parcourir (nl+pasX) (nc+pasY) pasX pasY coul True plateau

-- Fonction permettant de savoir si un joueur peut jouer
peutJouer :: Joueur -> [[Case]] -> Bool
peutJouer (Humain coul) plateau = length (coups plateau coul) > 0
peutJouer (Ordinateur coul _) plateau = length (coups plateau coul) > 0

-- Fonction représentant la recherche d'un coup la plus basique
-- l'ordinateur choisit le coup qui donne le meilleur score de la grille
parcours :: [Coup] -> (Int,Int) -> Int -> [[Case]] -> Case -> [[Case]]
parcours [] (a,b) val plateau coul
	| a==0 || b ==0 = plateau
	| otherwise = jouerCoup (a,b) coul plateau
parcours ((Coup _ (P nl nc) _ _):xs) (a,b) val plateau coul
	| (get nl nc grid) > val = parcours xs (nl,nc) (get nl nc grid) plateau coul
	| otherwise = parcours xs (a,b) val plateau coul
	where 
	get nl nc (x:xs)
		| nl> 1 = get (nl-1) nc xs
		| otherwise = get2 x nc
		where get2 (y:ys) nc 
			| nc > 1 = get2 ys (nc-1)
			| otherwise = y

-- Fonction permettant de rechercher un coup par l'algorithme min-max et de jouer ce coup
cpplay :: [[Case]] -> Case -> Int -> [[Case]]
cpplay plateau coul n = jouerCoup (minMax plateau n coul) coul plateau

-- Fonction permettant de créer un arbre de niveau n pour l'algorithme du min-max
getTree :: [[Case]] -> Int -> Case -> Tree
getTree plateau n coul
	| n > 0 = Node (getList plateau)
	| otherwise = Tip plateau
	where getList plateau = test ( getC plateau coul )
		where 
		test l
			| length l == 0 = associe [(0,0)]
			| otherwise = associe l
			where
			associe [] = []
			associe [(0,0)] = [(getTree plateau (n-1) (opp coul), (0, 0))]
			associe ((nl, nc):xs) = (getTree ( jouerCoup (nl,nc) coul plateau) (n-1) (opp coul), (nl, nc)) : associe xs

-- Fonction permettant de creer une liste simplifier des coups obtenus par le fonction coups
getC :: [[Case]] -> Case -> [(Int, Int)]
getC plateau coul = filtrer ( reduire ( coups plateau coul ) ) []

isIn :: (Int, Int) -> [(Int, Int)] -> Bool
isIn _ [] = False
isIn (a,b) ((c,d):xs)
	| not (a == c) || not (b == d) = isIn (a,b) xs
	| otherwise = True

filtrer :: [(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
filtrer [] acc = acc
filtrer (x:xs) acc
	| isIn x acc = filtrer xs acc
	| otherwise = filtrer xs (x:acc)

reduire :: [Coup] -> [(Int, Int)]
reduire [] = []
reduire ((Coup _ (P nl nc) _ _):xs) = (nl,nc):reduire xs

-- Fonctions de l'algorithme min-max
minMax :: [[Case]] -> Int -> Case -> (Int, Int)
minMax plateau n coul = prendreMeilleur (getTree plateau n coul)
	where  
	prendreMeilleur (Node l) = analyseLst l (0,0) 0 False
		where 
		analyseLst ((sousnoeud, (x, y)) :xs) (a,b) v False = analyseLst xs (x,y) (minimax sousnoeud False coul) True
		analyseLst [] (a,b) v drop = (a,b)
		analyseLst ((sousnoeud, (x, y)) :xs) (a,b) v drop
			| val > v = analyseLst xs (x,y) val drop
			| otherwise = analyseLst xs (a,b) v drop
			where val = minimax sousnoeud False coul

minimax :: Tree -> Bool -> Case -> Int
minimax (Tip plateau) drop coul = eval plateau coul
minimax (Node l) drop couleur
	| drop = selectMax l 0 False
	| otherwise = selectMin l 0 False
	where	
	selectMax [] v init = v
	selectMax ((sn,(a,b)):xs) v False = selectMax xs (minimax sn (not drop) couleur) True
	selectMax ((sn,(a,b)):xs) v init
		| val > v = selectMax xs val init 
		| otherwise = selectMax xs v init
		where	val = (minimax sn (not drop) couleur)
	selectMin [] v init = v
	selectMin ((sn,(a,b)):xs) v False = selectMin xs (minimax sn (not drop) couleur) True
	selectMin ((sn,(a,b)):xs) v init
		| val < v = selectMin xs val init	
		| otherwise = selectMin	xs v init
		where	val = (minimax sn (not drop) couleur)

-- Fonction d'évaluation d'un plateau
eval :: [[Case]] -> Case -> Int
eval plateau coul = eval2 plateau grid 0
	where 
	eval2 [] [] acc = acc
	eval2 (x:xs) (y:ys) acc = eval2 xs ys (parcour x y acc)
		where 	
		parcour [] [] acc = acc
		parcour (l:ls) (g:gs) acc
			| isEqual coul l = parcour ls gs (acc+g)
			| otherwise = parcour ls gs (acc-g)

-- Fonction permettant de jouer un coup représenter par un couple de valeur ( numero_ligne, numero_colonne)
jouerCoup :: (Int, Int) -> Case -> [[Case]] -> [[Case]]
jouerCoup (a,b) coul plateau = retourner plateau a b coul

-- Fonction demandant la saisie d'un couple de valeur à l'utilisateur
-- Ces valeurs représente le numero de ligne et le numero de colonne d'une case du jeu
getIndicesCase = do
			putStr "Ligne : "
			l <- getNumber
			putStr "Colonne : "
			c <- getNumber
			if l > 0 && l < 9 && c > 0 && c < 9 
				then return (l,c)
				else do
					putStr "Erreur de saisie\n"
					val <- getIndicesCase
					return val

ok :: [Char] -> Bool
ok [] = True
ok (x : xs)
	| x >= '0' && x <= '9' = True && ok xs
	| otherwise = False


-- Fonction permettant de verifier si un couple (numero_ligne, numero_colonne) est un coup valide
estUnCoup :: (Int, Int) -> [[Case]] -> Case -> Bool
estUnCoup (a,b) plateau coul = verifier a b (coups plateau coul)
	where 
	verifier _ _ [] = False
	verifier nl nc ((Coup _ (P l c) _ _):xs)
		| l==nl && c==nc = True
		| otherwise = verifier nl nc xs

-- Fonction permettant d'obtenir la valeur d'une case du jeu
get :: Int -> Int -> [[Case]] -> Case
get nl nc (x:xs)
	| nl > 1 = get (nl-1) nc xs
	| otherwise = get2 nc x
	where get2 numcol (y:ys)
		| numcol > 1 = get2 (numcol-1) ys
		| otherwise = y

-- Fonction permettant de modifier la valeur d'une case du jeu
set :: Int -> Int -> [[Case]] -> Case -> [[Case]]
set nl nc (x:xs) coul
	| nl > 1 = x : set (nl-1) nc xs coul
	| otherwise = set2 nc x coul : xs 	
	where set2 numcol (y:ys) coul
		| numcol > 1 = y : set2 (numcol-1) ys coul
		| otherwise = coul : ys

-- Fonction permettant de recuperer le score de la partie
score :: [[Case]] -> (Int, Int)
score plateau = foldl add (0,0) (tab plateau)
	where 
	tab [] = []
	tab (x:xs) = tabLigne x (0,0) : tab xs
		where 
		tabLigne [] (b,n) = (b,n)
		tabLigne (y:ys) (b,n)
			| isEqual y B = tabLigne ys ((b+1),n)
			| isEqual y N = tabLigne ys (b,(n+1))
			| otherwise = tabLigne ys (b,n)

-- Fonction prenant un numero de ligne et un numero de colonne et retournant les cases qu'il faut
retourner :: [[Case]] -> Int -> Int -> Case -> [[Case]]
retourner plateau nl nc coul = appliquerCoup plateau ( getOnly nl nc (coups plateau coul))
	
-- Fonction permettant de filtrer les coups disponibles sur un numero de colonne et un numero de ligne
getOnly :: Int -> Int -> [Coup] -> [Coup]
getOnly _ _ [] = []
getOnly nl nc ((Coup coul (P l c) pasX pasY ):cs)
	| nl == l && nc == c = Coup coul (P l c) pasX pasY : getOnly nl nc cs
	| otherwise = getOnly nl nc cs

-- Fonction permettant d'appliquer une liste de coup sur le plateau
appliquerCoup :: [[Case]] -> [Coup] -> [[Case]]
appliquerCoup plateau [] = plateau
appliquerCoup plateau ((Coup coul (P nl nc) pasX pasY):ys) = appliquerCoup (appliquer plateau (Coup coul (P nl nc) pasX pasY) False) ys
	
-- Fonction permettant d'appliquer un coup sur le plateau
appliquer :: [[Case]] -> Coup -> Bool -> [[Case]]
appliquer plateau (Coup coul (P nl nc) pasX pasY) drop
	| not drop = appliquer (set nl nc plateau coul) (Coup coul (P (nl+pasX) (nc+pasY)) pasX pasY) True
	| not (isEqual (get nl nc plateau) coul) = appliquer (set nl nc plateau coul) (Coup coul (P (nl+pasX) (nc+pasY)) pasX pasY) True
	| otherwise = plateau

-- Fonction permettant de verifier si une partie est terminee
isFinish :: [[Case]] -> Bool
isFinish plateau = verifScore (score plateau)
	where verifScore (a,b)
		| a==0 || b==0 || (a+b) == 64 = True
		| otherwise = False

-- FONCTION UTILITAIRES
-- Fonction permettant de convertir un nombre sous forme de chaine de caractère sous forme d'entier
toInt :: [Char] -> Int
toInt [] = 0
toInt (x:xs) = toDigit x * (puissance 10 (length xs)) + toInt xs
	where 
	toDigit '0' = 0
	toDigit '1' = 1
	toDigit '2' = 2
	toDigit '3' = 3
	toDigit '4' = 4
	toDigit '5' = 5
	toDigit '6' = 6
	toDigit '7' = 7
	toDigit '8' = 8
	toDigit '9' = 9

-- Fonction puissance
puissance :: Int -> Int -> Int
puissance a 0 = 1
puissance a n = a * puissance a (n-1)

-- Fonction pour verifier si deux cases sont identiques
isEqual :: Case -> Case -> Bool
isEqual V V = True
isEqual _ V = False
isEqual B B = True
isEqual _ B = False
isEqual N N = True
isEqual _ N = False

-- Fonction permettant d'obtenir la couleur oppose d'une case
opp :: Case -> Case
opp N = B
opp B = N
opp V = V

-- Fonction permettant d'additionner un couple de valeur
add :: (Int, Int) -> (Int, Int) -> (Int, Int)
add (a,b) (c,d) = (a+c,b+d)


