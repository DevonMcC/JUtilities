NB.* cmdtool.ijs: run external OS command and get result.

NB. From: "Simon Ampleman" <sa@infodev.ca>
NB. To: forum@jsoftware.com
NB. Subject: RE: Jforum: Waiting for dos program to complete
NB. Date: Mon, 28 Oct 2002 13:02:43 -0500

coclass 'cmdtool'

NB. Usage:
NB. a=: '' conew 'cmdtool'
NB. runCmd__a 'dir'

NB. Can disable waiting (set x to 0), the J call returns
NB. immediately even though the wait command won't return 
NB. for 12 seconds.
NB.EG         $ 0 runcommand__a 'wait 12'
NB.        0 0

create=: 3 : 0
   try. wd 'pc ShellObj' catch. 'May already be defined.' end.
   wd 'cc WshShell oleautomation:Wscript.Shell'
   wd 'cc fso oleautomation:Scripting.FileSystemObject'
   wd 'olemethod fso base GetSpecialFolder 2'
   gTmpPath=: wd 'oleget fso temp Path'
)

cmdtool_close=: destroy=: 3 : 0
   wd 'pclose'
   codestroy''
)

gettmpfile=: 3 : 0
   gTmpPath, '\', wd 'olemethod fso base GetTempName'
)

runCmd=: 3 : 0
   0 1 runCmd y
:
   sTempName =. gettmpfile ''
   cmd =. y

   e =. wd 'olemethod WshShell base run "cmd /c ',cmd, ' > ',sTempName,'" ',": x
   try.
       res =. 1!:1 < sTempName
       1!:55 < sTempName
       e; res
   catch.
       empty ''
   end.
)

EAV=: 255{a.

runCmd2=: 3 : 0
   0 1 runCmd2 y
:
   sTempName =. gettmpfile ''
   cmd=. EAV,'cmd /c ',y, ' > ',sTempName,EAV,' ',": x
   e =. wd 'olemethod WshShell base run ',cmd
   try.
       res =. 1!:1 < sTempName
NB.       1!:55 < sTempName
       e; res; <cmd
   catch.
       empty ''
       cmd
   end.
)
