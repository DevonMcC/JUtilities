NB.* fileFns.ijs: examine and manipulate files and directories.

NB.* findWhereFileIs: give locations of filename; assume parseDir globals available.
NB.* encLines: enclose lines of text vector assuming LF line terminators
NB.* freeSpaceOn: bytes of free space on disk (letter) y; assumes Windows "dir"
NB.* hexcvt: convert between number and hex representation.
NB.* readLast: read last x bytes of file y.
NB.* breakAndAssemble: break file into pieces and generate batch file to re-assemble into original file.
NB.* readChunk: read a chunk of a file from location given by "curptr".
NB.* breakUpFile: break file into smaller files.
NB.* pathFileBreak: separate path from file given fully-pathed filename.
NB.* massMoveCmds: build commands for moving a mass of files efficiently;
NB.* makeEqualSizedGroups: given a directory containing files to be split
NB.* move1Wt: move (closest to target) weight from one partition to another.
NB.* mmovetoBAT: contents of .bat file assumed by "massMoveCmds".
NB.* renameFlsGenerally: rename files found by "flexp" using fnc u.
NB.* dumpCDDir2Fl: fully list all files and dirs on disk y in file named by disk name.
NB.* copyMissing: copy files from dir 0{y to dir 1{y which not already in 1{y.
NB.* getNDSFilesMatching: get name, date, size of files w/string x in name.
NB.* gndfm: get name, date, size of files w/string x in name in dir y.
NB.* accumFlSzs: accumulate file sizes for all files under y.
NB.* makeCopyCmds: make a list of DOS copy commands after creating needed dirs.
NB.* delMulti: delete multiple files efficiently given boxed list of names.
NB.* mkMCopyTo: aggregate multiple files to single multi (e.g. copy) command.
NB.* copyFilesTo: copy all files named by >2}.y in dir >0{y to dir >1{y.
NB.* dirInfo: organize directory listing info: vec of names, mat of dates, vec
NB.* searchForInText: search for string in file.
NB.* findInFiles: look in all files in directory for given string.
NB.* lookUnder: look for x in files under dir y and its subdirs.
NB.* findFile: look for string x in file names in dir y.
NB.* findFileUC: find file - all uppercase.
NB.* findInFilesUC: look in all files in directory for given upper-cased string.
NB.* lookUnderUC: look for upper-case x in upper-cased contents of files under dir y and its subdirs.
NB.* searchForInTextUC: search for upper-case string in upper-cased file.
NB.* lookUnderAdv: look for upper-case x in upper-cased contents of files under dir y and its subdirs.
NB.* findInFilesAdv: look in all files in directory for given u'd string.
NB.* searchForInTextAdv: search for u'd string in u'd file.
NB.* chgToDir: change to directory y or don't (if protected or missing)
NB.* generalWalkTree: general directory tree walk: perform "u y" at each node:
NB.* depthEnc: enclose items on right by depth specified on left.
NB.* walkDirTree: walk directory tree performing "u y" at each node y.
NB.* renameFls: rename selected files based on string replace of names.
NB.* presuff: split file name: 'pre.suf'->'pre';'suf'.
NB.* qualifyFlnms: rename files of suffix in dir with qualifying string inserted.
NB.* subDirs: return names of all sub-directories under path y
NB.* getlines: process lines in a file.  The right argument is 3 boxed things
NB.* readNextLine: read next line of text from a file.
NB.* initLineFile: initialize lines of text from file vars.
NB.* GBLNMS_rnl_: global names for read-file-lines.
NB.* getMoreFromFl: get more data from file.
NB.* getFlPfx: get filename prefix.
NB.* getFlSfx: get filename suffix.
NB.* fixFileNames: create & run .BAT file to fix file names by replacing part.
NB.* GDT: API call to get type number of disk drive.
NB.* GetDriveType: tell what type disk drive is, given root e.g. 'C:\'.
NB.* moveToFrom: move files y to x (dir)
NB.* getCopyOf: copy files y to x (dir)
NB.* jd: list just directories, not files, from "dir" list
NB.* createYMDDir: create directory top-level;current year-month-day nums.
NB.* copyOverRegularFile: copy file from one dir to other unless already there.
NB.* getPS: get information of running processes: col 0 is process ids,
NB.* copyOverwrite: copy file from x to y, overwriting if necessary.
NB.* arblf2mat: cvt arbitrary-character delim'd fields in LF-delim'd fl->mat.
NB.* tablf2mat: convert TAB-delim'd fields in LF-delim'd lines to mat.
NB.* spclf2mat: convert spaces-delim'd fields in LF-delim'd lines to mat.
NB.* numCmdShells: count number of command shells running.
NB.* moveDirOverAnother: copy directory tree over another and remove original.
NB.* runCmdWait: run external command and wait for it to finish.
NB.* createdir: Create directory
NB.* deepCopyDir: copy directory x and all its files and sub-dirs to directory y
NB.* copyDir: copy directory x and all its files to directory y
NB.* fcopy: copy file x to y.
NB.* endSlash: ensure terminal path separator char, e.g. for directory.
NB.* flipFile: replace file named by y with its "flip":
NB.* fileExists: 0: file does not exist; 1: does exist.
NB.* dirExists: 0: directory does not exist; 1: does exist.
NB.* direxist: 0: dir does not exist; 1: exists.  From Ric Sherlock <R.G.Sherlock@massey.ac.nz>
NB.* dirSize: total size of all files and all subdirectories under dir y
NB.* dropPS: drop trailing path separator
NB.* frdix: file read indexed: name;(start,len)
NB.* fwrix: file write indexed: write x to >0{y at >1{y
NB.* dirlist1: list directories at given path.
NB.* xformFileDTS: transform file Date-Times and Size info to numeric vecs.
NB.* parseDirPieces: parse dir list from file in pieces to minimize memory use.
NB.* parseDirlist: break down text of directory listing into components.
NB.* validDrives: find what are the valid drive letters on this machine.
NB.* FILE_ATTRIBUTES: contents of file \amisc\ainfo\FILE_ATTRIBUTES.txt which
NB.* fileBitsSet: show which file attribute bits are set.
NB.* isFileWriteable: check if file y can be written to.

coclass 'fldir'
coinsert 'base'
require 'dll dt cmdtool task' NB. winapi - problematic for upgrades?
load 'regex'

NB.* findWhereFileIs: give locations of filename; assume parseDir globals available.
findWhereFileIs=: 3 : 0
   wh=. DIRNMS{~FLPARENT{~I. (tolower&.>FLNMS)=<tolower y
   jpathsep&.>wh,&.><'/',y
)

NB.* encLines: enclose lines of text vector assuming LF line terminators
encLines=: ([: <;._2 (10{a.) (] , [ #~ [ ~: [:{:]) (13{a.) -.~ ])

NB.* freeSpaceOn: bytes of free space on disk (letter) y; assumes Windows "dir"
freeSpaceOn=: 3 : '".'',''-.~>2{<;._1 '' '',dsp ,>_1{.<;._2 shell ''dir '',(y-.'':''),'':'''
NB.EG (],10&^.) freeSpaceOn 'C'

NB.* hexcvt: convert between number and hex representation.
hexcvt=: 3 : 0
   hxalph=. '0123456789ABCDEF'
   if. 0={.0$y do.                 NB. number->hex
       hxalph{~y#:~16$~>:<.16^.y
   else.                           NB. hex char str->number
       hexnum=. 'ABCDEFABCDEF0123456789*' {~ y i.~ 'abcdefABCDEF0123456789'
       16#.hxalph i. hexnum
   end.
NB.EG    hexcvt&.>'FF';'A00';'100';16;17;18;255;256;<257
NB.EG +---+----+---+--+--+--+--+---+---+
NB.EG |255|2560|256|10|11|12|FF|100|101|
NB.EG +---+----+---+--+--+--+--+---+---+
)

NB.* readLast: read last x bytes of file y.
readLast=: 13 : 'fread y;x ([ ,~ ] - [: >: [) fsize y'

NB.* breakAndAssemble: break file into pieces and generate batch
NB. file to re-assemble into original file.
breakAndAssemble=: 3 : 0
   'pfx suff maxsz flnm'=. y
   nmlst=. {."1 dir pfx,'*',suff  NB. In case already names like this.
   (pfx;suff)&breakUpFile^:_ 0;maxsz;(fsize flnm);flnm;'';0
   nms2asm=. nmlst-.~{."1 dir pfx,'*',suff
   #st=. 'copy /b ',egend=. ' Tmp000.dat'
)

NB.* readChunk: read a chunk of a file from location given by "curptr".
readChunk=: 3 : 0
   'curptr chsz max flnm'=. 4{.y
   chunk=. fread flnm;curptr,chsz2=. chsz<.0>.max-curptr
   (curptr+chsz2);chsz2;max;flnm;chunk
NB.EG chunk=. >_1{ch0=. readChunk 0;1e6;(fsize 'big.dat');'big.dat'
)

NB.* breakUpFile: break file into smaller files.
breakUpFile=: 4 : 0
NB. Current position, size of pieces, size of file, file name, piece, counter.
   'curptr chsz max flnm ch ctr'=. 6{.y
   ch=. readChunk curptr;chsz;max;flnm
   if. -. ((_1 -: ]) +. 0 = #&>) >{:ch do.
       (>{:ch) fwrite pfx,(":ctr),suff [ 'pfx suff'=. x
       ch,<>:ctr
   else. ch,<ctr end.
NB.EG ('pfx';'.suf')&breakUpFile ^:_ ] 0;1e6;(fsize 'big.dat');'big.dat';'';0
)

NB.* pathFileBreak: separate path from file given fully-pathed filename.
pathFileBreak=: ] ([ (}. ; {.) [: , ])~ [: - '/\:'&([: <./ [ i.~ [: |. [: , ])
NB.EG ('c:/foo/bar/';'somefile.txt') -: pathFileBreak 'c:/foo/bar/somefile.txt'

NB.* massMoveCmds: build commands for moving a mass of files efficiently;
NB. uses .bat file mmoveto.bat (shown below).
massMoveCmds=: 4 : 0
   'todir grpsz'=. 2{. boxopen y
   if. 0=#grpsz do. grpsz=. 10 end.     NB. Default to 10 files/group
   fromfls=. ((#x){.grpsz#i.>.grpsz%~#x) </. x
   cmds=. (<'mmoveto ',todir),&.>([:;' ',&.>])&.>fromfls
)

NB.* makeEqualSizedGroups: given a directory containing files to be split
NB. more or less equally, and a number of groups into which they are
NB. to be split, return a list of names and corresponding sizes.
makeEqualSizedGroups=: 3 : 0
   'srcdir ng'=. y            NB. Source directory, # groups
   1!:44 srcdir [ svdir=. 1!:43 ''
   szs=. ;szs [ 'fls szs'=. <"1|:0 2{"1 jfi dir '*'
   newptn=. ptn=. ?ng#~#szs  NB. Random partition to start.
NB. Measure to improve partition evenness.
   ptnmsr=. _,stddev sums=. (/:~.ptn){ ptn (+/)/. szs
   while. >/ptnmsr do.
       ptn=. newptn
       newptn=. (({.,{:)\:sums) move1Wt ptn;szs;<sums
       ptnmsr=. (}.ptnmsr),stddev sums=. (/:~.newptn){ newptn (+/)/. szs
   end.
   ptn
)

NB.* move1Wt: move (closest to target) weight from one partition to another.
move1Wt=: 4 : 0
  'ptn wts sums'=. y
   targWt=. -:-/x{sums        NB. Move From->To partition
   'fromix toix'=. I.&.> x=&.> <ptn
   whbest=. {./:|targWt-fromix{wts
   (1{x) (whbest{fromix)} ptn
NB.   sums=. (/:~.ptn){ ptn (+/)/. szs
NB.EG ({.,{:)\:sums) move1Wt ptn;szs;<sums
)

move1Wt=: 4 : 0                    NB. Move randomly...
   'fromix toix'=. I.&.>x=&.><y
   (1{x) (fromix{~?#fromix)}y
)

NB.* mmovetoBAT: contents of .bat file assumed by "massMoveCmds".
mmovetoBAT=: 0 : 0
Rem Echo off
Rem *MMoveTo.bat:  Multiple move TO %1: move %2, %3, %4, etc.
:START
If %1/==/ goto SHOWHOW
Set tmpnm=%1
:DO1
If %2/==/ goto BYEBYE
echo Y | move %2 %tmpnm% > nul
Shift
Goto DO1
:SHOWHOW
Echo on
Rem  MMoveTo target source1 source2...sourceN
Echo off
Goto BYEBYE
:BYEBYE
Set tmpnm=
Rem Echo on
)

NB.* renameFlsGenerally: rename files found by "flexp" using fnc u.
renameFlsGenerally=: 1 : 0
   cmds=. '' [ flexp=. y                NB. File selection expression
   fls=. {."1 jfi dir flexp   NB. eg. 'E:\amisc\pix\s90*.jpg'
   if. 0<#srcdir=. ('\' e. flexp)#flexp{.~flexp i: '\' do.
       cmds=. (flexp{.~>:flexp i. ':');'cd "',srcdir,'"'   NB. Move to disk, dir
   end.
   newnms=. u&.>fls
   cmds=. cmds,(<'ren "'),&.>fls,&.>(<'" "'),&.>newnms,&.>'"'
   cmds v2f batflnm=. srcdir,'renmFls.bat'
   shell batflnm
   shell ('del ',batflnm),~;(<' && '),~&.>2{.cmds
   cmds
)

renameFlsGenerally_eg_=. 0 : 0
   ([: (_4&}. , _4&{.) '.' -.~ ]) 'glb_funda_st.1997.01.31.COV'
glb_funda_st19970131.COV
   ([: (_4&}. , _4&{.) '.' -.~ ]) renameFlsGenerally 'glb*'
)

NB.* dumpCDDir2Fl: fully list all files and dirs on disk y in file named by disk name.
dumpCDDir2Fl=: 3 : 0
   aa=. <;._2 CR-.~shell 'dir ',(y-.':\/'),':\*' NB.  Volume in drive D is Ofld110213_1503
   nm=. '"',~'"C:\amisc\OfldInfo\','.dir',~>_1{<;._1>0{aa
   shell 'dir /o-d /s D:\ > ',nm
   nm
)

NB.* copyMissing: copy files from dir 0{y to dir 1{y which not already in 1{y.
copyMissing=: 3 : 0
   'fls0 fls1'=. {."1 &.> dir &.> (y=. endSlash&.>y),'*'
   copyFilesTo y,fls1-.fls0
NB.EG copyMissing 'GC',&.><':\amisc\pix\'              NB. Same dir, G: to C:
NB.EG copyMissing 'C:\amisc\pix0\';'C:\amisc\pix1\'    NB. One dir to another
)

NB.* getNDSFilesMatching: get name, date, size of files w/string x in name.
getNDSFilesMatching=: 4 : '>,&.>/,.&.>/"1](]#~0+./ .~:[:#&>|:)(x&gndfm) generalWalkTree y'
NB.EG '.ijs' getNDSFilesMatching 'C:\amisc\SP'

NB.* gndfm: get name, date, size of files w/string x in name in dir y.
gndfm=: 4 : 0
   'nms dts szs'=. <"0 |:3{."1 dir y,'\*'
   xc=. <x ([: +./&> ] E.&.>~ [: < [) nms
   xc#&.>nms;dts;<szs
NB.EG aa=. ('.ijs'&gndfm) generalWalkTree 'C:\amisc\SP'
NB. aa=. >,&.>/,.&.>/"1](]#~0+./ .~:[:#&>|:)aa
)

NB.* accumFlSzs: accumulate file sizes for all files under y.
accumFlszs=: 3 : '(];[:+/[:;2{"1[:jfi[:dir ''\*'',~ ]) generalWalkTree y'
NB.EG 6!:2 'OFls=. accumFlSzs ''O:'''

makeCopyCmds=: 3 : 0
NB.* makeCopyCmds: make a list of DOS copy commands after creating needed dirs.
   (FLNMS;FLPARENT;<DIRNMS) makeCopyCmds y   NB. Use globals if none supplied.
:
   'targ ix'=. y [ 'FLNMS FLPARENT DIRNMS'=. x
   fls=. ix{FLNMS             NB. Use globals created by parseDir.
   drs=. DIRNMS{~ix{FLPARENT
   udrs=. ~.drs
   ord=. /:udrs i. drs
   fls=. (1,2~:/\ord{udrs i. drs)<;.1 ord{fls
   newdrs=. (<targ),&.>udrs}.~&.>2+&.>udrs i.&.>':'
   mknew=. (<'mkdir "'),&.>newdrs,&.>'"'
NB. e.g. mkdir C:\Temp\Recent\amisc\jsys\user\code
   cdnext=. (<'cd "'),&.>udrs,&.>'"'
NB. e.g. cd c:\amisc\jsys\user\code
   cmds=. ''

   for_ii. i. #udrs do.
       mm=. mkMCopyTo 10;(>ii{newdrs);ii{fls
NB. e.g. mcopyto "C:\Temp\Recent\global\fof" "bmkcorr.ijx" "targetbands.xls"...
       cmds=. cmds,(<2{.;ii{udrs),(ii{cdnext),(ii{mknew),,mm  NB. E.g. 'C:';'cd C:\utl';'mcopyto...'
   end.
   cmds
)

NB.* delMulti: delete multiple files efficiently given boxed list of names.
delMulti=: 3 : 'shell&.>''mdel'' mkMCopyTo 10;'''';<y'

mkMCopyTo=: 3 : 0
   'mcopyto' mkMCopyTo y
:
NB. mkMCopyTo  10;targ;fls  NB. -> mcopyto targ fl1 fl2..fl10 ; mcopyto targ fl11...
   'npc targ fls'=. y   NB. Number per copy, target dir, file list
   ptn=. (#fls)$npc{.1
   fls=. ;&.>ptn<;.1 '"',&.>fls,&.><'" '
   cmd=. (<'call ',x,' "',targ,'" '),&.>fls
)

NB.* copyFilesTo: copy all files named by >2}.y in dir >0{y to dir >1{y.
copyFilesTo=: 3 : 0
   'mcopyto' copyFilesTo y
:
   fls=. 2}.y [ 'srcd dest'=. 2{.y
   1!:44 srcd [ svod=. 1!:43 ''              NB. Move to source dir
   if. 0=#fls do. fls=. 0{"1 dir '*' end.    NB. All files if none spec'd
   if. -.dirExists dest do. shell 'mkdir ',dest end.
NB. npc: # files/copy statement
   npc=. 1>.<.((+/%#)#&>fls)%~255-#'call ',x,' ',dest,' '
   (x mkMCopyTo (npc;dest),<fls) v2f batfl=. 'cpFls.bat'
   1!:44 svod [ ferase batfl [ shell batfl   NB. Return to original dir after
NB.EG copyFilesTo ((<'C:\J\'),&.>'src';'svdocs'),0{"1 dir 'C:\J\src\*.doc'
NB.  shell&.>((<'cd ',srcd),(<'mcopyto ',dest,' '),&.>([:}.[:;' ',&.>])&.>npc<\fls)
NB.  shell batfl
)

NB.* dirInfo: organize directory listing info: vec of names, mat of dates, vec
NB. of sizes, vec of dir flags.
dirInfo=: ([:((0{"1]) ; ([:>1{"1]) ; ([:;2{"1]) ; [:<'d'e.&>4{"1]) dir)

NB.* searchForInText: search for string in file.
searchForInText=: [ ([: +./ E.) [: fread ]
MAXFLSZ=: 2e8
searchForInText=: 4 : 0
   rr=. 0 NB. Not found if 0-length or unreadable file; skip if too large.
   if. ([:(MAXFLSZ&> *. 0&<)fsize)y do. rr=. 1
       try. frdix y;0 1 catch. rr=. 0 end.
       try. tmp=. fread y catch. rr=. 0 end.
       if. rr*.-.tmp-:_1 do. rr=. +./x E. tmp end.
   end.
   rr
)

NB.* grepInFiles: return names of files containing pattern y with optional flags x: UNFINISHED!
grepInFiles=: 3 : 0
   '' grepInFiles y
:
   rr=. a:-.~x ([: <;._2 [: ] (10{a.) (] , [ #~ [ ~: [: {: ]) (13{a.) -.~ [: shell 'grep -l ' , [ , ' ' , ' *.*' ,~ ]) y
   if. 0~:#rr do. (<endSlash 1!:43''),&.>rr else. '' end.
)

NB.* grepUnder: find pattern >0{y with optional flags x in all files under >1{y: UNFINISHED!
grepUnder=: 3 : 0
   (''&grepInFiles&>0{y) generalWalkTree >1{y
:
   (x&grepInFiles&>0{y) generalWalkTree >1{y
)

NB.* findInFiles: look in all files in directory for given string.
findInFiles=: 13 : 'x(]#~ ] searchForInText&>~[:<[)(([: < endSlash) ,&.> [: {."1 [: jfi [: dir ''\*'',~ ])y'
NB.* lookUnder: look for x in files under dir y and its subdirs.
lookUnder=: 4 : '(x&findInFiles) generalWalkTree y'
NB.EG 'whoami' lookUnder 'C:\amisc\JSys\user\code'
NB.EG ;LF,~&.>;rr [ smoutput (#;#&>;[:+/#&>)rr [ smoutput 6!:2 'rr=. a:-.~''burma'' lookUnder ''c:/amisc/J/NYCJUG/201808'''
NB.* findFile: find files with string x in names in dir y.
findFile=: 13 : '(<y,''\''),&.>x(]#~]+./ .E.&>~[:<[){."1 dir y,''\*'''
NB.EG ('glossary'&findFile) generalWalkTree 'W:'
NB.* findFileUC: find file - all uppercase.
findFileUC=: ([: < '\' ,~ ]) ,&.> [ (] #~ ] +./ . (E. [: toupper])&>~ [: < (toupper@:[)) [: {."1 [: dir '\*' ,~ ]

NB.* findInFilesUC: look in all files in directory for given upper-cased string.
findInFilesUC=: ([: toupper [) (] #~ ] searchForInTextUC&>~ [: < [) [: (([: < endSlash) ,&.> [: {."1 [: jfi [: dir '\*' ,~ ]) ]
NB.* lookUnderUC: look for upper-case x in upper-cased contents of files under dir y and its subdirs.
lookUnderUC=: 4 : '(x&findInFilesUC) generalWalkTree y'
NB.EG ;LF,~&.>;rr [ smoutput (#;#&>;[:+/#&>)rr [ smoutput 6!:2 'rr=. a:-.~''burma'' lookUnderUC ''c:/amisc/J/NYCJUG/201808'''
NB.* searchForInTextUC: search for upper-case string in upper-cased file.
searchForInTextUC=: 4 : 0
   rr=. 0 NB. Not found if 0-length or unreadable file; skip if too large.
   if. ([:(MAXFLSZ&> *. 0&<)fsize)y do. rr=. 1
       try. frdix y;0 1 catch. rr=. 0 end.
       try. tmp=. fread y catch. rr=. 0 end.
       if. rr*.-.tmp-:_1 do. rr=. +./(toupper x) E. toupper tmp end.
   end.
   rr
)

NB.* lookUnderAdv: look for upper-case x in upper-cased contents of files under dir y and its subdirs.
lookUnderAdv=: 1 : (':';'(x&(u findInFilesAdv)) generalWalkTree y')
NB.EG ;LF,~&.>;rr [ smoutput (#;#&>;[:+/#&>)rr [ smoutput 6!:2 'rr=. a:-.~''burma'' (toupper lookUnderAdv) ''c:/amisc/J/NYCJUG/201808'''

NB.* findInFilesAdv: look in all files in directory for given u'd string.
findInFilesAdv=: 1 : (':';'(u x) (]#~ ] (u searchForInTextAdv) &>~[:<[)(([: < endSlash) ,&.> [: {."1 [: jfi [: dir ''\*'',~ ]) y')

NB.* searchForInTextAdv: search for u'd string in u'd file.
searchForInTextAdv=: 1 : 0
:
   rr=. 0 NB. Not found if 0-length or unreadable file; skip if too large.
   x=. u x
   if. ([:(MAXFLSZ&> *. 0&<)fsize)y do. rr=. 1
       try. frdix y;0 1 catch. rr=. 0 end.
       try. tmp=. fread y catch. rr=. 0 end.
       if. rr*.-.tmp-:_1 do. rr=. +./x E. u tmp end.
   end.
   rr
)

NB.* chgToDir: change to directory y or don't (if protected or missing)
chgToDir=: 3 : 'try. 1!:44 y catch. '''' end.'

NB.* generalWalkTree: general directory tree walk: perform "u y" at each node:
NB. 0{x: (0) depth first or (1) breadth first;
NB. 1{x: (0) flattened or (1) nested result matching input tree structure.
generalWalkTree=: 1 : 0
   (1 0) u generalWalkTree y  NB. Default: breadth-first, flattened result.
:
   ct=. 0 [ rr=. '' [ stack=. ,boxopen y [ x=. 2{.x
   ctr=. (0{x){_1 0           NB. First we build the stack.
   while. ct<#stack do.                           NB. Get subdir names:
       subds=. ((('d'e.&>4{"1])#0{"1])@:(1!:0@<)) (>ctr{stack),'\*'
       subds=. subds (],&.>'\',&.>[) ctr{stack    NB. -> full path names
       if. 0{x do. stack=. stack,subds            NB. Breadth or
       else.       stack=. subds,stack  end.      NB.  depth first
       ctr=. ctr+(0{x){_1 1 [ ct=. >:ct           NB. Go forward or backward
   end.
   dpth=. (]-<./)'\'+/ . =&>stack

   if. 1{x do. ;&.>(<:~.dpth) depthEnc dpth </. u&.>stack  NB. Preserve tree
   else.       u&.>stack              end.                 NB.  or flatten it.
NB.EG ([:;2{"1 [:dir '*',~],'\'-.{:) generalWalkTree 'C:\' NB. All file sizes
)
NB.EG 6!:2 '(3 : ''shell ''''rmxs && del "#*#" && del ".#*"''''[chgToDir y'')generalWalkTree ''C:\amisc'''
NB. where 0 : 0 fwrite '\utl\rmxs.bat'
NB. @echo off
NB. REM rmxs.bat: remove excess files left over from emacs.
NB. If %1/==/ goto DELETEM
NB. cd %1
NB. :DELETEM
NB. if exist *~ del *~
NB. )

NB.* depthEnc: enclose items on right by depth specified on left.
depthEnc=: 4 : '<^:(>:x)]y'"0

NB.* walkDirTree: walk directory tree performing "u y" at each node where
NB. "y" is current directory name.
walkDirTree=: 1 : 0
   rr=. u y    NB. Do it in current, then look to subdirs
   subds=. ((('d'e.&>4{"1])#0{"1])@:(1!:0@<)) y,'\*' NB. Only subdir names
   rr=. (<rr),(u walkDirTree)&.>subds ([,~&.>[:<'\',~]) y
)

NB.* renameFls: rename selected files based on string replace of names.
renameFls=: 3 : 0
   'flexp frstr tostr'=. y    NB. File selection expression, from & to strings
   fls=. {."1 jfi dir flexp   NB. eg. 'E:\amisc\pix\s90*.jpg'
   srcdir=. cmds=. ''
   if. ':' e. flexp do. srcdir=. flexp{.~flexp i: '\'
       cmds=. (flexp{.~>:flexp i. ':');'cd "',srcdir,'"'   NB. Move to disk, dir
   end.
NB. e.g. 'frstr tostr'=. 's90X03';'s90X02'   NB. Name change by replacement
   newnms=. (<frstr;tostr)stringreplace&.> fls
   cmds=. cmds,(<'ren "'),&.>fls,&.>(<'" "'),&.>newnms,&.>'"'
   cmds v2f batflnm=. srcdir,'renmFls.bat'
   shell batflnm
   shell ('del ',batflnm),~;(<' && '),~&.>2{.cmds
   cmds
NB.EG cmds=. renameFls 'E:\amisc\pix\s90*.jpg';'s90X03';'s90X02'
)

NB.* presuff: split file name: 'pre.suf'->'pre';'suf'.
presuff=: 13 : 'y({.;}.)~(y i: ''.'')'

NB.* qualifyFlnms: rename files of suffix in dir with qualifying string inserted.
qualifyFlnms=: 3 : 0
   'tdir tsuf qual'=. y                 NB. Target directory, suffix, qualifier
   tdir=. tdir,'\'#~'\'~:{:tdir         NB. Ensure trailing separator.
   fls=. {."1 jfi dir tdir,'*',tsuf,~'.'#~'.'~:{.tsuf
   'pre suf'=. <"1 |:presuff&>fls
   newnms=. suf,~&.>pre,&.><qual        NB. Qualifier after prefix, before suffix
   cmds=. (<'ren "'),&.>fls,&.>(<'" "'),&.>newnms,&.>'"'
   cmds=. (<tdir{.~>:tdir i. ':'),(<'cd ',tdir),cmds   NB. Move to drive, dir first
   cmds v2f cfn=. tdir,'renmfls.bat'    NB. Command file to perform renames.
   cfn;shell cfn                        NB. Run command, return name
NB.EG qualifyFlnms 'E:\amisc\pix\';'jpg';'XX'     NB. 'foo.jpg'->'fooXX.jpg'
)

NB.* subDirs: return path,sep;names of all sub-directories under path y
subDirs=: 13 : 'y;jd dir y,''*''[y=. y,PATHSEP_j_#~PATHSEP_j_~:{:y'
NB.EG pgmpaths=. ({. ,&.> }.)subDirs 'C:\Program Files'

NB.* getlines: process lines in a file.  The right argument is 3 boxed things
NB. 'filename' ; file_pointer ; line_buffer
getlines =: 3 : 0
 100000 getlines y  NB. Default BS is 100,000 bytes
:
 bs =. x
 fs =. fsize fn =. > 0{y
 fl =. bs <. fs -fp =. > 1{y
 buf =. ir fn;fp,fl
  if. (fs = fp =. fp + fl) do. fp =. _1 end.
 drop =. (<:#buf)-buf i: NL
  if. ((drop ~: 0) *. fp = _1 ) do. echo '** Unexpected EOF **' end.
 fp =. _1 >. fp - drop
 fn;fp;buf }.~ -drop
)
NB. from Joey Tuttle.

NB.* readNextLine: read next line of text from a file.
readNextLine=: 3 : 0
NB. Initialize globals if necessary.
   if. fexist y do. initLineFile y
   else. return. [ smoutput 'File not found: ',y,'.' end.
   whfl=. FILES_rnl_ i. <y
   'flnm flbuf fleof flix'=. whfl{&.>FILES_rnl_;BUFFL_rnl_;EOF_rnl_;<FLIX_rnl_
   flbuf=. >flbuf

NB. Keep filling buffer until we've got at least one line or have reached EOF.
   while. (-.fleof)*. -.EOL e. flbuf do.
       'fleof flix flbuf'=. getMoreFromFl flix;flnm;flbuf;whfl
   end.
   whln=. flbuf i. EOL
   outln=. whln{.flbuf
   BUFFL_rnl_=: (<flbuf=. (>:whln)}.flbuf) whfl}BUFFL_rnl_
   if. 0=#flbuf do. EOD_rnl_=: 1 whfl}EOD_rnl_ end.
   flsz=. fsize flnm
   FLIX_rnl_=: (flix=. flsz<.>:whln+flix) whfl}FLIX_rnl_
   outln
)

NB.* initLineFile: initialize lines of text from file vars.
initLineFile=: 3 : 0
   if. -.nameExists 'FILES_rnl_' do.
       FILES_rnl_=: ,<y       NB. List of file names we're now reading.
       BUFFL_rnl_=: ,<''      NB. Vector of partial file contents in memory.
       EOF_rnl_=: ,0          NB. End-of-file indicator: 0: no.
       EOD_rnl_=: ,0          NB. End-of-data indicator: 0: no.
       FLIX_rnl_=: 0          NB. Point in file to which we've read.
       CHUNKSZ_rnl_=: 2048    NB. Number of bytes to read at a time.
   end.

NB. Add new file to list if necessary.
   whfl=. FILES_rnl_ i. <y
   if. (#FILES_rnl_)=whfl do.
       FILES_rnl_=: FILES_rnl_,,<y
       BUFFL_rnl_=: BUFFL_rnl_,<''
       EOF_rnl_=: EOF_rnl_,0
       EOD_rnl_=: EOD_rnl_,0
       FLIX_rnl_=: FLIX_rnl_,0
   end.
)

NB.* GBLNMS_rnl_: global names for read-file-lines.
GBLNMS_rnl_=: ('FILES';'BUFFL';'EOF';'FLIX';'CHUNKSZ'),&.><'_rnl_'

NB.* getMoreFromFl: get more data from file.
getMoreFromFl=: 3 : 0
   'flix flnm flbuf whfl'=. y
   flsz=. fsize flnm=. >flnm
   chsz=. CHUNKSZ_rnl_<.flix-~flsz
   chunk=. frdix flnm;flix,chsz
   BUFFL_rnl_=: (<flbuf=. flbuf,chunk) whfl}BUFFL_rnl_
   FLIX_rnl_=: (flix=. flsz<.>:flix+#chunk) whfl}FLIX_rnl_
   fleof=. 0
   if. flix>:flsz do. EOF_rnl_=: (fleof=. 1) whfl}EOF_rnl_ end.
   fleof;flix;<flbuf
)

getFlPfx=: 3 : 'y{.~y i: ''.'''     NB.* getFlPfx: get filename prefix.
getFlSfx=: 3 : 'y}.~>:y i: ''.'''   NB.* getFlSfx: get filename suffix.

NB.* fixFileNames: create & run .BAT file to fix file names by replacing part.
fixFileNames=: 3 : 0
   'dirnm src rplcstr'=. y             NB. Directory name, part of file name
   dirnm=. endSlash dirnm               NB.  to replace, replacement string.
   fls=. {."1 jfi dir dirnm,'*',src,'*' NB. Get file names.
   newnms=. (<src;rplcstr) stringreplace&.>fls
   cmds=. (<'ren "'),&.>fls,&.>(<'" "'),&.>newnms,&.>'"'
   dsk=. dirnm{.~dirnm i. ':'
   if. 1~:#dsk do. dsk=. 'C' end.       NB. Assume C: drive if none specified.
   cmds=. cmds,~(dsk,':');'cd ',dirnm   NB. Change to correct drive and dir.
   alp=. '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'   NB. Create new filename.
   while. fexist batflnm=. dd,'ren',(alp{~?5$#alp),'.bat' do. end.
   wait 1 [ cmds v2f batflnm       NB. Wait for .BAT file to get created.
   wait 1 [ shell batflnm          NB. Run name-change commands.
   shell 'del ',batflnm            NB. Remove .BAT file.
)

0 : 0
NB.* GDT: API call to get type number of disk drive.
GDT=: 'GetDriveType'win32api
)

NB.* GetDriveType: tell what type disk drive is, given root e.g. 'C:\'.
GetDriveType=: 3 : 0
   numType=. |:(;/i.7),.'Error';'Nonexistent';'Removable';'Hard';'Network';'CD-ROM';<'RAMDisk'
   if. 0=#y do. numType      NB. Show all known types if empty arg.
   else.
       diskLetter=. y
       diskLetter=. diskLetter-.' '
       diskLetter=. <diskLetter,(-.':' e. diskLetter)#':'
       dtype=. GDT diskLetter
       diskLetter,(0{dtype),((0{numType)i. 0{dtype){1{numType
   end.
NB.EG 'letter typenum typetext'=. GetDriveType 'C'
)

NB.    qts ''
NB. 2001 12 10 16 29 47.949
NB.    6!:2 '>GetDriveType &.>''ABCDEFGHIJKLMNOPQRSTUVWXYZ'''
NB. 0.00575855
NB.    >GetDriveType &.>'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
NB. +--+-+-----------+
NB. |A:|2|Removable  |
NB. +--+-+-----------+
NB. |B:|1|Nonexistent|
NB. +--+-+-----------+
NB. |C:|3|Hard       |
NB. +--+-+-----------+
NB. |D:|5|CD-ROM     |
NB. +--+-+-----------+
NB. |E:|4|Network    |
NB. +--+-+-----------+
NB. |F:|4|Network    |
NB.  ...
NB. |K:|4|Network    |
NB. +--+-+-----------+
NB. |L:|1|Nonexistent|
NB. +--+-+-----------+
NB. |M:|1|Nonexistent|
NB.  ...
NB. +--+-+-----------+
NB. |Z:|1|Nonexistent|
NB. +--+-+-----------+

NB.* moveToFrom: move files y to x (dir)
moveToFrom=: 4 : 0
   'rc flnms'=. x getCopyOf y
   mvok=. rc*.fexist&>flnms
   mvok*.mvok exp ferase&>mvok#y
NB.EG 'C:\Dest\' moveToFrom 0{"1 dir '*.jpg' [ 1!:44 'C:\Source\'
)

NB.* getCopyOf: copy files y to x
getCopyOf=: 4 : 0
   flnms=. (<endSlash x),&.>;(}.@:pathFileBreak)&.>y=. boxopen y
   rc=. y copyOverwrite &> flnms
   rc;<flnms
)

NB.* jd: return just directories, not files, from "dir" list
jd=: 3 : '(''d''e.&>4{"1 y)#0{"1 y'
NB.* jfi: return just files' info, not directories, from "dir" list
jfi=: 3 : '(-.''d''e.&>4{"1 y)#y'

NB.* createYMDDir: create directory top-level;current year-month-day nums.
createYMDDir=: 3 : 0
   'AllocDetails.xls' createYMDDir y   NB. Left arg is name of a file to copy.
:
   'y ymd'=. y [ flnm=. x
   dirnm=. y,subdir=. ;2 lead0s&.>ymd
   ny=. createdir dirnm
   ny=. dirExists dirnm       NB. Don't really care if created, just that it
   if. DEBUGON do.            NB.  exists.
       word=. ,>ny{' NOT';''
       logMsg_logger_ 'Directory ',dirnm,' does',word,' exist'
       logMsg_logger_ ' at ','.',~showdate ''
       wait 5                 NB. Allow 5 secs to read msg.
   end.
   if. 0~:#flnm do.                NB. Need to copy file forward to new dir?
       dd=. /:~jd dir y,'*'        NB. Search back through previous
       dix=. dd i. <subdir         NB.  directories to copy forward a
       while. _1<dix=. <:dix do.   NB.  file we need in new dir.
           fromfl=. (y,>dix{dd),'\',flnm
           if. copyUnlessPresent fromfl;dirnm do. dix=. _1 end.
       end.
   end.
)

NB.* copyUnlessPresent: copy file from one dir to other unless already there.
copyUnlessPresent=: 3 : 0
   'fromfl dirnm'=. y
   'xx tofl'=. pathFileBreak fromfl
   ny=. 0                               NB. Assume failure
   if. fexist fromfl do.
       tofl=. dirnm,'\',tofl            NB. Same name, different directory
       if. -.fexist tofl do.            NB. "fcopy" will fail if target exists.
           ny=. 0={.fromfl fcopy tofl   NB. "fcopy" returns 0 for success.
           if. DEBUGON do.
               word=. ,>ny{' NOT';''
               'dirnm flnm'=. pathFileBreak tofl
               logMsg_logger_ 'File ',flnm,' was',word,' copied from ',fromfl
               logMsg_logger_ ' to ','.',~dirnm
               wait 2
           end.
       else. logMsg_logger_ 'File ',tofl,' already exists - no copy done.'
           ny=. 1
       end.
   end.
   ny
)

getPS=: 3 : 0
NB.* getPS: get information of running processes: col 0 is process ids,
NB. col 1 is class and text name.
   alph=. '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
   rnd=. (?6##alph){alph
   tmpfl=. (endSlash getTempDir ''),'PS',rnd,'.txt'
   delFile tmpfl
   sink=. shell 'cmd /C ps > ',tmpfl
   wait 1                NB. Wait a second for command to finish
   max=. 9               NB.  and try 9 times just for sake of bogged system.
   ctr=. 1
   while. ctr<:max do.
       if. fexist tmpfl do. ctr=. max+10
       else. wait (ctr) [ ctr=. >:ctr end.   NB. Wait longer each time since
   end.                                      NB.  must be slow.
   ps=. dlsp&.>f2v tmpfl
   ps=. (2+(3{.&.>ps)i.<'PID')}.ps           NB. Drop header
   delFile tmpfl
   ps=. (wh{.&.>ps),:(>:&.>wh=. ps i.&.>' ')}.&.>ps
)

copyOverwrite=: 4 : 0
NB.* copyOverwrite: copy file from x to y, overwriting if necessary.
   if. fexist y do.
       if. fexist x do. ferase y end.
   end.
   x fcopy y
)

NB.* arblf2mat: cvt arbitrary-character delim'd fields in LF-delim'd fl->mat.
arblf2mat=: 4 : '><;._1&.>x,&.><;._1 LF,(-LF={:y)}.y=.x dechar y'
NB.* tablf2mat: convert TAB-delim'd fields in LF-delim'd lines to mat.
tablf2mat=: 3 : '><;._1&.>TAB,&.><;._1 LF,(-LF={:y)}.y'
NB. Only do if y is unenclosed.
tablf2mat=: ([: > [: <;._1&.> (9{a.) ,&.> [: <;._1 (10{a.) , ] }.~ [: - (10{a.) = {:)^:(1 > L.)
NB.* spclf2mat: convert spaces-delim'd fields in LF-delim'd lines to mat.
spclf2mat=: 3 : '><;._1&.>('' ''&,@:dsp)&.><;._1 LF,(-LF={:y)}.y'
spclf2mat=: (3 : '><;._1&.>('' ''&,@:dsp)&.><;._1 LF,(-LF={:y)}.y')^:(1 > L.)

numCmdShells=: 3 : 0
NB.* numCmdShells: count number of command shells running.
   +/+./&>(<'CMD.EXE') E.&.>toupper&.>1{getPS ''
)

NB.* cmdShellNums: get process numbers of all DOS command shells running.
cmdShellNums=: 3 : 0
   if. 0=#y do. y=. 'CMD.EXE' end.
   ;n2j&.>(+./&>(boxopen y) E.&.>toupper&.>1{pss)#0{pss=. getPS ''
)

NB.* moveDirOverAnother: copy directory tree over another and remove original.
moveDirOverAnother=: 4 : 0
   fromdir=. quoteIfSp openbox x [ todir=. quoteIfSp openbox y
   if. nameExists 'TOPDIR' do. topdir=. TOPDIR
   else. topdir=. 'C:/Temp/' end.       NB. Assume dirs in C:\Temp....
   topdir=. (topdir rplc '/\') rplc '\\';'\'
   batflnm=. ((topdir,'xcopydir.bat')rplc '/\';'/') rplc '\\';'\'
   if. fexist batflnm do. ferase batflnm end.
   cmd=. (2{.topdir),CRLF,('cd ',2}.topdir),CRLF NB. C:,cd \Temp\...
   cmd=. cmd,'xcopy /S /C /H /I /R /Q /Y ',fromdir,' ',todir     NB. New parms for Windows 7 xcopy
   ((cmd rplc '/\';'/') fwrite batflnm) rplc '\\';'\'
   shell_ptask_ batflnm
NB.   runCmdWait 'cmd /c ',batflnm
NB. The following waiting means the above wait loop does not properly wait
NB. until end of process; the increasing wait attempts to account for the
NB. increasing size of directories copied backwards.
NB.   wait {.WTTMINC_TMP_=. (+/WTTMINC_TMP_) 0}WTTMINC_TMP_
   if. (dirExists topdir,fromdir)*.-.topdir-:topdir,fromdir do.
       cmdstr=. 'rmdir /S /Q ',topdir,fromdir
       shell_ptask_ cmdstr
   end.
)

NB.* runCmdWait: run external command and wait for it to finish.
runCmdWait=: 3 : 0
   pid0=. cmdShellNums ''           NB. Get process ids of all command shells running.
   shell y                          NB. This starts another command shell.
   pidn=. pid0-.~cmdShellNums ''    NB. New processes since 1st check may include the
   while. +./(cmdShellNums '')e. pidn do. wait 1 end.  NB. .bat file we just started.
)

failedAttempt=: 0 : 0
   if. 0 do.      NB. Attempt to ID process and wait for it to end...
       logs=. (<'C:\Temp\xcopy'),&.>'01',&.><'.log'
       'cmd0 cmd1'=. (<'cmd /C "ps > '),&.>logs,&.>'"'
       shell cmd1 [ shell 'cmd /C ',batflnm [ shell cmd0
       'xc0 xc1'=. f2v&.>logs
       difps=. toupper&.>(dsp@:;)&.>xc1-.xc0 NB. May be more than 1 process.
       difps=. (+./&>(<'CMD')E.&.>difps)#difps
       logMsg_logger_ 'Waiting for xcopy to complete at ',':',~showdate ''
       logMsg_logger_ ' ',cmd{.~-LF i.~|.cmd
       logMsg_logger_ difps
       waitForProcessToFinish &.> 2;&.>]&.>difps
       logMsg_logger_ 'xcopy finished at ','.',~showdate ''
   end.
)

NB.* createdir: Create directory
createdir=: 3 : 'try. 1!:5 <y catch. 0 end.'

NB.* createDirPath: create (all elements of) directory path.
createDirPath=: 3 : 0
   ps=. PATHSEP_j_
   dn=. y
NB. Break path into pieces, e.g. 'C:\tmp\foo'->'C:';'\tmp';'\foo'
   pdn=. <;.1 (ps#~ps~:{.dn),(-ps={:dn)}.dn
   if. ':' e. dn do.               NB. Remove '\' before drive letter
       pdn=. (<dn{.~>:dn i. ':') 0}pdn
NB. Combine drive letter w/1st path element, e.g. '\C:';'\tmp';'\foo'->'C:\tmp';'\foo'
       pdn=. ((<ps-.~>0{pdn),&.>1{pdn) 0}}.pdn
   end.
NB. Successive directories to create, e.g. 'C:\tmp';'C:\tmp\foo';'C:\tmp\foo\bar'
   d2c=. <"1 pdn#~-.dirExists"1 pdn=. ;\pdn
   rc=. 1                          NB. Success too if they're already all there
   if. 0<#d2c do. rc=. createdir&>d2c end.
   rc
)

deepCopyDir=: 4 : 0
NB.* deepCopyDir: copy directory x and all its files and sub-dirs to directory y
   fromdir=. endSlash x [ todir=. endSlash y
   assert. dirExists fromdir
   if. -.dirExists todir do. createdir todir end.
   wait 1
   assert. dirExists todir
   fls=. dir fromdir,'*'
   subdirs=. 0{"1 (whd=. 'd' e.&>4{"1 fls)#fls
   fls=. 0{"1 (-.whd)#fls
   sf=. 0 0                        NB. Count successes and failures.
   for_fl. fls do. fl=. >fl
       if. fexist todir,fl do. ferase todir,fl end.    NB. Overwrite existing
       ct=. 1 0                    NB. Assume 1 success, 0 failures...
       try. (fromdir,fl) fcopy todir,fl catch. ct=. 0 1 end.
       sf=. sf+ct
   end.
   for_sbdr. subdirs do. sbdr=. >sbdr
       if. -.dirExists sbdr do. createdir sbdr end.
       ct=. 1 0                    NB. Assume 1 success, 0 failures...
       try. ssf=. (fromdir,sbdr) deepCopyDir todir,sbdr catch. ct=. 0 1 end.
       sf=. sf+ssf+ct
   end.
)

copyDir=: 4 : 0
NB.* copyDir: copy directory x and all its files to directory y
NB.   fromdir=. endSlash x [ todir=. endSlash y
   fromdir=. x [ todir=. y
   assert. dirExists fromdir}.~-'*'={:fromdir
   if. -.dirExists todir do. createdir todir end.
   if. -.dirExists todir do. shell 'mkdir ',todir end. [ wait 1
   wait -.dirExists todir
   if. -.dirExists todir do. shell 'mkdir ',todir end.  NB. Belt and suspenders
   wait -.dirExists todir
   sf=. 1 0                    NB. Assume 1 success, 0 failures...
   try. fromdir fcopy todir catch. sf=. 0 1 end.
   sf
NB.EG NB. Copy dir from E: to Z:
NB.EG 'CDZ' (] copyDir [,[:}.])&.> <'E:\amisc\pix\Sel\2006Q4\20061005-07'
NB.EG 'CDZ' (] copyDir [,[:}.])&.> <'E:\amisc\pix\Photos\2006Q4\20061005-07'
NB.EG 6!:2 '''EDZ'' (] copyDir [,[:}.])&.> <''C:\amisc\Jsys'''
NB.EG 'CDZ' (] copyDir [,[:}.])&.> <'E:\amisc\pix\Photos\2021Q1\20210229'
NB.EG 'CDZ' (] copyDir [,[:}.])&.> <'E:\amisc\pix\Sel\2021Q1\20210229'
NB.EG 'CDZ' (] replaceDir [,[:}.])&.> <'E:\amisc\pix\Photos\2021Q1\20210229'
)

delDir=: 3 : 0
   assert. dirExists y
   shell 'rmdir /S /Q ','/\' rplc~endSlash y
   -. dirExists y
NB.EG delDir 'C:\Temp\test'
)

replaceDir=: 4 : 0
NB.* replaceDir: replace directory y and all its contents with directory x
   fromdir=. x [ todir=. y
   assert. dirExists fromdir}.~-'*'={:fromdir
   if. dirExists todir do. wait 1 [ shell 'rmdir /Q /S ',todir rplc '/\' end. NB. Wait to ensure removal finishes
   assert. -.dirExists todir
   sf=. 1 0                    NB. Assume 1 success, 0 failures...
   try. fromdir fcopy todir catch. sf=. 0 1 end.
   sf
NB.EG NB. Replace dir from E: to Z:
NB.EG 'Z' (] replaceDir [ , [: }. ]) 'E:\amisc\pix\Photos\2020Q1\20200302-03'   
)

0 : 0
NB.* fcopy: copy file x to y using WIN32 API call.
fcopy=: 'CopyFileA' win32apir @: (; ;&1)
NB.EG 'c:\temp\src.xls' fcopy 'c:\temp\dest.xls'  NB.  Returns 1 iff successful
)

NB.* fcopy: copy x (fully-pathed name of file) to y.
fcopy=:	4 : 'shell ''xcopy /S /C /H /I /R /Q /Y "'',(x,''" "'',y,''"'') rplc ''/\'''
NB.EG 'C:\Temp\foo.txt' fcopy 'E:\Perm\foo2.txt'

endSlash=: ] , PATHSEP_j_ -. {:
NB.* endSlash: ensure terminal path separator char, e.g. for directory.
NB.EG -:/endSlash &.>'C:\ADir\';'C:\ADir'

flipFile=: 3 : 0
NB.* flipFile: replace file named by y with its "flip":
NB. lines reversed top to bottom except (optionally) for header line(s).
   0 flipFile y
:
   fl=. f2v y
   fl=. fl#~-.*./\&.|.fl e. a:     NB. Remove trailing empty lines.
   ((x{.fl),|.x}.fl) v2f y      NB. Flip after x lines.
)

fileExists=: 3 : '0~:#1!:0<y'     NB.* fileExists: 0: file does not exist;
                                   NB. 1: does exist.  Should use "fexist"?
NB.* dirExists: 0: dir does not exist; 1: exists
dirExists=: 3 : '0&~:#@:dirlist1 (-PATHSEP_j_={:y)}.y=. ,y'
NB.* direxist: 0: dir does not exist; 1: exists.  From Ric Sherlock <R.G.Sherlock@massey.ac.nz>
direxist=: 'd' e."1 [: > [: , [: ({:"1)1!:0@(fboxname&>)@(dropPS&.>)@boxopen
NB.* dirSize: total size(s) of all files and all subdirectories under dir y
dirSize=: 3 : 0
   0 dirSize y                        NB. Default is don't sum
:
   y=. y,PATHSEP_j_#~PATHSEP_j_~:{:y
NB.   y=. PATHSEP_j_ (],[#~[~:[:{:]) y
   dl=. dir y,'*'
   whd=. 'd' e. &> 4{"1 dl
   szs=. +/(-.whd)#;2{"1 dl             NB. Total size of files at this level
   if. 1 e. whd do.                   NB. Sum everything below top-level dirs
       szs=. szs,1 dirSize&>(<y),&.>PATHSEP_j_,~&.>whd#0{"1 dl
   end.
   if. x do. +/szs else. ,szs end.      NB. bytes in files immediately under dir,
NB.EG dirSize 'C:\Program Files'   NB. then total bytes under sub-dirs.
NB.EG (((<'Files:'),[:jd[:dir '*',~ endSlash),.[: <"0 dirSize) 'C:\Program Files'
NB.EG (1 dirSize 'C:\Temp')=+/0 dirSize 'C:\Temp'
)

dropPS=: }:^:(PATHSEP_j_={:)  NB.* dropPS: drop trailing path separator
frdix=: 1!:11       NB.* frdix: file read indexed: name;(start,len)
fwrix=: 1!:12       NB.* fwrix: file write indexed: write x to >0{y at >1{y

dirlist1=: 3 : 0
NB.* dirlist1: list only directories at given path.
   y=. y,(PATHSEP_j_={:y)#'*.*'      NB. Add wildcards if last char is path sep'r.
   if. 0~:#dl=. 1!:0 y do. jd dl
   else. dl end.
)

breakupFile=: 3 : 0
NB.   flnm=. '\temp\DVD DIVx RIP ENCODE\ULEAD.DVD.WORKSHOP.V2.0.DVDR-RORiSO\ISO Image\rorudw20\uledvdw2.zip'
   'flnm pcsz'=. y
   if. fexist flnm do.
       sz0=. fsize flnm
NB.   pcsz=. 130e6
       'flpth fl'=. pathFileBreak flnm
       flpfx=. getFlPfx fl
       np=. >.sz0%pcsz
       newnms=. (<flpfx,'.'),&.>3 lead0s&.>i.>:np
       newnms=. np{.newnms-.fl
       for_pc. i. np do.
           thispc=. pcsz<.sz0-pc*pcsz
           (frdix flnm;<(pc*pcsz),thispc) fwrite flpth,>pc{newnms
       end.
       batfl=. }.;'+',&.>'"',&.>newnms,&.>'"'
       batfl=. 'copy /b ',batfl,' "',fl,'"'
       batfl fwrite flpth,'ASSEMBLE.BAT'
    end.
)

getAllFilesInfo=: 3 : 0
   tmpfl=. '\alldirs.tmp',~getTempDir ''
   z =: '' conew 'cmdtool'
NB. "dir" flag "/ta" shows time last accessed.
NB.   runcommand__z 'dir /ta /s C:\ > ',tmpfl
   if. 0=#y do. y=. 'C:\' end.
   runcommand__z 'dir /s ',y,' > ',tmpfl
   cmdtool_close__z ''
NB.   shell 'cmd /K "dir /s C:\ > ',tmpfl,'"'
  'dirnms dt sz flnms flpar'=. parseDirPieces tmpfl
NB.* 'dirnms dt sz flnms flpar'=. getAllFilesInfo ''
)

xformFileDTS=: 3 : 0
NB.* xformFileDTS: transform file Date-Times and Size info to numeric vecs.
   dtszs=. ((toJulian@cvtMDY2Y4M2D2)&.>0{y) 0}y NB. Combine DOS date and time
   dtszs=. (DOSTime2DayFrac&.>1{dtszs) 1}dtszs    NB.  into single day num.
   flDT=. +/>2{.dtszs                        NB. Files' dates and times as num
   dtszs=. ;n2j&.>2{dtszs                    NB. File sizes: char->num
   flDT;<dtszs                               NB. Date-times and sizes as vecs
NB.EG 'dt sz'=. xformFileDTS dts             NB. "dts" as in "parseDirlist"
)

parseDirPieces=: 3 : 0
NB.* parseDirPieces: parse dir list from file in pieces to minimize memory use;
NB. argument is filename[;optional chunk size].
   chsz=. 1e6 [ ix=. 0 [ stll=. 0 [ cont=. ''
   dirnms=. flnms=. '' [ dt=. sz=. flpar=. i.0
   'flnm chsz'=. 2{.(boxopen y),<chsz
   fsz=. fsize flnm
   while. ix<fsz do.
       chunk=. cont,1!:11 flnm;ix,chsz
       stll=. <:>./(|.chunk) i. CRLF    NB. Find start of last line.
       if. 0<stll do.                   NB. A partial line at end?
           chunk=. (-stll)}.chunk       NB. If so, save for next chunk.
       end.
       chunk=. l2v chunk                NB. simple vec->vec of vecs
       'dir0 dt0 sz0 fls0 fp0'=. parseDirlist chunk
       flpar=. flpar,fp0+0>.<:#dirnms   NB. These pieces could be saved
       dt=. dt,dt0 [ sz=. sz,sz0        NB.  to files instead of accumulated
       dirnms=. dirnms,dir0             NB.  as long as we keep track of #dirnms
       flnms=. flnms,fls0               NB.  and last dir name.
       cont=. CRLF,~' Directory of ',>_1{dirnms   NB. Continue with last dir
       ix=. ix+chsz-stll                          NB.  for next chunk.
       chsz=. chsz<.fsz-ix              NB. Don't go past end of file.
   end.                                 NB. while. ix<fsz ...
   dirnms;dt;sz;flnms;<flpar
NB.EG shell 'cmd /K "dir /s C:\ > \Temp\alldirs.tmp"'
NB.EG 'dirnms dt sz flnms flpar'=. parseDirPieces '\Temp\alldirs.tmp'
)

parseDirlist=: 3 : 0
NB.* parseDirlist: break down text of directory listing into components.
NB. Input is vector of lines of listing.
   y=. deb&.>y
   whnotempty=. ;y +./ . ~: &.>' '
   whparents=. (_3{.&.>y) e. '  .';' ..'
   fls=. (whnotempty+.-.whparents)#y     NB. Remove empty lines & parents
   fls=. ><;._1&.>' ',&.>fls              NB. Table of entries
   whdir=. (0{"1 fls) e. <'Directory'
   dirnms=. 2{"1 whdir#fls
   col0=. (0{"1 fls),&.><6$' '            NB. Pad to avoid index error below.
   whentry=. (<'//')e.~(<2 5){&.>col0     NB. Date in col 0->file entry
   whdirs=. (2{"1 fls)e. <'<DIR>'
   fls=. (whentry*.-.whdirs)#"|:fls
NB.   jf=. (<'//')e.~(<2 5){&.>0{"1 jfls  NB. unnecessary?
   brkup=. (1{$fls){.1 0 0 1
   'dts fls'=. brkup<;.(1) |:fls          NB. Separate numerics from names
   dts=. xformFileDTS dts                 NB. Date-Time, Size: 2 num vecs
   fls=. dtsp&.>,&.>/fls,&.>' '           NB. Vec of names
   xx=. (whentry*.-.whdirs)*.whnotempty+.-.whparents
   flparents=. <:xx#+/\whdir
NB.   whnotempty;whparents;whdir;whentry;whdirs;dirnms;dts;<fls
NB.EG   'whn whp whdir whentry whdirs dirs dts fls'=. parseDirlist f2v '\amisc\ofldinfo\ph030605_0736.dir'
   dirnms;dts,fls;<flparents
NB.EG 'dirs dts fls fp'=. parseDirlist f2v '\amisc\ofldinfo\ph030605_0736.dir'
)

chkDrv=: 3 : 0
   if. 0<#rr=. dir y,':*' do. rr=. y end.
   ,rr
)

validDrives=: 3 : 0
NB.* validDrives: find what are the valid drive letters on this machine.
   ':',~&.>a:-.~chkDrv&.>a.{~(i.26)+a. i. 'A'
)
0 : 0
validDrives=: 3 : 0
NB.* validDrives: find what are the valid drive letters on this machine.
NB.   require 'winapi'
   if. -.nameExists 'GDT' do. GDT=. 'GetDriveTypeA' win32api end.
   allLetts=. <&.>':',~&.>a. {~ (i.26)+a. i. 'A'
   valid=. 1~:;;{.&.>GDT&.> allLetts
   ;valid#allLetts
)

0 : 0
createGFA=: 3 : 0
   if. 0>4!:0 <'gfa' do.
      gfa=: 'GetFileAttributes' win32api
      [''           NB. For some reason, use of win32api requires this.
   end.
)

NB.* FILE_ATTRIBUTES: contents of file \amisc\ainfo\FILE_ATTRIBUTES.txt which
NB. comes from windows win32api.txt file
FILE_ATTRIBUTES=: 0 : 0
Const FILE_ATTRIBUTE_READONLY = &H1
Const FILE_ATTRIBUTE_HIDDEN = &H2
Const FILE_ATTRIBUTE_SYSTEM = &H4
Const FILE_ATTRIBUTE_DIRECTORY = &H10
Const FILE_ATTRIBUTE_ARCHIVE = &H20
Const FILE_ATTRIBUTE_NORMAL = &H80
Const FILE_ATTRIBUTE_TEMPORARY = &H100
Const FILE_ATTRIBUTE_COMPRESSED = &H800
)

0 : 0
fileBitsSet=: 3 : 0
NB.* fileBitsSet: show which file attribute bits are set.
NB.*   flatt=. f2v '\amisc\ainfo\FILE_ATTRIBUTES.txt'
   flatt=. l2v FILE_ATTRIBUTES
   str=. 'FILE_ATTRIBUTE_'
   dropamt=. ;(#str)+&.>I.&.>(<str) E.&.> flatt
   wordnum=. dropamt}.&.>flatt
   attribWords=. (wordnum i. &.> ' '){.&.>wordnum
NB. READONLY
NB. HIDDEN
NB. SYSTEM
NB. DIRECTORY
NB. ARCHIVE
NB. NORMAL
NB. TEMPORARY
NB. COMPRESSED
   wordVals=. ;hexcvt&.>(wordnum i. &.> '&')}.&.>wordnum
   attribWords=. attribWords /: wordVals
   wordVals=. /:~ wordVals
   max=. >:<.2^.>./wordVals

   createGFA ''
   fa=. >0{gfa boxopen y
   attbits=. (-max){.#:fa
   wh=. wordVals i. attbits # |.2^i. max
   (wh{attribWords,<'UNSPECIFIED');<attbits
NB.EG fileBitsSet 'C:\pagefile.sys'
)

0 : 0
isFileWriteable=: 3 : 0
NB.* isFileWriteable: check if file y can be written to.  Unfortunately,
NB. this still fails when file is locked by an application like Excel -
NB. how do we check this?  Do we have to actually write to the file and
NB. catch the error?
NB. No, this doesn't even work - I can write (indexed) into an open spreadsheet.
   notRO=. 0
   if. fexist y do.
       attribs=. fileBitsSet y
       notRO=. -.(<'READONLY') e. ' '-.~&.>>0{attribs
   end.
   notRO
NB.    if. notRO do.
NB.        app=. 0{a.
NB.        try.
NB.            fh=. 1!:21 <y               NB. Open file
NB.            try.
NB.                lok=. 1!:31, fh, 0,1     NB. Lock 1st byte
NB.                byte1=. 1!:11 fh,0,1     NB. Read 1st byte
NB.                byte1 1!:12 fh,0         NB. Try writing it back
NB.                lok=. 1!:32, fh,0,1      NB. unlock
NB.                1!:22 fh                 NB. Close file
NB.            catch.
NB.                0
NB.            end.
NB.        catch.
NB.            0
NB.        end.
NB.    else.
NB.        0
NB.    end.
NB.    1
)

NB.* dateFilenames: suffix filenames (before "." suffix) with YYMMDD date,
NB. e.g. file051209.txt.
dateFilenames=: 3 : 0
   fldir=. endSlash fldir [ 'fldir flregex'=. y
NB.    dd=. '\Global\FoF\Competition\'
NB.    fls=. dir dd,'*.xls'
   fls=. dir fldir,flregex         NB. Get files' info: names, dates, etc.
NB. Assume any filename with 6 digits at end of prefix is already dated.
   whundated=. _1=({.^:2)&>(<'[0-9]{6}') rxmatch&.>{."1 fls
   'nms dts'=. <"1 |:2{."1 whundated#fls     NB. Just the names and dates
   pfxlen=. nms i:&>'.'
   dtsuff=. ;&.> 2 lead0s&.>&.>(100"_|3:{.])&.>dts
   newnms=. (pfxlen{.&.>nms),&.>dtsuff,&.>pfxlen}.&.>nms
   cmds=. (<'ren "'),&.>nms,&.>(<'" "'),&.>newnms,&.>'"'
   cmds=. ('cd "',dd,'"');cmds     NB. Put rename commands in .bat file
   cmds v2f batfl=. (getTempDir''),'renWDt.bat'
   rc=. shell 'cmd /c ',batfl
   33=>{.rc
NB.EG dateFilenames 'C:\repeated\';'data*.xls'
)

coclass 'base'

NB. Usually what I want to do:
usualUse=: 0 : 0
   6!:2 'rr=. a:-.~'''' lookUnder ''c:/ClarifiWork/2019.02/Vendors/XFv5/SQL Server'''
   6!:2 '(3 : ''shell ''''rmxs && del "#*#" && del ".#*"''''[chgToDir y'')generalWalkTree ''C:'''
   6!:2 '(3 : ''shell ''''del pspbrwse.jbf && del FlipScript*.ijs && del time?.out''''[1!:44 y'')generalWalkTree ''C:\Users\Owner\AppData\Local\Microsoft\Windows\Burn'''
   ;LF,~&.>(;rr)#~-.+./&>(<'Archive') E. &.>;rr
   rr=. ('.DLL'&findFile) generalWalkTree 'C:'
   rr=. (;rr)#~-.+./&>(<'Archive') E. &.>;rr
   ;LF,~&.>;rr [ smoutput (#;#&>;[:+/#&>)rr [ smoutput 6!:2 'rr=. a:-.~''{string}'' (toupper lookUnderAdv) ''c:/amisc'''
   6!:2 'rr=. a:-.~''{string}'' lookUnder ''c:/amisc'''
   (#;#&>;[:+/#&>)rr
   ;LF,~&.>;rr
   ;LF,~&.>;rr [ smoutput (#;#&>;[:+/#&>)rr [ smoutput 6!:2 'rr=. a:-.~''{string}'' lookUnder ''c:/amisc'''
   coinsert 'fldir'
)

NB.* Only invoke if loaded via interactive session.
3 : 0 ] ''
   maxLen=. >./ #&>possib=. '-jijx';'-rt'
   if. -. (0:"_ <: [: 4!:0 <^:(L. = 0:)) 'IsFORKED' do. IsFORKED=: 0 end.
   if. -. IsFORKED +. (maxLen{.&.>possib) +./ . e. maxLen&{.&.>tolower&.>ARGV_z_ do.
       smoutput usualUse
   end.
)
