import Char

--definition des états possibles d'une case : Noir, Blanc, Vide, Hors jeu
data Case = N | B | V | HJ deriving (Show,Eq)


-- Etat du jeu
type Plateau = [[Case]]

--Representation d'une position
type Position = (Int,Int)

--Exemple de plateau : plateauStart > Etat initial ; plateauFin > Etat final
plateauStart = [[V,V,V,V,V,V,V,V],
		[V,V,V,V,V,V,V,V],
		[V,V,V,V,V,V,V,V],
		[V,V,V,B,N,V,V,V],
		[V,V,V,N,B,V,V,V],
		[V,V,V,V,V,V,V,V],
		[V,V,V,V,V,V,V,V],
		[V,V,V,V,V,V,V,V]]
plateauFin = [[B,N,B,N,N,B,B,B],
		[B,N,B,N,N,B,B,B],
		[B,N,B,N,N,B,B,B],
		[N,N,N,B,N,N,B,B],
		[B,B,B,N,B,B,B,B],
		[B,N,B,N,N,B,B,B],
		[B,N,B,N,N,B,B,B],
		[B,N,B,N,N,B,B,B]]
plateauTest = [[V,V,V,V,V,V,V,V],
		[V,V,V,V,V,V,V,V],
		[V,V,B,V,V,V,V,V],
		[V,V,N,B,N,V,V,V],
		[V,V,V,N,B,V,V,V],
		[V,V,V,V,V,V,V,V],
		[V,V,V,V,V,V,V,V],
		[V,V,V,V,V,V,V,V]]

--Fonction d'affichage du plateau de jeu
sep = "+-+-+-+-+-+-+-+-+"

affichePlateau::Plateau->String
affichePlateau [] = sep++"\n"
affichePlateau (l:ls) = sep++"\n"++(afficheLigne l)++"\n"++(affichePlateau ls)
	where
		afficheLigne [] ="|"
		afficheLigne (e:xs) = "|"++(afficheElem e )++(afficheLigne xs)
			where
				afficheElem V =" "
				afficheElem N ="#"
				afficheElem B ="O"
				

-- accesseur en lecture du plateau de jeu
getCase:: Int -> Int -> Plateau -> Case
getCase a b p
        | (a < 1) || (b < 1) = HJ
        | (a > 8) || (b > 8) = HJ
        | otherwise = getCaseAux a b p
        where
        getCaseAux 1 1 p = (head (head p))
        getCaseAux n 1 p = getCaseAux (n-1) 1 ((tail (head p)):(tail p))
        getCaseAux n m p = getCaseAux n (m-1) (tail p)
		
		
{-#######################*PARTIE 1*############################################## 
############################Fonctions de jeu#####################################-}	
--1.1 Donne la liste des coups admissible selon une position et une couleur de pion.
admissible::Int->Int->Case->Plateau->[Position]
admissible x y c p 
	| ((getCase x y p)==c)||((getCase x y p)==V)||(c==V) = []
	| otherwise = (cases x y (x-1) (y-1) c p)++(cases x y x (y-1) c p)++(cases x y (x+1) (y-1) c p)++(cases x y (x-1) y c p)++(cases x y (x+1) y c p)++(cases x y (x-1) (y+1) c p)++(cases x y x (y+1) c p)++(cases x y (x+1) (y+1) c p) 


--Fonction renvoyant les cases possibles selon la direction donnée
cases::Int->Int->Int->Int->Case->Plateau->[Position]
cases a b x y c p 
	| (getCase x y p)==V = []
	| (((getCase x y p)==c) || (((getCase x y p)/=c)&&(suivant x y (x-a) (y-b) c p)))&&((getCase (a+(a-x)) (b+(b-y)) p)==V) = [(a+(a-x), b+(b-y))]
	| otherwise = []

--Fonction testant que la suite des pions suivant celui près du pion a tester , contient ou non un pion de la couleur du pion à poser.
suivant::Int->Int->Int->Int->Case->Plateau->Bool
suivant 8 _  x1 y1 c p = False
suivant _ 8 x1 y1 c p = False
suivant 0 _ x1 y1 c p = False
suivant _ 0 x1 y1 c p = False
suivant x y x1 y1 c p = ((getCase (x+x1) (y+y1) p)==c)||(suivant (x+x1) (y+y1) x1 y1 c p)



{-############################################################-}
--1.2

-- inverse la couleur des pions poser sauf si la case est vide ou hors jeu.
inversePion::Case->Case
inversePion c
	| c == B = N
	| c == N = B
	| otherwise = c

-- Modifie le plateau de jeu suite à la pose d'un pion
posePion::Int->Int->Case->Plateau->Plateau
posePion x y c p = (modifCase x y (x-1) (y-1) c (modifCase x y x (y-1) c (modifCase x y (x+1) (y-1) c (modifCase x y (x-1) y c (modifCase x y (x+1) y c (modifCase x y (x-1) (y+1) c (modifCase x y x (y+1) c (modifCase x y (x+1) (y+1) c (modifiePlateau c x y p))))))))) 


modifCase::Int->Int->Int->Int->Case->Plateau->Plateau
modifCase a b x y c p 
	| (getCase x y p)==V = p
	| ((getCase x y p)/=c)&&(suivant x y (x-a) (y-b) c p) = modifCase x y (x+(x-a)) (y+(y-b)) c (modifiePlateau c x y p)
	| otherwise = p

	
--Ajoute le pion au plateau 
modifiePlateau :: Case -> Int ->Int -> Plateau -> Plateau
modifiePlateau e x y p = modifieP e x y p

modifieP :: a -> Int -> Int -> [[a]] -> [[a]]
modifieP e x y [] = []
modifieP e x 1 (g:gs) = (modifieL e x g) : gs
modifieP e x y (g:gs) = g : (modifieP e x (y-1) gs)

modifieL :: a -> Int ->[a] -> [a]
modifieL _ _ []     = []
modifieL e 1 (g:gs) = e : gs
modifieL e x (g:gs) = g : (modifieL e (x-1) gs)	




{-################################################-}
--1.3 Donne le nombre de pions de chaque couleur
score::Plateau->String
score p = "Noirs : "++(show (nombreCouleur N p))++" | Blancs : "++(show (nombreCouleur B p))

nombreCouleur::Case->Plateau->Int
nombreCouleur c [] = 0
nombreCouleur c (l:ls) = (nombreCouleurAux c l)+(nombreCouleur c ls) 
	where
		nombreCouleurAux c [] = 0
		nombreCouleurAux c (k:ks) 
			| k==c = 1+(nombreCouleurAux c ks)
			| otherwise = nombreCouleurAux c ks
			

{-################################################-}
--1.4 détermine si le plateau est complet ou non
estFinal::Plateau->Bool
estFinal p = (not(foldr (||) False (map (elem V) p)))||(not(foldr (||) False (map (elem N) p)))||(not(foldr (||) False (map (elem B) p)))


{-########################################################-}
--1.5 Programme permettant l'affrontement de deux joueurs


--Fonction retournant pour une couleur donné l'ensemble des coups admissible sur le plateau.
listeCoupAdmissibles::Case->Plateau->Plateau->Int->Int->[Position]
listeCoupAdmissibles c _ p a 0 = []
listeCoupAdmissibles c (l:ls) p a b = (liste c l p a b)++(listeCoupAdmissibles c ls p a (b-1))
	where
		liste c _ p 0 _ = []
		liste c (k:ks) p x b
			| (getCase x b p)==V = liste c ks p (x-1) b
			|otherwise = (admissible x b c p)++(liste c ks p (x-1) b)

			
--Fonction pour une position à joué vérifie si elle se trouve dans la liste des positions admissibles.			
estJouable::Int->Int->Case->Plateau->Bool
estJouable x y c p = estJouableAux x y (listeCoupAdmissibles c p p 8 8) p 
	where 
		estJouableAux x y [] p = False
		estJouableAux x y (l:ls) p
			| ((((fst l)==x)&&((snd l)==y))&&((getCase x y p)==V)) = True
			| otherwise = False || (estJouableAux x y ls p)

			
--Lanceur du programme
main :: IO()
main = do
	putStrLn ("!! La partie de reversi commence !! ")
	help
	putStrLn (" C'est Partie !!! ")
	lanceTour plateauStart

	
--Aide des variable a rentrer	
help = do	
	putStrLn (" +++++++++++++++++++++++++++++++++++")
	putStrLn (" Joueur 1 possede les pions Blancs ")
	putStrLn (" Joueur 2 possede les pions Noirs ")
	putStrLn (" -- Tapez 1 pour le joueur 1 -- ")
	putStrLn (" -- Tapez 2 pour le joueur 2 -- ")
	putStrLn (" -- Tapez Q pour Quitter la partie --")
	putStrLn (" +++++++++++++++++++++++++++++++++++")


	
--Fonction transformant les string en int	
stringToInt::String->Int
stringToInt x = stiAux x 0
	where
	stiAux [] c = c
	stiAux (x:xs) c = stiAux xs (c*10 + (Char.digitToInt x))


	
--Fonction démarrant un tour de jeu
lanceTour :: Plateau -> IO()	
lanceTour p = do
	putStrLn (affichePlateau p)
	putStrLn ("Le score encour est de :"++(score p))
	putStrLn ("Saisissez le numero du joueur ou Q pour quitter")
	j <- getLine
	if (j=="Q") then putStrLn("Partie Terminee"++(score p)) 
				else (go j p)
				
--Fonction faisant jouer un joueur
go ::String->Plateau->IO()
go j p = do
	putStrLn ("Saisissez le numero de la colonne de votre pion")
	x <- getLine
	putStrLn ("Saisissez le numero de la ligne de votre pion")
	y <- getLine
	if (estFinal p==False) then (joueur (stringToInt j) (stringToInt x) (stringToInt y) p)
						  else putStrLn ("La partie est finie ! Le score est de :"++(score p))

						  
--Fonction testant le joueur du tour
joueur ::Int->Int->Int->Plateau->IO()
joueur i x y p =do
	if (i==1) then (possible x y B p)
			                 else (possible x y N p)		

							 
--Fonction testant si le coup est possible 
possible ::Int->Int->Case->Plateau->IO()
possible x y c p = do
	if  (estJouable x y c p) then (joueCoup x y c p)
			                 else (mauvaisCoup p)

							 
--Fonction relancant le tour en cas de mauvais coup
mauvaisCoup p = do lanceTour p					


--Fonction Modifiant le plateau								  
joueCoup ::Int->Int->Case->Plateau->IO()
joueCoup x y  c p = do 
		lanceTour (posePion x y c p)

{-######################*PARTIE 2*####################		
######################################################-}	
--2.6

grilleEval=[[100,-20,10,5,5,10,-20,100],[-20,-50,-2,-2,-2,-2,-50,-20],[10,-2,-1,-1,-1,-1,-2,10],[5,-2,-1,-1,-1,-1,-2,5],[5,-2,-1,-1,-1,-1,-2,5],[10,-2,-1,-1,-1,-1,-2,10],[-20,-50,-2,-2,-2,-2,-50,-20],[100,-20,10,5,5,10,-20,100]]


--Fonction donnant pour une case donnée son evaluation
getEvalCase::[[Int]]->Int->Int->Int
getEvalCase [] _ _ = 0
getEvalCase (l:ls) x y = (getEvalCaseAux l x y)+(getEvalCase ls x (y-1))
	where
		getEvalCaseAux [] _ _ =0
		getEvalCaseAux (z:zs) 0 0 = z
		getEvalCaseAux (k:ks) x y = getEvalCaseAux ks (x-1) y
		

--Fonction qui donne tous les coups possibles et leurs evaluations en fonction d'une liste de coup admissible 
listeEval::[Position]->[(Int,Position)]
listeEval k = map (\x-> ((getEvalCase grilleEval (fst x) (snd x)),x)) k


--Fonction retournant le meilleur choix possible
meilleur::[(Int,Position)]->Position
meilleur p = meilleurAux p (-2000,(0,0))
	where 
		meilleurAux [] acc = snd acc
		meilleurAux (k:ks) acc 
			| ((fst k) > (fst acc)) = meilleurAux ks k
			| otherwise = meilleurAux ks acc
			

--Lanceur du programme a un joueur
mainBis :: IO()
mainBis = do
	putStrLn ("!! La partie de reversi commence !! ")
	helpBis
	putStrLn (" C'est Partie !!! ")
	lanceTourBis plateauStart

	
--Aide des variable a rentrer	
helpBis = do	
	putStrLn (" +++++++++++++++++++++++++++++++++++")
	putStrLn (" Joueur 1 possede les pions Blancs ")
	putStrLn (" L'ordinateur possede les pions Noirs ")
	putStrLn (" +++++++++++++++++++++++++++++++++++")


--Fonction faisant jouer l'ordinateur en fonction de la grille d'évaluation des positions
ordinateur p = do 
	             posePion (fst (meilleur (listeEval d))) (snd (meilleur (listeEval d))) N p
					where 
						d = listeCoupAdmissibles N p p 8 8

	
--Fonction démarrant un tour de jeu
lanceTourBis :: Plateau -> IO()	
lanceTourBis p = do
	putStrLn (affichePlateau  p)
	putStrLn ("L'ordinateur joue !")
	putStrLn (affichePlateau (ordinateur p))
	putStrLn ("Le score encour est de :"++(score (ordinateur p)))
	putStrLn ("Saisissez Q pour quitter ou 1 pour continuer")
	j <- getLine
	if (j=="Q") then putStrLn("Partie Terminee"++(score (ordinateur p))) 
				else (goBis (ordinateur p))
				
--Fonction faisant jouer un joueur
goBis ::Plateau->IO()
goBis p = do
	putStrLn ("Saisissez le numero de la colonne de votre pion")
	x <- getLine
	putStrLn ("Saisissez le numero de la ligne de votre pion")
	y <- getLine
	if (estFinal p==False) then (possibleBis (stringToInt x) (stringToInt y) B p)
						  else putStrLn ("Le Plateau est complet, la partie est finie ! Le score est de :"++(score p))


--Fonction testant si le coup est possible 
possibleBis ::Int->Int->Case->Plateau->IO()
possibleBis x y c p = do
	if  (estJouable x y c p) then (joueCoupBis x y c p)
			                 else (mauvaisCoupBis p)

--Fonction relancant le tour en cas de mauvais coup
mauvaisCoupBis p = do lanceTourBis p					

--Fonction Modifiant le plateau								  
joueCoupBis ::Int->Int->Case->Plateau->IO()
joueCoupBis x y  c p = do 
		lanceTourBis (posePion x y c p)

		
