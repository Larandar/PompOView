import Char

--Partie 1

--Question 1

--Les piece
data Piece = Vide | Blanc | Noire
	deriving(Eq,Show)
	
type Othello = [[Piece]]

-- L'othello
jeux =  [[Vide,Vide,Vide,Vide,Vide,Vide,Vide,Vide],
	[Vide,Vide,Vide,Vide,Vide,Vide,Vide,Vide],
	[Vide,Vide,Vide,Vide,Vide,Vide,Vide,Vide],
	[Vide,Vide,Vide,Blanc,Noire,Vide,Vide,Vide],
	[Vide,Vide,Vide,Noire,Blanc,Vide,Vide,Vide],
	[Vide,Vide,Vide,Vide,Vide,Vide,Vide,Vide],
	[Vide,Vide,Vide,Vide,Vide,Vide,Vide,Vide],
	[Vide,Vide,Vide,Vide,Vide,Vide,Vide,Vide]]

--Selon une position et une couleur retourne la liste des position valide
listevalide:: Int -> Int -> Piece -> Othello ->  [(Int,Int)]
listevalide x y Vide o = []
listevalide x y p o = (haut False Vide x y p1 o)++(bas False Vide x y p1 o)++(gauche False Vide x y p1 o)++(droite False Vide x y p1 o)++(diagonalHautDroite False Vide x y p1 o)++(diagonalHautGauche False Vide x y p1 o)++(diagonalHautDroite False Vide x y p1 o)++(diagonalBasDroite False Vide x y p1 o)++[] 
						where p1 = contraire p

--les 8 fonction qui suivent servent a savoir si il y dans une direction données une suite de couleur opposé.
-- A la fin de la fonction , on retourne la position ou il y a une case c aprés la succesion de piece p voulu						
haut:: Bool -> Piece -> Int -> Int -> Piece -> Othello ->[(Int ,Int)]
haut r c x 1 p o = []
haut r c x y p o 
	| qui x (y-1) o == p = haut True c x (y-1) p o
	| (qui x (y-1) o == c) && (r == True) = [(x,y-1)]
	| otherwise = []

bas:: Bool -> Piece -> Int -> Int -> Piece -> Othello ->[(Int ,Int)]
bas r c x 8 p o = []
bas r c x y p o 
	| qui x (y+1) o == p = bas True c x (y+1) p o
	| (qui x (y+1) o == c) && (r == True) = [(x,y+1)]
	| otherwise = []
	
droite:: Bool -> Piece -> Int -> Int -> Piece -> Othello ->[(Int ,Int)]
droite r c 8 y p o = []
droite r c x y p o 
	| qui (x+1) y o == p = droite True c (x+1) y p o
	| (qui (x+1) y o == c) && (r == True) = [(x+1,y)]
	| otherwise = []

gauche:: Bool -> Piece -> Int -> Int -> Piece -> Othello ->[(Int ,Int)]
gauche r c 1 y p o = []
gauche r c x y p o 
	| qui (x-1) y o == p = gauche True c (x-1) y p o
	| (qui (x-1) y o == c) && (r == True) = [(x-1,y)]
	| otherwise = []

diagonalHautDroite:: Bool -> Piece -> Int -> Int -> Piece -> Othello ->[(Int ,Int)]
diagonalHautDroite r c 8 y p o = []
diagonalHautDroite r c x 1 p o = []
diagonalHautDroite r c x y p o 
	| qui (x+1) (y-1) o == p = diagonalHautDroite True c (x+1) (y-1) p o
	| (qui (x+1) (y-1) o == c) && (r == True) = [(x+1,y-1)]
	| otherwise = []

diagonalHautGauche:: Bool -> Piece -> Int -> Int -> Piece -> Othello ->[(Int ,Int)]
diagonalHautGauche r c 1 _ p o = []
diagonalHautGauche r c _ 1 p o = []
diagonalHautGauche r c x y p o 
	| qui (x-1) (y-1) o == p = diagonalHautGauche True c (x-1) (y-1) p o
	| (qui (x-1) (y-1) o == c) && (r == True) = [(x-1,y-1)]
	| otherwise = []	


diagonalBasDroite:: Bool -> Piece -> Int -> Int -> Piece -> Othello ->[(Int ,Int)]
diagonalBasDroite r c 8 y p o = []
diagonalBasDroite r c x 8 p o= []
diagonalBasDroite r c x y p o 
	| qui (x+1) (y+1) o == p = diagonalBasDroite True c (x+1) (y+1) p o
	| (qui (x+1) (y+1) o == c) && (r == True) = [(x+1,y+1)]
	| otherwise = []

	
diagonalBasGauche:: Bool -> Piece -> Int -> Int -> Piece -> Othello ->[(Int ,Int)]
diagonalBasGauche r c 1 y p o = []
diagonalBasGauche r c x 8 p o = []
diagonalBasGauche r c x y p o 
	| qui (x-1) (y+1) o == p = diagonalBasGauche True c (x-1) (y+1) p o
	| (qui (x-1) (y+1) o == c) && (r == True) = [(x-1,y+1)]
	| otherwise = []	
	
-- retourne le contraire d'une piece
contraire :: Piece ->Piece
contraire Blanc = Noire
contraire Noire = Blanc	

--permet de savoir ce qu'il ya sur l'othello en position x y
qui:: Int -> Int -> Othello -> Piece	
qui x y o = last (take x (last (take y o)))


--Question 2

--Pose une piece sur l'échequier

poser:: Int -> Int -> Piece -> Othello -> Othello
poser x y p o = poserConf x y p o (versQui x y p o)

poserConf :: Int -> Int -> Piece -> Othello -> [(Int,Int)] -> Othello
poserConf x y p o [] = o
poserConf x y p o ((a,b):ls) = poserConf x y p (toutChanger x y a b p o) ls

--Permet de changer en une couleur p les piece comprise entre dx dy et fx fy
toutChanger :: Int -> Int -> Int -> Int -> Piece -> Othello -> Othello
toutChanger dx dy fx fy p o 
	| (dx == fx) && (dy < fy) = toutChanger dx (dy+1) fx fy p (changer dx dy p o) -- Bas
	| (dx == fx) && (dy > fy) && ((dy-1) /= 0) = toutChanger dx (dy-1) fx fy p (changer dx dy p o) -- Haut
	| (dy == fy) && (dx < fx) = toutChanger (dx+1) dy fx fy p (changer dx dy p o) -- Droite
	| (dy == fy) && (dx > fx) && ((dx-1) /= 0) = toutChanger (dx-1) dy fx fy p (changer dx dy p o) -- Gauche
	| (dx < fx) && (dy > fy) && ((dy-1) /= 0) = toutChanger (dx+1) (dy-1) fx fy p (changer dx dy p o) -- diagonalHautDroite
	| (dx > fx) && (dy > fy) && ((dx-1) /= 0)&& ((dy-1) /= 0)= toutChanger (dx-1) (dy-1) fx fy p (changer dx dy p o) -- diagonalHautGauche
	| (dy < fy) && (dx < fx) = toutChanger (dx+1) (dy+1) fx fy p (changer dx dy p o) -- diagonalBasDroite
	| (dy < fy) && (dx > fx) && ((dx-1) /= 0)= toutChanger (dx-1) (dy+1) fx fy p (changer dx dy p o) -- diagonalBasGauche
	| (dx == fx) && (dy == fy) = changer dx dy p o
	| otherwise = o

--Permet de changer une piece en x y en une couleur donné
changer :: Int -> Int -> Piece -> Othello -> Othello
changer x y p o = changerR (x-1) (y-1) p o
	
changerR :: Int -> Int -> Piece -> Othello -> Othello
changerR x 0 p (o:ot) = (changerP x p o):ot
changerR x y p (o:ot) = o:(changerR x (y-1) p ot)

changerP :: Int -> Piece -> [Piece] -> [Piece]
changerP 0 p (l:ls) = p :ls
changerP x p (l:ls) = l:( changerP (x-1) p ls)

--Permet d'avoir la liste des position qui interprete le changement de couleur si on pose un pion en x y de couleur 
versQui :: Int -> Int -> Piece -> Othello -> [(Int,Int)]
versQui x y p o = (haut False p x y p1 o)++(bas False p x y p1 o)++(gauche False p x y p1 o)++(droite False p x y p1 o)++(diagonalHautDroite False p x y p1 o)++(diagonalHautGauche False p x y p1 o)++(diagonalBasDroite False p x y p1 o)++(diagonalBasGauche False p x y p1 o)++[] 
						where p1 = contraire p

--Question 3
--Permet d'avoir le score
score :: Othello -> String
score o = ("Blanc : " ++ show (compte Blanc o ) ++"\t" ++ "Noire : " ++ show (compte Noire o)++"\n")

--Permet de compter le nombre de piece de couleur p
compte :: Piece -> Othello -> Int
compte p [] = 0
compte p (o:os) = length(filter (== p) o) + (compte p os)

--a f f i c h e un p l a t e a u (8 x8 cas e s )

ligne = " --------------------------------------"

afficher :: Othello -> IO ()
afficher o = putStrLn(affiche 1 o ++ "\t "++ligne ++ "\n \t  | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |    |\n\t " ++ ligne ++ "\n\n\t "++"SCORE : \t"++ score o)

affiche :: Int -> Othello -> String
affiche x [] = ""
affiche x (l:ls) = "\t "++ligne ++ "\n\t " ++( afficheLigne x l ) ++ "\n" ++ ( affiche (x+1) ls )

afficheLigne :: Int -> [Piece] -> String
afficheLigne x [ ] =" |  "++(show x) ++ " | "
afficheLigne x ( e:xs ) = " | " ++ ( afficheEl e) ++ ( afficheLigne x xs )

afficheEl :: Piece -> String
afficheEl Vide =" "
afficheEl Noire ="N"
afficheEl Blanc ="B"

--Permet de convertir un string en int
stringToInt :: String->Int
stringToInt x = stiAux x 0
	where
	stiAux [] c = c
	stiAux (x:xs) c = stiAux xs (c*10 + (Char.digitToInt x))

--Test si une position x y est valide
test :: Int -> Int -> Piece -> Othello -> Bool
test x y p o 
	| diff x y == True && ((qui x y o) == Vide) && (length(versQui x y p o) /= 0)  = True
	| otherwise = False

--Verifie que l'utilisateur n'a pas entrer de mauvaise coordonnées
diff :: Int -> Int -> Bool
diff x y 
	| x < 9 && x > 0 && y < 9 && y > 0  = True
	| otherwise = False

--Test si quelqu'un passe son tour
passetour :: Piece -> Othello -> Bool
passetour p o = pass p o 8 8

pass :: Piece -> Othello -> Int -> Int -> Bool
pass p o x 0 = True
pass p o 0 y = pass p o 8 (y-1)
pass p o x y 
	| (qui x y o == p) && (length(listevalide x y p o) > 0) = False
	| otherwise = pass p o (x-1) y
	
--Permet de jouer A 2
jouer :: IO ()
jouer =   start jeux Blanc

--donner la version string d'une piece
toString :: Piece -> String
toString Blanc = "Blanc"
toString Noire = "Noire"

--Permet de donner le gagant
quiAgagner :: Othello -> IO ()
quiAgagner o 
	| ((compte Blanc o) < (compte Noire o))  = putStrLn ("FIN DE PARTIE : LES NOIRE GAGNE")
	| ((compte Blanc o) > (compte Noire o))  = putStrLn ("FIN DE PARTIE : LES BLANC GAGNE")

--Permet de savoir si il y a un gagnant
gagner :: Othello -> Piece -> Bool
gagner o p
	| (compte Vide o) == 0 = True
	| ((passetour p o == True) && (passetour (contraire p) o)== True)  = True
	| otherwise = False

--commence une partie a 2 jouer
start :: Othello -> Piece -> IO ()
start o p = do
 (afficher o)
 if (gagner o p == True) then quiAgagner o
	else if ((passetour p o) == True) then do 
									putStrLn ("Vous passer votre toutr , vous ne pouvez pas posser de pion")
									(start o (contraire p))
							else do
									putStrLn ("C'est au "++ (toString p) ++" de jouer")                             		
									putStrLn ("Entrer La Position X ")
									x <- getLine
									putStrLn ("Entrer La Position Y ")
									y <- getLine
									if ((Char.isDigit (head x)) == True && (Char.isDigit (head y)) == True && (test (stringToInt x) (stringToInt y) p o) == True) then start (poser (stringToInt x) (stringToInt y) p o) (contraire p)
														 									  else do putStrLn("Position impossible ou non valide , rechoissisez")
	    																							  start o p
									
			
					
             
             
--2eme partie

--joueur contre ordi

type Grille =[[Int]]

p1 = [[100,-20,10,5,5,10,-20,100],[-20,-50,-2,-2,-2,-2,-50,-20],[10,-2,-1,-1,-1,-1,-2,-10],[5,-2,-1,-1,-1,-1,-2,5]]
p2 = reverse p1

--La grille de point
grille = p1 ++ p2

--Permet de savoir que vaut la case x y dans la grille
point :: Int -> Int -> Grille -> Int	
point x y g = last (take x (last (take y g)))

--permet de selectionner dans la grille la case qui a un point maximal (por l'ordinateur) 
maxi :: [(Int,Int)] -> (Int,Int) -> Grille -> (Int,Int)
maxi [] (sx,sy) g = (sx,sy)
maxi (l:ls) (0,0) g = maxi ls l g
maxi ((a,b):ls) (sx,sy) g
	| (point a b g) < (point sx sy g) = maxi ls (sx,sy) g
	| otherwise = maxi ls (a,b) g

--Permet a l'ordinateur de jouer selon la grille , on retoure la meilleur position parmi toute les position valide, celle qui rapporte le plus de point
ordijou :: Piece -> Othello -> Grille -> (Int,Int)
ordijou p o g = ordi 8 8 p g o []

ordi :: Int -> Int -> Piece -> Grille -> Othello -> [(Int,Int)] -> (Int,Int)
ordi 0 1 p g o l = maxi l (0,0) g
ordi 0 y p g o l = ordi 8 (y-1) p g o l
ordi x y p g o l
	| (qui x y o == Vide) && length (versQui x y p o) > 0 =  ordi (x-1) y p g o (l ++ [(x,y)])
	| otherwise = ordi (x-1) y p g o l

--Permet de lancer une partie contre l'ordinateur	
ordinateur :: IO ()
ordinateur = startordi jeux Noire 

startordi :: Othello -> Piece -> IO () 
startordi o p = do
 (afficher o)
 if (gagner o p == True) then quiAgagner o
    else if (p == Blanc && (passetour p o) == False ) then do 
    														  let (ox,oy) = ordijou Blanc o grille
    														  let ot = poser ox oy Blanc o
    														  putStrLn ("L'ordinateur a jouer en x = " ++ [Char.intToDigit ox] ++ " et en y = " ++ [Char.intToDigit oy] ++ " \n")
    							 							  startordi ot Noire

													else if ((passetour p o) == True) then do 
																							putStrLn ("Vous passer votre tour , vous ne pouvez pas posser de pion")
																							(startordi o Blanc)
																					  else do
																							putStrLn ("C'est au "++ (toString p) ++" de jouer")                             		
																							putStrLn ("Entrer La Position X :")
																							x <- getLine
																							putStrLn ("Entrer La Position Y :")
																							y <- getLine
																							if ((Char.isDigit (head x)) == True && (Char.isDigit (head y)) == True && (test (stringToInt x) (stringToInt y) p o) == True) then startordi (poser (stringToInt x) (stringToInt y) p o) Blanc
														 									  																																else do putStrLn("Position impossible ou non valide , rechoissisez")
	    																							  																																startordi o Noire
	    																							  																																
	    																							  																																

-- Algo min-max

data Arbre = Feuille (Othello,(Int,Int)) | Arbre (Othello,(Int,Int)) [Arbre]
	deriving(Eq,Show)

--permet d'avoir la liste des position ou l'ordinateur peut jouer
oupeutposer:: Int -> Int -> Othello -> Piece ->[(Int,Int)] -> [(Int,Int)] 	
oupeutposer 0 1 o p l = l
oupeutposer 0 y o p l = oupeutposer 8 (y-1) o p l
oupeutposer x y o p l
	| (qui x y o == Vide) && length (versQui x y p o) > 0 =  oupeutposer (x-1) y o p (l ++ [(x,y)])
	| otherwise = oupeutposer (x-1) y o p l


--construie l'arbre selon les different choix du joueur adverse , puis , avec ces même arbres , on
--construie les feuille , qui sont des othello ou c'est l'ordinateur qui à jouer parmi différent choix 
construireArbre:: Othello -> Arbre
construireArbre o = Arbre (o,(0,0)) (construireForet o (oupeutposer 8 8 o Blanc []) )

construireForet:: Othello -> [(Int,Int)] -> [Arbre]
construireForet o [] = [] 
construireForet o ((x,y):ls)  = (Arbre (ot,(x,y)) (construireFeuille ot (oupeutposer 8 8 ot Noire []))):(construireForet o ls)
									where ot =  poser x y Blanc o 	

construireFeuille :: Othello -> [(Int,Int)] -> [Arbre]
construireFeuille o [] = []
construireFeuille o ((x,y):ls) = (Feuille ((poser x y Noire o),(x,y))):(construireFeuille o ls)	

--Permet parmi les othellos présent dans le noeud du joueur adverse , selectionner l'othello , où le joueur a posé
--sa piece sur une case où le point est maximal
coutMax:: Arbre -> Arbre
coutMax (Arbre (o,(x,y)) (f:fs)) = maxparmi fs f 

maxparmi:: [Arbre] -> Arbre -> Arbre
maxparmi [] f = f
maxparmi ((Arbre (o,(x,y)) f):fs) (Arbre (os,(xs,ys)) fss)
	| (point x y grille) > (point xs ys grille) = maxparmi fs (Arbre (o,(x,y)) fs)
	| otherwise = maxparmi fs (Arbre (os,(xs,ys)) fss)

--Prend parmi le noued ou c'est l'ordinateur qui a jouer , l'othello où la piece a été posé sur une case où le point
--est minimal
coutMin:: Arbre -> Arbre
coutMin (Arbre (o,(x,y)) (f:fs)) = minparmi fs f


minparmi:: [Arbre] -> Arbre -> Arbre
minparmi [] f = f
minparmi ((Feuille (o,(x,y))):fs) (Feuille (os,(xs,ys)))
	| (point x y grille) < (point xs ys grille) = minparmi fs (Feuille (o,(x,y)))
	| otherwise = minparmi fs (Feuille (os,(xs,ys)))


--retourne la position x y selon l'algorithme minmax
--on prend le noued adverse maximal , puis on prend dans ceux noeud , le fil minimal pour l'ordinateur
evaluation:: Othello -> (Int,Int)	
evaluation o = (x,y)
					where (Feuille (ot,(x,y))) = coutMin (coutMax (construireArbre o))	
					

-- jouer contre l'ordi avec la fonction MinMax

ordiMinMax :: IO ()
ordiMinMax = startordi jeux Noire 

startordiMinMax :: Othello -> Piece -> IO () 
startordiMinMax o p = do
 (afficher o)
 if (gagner o p == True) then quiAgagner o
    else if (p == Blanc && (passetour p o) == False ) then do 
    														  let (ox,oy) = evaluation o
    														  let ot = poser ox oy Blanc o
    														  putStrLn ("L'ordinateur a jouer en x = " ++ [Char.intToDigit ox] ++ " et en y = " ++ [Char.intToDigit oy] ++ " \n")
    							 							  startordiMinMax ot Noire

													else if ((passetour p o) == True) then do 
																							putStrLn ("Vous passer votre tour , vous ne pouvez pas posser de pion")
																							(startordiMinMax o Blanc)
																					  else do
																							putStrLn ("C'est au "++ (toString p) ++" de jouer")                             		
																							putStrLn ("Entrer La Position X :")
																							x <- getLine
																							putStrLn ("Entrer La Position Y :")
																							y <- getLine
																							if ((Char.isDigit (head x)) == True && (Char.isDigit (head y)) == True && (test (stringToInt x) (stringToInt y) p o) == True) then startordiMinMax (poser (stringToInt x) (stringToInt y) p o) Blanc
														 									  																																else do putStrLn("Position impossible ou non valide , rechoissisez")
	    																							  																																startordiMinMax o Noire

	    																							  																																
	    																							  																																

-- Choisir la profondeur
    																							  																																
profondeur:: Int -> Othello -> Arbre	    																							  																																
profondeur x o = Arbre (o,(0,0)) (construireForetP (2*x) Blanc o (oupeutposer 8 8 o Blanc []) )

construireForetP:: Int -> Piece -> Othello -> [(Int,Int)] -> [Arbre]
construireForetP 1 p o l = (construireFeuille o (oupeutposer 8 8 o p []))
construireForetP i p o [] = [] 
construireForetP i p o ((x,y):ls)  = (Arbre (ot,(x,y)) (construireForetP (i-1) (contraire p) ot (oupeutposer 8 8 ot (contraire p) []))):(construireForetP i p o ls)
									where ot =  poser x y p o 	
    																							  																																	    																							  																																 																							  																																														  																																	    																							  																																

