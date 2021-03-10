NB.* LRAltWords.ijs: find words type by alternating left and right hands.

egLRAlt_usage_=: 0 : 0
   load '~Code/LRAltWords.ijs'
   ]nw=. #words=. words#~4 5 6 7 e.~#&>words=. <;._2 ] LF (] , [ #~ [ ~: [: {: ]) CR-.~fread BASEDSK,'\amisc\txt\LRalternatingHandsWordsBySize.txt'
   (]{~[:?~#) words{~((<.>:nw^.nn)$nw) #: nn=. (#;LRsets)#.x:(;LRsets) i. tolower 4 (] $~ [ >. [:#]) 'str'
)

NB.* LRsets: Left/right-hand sets of characters.
LRsets=: 'qwertasdfgzxcvb~`12345!@#$%';'yuiophjklnm67890-_=+^&*();:''",./<>?'

NB.* rmGt2Dupes: remove any word with more than 2 duplicates (triplicate etc.)
rmGt2Dupes=: ] #~ ([: -. [: +./ 2 *./\ 2 =/\ ])&>
NB.* rmAdjDupes: remove adjacent duplicate letters.
rmAdjDupes=: ] #~ [: -. # {. 2 =/\ ]
NB.* isAlternating: return 1 if Boolean alternates 1s and 0s, 0 otherwise.
isAlternating=: [: *./ 0 1 *./ .=&> ({.&> /:~ ])@:(] (# ; ] #~ [: -. [)~ 1 0 $~ #)
NB. First 4 are good, last 2 are bad:
NB.EG 1 1 1 1 0 0 -: isAlternating&>(1 0 1 0);(0 1 0 1);(1 0 1);(0 1 0);(0 1 1 0);(1 0 0 1)

NB.* extractWords: extract words from HTML file from
NB. http://www.manythings.org/vocabulary/lists/l/words.php?f=noll{n}
extractWords=: 3 : 0
   locStr=. '<div class="wrapco"><div class="co"><ul>'
   endStr=. '</ul></div><br />'
   flnms=. 0{"1 dir 'Top*.htm'
   fl=. fread y
   ss=. I. ((locStr E. ])+.endStr E. ]) fl
   len=. -~/ss+(#locStr),0
   words=. (len{.({.ss+#locStr)}.]) fl
   words=. '</li>',words,'<li>'
   ptnStr=. '</li><li>'
   words=. words rplc '</li></ul></div><div class="co"><ul><li>';ptnStr
   (#ptnStr)}.&.>}:(ptnStr E. words)<;.1 words
)

urlTemplate=: 'http://www.manythings.org/vocabulary/lists/l/words.php?f=noll{n}'
egExtracting=: 0 : 0
   nn=. 2 lead0s&.>>:i.15
   cmds=. (<'wget -O '),&.>(nn,~&.><'TopAmericanEnglish'),&.>(<'.htm '),&.>(<urlTemplate) rplc&.><"1 (<'{n}'),.nn
   >1{cmds
wget -O TopAmericanEnglish01.htm http://www.manythings.org/vocabulary/lists/l/words.php?f=noll01

   shell&.>cmds
   flnms=. 0{"1 dir 'Top*.htm'
   allww=. ;extractWords &.> flnms
   allww=. tolower&.>allww
   allww=. ,&.>allww          NB. Don't want single characters to be scalars.

   whAlt=. isAlternating&>(list=. <;._2 CR-.~fread 'wordsEn.txt') e.&.>{.LRsets
   new1s=. whAlt#list
)

egSetFromKeyword=: 0 : 0
   lraFlnm=. 'C:\amisc\txt\LRalternatingHandsWordsBySize.txt'
   $words=. <;._2 ] LF (] , [ #~ [ ~: [: {: ]) CR-.~fread lraFlnm
1273
   $words=. words#~4 5 6 e.~#&>words
927
   nw=. #words
   nn=. (#;LRsets)#.x:(;LRsets) i. tolower 'CIQDEV'
   ((<.>:nw^.nn)$nw) #: nn
14 313 855 449
   words{~((<.>:nw^.nn)$nw) #: nn
+----+----+------+-----+
|bock|tory|panama|diane|
+----+----+------+-----+
   #'B0ckT0ry$Panama'
15
   qts''
2018 7 30 8 59 47.5
)

egPasswordFromString=: 0 : 0
   str=. tolower 'McAfee AV'
   $LRwords=. }.<;._2 fread 'E:/amisc/txt/LRalternatingHandsWordsBySize.txt'
1272
   #selLR=. LRwords#~4 5 6 e.~ #&>LRwords
927
   ]nb=. (#selLR)^.(#;LRsets)#.(;LRsets) i. str
5.36205
   LRwords{~_4{.((>.nb)$#selLR)#:(#;LRsets)#.x:(;LRsets) i. str
+-----+-----+----+----+
|kaiak|yamen|prig|slam|
+-----+-----+----+----+
   LRwords{~((>.nb)$#selLR)#:(#;LRsets)#.x:(;LRsets) i. str
+----+------+-----+-----+----+----+
|auto|formal|kaiak|yamen|prig|slam|
+----+------+-----+-----+----+----+
)

3 : 0 ''
   smoutput egLRAlt_usage_
)

onlineDictionaries=: 0 : 0
https://www.collinsdictionary.com/dictionary/english/
https://www.thefreedictionary.com/
https://www.lexico.com/en/definition/
)

NB.* egAddFromNewList: example of adding from a new word list.
egAddFromNewList=. 0 : 0
   wl=. <;._2 ] LF (] , [ #~ [ ~: [: {: ]) CR-.~fread 'Unabr.dict'
   wl=. wl#~-.({.&>wl) e. 26{.'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'  NB. No initial caps
   wl=. wl#~*./&>wl e. &.><26}.Alpha_j_   NB. Only alphabetics
   wl=. wl#~4<:&>#&>wl   NB. Only 4 or more letters
   whAlt=. isAlternating&>(rmAdjDupes&.>wl) e.&.>{.LRsets  NB. Alternating except for duplicate adjacent letters
   wl=. whAlt#wl
   words=. <;._2 ] LF (] , [ #~ [ ~: [: {: ]) CR-.~fread BASEDSK,'\amisc\txt\LRalternatingHandsWordsBySize.txt'
   words=. words,wl-.words
   words=. /:~words
   words=. words/:#&>words
   words=. ~.words
   (;LF,~&.>words) fwrite BASEDSK,'\amisc\txt\LRalternatingHandsWordsBySize.txt'
)
