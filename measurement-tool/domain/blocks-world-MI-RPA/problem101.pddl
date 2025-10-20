(define (problem blocks-50-0)
(:domain blocks)
(:objects
    X1
    W1
    V1
    U1
    T1
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
    (CLEAR H H)
    (CLEAR O O)
    (CLEAR H1 H1)
    (CLEAR S1 S1)
    (CLEAR E E)
    (CLEAR X X)
    (ONTABLE P P)
    (ONTABLE V V)
    (ONTABLE I I)
    (ONTABLE K1 K1)
    (ONTABLE J1 J1)
    (ONTABLE X X)
    (ON H H O1)
    (ON O1 O1 U)
    (ON U U P)
    (ON O O C1)
    (ON C1 C1 N1)
    (ON N1 N1 W)
    (ON W W L)
    (ON L L T1)
    (ON T1 T1 N)
    (ON N N F1)
    (ON F1 F1 T)
    (ON T T Q1)
    (ON Q1 Q1 C)
    (ON C C P1)
    (ON P1 P1 B1)
    (ON B1 B1 A1)
    (ON A1 A1 A)
    (ON A A R1)
    (ON R1 R1 D1)
    (ON D1 D1 V)
    (ON H1 H1 M1)
    (ON M1 M1 J)
    (ON J J Q)
    (ON Q Q M)
    (ON M M U1)
    (ON U1 U1 Y)
    (ON Y Y E1)
    (ON E1 E1 X1)
    (ON X1 X1 G1)
    (ON G1 G1 I)
    (ON S1 S1 Z)
    (ON Z Z W1)
    (ON W1 W1 I1)
    (ON I1 I1 L1)
    (ON L1 L1 K)
    (ON K K F)
    (ON F F R)
    (ON R R V1)
    (ON V1 V1 D)
    (ON D D G)
    (ON G G B)
    (ON B B K1)
    (ON E E S)
    (ON S S J1)
    (HANDEMPTY)
)
(:goal (and
    (ON L1 L1 Q)
    (ON Q Q G)
    (ON G G K1)
    (ON K1 K1 W1)
    (ON W1 W1 T)
    (ON T T A1)
    (ON A1 A1 J1)
    (ON J1 J1 C)
    (ON C C E)
    (ON E E S1)
    (ON S1 S1 R1)
    (ON R1 R1 Q1)
    (ON Q1 Q1 S)
    (ON S S H)
    (ON H H G1)
    (ON G1 G1 M)
    (ON M M N1)
    (ON N1 N1 B)
    (ON B B P1)
    (ON P1 P1 N)
    (ON N N L)
    (ON L L B1)
    (ON B1 B1 J)
    (ON J J V1)
    (ON V1 V1 T1)
    (ON T1 T1 D1)
    (ON D1 D1 I)
    (ON I I H1)
    (ON H1 H1 P)
    (ON P P F1)
    (ON F1 F1 U1)
    (ON U1 U1 O)
    (ON O O X)
    (ON X X K)
    (ON K K Y)
    (ON Y Y C1)
    (ON C1 C1 M1)
    (ON M1 M1 A)
    (ON A A V)
    (ON V V U)
    (ON U U I1)
    (ON I1 I1 R)
    (ON R R O1)
    (ON O1 O1 E1)
    (ON E1 E1 D)
    (ON D D W)
    (ON W W F)
    (ON F F X1)
    (ON X1 X1 Z)
)
)
)
