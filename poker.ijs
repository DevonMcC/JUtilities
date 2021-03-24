NB.* poker.ijs: functions to run poker simulations.

PKRDIR=: '\amisc\work\AgentBasedSimulation\'
load 'stats plot mystats WS'

RANK=: (]&.>'23456789'),'10';'J';'Q';'K';'A'
SUIT=: 'CDHS'

groupedHands=: 3 : 0
   assert. HRi-:/:~HRi
   np=. +/ptn=. 1,2~:/\HRi                   NB. Partition by signifcant diffs.
   p3=. possHandDist&.>12 25;14 40;27 39     NB. 3 possibs: AC,AD; 3D,3S; 3H,2S
   hd3=. >+/&.>>(<ptn)<;.1&.>p3
   xphd3=. >(<"1 hd3)#&.><i.np
)

NB.* getPokerVars: get poker variables from file.
getPokerVars=: 3 : 0
   vnms=. <`] @. (0~:L.) y   NB. Enclosed name(s) of variable(s)
   if. 0=#y do.
       vnms=. 'RANK';'SUIT';'HRi';'RH5i';'SZ';'HANDTYPE';'RH5'
   end.
   rr=. ;{.&>(<PKRDIR) unfileVar_WS_&.>vnms
   if. +./rr do. smoutput 'Created: ','.',~e2l vnms#~rr end.
   if. 0 e. rr do. smoutput 'NOT created: ','.',~e2l vnms#~-.rr end.
   vnms#~rr
NB. RH5=: a. i. CHORDH5   NB. all 5-card Hands in ascending order.
NB. SZ=: #RH5
)

NB.* buildHR: build hands ranking mat: 0{hand type (0-8); 1{sub-type.
buildHR=: 3 : 0
   npnt=. 2 9$1020 384 144 64 1020 4 24 4 4 1277 2860 858 858 10 1277 156 156 10
   HR=. ((*/npnt)#i.9),:;(0{npnt)#&.>i.&.>1{npnt
)

whmax0col=: ((=>./)@([:;0&{"1))    NB. Where are all = highest # in col0.

tallyMany=: 3 : 0
   'ndp ng'=. y   NB. Number of different players, number of games with each number of players.
   wins=: 0 2$a:
   for_np. ndp do. 'tt pp wins1M'=: tallyWinningHands np,ng
       wins=: wins,np;wins1M
   end.
   wins
)

tallyWinningHands=: 3 : 0
   'np ng'=. y               NB. Number of players, number of games
   winner=. 0 0$0
   while. _1<ng=. <:ng do.
       best=. play1FullGame np
       whmax=. whmax0col best                NB. Narrow to best hand type ties.
       rating=. rateHandI"1 >whmax#1{"1 best
       whr=. \:rating                        NB. Rate ties with tie-breaking
       't b'=. (split whr){&.><rating        NB.  sub-type->Top 1 & Bottoms.
       istie=. t e. b                        NB. Check if any tied with top.
       ww=. whr#~1,t*./ . =|:b               NB. Where ties are in best hands.
       bix=. ww{I. whmax                    NB. Where ties are in all hands.
       hc=. bix{HANDS                        NB. Hole cards,
       fr=. rating{~ww                       NB.  final hand rating,
NB.       fh=. >1{"1 best{~bix                  NB.  final hand value,
NB.       winner=. winner,hc,.fr,.fh,.istie     NB.  is tie or not.
       winner=. winner,hc,.fr,.istie         NB.  is tie or not.
   end.
NB.   ptn=. 1 0 1 0 1 0 0 0 0 1
NB.   tit=. 'Hole';'Type';'Hand';'Tie'
   ptn=. 1 0 1 0 1
   tit=. 'Hole';'Type';'Tie'
   tit;ptn;winner
NB.EG 'titles ptn winner'=. tallyWinningHands 5 1000
)

play1FullGame=: 3 : 0
   np=. y                         NB. Number of players per game
   DECK=: 52?52
   maxp=. <.-:5-~#DECK
   if. np<1 do. np=. maxp end.     NB. Default to max possible if np<1
   assert. np<maxp
   HANDS=: |:(2,np)$DECK
   COMMON=: _5{.DECK
   ixs=. 3 4 AllCombos&.>5
   fillout=. ixs{&.><COMMON
   best=. fillout findBestPoss"1 HANDS
)

makeAll2Combo5=: 3 : 0
   'apc h2'=. y              NB. All possible 3-cards combos; 4-card combos.
   allposs=. h2,"1 >0{apc     NB. Combine w/all 3-card combos->5 card hands
   allposs=. allposs,,/h2 ,"(0 1)/>1{apc     NB. w/all 4-card->5 card hands
)

findBestPoss2=: 4 : 0
   whb=. 0{\:ratings=. rateHandI"1 ap=. makeAll2Combo5 x;y
   whb{&.>ratings;<ap
)

findBestPoss=: 4 : 0
NB.* findBestPoss: find best possible combination of 2 card hand+all poss.
NB. combos of common cards.
   allposs=. makeAll2Combo5 x;y
   best=. bestHand"1 allposs  NB. Best of each possibility
   top=. >./best
   whbest=. allposs#~best=top
   best=. whbest{~(i.>./)rankWithinHandtype whbest
   top;best                   NB. Best handtype overall and which hand
)

strictord=: 3 : '(/:|:|.suitRank y){y'
rateHandI=: 3 : '0 2861#:HRi{~RH5i i. 52#.strictord y'
rateHand=: 3 : 'HANDRATED{~"1 RH5 i. strictord y'
bestHand=: 3 : 0
   if. isNothing y do. 0 return. end.
   if. isPair y do. 1 return. end.
   if. is2Pair y do. 2 return. end.
   if. is3ok y do. 3 return. end.
   if. isOnlyStraight y do. 4 return. end.
   if. isOnlyFlush y do. 5 return. end.
   if. isFullHouse y do. 6 return. end.
   if. is4ok y do. 7 return. end.
   if. isStraightFlush y do. 8 return. end.
   _1
)

lookAtSomeRanks=: 3 : 0
   allhigh2=. ~.,(,&.>/)~i.52
   allhigh2=. /:~allhigh2
   allhigh2=. allhigh2#~;~:/&.>allhigh2
   allhigh2=. 52 51$allhigh2
   aa=. >handRank01&.>5{."(1)13 14 15 16 17{allhigh2
   aa;<allhigh2     NB. "aa" should be symmetric.
)

handRank01=: 3 : 0
   mean EQHANDRANK#~possHandDist y
)

possHandDist=: 3 : 0"1
NB.* possHandDist: distribution of possibilities for a partial hand.
NB.   myc=. 0{"1 HANDS   NB. e.g. 13 28 37
   whmine=. (#y)=(|:RH5) +/ . e. y
NB.   plot whmine*%+/whmine
NB.   pd 'save \GTAAP\distAfter2cards.wmf 1900 1400'
NB.   max=. SZ%~SZ-4   NB. This is max rank because 4 hands tie for highest.
)

showCards=: 3 : 0"1
NB.* showCards: show char version of cards (e.g. 'AD';'10S') or vice
NB.* versa if not numeric.
   if. isNum y do.                                    NB. Num->char
       if. 2~:#$y do. y=. suitRank y end.
       (RANK{~1{y),&.>SUIT{~0{y
   else. (SUIT i. ;{:&.>y),:(,&.>RANK) i. }:&.>y     NB. char->num
   end.
NB.EG showCards 3 7 20 34 24
NB.EG showCards '5C';'9C';'9D';'10H';'KD'    NB. 5 Clubs, 9 Clubs, etc.
)

showWhichHand=: 3 : 0
   hh=. showCards y{ORDH5
   hs=. y{"1 HANDRATED
   hh=. hh,(HANDTYPE{~0{hs),<1{hs
)

rankAllHands=: 3 : 0
NB.* rankAllHands: rank all hands by type of hand and within type.
   'whall h5'=. y
   whall=. |:whall
   allranks=. (2,#h5)$_1
   for_hctr. i.#whall do.
       ht=. hctr{whall
       subrank=. rankWithinHandtype ht#h5
NB. Row 0 is hand type; 1 is rank within type
       allranks=. ((ht*hctr)+(-.ht)*0{allranks) 0}allranks
       allranks=. (ht}(1{allranks),:(ht exp subrank)) 1}allranks
   end.
NB. Fix wheels: zero-out subtype rank of straights and straight flushes
NB. that are wheels (A-5) so they rate lower than 6-highs.
   as=. 13*i.4                NB. All suits
   whs=. (0{allranks)e. 4 8   NB. Straights and straight-flushes
   whsa=. whs*.((0{"1 h5)e. as)*.(4{"1 h5)e.12+as NB. with a 2 and an Ace
   allranks=. ((-.whsa)*1{allranks) 1}allranks    NB. Make these subtype 0
NB. since this is lowest straight because the one case where Ace=1.
)

rankWithinHandtype=: 3 : 0
   hrnk=. 1{1 0 2|:suitRank"1 y
NB. "hr" is ,2 col. mat: col. 0 is count (how many dupes), col. 1 is card;
NB. so hand is rated by value of which card has most duplicates, value of
NB. which card has 2nd most dupes, etc.
   hr=. (,@\:~@|:@(~.,:~((+/@|:)@=)))"(1) hrnk
   gv=. /:hr
   whdif=. 1,2(+./ . ~:)/\gv{hrnk
   subrank=. (/:gv){+/\whdif
)

rankWithinNothing=: 3 : 0
NB.* rankWithinNothing: assign rank number for nothing hand.
   nothings=. whno#h5
   rn=. suitRank"1 nothings{~/:nothings
   rn=. 1{1 0 2|:rn
   gv=. /:|."1 rn
   whdif=. 2(+./ . ~:)/\gv{rn
   subrank=. (/:gv){+/\1,whdif
   allranks=. (2,#h5)$_1
NB. Row 0 is hand type; 1 is rank within type
   allranks=. ((0*whno)+(-.whno)*0{allranks) 0}allranks
   allranks=. (whno}(1{allranks),:(whno exp subrank)) 1}allranks
)

NB. 6!:2 'whall=. (isNothing"1 h5),.(isPair"1 h5),.(is2Pair"1 h5),.(is3ok"1 h5),.(isOnlyStraight"1 h5),.(isOnlyFlush"1 h5),.(isFullHouse"1 h5),.(is4ok"1 h5),.isStraightFlush"1 h5'

isNothing=: 3 : 0
   if. 2~:#$y do. y=. suitRank y end.
   'suit rank'=. /:~&.><"1 y
NB. >1 suit,    and    no duplicates,
   rc=. (1~:#~.suit)*.(#rank)=#~.rank
NB. and >1 apart, including special case of low Ace.
   rc=. rc*.-.(*./ 1=2-~/\rank)+.*./ 1=2-~/\/:~(rank=12)}rank,:_1
)

isAnyFlush=: 3 : 0
   if. 2~:#$y do. y=. suitRank y end.
   *./2=/\0{y
)

isOnlyFlush=: 3 : 0
   if. 2~:#$y do. y=. suitRank y end.
   (isAnyFlush y)*.-.isAnyStraight y       NB. Not straight flush
)

isAnyStraight=: 3 : 0
   if. 2~:#$y do. y=. suitRank y end.
   rc=. *./_1 =2-/\/:~rnk=. 1{y
   if. 12 e. rnk do.
       rc=. rc +. *./ _1=2-/\/:~(rnk=12)}rnk,:_1
   end.
   rc
)

isOnlyStraight=: 3 : 0
   if. 2~:#$y do. y=. suitRank y end.
   (isAnyStraight y)*.-.isAnyFlush y       NB. Not straight flush
)

isPair=: 3 : 0
   if. 2~:#$y do. y=. suitRank y end.
NB.   1=+/2=/\/:~1{y
   1 1 1 2-:/:~;#&.>(1,2~:/\/:~rnk)<;.1 rnk=. 1{y
)

is2Pair=: 3 : 0
   if. 2~:#$y do. y=. suitRank y end.
NB.   2=#~.rnk#~0,~2=/\rnk=. /:~1{y
   1 2 2-:/:~;#&.>(1,2~:/\/:~rnk)<;.1 rnk=. 1{y
)

is3ok=: 3 : 0
   if. 2~:#$y do. y=. suitRank y end.
   1 1 3-:/:~;#&.>(1,2~:/\/:~rnk)<;.1 rnk=. 1{y
)

isFullHouse=: 3 : 0
   if. 2~:#$y do. y=. suitRank y end.
NB.   0 1 1 1-:/:~2=/\/:~1{y
   2 3-:/:~;#&.>(1,2~:/\/:~rnk)<;.1 rnk=. 1{y
)

is4ok=: 3 : 0
   if. 2~:#$y do. y=. suitRank y end.
   1 4-:/:~;#&.>(1,2~:/\/:~rnk)<;.1 rnk=. 1{y
)

isStraightFlush=: 3 : 0
   if. 2~:#$y do. y=. suitRank y end.
   (isAnyFlush y)*.isAnyStraight y         NB. Is straight and flush.
)

NB.* isnSF: is n-card straight flush?
isnSF=: ([: +./ [ (([ = [: # ]) *. [: isAnyStraight ])&> [: </./ [: suitRank ])"(0 1)
NB.EG 1 1 0 -: 5 isnSF 0 1 2 3 4 17,0 1 2 3 12 17,:0 1 2 3 6 17

NB. suitRank=: |:@((4 13)&#:)
suitRank=: 3 : 0
NB.* suitRank: convert nums: 2 rows: suit, rank or 2 rows->nums 0-51.
   if. 2=#$y do.
       13#.|:y
   else.
       |:@((4 13)&#:)y
   end.
)

tallyPairs=: 3 : 0
   'hpi ni'=. y              NB. Hands per iteration, Number of iterations
   cts=. ni$0
   for_ii. i.ni do.
       hands=. >/:~&.>13|&.>5?&.>hpi$52
       cts=. (+/1=+/"1(}."1 hands)=}:"1 hands) ii}cts
   end.
   cts
)

NB.* initPokerVars: initialize poker variables from scratch.
initPokerVars=: 3 : 0
   h5=: 5 AllCombos 52
   h5=: h5{"1~/:"(1) 13|h5      NB. Order each hand by card rank.
   6!:2 'whall=. (isNothing"1 h5),.(isPair"1 h5),.(is2Pair"1 h5),.(is3ok"1 h5),.(isOnlyStraight"1 h5),.(isOnlyFlush"1 h5),.(isFullHouse"1 h5),.(is4ok"1 h5),.isStraightFlush"1 h5'

   HANDRANKS=: rankAllHands whall;<h5
   HANDGV=: /:|:HANDRANKS
   RH5=: HANDGV{h5       NB. 2598960 5-:$RH5 NB. Hands in rated order least to best.
   CHORDH5=: RH5{a.
   HANDRATED=: HANDGV{&.|:HANDRANKS       NB. HANDRATED: 0{Major type #, 1{minor type #
assert. HANDRATED -: /:~&.|:HANDRANKS
   HandTypes=: ('#';'Name'),(<"0 i.9),.'nothing';'pair';'2-pair';'3-of-a-kind';'straight';'flush';'full house';'4-of-a-kind';'straight flush'
   equihand=. -.*./"(1) 0,2=/\|:HANDRATED
   EQUIRANK=: +/\equihand
   lens=. 2-~/\I. equihand,1
   EQHANDRANK=: lens#I. equihand
   'RH5';'HANDRANKS';'HANDGV';'CHORDH5';'HANDRATED';'EQUIRANK';'EQHANDRANK'
)

exp=: #^:_1

3 : 0 ''
   if. fexist 'RH5.DAT' do.
       pvars=. 'RANK';'SUIT';'HANDRATED';'RH5'
       ;0{&>(<1!:43 '')unfileVar_WS_ &.>pvars
   else. initPokerVars '' end.
)

egs=: 0 : 0
   showCards"1 (5$52)#:_3{.RH5i  NB. Ranked hands as base-52 integer vector.
+---+--+--+--+--+
|10D|JD|QD|KD|AD|
+---+--+--+--+--+
|10H|JH|QH|KH|AH|
+---+--+--+--+--+
|10S|JS|QS|KS|AS|
+---+--+--+--+--+
   showCards"1 (5$52)#:3{.RH5i  NB. 3 lowest hands
+--+--+--+--+--+
|2C|3C|4C|5C|7D|
+--+--+--+--+--+
|2C|3C|4C|5C|7H|
+--+--+--+--+--+
|2C|3C|4C|5C|7S|
+--+--+--+--+--+
   2 5{.HANDRATED      NB. 5 lowest rated hands: subtype 1 nothings
0 0 0 0 0
1 1 1 1 1
   2 _5{.HANDRATED     NB. 5 highest hands: straight flushes, subtypes 9 & 10.
8  8  8  8  8
9 10 10 10 10
   3 3$HANDTYPE        NB. 0{HANDRATED indexes into HANDTYPE
+-----------+-----------+--------------+
|nothing    |pair       |2-pair        |
+-----------+-----------+--------------+
|3-of-a-kind|straight   |flush         |
+-----------+-----------+--------------+
|full house |4-of-a-kind|straight flush|
+-----------+-----------+--------------+
   $~.|:HANDRATED      NB. Number of distinct hand type, subtypes
7464 2
   >./|:HANDRATED
8 2860
   0 2861#:_5{.HRi     NB. Int vec version of HANDRATED: same relative ranking
8  8
8 10
8 10
8 10
8 10

   $HR=: |:0 2861#: HRi
2 2598960
   +/htp=. 1,2~:/\0{HR                  NB. Hand-type partition
9
   ]nht=. ;$&.>htp<;.(1)1{HR            NB. number of each hand type
1302540 1098240 123552 54912 10200 5108 3744 624 40
   ]npt=. ;($@~.)&.>htp<;.(1) 1{HR      NB. number subtypes per hand type
1277 2860 858 858 10 1277 156 156 10
   pcts=. 100*&.>1E_7 roundNums pht,.(+/\pht=. nht%+/nht),.|.+/\(|.nht)%+/nht
   pcts=. pcts,.]&.>0.1 roundNums %pht
   htstats=. HANDTYPE,.]&.>nht,.npt,.>pcts
   tit=. 'Hand Type';'# Type';'# Sub-type';'% Type';'Cum. %';'Rev. Cum. %';'Type/Hands'
   tots=. ('Total';]&.>+/>_3}."1}."1 htstats),3$<' - '
   tit,htstats,tots
+--------------+-------+----------+--------+--------+-----------+----------+
|Hand Type     |# Type |# Sub-type|% Type  |Cum. %  |Rev. Cum. %|Type/Hands|
+--------------+-------+----------+--------+--------+-----------+----------+
|nothing       |1302540|1277      |50.11774|50.11774|100        |2         |
+--------------+-------+----------+--------+--------+-----------+----------+
|pair          |1098240|2860      |42.2569 |92.37464|49.88226   |2.4       |
+--------------+-------+----------+--------+--------+-----------+----------+
|2-pair        |123552 |858       |4.7539  |97.12854|7.62536    |21        |
+--------------+-------+----------+--------+--------+-----------+----------+
|3-of-a-kind   |54912  |858       |2.11285 |99.24139|2.87146    |47.3      |
+--------------+-------+----------+--------+--------+-----------+----------+
|straight      |10200  |10        |0.39246 |99.63385|0.75861    |254.8     |
+--------------+-------+----------+--------+--------+-----------+----------+
|flush         |5108   |1277      |0.19654 |99.83039|0.36615    |508.8     |
+--------------+-------+----------+--------+--------+-----------+----------+
|full house    |3744   |156       |0.14406 |99.97445|0.16961    |694.2     |
+--------------+-------+----------+--------+--------+-----------+----------+
|4-of-a-kind   |624    |156       |0.02401 |99.99846|0.02555    |4165      |
+--------------+-------+----------+--------+--------+-----------+----------+
|straight flush|40     |10        |0.00154 |100     |0.00154    |64974     |
+--------------+-------+----------+--------+--------+-----------+----------+
|Total         |2598960|7462      |100     | -      | -         | -        |
+--------------+-------+----------+--------+--------+-----------+----------+
)
