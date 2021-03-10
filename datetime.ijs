NB.* datetime.ijs: date and time fns.

NB. load '~addons/sfl/sfldates.ijs'   NB. Use C++ Std Template Lib for dates
require 'dates' NB. format'

NB.* WKDAYS: English names of days of week
NB.* MONTHS: English names of months of year
NB.* moAbbrevs: 3-letter (English) month abbreviations
NB.* baseDPM: base # of days per month (Feb->28)
NB.* weekDayAbbrevs: 3-letter (English) weekday abbreviations
NB.* totalPlayTime: add up the playing times of all .mp3 sound files in specified directory.
NB.* cvtMySQLBigInt2TS: convert MySQL date/time as big int to (GMT) timestamp.
NB.* fix60SecTimestamp: fix time-stamps with "60" in minutes or seconds column.
NB.* cvtMsDsYhhmmss2TS: '10/18/10 15:29:11.959' -> 2010 10 18 15 29 11.959
NB.* cvtOracleTS2TS: convert Oracle timestamp to numeric Y M D h m s 0.
NB.* cvtTS21Num: convert J (or APL) timestamp to YYYYMMDD.(day fraction).
NB.* slashYMD: 20091116 -> '11/16/2009'
NB.* cvt1Num2TS: convert YYYYMMDD.(day fraction) to J (or APL) timestamp
NB.* cvtTmAPMil: convert [h]h:mm[ap] timestamp to hh:mm:00 format.
NB.* calendar: return text calendar for Year-Month YM (in form YYYYMM).
NB.* fmtHMS: format hours, minutes, seconds as string given 3 numbers.
NB.* elapsedTimeMsg: show time elapsed given starting qai=: 6!:1 ''.
NB.* isLaterThan: given timestamp is (1) later than now or not (0).
NB.* DateTimeCvt: Convert between DOS-style time (YYYYMMDD hh:mm[a|p]) & dayfraction.
NB.* fp2dt: floating point date.time to (char) date time: YYYYMMDD hh:mm.
NB.* DOSTime2DayFrac: DOS date & time MM/DD/YYYY hh:mm[a|p] -> YYYYMMDD.day-fraction.
NB.* ts2DayFrac: time stamp (YYYY MM DD hh mm ss) to Julian day+day fraction
NB.* monthAdd: add y months to x date YYYYMMDD.
NB.* DateAdd: limited mimic of VB DateAdd - DateAdd <unit to add>;date;num
NB.* waitUntil: wait until time y in [abbreviated] TS form: YYYY MM DD [[hh] [[mm] [[ss]]]]
NB.* adt2sqldt: MS Access date time 'M/D/Y h:m:s'->#M/D/Y#
NB.* yy2yyyy: 2-digit to 4-digit year; <:50 is pivot.
NB.* cvtIfDate2Num: assuming slash means [m]m/[d]d/[yy]yy date, convert to YYYYMMDD.
NB.* calcEOMdates: calculate End-Of-Month dates starting in year 0{y for 1{y years.  Account for weekends but not holidays.
NB.* cvtAT: convert vector of timestamps from MSAccess DB to numeric date YYYYMMDD.
NB.* JDCNV: Julian day conversion from http://www.astro.washington.edu/deutsch-bin/getpro/library01.html?JDCNV
NB.* TSDiff: timestamp difference - return difference between 2 timestamps
NB.* TSAdd: add 2 timestamps - return sum of 2 timestamps
NB.* cvtDateTime2numDt: convert multiple (e.g. MS Access) char date-times, e.g.
NB.* dow: Day-of-week for year month day: 0=Sunday
NB.* toJulian: convert YYYYMMDD date to Julian day number.
NB.* toGregorian: convert Julian day numbers to dates in form YYYYMMDD
NB.* cvtY4M2D22YMD: "2002-06-11" -> 20020611 (numeric)
NB.* cvtMDY2Y4M2D2: convert char [m]m/[d]d/[yy]yy -> yyyymmdd (numeric);
NB.* cvtY4M2D22MDY: convert yyyymmdd (numeric) -> [m]m/[d]d/yyyy (char)
NB.* cvtDDMMMYYYY2Y4M2D2: convert, e.g 31-Mar-1995->19950331; use global moAbbrevs.
NB.* cvtLogTS: convert log entry like <;._1 ' [31 Dec 2013 23:59:59,999]' to TS.
NB.* addMos: add N months to date in form Y4M2 (YYYYMM): YYYYMM addMos N.
NB.* fmtDate v Format a date in a given format
NB.* escaped v process an escaped string
NB.* fmt: cover for 8!:0

WKDAYS=: ;:'Sunday Monday Tuesday Wednesday Thursday Friday Saturday'
MONTHS=: ''; ;:'January February March April May June July August September October November December'
moAbbrevs=: 3{.&.>}.MONTHS
baseDPM=: 31 28 31 30 31 30 31 31 30 31 30 31  NB. Base # of days per month.
weekDayAbbrevs=: 3{.&.>WKDAYS

NB.* totalPlayTime: add up the playing times of all .mp3 sound files in specified directory.
totalPlayTime=: 3 : 0
   y=. endSlash y
   cmd=. 'C:\Pgm\ffmpeg-20200824-3477feb-win64-static\bin\ffprobe "',y,'{flnm}"'
   flnms=. 0{"1 dir y,'*.mp3'
   info=. shell &.> (<cmd) rplc &.>(<'{flnm}');&.>flnms
   keyStr=. '  Duration:'
   whtms=. (#keyStr)+,I.&>(<keyStr) E.&.> info
   tms=. ',' (]{.~]i.[) &.> whtms }.&.> info
   hms=. ".&><;._1 &> ':',&.>tms
   0 60 60#:60#.+/hms
NB.EG 0 3 21.38 -: totalPlayTime 'E:\amisc\Sound\MixCDs' NB. "Fever by Peggy Lee.mp3"
)

NB.* cvtMySQLBigInt2TS: convert MySQL date/time as big int to (GMT) timestamp.
cvtMySQLBigInt2TS=: [: (}. ,~ [: todate 62091 + {.) 0 24 60 60 1000 #: ]
NB.* fix60SecTimestamp: fix time-stamps with "60" in minutes or seconds column.
fix60SecTimestamp=: 3 : 0
   tm=. >_1{y=. <;._1 ' ',dsp y   NB. e.g. 09:48:60
   if. 60=_1{tm=. ".;._1 ':',tm do. tm=. 0 1 0+1 1 0*tm end.
   if. 60=1{tm do. tm=. 1 0 0+1 0 0*tm
       if. 24=0{tm do. tm=. 0*tm [ dt=. 1|.todate >:todayno _1|.".;._1 '/',>0{y
           y=. (<}.;'/',&.>_2 _2 _4{.&.>'0',&.>":&.>dt) 0}y  end. end.
   (>0{y),' ',}.;':',&.>_2{.&.>'0',&.>":&.>tm
NB.EG fix60SecTimestamp&.>'10/31/2001 23:59:60';'12/31/2001 23:59:60';'12/31/1999 23:59:60'
NB.EG +-------------------+-------------------+-------------------+
NB.EG |11/01/2001 00:00:00|01/01/2002 00:00:00|01/01/2000 00:00:00|
NB.EG +-------------------+-------------------+-------------------+
)

NB.* cvtMsDsYhhmmss2TS: '10/18/10 15:29:11.959' -> 2010 10 18 15 29 11.959
cvtMsDsYhhmmss2TS=: 3 : 0
   'dt tm'=. <;._1 ' ',dsp y
   dt=. (2 0 1 {[: (]2}~[:(]+2000*100>]) 2{]) [: ".&>[: <;._1 '/',]) dt
   dt,".&><;._1 ':',tm
)

NB.* cvtOracleTS2TS: convert Oracle timestamp to numeric Y M D h m s 0.
cvtOracleTS2TS=: 3 : 0
   if. 0<#y do. y=. <;._1 ' ',y
       ymd=. ".&>2 0 1{<;._1'/',>0{y
       hms=. ".&><;._1 ':',>1{y
       aorp=. 3{.0 12{~('A'~:{.>2{y) *. 12~:0{hms
       tm=. aorp+hms
       7{.ymd,tm
   else. 0 end.
NB.EG (1959 5 24 8 57 12 0)-:cvtOracleTS2TS '5/24/1959 8:57:12 AM'
NB.EG (1999 12 31 23 59 59 0;2001 1 1 0 0 1 0)-:cvtOracleTS2TS&.>'12/31/1999 11:59:59 PM';'1/1/2001 0:00:01 AM'
)

NB.* cvtTS21Num: convert J (or APL) timestamp to YYYYMMDD.(day fraction).
cvtTS21Num=: 13 : '(100#.3{.y)+(*/24 60 60 1000)%~24 60 60 1000#.3}.7{.y'"1
NB.* slashYMD: 20091116 -> '11/16/2009'
slashYMD=: [: ((4 5 { ]) , '/' , (6 7 { ]) , '/' , 4 {. ]) 8j0&":
NB.* cvt1Num2TS: convert YYYYMMDD.(day fraction) to J (or APL) timestamp
cvt1Num2TS=: [: (([: slashYMD [: <. 0 { ]) , ' ' , [: }. [: ; ':' ,&.> _2 {.&.> '0' ,&.> [: ":&.> [: <. 0.5 + 24 60 60 #: 86400 * 1 { ]) 0 1 | ]

NB.* cvtTmAPMil: convert [h]h:mm[ap] timestamp to hh:mm:00 format.
cvtTmAPMil=: 3 : 0
   tm=. <;._1 ':',y-.'mM'
   ap=. {:>_1{tm
   tm=. (}:&.>_1{tm) _1}tm
   hr=. ".>0{tm
   hr=. hr+12*(ap e. 'pP')*.12~:hr
   tm=. (<":hr) 0}tm
   (;tm,&.>':'),'00'
)

NB.* calendar: return text calendar for Year-Month YM (in form YYYYMM).
calendar=: 3 : 0"0
   if. 158210>:y do. 'Date must be after 158210 (October 1582).'
   else.
       mos=. 'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'
       days=. 'Sun';'Mon';'Tue';'Wed';'Thu';'Fri';'Sat'
       fom=. dow 0 100 100#:>:100*y          NB. Day-of-week of first day of month.
       'yr mo'=. 0 100#:y
       len=. 28+((~:/0=4 100 400 4000|yr)*2=mo)+(2~:mo)*2+-.mo e. 9 4 6 11
       cal=. days,":&.>6 7$(-fom)|.42{.":&.>>:i.len
       cal=. ,/"2 >(->:>./,#&>cal){.&.>cal   NB. Pad columns to >:max width
       tit=. (":yr),~' ',~>mos{~<:mo
       cal=. cal,~({:$cal)({.|.~[:-[:<.[:-:[-[:#]) tit     NB. Center title
   end.
NB.EG calendar 200705   NB. Calendar for May 2007
)

NB.* fmtHMS: format hours, minutes, seconds as string given 3 numbers.
NB.fmtHMS=: 3 : '}.;,'':'',&.>,&.>((<''zw2'')fmt&.>2{.y),<''zw6.3'' fmt 2}.y=. _3{.y'
fmtHMS=: 3 : '}.;'':'',&.>;((<''r<0>2.0'')8!:0&.>2{.y),<''r<0>6.3''8!:0]2}.y=. _3{.y'

NB.* fmtYMD: format year, month, day as string given 3 numbers.
fmtYMD=: 3 : '}.;''/'',&.>>(<''4.0'' 8!:0 {.y),(<''r<0>2.0'') 8!:0&.>_2{.y'
NB.* elapsedTimeMsg: show time elapsed given starting qai=: 6!:1 ''.
elapsedTimeMsg=: 3 : 0
   '' elapsedTimeMsg y
:
   elapsed=. y-~6!:1 ''                NB. Seconds elapsed in session.
   dhms=. 0 24 60 60#:elapsed           NB. Days, hours, minutes, seconds
   msg=. x,(CRLF#~0~:#x),'Done at ',(showdate ''),';',CRLF
   tmunits=. }:;'/',~&.>((*3{.dhms)#'Days';'Hrs';'Mins'),<'Secs'
   msg=. msg,'elapsed ',tmunits,': ',":dhms#~1,~*3{.dhms
)

isLaterThan=: 3 : '0< >0{(6!:0 '''') ([ TSDiff ] {.~ [: # [) y'
NB.* isLaterThan: given timestamp is (1) later than now or not (0).

DateTimeCvt=: 3 : 0
NB.* DateTimeCvt: Convert between DOS-style time (YYYYMMDD hh:mm[a|p]) & dayfraction
NB.  (single number=<Julian day number>.<day fraction>).
   if. ' '={.0$,y do.                        NB. Character … number
       'dt tm'=. 2{.dtap=. <;._1 ' ',dsp ,y  NB. Separate date and time
       if. 3=#dtap do.                       NB. Handle time in "hh:mm [AM|PM]" format
           tm=. tm,'ap'{~'P'={.>2{dtap       NB.  -> "hh:mm[a|p]"
       end.
       dt=. (toJulian cvtMDY2Y4M2D2 dt)+DOSTime2DayFrac tm
   else. dt=. (cvtY4M2D22MDY toGregorian <.y),' ',DOSTime2DayFrac 0|y
   end.
   dt
)

NB.* fp2dt: floating point date.time to (char) date time: YYYYMMDD hh:mm.
fp2dt=: 13 : '(0j0":{.y),'' '',DOSTime2DayFrac y'"0

DOSTime2DayFrac=: 3 : 0
NB.* DOSTime2DayFrac: DOS time hh:mm[a|p] -> 0.day-fraction or vice-versa.
   'DOS' DOSTime2DayFrac y
:
   spd=. 5+*/24 60 60         NB. Seconds per day + 5 for any leap seconds.
   targ=. toupper x           NB. Target direction->'DOS' or 'DF' (day fraction)
   if. -.isNum y do. targ=. 'DF' end.
   if. targ-:'DOS' do.
       df=. (12|0{df) 0}df=. }:0 60 60#:<.0.5+spd*1|y
       df=. ((0{df)+12*0=0{df) 0}df                         NB. 5 leap-seconds
       df=. (}:;(2 lead0s&.>df),&.>':'),(0.4999<:1|y){'ap' NB. means noon<0.5.
   else. df=. ;n2j&.><;._1 ':',y#~y e. ' 0123456789:'  NB. '3:25p'->3 25
       df=. ((0{df)+12*(12~:0{df)*.'pP'e.~{:y) 0}df
       df=. ((0{df)-12*(12= 0{df)*.'aA'e.~{:y) 0}df
       df=. 0.999999<.(60*60#.df)%spd
   end.
   df
)

NB.* ts2DayFrac: time stamp (YYYY MM DD hh mm ss) to Julian day+day fraction
ts2DayFrac=: 3 : 0
   spd=. 5+*/24 60 60         NB. Seconds per day + 5 for any leap seconds.
   (toJulian 100#.3{.y)+spd%~0 60 60#.3}.ts
)

NB.* dayFrac2ts: Julian day+day fraction to time stamp (YYYY MM DD hh mm ss)
dayFrac2ts=: 3 : 0
   (,0 100 100#:toGregorian {.0#:y),0 60 60#:(5+*/24 60 60)*1#:y
)

NB.* monthAdd: add y months to x date YYYYMMDD.
monthAdd=: 4 : 0
   mobase=. 0 12 31
   100#.todate todayno 0 1 0+mobase#:(31*y)+mobase#.0 _1 0+0 100 100#:x
NB.EG 19590524 monthAdd 6+12*50
)

DateAdd=: 3 : 0
NB.* DateAdd: limited mimic of VB DateAdd - DateAdd <unit to add>;date;num.
NB. Date in form YYYYMMDD.
   ts=. i. 0 [ units=. 'YMDW'      NB. Units are Year, Month, Day, Week.
   'unit dt addnum'=. y
   assert (unit=. {.toupper unit) e. units
   dpu=. (372 31 1 7){~units i. unit    NB. 372=12*31: provisional "year"
   mobase=. 0 12 31
   assert. dt>18000101   NB. todayno only goes back to this date
   dt=. 0 100 100#:dt
   select. unit
   case. 'D';'W' do.
       dt=. 100#.todate (dpu*addnum)+todayno dt
   case. 'M';'Y' do.
       fakedayno=. mobase#.0 _1 0+dt
       dt=. 100#.todate todayno 0 1 0+mobase#:fakedayno+dpu*addnum
   end.
   assert. dt>18000101   NB. todayno only goes back to this date
NB. dtdifs=. 2-/\todayno&>(<0 100 100)#:&.> dtsa=. DateAdd&>(<'D';20050101),&.><&.>i:_10000
NB. 1 *./ . = dtdifs
NB. dtdifs=. 2-/\todayno&>(<0 100 100)#:&.> dtsa=. DateAdd&>(<'W';20050101),&.><&.>i:_10000
NB. 7 *./ . = dtdifs
)

DateAddOLD=: 3 : 0
NB.* DateAdd: limited mimic of VB DateAdd - DateAdd <unit to add>;date;num
   ts=. i. 0 [ units=. 'YMDW'      NB. Units are Year, Month, Day, Week.
   'unit dt add'=. y
   unit=. {.toupper unit
   assert unit e. units
   if. 'W'=unit do. add=. 7*add [ unit=. 'D' end.
   summand=. 6{.add (units i. unit)}(#units)$0
   ts=. 100#.3{.>1{summand TSAdd 6{.0 100 100#:dt
NB.EG DateAdd 'D';20040524;_45
)

waitUntil=: 3 : 0
NB.* waitUntil: wait until time y in [abbreviated] TS form: YYYY MM DD [[hh] [[mm] [[ss]]]]
   6!:3 (0>.>0{y TSDiff 6!:0 '')
NB.EG 'Happy New Year!' [ waitUntil 2004 12 31 23 59 59
)

adt2sqldt=: (1&|.)@('##'&,)@((]i.&' '){.])   NB.* MS Access date time 'M/D/Y h:m:s'->#M/D/Y#

yy2yyyy=: 3 : 0
NB.* yy2yyyy: 2-digit to 4-digit year; <:50 is pivot.
   if. -.isNum yy=. y do. yy=. _".yy end.
   yy+(yy<:50){1900 2000
)

cvtIfDate2Num=: 3 : 0
NB.* cvtIfDate2Num: assuming slash (or dash) means [m]m/[d]d/[yy]yy date,
NB. -> character yyyymmdd.
   if. +./'-/' e. y do.
       dlim=. {.y-.'0123456789'        NB. Assume delimiter is 1st non-numeral.
       y=. ":dlim cvtMDY2Y4M2D2 y
   end.
   y                                   NB. Return input if not date.
)

cvtTS2Access=: 3 : 0
NB. cvtQTS2Access: convert J timestamp to MS Access date:
NB. YYYY MM DD hh mm ss.ms -> MM/DD/YYYY hh:mm:ss
   if. 0=#y do. dt=. qts ''
   else. dt=. 6{.y end.
   dt=. (1 2 0 3 4 5 ){dt               NB. Reorder YMD->MDY
   dt=. (roundNums 5{dt) 5}dt           NB. Round to whole seconds.
   dt=. <("1)2 3$dt                     NB. Separate date & time.
   dt=. (>":&.>&.>dt),&.>("1 0)'/:'     NB. M D Y ->"M/D/Y/" & h m s ->"h:m:s:"
   dt=. (_3{.&.>(<'00'),&.>1{dt) 1}dt   NB. Pad time w/leading 0s.
   dt=. }:&.>dsp&.><"1 ;"1 dt           NB. Drop excess trailing delimiters,
   dt=. }:;dt,&.>' '                    NB.  join date & time -> "M/D/Y hh:mm:ss"
NB.EG cvtTS2Access 6!:0 ''
)

normAccessDate=: 3 : 0
NB. normAccessDate: convert MS Access dates with usually useless timestamp
NB. to simple date, e.g. YYYY-MM-DD hh:mm:ss -> (numeric) YYYYMMDD.
   if. isNum 0{y do.                   NB. YYYYMMDD -> 'MM/DD/YYYY'
       xp=. 1 1 1 1 0 1 1 0 1 1 0
       tmp=. y
       dts=. ''
       while. 0<#tmp do.
          dd=. }.4|.xp (#^:_1) ": >0{tmp         NB. 20030524 -> 05 24 2003
          dts=. dts,<'/' (I. -.}.4|.xp)}dd  NB. -> 05/24/2003
          tmp=. }.tmp
       end.
   else.                                NB. YYYY-MM-DD hh:mm:ss -> YYYYMMDD
       dts=. boxopen y
       dts=. ;0".&.>'-'-.~&.>dts {.~ &.> dts i. &.> ' '
   end.
   dts
)

cvtAccessIODates=: 3 : 0
NB. cvtAccessIODates: stupid MS Access exports dates in form YYYY-MM-DD that
NB. it won't accept for import: convert between this and MM/DD/YYYY form.
   y=. y{.~y i. ' '        NB. 2002-01-23 12:34:46 -> 2002-01-23
   if. '-' e. y do.          NB. Dash delimiter: YYYY-MM-DD -> MM/DD/YYYY
       y=. (y='-')}y,:'/'
       dt=. y
       wh=. >:dt i. '/'            NB. Pull off [YY]YY/
       dt=. (wh}.dt),_1|.wh{.dt    NB. YYYY/MM/DD -> MM/DD/YYYY
       y=. dt,y}.~y i. ' '      NB. Put date back on first.
   elseif. '/' e. y do.           NB. Slash delimiter: MM/DD/YYYY -> YYYY-MM-DD
       y=. (y='/')}y,:'-'
       if. ' ' e. y do.
           dt=. y
           wh=. ->:(|.dt) i. '-'   NB. Pull off "-[YY]YY"
           dt=. (wh}.dt),~1|.wh{.dt     NB. MM-DD-YYYY -> YYYY-MM-DD
           y=. dt,y}.~y i. ' '  NB. Put date back on first.
       end.
   end.
   y
)

calcEOMdates=: 3 : 0
NB.* calcEOMdates: calculate End-Of-Month dates starting in year 0{y for
NB. 1{y years.  Optionally account for weekends but not any holidays.
   0 calcEOMdates y    NB. Do not account for weekends by default, avoid otherwise
:   
   'styr numyrs'=. y
   eomdts=. (styr+i.numyrs),&.>/(i.12)                 NB. Start with YYYY MM
   eomdts=. eomdts,&.>(1{&.>eomdts) d14&.>0{&.>eomdts  NB.  ,last calendar day
   eomdts=. eomdts+&.><0 1 0                           NB. Origin-1 months
   dd=. dow&.>eomdts                                   NB. Days-of-week
   weekdayshift=. dd{&.><2 0 0 0 0 0 1                 NB. Move back 2 days for Sunday,
   eomdts=. eomdts-&.>(<0 0),&.>x*&.>weekdayshift      NB. or 1 for Saturday
NB. Returns (numyrs,12)$<YYYY MM DD date numbers.
NB.EG eomdts=. calcEOMdates 2003 5
)

cvtAT=: 3 : 0
NB.* cvtAT: convert vector of timestamps between MS Access DB form
NB. 'MM/DD/YYYY hh:mm:ss' and numeric date YYYYMMDD.
   if. isNum y do.
       cvtTS2Access 0 100 100#:y
   else. cvtDateTime2numDt y end.
)

JDCNV=: 3 : 0
NB.* JDCNV: Julian day conversion from http://www.astro.washington.edu/deutsch-bin/getpro/library01.html?JDCNV
   'yr mn day hr'=. y
NB.  yr = long(yr) & mn = long(mn) &  day = long(day);Make sure integral
   L=. (mn-14)%12        NB. In leap years, -1 for Jan, Feb, else 0
   julian=. day-32075+(1461*(yr+4800+L)%4)+(367*(mn - 2-L*12)%12) - 3*((yr+4900+L)%100)%4
   julian=. julian+(hr%24)-0.5
)

TSDiff=: 4 : 0
NB. May have fixed bug which gives year, month, or day of 0: 20101216 16:20.
NB.* TSDiff: timestamp difference - return difference between 2 timestamps
NB. in form Y M D h m s= years months days hours minutes seconds.
   timebase=. 0 12 31 24 60 60 [ orig=. <0 1 1 0 0 0
   'x y'=. orig (]-[*0 ~:[:*])&.>(-#timebase){.&.>x;<y NB. Pad w/lead 0s if short.
   secs=. ;(<timebase)#.&.>x;<y
   if. swapHiLo=. </secs do. secs=. |.secs end.
   diff=. (>orig)(]+[*0 ~:[:*])timebase#: ds=. -/secs
   if. swapHiLo do.'ds diff'=. -&.>ds;diff end.
   ds;diff     NB. Difference in both seconds and in Y M D h m s.
NB.EG (6!:0 '') TSDiff ts [ 6!:3,10 [ ts=. 6!:0 ''  NB. 10-sec delay
)

TSAdd=: 4 : 0
NB. Still has bug: will give year, month, or day of 0.
NB.* TSAdd: add 2 timestamps - return sum of 2 timestamps
NB. in form Y M D h m s= years months days hours minutes seconds.
   timebase=. 0 12 31 24 60 60 [ orig=. <0 1 1 0 0 0
   'x y'=. orig (]-[*0 ~:[:*])&.>(-#timebase){.&.>x;<y NB. Pad w/lead 0s if short.
   ds;sum=. (>orig)+timebase#: ds=. +/;(<timebase)#.&.>x;<y NB. Sum in both seconds and in Y M D h m s.
NB.EG (6!:0 '') TSAdd 10 15                  NB. 10 min, 15 seconds from now.
)

showdate=: 3 : 0
NB. showdate: show given, or current if arg '', date & time in standard form.
NB. Can show 60 in seconds position because rounded to nearest second and
NB. carrying because of rounding gets too complicated.
   y=. ,y                        NB. Must be vector.
   if. 0=#y do. y=. 6!:0 '' end. NB. Arg is timestamp: YYYY MM DD hh mm ss
   dt=. fmtYMD 3{.y
   if. 3=#y do. tm=. '' else.
       tm=. fmtHMS 3}.y
       if. 0=1|_1{y do. tm=. tm{.~tm i: '.' end. NB. Drop fraction of second if none
   end.
   dt,(' '#~0~:#tm),tm
NB.EG showdate 1959 5 24 8 9 0
NB.EG showdate ''                  NB. Current date and time
NB.EG >}.<;._1 ' ',showdate ''     NB. Time only
NB.EG showdate 1992 12 16          NB. Date only
)

cvtDateTime2numDt=: 3 : 0
NB.* cvtDateTime2numDt: convert multiple (e.g. MS Access) char date-times, e.g.
NB. "1995-02-28 00:00:00", to numeric dates, e.g. 19950228.
   dt=. boxopen y=. ,y
   dlim=. ('-' e. >0{dt){'/-'
   dt=. dt {.~ &.> ' 'i.~ &.> dt
   dt=. ;dlim cvtY4M2D22YMD dt
NB.EG cvtDateTime2numDt '1995-05-31 12:34:56';<'1995-06-30 00:00:00'
)

cvtD2M3Y22MSDSY=: 3 : 0
NB. cvtD2M3Y22MSDSY: e.g. 31-Jul-02 -> 7/31/02.
   if. 0~:#y do.
       y=. ,y
       dlim=. {.~.y -. '0123456789'    NB. Assume delimiter whatever not num.
       dt=. <;._1 dlim,y
       mo=. >:(toupper &.> moAbbrevs) i. <toupper >1{dt
       }:;(":&.>mo;0 2{dt),&.>'/'
   else. y end.
)

m11=: 0: ~:/ .= 4 100 400"_ |/ ]   NB. Is y a leap year?
m12=: 28"_ + m11@]                 NB. Number of days in February of year y
d13=: 31"_ - 2: | 7: | [           NB. days in month x, not = 1
d14=: d13`m12@.([=1:)              NB. Number of days in month x of year y
m22=: -/@:<.@(%&4 100 400)"0       NB. # of leap days in year yyyy (Clavian corr.)
m21=: >:@(365&* + m22)@(-&1601)    NB. # of New Year's Day, Gregorian year y; m21 1601 is 1.
dowsoy=: 7&|@m21    NB. Day of week for start of year YYYY: 0=Sunday

dow=: 3 : 0
NB.* dow: Day-of-week for year month day: 0=Sunday
   7|+/(dowsoy 0{y),(;(i. 0>. <:1{y) d14 &.> 0{y),<:2{y
)

isLeapYr=: 0: ~:/ .= 4 100 400"_ |/ ]

toJulian=: 3 : 0
NB.* toJulian: convert YYYYMMDD date to Julian day number.
   dd=. |: 0 100 100 #: y
   mm=. (12*xx=. mm<:2)+mm=. 1{dd
   yy=. (0{dd)-xx
   nc=. <.0.01*yy
   jd=. (<.365.25*yy)+(<.30.6001*1+mm)+(2{dd)+1720995+2-nc-<. 0.25*nc
NB.EG 2436713 2448973 -: toJulian 19590524 19921216
)

toGregorian=: 3 : 0
NB.* toGregorian: convert Julian day numbers to dates in form YYYYMMDD
NB. (>15 Oct 1582).  Adapted from "Numerical Recipes in C" by Press,
NB. Teukolsky, et al.
   igreg=. 2299161        NB. Gregorian calendar conversion day (1582/10/15).
   xx=. igreg<:ja=. <. ,y
   jalpha=. <.((<.(xx#ja)-1867216)-0.25)%36524.25
   ja=. ((-.xx) (#^:_1) (-.xx)#ja)+xx (#^:_1) (xx#ja)+1+jalpha-<.0.25*jalpha
   jb=. ja+1524
   jc=. <.6680+((jb-2439870)-122.1)%365.25
   jd=. <.365.25*jc
   je=. <.(jb-jd)%30.6001
   id=. <.(jb-jd)-<.30.6001*je
   mm=. mm-12*12<mm=. <.je-1
   iyyy=. iyyy-0>iyyy=. (<.jc-4715)-mm>2
   gd=. (10000*iyyy)+(100*mm)+id
NB.EG 19590524 19921216 -: toGregorian 2436713 2448973
)

NB. Date fns: convert between different date formats.
cvtY4M2Mos=: 3 : '12#.(0 100#:y)-0 1'  NB. 200011 -> 24011
cvtMo2Y4M2=: 3 : '100#.0 1+0 12#:y'    NB. 24010 -> 200010
cvtMDY2Y4M2=: (".)@((_4&{.),(2&{.))     NB. "11/30/1999" -> 199911 (numeric)

cvtY4M2D22YMD=: 3 : 0
NB.* cvtY4M2D22YMD: "2002-06-11" -> 20020611 (numeric)
   '-' cvtY4M2D22YMD y
:
   if. 0~:#y do.
       dlim=. x
       dts=. (dts i. &.>' '){.&.>dts=. boxopen y
       dts=. ((5}.&.>dts),&.>dlim),&.>4{.&.>dts
       dts=. dlim cvtMDY2Y4M2D2 &.> dts
   else. y end.
NB.EG dts=. cvtY4M2D22YMD '1959-5-24';'1992-12-16';<'1959-05-06'
)

cvtMDY2Y4M2D2=: 3 : 0
NB.* cvtMDY2Y4M2D2: convert char [m]m/[d]d/[yy]yy -> yyyymmdd (numeric);
NB. x is optional delimiter character if not '/'.
   '/' cvtMDY2Y4M2D2 y  NB. Assume slash delimiter.
:
   if. 0~:#y do.
       ptn=. <;._1 ((x~:0{y)#x),y
       assert. *./isValNum&>ptn         NB. All date parts should be numeric.
       ymd=. ".&.>ptn
       if. 100 > year=. >2{ymd do.
           if. 80 > year do. year=. year+2000
           else. year=. year+1900 end.
           ymd=. (<year) 2}ymd
       end.
       100#.;_1|.ymd
   else. y end.
NB.    cvtMDY2Y4M2D2&.>'3/14/01';'5/9/99';'2/6/1999';'12/16/79';'2/18/80'
NB. +--------+--------+--------+--------+--------+
NB. |20010314|19990509|19990206|20791216|19800218|
NB. +--------+--------+--------+--------+--------+
)

cvtY4M2D22MDY=: 3 : 0
NB.* cvtY4M2D22MDY: convert yyyymmdd (numeric) -> mm/dd/yyyy (char)
NB. x is optional delimiter character if not '/'.
   '/' cvtY4M2D22MDY y  NB. Assume slash is delimiter.
:
   if. 0~:#y do.
       y=. ''$y
       dlim=. x
       dt=. (":&.>1|.0 100 100#:y),&.>1 1 0{.&.>dlim
       ;_3 _3 _4{.&.>(<'0000'),&.>dt    NB. Pad with leading 0s
   else. y end.
NB.EG cvtY4M2D22MDY 19730131
)

cvtDDMMMYYYY2Y4M2D2=: 3 : 0
NB.* cvtDDMMMYYYY2Y4M2D2: convert, e.g 31-Mar-1995->19950331; use global moAbbrevs.
   'dd mo yy'=. <;._1 '-',y
   100#.(".yy),(>:moAbbrevs i. <mo),".dd
)

NB.* cvtLogTS: convert log entry like <;._1 ' [31 Dec 2013 23:59:59,999]' to TS.
cvtLogTS=: 3 : 0
   'dd mo yy'=. '['-.~&.>3{.y
   ymd=. (".yy),(>:moAbbrevs i. <mo),".dd
   hmsm=. (]<;._1~':,'e.~]) ':',>']'-.~&.>3{y
   1000 ((_2}.]),[%~[#._2{.]) ymd,".&>hmsm
NB.* 2013 12 31 23 59 59.999 -: cvtLogTS '[31';'Dec';'2013';'23:59:59,999]'
)

addMos=: 3 : 0
NB.* addMos: add N months to date in form Y4M2 (YYYYMM): YYYYMM addMos N.
   (100 #. 2{.6!:0 '') addMos y        NB. Assume current date if none given.
:
   1+100#.0 12#:y+12#.0 100#:x-1
NB.EG    199909 addMos 16
NB.EG 200101
)

NB. From: "RISKS List Owner" <risko@csl.sri.com>
NB. Date: Sat, 27 Jul 2002 12:41:31 PDT
NB. Subject: [risks] Risks Digest 22.18
NB. To: risks@csl.sri.com
NB.             .+--------------------+.
NB. Date: Wed, 24 Jul 2002 18:37:22 +0100
NB. From: John Stockton <spam@merlyn.demon.co.uk>
NB. Subject: Possible day-of-week error - Zeller
NB.
NB. Algorithms for determining the day-of-week from year-month-day -
NB. whether or not truly Zeller's - can, for certain dates, compute a negative
NB. number mod 7, which does not yield the desired result.  Zeller himself
NB. dealt with this.
NB.
NB. Tests using "current" dates in the later 1900's would not have seen
NB. this problem.
NB.
NB. A good test date is 2001-03-01 (1st March 2001); the algorithm can
NB. easily be run manually.
NB.
NB. The problem has been seen, for example, in C code in an Internet draft.
NB.
NB. Those whose systems do suitable run-time checking may already have
NB. discovered the problem.
NB.
NB. John Stockton, Surrey, UK.  http://www.merlyn.demon.co.uk/programs/
NB. Dates: miscdate.htm moredate.htm js-dates.htm pas-time.htm critdate.htm
NB. etc.

NB. Following from Ric Sherlock's RicSherlock/Extend Dates Project/DatesAdd Script

NB.*fmtDate v Format a date in a given format
NB. eg: '\Date is: DDDD, D MMM, YYYY' fmtDate toDayNumber 6!:0''
NB. result: formated date string (or array of boxed, formated date strings)
NB. y is: numeric array of dates given as Day Numbers
NB. x is: optional format string specifing format of result
NB.      Use the following codes to specify the date format:
NB.      D: 1   DD: 01   DDD: Sun   DDDD: Sunday
NB.      M: 1   MM: 01   MMM: Jan   MMMM: January
NB.             YY: 09              YYYY: 2009
NB.     To display any of the letters (DMY) that are codes,
NB.     "escape" them with '\'
fmtDate=: 3 : 0
  'MMMM D, YYYY' fmtDate y
  :
  codes=. ;:'D DD DDD DDDD M MM MMM MMMM YY YYYY'
  pic=. x

  'unesc pic'=. '\' escaped pic
  pic=. (1 , 2 ~:/\unesc *. pic e. 'DMY') <;.1 pic  NB. Cut into tokens
  var=. pic e. codes                                NB. mark sections as vars

  ymd=. |: todate <.,y

  t=. 2{ymd                                         NB. Days
  values=. ('';'r<0>2.0') fmt"0 1 t
  t=. (7|3+<.,y){WKDAYS                             NB. Day names
  values=. values,(3&{.&.> ,: ]) t
  t=. 1{ymd                                         NB. Months
  values=. values, ('';'r<0>2.0') fmt"0 1 t
  t=. (0>.t){MONTHS                                 NB. Month names
  values=. values, (3&{.&.> ,: ]) t
  t=. 0{ymd                                         NB. Years
  values=. values, (2&}.&.> ,: ]) fmt t

  res=. <@;"1 (|:(codes i. var#pic){values) (I. var)}"1 pic
  if. 0=#$y do. res=. ,>res else.  res=. ($y)$ res end.
  res
)

NB.*escaped v process an escaped string
NB. result: 2-item list of boxed mask & string:
NB.          0{:: boolean mask of non-escaped characters
NB.          1{:: string with escape character compressed out
NB. y is: An escaped string
NB. x is: character used to escape string
NB. eg: '\' escaped '\Date is: D\\MM\\YYYY'
escaped=: 3 : 0
  '\' escaped y                         NB. default escape char
:
  mskesc=. y = x
  mskfo=. 2 < /\ 0&, mskesc             NB. 1st occurences of x
  mskesc=. mskesc ([ ~: *.) 0,}: mskfo  NB. unescaped 1st occurences of x
  mskunescaped=. -. 0,}: mskesc         NB. unescaped characters
  (-.mskesc)&# &.> mskunescaped;y       NB. compress out unescaped x
)

fmt=: 8!:0
