data Case = B | N | V
 deriving (Show,Eq)
 
-- Affichage

afficherLigne :: [Case] -> String
afficherLigne (V:b) = " -" ++ afficherLigne b
afficherLigne (B:b) = " B" ++ afficherLigne b
afficherLigne (N:b) = " N" ++ afficherLigne b
afficherLigne _ = "\n"

afficher :: [[Case]] -> String
afficher [] = " "
afficher a = afficherLigne (head a) ++ afficher (tail a)

-- Inversion de l'othello

inverseLigne :: [Case] -> [Case]
inverseLigne (V:a) = V : inverseLigne a
inverseLigne (N:a) = B : inverseLigne a
inverseLigne (B:a) = N : inverseLigne a
inverseLigne [] = []

inverseOth :: [[Case]] -> [[Case]]
inverseOth [] = []
inverseOth (a:l) = inverseLigne a : inverseOth l

-- PARTIE 1
-- Coups admissibles

-- determine les coups admissibles de B d'une liste de Case.
--                      incrX  incrY  Xok    Yok    posX   posY  etat
coupsLigne :: [Case] -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> [(Int,Int)]
coupsLigne [] _ _ _ _ _ _ _ = []
coupsLigne (V:l) ix iy x y x2 y2 0 = coupsLigne l ix iy (x+ix) (y+iy) (x2+ix) (y2+iy) 0
coupsLigne (N:l) ix iy x y x2 y2 0 =    coupsLigne l ix iy (x-ix) (y-iy) (x2+ix) (y2+iy) 3
coupsLigne (B:l) ix iy x y x2 y2 0 =    coupsLigne l ix iy (x+ix) (y+iy) (x2+ix) (y2+iy) 1
coupsLigne (V:l) ix iy x y x2 y2 1 = coupsLigne l ix iy (x+ix) (y+iy) (x2+ix) (y2+iy) 0
coupsLigne (N:l) ix iy x y x2 y2 1 =    coupsLigne l ix iy (x+ix) (y+iy) (x2+ix) (y2+iy) 2
coupsLigne (B:l) ix iy x y x2 y2 1 =    coupsLigne l ix iy (x+ix) (y+iy) (x2+ix) (y2+iy) 1
coupsLigne (V:l) ix iy x y x2 y2 2 = (x,y) : coupsLigne l ix iy (x+ix) (y+iy) (x2+ix) (y2+iy) 0
coupsLigne (N:l) ix iy x y x2 y2 2 =    coupsLigne l ix iy (x+ix) (y+iy) (x2+ix) (y2+iy) 2
coupsLigne (B:l) ix iy x y x2 y2 2 =    coupsLigne l ix iy (x+ix) (y+iy) (x2+ix) (y2+iy) 1
coupsLigne (V:l) ix iy x y x2 y2 3 = coupsLigne l ix iy x2 y2 (x2+ix) (y2+iy) 0
coupsLigne (N:l) ix iy x y x2 y2 3 =    coupsLigne l ix iy x y (x2+ix) (y2+iy) 3
coupsLigne (B:l) ix iy x y x2 y2 3 = (x,y) : coupsLigne l ix iy (x2+ix) (y2+iy) (x2+ix) (y2+iy) 1


coupsLignesInter :: [[Case]] -> Int -> [(Int,Int)]
coupsLignesInter [] _ = []
coupsLignesInter (a:l) y = (coupsLigne a 1 0 0 y 0 y 0) ++ (coupsLignesInter l (y+1))

--coups admissibles des lignes
coupsLignes :: [[Case]] -> Case -> [(Int,Int)]
coupsLignes a B = coupsLignesInter a 0 
coupsLignes a N = coupsLignesInter (inverseOth a) 0

coupsColonnesInter :: [[Case]] -> Int -> [(Int,Int)]
coupsColonnesInter [] _ = []
coupsColonnesInter (a:l) x = (coupsLigne a 0 1 x 0 x 0 0) ++ (coupsColonnesInter l (x+1))

--coups admissibles des colonnes
coupsColonnes :: [[Case]] -> Case -> [(Int,Int)]
coupsColonnes a B = coupsColonnesInter (colonnesVersLignes a) 0
coupsColonnes a N = coupsColonnesInter (inverseOth (colonnesVersLignes a)) 0

-- création des listes de Case des colonnes.
colonnesVersLignes :: [[Case]] -> [[Case]]
colonnesVersLignes l
	|(head l)==[] = []
	|otherwise= concat (map (take 1) l) : colonnesVersLignes (map (drop 1) l)
	
-- renvoie de l'element d'index x dans une liste.
takeOne :: Int -> [a] -> [a]
takeOne _ [] = []
takeOne x (b:l)
 |x<0 = []
 |x==0 = [b]
 |otherwise = takeOne (x-1) l

diag1 :: [[a]] -> Int -> [a]
diag1 [] _ = []
diag1 (a:l) b = takeOne b a ++ diag1 l (b+1)

diag2 :: [[a]] -> Int -> Int -> [a]
diag2 [] _ _ = []
diag2 (a:l) x1 x2
 |x1/=0 = diag2 l (x1-1) x2
 |otherwise = diag1 (a:l) x2

-- transforme les diagonales (haut-gauche vers bas-droite) en liste de Case.
diagVersLignes :: [[a]] -> [[a]]
diagVersLignes a = (map (\x -> diag1 a x) (reverse [0..(length a)-1])) ++ (map (\x -> diag2 (tail a) x 0) [0..(length a)-2])

diag3 :: [[a]] -> Int -> [a]
diag3 [] _ = []
diag3 (a:l) b = (takeOne b a) ++ (diag3 l (b-1))

diag4 :: [[a]] -> Int -> Int -> [a]
diag4 [] _ _ = []
diag4 (a:l) x1 x2
 |x1/=0 = diag4 l (x1-1) x2
 |otherwise = diag3 (a:l) x2

-- transforme les diagonales (haut-droite vers bas-gauche) en liste de Case.
diagVersLignes2 :: [[a]] -> [[a]]
diagVersLignes2 a = map (\x -> diag3 a x) [0..(length a)-1] ++ (map (\x -> diag4 a x (length a)) [0..(length a)-2])

--                             x      y    marqueur
coupsDiagsInter :: [[Case]] -> Int -> Int -> Int -> [(Int,Int)]
coupsDiagsInter [] _ _ _ = []
coupsDiagsInter (a:l) x y t -- si la taille de la diagonale courante est plus grande que t, on incrémente x.
 |(length a)>t = (coupsLigne a 1 1 x y 0 0 0) ++ (coupsDiagsInter l (x-1) y (t+1))
 |otherwise = (coupsLigne a 1 1 (x+1) (y+1) 0 0 0) ++ (coupsDiagsInter l x (y+1) t)

-- liste de coups admissibles dans les diagonales (haut-gauche vers bas-droite)
coupsDiags :: [[Case]] -> Case -> [(Int,Int)]
coupsDiags a B = coupsDiagsInter (diagVersLignes a) ((length a)-1) 0 0
coupsDiags a N = coupsDiagsInter (inverseOth (diagVersLignes a)) ((length a)-1) 0 0

coupsDiagsInter2 :: [[Case]] -> Int -> Int -> Int -> [(Int,Int)]
coupsDiagsInter2 [] _ _ _ = []
coupsDiagsInter2 (a:l) x y t
 |(length a)>t = (coupsLigne a (-1) 1 x y 0 0 0) ++ (coupsDiagsInter2 l (x+1) y (t+1))
 |otherwise = (coupsLigne a (-1) 1 x (y+1) 0 0 0) ++ (coupsDiagsInter2 l x (y+1) t)

-- liste de coups admissibles dans les diagonales (haut-droite vers bas-gauche)
coupsDiags2 :: [[Case]] -> Case -> [(Int,Int)]
coupsDiags2 a B = coupsDiagsInter2 (diagVersLignes2 a) 0 0 0
coupsDiags2 a N = coupsDiagsInter2 (inverseOth (diagVersLignes2 a)) 0 0 0

-- supprime les doublons d'une liste
verifierDoublon :: (Eq a) => [a] -> [a]
verifierDoublon [] = []
verifierDoublon (a:l)
 |elem a l = verifierDoublon l
 |otherwise = a : verifierDoublon l

coupsAdmissibles :: [[Case]] -> Case -> [(Int,Int)]
coupsAdmissibles a p = verifierDoublon (coupsLignes a p ++ coupsColonnes a p  ++ coupsDiags a p ++ coupsDiags2 a p)

-- Score

scoreLigne :: [Case] -> Case -> Int
scoreLigne [] _ = 0
scoreLigne (a:l) p
 |p==a = 1 + scoreLigne l p
 |otherwise = 0 + scoreLigne l p

score :: [[Case]] -> Case -> Int
score l p = sum (map (\x -> scoreLigne x p) l)

-- Transformation

invCase :: Case -> Case
invCase N = B
invCase B = N
invCase V = V

--                          pion  liste a retourner IncrX  IncrY  xOk    yOk   etat
pionsAretourner :: [Case] -> Case -> [(Int,Int)] -> Int -> Int -> Int -> Int -> Int -> [(Int,Int)]
pionsAretourner [] _ _ _ _ _ _ 2 = [] -- pas de pions a retourner
pionsAretourner [] _ _ _ _ _ _ 1 = []
pionsAretourner [] _ _ _ _ _ _ 0 = []
pionsAretourner(a:l) p k ix iy x y e
 |a==p && e==0 = pionsAretourner l p k ix iy (x+ix) (y+iy) 1
 |a==V && e==0 = []
 |a==(invCase p) && e==0 = []
 |a==(invCase p) && e==1 = pionsAretourner l p ((x,y):k) ix iy (x+ix) (y+iy) 2
 |a==p && e==1 = []
 |a==V && e==1 = []
 |a==(invCase p) && e==2 = pionsAretourner l p ((x,y):k) ix iy (x+ix) (y+iy) 2
 |a==p && e==2 = k  -- on renvoie la liste de pions a retourner
 |otherwise = []

changerPionLigne :: [Case] -> Int -> [Case]
changerPionLigne (a:l) x
 |x/=0 = a : changerPionLigne l (x-1)
 |otherwise = (invCase a) : l

-- inverse le pion situé en x y
changerPion :: [[Case]] -> Int -> Int -> [[Case]]
changerPion (a:l) x y 
 |y/=0 = a : changerPion l x (y-1)
 |otherwise = changerPionLigne a x : l

-- renvoie d'un element a situé en x y dans une liste de liste de a
takeOne2 :: (Eq a) => [[a]] -> Int -> Int -> [a]
takeOne2 [] _ _ = []
takeOne2 (a:l) x y
 |y>0 = takeOne2 l x (y-1)
 |y==0 = takeOne x a
 |otherwise = []

consLigneG :: [[Case]] -> Int -> Int -> [Case]
consLigneG a (-1) y = []
consLigneG a x y = takeOne2 a x y ++ consLigneG a (x-1) y

consLigneD :: [[Case]] -> Int -> Int -> [Case]
consLigneD a 8 y = []
consLigneD a x y = takeOne2 a x y ++ consLigneD a (x+1) y

consLigneH :: [[Case]] -> Int -> Int -> [Case]
consLigneH a x (-1) = []
consLigneH a x y = takeOne2 a x y ++ consLigneH a x (y-1)

consLigneB :: [[Case]] -> Int -> Int -> [Case]
consLigneB a x 8 = []
consLigneB a x y = takeOne2 a x y ++ consLigneB a x (y+1)

consDiagGH :: [[Case]] -> Int -> Int -> [Case]
consDiagGH a x y
 |x<0 || y<0 = []
 |otherwise = (takeOne2 a x y) ++ (consDiagGH a (x-1) (y-1))

consDiagGB :: [[Case]] -> Int -> Int -> [Case]
consDiagGB a x y
 |x<0 || y>7 = []
 |otherwise = (takeOne2 a x y) ++ (consDiagGB a (x-1) (y+1))
 
consDiagDH :: [[Case]] -> Int -> Int -> [Case]
consDiagDH a x y
 |x>7 || y<0 = []
 |otherwise = (takeOne2 a x y) ++ (consDiagDH a (x+1) (y-1))

consDiagDB :: [[Case]] -> Int -> Int -> [Case]
consDiagDB a x y
 |x>7 || y>7 = []
 |otherwise = (takeOne2 a x y) ++ (consDiagDB a (x+1) (y+1))

--retourne tous les pions dont les indices sont dans la liste.
retournerPions :: [[Case]] -> [(Int,Int)] -> [[Case]]
retournerPions a [] = a
retournerPions a ((x,y):l) = retournerPions (changerPion a x y) l

poserPionLigne :: [Case] -> Case -> Int -> [Case]
poserPionLigne (a:l) p x
 |x>0 = a : poserPionLigne l p (x-1)
 |otherwise = p : l

-- pose le pion p en x y dans la liste de Case
poserPion :: [[Case]] -> Case -> Int -> Int -> [[Case]]
poserPion (a:l) p x y
 |y>0 = a: poserPion l p x (y-1)
 |otherwise = poserPionLigne a p x : l
 
jouerUnPionInter :: [[Case]] -> Case -> Int -> Int -> [[Case]] 
jouerUnPionInter l p x y = retournerPions l ((pionsAretourner (consDiagDB l x y) p [] 1 1 x y 0) ++ (pionsAretourner (consDiagDH l x y) p [] 1 (-1) x y 0) ++ (pionsAretourner (consDiagGB l x y) p [] (-1) 1 x y 0) ++ (pionsAretourner (consDiagGH l x y) p [] (-1) (-1) x y 0) ++ (pionsAretourner (consLigneB l x y) p [] 0 1 x y 0) ++ (pionsAretourner (consLigneD l x y) p [] 1 0 x y 0) ++ (pionsAretourner (consLigneG l x y) p [] (-1) 0 x y 0) ++ (pionsAretourner (consLigneH l x y) p [] 0 (-1) x y 0))

-- pose un pion et retourne tous les pions a retourner.
jouerUnPion :: [[Case]] -> Case -> Int -> Int -> [[Case]] 
jouerUnPion l p x y =  jouerUnPionInter (poserPion l p x y) p x y


-- partie terminée ?
estTerminee :: [[Case]] -> Bool
estTerminee a = (length (coupsAdmissibles a N) == 0) && (length (coupsAdmissibles a B) == 0)

oth = [
	[V,V,V,V,V,V,V,V],
	[V,V,V,V,V,V,V,V],
	[V,V,V,V,V,V,V,V],
	[V,V,V,N,B,V,V,V],
	[V,V,V,B,N,V,V,V],
	[V,V,V,V,V,V,V,V],
	[V,V,V,V,V,V,V,V],
	[V,V,V,V,V,V,V,V]]



jouer2joueur :: String -> String -> Case -> Case -> [[Case]] -> IO()
jouer2joueur n1 n2 p1 p2 othe=do
		 putStrLn ( "etat de l'othello :\n" ++ (afficher othe))
		 if (estTerminee othe)
			then do
				if ((score othe p1)>(score othe p2))
					then do
						putStrLn ("partie terminée!" ++ n1 ++ " gagne")	
						return ()
					else do
						putStrLn ("partie terminée!" ++ n2 ++ " gagne")
						return ()
			else do
			 putStrLn  ( n1 ++ ", entrez un 0<=X<8: ")
			 x <- readLn
			 putStrLn "entrez un 0<=Y<8: "
			 y <- readLn
			 if (x<0 || y<0)
				then do
					putStrLn "!entier positif demandé!"
					jouer2joueur n1 n2 p1 p2 othe
				else if (elem (x,y) (coupsAdmissibles othe p1))
					 then jouer2joueur n2 n1 p2 p1 (jouerUnPion othe p1 x y) -- changement de joueur
					 else do
						putStrLn "coup impossible ! rejouez."
						jouer2joueur n1 n2 p1 p2 othe
						
-- PARTIE 2	

jouerContreIA :: [[Case]] -> IO()
jouerContreIA dam = do
	putStrLn ( "etat de l'othello :\n" ++ (afficher dam))
	if (estTerminee dam)
		then do
			if ((score dam N)>(score dam B))
				then putStrLn ("partie terminée! l'IA gagne")	
				else putStrLn ("partie terminée! vous gagnez")
		else do	
			putStrLn  ( "entrez un 0<=X<8: ")
			x <- readLn
			putStrLn "entrez un 0<=Y<8: "
			y <- readLn
			if (x<0 || y<0)
				then do
					putStrLn "!!! entier positif demandé !!!"
					jouerContreIA dam
				else if (elem (x,y) (coupsAdmissibles dam B))
					then jouerContreIA (coupJoueurIA (jouerUnPion dam B x y) N)
					else do
						putStrLn "!!! coup impossible ! rejouez. !!!"
						jouerContreIA dam	

main = do 
	putStrLn "jouer contre une ia (1) ou a 2 joueurs (2) ?"
	a <- getChar
	if (a=='1')
		then do
			putStrLn "\nvous avez les blancs, a vous de jouer"
			jouerContreIA oth  
		else if (a=='2')
			then do
				putStrLn "nom du joueur 1: "
				nom1 <- getLine
				putStrLn "nom du joueur 2: "
				nom2 <- getLine
				putStrLn (nom1 ++ " vous avez les blanc (B), " ++ nom2 ++ " vous avez les noirs (N).")
				jouer2joueur nom1 nom2 B N oth
		else main
	return ()
	
valeurs = [
	[100,-20,10,5,5,10,-20,100],
	[-20,-50,-2,-2,-2,-2,-50,-20],
	[10,-2,-1,-1,-1,-1,-2,10],
	[5,-2,-1,-1,-1,-1,-2,5],
	[5,-2,-1,-1,-1,-1,-2,5],
	[10,-2,-1,-1,-1,-1,-2,10],
	[-20,-50,-2,-2,-2,-2,-50,-20],
	[100,-20,10,5,5,10,-20,100]]


-- determine le meilleur coup parmis une liste de coups admissibles.
valeurMax :: [(Int,Int)] -> (Int,Int) -> (Int,Int)
valeurMax [] v = v
valeurMax ((x,y):l) (x2,y2)
 |(takeOne2 valeurs x y) > (takeOne2 valeurs x2 y2) = valeurMax l (x,y)
 |otherwise = valeurMax l (x2,y2)
 
peutJouerIA :: [[Case]] -> Case -> Bool
peutJouerIA a p
 |length (coupsAdmissibles a p) == 0 = False
 |otherwise = True
	
coupJoueurIA :: [[Case]] -> Case -> [[Case]]
coupJoueurIA a p
 |peutJouerIA a p = jouerUnPion a p (fst val) (snd val)
 |otherwise = a
	where
	val = valeurMax (coupsAdmissibles a p) (1,1) -- (1,1) correspond a -50 dans le tableau valeurs.
	
-- 2.6

data Arbre a = Noeud a [Arbre a] | Feuille a | Null
	deriving Show

construireNoeud :: [[Case]] -> Case -> (Int,Int) -> Arbre (Int,Int)
construireNoeud l p (x,y)
 |length (coupsAdmissibles l p)==0 =  Feuille (x,y)
 |otherwise = Noeud (x,y) (map (\a -> (construireNoeud (jouerUnPion l p x y) p a)) (coupsAdmissibles l p))

construireArbre :: [[Case]] -> Case -> (Int,Int) -> Arbre (Int,Int)
construireArbre l p (x,y)
 |not (elem (x,y) (coupsAdmissibles l p)) = Null
 |otherwise= construireNoeud (jouerUnPion l p x y) (invCase p) (x,y)

