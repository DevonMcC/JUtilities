NB.* exclusions.ijs: list of directories to exclude from usual backups
NB. because they change often due to processes about which I don't care
NB. or they get updated sometimes with very large files.
NB. This was formerly part of "parseDir.ijs" but I broke it out when I
NB. realized I also need it in "parallelParseDir.ijs".

NB.* rmEndSep: remove terminal path separator from string.
NB.* extractExclusions: extract names of target, exclude dirs, and files from global EXCLUDEUSUAL.
NB.* EXCLUDEUSUAL: list of usual files and directories to exclude from backup.

NB.* rmEndSep: remove terminal path separator from string.
rmEndSep=: 3 : '(]}.~[:-PATHSEP_j_={:)"1 dtb y'

extractExclusions=: 3 : 0
NB.* extractExclusions: extract names of target, exclude dirs, and files from global EXCLUDEUSUAL.
   targ=. rmEndSep y               NB. Exclude target to avoid unwanted recursion.
   sections=. '[ExcludeDirs]';'[ExcludeFiles]'
   xu=. EXCLUDEUSUAL
   xu=. xu#~&.>-.&.>+./\&.>(<'NB.')E.&.>xu  NB. Exclude comments
   xu=. xu#~0~:;#&.>xu
   whsect=. >+./&.>sections E.&.>/ xu
   secord=. /:sections i. ' '-.~&.>xu#~+./whsect
   targ;secord{(+./whsect)<;._1 xu
NB.EG 'targ xd xf'=. extractExclusions y
)

NB. Exclude the usual files and directories from being copied given list of Files &
NB. Directories (result of munge_dir) & source Disk & target Disk[:\dir] names.
NB. Some DBs big enough to be done separately.
NB. Need to include a [regexp] exclusion section to apply to files, e.g.
NB. "saves-{d}*", "*~", etc.

NB. Use this to exclude nothing.
EXCLUDEUSUAL=: '[ExcludeDirs]';'[ExcludeFiles]'

NB.* EXCLUDEUSUAL: list of usual files and directories to exclude from backup.
EXCLUDEUSUAL=: <;._2 CR-.~jpathsep 0 : 0
[ExcludeDirs]
avg
$Recycle.Bin
.emacs.d
.eshell
amisc\Ainfo\sentmail
amisc\Incoming
amisc\pix\Photos
amisc\pix\Sel
amisc\sound
ant
binaries
Boot
ca_lic
CFGSAFE
Data
Documents and Settings
downloads
DRV
i386
Informatica
Intel
My Dropbox
oracle
PDMEngineTest
Pgm\d2cpp-0.1.0
Pgm\ffmpeg-20200824-3477feb-win64-static
Pgm\j902
Pgm\mingw64
Pgm\msys64
Pgm\Python27\Lib
Pgm\Python35-32\Lib
Pgm\Python37-64\Lib
pgm\R
pgm\strawberry
Pgm\vcpgk
Program Files (x86)
Program Files
ProgramData
Recycled
Recycler
Sengent
source_control
temp
Users\Administrator
Users\All Users
Users\Default
Users\devon
Users\itsupport
Users\MSSQL$DHM
Users\Public
vbroker
WINDOWS
Windows.old
Windows.old.000
ws
zenworks

[ExcludeFiles]   NB. Files to exclude from any directory
~
*.bz2
*.filters
*.idb
*.ilk
*.lastbuildstate
*.manifest
*.obj
*.pdb
*.rc
*.res
*.sdf
*.sln
*.tlog
*.user
*.vcxproj
*.zip
.history
.bash_history
.emacs~
AUTOEXEC.BAT
CONFIG.SYS
DHMTest*
GII_ICD.txt
IO.SYS
MSDOS.SYS
NTDETECT.COM
NTLDR
SECURITY
SOFTWARE
stderr_Server.txt
stdout_Server.txt
SYSTEM
SYSTEM.ALT
Setup.log
Thumbs.db
USER0000.log
boot.ini
default.dlf
eventlog.log
fold0000.frm
git_shell_ext_debug.txt
hiberfil.sys
installer_debug.txt
keepAlive.log
mdr.log
pagefile.sys
pspbrwse.jbf
quote.flag
sysiclog.txt
)
NB.*** Need to actually use the wildcards in the file list above!!!

EV=: getEnviVars ''
WINDIR=: endSlash ,>EV{~<1,~(toupper&.>0{"1 EV)i.<'WINDIR'

NB. Replace WINNT with actual Windows system dir from environment var.
EXCLUDEUSUAL=: ('WINNT';<'\'-.~WINDIR}.~WINDIR i. '\') stringreplace EXCLUDEUSUAL
