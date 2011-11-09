-------------------------------------------------------------------------------
-- Auteurs : GERBEX Adrien et KAROUI Wajdi
-------------------------------------------------------------------------------

#!/usr/bin/runhugs
module Main where 

import Char

data Case = N | B | V
        deriving(Show, Eq)

type Position = (Int,Int)
type Grille = [[Case]]
type Score = (Int,Int)


-------------------------------------------------------------------------------
-- Fonction d'interaction avec l'utilisateur
-------------------------------------------------------------------------------

main = do
	(putStrLn "Vous pouvez jouer seul ou a deux")
	(putStrLn "Choisissez le nombre de joueur")
	nbJoueur <- getLine
	if ( nbJoueur == "1")
		then do
			(putStrLn "Choisissez le type de l'IA")
			(putStrLn "Pour alphaBeta tapez a")
			(putStrLn "pour minmax tapez m")
			typeIA <- getLine
			if ( typeIA == "a")
				then do
					(putStrLn "Choisissez le niveau de l'IA (1,2 ou 3)")
					niveau <- getLine
					(putStrLn "Choisissez la couleur des pions l'IA")
					(putStrLn "Pour les O tapez B")
					(putStrLn "Pour les # tapez N")
					couleur <- getLine
					if ( couleur == "B")
						then (demandePosIA2 B grilleDepart 0 (stringToInt(niveau)))
						else (demandePosJoueur2 B grilleDepart 0 (stringToInt(niveau)))
				else do
					(putStrLn "Choisissez le niveau de l'IA (1,2 ou 3)")
					niveau <- getLine
					(putStrLn "Choisissez la couleur des pions l'IA")
					(putStrLn "Pour les O tapez B")
					(putStrLn "Pour les # tapez N")
					couleur <- getLine
					if ( couleur == "B")
						then (demandePosIA B grilleDepart 0 (stringToInt(niveau)))
						else (demandePosJoueur B grilleDepart 0 (stringToInt(niveau)))
						
		else (demandePos B grilleDepart 0)
					





demandePos :: Case -> Grille -> Int -> IO ()
demandePos pion grille x = do
	putStrLn (affichePlateau grille)
	putStrLn ("Blanc:"++ (show (fst (score grille))) ++"   "++"Noir:"++ (show (snd (score grille))) ++ "\n" ++joueur pion)
	if (x == 2)
		then (putStrLn (gagnant grille))
		else do
			let coup = (coupsPossibles pion grille)
			if ( coup == [] )
				then do
					(putStrLn "Vous ne pouvez pas jouer")
					(demandePos (inversePion pion) grille (x+1))
				else do
					putStrLn "entrer la ligne : "
					l <- getLine
					putStrLn "entrer la colone : "
					c <- getLine
					let ligne = (stringToInt(l::String))
					let colone = (stringToInt(c::String))
					let position = consPos ligne colone
					if (elem position coup)
						then (joueCoup position pion grille)
						else do
							putStrLn "vous ne pouvez pas poser ce pion"
							(demandePos pion grille x)



demandePosJoueur::Case -> Grille -> Int -> Int -> IO ()
demandePosJoueur pion grille x i = do
	putStrLn (affichePlateau grille)
	putStrLn ("Blanc:"++ (show (fst (score grille))) ++"   "++"Noir:"++ (show (snd (score grille))) ++ "\n" ++joueur pion)
	if (x == 2)
		then (putStrLn (gagnant grille))
		else do
			let coup = (coupsPossibles pion grille)
			if ( coup == [] )
				then do
					(putStrLn "Vous ne pouvez pas jouer")
					(demandePosIA (inversePion pion) grille (x+1) i)
				else do
					putStrLn "entrer la ligne : "
					l <- getLine
					putStrLn "entrer la colone : "
					c <- getLine
					let ligne = (stringToInt(l::String))
					let colone = (stringToInt(c::String))
					let position = consPos ligne colone
					if (elem position coup)
						then (joueCoupJoueur position pion grille i)
						else do
							(putStrLn "vous ne pouvez pas poser ce pion")
							(demandePosJoueur pion grille x i)








demandePosIA::Case -> Grille -> Int -> Int -> IO ()
demandePosIA pion grille x i = do
	putStrLn (affichePlateau grille)
	putStrLn ("Blanc:"++ (show (fst (score grille))) ++"   "++"Noir:"++ (show (snd (score grille))) ++ "\n" ++joueur pion)
	if (x == 2)
		then (putStrLn (gagnant grille))
		else do
			let coup = (coupsPossibles pion grille)
			if ( coup == [] )
				then do
					(putStrLn "l'ordinateur ne peut pas jouer")
					(demandePosJoueur (inversePion pion) grille (x+1) i)
				else do
					(joueCoupIA (decision2 pion grille i) (pion) (grille) i)


demandePosJoueur2::Case -> Grille -> Int -> Int -> IO ()
demandePosJoueur2 pion grille x i = do
	putStrLn (affichePlateau grille)
	putStrLn ("Blanc:"++ (show (fst (score grille))) ++"   "++"Noir:"++ (show (snd (score grille))) ++ "\n" ++joueur pion)
	if (x == 2)
		then (putStrLn (gagnant grille))
		else do
			let coup = (coupsPossibles pion grille)
			if ( coup == [] )
				then do
					(putStrLn "Vous ne pouvez pas jouer")
					(demandePosIA2 (inversePion pion) grille (x+1) i)
				else do
					putStrLn "entrer la ligne : "
					l <- getLine
					putStrLn "entrer la colone : "
					c <- getLine
					let ligne = (stringToInt(l::String))
					let colone = (stringToInt(c::String))
					let position = consPos ligne colone
					if (elem position coup)
						then (joueCoupJoueur2 position pion grille i)
						else do
							(putStrLn "vous ne pouvez pas poser ce pion")
							(demandePosJoueur2 pion grille x i)


demandePosIA2::Case -> Grille -> Int -> Int -> IO ()
demandePosIA2 pion grille x i = do
	putStrLn (affichePlateau grille)
	putStrLn ("Blanc:"++ (show (fst (score grille))) ++"   "++"Noir:"++ (show (snd (score grille))) ++ "\n" ++joueur pion)
	if (x == 2)
		then (putStrLn (gagnant grille))
		else do
			let coup = (coupsPossibles pion grille)
			if ( coup == [] )
				then do
					(putStrLn "l'ordinateur ne peut pas jouer")
					(demandePosJoueur2 (inversePion pion) grille (x+1) i)
				else do
					(joueCoupIA2 (decision pion grille i) (pion) (grille) i)



joueCoup :: Position -> Case -> Grille -> IO ()
joueCoup pos pion g = do
	let grille = actualiseGrille pion pos listeDirection g
	if(estFinie grille)
		then do
			(putStrLn (affichePlateau grille ++ "\n" ++ "\n" ++ gagnant grille))
		else do
			demandePos (inversePion pion) grille 0


joueCoupJoueur :: Position -> Case -> Grille -> Int -> IO ()
joueCoupJoueur pos pion g i = do
	let grille = actualiseGrille pion pos listeDirection g
	if(estFinie grille)
		then (putStrLn (affichePlateau grille ++ "\n" ++ "\n" ++ gagnant grille))
		else demandePosIA (inversePion pion) grille 0 i

joueCoupJoueur2 :: Position -> Case -> Grille -> Int -> IO ()
joueCoupJoueur2 pos pion g i = do
	let grille = actualiseGrille pion pos listeDirection g
	if(estFinie grille)
		then (putStrLn (affichePlateau grille ++ "\n" ++ "\n" ++ gagnant grille))
		else demandePosIA2 (inversePion pion) grille 0 i


joueCoupIA :: Position -> Case -> Grille -> Int -> IO ()
joueCoupIA pos pion g i = do
	let grille = actualiseGrille pion pos listeDirection g
	if(estFinie grille)
		then (putStrLn (affichePlateau grille ++ "\n" ++ "\n" ++ gagnant grille))
		else demandePosJoueur (inversePion pion) grille 0 i


joueCoupIA2 :: Position -> Case -> Grille -> Int -> IO ()
joueCoupIA2 pos pion g i = do
	let grille = actualiseGrille pion pos listeDirection g
	if(estFinie grille)
		then (putStrLn (affichePlateau grille ++ "\n" ++ "\n" ++ gagnant grille))
		else demandePosJoueur2 (inversePion pion) grille 0 i


joueur :: Case -> String
joueur N = "Joueur avec les pions Noirs"
joueur B = "Joueur avec les pions Blancs"
joueur _ = "None"

-------------------------------------------------------------------------------
-- Declaration de variables
-------------------------------------------------------------------------------

posInit :: Position
posInit = (4,3)

listeDirection :: [Position]
listeDirection = [(-1,-1),(0,-1),(1,-1),(1,0),(1,1),(0,1),(-1,1),(-1,0)]

grilleDepart :: Grille
grilleDepart = [[V,V,V,V,V,V,V,V],
	[V,V,V,V,V,V,V,V],
	[V,V,V,V,V,V,V,V],
	[V,V,V,B,N,V,V,V],
	[V,V,V,N,B,V,V,V],
	[V,V,V,V,V,V,V,V],
	[V,V,V,V,V,V,V,V],
	[V,V,V,V,V,V,V,V]]

grilleCout :: [[Int]]
grilleCout = [[100,-20,10,5,5,10,-20,100],
	   [-20,-50,-2,-2,-2,-2,-50,-20],
	   [10,-2,-1,-1,-1,-1,-2,10],
	   [5,-2,-1,-1,-1,-1,-2,5],
	   [5,-2,-1,-1,-1,-1,-2,5],
	   [10,-2,-1,-1,-1,-1,-2,10],
	   [-20,-50,-2,-2,-2,-2,-50,-20],
	   [100,-20,10,5,5,10,-20,100]]


-------------------------------------------------------------------------------
-- Fonctions annexes
-------------------------------------------------------------------------------

-- Transforme une chaine de caractere en entree
stringToInt :: String->Int
stringToInt x = stiAux x 0
	where
	stiAux [] c = c
	stiAux (x:xs) c = stiAux xs (c*10 + (Char.digitToInt x))

-- Donne l'inverse de la couleur d'un pion
inversePion :: Case -> Case
inversePion N = B
inversePion B = N
inversePion _ = V

getCoutGrille :: Position -> [[a]] -> a
getCoutGrille pos grille = getElem (getColone pos) (getElem (getLigne pos) grille)

-------------------------------------------------------------------------------
-- Fonctions elementaires permettant la manipulation du type Position
-------------------------------------------------------------------------------

-- Constructeur de type Position
consPos :: Int -> Int -> Position
consPos ligne colone = (ligne,colone)

-- Accesseur de la ligne du type Position
getLigne :: Position -> Int
getLigne pos = fst pos

-- Accesseur de la colone du type Position
getColone :: Position -> Int
getColone pos = snd pos

-------------------------------------------------------------------------------
-- Fonction d'affichage du type Grille
-------------------------------------------------------------------------------

--affiche un plateau (8x8 cases )
sep = "+ - + - + - + - + - + - + - + - +"
affichePlateau [] = sep
affichePlateau (l:ls) = sep ++ "\n" ++ (afficheLigne l ) ++ "\n" ++ (affichePlateau ls )
	where
	afficheLigne [] =" | "
	afficheLigne (e:xs) = " | " ++ (afficheElem e) ++ (afficheLigne xs)
		where
		afficheElem V =" "
		afficheElem N ="#"
		afficheElem B ="O"

-------------------------------------------------------------------------------
-- Fonctions elementaires permettant la manipulation du type Grille
-------------------------------------------------------------------------------

-- Retourne le ieme element d'une liste
getElem :: Int -> [a] -> a
getElem 0 (x:xs) = x
getElem i (x:xs) = getElem (i-1) xs

-- Modifie le ieme element d'une liste
setElem :: Int -> a -> [a] -> [a]
setElem 0 elem (x:xs) = [elem] ++ xs
setElem i elem (x:xs) = [x] ++ (setElem (i-1) elem xs)

-- Verifie si une position est une position de la grille
estDansGrille :: Position -> Bool
estDansGrille pos =  (getLigne pos > -1) && (getLigne pos < 8) && (getColone pos > -1) && (getColone pos < 8)

-- Retourne la valeur de la case
getCase :: Position -> Grille -> Case
getCase pos grille = getElem (getColone pos) (getElem (getLigne pos) grille)

-- Modifie la valeur de la case
setCase :: Position -> Case -> Grille  -> Grille 
setCase pos elem grille = setElem (getLigne pos)
								(setElem (getColone pos)
										elem
										(getElem (getLigne pos) grille))
								grille

-- Calcule la position suivante d'une grille d'apres une direction definie
posSuivante :: Position -> Position -> Position
posSuivante pos direction = consPos ((getLigne pos) + (getLigne direction))
									((getColone pos) + (getColone direction))

-------------------------------------------------------------------------------
-- Lister tous les pions d'une meme couleur d'une grille
-------------------------------------------------------------------------------

-- Liste tous les pions d'une meme couleur d'une grille
listePions :: Case -> Grille -> [Position]
listePions pion (x:xs) = aux x xs 0 0 [] where
	aux :: [Case] -> [[Case]] -> Int -> Int -> [Position] -> [Position]
	aux ligne colone i j res
		| ligne == [] && colone == [] = res
		| ligne == [] = aux (head colone) (tail colone) (i+1) 0 res
		| (head ligne) == pion = aux (tail ligne) colone i (j+1) (res++[(consPos i j)])
		| otherwise = aux (tail ligne) colone i (j+1) res

-------------------------------------------------------------------------------
-- Caluler les coups jouables pour une couleur
-------------------------------------------------------------------------------

-- Test si un pion peut etre pose selon un direction
estJouableDirection :: Case -> Position -> Position -> Grille -> Bool
estJouableDirection pion pos direction grille
	| estDansGrille pos == False = False
	| estDansGrille (posSuivante pos direction) == False = False
	| getCase pos grille == V = False
	| getCase (posSuivante pos direction) grille == pion = False
	| getCase pos grille == (inversePion pion) && getCase (posSuivante pos direction) grille == V = True
	| otherwise = estJouableDirection pion (posSuivante pos direction) direction grille

-- Calcule la position ou un pion peut etre pose selon une direction
posJouable :: Case -> Position -> Position -> Grille -> Position
posJouable pion pos direction grille
	| getCase (posSuivante pos direction) grille == V = (posSuivante pos direction)
	| otherwise = (posJouable pion (posSuivante pos direction) direction grille)


-- Calcule pour une case donnee les positions des pions qui peuvent etre posee
toutePosJouable :: Case -> Position -> [Position] -> Grille -> [Position]
toutePosJouable pion pos [] grille = []
toutePosJouable pion pos (x:xs) grille
	| estJouableDirection pion pos x grille = [(posJouable pion pos x grille)]
											++
											toutePosJouable pion pos xs grille
	| otherwise = [] ++ toutePosJouable pion pos xs grille

-- Calcule pour tous les pions d'une meme couleur la liste des positions
-- ou un pion de la meme couleur peut etre pose
coupsPossibles :: Case -> Grille -> [Position]
coupsPossibles pion grille = foldr (++) [] (map (\x->(toutePosJouable pion x listeDirection grille)) (listePions pion grille))



-------------------------------------------------------------------------------
-- Mise a jour de la couleur des pions de la grille lors de la pose d'un pion
-------------------------------------------------------------------------------

-- Test si des pions peuvent etre retourne a partir d'une position
--  ou un pion est pose et selon une direction
estRetournable :: Case -> Position -> Position -> Grille -> Bool
estRetournable pion pos direction grille
	| estDansGrille pos == False = False
	| estDansGrille (posSuivante pos direction) == False = False
	| getCase (posSuivante pos direction) grille == V = False
	| getCase pos grille == (inversePion pion) && getCase (posSuivante pos direction) grille == pion = True
	| otherwise = estRetournable pion (posSuivante pos direction) direction grille

-- Retourne tous les pions a partir d'une position ou un pion est pose
-- et selon une direction
retourneLigne :: Case -> Position -> Position -> Grille -> Grille
retourneLigne pion pos direction grille
	| getCase (posSuivante pos direction) grille == pion = setCase pos pion grille
	| otherwise = retourneLigne pion (posSuivante pos direction) direction (setCase pos pion grille)

-- Retourne tous les pions possible a partir d'une position ou un pion est pose
actualiseGrille :: Case -> Position -> [Position] -> Grille -> Grille
actualiseGrille pion pos [] grille = grille
actualiseGrille pion pos (x:xs) grille
	| estRetournable pion pos x grille = actualiseGrille pion pos xs (retourneLigne pion pos x grille)
	| otherwise = actualiseGrille pion pos xs grille

-------------------------------------------------------------------------------
-- Fonctions de score et de fin de partie
-------------------------------------------------------------------------------

-- Calcul le score de chaques joueurs a partir d'une grille
score :: Grille -> Score
score grille = (length (listePions B grille),length (listePions N grille))

-- Test si une partie est finie
estFinie :: Grille -> Bool
estFinie grille
	| fst(score grille) + snd(score grille) == 64 = True
	| fst(score grille) == 0 || snd(score grille) == 0 = True
	| otherwise	= False

-- Affiche le joueur gagnant
gagnant :: Grille -> String
gagnant grille
	|fst(score grille) > snd(score grille) = "Joueur Blanc a gagne" ++(show (score grille))
	|fst(score grille) < snd(score grille) = "Joueur Noir a gagne" ++(show (score grille))
	|otherwise = "Match nul" ++(show (score grille))

-- Affiche la couleur gagnante
gagnant2::Grille->Case
gagnant2 grille
	|fst(score grille) > snd(score grille) = B
	|fst(score grille) < snd(score grille) = N
	|otherwise = V

-------------------------------------------------------------------------------
-- Fonctions de choix d'un ordinateur
-------------------------------------------------------------------------------

ordiChoixCoup :: Case -> Grille -> Position
ordiChoixCoup p g = meilleurCoup (coupsPossibles p g) (getElem 0 (coupsPossibles p g))
	 

meilleurCoup :: [Position] -> Position -> Position
meilleurCoup [] x = x
meilleurCoup (y:ys) x
	|(getCoutGrille y grilleCout) >= (getCoutGrille x grilleCout)	= meilleurCoup ys y
	|otherwise					= meilleurCoup ys x

-------------------------------------------------------------------------------
-- Fonctions MinMax
-------------------------------------------------------------------------------

-- Type pour manipuler des arbres de jeu values
data Arbre a = Noeud Case Case Position Grille Int [(Arbre a)]
        deriving(Show, Eq) 

-- Fonctions pour manipuler des arbres de jeu values


-- Renvoie la foret des fils d'un arbre
foret::Arbre a->[Arbre a]
foret (Noeud c c2 p g i []) = []
foret (Noeud c c2 p g i l) = l


-- Renvoie la valeur d'un noeud
renvoie::Arbre a->Int
renvoie (Noeud c c2 p g i _) = i


-- Renvoie la position jouée qui a la grille dans cette situation 
renvoiePos:: Arbre a -> Position
renvoiePos (Noeud c c2 p g i _) = p


-- Renvoie la liste des valeurs des racines de la foret des fils d'un arbre
renvoieP::Arbre a->[Int]
renvoieP a = (map (renvoie) (foret a)) 


-- Fonction intermédiaire pour calculer la profondeur maximale d'un arbre
profondeur2::Arbre a -> Int -> [Int]
profondeur2 (Noeud c c2 p g i []) x = [x]
profondeur2 (Noeud c c2 p g i (l:ls)) x = profondeur2 (l) (x+1) ++ profondeur2 (Noeud c c2 p g i ls) x


-- Fonction qui donne la profondeur maximale d'un arbre
profondeur::Arbre a -> Int
profondeur (Noeud c c2 p g i []) = 0
profondeur a = getMax (profondeur2 a 0) (0)


-- Renvoie le min et le max d'une liste

getMin::[Int]->Int->Int
getMin [] x = x
getMin (y:ys) x
	|y<=x		=getMin ys y
	|otherwise 	=getMin ys x

getMax::[Int]->Int->Int
getMax [] x = x
getMax (y:ys) x
	|y>=x		=getMax ys y
	|otherwise 	=getMax ys x

-- Fais la somme des éléments de la liste
somme::[Int]->Int
somme [] = 0
somme (l:ls) = l+(somme ls)


-------------------------------------------------------------------------------
-- Calcul d'arbres de jeu valués
-------------------------------------------------------------------------------

-- calcule l'arbre de jeu entier et évalué
arbre2 :: Case -> Case -> Position -> Grille -> Int -> (Arbre Grille)
arbre2 pion pion2 pos grille valeur
	| (coupsPossibles pion grille == []) && (gagnant2 grille == pion2) 					= Noeud pion pion2 pos grille (100) []
	| (coupsPossibles pion grille == []) && (gagnant2 grille == (inversePion pion2)) 			= Noeud pion pion2 pos grille (-50) []
	| (coupsPossibles pion grille == []) 									= Noeud pion pion2 pos grille (0) []
	| otherwise 												= Noeud pion pion2 pos grille valeur (map (\x -> (arbre2 (inversePion pion) pion2 x (actualiseGrille pion x listeDirection grille) (valeur))) (coupsPossibles pion grille))


-- Calcule l'arbre de jeu évalué de profondeur i 
arbre :: Case -> Case -> Position -> Grille -> Int -> Int -> (Arbre Grille)
arbre pion pion2 pos grille valeur 0 = Noeud pion pion2 pos grille (((somme (map (\x -> getCoutGrille x grilleCout) (listePions pion2 grille)) - somme (map (\x -> getCoutGrille x grilleCout) (listePions (inversePion pion2) grille)))) + (length (listePions pion2 grille)-length (listePions (inversePion pion2) grille))*5 - (length (coupsPossibles (inversePion pion2) grille))*5) []
arbre pion pion2 pos grille valeur i
	|(coupsPossibles pion grille == [])  			= Noeud pion pion2 pos grille (((somme (map (\x -> getCoutGrille x grilleCout) (listePions pion2 grille)) - somme (map (\x -> getCoutGrille x grilleCout) (listePions (inversePion pion2) grille)))) + (length (listePions pion2 grille)-length (listePions (inversePion pion2) grille))*5 - (length (coupsPossibles (inversePion pion2) grille))*5) []
	|otherwise 						= Noeud pion pion2 pos grille valeur (map (\x -> (arbre (inversePion pion) pion2 x (actualiseGrille pion x listeDirection grille) (valeur) (i-1))) (coupsPossibles pion grille))


-------------------------------------------------------------------------------
-- Algorithme min-max (demande trop de mémoire et de temps pour fonctionner)
-------------------------------------------------------------------------------

-- Pour utiliser l'arbre de jeu entier, il suffit d'utiliser la fonction minmax 
-- borné avec la profondeur de l'arbre de jeu entier en second argument
-- (Ce n'est qu'une utilisation théorique, en pratique l'utilisation de 
-- l'algorithme min-max non borné demande souvent trop de temps et de mémoire).

-------------------------------------------------------------------------------
-- Algorithme min-max borné
-------------------------------------------------------------------------------

-- fonction min-max pour arbre de profondeur i 
minmax:: Arbre a -> Int -> Arbre a
minmax a 0 = a
minmax a b = minmax (minmax1 a) (b-1)


-- fonction min-max intermédiaire  
minmax1::Arbre a->Arbre a
minmax1 (Noeud c c2 p g i []) = (Noeud c c2 p g i [])
minmax1 (Noeud c c2 p g i l)
	|(c == c2)	= Noeud c c2 p g (getMax (renvoieP (Noeud c c2 p g i l)) (head (renvoieP (Noeud c c2 p g i l)))) (map (minmax1) l)
	| otherwise	= Noeud c c2 p g (getMin (renvoieP (Noeud c c2 p g i l)) (head (renvoieP (Noeud c c2 p g i l)))) (map (minmax1) l)


-- valeur de la branche a choisir
decide::Arbre a -> Int -> Int
decide a i = renvoie (minmax a i)


-- position donnée par la branche choisie 
decideCoup::Arbre a -> Int -> Position
decideCoup (Noeud c c2 p g i []) j = error "Exception: Cet arbre n'a pas de fils"
decideCoup (Noeud c c2 p g i (l:ls)) j 
	|(renvoie l) == (decide (Noeud c c2 p g i (l:ls)) j)				=(renvoiePos l)
	|otherwise 									=(decideCoup (Noeud c c2 p g i (ls)) j) 


-- adaptation de la fonction au programme des IA
decision:: Case -> Grille -> Int -> Position
decision pion grille i = decideCoup (minmax (arbre pion pion (99,99) grille 99999 i) i) i

-------------------------------------------------------------------------------
-- Algorithme Alpha-Beta
-------------------------------------------------------------------------------

-- fonction alphaBeta intermédiaire
alphaBeta1::Arbre a->Arbre a
alphaBeta1 (Noeud c c2 p g i []) = (Noeud c c2 p g i [])
alphaBeta1 (Noeud c c2 p g i (l:ls))
	|(c == c2)										= Noeud c c2 p g (getMax (renvoieP (Noeud c c2 p g i (l:ls))) (head (renvoieP (Noeud c c2 p g i (l:ls))))) (map (alphaBeta1) (l:ls))
	|(c == c2) && (i > renvoie l) && (i /= 99999) && (renvoie l /= 99999)			= Noeud c c2 p g (getMax (renvoieP (Noeud c c2 p g i (l:ls))) (head (renvoieP (Noeud c c2 p g i (l:ls))))) (map (alphaBeta1) (ls))
	|(c == (inversePion c2)) && (i < renvoie l) && (i /= 99999) && (renvoie l /= 99999)	= Noeud c c2 p g (getMin (renvoieP (Noeud c c2 p g i (l:ls))) (head (renvoieP (Noeud c c2 p g i (l:ls))))) (map (alphaBeta1) (ls))
	| otherwise										= Noeud c c2 p g (getMin (renvoieP (Noeud c c2 p g i (l:ls))) (head (renvoieP (Noeud c c2 p g i (l:ls))))) (map (alphaBeta1) (l:ls))

-- fonction alphaBeta pour arbre de profondeur i
alphaBeta:: Arbre a -> Int -> Arbre a
alphaBeta a 0 = a
alphaBeta a b = alphaBeta (alphaBeta1 a) (b-1)  
  

-- valeur de la branche a choisir
decide2::Arbre a -> Int -> Int
decide2 a i = renvoie (alphaBeta a i)


-- position donnée par la branche choisie
decideCoup2::Arbre a -> Int -> Position
decideCoup2 (Noeud c c2 p g i []) j = error "Exception: Cet arbre n'a pas de fils"
decideCoup2 (Noeud c c2 p g i (l:ls)) j 
	|(renvoie l) == (decide2 (Noeud c c2 p g i (l:ls)) j)				=(renvoiePos l)
	|otherwise 									=(decideCoup2 (Noeud c c2 p g i (ls)) j) 

-- adaptation de la fonction au programme des IA
decision2:: Case -> Grille -> Int -> Position
decision2 pion grille i = decideCoup2 (alphaBeta (arbre pion pion (99,99) grille 99999 i) i) i



-------------------------------------------------------------------------------
-- Comparaison des IA
-------------------------------------------------------------------------------


-- L'IA rudimentaire (Partie 2 question 1) est plus rapide mais moins efficace
-- que les IA basées sur les algorithmes MinMax Borné et AlphaBeta. 

-- LIA basée sur lalgorithme AlphaBeta est plus rapide et tout aussi efficace 
-- que lIA basée sur lalgorithme MinMax Borné.
-- Elle est aussi plus lente que l'IA rudimentaire mais bien plus efficace.

-- L'IA basée sur l'algorithme MinMax Borné est plus lente mais bien plus efficace que
-- l'IA rudimentaire.
-- En outre, elle plus lente et aussi efficace que l'IA basée sur l'algorithme
-- AlphaBeta.

-- L'IA basée sur l'algorithme MinMax Non-Borné est théoriquement la plus efficace
-- mais a cause de son extrême lenteur il est impossible d'en juger de manière
-- pratique.
