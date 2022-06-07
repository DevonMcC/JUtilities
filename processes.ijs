NB.* processes.ijs: process monitoring utilities - relies on "pslist" for Windows.

NB.* watchTillStartNew: wait for new instance of process identified by "str"
NB.* watchTillDone: watch processes ID'd by string, waiting wtm except 1st;
NB.* watchTillDoneTL: using TaskList, watch processes ID'd by string, waiting 
NB.* joinSplitHdrTitles: last 2 titles are 2 words each: put each pair into 1 col.
NB.* getRawPsTbl: get pslist output as table w/headers improperly split.
NB.* getRawTLTbl: get TaskList output as table w/headers improperly split.
NB.* noPsFound: no process found by "getRawPsTbl".
NB.* getPsTbl: get pslist table as enclosed mat w/cell per item.
NB.* joinTaskListSplitHdrTitles: join multi-word header titles from TaskList /V output.
NB.* joinSplitTLCols: join multiple column TaskList table columns
NB.* getTLTbl: get TaskList table as enclosed mat w/cell per item.
NB.* isNum: 1 iff y is numeric, 0 if not
NB.* dsp: delete extra spaces: multiple, leading, trailing.
NB.* checkPsEquiv: check if two uses of getPsTbl return same set of processes.

NB.* multiTimePSs: time multiple instances of process identified by name.
multiTimePSs=: 3 : 0
   'psnm wtm'=. y   NB. Process name, wait time between looks.
   timings=. 0 8$a: [ pstable=. 4$<'nanana'
   while. 0~:#>2{pstable do. pstable=. watchTillDone psnm;wtm;'';_1
       timings=. timings,>2{pstable
   end.
)

NB.* watchTillStartNew: wait for new instance of process identified by "str"
NB. to start: return its process info.
watchTillStartNew=: 3 : 0
   'str wtm'=. y [ ctr=. 0
   while. 0=#pt=. }.lastPsTbl=. getPsTbl str do. wait 1 [ ctr=. >:ctr end.
NB. Above if no "str" running at start; below handles if one
NB. or more processes identified by "str" already running.
   if. 0=ctr do.
       while. (0=#pt) +. 0=#(2{."1 pt) -. 2{."1 }.lastPsTbl do.
           pt=. }.getPsTbl str [ wait 1 [ ctr=. >:ctr end.
       pt=. pt#~-.+./"1 (2{."1 pt) *./ . = |:2{."1 }.lastPsTbl
   end.
   pt;ctr
NB.EG watchTillStartNew 'notepad';1
)

NB.* watchTillDone: watch processes ID'd by string, waiting wtm except 1st;
NB. return most recent process info before each process finished.
watchTillDone=: 3 : 0
   'str wtm lastPsTbl ctr'=. y
   while. 0=#lastPsTbl do. lastPsTbl=. }.getPsTbl str end.
   pstbl=. }.getPsTbl str [ wait wtm**ctr=. >:ctr
   if. 0<#pstbl do. lastPsTbl=. (lastPsTbl#~-.(1{"1 lastPsTbl) e. 1{"1 pstbl),pstbl
   else. ctr=. <:ctr end.     NB. Revert counter so result stays same...
   (lastPsTbl;ctr) 2 3}y
NB.EG watchTillDone^:_ ] 'J7Pll';1;'';_1
)

NB.* watchTillDoneTL: using TaskList, watch processes ID'd by string, waiting 
NB. wtm except 1st; return most recent process info before each process finished.
watchTillDoneTL=: 3 : 0
   'str wtm lastTLTbl ctr'=. y
   while. 0=#lastTLTbl do. lastTLTbl=. }.getTLTbl str end.
   tltbl=. }.getTLTbl str [ wait wtm**ctr=. >:ctr
   if. 0<#tltbl do. lastTLTbl=. (lastTLTbl#~-.(1{"1 lastTLTbl) e. 1{"1 tltbl),tltbl
   else. ctr=. <:ctr end.     NB. Revert counter so result stays same...
   (lastTLTbl;ctr) 2 3}y
NB.EG watchTillDoneTL^:_ ] 'J7Pll';1;'';_1
)

NB.* joinSplitHdrTitles: last 2 titles are 2 words each: put each pair into 1 col.
joinSplitHdrTitles=: (_4 }. ]) , [: ([: }: ;)&.> 1 0 1 0 <;.1 ' ' ,~&.> _4 {. ]

NB.* getRawPsTbl: get pslist output as table w/headers improperly split.
getRawPsTbl=: ([: <;._1&> [: (' ' , dsp)&.> [: (] }.~ [: I. (<'Name ') e.~ 5 {.&.> ]) [: <;._2 (13{a.) -.~ [: shell 'pslist ' , '' ,~ ])
NB.* getRawTLTbl: get TaskList output as table w/headers improperly split.
getRawTLTbl=: [: <;._1&> [: (' ' , dsp)&.> [: (] }.~ [: I. (<'Image ') e.~ 6 {.&.> ]) [: <;._2 (13{a.) -.~ [: shell 'tasklist /V /FI "IMAGENAME eq ' , '*"' ,~ ]

NB.* noPsFound: no process found by "getRawPsTbl".
noPsFound=: 0 *./ . = [: ([: # ' ' -.~ ])&> 0 { ]

NB.* getPsTbl: get pslist table as enclosed mat w/cell per item.
getPsTbl=: 3 : 0
   if. isNum y do. y=. ": y end.        NB. Number is process ID.
   if. noPsFound rpt=. getRawPsTbl y do. ''
   else. (([: joinSplitHdrTitles 0 { ]) 0} _2 }."1 ]) rpt end.
NB.EG getPsTbl ''  NB. Get data on all processes
NB.EG getPsTbl 'jconsole'  NB. Get data on processes with "jconsole" in their names.
)

NB.* joinTaskListSplitHdrTitles: join multi-word header titles from TaskList /V output.
joinTaskListSplitHdrTitles=: [: ([: }: ;)&.> 1 0 1 1 0 1 1 0 1 1 0 1 0 1 0 <;.1 ' ' ,~&.> 15 {. ]
NB.* joinSplitTLCols: join multiple column TaskList table columns
joinSplitTLCols=: ([: joinTaskListSplitHdrTitles 0 { ]) 0} [: }.&.> [: ;&.> ' ' ,&.>&.> 1 1 1 1 1 0 1 1 1 1 <;.1"1 [: ] 10 {."1 ]
NB.* getTLTbl: get TaskList table as enclosed mat w/cell per item.
getTLTbl=: 3 : 0
   if. isNum y do. y=. ": y end.        NB. Number is process ID.
   if. noPsFound rpt=. getRawTLTbl y do. ''
   else. joinSplitTLCols rpt end.
)

getPsTbl=: getTLTbl   NB. Adjust for "pslist" problems on ROG-160 machine.

NB.* isNum: 1 iff y is numeric, 0 if not
isNum=: 1 4 8 16 64 128 1024 4096 8192 16384 e.~ 3!:0
isNum_testCases_=. 3 : 0
   assert. 0 1 1 0 0 -: isNum&>'hi';1;(i.3);'3';<<99
)

NB.* dsp: delete extra spaces: multiple, leading, trailing.
dsp=: deb"1@dltb"1

NB.* checkPsEquiv: check if two uses of getPsTbl return same set of processes.
checkPsEquiv=: 4 : '(0~:#x) *. -:/([: /:~ _2}."1])&.>x;<y'
checkPsEquiv_egUse_=. 0 : 0
   (getPsTbl 'JCONSOLE') checkPsEquiv getPsTbl 'jconsole'
1
   (getPsTbl 'jconsole') checkPsEquiv getPsTbl '*console*'
0
   (getPsTbl 'j') checkPsEquiv getPsTbl 'jconsole'
0
   (getPsTbl 'jc') checkPsEquiv getPsTbl 'jconsole'
1
)

getPsTbl_egUse_=. 0 : 0
   4{.getPsTbl ''        NB. Empty arg returns all processes.
+------+----+---+---+---+----+-------------+-------------+
|Name  |Pid |Pri|Thd|Hnd|Priv|CPU Time     |Elapsed Time |
+------+----+---+---+---+----+-------------+-------------+
|Idle  |0   |0  |4  |0  |0   |785:15:55.750|0:00:00.000  |
+------+----+---+---+---+----+-------------+-------------+
|System|4   |8  |91 |900|0   |2:12:27.984  |0:00:00.000  |
+------+----+---+---+---+----+-------------+-------------+
|smss  |1012|11 |2  |21 |160 |0:00:01.312  |205:42:51.220|
+------+----+---+---+---+----+-------------+-------------+
   4{.getPsTbl 's'       NB. Character arg->process names starting w/"s"
+--------+----+---+---+---+----+-----------+-------------+
|Name    |Pid |Pri|Thd|Hnd|Priv|CPU Time   |Elapsed Time |
+--------+----+---+---+---+----+-----------+-------------+
|System  |4   |8  |91 |902|0   |2:12:28.000|0:00:00.000  |
+--------+----+---+---+---+----+-----------+-------------+
|smss    |1012|11 |2  |21 |160 |0:00:01.312|205:42:58.376|
+--------+----+---+---+---+----+-----------+-------------+
|services|1776|9  |16 |406|5492|0:08:04.000|205:42:45.064|
+--------+----+---+---+---+----+-----------+-------------+
   getPsTbl '1776'       NB. Numeric arg->all w/PID "1776"
+--------+----+---+---+---+----+-----------+-------------+
|Name    |Pid |Pri|Thd|Hnd|Priv|CPU Time   |Elapsed Time |
+--------+----+---+---+---+----+-----------+-------------+
|services|1776|9  |16 |406|5492|0:08:04.000|205:42:55.704|
+--------+----+---+---+---+----+-----------+-------------+

getPsTbl_Caveats_=. 0 : 0
   4{.getPsTbl 'cmd'     NB. Two instances of "1496" not PID
+----+----+---+---+---+----+-----------+-------------+
|Name|Pid |Pri|Thd|Hnd|Priv|CPU Time   |Elapsed Time |
+----+----+---+---+---+----+-----------+-------------+
|cmd |2336|8  |1  |25 |1496|0:00:00.125|205:48:34.566|
+----+----+---+---+---+----+-----------+-------------+
|cmd |2908|8  |1  |37 |2108|0:00:00.265|205:48:34.424|
+----+----+---+---+---+----+-----------+-------------+
|cmd |5028|8  |1  |25 |1496|0:00:00.125|193:05:52.357|
+----+----+---+---+---+----+-----------+-------------+
   $getPsTbl '1496'      NB. Does not find if not PID.
0

NB. Fails to find process named as number - notice "1776" below:
   _3{.getPsTbl ''
+------------------+----+--+-+---+-----+-----------+-----------+
|1776              |7104|8 |1|63 |12712|0:00:00.093|0:00:16.843|
+------------------+----+--+-+---+-----+-----------+-----------+
|cmd               |3480|8 |1|35 |2024 |0:00:00.031|0:00:00.031|
+------------------+----+--+-+---+-----+-----------+-----------+
|pslist            |4196|13|2|119|1208 |0:00:00.031|0:00:00.015|
+------------------+----+--+-+---+-----+-----------+-----------+
   getPsTbl '1776'       NB. Only finds PID, not name
+--------+----+---+---+---+----+-----------+-------------+
|Name    |Pid |Pri|Thd|Hnd|Priv|CPU Time   |Elapsed Time |
+--------+----+---+---+---+----+-----------+-------------+
|services|1776|9  |16 |406|5492|0:08:05.234|206:17:36.539|
+--------+----+---+---+---+----+-----------+-------------+
   getPsTbl 1776
+--------+----+---+---+---+----+-----------+-------------+
|Name    |Pid |Pri|Thd|Hnd|Priv|CPU Time   |Elapsed Time |
+--------+----+---+---+---+----+-----------+-------------+
|services|1776|9  |16 |406|5492|0:08:05.250|206:18:03.711|
+--------+----+---+---+---+----+-----------+-------------+
)
