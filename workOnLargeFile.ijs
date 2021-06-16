NB.* workOnLargeFile.ijs: apply arbitrary verb across large file in blocks.

NB.* searchFor: search for target string (uppercased) in piece of large file.
NB.* doSomethingSimple: apply verb to file making minimal assumptions about file structure.
NB.* doSomething: apply verb to sequential blocks of file - assuming field-delimited file - by whole lines.
NB.* getFirstLine: get 1st line of tab-delimited file, along w/info to apply this repeatedly to get subsequent lines.
NB.* MDY2ymdNum: 'mm/dd/yyyy' -> yyyymmdd

NB.* searchFor: search for target string (uppercased) in piece of large file.
searchFor=: 3 : 0
   'src ltlb'=. y  NB. Source to search; locations found, target string to find, 
   'locs targstr leftover bn'=. ltlb NB. leftover from previous, base number.
   locs=. locs,bn+(I. targstr E. toupper leftover,src)-#leftover
   bn=. bn+#src [ leftover=. src{.~-<:#targstr
   locs;targstr;leftover;bn
NB.EG searchFor doSomethingSimple ^:_ ] 0x;127275;(fsize 'mysql150410.sql');'mysql150410.sql';<'';'DISABLE KEYS';'';0
)

NB.* doSomethingSimple: apply verb to file making minimal assumptions about
NB. file structure.
doSomethingSimple=: 1 : 0
   'curptr chsz max flnm passedOn'=. 5{.y
   if. curptr>:max do. ch=. curptr;chsz;max;flnm
   else. ch=. readChunk curptr;chsz;max;flnm
       passedOn=. u (_1{ch),<passedOn  NB. Allow u's work to be passed on to next invocation
   end.
   (4{.ch),<passedOn
NB.EG ([:~.;) doSomethingSimple ^:_ ] 0x;1e6;(fsize 'bigFile.txt');'bigFile.txt';<'' NB. Return unique characters in file.
)

NB.* doSomething: apply verb to sequential blocks of file - assuming
NB. field-delimited file - by whole lines.  Args: file current location
NB. pointer, # bytes in each chunk read, size and name of file, [any
NB. partial chunk from previous call, file header, result of previous
NB. call to be passed on to next one].
doSomething=: 1 : 0
   'curptr chsz max flnm leftover hdr passedOn'=. 7{.y
   if. curptr>:max do. ch=. curptr;chsz;max;flnm
   else. if. 0=curptr do. ch=. readChunk curptr;chsz;max;flnm
           chunk=. leftover,CR-.~>_1{ch                NB. Last complete line.
           'chunk leftover'=. (>:chunk i: LF) split chunk   NB. LF-delimited lines
           'hdr body'=. (>:chunk i. LF) split chunk    NB. Assume 1st line is header.
           hdr=. }:hdr                                 NB. Remaining part as "leftover".
       else. chunk=. leftover,CR-.~>_1{ch=. readChunk curptr;chsz;max;flnm
           'body leftover'=. (>:chunk i: LF) split chunk
       end.
       passedOn=. u body;hdr;<passedOn            NB. Pass on u's work to next invocation
   end.
   (4{.ch),leftover;hdr;<passedOn
NB.EG ((10{a.)&(4 : '(>_1{y) + x +/ . = >0{y')) doSomething ^:_ ] 0x;1e6;(fsize 'bigFile.txt');'bigFile.txt';'';'';0  NB. Count LFs in file.
)

NB.* getFirstLine: get 1st line of text file, along w/info
NB. to apply this repeatedly to get subsequent lines.
getFirstLine=: 3 : 0
   (10{a.) getFirstLine y     NB. Default to LF line-delimiter.
:
   if. 0=L. y do. y=. 0;10000;y;'' end.
   'st len flnm accum'=. 4{.y NB. Starting byte, length to read, file name,
   len=. len<.st-~fsize flnm  NB. any previous accumulation.
   continue=. 1               NB. Flag indicates OK to continue (1) or no
   if. 0<len do. st=. st+len  NB. header found (_1), or still accumulating (0).
       if. x e. accum=. accum,fread flnm;(st-len),len do.
           accum=. accum{.~>:accum i. x [ continue=. 0
       else. 'continue st len flnm accum'=. x getFirstLine st;len;flnm;accum end.
   else. continue=. _1 end.   NB. Ran out of file w/o finding x.
   continue;st;len;flnm;accum
NB.EG hdr=. <;._1 TAB,(CR,LF) -.~ >_1{getFirstLine 0;10000;'bigFile.txt' NB. Assumes 1e4>#(1st line).
)

readChunk=: 3 : 0
   'curptr chsz max flnm'=. 4{.y
   if. 0<chsz2=. chsz<.0>.max-curptr do. chunk=. fread flnm;curptr,chsz2
   else. chunk=. '' end.
   (curptr+chsz2);chsz2;max;flnm;chunk
NB.EG chunk=. >_1{ch0=. readChunk 0;1e6;(fsize 'bigFile.txt');'bigFile.txt'
)

readChunk_egUse_=: 0 : 0
   ch0=. readChunk 0;1e6;(fsize 'bigFile.txt');'bigFile.txt'
   chunk=. CR-.~>_1{ch0
   'chunk leftover'=. (>:chunk i: LF) split chunk
   'hdr body'=. split <;._1&> TAB,&.><;._2 chunk
   body=. body#~-.a: e.~ body{"1~hdr i. <'PRCCD - Price - Close - Daily'
   unqids=. ~.ids=. ;&.><"1 body{"1~ hdr i. '$gvkey';'$iid'
   dts=. MDY2ymdNum&>0{"1 body
   (unqids textLine ids (<./,>./) /. dts) fappend 'IDsDateRanges.txt'
)

accumDts2File=: 4 : 0
   'body hdr'=. y
   hdr=. <;._1 TAB,hdr
   'lkupPxs lkupID'=. hdr i. 2{.x [ outflnm=. >_1{x
   body=. <;._1&> TAB,&.><;._2 body
   body=. body#~-.a: e.~ body{"1~lkupPxs
   unqids=. ~.ids=. body{"1~lkupID
   dts=. MDY2ymdNum&>0{"1 body
   (unqids textLine ids (<./,>./) /. dts) fappend outflnm
NB.EG ('PRCCD - Price - Close - Daily - USD';'$issue_id';'IDsDateRanges.txt') accumDts2File body;<hdr
)

NB.* MDY2ymdNum: 'mm/dd/yyyy' -> yyyymmdd
MDY2ymdNum=: [: ". [: ; _1 |. [: <;._1 ] ,~ [: {. [: ~. '0123456789' -.~ ]
