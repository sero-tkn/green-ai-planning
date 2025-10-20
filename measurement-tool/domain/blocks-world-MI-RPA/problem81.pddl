(define (problem blocks-40-0)
(:domain blocks)
(:objects
    N1
    M1
    L1
    K1
    J1
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
    (CLEAR D D)
    (CLEAR O O)
    (CLEAR C C)
    (CLEAR T T)
    (CLEAR M M)
    (CLEAR H H)
    (ONTABLE D D)
    (ONTABLE W W)
    (ONTABLE N N)
    (ONTABLE T T)
    (ONTABLE M M)
    (ONTABLE H H)
    (ON O O J1)
    (ON J1 J1 H1)
    (ON H1 H1 A)
    (ON A A M1)
    (ON M1 M1 J)
    (ON J J G1)
    (ON G1 G1 I1)
    (ON I1 I1 Q)
    (ON Q Q B)
    (ON B B P)
    (ON P P L)
    (ON L L V)
    (ON V V F1)
    (ON F1 F1 Y)
    (ON Y Y K1)
    (ON K1 K1 N1)
    (ON N1 N1 D1)
    (ON D1 D1 Z)
    (ON Z Z X)
    (ON X X S)
    (ON S S E)
    (ON E E C1)
    (ON C1 C1 R)
    (ON R R U)
    (ON U U K)
    (ON K K E1)
    (ON E1 E1 B1)
    (ON B1 B1 G)
    (ON G G W)
    (ON C C A1)
    (ON A1 A1 F)
    (ON F F I)
    (ON I I L1)
    (ON L1 L1 N)
    (HANDEMPTY)
)
(:goal (and
    (ON A A B1)
    (ON B1 B1 S)
    (ON S S I1)
    (ON I1 I1 A1)
    (ON A1 A1 Y)
    (ON Y Y R)
    (ON R R K)
    (ON K K J1)
    (ON J1 J1 D)
    (ON D D N)
    (ON N N F)
    (ON F F G)
    (ON G G E)
    (ON E E N1)
    (ON N1 N1 T)
    (ON T T U)
    (ON U U C)
    (ON C C L1)
    (ON L1 L1 D1)
    (ON D1 D1 P)
    (ON P P V)
    (ON V V Q)
    (ON Q Q M1)
    (ON M1 M1 H)
    (ON H H K1)
    (ON K1 K1 E1)
    (ON E1 E1 W)
    (ON W W F1)
    (ON F1 F1 O)
    (ON O O J)
    (ON J J Z)
    (ON Z Z C1)
    (ON C1 C1 M)
    (ON M M X)
    (ON X X L)
    (ON L L H1)
    (ON H1 H1 B)
    (ON B B I)
    (ON I I G1)
)
)
)
