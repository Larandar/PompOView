import Char
-- ***************************************************************
-- DATA ET PLATEAU PAR DEFAUT
-- ***************************************************************
--Type des cases
data Case = N|B|V|P deriving (Show,Eq,Ord)
--Position de depart du jeu
plateauStart =[ [V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,B,N,V,V,V],
                [V,V,V,N,B,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V]]

-- ***************************************************************
-- AFFICHAGE
-- ***************************************************************
--affiche un plateau (8x8 cases )
sep = " ---------------------------------\n"
affiche p = putStr (affichePlateau p)
affichePlateau [] = sep
affichePlateau (l:ls ) = sep ++ (afficheLigne l ) ++ "\n" ++ (affichePlateau ls )
        where
        afficheLigne [ ] =" | "
        afficheLigne ( e : xs ) = " | " ++ ( afficheElem e ) ++ ( afficheLigne xs )
                where
                afficheElem V =" "
                afficheElem N ="#"
                afficheElem B ="O"
                afficheElem P = "."

-- Question 1
diag4 :: [[a]] -> Int -> Int -> [a]
diag4 [] _ _ = []
diag4 (a:l) x1 x2
 |x1/=0 = diag4 l (x1-1) x2
 |otherwise = diag3 (a:l) x2

--modifie un plateau du jeu d'othello (ce n'est pas la reponse de la question --1.2 cette fonction modifie simplement la case d'un plateau.
pose :: (Num a, Num b) => a -> b -> [[c]] -> c -> [[c]]
pose j i (x:xs) c
	| j==0 = (poseLigne i x c):xs
	| otherwise = x:(pose (j-1) i xs c)
	where
	poseLigne j (x:xs) c
		| j==0 = (c:xs)
		| otherwise = x:(poseLigne (j-1) xs c)

--liste des coordonnees des coups admissibles
coupAdmissibleLst :: [[Case]] -> Case -> [(Int,Int)]
coupAdmissibleLst p c = coupAdm 0 p c

--liste des plateaux(fonction qui renvoie la liste des successeurs d'un jeu --d'othello )
coupAdmissible :: [[Case]] -> Case -> [[[Case]]]
coupAdmissible p c = map (\x->pose (fst x) (snd x) p P) (coupAdm 0 p c)

afficheCoupAdmissible :: [[Case]] -> Case -> IO ()
afficheCoupAdmissible p c = affCoupAdmissible p (coupAdmissibleLst p c)

-- affiche un point "." dans les cases dont les coordonn�es sont dans la liste (x:xs).
affCoupAdmissible :: (Num a, Num b) => [[Case]] -> [(b,a)] -> IO ()
affCoupAdmissible p [] = affiche p
affCoupAdmissible p (x:xs)=  affCoupAdmissible (pose (fst x) (snd x) p P) xs

-- affiche la liste des coups admissibles a partir d'une ligne donnee
coupAdm :: Int -> [[Case]] -> Case -> [(Int,Int)]
coupAdm i p c 
	| (length p) == i = []
	| otherwise = (coupAdmLigne i 0 p c)++(coupAdm (i+1) p c)

--affihche les coordonnees d'un coup admissible a partir des coordonnees d'une --case et de sa couleur
coupAdmLigne :: Int -> Int -> [[Case]] -> Case -> [(Int,Int)]
coupAdmLigne i j p c
	| (length p) == j = []
	| (peutPoserPlace i j p c)==True = (i,j):(coupAdmLigne i (j+1) p c)
	| otherwise = (coupAdmLigne i (j+1) p c)

--renvoie vrai si on peut placer un pion dans le jeu d'othello
peutPoserPlace :: Int -> Int -> [[Case]] -> Case -> Bool
peutPoserPlace i j plateau c
	| plateau!!i!!j /=V = False 
	| otherwise = (peutPoser (verticalInf i j plateau) c False) || (peutPoser (verticalSup i j plateau) c False) || (peutPoser (horizontalInf i j plateau) c False) || (peutPoser (horizontalSup i j plateau) c False) || (peutPoser (diagonalSup i j plateau) c False) || (peutPoser (diagonalInf i j plateau) c False) || (peutPoser (antiDiagonalSup i j plateau) c False) || (peutPoser (antiDiagonalInf i j plateau) c False)

--verticalInf affiche la ligne verticale inferieure de la case de coordonnees i --j dans le plateau du jeu(idem pour les fonctions qui
--suivent mais avec des lignes horizontales, diagonales etc.....)
verticalInf :: Int -> Int -> [[a]] -> [a]
verticalInf i j plateau = reverse (map (\x->x!!j) (take (i) plateau))

verticalSup :: Int -> Int -> [[a]] -> [a]
verticalSup i j plateau = enleve (i+1) (map (\x->x!!j) (plateau)) 

horizontalInf :: Int -> Int -> [[a]] -> [a]
horizontalInf i j plateau = reverse (take j (plateau!!i))

horizontalSup :: Int -> Int -> [[a]] -> [a]
horizontalSup i j plateau = enleve (j+1) (plateau!!i)

diagonalInf :: Int -> Int -> [[a]] -> [a]
diagonalInf j i plateau= reverse (take (min i j) (diagonal i j plateau)) 

diagonalSup :: Int -> Int -> [[a]] -> [a]
diagonalSup j i plateau = enleve ((min i j)+1) (diagonal i j plateau)

antiDiagonalInf :: Int -> Int -> [[a]] -> [a]
antiDiagonalInf i j plateau = diagonalInf i ((length plateau)-j-1) (retourne plateau)

antiDiagonalSup :: Int -> Int -> [[a]] -> [a]
antiDiagonalSup i j plateau = diagonalSup i ((length plateau)-j-1) (retourne plateau)

-- calcule toute la diagonale
diagonal :: Int -> Int -> [[a]] -> [a]
diagonal x y plateau
	| x==y = calculDiagonal 0 0 plateau
	| x>y= calculDiagonal (x-y) 0 plateau
	|otherwise = calculDiagonal 0 (y-x) plateau
  
	
--calcule une partie de la diagonale a partir de la case de coordonnees x,y
calculDiagonal :: Int -> Int -> [[a]] -> [a]	
calculDiagonal x y plateau
	| (x == (length plateau) || y == (length plateau)) = []
	| otherwise=(plateau!!y!!x):(calculDiagonal (x+1) (y+1) plateau)

--inverse le plateau
retourne :: [[a]] -> [[a]]
retourne plateau = map (\x->reverse x) plateau

--enleve les n premieres cases de la liste de cases
enleve :: Num a => a -> [b] -> [b]
enleve 0 l = l
enleve 1 (x:xs) = xs
enleve n (x:xs) = enleve (n-1) xs

peutPoser :: [Case] -> Case -> Bool -> Bool
peutPoser [] _ _ = False
peutPoser (x:xs) c b
	| x==V = False
	| x==c = b
	| otherwise = peutPoser (xs) c True
	
--Question 2


modification :: [Case] -> Case -> [Case]
modification l c
	| (peutPoser l c False) = modif l c
	| otherwise = l  
	where
	modif [] _ = []
	modif (x:xs) c
		| x==c = xs
		| otherwise = c:(modification xs c)

--modification horizontale du plateau
horizontalPose ie i j (x:xs) c p
	| ie==0 = ((reverse (modification (horizontalInf i j p) c)) ++ (c:(modification (horizontalSup i j p) c))):xs
	| otherwise = x:(horizontalPose (ie-1) i j xs c p)

--modification verticale du plateau à partir d'un pion de coordonnées (i,j)
verticalPose :: Int -> Int -> [[Case]] -> Case -> [[Case]]
verticalPose i j p c =ajoutVertical j ((reverse (modification (verticalInf i j p) c))++(c:(modification  (verticalSup i j p) c))) p
	where
	ajoutVertical _ _ [] = []
	ajoutVertical i (x:xs) (e:er) = ((take i e)++(x:(enleve (i+1) e))):(ajoutVertical i xs er)

--modification diagonale du plateau  à partir d'un pion de coordonnées (i,j)
diagonalPose :: Int -> Int -> [[Case]] -> Case -> [[Case]]
diagonalPose i j p c = ajoutDiagonal (max 0 (j-i)) ((reverse (modification (diagonalInf i j p) c))++(c:(modification  (diagonalSup i j p) c))) p (aide i j)
	where
	ajoutDiagonal _ _ [] _= []
	ajoutDiagonal _ [] a _ = a
	ajoutDiagonal i (x:xs) (e:er) l
		| l>0 = e:(ajoutDiagonal i (x:xs) er (l-1))
		| otherwise = ((take i e)++(x:(enleve (i+1) e))):(ajoutDiagonal (i+1) xs er 0)
		
aide :: (Ord a, Num a) => a -> a -> a
aide i j
	| i>j = i-j
	| otherwise=0 

--modification de la diagonale inverse du plateau  à partir d'un pion de coordonnées (i,j)
antiDiagonalPose :: Int -> Int -> [[Case]] -> Case -> [[Case]]
antiDiagonalPose i j p c = retourne (diagonalPose i ((length p)-j-1) (retourne p) c)

-- transformation du plateau suite à la pose d'un pion
poseModifie :: Int -> Int -> [[Case]] -> Case -> [[Case]]
poseModifie i j p c = antiDiagonalPose i j (diagonalPose i j (verticalPose i j (horizontalPose i i j p c p) c) c) c

-- Question 3
--score des deux joueurs
score :: [[Case]] -> IO ()
score plateau = putStr ("Joueur Noir : "++[(intToDigit (scoreNoir plateau))]++"\nJoueur Blanc : "++[(intToDigit (scoreBlanc plateau))]++"\n")

scoreNoir :: Num a => [[Case]] -> a
scoreNoir [] = 0
scoreNoir (l:ls) = (elementLigneNoir l) + (scoreNoir ls)
        where 
        elementLigneNoir [] = 0
        elementLigneNoir (l:ls)
                | l==N = 1 + (elementLigneNoir ls)
                | otherwise = (elementLigneNoir ls)
scoreBlanc :: Num a => [[Case]] -> a
scoreBlanc [] = 0
scoreBlanc (l:ls) = (elementLigneBlanc l) + (scoreBlanc ls)
        where 
        elementLigneBlanc [] = 0
        elementLigneBlanc (l:ls)
                | l==B = 1 + (elementLigneBlanc ls)
                | otherwise = (elementLigneBlanc ls)

-- Question 4
--le jeu d'othello est considere termine si toutes les cases sont remplies(il n y a plus de case vide) ou si aucun des deux joueurs ne peut jouer.
estFini :: [[Case]] -> Bool
estFini p = (scoreBlanc p)+(scoreNoir p)==(lon*lon) || (((length (coupAdmissibleLst p N))==0) && ((length (coupAdmissibleLst p B))==0))
	where
		lon=(length p)
-- Question 5
--lance une phase de jeux d'une couleur de pion et un plateau donn�s en entr�e
phaseJeux :: Case -> [[Case]] -> IO ()
phaseJeux c p= do
	affiche p
	putStrLn ("Entrer un x: ")
	x <- getLine
	putStrLn ("Entrez un y: ")
	y <- getLine 
	peutPoserStr (peutPoserPlace (stringToInt y) (stringToInt x) p c) c x y p

-- definit si un joueur peut placer le pion donn� en entr�e avec ses coordonn�es dans le plateau
-- la fonction peutPoserStr modifie le plateau si la pose du pion est accept�e.
peutPoserStr :: Bool -> Case -> [Char] -> [Char] -> [[Case]] -> IO ()
peutPoserStr b c x y p
	| estFini nouveauPlateau = putStrLn (fin nouveauPlateau)
	| ((length (coupAdmissibleLst nouveauPlateau (changementJoueur c)))==0) && b= do
			(putStrLn ("Le joueur "++(nomJoueur (changementJoueur c))++" ne peut pas placer de pion. Le "++(nomJoueur c)++" joue encore"))
			phaseJeux c nouveauPlateau
	| b = do
		(putStrLn ("Pion place. Au tour de "++(nomJoueur (changementJoueur c))++" de jouer")) 
		phaseJeux (changementJoueur c) nouveauPlateau
	| otherwise = do 
			(putStrLn ("vous ne pouvez pas placer ce pion. "++(nomJoueur c)++" joue encore"))
			(phaseJeux c p)
	where
		nouveauPlateau = (poseModifie (stringToInt y) (stringToInt x) p c)

-- renvoie le score de chacun des deux joueurs
fin :: [[Case]] -> [Char]
fin p
	| blanc>noir = "Joueur Blanc gagne la partie avec "++(show blanc)++"\nJoueur Noir perd avec "++(show noir)++"\n"
	| otherwise = "Joueur Noir gagne la partie avec "++(show noir)++"\nJoueur Blanc perd avec "++(show blanc)++"\n"
	where
		blanc = scoreBlanc p
		noir = scoreNoir p

--retourne le nom du joueur
nomJoueur :: Case -> [Char]
nomJoueur c
	| c==N = "joueur Noir"
	| otherwise = "joueur Blanc"	

-- retourne le joueur adverse
changementJoueur :: Case -> Case
changementJoueur c
	| c==N = B
	| otherwise = N
stringToInt::String->Int
stringToInt x = stiAux x 0
	where
	stiAux [] c = c
	stiAux (x:xs) c = stiAux xs (c*10 + (Char.digitToInt x))
	
--lance une partie de deux joueurs humains(le joueur Noir commence)
unvsun :: IO ()
unvsun = phaseJeux N plateauStart

-- Partie 2

grille =[ [100,-20,10,5,5,10,-20,100],
                [-20,-50,-2,-2,-2,-2,-50,-20],
                [10,-2,-1,-1,-1,-1,-2,10],
                [5,-2,-1,-1,-1,-1,-2,5],
                [5,-2,-1,-1,-1,-1,-2,5],
                [10,-2,-1,-1,-1,-1,-2,10],
                [-20,-50,-2,-2,-2,-2,-50,-20],
                [100,-20,10,5,5,10,-20,100]]
-- calcule le maximum d'une liste de coordonnées .			
calculMaximum :: [(Int,Int)] -> (Int,Int)
calculMaximum [] = (1,1)
calculMaximum (x:[]) = x
calculMaximum (x:e:xs) = calculMax ( calculMax x e) (calculMaximum xs) 

calculMax :: (Int,Int) -> (Int,Int) -> (Int,Int)
calculMax (a,e) (ar,er)
	| (max (grille!!e!!a) (grille!!er!!ar)) == (grille!!e!!a) = (a,e)
	| otherwise = (ar,er)

--fait jouer l'ordinateur un coup selon la grille de la figure 2(en jouant sur --la case maximale possible de la grille).
jouerCoupPC :: Case -> [[Case]] -> [[Case]]
jouerCoupPC c p = poseModifie (fst sol) (snd sol) p c
	where
		sol = calculMaximum (coupAdmissibleLst p c)


jouerPC :: Case -> [[Case]] -> IO ()
jouerPC B p
	| estFini nouveauPlateau = putStrLn (fin nouveauPlateau)
	| (length (coupAdmissibleLst nouveauPlateau N)==0) = do
			(putStrLn ("Vous ne pouvez placer le pion, l'ordinateur joue encore"))
			putStrLn ("l'ordi joue en x "++ [(intToDigit (fst sol))]++"et en y = "++ [(intToDigit (snd sol))])
			affiche nouveauPlateau
			jouerPC B nouveauPlateau
	| otherwise = do 
			putStrLn ("l'ordi joue en x "++ [(intToDigit (fst sol))]++"et en y = "++ [(intToDigit (snd sol))])

	where
	nouveauPlateau = jouerCoupPC B p
	sol = calculMaximum (coupAdmissibleLst p B)

--lance une phase de jeu entre l'ordi et le joueur sur un plateau donn� en argument
phaseJeuxPC N p= do
	affiche p
	putStrLn ("Entrer un x: ")
	x <- getLine
	putStrLn ("Entrez un y: ")
	y <- getLine 
	peutPoserStrPC (peutPoserPlace (stringToInt y) (stringToInt x) p N) N x y p

-- meme fonctionnalit� que la fonction  peutPoserStr mais entre un joueur et un ordinateur
peutPoserStrPC :: Bool -> Case -> [Char] -> [Char] -> [[Case]] -> IO ()
peutPoserStrPC b c x y p
	| estFini nouveauPlateau = putStrLn (fin nouveauPlateau)
	| ((length (coupAdmissibleLst nouveauPlateau B))==0) && b= do
			putStrLn ("L'ordinateur ne peut pas placer de pion, vous jouez encore")
			phaseJeuxPC N nouveauPlateau
	| b = do
		affiche nouveauPlateau
		jouerPC B nouveauPlateau
		phaseJeuxPC N (jouerCoupPC B nouveauPlateau)
	| otherwise = do 
			 putStrLn ("vous ne pouvez pas placer ce pion.Vous jouez encore")
			 phaseJeuxPC N p
	where
		nouveauPlateau = (poseModifie (stringToInt y) (stringToInt x) p c)

unvspc :: IO ()
unvspc = phaseJeuxPC N plateauStart

-- Question 2
-- constructeur de l 'abre minmax
data Arb a = Vide | Node Int [[Case]] [Arb [[Case]]]
        deriving (Show,Ord,Eq)
--fonction qui crée l'abre minmax, chaque niveau correspond à un joueur donné
--dont on développe la liste de successeurs grace a la fonction coupAdmissibleLst
-- et on sélectionne le meilleur coup grace a la fonction d'evaluation definie --ci-dessus.
-- On considere que l'ordinateur aura les pions noir pour creer l'arbre en sa faveur
creerArbre 0 _ _ s= Vide
creerArbre n p c s= Node (evaluation s sol c) p sol
        where 
        	sol = (lst (coupAdmissibleLst p c) c)
                lst [] _= []
                lst (x:xs) N= (creerArbre (n-1) (poseModifie (fst x) (snd x) p c) B (grille!!(fst x)!!(snd x))):(lst xs N)
                lst (x:xs) B= (creerArbre (n-1) (poseModifie (fst x) (snd x) p c) N (inverse (grille!!(fst x)!!(snd x)))):(lst xs B)
--evaluation des cases de la grille de la figure 2
evaluation :: Int -> [Arb t] -> Case -> Int
-- on considere que l'ordinateur aura les pions noirs.     
evaluation e [] _= e
evaluation e ((Node s _ _):xs) N = evaluation (max e s) xs N
evaluation e ((Node s _ _):xs) B = evaluation (min e s) xs B
evaluation e (Vide:xs) c= evaluation e xs c

inverse :: (Num a) => a -> a
inverse e = -e

--reprend le meilleur resultat dans l'abre créé au préalable
longueurM :: Int -> [Arb t] -> [[Case]] -> [[Case]]
longueurM e [] p= p
longueurM e ((Node s er _):xs) p
	| s>e = longueurM s xs er
	| otherwise = longueurM e xs p
longueurM e (Vide:xs) p= longueurM e xs p

-- renvoie un plateau qui correspond au minmax de rang n.
resultat :: (Num t) => t -> [[Case]] -> Case -> [[Case]]
resultat n p c = res (creerArbre n p c 0)
	where
	res (Node _ p c) = longueurM (-201) c [[]]

--algo1 vs algo2
-- On teste quel algo est le meilleur. Le rang 0 contre le rang n variable.
algo1vsalgo2 :: Case -> [[Case]] -> IO ()
algo1vsalgo2 c p
	| estFini p = putStrLn (fin p)
	| ((length (coupAdmissibleLst p (changementJoueur c)))==0) = algo1vsalgo2 c (jouerAlgo c p)
	| (length (coupAdmissibleLst p c)==0) = algo1vsalgo2 (changementJoueur c) p
	| otherwise = do
		putStrLn (nomJoueur c)
		affiche play
		algo1vsalgo2 (changementJoueur c) play
	where
		play = (jouerAlgo c p)
		jouerAlgo N p = resultat 3 p N
		jouerAlgo B p = jouerCoupPC B p
main :: IO ()
main = algo1vsalgo2 N plateauStart


