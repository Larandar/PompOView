---------------------------------------------
-- Programmation Fonctionnelle - Devoir 1 ---
-- Lecrosnier Cédric & Proch Nicolas --------
-- 31 Janvier 2007 --------------------------
---------------------------------------------

import Char


-- Type Case
data Case = N|B|V 
            deriving (Show,Eq)

-- Le plateau du début
plateauStart = [[V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,B,N,V,V,V],
                [V,V,V,N,B,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V]]

plateauFin = [[V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,N,N,V,V,V],
                [V,V,V,N,N,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V]]


-- Affichage
sep = "+---+---+---+---+---+---+---+---+"
affichePlateau [] = sep
affichePlateau (l : ls) =
    sep ++ "\n" ++ (afficheLigne l) ++ "\n" ++ (affichePlateau ls)
        where
          afficheLigne [] = "|"
          afficheLigne (e : xs) = "|" ++ (afficheElem e) ++ (afficheLigne xs)
              where
                afficheElem V = "   "
                afficheElem N = " # "
                afficheElem B = " O "




-- Partie 1

-- Fonction qui retourne la couleur inverse de celle donnée en argument
inverse :: Case -> Case
inverse N = B
inverse B = N
inverse V = V  --On définit l'inverse de V par sécurité

-- Fonction qui retourne la liste passée en argument privée des premiers éléments vérifiant le prédicat p
dropwhile :: (a -> Bool) -> [a] -> [a]
dropwhile _ [] = []
dropwhile p (x:xs)
    | p x = dropwhile p xs
    | otherwise = x:xs

-- Fonction qui retourne la liste passée en argument privée des n premiers éléments 
untake :: Int -> [a] -> [a]
untake _ [] = []
untake 0 l = l
untake n (x:xs) = untake (n-1) xs



-- Question 1.1

-- Prédicat peutPoser
peutPoser :: Case -> [Case] -> Bool
peutPoser _ [] = False
peutPoser _ (x1:[]) = False
peutPoser col (x1:x2:xs)
    | (x1 == V) && (x2 == anticol) && (head (dropwhile (== anticol) xs) == col) = True
    | otherwise = False
    where anticol = inverse col

-- Accesseurs qui retourne l'élement du plateau d'indice (i,j)
getElem :: [[Case]] -> (Int,Int) -> Case
getElem p (i,j) = head (untake j iemeLigne)
    where iemeLigne = head (untake i p)


-- Fonctions qui créent la listes des cases situées dans une direction à partir de la case (i,j)
diagonaleAvant,diagonaleApres,antiDiagonaleAvant,antiDiagonaleApres :: [[Case]] -> (Int,Int) -> [Case]
colonneAvant,colonneApres,ligneAvant,ligneApres :: [[Case]] -> (Int,Int) -> [Case]
diagonaleAvant p (i,j)
    | i<0 || j<0 = []
    | otherwise = (getElem p (i,j)) : (diagonaleAvant p (i-1,j-1))
diagonaleApres p (i,j) 
    | i==l || j==l = []
    | otherwise = (getElem p (i,j)) : (diagonaleApres p (i+1,j+1))
    where l = length p
antiDiagonaleAvant p (i,j) 
    | i<0 || j==(length p) = []
    | otherwise = (getElem p (i,j)) : (antiDiagonaleAvant p (i-1,j+1))
antiDiagonaleApres p (i,j)
    | i==(length p) || j<0 = []
    | otherwise = (getElem p (i,j)) : (antiDiagonaleApres p (i+1,j-1))
colonneAvant p (i,j)
    | i<0 = []
    | otherwise = (getElem p (i,j)) : (colonneAvant p  (i-1,j))
colonneApres p (i,j)
    | i == (length p) = []
    | otherwise = (getElem p (i,j)) : (colonneApres p (i+1,j))
ligneAvant p (i,j)
    | j<0 = []
    | otherwise = (getElem p (i,j)) : (ligneAvant p (i,j-1))
ligneApres p (i,j)
    | j == (length p) = []
    | otherwise = (getElem p (i,j)) : (ligneApres p (i,j+1))

-- Toutes les directions
toutesLesListes :: [[Case]] -> (Int,Int) -> [[Case]]
toutesLesListes p (i,j) = (diagonaleApres p (i,j)):
                           (diagonaleAvant p (i,j)):
                           (antiDiagonaleApres p (i,j)):
                           (antiDiagonaleAvant p (i,j)):
                           (colonneApres p (i,j)) :
                           (colonneAvant p (i,j)) :
                           (ligneApres p (i,j)):
                           (ligneAvant p (i,j)):[]

-- Prédicat peutPoserAnyDir
peutPoserAnyDir :: Case -> [[Case]] -> (Int,Int) -> Bool
peutPoserAnyDir col p (i,j) = (foldr (||) False (map (peutPoser col) (toutesLesListes p (i,j))))


-- Fonction qui étant donnée une position et une couleur retourne la liste des coups admissibles
coupsAdmissibles :: Case -> [[Case]] -> [(Int,Int)]
coupsAdmissibles col p = filter (peutPoserAnyDir col p) [(i,j) | i<-[0..l], j<-[0..l]]
    where l = (length p) -1 






--Question 1.2

--Accesseur setElem
setElem :: Case -> [[Case]] -> (Int,Int) -> [[Case]]
setElem col p (i,j) = (take i p) ++ iemeLigne ++ (untake (i+1) p)
	where iemeLigne = [(take j (head (untake i p)))++[col]++(untake (j+1) (head(untake i p)))]

listeDirection = [(1,1),((-1),(-1)),(1,(-1)),((-1),1),(1,0),((-1),0),(0,1),(0,(-1))]

-- (zip (toutesLesListes p (i,j)) listeDirection) fait une liste de tuples : (diagonalesAvant,(-1,-1)),(colonneApres,(1,0))...
-- le filter ne garde que ceux admissibles (donc où il y a des pions à changer)
-- le map tail sert à enlever le premier elt des listes qui contiennent l'élément courant (de pos i,j)
k p col i j = map (\(x,(y,z))-> ((tail x),(y,z))) (filter (\(x,(y,z)) -> peutPoser col x) l)
	where l = (zip (toutesLesListes p (i,j)) listeDirection)


-- Fonction qui compte le nombre d'éléments à changer
compter col (x:xs) 
    | col==x = 1 + (compter col xs)
    | otherwise = 0

-- Fonction qui permet "d'avancer" dans une direction
continuer 0 _ _ _ _ = []
continuer n i j vari varj = (ni,nj) : (continuer (n-1) ni nj vari varj)
    where ni = i+vari
          nj = j+varj

-- Fonction qui retourne les indices des cases à changer dans une direction 
elemsAchangerDansUneDirection p col i j (l,(vari,varj)) = continuer nbAchanger i j vari varj
    where nbAchanger = compter (inverse col) l

-- Fonction qui retourne les indices des cases à changer dans toutes les directions
elemsAchanger p col i j = foldr (++)[] ( map (elemsAchangerDansUneDirection p col i j) liste)
    where liste = k p col i j

-- Fonction qui modifie le plateau après la pose d'un pion
poser p col i j = poserAux p col i j ((i,j):l)
    where l = elemsAchanger p col i j
          poserAux p col i j [] = p
          poserAux p col i j (x:xs) = poserAux (setElem col p x) col i j xs






--Question 1.3

-- Fonction qui donne le score de la couleur donnée en argument
score :: Case -> [[Case]] -> Int
score col plateau = foldr (+) 0 (map length (map (filter (==col)) plateau))






--Question 1.4

-- Fonction qui détermine si une partie est terminée
finPartie :: [[Case]] -> Bool
finPartie plateau = nbN == 0 || nbB == 0 || nbV == 0
    where nbN = score N plateau
          nbB = score B plateau
          nbV = score V plateau




--Question 1.5

-- Fonction qui transforme une chaine de carctère en un entier correspondant
stringToInt :: String -> Int
stringToInt x = stiAux x 0
	where
	stiAux [] c = c
	stiAux (x:xs) c = stiAux xs (c*10 + (Char.digitToInt x))

-- affichage des scores
afficherScore p = do 
	putStrLn ("Noirs : " ++ (show (score N p)))
	putStrLn ("Blancs : " ++ (show (score B p)))

-- saisie des coordonnées du pion
getCoords = do
	putStrLn ("indice de la ligne : ")
	l <- getLine
	putStrLn ("indice de la colonne : ")
	c <- getLine
	return (stringToInt l, stringToInt c)

-- jouer !!
jouer col p = do 
	if finPartie p then do 
			(afficherScore p) 
			return ""
		else do 
			if (coupsAdmissibles col p) == [] then do (jouer (inverse col) p)
				else do
					putStrLn (affichePlateau p)
					putStrLn ("Aux " ++ (show col) ++ " de jouer")
					(i,j) <- getCoords
					if (not (elem (i,j) (coupsAdmissibles col p))) then do 
							putStrLn ("coordonnees incorrectes")
							(jouer col p)
						else do 
							jouer (inverse col) (poser p col i j)

-- lancement du jeu
main = do
	jouer N plateauStart

