(define (problem blocks-20-0)
(:domain blocks)
(:objects
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
    (CLEAR S S)
    (CLEAR N N)
    (CLEAR P P)
    (ONTABLE H H)
    (ONTABLE N N)
    (ONTABLE K K)
    (ON S S C)
    (ON C C M)
    (ON M M Q)
    (ON Q Q B)
    (ON B B T)
    (ON T T J)
    (ON J J L)
    (ON L L E)
    (ON E E I)
    (ON I I O)
    (ON O O G)
    (ON G G F)
    (ON F F A)
    (ON A A D)
    (ON D D H)
    (ON P P R)
    (ON R R K)
    (HANDEMPTY)
)
(:goal (and
    (ON K K E)
    (ON E E N)
    (ON N N R)
    (ON R R D)
    (ON D D G)
    (ON G G H)
    (ON H H O)
    (ON O O A)
    (ON A A L)
    (ON L L J)
    (ON J J F)
    (ON F F M)
    (ON M M I)
    (ON I I Q)
    (ON Q Q B)
    (ON B B P)
    (ON P P T)
    (ON T T S)
    (ON S S C)
)
)
)
