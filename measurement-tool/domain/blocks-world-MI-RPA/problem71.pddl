(define (problem blocks-35-0)
(:domain blocks)
(:objects
    I1
    H1
    G1
    F1
    E1
    D1
    C1
    B1
    A1
    Z
    Y
    X
    W
    V
    U
    T
    S
    R
    Q
    P
    O
    N
    M
    L
    K
    J
    I
    H
    G
    F
    E
    D
    C
    A
    B
 - block)
(:init
    (CLEAR A1 A1)
    (CLEAR F F)
    (CLEAR X X)
    (CLEAR I1 I1)
    (CLEAR H1 H1)
    (ONTABLE D D)
    (ONTABLE J J)
    (ONTABLE W W)
    (ONTABLE B1 B1)
    (ONTABLE G1 G1)
    (ON A1 A1 Q)
    (ON Q Q O)
    (ON O O Z)
    (ON Z Z D)
    (ON F F S)
    (ON S S B)
    (ON B B I)
    (ON I I R)
    (ON R R J)
    (ON X X U)
    (ON U U V)
    (ON V V C)
    (ON C C C1)
    (ON C1 C1 K)
    (ON K K E1)
    (ON E1 E1 H)
    (ON H H F1)
    (ON F1 F1 G)
    (ON G G P)
    (ON P P L)
    (ON L L N)
    (ON N N A)
    (ON A A T)
    (ON T T M)
    (ON M M D1)
    (ON D1 D1 W)
    (ON I1 I1 Y)
    (ON Y Y E)
    (ON E E B1)
    (ON H1 H1 G1)
    (HANDEMPTY)
)
(:goal (and
    (ON C1 C1 H)
    (ON H H F1)
    (ON F1 F1 P)
    (ON P P O)
    (ON O O N)
    (ON N N S)
    (ON S S L)
    (ON L L Q)
    (ON Q Q R)
    (ON R R B)
    (ON B B Z)
    (ON Z Z X)
    (ON X X G1)
    (ON G1 G1 H1)
    (ON H1 H1 M)
    (ON M M D1)
    (ON D1 D1 E)
    (ON E E G)
    (ON G G C)
    (ON C C F)
    (ON F F E1)
    (ON E1 E1 A)
    (ON A A I1)
    (ON I1 I1 A1)
    (ON A1 A1 I)
    (ON I I Y)
    (ON Y Y V)
    (ON V V J)
    (ON J J U)
    (ON U U W)
    (ON W W B1)
    (ON B1 B1 T)
    (ON T T D)
    (ON D D K)
)
)
)
