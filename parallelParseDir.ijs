NB.* parallelParseDir.ijs: gather directory info in parallel.

isCurVer=: +./+./&>('Library: 8';'Library: 9') E. &.><JVERSION

load BASEDSK,'\amisc\JSys\user\code\DHMConfig.ijs'
require '~Code\exclusions.ijs'
wait 1
load '~Code\processes.ijs'
3 : 0 ''
   if. isCurVer do. wd=: [ end.
   ''
)

usuUse=: 0 : 0
   1!:44 dd=. BASEDSK,'/amisc/J/Parallel/ExampleProblems/DirInfo/'
   load 'parallelParseDir.ijs'
   6!:2 '''FLNMS FLDTS FLSZS FLPARENT DIRNMS DIRDEP''=: PllDirInfoEG ''',BASEDSK,'/'''
)

NB.* jpathsep: change backslashes to slashes in a path.
jpathsep=: '/'&(('\' I.@:= ])})
NB.* dospathsep: change forward slashes to backslashes.
dospathsep=: '\'&(('/' I.@:= ])})
NB.* lookupValAfterName: get value following name in list of name;value pairs.
lookupValAfterName=: 3 : 0
   '' lookupValAfterName y
:
   'list keyword'=. (}:;[:<{:)y
   if. keyword e. list do. val=. >list{~>:list i. keyword
       if. isValNum val do. val=. _".val end.
   else. val=. x end.
   val
NB.EG 22 -: 'Default' lookupValAfterName 'arg1';'1';'arg2';'22';'foo';<'arg2'
)

PllDirInfoEG=: 3 : 0
NB.* PllDirInfoEG: gather all dirs'' info accumulated in parallel.
   exeID=. 'JPll'
   'tmpd srcd flnms fldts flszs exeIDs'=. pllParseDir exeID;y=. endSlash jpathsep y
   exeID=. '0123456789' (]{.~[:>:0 i:~ ] e. [) '.' (]{.~]i:[) '/' (]}.~[:>:]i:[) >0{exeIDs
   flszs=. ;flszs [ fldts=. cvtTS21Num&>fldts
   flparent=. 0$~#flszs
   dirdep=. _1,0$~#srcd [ dirnms=. y;srcd
   'flnms fldts flszs flparent dirnms dirdep'=. cumulateTempDumps tmpd;flnms;fldts;flszs;flparent;<dirnms
   cleanupTempDirs 'PllDTmp'
   'dirnms flparent'=. adjustDirInfo dirnms;<flparent
   dirdep=. dirDependencies dirnms
   flnms;fldts;flszs;flparent;dirnms;<dirdep
NB.EG 'FLNMS FLDTS FLSZS FLPARENT DIRNMS DIRDEP'=. PllDirInfoEG 'D:/'
)

NB.* cumulateTempDumps: accumulate all the sub-objects from a set of temporary directories.
cumulateTempDumps=: 3 : 0
   'tmpd flnms fldts flszs flparent dirnms'=. y
   vnms=. <;._1 ' FLNMS FLDTS FLSZS FLPARENT DIRNMS DIRDEP'
   for_ii. i. #tmpd do.
       vals=. (3!:2)&.>fread&.>(<endSlash >ii{tmpd),&.>vnms,&.><'.DAT'
       'flnms fldts flszs'=. (flnms;fldts;<flszs),&.>3{.vals
       flparent=. flparent,(#dirnms)+>3{vals
       dirnms=. dirnms,>4{vals
       ddep=. (#dirnms)|dirnms i. (]{.~PATHSEP_j_ i:~])&.>dirnms
       dirdep=. (ddep=i.#ddep)}ddep,:_1
   end.
   flnms;fldts;flszs;flparent;dirnms;<dirdep
NB.EG 'FLNMS FLDTS FLSZS FLPARENT DIRNMS DIRDEP'=. cumulateTempDumps tmpd;FLNMS;FLDTS;FLSZS;FLPARENT;<DIRNMS
)

NB.* adjustDirInfo: remove spurious base sub-dir entries.
adjustDirInfo=: 3 : 0
   'dirnms flparent'=. y
   dirnms=. jpathsep&.>dirnms
   whdd=. dirnms e.~({.dirnms),&.>dirnms
   flparent=. flparent-(flparent>0)*+/whdd
   dirnms=. (<'//';'/') rplc~&.>dirnms#~-.whdd
   dirnms;<flparent
)

dirDependencies=: 3 : 0
NB.* dirDependencies: convert list of full paths to index vector form of tree
NB. showing directory and subdirectories as parent-child relations.
   ps=. '/' [ y=. jpathsep&.>y
   y=. y}.~&.>-ps={:&>y           NB. No terminal separators
   dd=. (] i. (]{.~ps i:~])&.>) y NB. Drop part of path after last separator
   dd=. (_1) (I. dd=i.#dd)}dd     NB. Dirs' dependency tree: parent indexes
   dd=. (_1) (I. dd>:#dd)}dd      NB. "_1" is root (no parent).
NB.EG dirDependencies 'D:';'D:\a1';'D:\a1\b2';'D:\a2';'D:\a2\b3';'D:\a1\b4'
NB. _1 0 1 0 3 1         NB. Parent index for each subdir; _1 for no parent.
)

NB.* endSlash: ensure path has ending slash.
AltSlash=. {.'/\'-.PATHSEP_j_
cvtSlash=: (AltSlash,PATHSEP_j_)&(4 : '(y=0{x)}y,:1{x')
endSlash=: PATHSEP_j_&(4 : '(] , x -. {:)cvtSlash y')

SUBTASK=: <jpath '~Code/pllPDSub.ijs'
dq=: '"','"' ,~]                        NB.* dq: put double-quotes around y.

NB.* buildExe: build distinctly-named copies of J executable, if possible.
buildExe=: 3 : 0
   'pfx nn'=. y
   suffixes=. <^:(0=L. suffixes)]suffixes [ suffixes=. ,2 lead0s i. nn
   exe=. (<'.exe" '),~&.>(<'/',pfx),&.>":&.>suffixes
   exe=. jpathsep&.>('"',&.><jpath '~bin'),&.>exe
   whEx=. fexist&>'"'-.~&.>exe     NB. Which executables exist?
   if. 0 e. whEx do.               NB. If missing executables,
NB.       exe=. nn$<(jpath '~bin'),'/jconsole.exe' end.
       if. 0*./ . = whEx do.
           (fread (jpath '~bin'),'/jconsole.exe') fwrite ;exe=. {.exe
	   whEx=. 1
       end.
       exe=. nn$whEx#exe end.
   exe
NB.EG exes=. buildExe 'J8Pll';2    NB. 2 strings -> execute distinctly-named J exes.
)

pllParseDir=: 3 : 0
NB.* pllParseDir: launch sub-tasks to parse each sub-directory under y.
   'exeID0 y'=. y
   if. 0=#y do. y=. BASEDSK,'/' end.
   srcDirs=. jd dir '*',~y=. endSlash y
   'targ EXCLUDIRS xf'=. extractExclusions y
   srcDirs=. srcDirs-.EXCLUDIRS
   'flnms fldts flszs'=. <"1|:0 1 2{"1 jfi dir '*',~y
   cleanupTempDirs tmpd=. 'PllDTmp',4 (] {~ [ ?@$ [: # ]) Alpha_j_
   tmpDirs=. (<BASEDSK,'/Temp/',tmpd),&.>":&.>i.#srcDirs   NB. Don't end w/slash->escapes "
   args=. SUBTASK,&.>(<' SRCDIR '),&.>dq&.>(<y),&.>srcDirs  NB. One command/dir
   args=. args,&.>(<' RESULTDIR '),&.>dq&.>tmpDirs
   args=. (<'//';'/') rplc~&.>jpathsep&.>args
   exeIDs=. buildExe exeID0;#args
   IsFORKED=. 1
   fork&>exeIDs,&.>(<' ',IFJ6#'-jijx '),&.>args
NB.   watchTillDone exeID0;1;'';_1
   watchTillDoneTL^:_ ] exeID0;1;'';_1
   wait 2 [ checkIfDonePPD exeID0 NB. cleanupTempDirs tmpd
   tmpDirs;srcDirs;flnms;fldts;flszs;<exeIDs
NB.EG 'tmpd srcd flnms fldts flszs exeIDs'=. pllParseDir 'J8Pll';'D:/'
)

checkIfDonePPD=: 3 : 'while. 9<LF+/ . =shell ''pslist '',y do. wait 1 end.'
checkIfDonePPD=: 3 : 'while. -.+./''not found'' E. shell ''pslist '',y do. wait 1 end.'

cleanupTempDirs=: 3 : 0
   if. 0<#dd=. dir ttop,y,'*' [ ttop=. BASEDSK,'/Temp/' do.
       tmpdirs=. dospathsep&.>(<ttop),&.>jd dd
       shell&>(<'echo Y|del '),&.>tmpdirs,&.><'\*'
       1[shell&>(<'rmdir '),&.>tmpdirs
   end.
)

0 : 0
NB.* only invoke if not loaded via interactive session.
   ml=. >./ #&>possib=. '-jijx';'-rt'
   if. IsFORKED +. (ml{.&.>possib) +./ . e. ml&{.&.>tolower&.>ARGV_z_ do.
       'FLNMS FLDTS FLSZS FLPARENT DIRNMS DIRDEP'=. PllDirInfoEG BASEDSK,'/'
       (<'/Temp/') fileVar_WS_&.>'FLNMS';'FLDTS';'FLSZS';'FLPARENT';'DIRNMS';'DIRDEP'
       'batfl cmds'=. buildBatFl_parseDir_ 12e6;BASEDSK,'/Temp/Recent/'
       shell batfl
   end.
   2!:55 ''
)
