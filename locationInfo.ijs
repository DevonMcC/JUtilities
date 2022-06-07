NB.* locationInfo.ijs: information to distinguish run-time location &
NB. ID for known flash & other drives.

NB.* KNMACH: Known machines: network IDs to distinguish different machines I use.
NB.* KMPFX: Known-machine prefixes to de-couple network ID from functionality.
NB.* KNIDS: Known-IDs associated with each machine - good idea?
NB.* MDESC: Description of machine
NB.* whoami: find what machine and user-id I'm on (assume Novell net command).
NB.* nonEmptyDrive: return drive letters of active drives.
NB.* locateFlashDrive: locate known flash drive by name.
NB.* NED: drive letters of non-empty (present) drives
NB.* PICDRVguess: guess which SD card has pictures on it.
NB.* EXTERNDRV: external drives known by name

'KNMACH KMPFX KNIDS MDESC'=: <"1|:<;._1&><;._2 ] 0 : 0
|DESKTOP-6POO6QU|Dell2021|devonmcc@gmail.com|Dell desktop 2021
|DAEDALUS-AA383F|HL|Dev|Home Dell laptop
|L3N0V0|HLL|Dev|Home Lenovo laptop
|DMCCHINE|HD|Devon|Home Gateway desktop
|NY0193FF5D1|WMM|devon_mccormick|S&P old main desktop
|NY015CDSSK1|WL|devon_mccormick|S&P old lab machine
|NYCCMSDP9XWZ361|WTM|devon_mccormick|S&P old test machine
|NY016Z40NM1|NWMM|devon_mccormick|S&P last desktop
|DMCCOR-E6420|CIQLap|devon_mccormick|CapIQ laptop
|DEVONMCC-ROG160|asus|DevonMcC|Home ASUS laptop - pre-break
|NY01-6YFGM12|ciqNew|devon_mccormick|New 16GB Clarifi laptop
|NY01-8YFGM12|ciqRB|devon_mccormick|16GB Clarifi laptop after HD crash re-boot
|ASUS-256SSD|asus|DevonMcC|Home ASUS laptop
|ROG-160|asus|DevonMcC|Home ASUS laptop
|ROG-160|asus|Owner|Home ASUS laptop
||BK|Generic|Unknown
)
KNMACH=: (<'\\'),&.>}:KNMACH
NB. #&>KNMACH;KMPFX;<KNIDS NB. 1st one is 1 shorter than other 2.

NB.* whoami: find what machine and user-id I'm on (assume Novell net command).
whoami=: 3 : 0
   sess=. spawn_jtask_ 'net config workstation'
   if. 'not started' +./ . E. tolower sess do. 
       wait 2 [ shell 'net start workstation'
       sess=. spawn_jtask_ 'net config workstation'
   end.
   sess=. dsp&.><;._1 LF,sess-.CR            NB. Vec of lines
   sess=. ><;._1&.> ' ',&.>,sess             NB. Mat of words
   strs=. 'COMPUTER';<'USER'                 NB. Strings to key on
   wh=. (<toupper&.>0{"1 sess)e.&.> <&.>strs NB. Which lines start with strings
   wh=. ;I.&.>(<(toupper&.>1{"1 sess)e. <'NAME')*.&.>wh
   wh{2{"1 sess
NB.EG 'machine userid'=. whoami ''
)

nonEmptyDrive=: ] #~ 0 ~: [: #&> [: dir&.> (<':\*') ,&.>~ ]
locateFlashDrive=: ] #~ ] ([: +./ [ E. [: toupper [: shell 'dir ' , ':\*' ,~ ])&>~ [: < [: toupper[ 
NB.EG 'KINGSTON' locateFlashDrive nonEmptyDrive 'ABCDEFGHIJ'

NED=: nonEmptyDrive 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

3 : 0 ''
NB.* PICDRVguess: guess which SD card has pictures on it.
if. -. nameExists 'PICDRVguess' do.
   PICDRVguess=: 'FC30-3DA9' locateFlashDrive NED
   PICDRVguess=: PICDRVguess,,~'LUMIX2GB' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'SONY32GB' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'LUMIX16GB' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'CANON16GB' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'KINGSTO16GB' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'LUMIX64GB' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'SDULTRA64GB' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'ULTRAPLUS32' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'RICOH_GR' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'QUICK16' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'SDULTRAPLUS' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'MICRO32' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'HD1080P' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'LUMIX32GB' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'BLKMICRO32' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'ULTRA32' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'SD32_80' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'BLUE32SDHC' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'PNY32GB' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'LUMIX' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'SDHD64GB' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'AGFA2GB' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'PNY16GB' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'SDHC32GB' locateFlashDrive NED
   PICDRVguess=: {.PICDRVguess,~'SDXC' locateFlashDrive NED
end.
0 0$''
)

3 : 0 ''
NB.* EXTERNDRV: external drives known by name
if. -. nameExists 'EXTERNDRV' do.
   EXTERNDRV=: ([: {. ] #~ 0 < [: #&> [: dir&.> (<':\*') ,&.>~ ]) 'EFGH'  NB. Guess
   EXTERNDRV=: 'KINGSTON' locateFlashDrive NED
   EXTERNDRV=: {:EXTERNDRV,'BLACK16GB' locateFlashDrive NED
   EXTERNDRV=: {:EXTERNDRV,'BLACK8GBPNY' locateFlashDrive NED
   EXTERNDRV=: {:EXTERNDRV,'TRANSCEND' locateFlashDrive NED
   EXTERNDRV=: {:EXTERNDRV,'S&P DRIVE' locateFlashDrive NED
   EXTERNDRV=: {:EXTERNDRV,'GIGA32' locateFlashDrive NED        NB. SD
   EXTERNDRV=: {:EXTERNDRV,'SSD256_2011' locateFlashDrive NED  NB. SSD
   EXTERNDRV=: {:EXTERNDRV,'WHENI''M64' locateFlashDrive NED   NB. Thumb
   EXTERNDRV=: {:EXTERNDRV,'PINK31GB' locateFlashDrive NED     NB. mini-thumb
   EXTERNDRV=: {:EXTERNDRV,'ULTRAPLUS32' locateFlashDrive NED  NB. SD
   EXTERNDRV=: {:EXTERNDRV,'OS' locateFlashDrive NED   NB. Externally-mounted internal drive
   EXTERNDRV=: {:EXTERNDRV,'LISMAISONGS' locateFlashDrive NED  NB. Black thumb
   EXTERNDRV=: {:EXTERNDRV,'LILACLEXAR' locateFlashDrive NED   NB. Lilac-shelled thumb
   EXTERNDRV=: {:EXTERNDRV,'LILAC2LEXAR' locateFlashDrive NED  NB. 2nd Lilac-shelled thumb
   EXTERNDRV=: {:EXTERNDRV,'PNYSSD240' locateFlashDrive NED    NB. PNY SSD 240 GB external
   EXTERNDRV=: {:EXTERNDRV,'MANGO256' locateFlashDrive NED
   EXTERNDRV=: {:EXTERNDRV,'RUBRYORANGE' locateFlashDrive NED
   EXTERNDRV=: {:EXTERNDRV,'TINY64' locateFlashDrive NED    NB. Tiny Sandisk 64GB thumb
   EXTERNDRV=: {:EXTERNDRV,'Seagate4TB' locateFlashDrive NED    NB. Seagate 4TB Expansion
   lavnms=. (<'Lav64_'),&.>":&.>i.10    NB. Lav_[0-9] thumbs
   EXTERNDRV=: {:EXTERNDRV, ;a:-.~lavnms locateFlashDrive&.><NED
   EXTERNDRV=: {:EXTERNDRV,'BLKSLD16GB' locateFlashDrive NED    NB. 16 GB black thumb w/sliding cover
end.
0 0$''
)
