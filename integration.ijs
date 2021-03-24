NB.* integration.ijs: different methods for numerical integration of functions.

Simpson=: 1 : 0
  128 u Simpson y
:
  x =. >.&.-: x  NB. ensure x is even
  h =. - y -/ . * % x
  (h*+/(1,((x-1)$4 2),1)*u every ({.y)+h*i.x+1)%3
)

NB.* adapt: a development of the Simpson method which subdivides
NB. the range of integration in two at each step, and carries on
NB. applying Simpson integration recursively in each half until
NB. the required level of approximation specified in the left
NB. argument is attained.
adapt=: 1 : 0
:
  r =. 4 u Simpson y
  if. x > | r - 2 u Simpson y do.
    return.
  else.
    m =. 0 1 |. each y , each -: +/ y
    +/ (x u adapt {.&> m) , x u adapt {:&>m
  end.
)

NB.* Romberg: uses series expansions for the error terms in
NB. Simpson approximation and applies corrections to progressively
NB. more refined Simpson estimates. The process is too complicated
NB. to describe in succinct comments, but can be found in most
NB. elementary texts on Numerical Analysis.

romb=: 1 : 0
:
  r=. > (2 ^ 1 + i. x) u Simpson every < y
  while. 1 < # r do.
    r=. }. r + (_1 + 2 ^ 4 * 2 + x - # r) %~ r - _1 |. r
  end.
)

Romberg=: 1 : 0
:
  t=. (i=. 1) u romb y
  while. x < | t - r=. (i=. >: i) u romb y do.
    t=. r
  end.
)
