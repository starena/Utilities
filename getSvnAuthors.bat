echo off
REM Batch File to obtain the UNIQUE commit list in DOS (Windows CMD) for all SVN repositories

REM THIS USES SUPER-SED, LOCATED AT: http://www.pement.org/sed/
REM   (DIRECT LINK USED FOR SED.EXE: http://sed.sourceforge.net/grabbag/ssed/sed-3.59.zip )
REM Made by Adam Rofer, distribute freely, etc
REM This was developed to work in Windows Server 2007 SP2, so if you're using
REM     XP or Win2K then the "FOR" and "SORT" commands may not be present or use different syntax

SET REPOSITORY_DIR=C:\working\tm-fp-trunk
SET FULL_LIST=authors.txt
SET REPO_URL=http://be-devsrv01:81/svn/tm-fp/trunk

del /q %FULL_LIST%
for /f %%g in ('dir /b /a:d %REPOSITORY_DIR%') DO call :getlog %%g
type %FULL_LIST% | sort | sed "$!N; /^\(.*\)\n\1$/!P; D" > %FULL_LIST%xx
del /q %FULL_LIST%
ren %FULL_LIST%xx %FULL_LIST%
goto :DONE

rem SUB -------------------------
:getlog
svn log %REPO_URL%/%1 --quiet --xml | sed -n -e "s/<\/\?author>//g" -e "/[<>]/!p" | sort | sed "$!N; /^\(.*\)\n\1$/!P; D" > %1.txt
type %1.txt >> %FULL_LIST%
goto :eof
rem END SUB ---------------------

:DONE