-- GUERET GREGORY L3 INFORMATIQUE
-- GGUERET@ETU.INFO.UNICAEN.FR
-- HASKELL DEVOIR 2
-- HUGS (HASKELL98 Mode)
-- Compiler puis taper main pour lancer le jeu.

data Case = N|B|V|A deriving (Show,Eq)

plateauStart = [[V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,B,N,V,V,V],
                [V,V,V,N,B,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V],
                [V,V,V,V,V,V,V,V]]


-- On utilisera une variante de plateauStart, plateauStart ou A represente une case vide
-- adjacente a un pion (afin de gagner du temps par la suite).
				
sep = "+-+-+-+-+-+-+-+-+"
affichePlateau [] = sep
affichePlateau (l:ls)=
    sep ++ "\n" ++ (afficheLigne l) ++ "\n" ++ (affichePlateau ls)
    where
    afficheLigne [] = "|"
    afficheLigne (e:xs) = "|" ++ (afficheElem e) ++ (afficheLigne xs)
        where
        afficheElem V = " "
        afficheElem N = "#"
        afficheElem B = "O"

-- QUESTION 1.1

-- Note : On appellera 'case hostile' une case occupee par un pion de couleur adverse. On la note H.
--		  On appellera 'case amie' une case occupee par un pion de notre couleur. On la note A.
--        On note V une case.
-- 		  H* represente un nombre quelconque de case hostiles adjacentes dans une même ligne, diagonale ou colonne.

-- METHODE : On va va partir de chaque case adjacente et on va parcourir le plateau dans les 8 directions.
-- On recherche des suites de cases de la forme :
-- V - H* - A
-- A chaque fois, la case vide sera solution.
-- Il faudra donc garder en memoire la case vide V et la liste des cases hostiles H*

-- Fonctions utiles
iEme :: Int -> [a] -> a
iEme 1 (x:xs) = x
iEme n (x:xs) = iEme (n-1) xs

append :: [a] -> [a] -> [a]
append []		ys = ys
append (x:xs)	ys = x : (append xs ys)

member x (y:ys) | x == y    = True
                | otherwise = member x ys
member x [] = False

-- A partir d'une liste de coordonnees, renvoit la liste des contenus (par exemple [N,B,N,V,V,V,V,V])
listeCase :: [[Case]] -> [[Int]] -> [Case] -> [Case]
listeCase plateau [] liste = liste
listeCase plateau (x:xs) liste = [(pion (iEme 1 x) (iEme 2 x) plateau)] ++ listeCase plateau xs liste

-- Renvoit le pion contenu dans la case du plateau de coordonnee x y. La position (1,1) correspond a la case la plus en haut a gauche.
pion :: Int -> Int -> [[Case]] -> Case
pion x y plateau = iEme x (iEme y plateau)

-- A partir d'un pion on va parcourir le plateau dans une direction afin de
-- recuperer la liste de coordonnees de cases
creerListe :: Int -> Int -> [Int] -> [[Case]] -> [[Int]] -> [[Int]]
creerListe 0 _ direction plateau liste = reverse liste
creerListe 9 _ direction plateau liste = reverse liste
creerListe _ 0 direction plateau liste = reverse liste
creerListe _ 9 direction plateau liste = reverse liste
creerListe x y direction plateau liste
  | (elem (pion x y plateau) [N,B,V,A]) = creerListe (x + (iEme 1 direction)) (y + (iEme 2 direction)) direction plateau ([[x,y]] ++ liste)
  | otherwise							= reverse liste   
  
-- Teste une liste pour verifier si on trouve une suite de cases de la forme V - H* - A
-- Il prend en argument une couleur (celle du joueur qui est en train de jouer). Si oui, renvoie true 
testeListe :: Case -> [Case] -> Bool
testeListe couleur [] = False
testeListe couleur (x:xs)
  | xs == [] = False
  | (iEme 1 xs) == A || (iEme 1 xs) == V || (iEme 1 xs) == couleur		= False 
  | otherwise															= testeListe' couleur xs
    where
	  testeListe' couleur [_]	= False
	  testeListe' couleur (x:xs)
	    | (iEme 1 xs) == A || (iEme 1 xs) == V		= False
		| (iEme 1 xs) == couleur					= True
		| otherwise									= testeListe' couleur xs

-- Teste une case dans une direction specifique
testeCaseDirection :: Case -> [Int] -> Int -> Int -> [[Case]] -> Bool
testeCaseDirection couleur direction x y plateau
  | direction == [0,0]																	= False
  | testeListe couleur (listeCase plateau (creerListe x y direction plateau []) []) == True		= True
  | otherwise																			= False

-- Teste si une case est valide en etudiant les cases adjacentes dans les 8 directions  
testeCase :: Case -> Int -> Int -> [[Case]] -> Bool
testeCase couleur x y plateau = testeCaseAux couleur [-1,-1] x y plateau

testeCaseAux :: Case -> [Int] -> Int -> Int -> [[Case]] -> Bool
testeCaseAux couleur direction x y plateau
  | (iEme 1 direction) == 2											= False
  | (iEme 2 direction) == 2											= testeCaseAux couleur [(iEme 1 direction)+1,-1] x y plateau
  | (pion x y plateau) == V && testeCaseDirection couleur direction x y plateau == True		= True  
  | otherwise														= testeCaseAux couleur [(iEme 1 direction),(iEme 2 direction)+1] x y plateau


-- On aura besoin de la liste des coordonnees de cases marquees comme vide
listeCasesAdjacentes :: [[Case]] -> [[Int]]
listeCasesAdjacentes plateau = listeCasesAdjacentesAux plateau [1,1] []
  
listeCasesAdjacentesAux :: [[Case]] -> [Int] -> [[Int]] -> [[Int]]
listeCasesAdjacentesAux plateau [] liste = liste
listeCasesAdjacentesAux plateau position liste
 | iEme 1 position == 9
   = liste
 | iEme 2 position == 9
   = listeCasesAdjacentesAux plateau [iEme 1 position + 1,1] liste
 | (pion (iEme 1 position) (iEme 2 position) plateau) == V
   = listeCasesAdjacentesAux plateau [iEme 1 position, iEme 2 position + 1] [[iEme 1 position,iEme 2 position]]++liste
 | otherwise
   = listeCasesAdjacentesAux plateau [iEme 1 position, iEme 2 position + 1] liste
   
-- Etant donne une couleur et une position, fonction retournant la liste des coups admissibles
listeCoupsAdmissibles :: Case -> [[Case]] -> [[Int]]
listeCoupsAdmissibles couleur plateau = listeCoupsAdmissiblesAux couleur plateau (listeCasesAdjacentes plateau) []

listeCoupsAdmissiblesAux :: Case -> [[Case]] -> [[Int]] -> [[Int]] -> [[Int]]
listeCoupsAdmissiblesAux couleur plateau [] listeSolution = listeSolution
listeCoupsAdmissiblesAux couleur plateau (x:xs) listeSolution
  | (testeCase couleur (iEme 1 x) (iEme 2 x) plateau)	= listeCoupsAdmissiblesAux couleur plateau xs (x:listeSolution)
  | otherwise											= listeCoupsAdmissiblesAux couleur plateau xs listeSolution
  
question1 :: Case -> [[Case]] -> [[Int]]
question1 couleur plateau = listeCoupsAdmissibles couleur plateau
  
-- QUESTION 1.2

-- A partir d'une case on va parcourir les cases adjacentes dans les 8 directions
-- On cherche toujours des structures de la forme V - H* - A

-- Pour une couleur donnee, une direction donnee, une position donnee, un plateau donne, renvoit la liste des cases a modifier
casesAModifierDirection :: Case -> [Int] -> Int -> Int -> [[Case]] -> [[Int]] -> [[Int]]
casesAModifierDirection couleur direction x y plateau liste
  | direction == [0,0]		= []
  | otherwise				= casesAModifierDirectionAux couleur plateau (creerListe x y direction plateau liste) []

casesAModifierDirectionAux :: Case -> [[Case]] -> [[Int]] -> [[Int]] -> [[Int]]
casesAModifierDirectionAux couleur plateau [] liste = liste
casesAModifierDirectionAux couleur plateau [_] liste = liste
casesAModifierDirectionAux couleur plateau (x:xs) liste
  | pion (iEme 1 (iEme 1 xs)) (iEme 2 (iEme 1 xs)) plateau == V ||
    pion (iEme 1 (iEme 1 xs)) (iEme 2 (iEme 1 xs)) plateau == A ||
	pion (iEme 1 (iEme 1 xs)) (iEme 2 (iEme 1 xs)) plateau == couleur = liste
  |	otherwise 											= casesAModifierDirectionAux' couleur plateau xs (x:liste)
    where
	casesAModifierDirectionAux' couleur plateau [] liste = []
	casesAModifierDirectionAux' couleur plateau (x:xs) liste
	  | xs == [] && pion (iEme 1 x) (iEme 2 x) plateau == couleur	= liste
	  | xs == []													= []
	  | pion (iEme 1 x) (iEme 2 x) plateau == couleur				= liste
	  | pion (iEme 1 x) (iEme 2 x) plateau == V ||
	    pion (iEme 1 x) (iEme 2 x) plateau == A						= []
	  | otherwise													= casesAModifierDirectionAux' couleur plateau (xs) (x:liste)

-- Pour une case jouee donnee, donne la liste de toutes les cases a modifier
casesAModifier :: Case -> Int -> Int -> [[Case]] -> [[Int]]
casesAModifier couleur x y plateau = casesAModifierAux couleur x y plateau [] [] [-1,-1]

casesAModifierAux :: Case -> Int -> Int -> [[Case]] -> [[Int]] -> [[Int]] -> [Int] -> [[Int]]
casesAModifierAux couleur x y plateau liste1 liste2 direction
  | iEme 1 direction == 2			= liste2
  | iEme 2 direction == 2			= casesAModifierAux couleur x y plateau [] liste2 [(iEme 1 direction)+1,-1]
  | otherwise					 	= casesAModifierAux couleur x y plateau [] ((casesAModifierDirection couleur direction x y plateau liste1)++(liste2)) [(iEme 1 direction),(iEme 2 direction)+1]

changeLignePlateau :: Int -> Case -> Int -> [Case] -> [Case] -> [Case]
changeLignePlateau i couleur position [] tableau	= (reverse tableau)
changeLignePlateau i couleur position (x:xs) tableau
  | i == 9						= (reverse tableau)
  | i == position 				= changeLignePlateau (i+1) couleur position (xs) (couleur:tableau)
  | otherwise					= changeLignePlateau (i+1) couleur position (xs) (x:tableau)  

changePlateau :: Int -> Case -> [Int] -> [[Case]] -> [[Case]] -> [[Case]]  
changePlateau i couleur position [] tableau = reverse tableau
changePlateau i couleur position (x:xs) tableau
  | (i == 9) = reverse tableau
  | i == (iEme 2 position)								
	= changePlateau (i+1) couleur position xs ((changeLignePlateau 1 couleur (iEme 1 position) x []):tableau)  
  | otherwise						
	= changePlateau (i+1) couleur position xs (x:tableau)

question2 :: Int -> Int -> Case -> [[Case]] -> [[Case]]
question2 x y couleur tableau = question2Aux x y (casesAModifier couleur x y tableau) couleur tableau

question2Aux :: Int -> Int -> [[Int]] -> Case -> [[Case]] -> [[Case]]
question2Aux _ _ [] _ tableau					= tableau
question2Aux a b (x:xs) couleur tableau
  | (x:xs) == []								= tableau
  | otherwise									= question2Aux a b (xs) couleur (changePlateau 1 couleur x tableau [])

-- QUESTION 1.3
-- La fonction donne le score sous la forme [<score joueur noir>,<score joueur blanc>]

question3 :: [[Case]] -> [Int]
question3 plateau = question3Aux plateau [1,1] [0,0]

question3Aux :: [[Case]] -> [Int] -> [Int] -> [Int]
question3Aux plateau position score
  | iEme 1 position == 9									= score
  | iEme 2 position == 9									= question3Aux plateau [iEme 1 position+1,1] [iEme 1 score,iEme 2 score]
  | pion (iEme 1 position) (iEme 2 position) plateau == N	= question3Aux plateau [iEme 1 position,iEme 2 position+1] [iEme 1 score + 1,iEme 2 score]
  | pion (iEme 1 position) (iEme 2 position) plateau == B	= question3Aux plateau [iEme 1 position,iEme 2 position+1] [iEme 1 score,iEme 2 score + 1]
  | otherwise												= question3Aux plateau [iEme 1 position,iEme 2 position+1] [iEme 1 score,iEme 2 score]
 

 
-- QUESTION 1.4
-- Une partie est terminee quand plus aucun coup ne peut être joue, ni par le joueur 1 ni par le joueur 2

question4 :: [[Case]] -> Bool
question4 plateau
  | (listeCoupsAdmissibles N plateau == [])&&(listeCoupsAdmissibles B plateau == [])	= True
  | otherwise																			= False

-- QUESTION 1.5
-- Gere une partie entre deux joueurs humains

main = do putStrLn "\n+--------------------------+"
          putStrLn "| BIENVENUE AU JEU OTHELLO |"
          putStrLn "+--------------------------+\n"
          putStrLn "\nChoisissez un adversaire"
          putStrLn "\nTapez 'humain' pour le mode 2 joueurs"
          putStrLn "\nTapez 'ordinateur' pour le mode 1 joueur"
          mode <- getLine
          case mode of
            "humain" -> do play(N,plateauStart)
            "ordinateur" -> do playComputer(N,plateauStart)
            _ -> do putStrLn "\n\nENTRE NON VALIDE, RECOMMENCEZ VOTRE CHOIX"
                    main

aide() = do putStrLn "\n+------+"
            putStrLn "| AIDE |"
            putStrLn "+------+\n"
            putStrLn "Pour jouer, vous devez indiquer les coordonnees de la case ou vous souhaitez poser votre pion.\nLa premiere coordonnee correspond a l'abscisse, la deuxieme a l'ordonnee.\nL'origine se situe le plus en haut a gauche du plateau.\n\nExemple :\nLa case en haut a gauche du plateau a pour coordonnees [1,1].\nLa case en haut a droite du plateau a pour coordonnees [8,1]."		  
play(couleur,plateau) = do putStrLn ("\n"++affichePlateau(plateau))
                           if (question4 plateau == True) then endGame(plateau)
						     else if (couleur == N) then putStrLn "\nJoueur actif : NOIR"
							   else putStrLn "\nJoueur actif : BLANC"
                           if (question4 plateau == False)&&(listeCoupsAdmissibles couleur plateau == []) then do putStrLn "\nAUCUN COUP VALIDE. VOUS PASSEZ VOTRE TOUR"
                                                                                                                  if (couleur == N) then play(B,plateau)
                                                                                                                    else play(N,plateau)
                             else if (question4 plateau == False) then requireAbscisse(couleur,plateau) else putStrLn ""

endGame(plateau) = do putStrLn "\n+-----------------+"
                      putStrLn "| PARTIE TERMINEE |"
                      putStrLn "+-----------------+"
                      if ((iEme 1 (question3 plateau)) == (iEme 2 (question3 plateau))) then putStr "\nEgalite."
					    else if ((iEme 1 (question3 plateau)) > (iEme 2 (question3 plateau))) then putStr "\nLe joueur NOIR gagne." else putStr "Le joueur BLANC gagne"
                      putStrLn ("\n\nSCORE FINAL :\nJoueur NOIR : " ++ show (iEme 1 (question3 plateau)) ++ "\nJoueur BLANC : " ++ show (iEme 2 (question3 plateau)))
                      main

requireAbscisse(couleur,plateau) =
    do putStrLn "\nEntrez l'abscisse de la case que vous desirez jouer.\nTapez 'aide' pour plus d'informations et 'quitter' pour quitter le jeu."
       abscisse <- getLine
       case abscisse of
         "quitter" -> do endGame(plateau)
         "aide"    -> do aide()
                         requireAbscisse(couleur,plateau)
         _         -> if (member abscisse ["1","2","3","4","5","6","7","8"])
		              then requireOrdonnee(abscisse,couleur,plateau)
                      else requireAbscisse(couleur,plateau)

requireOrdonnee(abscisse,couleur,plateau) =
    do putStrLn "\nEntrez l'ordonnee de la case que vous desirez jouer.\nTapez 'aide' pour plus d'informations et 'quitter' pour quitter le jeu."
       ordonnee <- getLine
       case ordonnee of
         "quitter" -> do endGame(plateau)
         "aide"    -> do aide()
                         requireOrdonnee(abscisse,couleur,plateau)
         _         -> if (member ordonnee ["1","2","3","4","5","6","7","8"])
		              then resultat(abscisse,ordonnee,couleur,plateau)
                      else requireOrdonnee(abscisse,couleur,plateau)

resultat(abscisse,ordonnee,couleur,plateau) = if (testeCase couleur (read abscisse::Int) (read ordonnee::Int) plateau)
                                                then do putStrLn("\n\n\nVous posez votre pion.")
                                                        if couleur == N then play(B,(question2 (read abscisse::Int) (read ordonnee::Int) couleur plateau))
                                                          else play(N,(question2 (read abscisse::Int) (read ordonnee::Int) couleur plateau))
                                              else do putStrLn "\n\n\nATTENTION, CE COUP N'EST PAS VALIDE.\nRecommencez s'il vous plait."
                                                      play(couleur,plateau)
													  
-- QUESTION 1.6
-- Gere une partie entre un humain et l'ordinateur
bestMove :: Case -> [[Case]] -> [Int]
bestMove couleur plateau = bestMove' couleur 1 listeAll (listeCoupsAdmissibles couleur plateau)

bestMove' :: Case -> Int -> [[[Int]]] -> [[Int]] -> [Int]
bestMove' couleur i liste1 liste2 
  | i > 7											= []
  | (bestMoveAux 1 (iEme i liste1) liste2) /= []	= bestMoveAux 1 (iEme i liste1) liste2
  | otherwise										= (bestMove' couleur (i+1) liste1 liste2) 				

-- On considere deux liste
-- liste1 la liste des coups que l'on aimerait jouer en priorite
-- liste2 la liste des coups jouables (admissibles)
-- On cherche si l'un des elements de liste1 appartient a liste2

bestMoveAux :: Int -> [[Int]] -> [[Int]] -> [Int]
bestMoveAux i liste1 listeCoupsValides
  | i > length liste1							= []
  | member (iEme i liste1) listeCoupsValides	= iEme i liste1
  | otherwise 									= bestMoveAux (i+1) liste1 listeCoupsValides

playComputer(couleur,plateau) = do putStrLn ("\n"++affichePlateau(plateau))
                                   if (question4 plateau == True) then endGame(plateau)
						             else if (couleur == N) then putStrLn "\nJoueur actif : NOIR"
							           else resultatComputer((iEme 1 (bestMove B plateau)),(iEme 2 (bestMove B plateau)),couleur,plateau)
                                   if (question4 plateau == False)&&(listeCoupsAdmissibles couleur plateau == []) then do putStrLn "\nAUCUN COUP VALIDE. VOUS PASSEZ VOTRE TOUR"
                                                                                                                          if (couleur == N) then playComputer(B,plateau)
                                                                                                                            else playComputer(N,plateau)
                                     else if (question4 plateau == False) then requireAbscisseComputer(couleur,plateau) else putStrLn ""

resultatComputer(abscisse,ordonnee,couleur,plateau) = if (testeCase couleur abscisse ordonnee plateau)
                                                        then do putStrLn("\n\n\nVous posez votre pion.")
                                                                if couleur == N then playComputer(B,(question2 abscisse ordonnee couleur plateau))
                                                                  else playComputer(N,(question2 abscisse ordonnee couleur plateau))
                                                      else do putStrLn "\n\n\nATTENTION, CE COUP N'EST PAS VALIDE.\nRecommencez s'il vous plait."
                                                              playComputer(couleur,plateau)
													  
requireAbscisseComputer(couleur,plateau) =
    do putStrLn "\nEntrez l'abscisse de la case que vous desirez jouer.\nTapez 'aide' pour plus d'informations et 'quitter' pour quitter le jeu."
       abscisse <- getLine
       case abscisse of
         "quitter" -> do endGame(plateau)
         "aide"    -> do aide()
                         requireAbscisseComputer(couleur,plateau)
         _         -> if (member abscisse ["1","2","3","4","5","6","7","8"])
		              then requireOrdonneeComputer(abscisse,couleur,plateau)
                      else requireAbscisseComputer(couleur,plateau)

requireOrdonneeComputer(abscisse,couleur,plateau) =
    do putStrLn "\nEntrez l'ordonnee de la case que vous desirez jouer.\nTapez 'aide' pour plus d'informations et 'quitter' pour quitter le jeu."
       ordonnee <- getLine
       case ordonnee of
         "quitter" -> do endGame(plateau)
         "aide"    -> do aide()
                         requireOrdonneeComputer(abscisse,couleur,plateau)
         _         -> if (member ordonnee ["1","2","3","4","5","6","7","8"])
		              then resultatComputer(read abscisse::Int,read ordonnee::Int,couleur,plateau)
                      else requireOrdonneeComputer(abscisse,couleur,plateau)
					 
liste100 :: [[Int]]
liste100=[[1,1],[1,8],[8,1],[8,8]]

liste10 :: [[Int]]
liste10=[[1,3],[1,6],[3,1],[3,8],[6,1],[6,8],[8,3],[8,6]]

liste5 :: [[Int]]
liste5=[[1,4],[1,5],[4,1],[4,8],[5,1],[5,8],[8,4],[8,5]]


liste_1 :: [[Int]]
liste_1=[[3,3],[3,4],[3,5],[3,6],[4,3],[4,4],[4,5],[4,6],[5,3],[5,4],[5,5],[5,6],[6,3],[6,4],[6,5],[6,6]]

liste_2 :: [[Int]]
liste_2=[[2,3],[2,4],[2,5],[2,6],[3,2],[3,7],[4,2],[4,7],[5,2],[5,7],[6,2],[6,7],[7,3],[7,4],[7,5],[7,6]]

liste_20 :: [[Int]]
liste_20=[[1,2],[1,7],[2,1],[2,8],[7,1],[7,8],[8,2],[8,7]]

liste_50 :: [[Int]]
liste_50=[[2,2],[2,7],[7,2],[7,7]]

listeAll=[liste100,liste10,liste5,liste_1,liste_2,liste_20,liste_50]
