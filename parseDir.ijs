NB.* ParseDir.ijs: tools to parse dir listing->backup most recently changed.
NB. Look for command-line arguments SZLIM (max bytes to backup) and TARGDIR
NB. (target directory to which to write backups).

load '~Code/locationInfo.ijs'   NB. On which machine are we running?  Which external drives?
require '~Code/parallelParseDir.ijs'
require '~Code/exclusions.ijs'

NB. require 'csv task WS'
require 'WS'
coinsert 'jtask'

coclass 'parseDir'
require 'jmf files dir dt logger filefns task'
coinsert 'base fldir'
USUVARS=: 'FLNMS';'FLDTS';'FLSZS';'FLPARENT';'DIRNMS';'DIRDEP'

NB.* buildTimedDiskInfo: build files' info vecs in separate namespace for given disk.
NB.* subdirSzs: show directory sizes for all sub-dirs at specified dir.
NB.* successiveRplc: apply pairs of replacements }.y to >{.y .
NB.* findSlash: find which slash is being used in boxed items.
NB.* jpathsep: change backslashes to slashes in a path.
NB.* dospathsep: change forward slashes to backslashes in a path.
NB.* sizeDirs: Add up sizes of all files in directories and all sub-dirs.
NB.* sumSizesSubdirs: sum file sizes in named dir and all sub-dirs.
NB.* accumSubdirs: accumulate dir indexes for dir named and all sub-dirs.
NB.* crDirLog: create directory log file in \amisc\OfldInfo for drive spec'd.
NB.* nameSpan: given 2 names like pfxYYYYMMDD, combine->pfxYYYYMMD1-D2.
NB.* consolidateBkpsTowardPast: copy all contents of successive dirs into earliest starting with oldest->consolidated backups with newest version overwriting older ones.
NB.* buildBatFl: build .BAT file to create target dirs and copy files to them.
NB.* indicateSubdirs: from boolean selecting DIRNMS, indicate all subdirs.
NB.* rmEndSep: remove terminal path separator from string.
NB.* excludeFiles: exclude designated files from list to back up.
NB.* dix2FullPath: dir index -> indexes for full path
NB.* getDirFlInfo: get info on dirs and files starting at node specified.
NB.* cvtDt2Num: convert Y M D h m s date to single num: YYYYMMDD.day fraction.
NB.* initFlsDir: parse memory-mapped file of directory listing->file, dir info.
NB.* getInfo: get directory into into file, memory-map and parse it.
NB.* process1Subdir: parse single subdir entry->files, parent dirs as globals.
NB.* extract1SubdirList: get first full sub-directory listing out of many.
NB.* addPath: put new parent/child index in tree from text of "dir/subdirs..."
NB.* Tst0addPath_tests_: test adding path to index vec tree from text.
NB.* mcopyto: text of DOS .BAT file to do multiple copies.
NB.* setTargetDir: figure target directory based on machine on which we run.
NB.* setGlobalParms: assign globals according to defaults or command-line overrides.
NB.* NYto01: convert 'N' or 'Y' to 0 or 1, respectively.
NB.* runFromSavedVars: Run backup assuming dir&file vars already saved.
NB.* sizeDirs: Add up sizes of all files in directories and all sub-dirs; x is sort column.
NB.* sumSizesSubdirs: sum file sizes in named dir and all sub-dirs.
NB.* accumSubdirs: accumulate dir indexes for dir named and all sub-dirs.
NB.* crDirLog: create directory log file in \amisc\OfldInfo for drive spec'd.
NB.* nameSpan: given 2 names like pfxYYYYMMDD, combine->pfxYYYYMMD1-D2.
NB.* consolidateBkpsTowardPast: copy all contents of successive dirs into
NB.* buildBatFl: build .BAT file to create target dirs and copy files to them.
NB.* indicateSubdirs: from boolean selecting DIRNMS, indicate all subdirs.
NB.* excludeFiles: exclude designated files from list to back up.
NB.* dix2FullPath: dir index -> indexes for full path
NB.* fmtNumComma3: format (literal) number w/commas after each group of 3.
NB.* dirInfo: put directory info in more usable format: names, dates, sizes, dir flag.
NB.* getDirFlInfo: get info on dirs and files starting at node specified.
NB.* getDirFlInfo: get info on dirs and files starting at node specified.
NB.* cvtDt2Num: convert Y M D h m s date to single num: YYYYMMDD.day fraction.
NB.* initFlsDir: parse memory-mapped file of directory listing->file, dir info.
NB.* getInfo: get directory info into file, memory-map and parse it.
NB.* process1Subdir: parse single subdir entry->files, parent dirs as globals.
NB.* extract1SubdirList: get first full sub-directory listing out of many.
NB.* addPath: put new parent/child index in tree from text of "dir\subdirs..."
NB.* Tst0addPath_tests_: test adding path to index vec tree from text.
NB.* mcopyto: text of DOS .BAT file to do multiple copies.
NB.* setTargetDir: figure target directory based on machine on which we run.
NB.* setGlobalParms: assign globals according to defaults or command-line overrides.
NB.* dailyBackup: run backup for today.
NB.* runFromSavedVars: Run backup assuming dir&file vars already saved.
NB.* getCmdlnArgs: get named arguments from command line.
NB.* runBackup: run usual backup of main drive.
NB.* onlyRuntime: only invoke this if not loaded via usual interactive session.

NB.* buildTimedDiskInfo: build files' info vecs in separate namespace for given disk.
buildTimedDiskInfo=: 3 : 0
   dskNm=. y  NB.EG y= 'Z'
   nms=. ;:'FLNMS FLDTS FLSZS FLPARENT DIRNMS DIRDEP'
   exeExp=. (1|.'''''',}:;nms,&.><'_',dskNm,'_ '),'=. PllDirInfoEG ''',dskNm,':\'''
   '''',~'6!:2 ''','''' (] #~ [: >: =) exeExp
NB.EG ". buildTimedDiskInfo 'D' NB. Build vecs "FLNM_D_" etc.
)

checkFork=: 3 : 0
   svIF=. _1
   if. nameExists 'IsFORKED' do. svIF=. IsFORKED end.
   IsFORKED=: y
   svIF
)
svIF=. checkFork 1

DEBUGON=: 0         NB. Show messages as program progresses (1) or don't (0).
DBGFL=: BASEDSK,'/Temp/parseDir.tmp'          NB. These 3 things allow logging at load
sepLF=: 13 : ';((": :: ])y),10{a.'      NB.  time: DBGFL (log file), sepLF, and
fappendDHM=: 4 : '(,x) (#@[ [ 1!:3) :: _1: (([: < 8 u: >) ::]) y'     NB. this.
3 : 0 ''
   if. DEBUGON do. (;sepLF&.>'parseDir.ijs:23';ARGV_j_,<6!:0 '') fappendDHM DBGFL end.
)

PATHSEP_j_=: '/'
jpathsep=: '/'&(('\' I.@:= ])})
dospathsep=: '\'&(('/' I.@:= ])})

NB.* subdirSzs: show directory sizes for all sub-dirs at specified dir.
subdirSzs=: 3 : 0
   y=. endSlash y
   if. '/' e. >{.DIRNMS do. y=. y rplc '\/' end.       NB. Ensure correct slash
   szs=. sizeDirs y
   szsTop=. (2{.szs),szs#~('/'+/ . =y)='/'+/ . =&>2{"1 szs
NB.EG subszs=. subdirSzs 'C:\amisc\pix\Photos'
)

NB.* successiveRplc: apply pairs of replacements }.y to >{.y .
successiveRplc=: [: > 0 { ((([: > {.) rplc 2 {. }.) ; 3 }. ])^:_
NB.* findSlash: find which slash is being used in boxed items.
findSlash=: [: ~. [: ; ] -.&.> (<'/\') -.&.>~ ]
NB.* sizeDirs: Add up sizes of all files in directories and all sub-dirs; x is sort column.
sizeDirs=: 3 : 0
NB.  Assume globals 'FLNMS FLDTS FLSZS FLPARENT DIRNMS DIRDEP'=. PllDirInfoEG rootdir
   1 sizeDirs y   NB. Col 2 default sort
:
   if. -. nameExists 'DIRNMS' do. 'FLNMS FLDTS FLSZS FLPARENT DIRNMS DIRDEP'=: PllDirInfoEG y end.
   y=. endSlash y
   if. '/' e. >{.DIRNMS do. y=. y rplc '\/' end.       NB. Ensure correct slash
   if. (#DIRNMS)=top=. DIRNMS i. <y do. top=. DIRNMS i. <}.y end.  NB. Allow for terminal slash or not.
   assert. top<#DIRNMS   NB. Ensure y found in DIRNMS
   whamsd=. top,I. (DIRNMS{.~&.>#y) e. <y    NB. WHere Are Main Sub-Dirs (of parent)?
   noFiles=. I. -.(i.#DIRNMS) e. FLPARENT
NB. Account for dirs w/no files in them.
   flparent=. FLPARENT,noFiles [ flnms=. FLNMS,noFiles{DIRNMS [ flszs=. FLSZS,0$~#noFiles
   key=. flparent#~choose=. flparent e. whamsd
   chszs=. key +//. choose#flszs
   dkey=. ~.top,key [ chszs=. chszs,~(-.top e. key)#+/chszs
   tit=. '@dir';'w/subdirs';'Directory'
   x=. 0>.1<.<.x    NB. 0 or 1 are allowable sort columns; put #s first, directories last.
   dirinf=. tit,":&.>x(] \: [: ; [{"1 ])(dkey{DIRNMS),.~(<"0 chszs),.sumSizesSubdirs&.>dkey{DIRNMS
   dirinf=. ((-0{szs){.&.>0{"1 dirinf) 0}&.|:dirinf [ szs=. >./#&>dirinf
   dirinf=. ((-1{szs){.&.>1{"1 dirinf) 1}&.|:dirinf    NB. Right-align numeric columns
)
sizeDirs_Usage_=: 0 : 0
(sizeDirs 'G:\amisc') writedsv 'GamiscDirsSzs120221.txt';TAB;''
sz=. sizeDirs 'Z:\'
maxcol=. 4 : '((->./#&>x{"1 y){.&.>x{"1 y) x}&.|:y'
sz=. 1 maxcol sz [ sz=. 0 maxcol sz  NB. Align "number" columns
(;LF ([ ,~ [: }: [: ; ])&.><"1 sz,&.><TAB) fwrite 'ZdirsFlsSzs.txt'
)

NB.* sumSizesSubdirs: sum file sizes in named dir and all sub-dirs.
sumSizesSubdirs=: 3 : '+/FLSZS#~FLPARENT e. accumSubdirs y'
NB.* accumSubdirs: accumulate dir indexes for dir named and all sub-dirs.
accumSubdirs=: 3 : 0
   down1=. all=. DIRNMS i. boxopen y
   while. 0<#down1=. I. DIRDEP e. down1 do. all=. all,down1 end.
   all
NB.EG subdixs=. accumSubdirs 'V:/Recent/utl'
)

NB.* crDirLog: create directory log file in \amisc\OfldInfo for drive spec'd.
crDirLog=: 3 : 0
   y=. {.y,'D'                NB. Drive, e.g. D:, for which
   y=. (],':' #~ ':'~:{:)y    NB.  to create log file.
   1!:44 BASEDSK,'\amisc\ofldinfo\' [ svdir=. 1!:43 ''
   lognm=. '.dir',~>_1{<;._1 ' ',(]{.~i.&LF) CR-.~shell 'dir ',y
   shell 'dir /o-d /s ',BASEDSK,'\ > "',lognm,'"'
   1!:44 svdir
)

NB.* nameSpan: given 2 names like pfxYYYYMMDD, combine->pfxYYYYMMD1-D2.
nameSpan=: 3 : 0
NB. y=. ({:,{.) dd  NB. Earliest, latest
   endlast=. 1 i.~ ~:/>y
   (>0{y),'-',endlast}.>1{y
)

consolidateBkpsTowardPast=: 3 : 0
NB.* consolidateBkpsTowardPast: copy all contents of successive dirs into
NB. earliest starting with oldest->consolidated backups with newest version
NB. overwriting older ones.
   y=. 2{.boxopen y         NB. Files' prefix, dir in which to work
   pfx=. openbox {.y         NB. Prefix is "WL" for laptop, "WD" desktop
   if. 0=#>1{y do.
       wrkdir=. BASEDSK,'/Temp/'
   else. wrkdir=. endSlash >1{y
   end.
   dd=. jd dir wrkdir,'*.'   NB. Just directories
   dd=. (<pfx,'[0-9]{8}$') rxfirst&.>dd   NB. Only names like {pfx}YYYYMMDD
   dd=. \:~dd-.a:             NB. Order from most to least recent.
NB.    if. -.nameExists 'WTTMINC_TMP_' do.
NB.        WTTMINC_TMP_=. 2 1     NB. Add 1 sec to each subsequent wait
NB.    end.
   if. nameExists 'TOPDIR' do. svTD=. TOPDIR end.
   TOPDIR=: (wrkdir rplc '/\';'\') rplc '/\'
   2 moveDirOverAnother/\dd
   newnm=. nameSpan ({:,{.) dd
   cmd=. (TOPDIR{.~>:TOPDIR i. ':'),' && cd ',(TOPDIR}.~>:TOPDIR i. ':'),' && '
   cmd=. ((cmd,'ren "',(>{:dd),'" "',newnm,'"') rplc '/\';'\') rplc '/\'
   shell cmd
   if. nameExists 'svTD' do. TOPDIR=: svTD   NB. Re-instate or
   else. 4!:55 <'TOPDIR' end.                NB.  remove global.
   newnm
NB.EG consolidateBkpsTowardPast 'ciqRB';'C:/Temp/WrkDesk/'
)

consolidateBkpsTowardPast_testCase_=: 3 : 0
   drnms=. (<y),&.>(<'HLL201206'),&.>_2{.&.>'0',&.>":&.>>:i.30
   flnms=. (<'/file'),&.>(":&.>>:i.#drnms),&.><'.txt'
   ({.,{:) cmds=. (<'echo '),&.>(":&.>(#drnms)?@$1e9),&.>'>',&.>drnms,&.>flnms
   assert. a:*./ . =rr=. shell&.>(<'mkdir '),&.>drnms rplc &.><'/\'
   assert. a:*./ . =rr=. shell&.>cmds
   consolidateBkpsTowardPast_base_ 'HLL';y
   assert. dirExists_base_ y,'/HLL20120601-30'
   assert. *./fileExists_base_ &> (<y,'/HLL20120601-30'),&.>flnms
NB.EG consolidateBkpsTowardPast_testCase_ 'D:/Temp/amisc/Tmp/'
)

cleanupConsolidateBkpsTowardPast_testCase_=: 3 : 0
   drnms=. (<y),&.>(<'HLL201206'),&.>_2{.&.>'0',&.>":&.>>:i.30
   drnms=. drnms rplc&.><'/\'
   shell&.>(<'del /Q /S '),&.>drnms
   shell&.>(<'rmdir '),&.>drnms
NB.EG a:*./ . =cleanupConsolidateBkpsTowardPast_testCase_ 'D:/Temp/amisc/Tmp/'
)

NB. KMPFX, KNMACH from locationInfo.ijs
machid=. >KMPFX{~KNMACH i. {.whoami ''       NB. Tailor commands to machine on which we're running.
todayDt=. ([: ; ([: ": {.) ; [: 2&lead0s 1 2&{) qts''

NB. Display commonly-used set of commands in usual sequence; EXTERNDRV from locationInfo.ijs
usuReminder=: (0 : 0) rplc '{todayDt}';todayDt;'{machid}';machid;'{xdrv}';EXTERNDRV
". buildTimedDiskInfo }:BASEDSK
". buildTimedDiskInfo 'D'
nms=. USUVARS
(<'/Temp/') fileVar_WS_&.>,|:USUVARS,&.>/('_',(}:BASEDSK),'_');'_D_'
FLNMS_CD_=: FLNMS_C_,FLNMS_D_
FLPARENT_CD_=: FLPARENT_C_,(#DIRNMS_C_)+FLPARENT_D_
FLDTS_CD_=: FLDTS_C_,FLDTS_D_
FLSZS_CD_=: FLSZS_C_,FLSZS_D_
DIRNMS_CD_=: DIRNMS_C_,DIRNMS_D_
DIRDEP_CD_=: DIRDEP_C_,(#DIRNMS_C_)+DIRDEP_D_
(<'/Temp/') fileVar_WS_&.>USUVARS,&.><'_CD_'
6!:2&.>'''batfl cmds''=. (".&.>USUVARS,&.><''_CD_'') buildBatFl_parseDir_ 10e6;(BASEDSK,''/Temp/{machid}{todayDt}/'');'''';<''CDMCCopyE.bat''';'shell batfl'
6!:2&.>'''batfl cmds''=. (".&.>USUVARS,&.><''_CD_'') buildBatFl_parseDir_ 50e6;''D:\''';'shell batfl'
6!:2&.>'''batfl cmds''=. (".&.>USUVARS,&.><''_CD_'') buildBatFl_parseDir_ 30e6;''Z:\''';'shell batfl' NB. Backup drive
6!:2&.>'''batfl cmds''=. (".&.>USUVARS,&.><''_D_'') buildBatFl_parseDir_ 10e6;(BASEDSK,''/Temp/{machid}{todayDt}/'');'''';<''CDMCCopyE.bat''';'shell batfl'
6!:2&.>'''batfl cmds''=. (".&.>USUVARS,&.><''_D_'') buildBatFl_parseDir_ 50e6;''D:\''';'shell batfl'
6!:2&.>'''batfl cmds''=. (".&.>USUVARS,&.><''_D_'') buildBatFl_parseDir_ 30e6;''Z:\''';'shell batfl' NB. Backup drive
6!:2&.>'''batfl cmds''=. (".&.>USUVARS,&.><''_D_'') buildBatFl_parseDir_ 20e6;''J:\''';'shell batfl'

str=. 'shell ''xcopy ',BASEDSK,'\Temp\{machid}{todayDt} {dsk}:\Temp\{machid}{todayDt} /S /C /H /I /R /Q /Y'''
6!:2 '".&>(<str) rplc&.><"1 (<''{dsk}''),.''D'';''G'';''H'';''Z'''

80 (] {."1~ [ <. [: {: [: $ ]) ":,.rr=. ".&.>_2}.<;._2 usuReminder [ smoutput qts'' NB. Max 80 cols display
usuReminder=: usuReminder rplc ' :';'_:'
)

3 : 0 ] svIF
   if. y=_1 do. 4!:55 <'IsFORKED' else. IsFORKED=: y end.
)

3 : 0 ] usuReminder;svIF
   if. _1=>1{y do. IsFORKED=: 0 end.
   ml=. >./ #&>possib=. '-jijx';'-rt'
   if. -. IsFORKED +. (ml{.&.>possib) +./ . e. ml&{.&.>tolower&.>ARGV_z_ do.
       smoutput >0{y end.
   if. _1=>1{y do. 4!:55 <'IsFORKED' end.
)

buildBatFl=: 3 : 0
NB.* buildBatFl: build .BAT file to create target dirs and copy files to them.
   (FLNMS;FLDTS;FLSZS;FLPARENT;DIRNMS;<DIRDEP) buildBatFl y
:
   'szlim targ DescAsc batflnm'=. 4{.y   NB. 'batflnm' is optional
   'FLNMS FLDTS FLSZS FLPARENT DIRNMS DIRDEP'=. x
   if. 0=#DescAsc do. DescAsc=.'D' end.   NB. Dates in descending order by default.
   targ=. endSlash targ
   xclud=. (FLNMS;FLPARENT;DIRNMS;<DIRDEP) excludeFiles targ
   if. 'D'-:DescAsc do. dtdord=. xclud-.~\:FLDTS  NB. File list indexes in date desc. order
   else. dtdord=. xclud-.~/:FLDTS end.            NB.  or date ascending (oldest first) order.
   ix=. FLSZS figureWhichFiles szlim;<dtdord
   NB. 0{DIRNMS, up to ':', gives disk from which to copy.
   cmds=. (<'//';'/') rplc~&.>(<({.~>:@:i.&':');0{DIRNMS),(FLNMS;FLPARENT;<DIRNMS) makeCopyCmds targ;<ix
   cmds=. dospathsep &.> cmds
   tmpd=. getTempDir ''
   cmds v2f batfl=. tmpd,>(4<:#y){'CDMDCopy.bat';<batflnm
   batfl;<cmds
NB.EG 'batfl cmds'=. buildBatFl 700e6;'C:\Temp\Recent\'
)

figureWhichFiles=: 3 : 0
   FLSZS figureWhichFiles y
:
   'szlim dtdord'=. y   NB. szlim: max,[min] size to copy.
   FLSZS=. x
   if. 2=#>szlim do. szlim=. {:lims=. \:~>szlim else. lims=. szlim,0 end.
   toobig=. szlim<:dtdord{FLSZS    NB. Exclude any single file > size limit
   toobig=. toobig#dtdord          NB.  as this will truncate list prematurely.
   dtdord=. dtdord-.toobig
   ss=. +/\dtdord{FLSZS
   selection=. (ss>:{:lims)*.ss<:{.lims
NB. Do better job noting which files excluded because too big; the following
NB. fails to account for cutoff.
   if. DEBUGON do.
       pl=. 's'#~1~:#toobig
       logMsg_logger_ 'Excluding file',pl,' singly > size limit: ',":#toobig
   end.
   selection#dtdord
)

locChildren=: 3 : 0
   DIRDEP locChildren y
:
   (<^:(L. = 0:)y),~(<#~0~:#) I. x e. >0{y
)

indicateSubdirs=: 3 : 0
   DIRDEP indicateSubdirs y
:
   ~.;;x&locChildren^:_&.>I. y
)

indicateSubdirs0=: 3 : 0
NB.* indicateSubdirs: from boolean selecting DIRNMS, indicate all subdirs.
   xdix=. I. y
   childxd=. xdix-.~I. DIRDEP e. xdix
   while. 0<#childxd do.
       xdix=. ~.xdix,childxd
       childxd=. xdix-.~I. DIRDEP e. xdix
   end.
   xdix                       NB. Index into DIRNMS of all subdirectories.
NB.EG xdix=. indicateSubdirs DIRNMS e. 'c:/amisc';'c:/Program Files'
)

excludeFiles=: 3 : 0
NB.* excludeFiles: exclude designated files from list to back up.
   (FLNMS;FLPARENT;DIRNMS;<DIRDEP) excludeFiles y
:
   'targ xd xf'=. extractExclusions y
   'FLNMS FLPARENT DIRNMS DIRDEP'=. x
   if. 0 *./ . =#&>xd;<xf do. xclud=. i.0 else.
       assert. 1=#ps=. '\/'#~'\/' e. ;DIRNMS     NB. Path Separator being used.
       whxd=. DIRNMS}.~&.>(2*;':'e.&.>DIRNMS)*;DIRNMS i.&.>':'  NB. Drop disk
       whxd=. (toupper&.>whxd)e. ({.ps),&.>toupper&.>xd,<targ   NB. Exclude target
       whxd=. (1) (DIRDEP indicateSubdirs whxd)}whxd         NB.  to avoid recursion.
       whxf=. (toupper&.>FLNMS)e. toupper&.>xf        NB. Exclude files.
       whxf=. whxf+.({.xf)e.~(#>{.xf){.&.>FLNMS       NB. No *~ (emacs save) files.
       xf=. toupper&.>xf#~(2{.&.>xf)e. <'*.'          NB. Simple wild-card:
       xf=. '.' (]}.~[:>:]i.[)&.>xf                   NB. just suffixes.
       whxf=. whxf+.xf e.~toupper&.>'.'(]}.~[:>:]i:[)&.>FLNMS NB. Final .suffixes
       xclud=. I. whxf+.FLPARENT e. I. whxd
   end.
NB. xclud is list of indexes into FLNMS=files to exclude.
)

NB.* dix2FullPath: dir index -> indexes for full path
dix2FullPath=: [ (] ,~ _1 -.~ [ {~ [: {. ])^:_ [: ] ]
NB.EG DIRPARENT&dix2FullPath 239
NB.* fmtNumComma3: format (literal) number w/commas after each group of 3.
fmtNumComma3=: ([: }: [: ; ',' ,~&.> [: |. [: |.&.> _3 <\ |.)"1
NB.EG ('123';'1,234';'1,234,567') -: fmtNumComma3 &.> '123';'1234';'1234567'

showDFSzDt=: 3 : 0
  ((;&.>'\',~&.>&.>(<DIRNMS){~&.>DIRPARENT&dix2FullPath &.> y{FLPARENT),&.>y{FLNMS),.((fmtNumComma3@:":)&.>y{FLSZS),.DateTimeCvt&.>y{FLDTS
)

NB.* dirInfo: put directory info in more usable format: names, dates, sizes, dir flag.
dirInfo=: ([:((0{"1]) ; ([:>1{"1]) ; ([:;2{"1]) ; [:<'d'e.&>4{"1]) dir)

getDirFlInfo=: 3 : 0
NB.* getDirFlInfo: get info on dirs and files starting at node specified.
   dskInf=. >(];[: dirInfo '\*',~]) generalWalkTree rmEndSep y
   DIRNMS=: dospathsep&.>0{"1 dskInf NB. Full names of all paths
   DIRNMS=: DIRNMS rplc&.><'\\';'\'  NB. '\\'->'\'
   DIRDEP=: dirDependencies DIRNMS NB. Dirs' dependency tree: parent indexes
   isfl=. -.;4{"1 dskInf           NB. Exclude dir info->only files.
   FLNMS=: isfl#;1{"1 dskInf
   ned=. 0~:#&>2{"1 dskInf         NB. No empty directories
   FLDTS=: isfl#;cvtTS21Num &.>ned#2{"1 dskInf    NB. Date as single num: YYYYMMDD.day fraction
   FLSZS=: isfl#;3{"1 dskInf       NB. File size in bytes.
   FLPARENT=: isfl#;(#&.>3{"1 dskInf)#&.>i.#DIRNMS
   FLNMS;FLDTS;FLSZS;FLPARENT;DIRNMS;<DIRDEP
)

getDirFlInfo0=: 3 : 0
NB.* getDirFlInfo: get info on dirs and files starting at node specified.
   tree=. dirtree y
   fpths=. (}.~(<:@-@(i.&PATHSEP_j_)@|.))&.>0{"1 tree  NB. Paths w/o filenames.
   DIRNMS=. dirpath y             NB. All dirs - even those with no files
   DIRDEP=: dirDependencies DIRNMS=. ~.DIRNMS,~.fpths  NB. Dir dependency tree
   FLPARENT=: DIRNMS i. fpths                          NB. Parent dirs of files
   assert. FLPARENT *./ . <#DIRNMS                     NB. Found all paths?
   FLNMS=. ((>:@#)&.>fpths)}.&.>0}"1 tree              NB. bare filenames
NB.   FLDTS=: ;100#.&.>3{.&.>1{"1 tree                NB. Num yyyymmdd dates
NB.   max=. 5+24 60 60#.24 60 60 NB. Max secs/day + 5 for any leap seconds.
NB.   FLDTS=: FLDTS+max%~;(<24 60 60)#.&.>_3{.&.>1{"1 tree
   FLDTS=: ;cvtDt2Num >1{"1 tree        NB. Num YYYYMMDD.(day fraction) dates
   FLSZS=: ;2{"1 tree                   NB. Very large files have signed sizes
   FLSZS=: FLSZS+(2^32)*FLSZS<0         NB.  so adjust them.
   FLNMS;FLDTS;FLSZS;FLPARENT;DIRNMS;<DIRDEP
NB.EG 'FLNMS FLDTS FLSZS FLPARENT DIRNMS DIRDEP'=: getDirFlInfo_parseDir_ 'C:\'
)

NB.* cvtDt2Num: convert Y M D h m s date to single num: YYYYMMDD.day fraction.
cvtDt2Num=: 3 : 0"1
   NB. 90065 = 5 + 24 60 60#.24 60 60 NB. Max secs/day+5 fudge for leap secs.
   (100#.3{.y)+90065%~24 60 60#._3{.y
NB.EG ' 20090803.32600899' -: 18j8":cvtDt2Num 2009 8 3 8 9 22
)
NB. Only distinguishes to about 1/10,000 second.

DOMAP=: 1
NB. -------- Dir listing fns: parse text file directory listing:
NB. -------- this is a separate way to accomplish what has been done above.
initFlsDir=: 3 : 0
NB.* initFlsDir: parse memory-mapped file of directory listing->file, dir info.
   if. DOMAP do. JCHAR map_jmf_ 'DIRLSTFL';y-.CR
   else.  DIRLSTFL=: CR-.~fread y end.
   DBSTR=: LF,' Directory of '
   WHDB=: (I. DBSTR E. DIRLSTFL),<:#DIRLSTFL NB. Where directory breaks are
   DIRNMS=: FLNMS=: ''
   FLSZS=: DIRPARENT=: FLPARENT=: i.0
   FLDTS=: 0$0.0
)

3 : 0 ''
   if. DEBUGON do. (;sepLF&.>'parseDir.ijs:465';<6!:0 '') fappendDHM DBGFL end.
)

getInfo=: 3 : 0
NB.* getInfo: get directory info into file, memory-map and parse it.
NB.   shell 'cmd /C dir /A /S C:\ > C:\allfls2.dir'
   dirlstfl=. y
   if. 0=#dirlstfl do.
       dirlstfl=. 'D:\allfls2.dir'
       shell 'dir /A /S D:\ > ',dirlstfl
   end.
   initFlsDir dirlstfl
   for_ix. i.<:#WHDB do.
       ch=. extract1SubdirList WHDB{~ix+0 1
       process1Subdir ch
   end.
   if. DOMAP do. unmapall_jmf_ '' end.
   assert. *./nameExists&>nms=. 'FLNMS';'DIRNMS';'FLPARENT';'FLSZS';'FLDTS';'DIRPARENT'
   nms
)

process1Subdir=: 3 : 0
NB.* process1Subdir: parse single subdir entry->files, parent dirs as globals.
   ch=. a:-.~<;._2 (LF#~-.LF={:y),~y    NB. break into lines; no empty lines
   whd=. (ch{.~&.><:#DBSTR) i. <DBSTR-.LF
   thisdir=. (] }.~ [: <: ':' i.~ ]) >whd{ch
   'isnew thisdn'=. addPath thisdir
   ch=. }:ch}.~>:whd               NB. Drop dir info header and summary trailer.
   ch=. ch#~' '~:;{.&.>ch          NB. Get rid of lines beginning with space.
   ch=. <;._1&.>' ',&.>dsp&.>ch    NB. break apart lines by spaces
NB. Account for time variants: '12:34a' vs. '12:34 AM'.
   whnms=. 3+time2pcs=. *./(2{"1 >ch) e. 'AM';'PM'
NB. re-join any names with embedded spaces
   ch=. |:>(whnms{.&.>ch),&.><&.>(}.@;)&.>(' '&,)&.>&.>whnms}.&.>ch
   if. time2pcs do. ch=. (([: }:&.> [: ,&.>/ ' ' ,~&.> 1 2 { ]) 1} (<<<2) { ]) ch end.   
   chtit=. 'DATE';'TIME';'SIZE';'NAME'  NB. row titles for "ch"
   whmootdirs=. (ch{~chtit i. <'NAME')e. ,&.>'.';'..'
NB. "SIZE" column has "<DIR>" indicator for directory, size for file.
   whdir=. ((ch{~chtit i. <'SIZE') e. '<DIR>';'<JUNCTION>')*.-.whmootdirs
   addPath&.>(<thisdir,'\'),&.>whdir#ch{~chtit i. <'NAME'
   whfls=. -.whdir+.whmootdirs
   ch=. whfls#"1 ch
   FLNMS=: FLNMS,ch{~chtit i. <'NAME'
   FLPARENT=: FLPARENT,(+/whfls)$thisdn
   FLSZS=: FLSZS,;n2j&.>(ch{~chtit i. <'SIZE')-.&.>','
   FLDTS=: FLDTS,;DateTimeCvt &.>,&.>/' ',&.>ch{~chtit i. 'DATE';'TIME'
   thisdn
)

extract1SubdirList=: 3 : 0
NB.* extract1SubdirList: get first full sub-directory listing out of many.
   'st end'=. y
   ch=. CR-.~(st+i.>:end-st){DIRLSTFL
)

addPath=: 3 : 0
NB.* addPath: put new parent/child index in tree from text of "dir\subdirs..."
   p2a=. <;._1 '\',y    NB. Path to add, e.g. 'C:\top\mid\bottom'
   p2a=. p2a-.a:
   isnew=. 0
NB.    if. 0=#wh=. I. DIRNMS e. 0{p2a do.  NB. Completely new root
NB.        DIRPARENT=: DIRPARENT,_1    NB. "Parent Index" of _1 means root node.
NB.        wh=. <:#DIRNMS=: DIRNMS,0{p2a
NB.        isnew=. 1
NB.    else. wh=. {.wh#~_1=wh{DIRPARENT end.     NB. or same old root
   wh=. _1
   for_nm. p2a do.                 NB. "wh" is parent index of current node...
       if. 0=#wh2=. I. DIRNMS e. nm do. NB. new subdir
           DIRPARENT=: DIRPARENT,wh
           wh=. {.<:#DIRNMS=: DIRNMS,nm NB. will be parent of next node, if any
           isnew=. 1
       else.
           if. 0=#wh2=. wh2#~wh=wh2{DIRPARENT do. NB. Name exists but with
               DIRPARENT=: DIRPARENT,wh           NB.  different parent.
               wh=. {.<:#DIRNMS=: DIRNMS,nm
               isnew=. 1
           else. wh=. {.wh2 end.                  NB. Name exists with
       end.                                       NB.  same parent
   end.
   isnew,wh                              NB. 0 if path was already here
)

Tst0addPath_tests_=: 3 : 0
NB.* Tst0addPath_tests_: test adding path to index vec tree from text.
   coinsert 'parseDir base'
   EV=: getEnviVars ''
   WINDIR=: endSlash ,>EV{~<1,~(toupper&.>0{"1 EV)i.<'WINDIR'
   
   d0=. DIRNMS=: 'D:';'Aegis';('\'-.~WINDIR}.~WINDIR i. '\');'Web';'printers';'foo';'Web'
   dp0=. DIRPARENT=: _1 0 0 3 4 0 0

   assert. 0 2-:addPath WINDIR     NB. Shouldn't add it again.
   assert. d0-:DIRNMS              NB. Should not have changed
   assert. dp0-:DIRPARENT          NB. Should not have changed

   td=. 'D:\foo\bar'               NB. New path starting from new root
   assert. 1 9-:addPath td         NB. but with same-named sub as existing
   assert. (d1=. DIRNMS)-:d0,<;._1 '\',td
   assert. (dp1=. DIRPARENT)-:_1 0 0 0 3 4 0 0 _1 8 9
   assert. 0 9-:addPath td    NB. Shouldn't add it again.
   assert. d1-:DIRNMS         NB. Should not have changed
   assert. dp1-:DIRPARENT     NB. Should not have changed

   assert. 1 10-:addPath WINDIR,'foo'
   1
)

NB.* mcopyto: text of DOS .BAT file to do multiple copies.
mcopyto=: 0 : 0
Rem MCopyTo.bat: Multiple COPY TO %1: copy %2, %3, %4, etc.
:START
If %1/==/ goto SHOWHOW
Set tmpnm=%1
:DO1
If %2/==/ goto BYEBYE
Copy %2 %tmpnm% > nul
Shift
Goto DO1
:SHOWHOW
Echo on
Rem  MCOPY target source1 source2...sourceN
Echo off
Goto BYEBYE
:BYEBYE
Set tmpnm=
)

NB.* setTargetDir: figure target directory based on machine on which we run.
setTargetDir=: 3 : 0
   if. -.nameExists 'TARGDIR' do. TARGDIR=. '' end.
   if. -.nameExists 'TMPDIR' do. TMPDIR=. getTempDir '' end.
   if. 0=#TARGDIR do.              NB. Assign dir prefix based on machine, if known.
       pfx=. KMPFX
       'machnm usernm'=. whoami ''
       pfx=. >pfx{~KNMACH i. <machnm         NB. Prefix based on computer name
       today=. ;4 2 2 lead0s&.>3{.qts ''     NB. today's date as 'yyyymmdd'
       dirnm=: TMPDIR,pfx,today,'\'
   else. dirnm=: endSlash TARGDIR end.
   TMPDIR;dirnm
)
NB. ARGV_z_=: ARGV_z_,<'-jijx'

NB.* setGlobalParms: assign globals according to defaults or command-line overrides.
setGlobalParms=: 3 : 0
   SZLIM=: ''$>1e7 lookupValAfterName ARGV_z_;<'SZLIM'
   if. -.isNum SZLIM do. SZLIM=: ".SZLIM end.
   RUNFROMSAVED=: NYto01 {.>0 lookupValAfterName ARGV_z_;<'RUNFROMSAVED'
   TARGDIR=: jpathsep ,>lookupValAfterName ARGV_z_;<'TARGDIR'
   SRCDIR=: ,>'D:\' lookupValAfterName ARGV_z_;<'SRCDIR'
   RUNANYDAY=: NYto01,>'N' lookupValAfterName ARGV_z_;<'RUNANYDAY'
   if. -.nameExists 'DEBUGON' do.
       DEBUGON=: NYto01,>0 lookupValAfterName ARGV_z_;<'DEBUGON'
   end.
   ans=. ans,:".&.>ans=. 'SZLIM';'RUNFROMSAVED';'TARGDIR';'RUNANYDAY';'DEBUGON'
)

NB.* dailyBackup: run backup for today.
dailyBackup=: 3 : 0
   if. -.nameExists 'DEBUGON' do. DEBUGON=: 0 end.
   setGlobalParms ''      NB. Cmd-line size limit, target dir, if present.
   wkdy=. dow 3{.qts ''   NB. Weekday number: 0=Sunday, 6=Saturday
   if. RUNANYDAY+.wkdy e. 1 2 3 4 5 do.      NB. Only Mon-Fri unless
       try. sink=. runDaily '' [ 4!:55 <'ASSERR'   NB.  any day allowed.
       catch. if. nameExists 'ASSERR' do. logMsg_logger_ ASSERR
              else. msg=. '*** Unspecified error in "runDaily" at '
                    logMsg_logger_ msg,'.',~showdate ''
              end.
       end.
   end.
)

NB.* runFromSavedVars: Run backup assuming dir&file vars already saved.
runFromSavedVars=: 3 : 0
   '\amisc\' runFromSavedVars y
:
   bkpargs=. y          NB. 'szlim targ'=. y
   vn=. USUVARS
   (<x,'\'#~'\'~:{:x) unfileVar_WS_&.>vn
   ".&.>(<'parseDir_'),&.>vn,&.>(<'_=. '),&.>vn
   'batfl cmds'=. buildBatFl bkpargs
   shell batfl
   wait 2                                    NB. Give .BAT chance to start.
NB.EG runFromSavedVars 5e6;'C:\Temp\WL20050315\'
)

3 : 0 ''
   if. DEBUGON do. (;sepLF&.>'parseDir.ijs:647';<6!:0 '') fappendDHM DBGFL end.
)

coclass 'base'
coinsert 'parseDir'
3 : 0 ] svIF
   if. _1=y do. 4!:55 <'IsFORKED'
   else. IsFORKED=: y end.
)

getCmdlnArgs=: 3 : 0
NB.* getCmdlnArgs: get named arguments from command line.
   parms=. 'NUM';'NAME'
   num=. ".,>lookupValAfterName CMDLN;<'NUM'      NB. Example numeric value
   num=. >(0=#num) { num;0
   name=. ,>lookupValAfterName CMDLN;<'NAME'      NB. Example character value
   num;name
NB.EG 'num name'=: getSFCmdlnArgs ''
)

NB.* runBackup: run usual backup of main drive.
runBackup=: ([: (80 (] {."1~ [ <. [: {: $) [: ": ,.) [: ".&.> 0 2 3 _3 _2 { <;._2)
NB.EG runBackup usuReminder

onlyRuntime=: 3 : 0
NB.* onlyRuntime: only invoke this if not loaded via usual interactive session.
   if. -.nameExists 'OverrideDefault' do. OverrideDefault=: 0 end.
   if. -.OverrideDefault do.
       if. (5{.&.>'-jijx';<'-rt') +./ . e. 5&{.&.>tolower&.>ARGV_z_ do.
           80 (] {."1~ [ <. [: {: [: $ ]) ":,.rr=. ".&.> 0 2 3 _3 _2 { <;._2 usuReminder
           2!:55 ''                              NB. Terminate session.
       end.
   end.
)

onlyRuntime ''
