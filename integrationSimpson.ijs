NB.* integrationSimpson.ijs: numeric integration using Simpson's method: from
NB. http://www.byte.com/art/9509/img/505079a2.htm (Byte magazine article, 9/1995)

NB. form: verb simpson int
NB.   verb is the monadic function to be integrated.
NB.   int has 2 or 3 elements:
NB.     [0] lower bound of interval
NB.     [1] upper bound of interval
NB.     [2] number of subintervals (default 128)
NB. result is the integral
NB. e.g. 43.75 = ^&3 simpson ] 3 4
simpson=: 1 : 0
   'lower upper int'=. 3{.y,128
   size=. int%~upper-lower
   val=. u lower+size*i.>:int
   size*+/val*3%~1,1,~4 2$~<:int
)
