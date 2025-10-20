(define (problem blocks-45-0)
(:domain blocks)
(:objects
    S1
    R1
    Q1
    P1
    O1
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
    (CLEAR G1 G1)
    (CLEAR P1 P1)
    (ONTABLE R R)
    (ONTABLE K1 K1)
    (ON G1 G1 H)
    (ON H H M1)
    (ON M1 M1 J1)
    (ON J1 J1 A)
    (ON A A E1)
    (ON E1 E1 J)
    (ON J J X)
    (ON X X I)
    (ON I I A1)
    (ON A1 A1 R)
    (ON P1 P1 C1)
    (ON C1 C1 G)
    (ON G G C)
    (ON C C Y)
    (ON Y Y E)
    (ON E E W)
    (ON W W Z)
    (ON Z Z H1)
    (ON H1 H1 M)
    (ON M M Q)
    (ON Q Q U)
    (ON U U K)
    (ON K K D)
    (ON D D N)
    (ON N N T)
    (ON T T S)
    (ON S S B)
    (ON B B S1)
    (ON S1 S1 L)
    (ON L L N1)
    (ON N1 N1 V)
    (ON V V B1)
    (ON B1 B1 F1)
    (ON F1 F1 F)
    (ON F F L1)
    (ON L1 L1 I1)
    (ON I1 I1 Q1)
    (ON Q1 Q1 O)
    (ON O O R1)
    (ON R1 R1 P)
    (ON P P O1)
    (ON O1 O1 D1)
    (ON D1 D1 K1)
    (HANDEMPTY)
)
(:goal (and
    (ON W W P)
    (ON P P Q)
    (ON Q Q R1)
    (ON R1 R1 H1)
    (ON H1 H1 S)
    (ON S S Q1)
    (ON Q1 Q1 A1)
    (ON A1 A1 J1)
    (ON J1 J1 V)
    (ON V V G)
    (ON G G K1)
    (ON K1 K1 D)
    (ON D D M)
    (ON M M E)
    (ON E E A)
    (ON A A D1)
    (ON D1 D1 F)
    (ON F F G1)
    (ON G1 G1 P1)
    (ON P1 P1 C)
    (ON C C F1)
    (ON F1 F1 Y)
    (ON Y Y L)
    (ON L L M1)
    (ON M1 M1 E1)
    (ON E1 E1 B)
    (ON B B L1)
    (ON L1 L1 O)
    (ON O O Z)
    (ON Z Z H)
    (ON H H X)
    (ON X X K)
    (ON K K R)
    (ON R R T)
    (ON T T I)
    (ON I I C1)
    (ON C1 C1 S1)
    (ON S1 S1 O1)
    (ON O1 O1 U)
    (ON U U J)
    (ON J J B1)
    (ON B1 B1 N1)
    (ON N1 N1 N)
    (ON N N I1)
)
)
)
