NB.* mutex.ijs: implement mutual exclusion via file locking.

coclass 'mutex'
require 'task'      NB. Only for "spawn" in "whoami" - not necessary.

fopen=: [:1!:21<    NB. Open file named by y.
fclose=: [:1!:22<   NB. Close file name or number y.
flock=: 1!:31       NB. File number, index, length of region to lock
funlock=: 1!:32     NB. File number, index, length of region to unlock
whlocks=: 1!:30     NB. Which locks - 3-cols: file #, index, and length
whfiles=: 1!:20     NB. Which files - 2-cols: file #; name
getpid=: 2!:6       NB. Current process ID
qts=: 6!:0          NB. Timestamp -integers: Y M D h m s.s (millisec?)
fwrix=: 1!:12       NB. Write to position (1{y) for file-id 0{y.

LOCKFL=: 'Lock.fl'  NB. Central hold file
LFINFO=: (i.0);''   NB. Hold file details while holding

NB.* getMyInfo: nice to have info identifying who has the lock and when.
getMyInfo=: 3 : '100{.(;'' '',~&.>whoami''''),":(getpid,qts)'''''

NB.* getHold: put hold on lock file.
getHold=: 3 : 0
   fid=. fopen LOCKFL [ myinfo=. getMyInfo ''
   if. -. fid e. ;0{"1 whlocks '' do.             NB. If we don't have lock,
       while. -.flock fid,0,100 do. wait ?0 end.  NB.  keep waiting until we
       myinfo fwrix fid;0                         NB.  get it; put ID info in
       LFINFO=: fid (]{~[i.~[:;0{"1]) whfiles ''  NB.  file & update global.
   end.
   fid;myinfo
NB.EG 'fid myinfo'=. getHold ''  NB. File ID, my ID info.
)

NB. funlock (>0{LFINFO) (]{~[i.~[:;0{"1]) whlocks ''
releaseHold=: 3 : 0
   if. 0~:#>0{LFINFO do. 0*./ . =#&>LFINFO=: (i.0);'' [ fclose >0{LFINFO end.
)

NB.* getMUP: get Machine name, User ID, Process ID from my info string.
getMUP=: 13 : '3{.<;._1 '' '',y'

NB.* dsp: Despace - remove leading, trailing and redundant spaces.
dsp=: [:(#~(+.(1:|.(></\)))@(' '&~:))"1 (#~([:(+./\*. +./\.)' '&~:))"1

NB.* whoami: get machine and user ID - Windows only.
whoami=: 3 : 0
   assert. 6-:9!:12 ''                       NB. Fail if not Windows
   sess=. spawn_jtask_ 'net config workstation'
   sess=. dsp&.><;._1 LF,sess-.CR            NB. Vec of lines
   sess=. ><;._1&.> ' ',&.>,sess             NB. Mat of words
   strs=. 'COMPUTER';<'USER'                 NB. Strings to key on
   wh=. (<toupper&.>0{"1 sess)e.&.> <&.>strs NB. Which lines start w/ strings?
   wh=. ;I.&.>(<(toupper&.>1{"1 sess)e. <'NAME')*.&.>wh
   wh{2{"1 sess
NB.EG 'machine userid'=. whoami ''
)
