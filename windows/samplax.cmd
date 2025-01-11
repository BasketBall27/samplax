:: contribute 2024-2025 Anonim "Socket"
@ECHO OFF

setlocal EnableDelayedExpansion

color F

:: pawncc 3.10.7^
:: Usage:   pawncc <filename> [filename...] [options]
:: Options:
::         -A<num>  alignment in bytes of the data segment and the stack
::         -a       output assembler code
::         -C[+/-]  compact encoding for output file (default=+)
::         -c<name> codepage name or number; e.g. 1252 for Windows Latin-1
::         -Dpath   active directory path
::         -d<num>  debugging level (default=-d1)
::             0    no symbolic information, no run-time checks
::             1    run-time checks, no symbolic information
::             2    full debug information and dynamic checking
::             3    same as -d2, but implies -O0
::         -e<name> set name of error file (quiet compile)
::         -H<hwnd> window handle to send a notification message on finish
::         -i<name> path for include files
::         -l       create list file (preprocess only)
::         -o<name> set base name of (P-code) output file
::         -O<num>  optimization level (default=-O1)
::             0    no optimization
::             1    JIT-compatible optimizations only
::             2    full optimizations
::         -p<name> set name of "prefix" file
::         -R[+/-]  add detailed recursion report with call chains (default=-)
::         -r[name] write cross reference report to console or to specified file
::         -S<num>  stack/heap size in cells (default=4096)
::         -s<num>  skip lines from the input file
::         -t<num>  TAB indent size (in character positions, default=8)
::         -v<num>  verbosity level; 0=quiet, 1=normal, 2=verbose (default=1)
::         -w<num>  disable a specific warning by its number
::         -X<num>  abstract machine size limit in bytes
::         -XD<num> abstract machine data/stack size limit in bytes
::         -Z[+/-]  run in compatibility mode (default=-)
::         -E[+/-]  turn warnings in to errors
::         -\       use '\' for escape characters
::         -^       use '^' for escape characters
::         -;[+/-]  require a semicolon to end each statement (default=-)
::         -([+/-]  require parantheses for function invocation (default=-)
::         sym=val  define constant "sym" with value "val"
::         sym=     define constant "sym" with value 0

:: Options may start with a dash or a slash; the options "-d0" and "/d0" are
:: equivalent.

:: Options with a value may optionally separate the value from the option letter
:: with a colon (":") or an equal sign ("="). That is, the options "-d0", "-d=0"
:: and "-d:0" are all equivalent.

SET "ASM_OPTION_M=-o"
SET "ASM_OPTION_P=-C- -O0 -d3"

IF not EXIST .cache ( MKDIR .cache )
SET "METADAT_FILE=.cache\cache.log"

(
    ECHO Thanks for using this program
    ECHO -----------------------------
    ECHO Use '$ cat -R' to compress Pawn to Lax and enter your script file name.
    ECHO Use '$ cat -c' to compile your Pawn Script's
    ECHO Use '$ cat -r' for running your server's
    ECHO Use '$ cat -t' to test your server's
) > ".cache\readme.txt"

SET "algorithm=%username%@%computername%"
IF EXIST "%BATCHDIR%.cache\users.txt" ( DEL "%BATCHDIR%.cache\users.txt" /q >nul )
powershell -Command "[BitConverter]::ToString([System.Security.Cryptography.SHA256]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes('%algorithm%'))).Replace('-', '') | Out-File -FilePath '.cache\users.txt' -Append"

TITLE %algorithm%:~

SET "BATCHDIR=%~dp0"
SET "BATCHTITLE="
SET "BATCHSTS=false"
SET "BATCHPAWNCC="
SET "BATCHNAME=samplax.cmd"
SET "SVRDEF=samp-server.exe"

:COMMAND_TYPEOF
FOR /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & ECHO on & FOR %%b in (1) do rem"') do (SET "DEL=%%a")

<nul SET /p="" 
    CALL :COLOURTEXT A "%algorithm%" 
    <nul SET /p=":~$ " 
    SET /p LAXTYPEOF=" "
    GOTO NEXT

:COLOURTEXT
    <nul SET /p "=%DEL%" > "%~2"
    FINDSTR /v /a:%1 /R "+" "%~2" nul
    del "%~2" > nul
    GOTO :eof

:NEXT
SET "BATCHFILE=true"
SET "BATCHOPTION=cat"

IF "%LAXTYPEOF%"=="%BATCHOPTION% -c" (

    TASKKILL /f /im "%SVRDEF%" >nul 2>&1

    SET "BATCHTITLE=compilers"
    TITLE %algorithm%:~/!BATCHTITLE!
    
    ECHO.

    SET "BATCHSTS=true"
    GOTO COMPILERS

) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -r" (

    TASKKILL /f /im "%SVRDEF%" >nul 2>&1
    
    SET "BATCHTITLE=running"
    TITLE %algorithm%:~/!BATCHTITLE!

    GOTO SERVERS

) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -t" (
    
:TESTSERVERS
    IF EXIST "%BATCHDIR%server_log.txt" ( DEL "%BATCHDIR%server_log.txt" /q >nul )
    
    TASKKILL /f /im "%SVRDEF%" >nul 2>&1
    
    TIMEOUT /t 1 >nul
        START /min "" "%SVRDEF%"
    TIMEOUT /t 1 >nul
        TYPE server_log.txt
		ECHO.
	TASKKILL /f /im "%SVRDEF%" >nul 2>&1
	
    GOTO BATCHEND

) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -ci" (

    TASKKILL /f /im "%SVRDEF%" >nul 2>&1

    SET "BATCHTITLE=compile running"
    TITLE %algorithm%:~/!BATCHTITLE!

    SET "BATCHSTS=false"
    
    CALL :COMPILERS
    FINDSTR /i "error" %METADAT_FILE% >nul && ECHO. || CALL :OK_NEXT

:OK_NEXT
    ECHO # Press any key to running . . .
    PAUSE >nul

:SERVERS
    IF EXIST "%BATCHDIR%server_log.txt" ( DEL "%BATCHDIR%server_log.txt" /q >nul )
	
    START "" "%SVRDEF%"
	
    TIMEOUT /t 2 >nul
    TASKLIST | FIND /i "%SVRDEF%" >nul

    IF not EXIST %SVRDEF% (
        ECHO # %SVRDEF% not found..
        TIMEOUT /t 1 >nul
            START "" "https://sa-mp.app/"
        GOTO COMMAND_TYPEOF
    )

    IF ERRORLEVEL 1 (
        SET "BATCHTITLE=running - failed"
        TITLE %algorithm%:~/!BATCHTITLE!

        ECHO.
        ECHO # [%time%] S?.. no
		
        IF EXIST "server_log.txt" (
            TIMEOUT /t 2
                TYPE server_log.txt
            ECHO.
        ) ELSE (
            ECHO # server_log.txt not found.
        )
        
        <nul SET /p=""
            CALL :COLOURTEXT a "# End."
            ECHO.
        GOTO COMMAND_TYPEOF
    ) ELSE (
        ECHO # [%time%] S?.. Done
        ECHO.
		
        TIMEOUT /t 2 >nul
        FINDSTR /i "error" server_log.txt >nul && CALL :START_TRUE2 || CALL :START_FALSE2

:START_TRUE2
        <nul SET /p=""
            CALL :COLOURTEXT 4X "~"
            ECHO    "Error"   .. Yes .. True
        CALL :ERROR_CACHE
        
        GOTO :eof

:START_FALSE2
        <nul SET /p=""
            CALL :COLOURTEXT a "~"
            ECHO    "Error"   .. No .. False
        
:CHECK2
        FINDSTR /i "failed" server_log.txt >nul && CALL :START_TRUE || CALL :START_FALSE

:START_TRUE
        <nul SET /p=""
            CALL :COLOURTEXT 4X "~"
            ECHO    "Failed"  .. Yes .. True
        CALL :FAILED_CACHE
        
        GOTO :eof

:START_FALSE
        <nul SET /p=""
            CALL :COLOURTEXT a "~"
            ECHO    "Failed"  .. No .. False

:CHECK3
        FINDSTR /i "invalid" server_log.txt >nul && CALL :START_TRUE3 || CALL :START_FALSE3

:START_TRUE3
        <nul SET /p=""
            CALL :COLOURTEXT 4X "~"
            ECHO    "Invalid" .. Yes .. True
        CALL :INVALID_CACHE

        GOTO :eof

:START_FALSE3
        <nul SET /p=""
            CALL :COLOURTEXT a "~"
            ECHO    "Invalid" .. No .. false

        ECHO.
        GOTO BATCHEND
    )

:ERROR_CACHE
    ECHO.
    FINDSTR /i "error" ^> server_log.txt
    ECHO.
    GOTO CHECK2
:FAILED_CACHE
    ECHO.
    FINDSTR /i "failed" ^> server_log.txt
    ECHO.
    GOTO CHECK3
:INVALID_CACHE
    ECHO.
    FINDSTR /i "invalid" ^> server_log.txt
    ECHO.

    GOTO COMMAND_TYPEOF

) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -C" (

    SET "BATCHTITLE=clear screen"
    TITLE %algorithm%:~/!BATCHTITLE!

    CLS
    GOTO COMMAND_TYPEOF

) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -V" (

    SET "BATCHTITLE=vscode tasks"
    TITLE %algorithm%:~/!BATCHTITLE!

    IF EXIST ".vscode" (
        RMDIR /s /q .vscode
    )
    MKDIR ".vscode"
    (
        ECHO {
        ECHO   "version": "2.0.0",
        ECHO   "tasks": [
        ECHO     {
        ECHO       "label": "Run Lax",
        ECHO       "type": "process",
        ECHO       "command": "${workspaceFolder}/%BATCHNAME%",
        ECHO       "group": {
        ECHO           "kind": "build",
        ECHO           "isDefault": true
        ECHO       },
        ECHO       "problemMatcher": [],
        ECHO       "detail": "Task to run the batch file"
        ECHO     }
        ECHO   ]
        ECHO }
    ) > ".vscode\tasks.json"
    ECHO # [%time%] C? '.vscode\tasks.json'...: [yes]
    GOTO BATCHEND

) ELSE IF "%LAXTYPEOF:~0,2%"=="./" (

    SET RENEWTYPEOF=%LAXTYPEOF:~2%

    FOR /r "%BATCHDIR%" %%a in ("!RENEWTYPEOF!.*") do (
            ECHO %%~nxa | FINDSTR /i ".lax" >nul
        IF not ERRORLEVEL 1 (
            ECHO Error: File "%%~nxa" already contains .lax in its name...
            GOTO BATCHEND
        ) ELSE (
            ECHO %%~nxa | FINDSTR /i ".amx" >nul
            IF ERRORLEVEL 1 (
                ren "%%a" "!RENEWTYPEOF!.lax.pwn"
            ) ELSE (
                GOTO BATCHEND
            )
        )
    )
    
    GOTO BATCHEND

)  ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -R" (

    SET /p NAMEFROMINPUT="~ "

    FOR /r "%BATCHDIR%" %%a in ("!NAMEFROMINPUT!.*") do (
        ECHO %%~nxa | FINDSTR /i ".lax" >nul
        IF not ERRORLEVEL 1 (
            ECHO Error: File "%%~nxa" already contains .lax in its name...
            GOTO BATCHEND
        ) ELSE (
            ECHO %%~nxa | FINDSTR /i ".amx" >nul
            IF ERRORLEVEL 1 (
                ren "%%a" "!NAMEFROMINPUT!.lax.pwn"
            ) ELSE (
                GOTO BATCHEND
            )
        )
    )

    GOTO BATCHEND

) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -F" (

    SET "BATCHTITLE=folder existence check"
    TITLE %algorithm%:~/!BATCHTITLE!

    IF EXIST filterscripts (
        ECHO.
        ECHO # filterscripts is .. Ok ..
        ECHO  [A subdirectory or file filterscripts already exists.]
        ECHO -
        TIMEOUT /t 1 >nul
    ) ELSE (
        MKDIR filterscripts
        ECHO # [%time%] C? '%BATCHDIR%filterscripts'...: [yes]
        TIMEOUT /t 1 >nul
    )
    IF EXIST gamemodes (
        ECHO.
        ECHO # gamemodes is .. Ok ..
        ECHO  [A subdirectory or file gamemodes already exists.]
        ECHO -
        TIMEOUT /t 1 >nul
    ) ELSE (
        setlocal EnableDelayedExpansion
        MKDIR gamemodes
        (
            ECHO #include ^<a_samp^>
            ECHO.
            ECHO main^(^) {
            ECHO     printf "Hello, World!";
            ECHO }
        ) > "gamemodes\main.lax.pwn"
        endlocal
        ECHO.
        ECHO # [%time%] C? '%BATCHDIR%gamemodes'...: [yes]
        ECHO.
        TIMEOUT /t 1 >nul
    )
    IF EXIST scriptfiles (
        ECHO.
        ECHO # scriptfiles is .. Ok ..
        ECHO  [A subdirectory or file scriptfiles already exists.]
        ECHO -
        TIMEOUT /t 1 >nul
    ) ELSE (
        MKDIR scriptfiles
        ECHO # [%time%] C? '%BATCHDIR%scriptfiles'...: [yes]
        TIMEOUT /t 1 >nul
    )
    FOR /r "%BATCHDIR%" %%F in (*.lax*) DO (
        IF EXIST "%%F" (
            IF not "%%~xF"==".amx" (
                ECHO.
                ECHO # lax file is .. Ok ..
                ECHO  [A subdirectory or file %%F already exists.]
                ECHO -
                TIMEOUT /t 1 >nul
            )
        )
    )
    IF EXIST server.cfg (
        ECHO.
        ECHO # server.cfg is .. Ok ..
        ECHO  [A subdirectory or file server.cfg already exists.]
    ) ELSE (
        (
            ECHO ECHO Executing Server Config...
            ECHO lanmode 0
            ECHO rcon_password changename
            ECHO maxplayers 150
            ECHO port 7777
            ECHO hostname SA-MP 0.3
            ECHO gamemode0 main 1
            ECHO filterscripts 
            ECHO announce 0
            ECHO chatlogging 0
            ECHO weburl www.sa-mp.com
            ECHO onfoot_rate 40
            ECHO incar_rate 40
            ECHO weapon_rate 40
            ECHO stream_distance 300.0
            ECHO stream_rate 1000
            ECHO maxnpc 0
            ECHO logtimeformat [%H:%M:%S]
            ECHO language English
        ) > "server.cfg"
        ECHO # [%time%] C? '%BATCHDIR%server.cfg'...: [yes]
        ECHO.
        TYPE server.cfg
        ECHO.
        GOTO BATCHEND
    )

) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -X" (
    git clone https://github.com/laterium/samplax.git
) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -P" (
    START "" "https://github.com/pawn-lang/compiler/releases"
) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -D" (
    cmd /c dir
) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -K" (
    START %BATCHNAME%
    EXIT
) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -N" (
    cmd /c netstat -an
) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -I" (
    cmd /c ipconfig
) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% -S" (
    cmd /c systeminfo
) ELSE IF "%LAXTYPEOF%"=="help" (

    SET "BATCHTITLE=help"
    TITLE %algorithm%:~/!BATCHTITLE!
    
:HELPL
    ECHO usage: cat [-c compile] [-r running] [-t test server] [-ci compile-running] 
    ECHO       	   [-F folder check] [-C clear screen] [-P pawncc release] [-V vscode tasks]
    ECHO       	   [-X clone samplax] [-R rename file] [-K kill batch] [-D directory]
    ECHO       	   [-N netstat] [-I ipconfig] [-S systeminfo]
    GOTO COMMAND_TYPEOF

) ELSE IF "%LAXTYPEOF%"=="cat ." (

    GOTO TESTSERVERS

) ELSE IF "%LAXTYPEOF%"=="cat" (

    SET "BATCHTITLE=cat"
    TITLE %algorithm%:~/!BATCHTITLE!
    GOTO HELPL

) ELSE IF "%LAXTYPEOF%"=="" (
    GOTO COMMAND_TYPEOF
) ELSE IF "%LAXTYPEOF%"==" " (
    GOTO COMMAND_TYPEOF
) ELSE IF "%LAXTYPEOF%"=="%BATCHOPTION% " (
    GOTO HELPL
) ELSE (
    ECHO '!LAXTYPEOF!' is not recognized as an internal or external command,
    ECHO operable program or batch file.
    ECHO.
    GOTO HELPL
    GOTO COMMAND_TYPEOF
)

:BATCHEND
<nul SET /p=""
    CALL :COLOURTEXT a "# Press any key to return"
    ECHO.
PAUSE >nul
GOTO COMMAND_TYPEOF

:COMPILERS
    <nul SET /p=""
        CALL :COLOURTEXT a "~"
        ECHO %time%
        ECHO.

    FOR /r "%BATCHDIR%" %%P in (pawncc.exe) DO (
        IF EXIST "%%P" (
            SET "BATCHPAWNCC=%%P"
            GOTO PAWNCC
        )
    )
:PAWNCC
    IF not DEFINED BATCHPAWNCC (
        ECHO.
            ECHO # [%time%] pawncc not found in any subdirectories.
        ECHO.

        TIMEOUT /t 1 >nul
        START "" "https://github.com/pawn-lang/compiler/releases"
        GOTO COMMAND_TYPEOF
    )
    SET "BATCHFILE=false"
    FOR /r "%BATCHDIR%" %%F in (*.lax*) DO (
        IF EXIST "%%F" (
            IF not "%%~xF"==".amx" (
            
            SET "BATCHFILE=true"
            
            TITLE %%F
            
            SET "AMX_O=%%~dpnF"
            SET "AMX_O=!AMX_O:.lax=!%.amx"

            "!BATCHPAWNCC!" "%%F" %ASM_OPTION_M%"!AMX_O!" %ASM_OPTION_P% > %METADAT_FILE% 2>&1
            TYPE %METADAT_FILE%

            IF EXIST "!AMX_O!" (
                FOR %%A in ("!AMX_O!") DO (
                    ECHO.
                    <nul SET /p=""
                        CALL :COLOURTEXT a "~"
                        ECHO %time%
                        ECHO.

                        CALL :COLOURTEXT a "[#]~"
						
                        IF "%BATCHSTS%"=="true" (
                            SET "BATCHTITLE=compilers "%ASM_OPTION_M% %ASM_OPTION_P%""
                            TITLE %algorithm%:~/!BATCHTITLE!
                        ) ELSE IF "%BATCHSTS%"=="false" (
                            SET "BATCHTITLE=compiler - running "%ASM_OPTION_M% %ASM_OPTION_P%""
                            TITLE %algorithm%:~/!BATCHTITLE!
                        )
                        ECHO Total Size [%%~zA / bytes] ^| "!AMX_O!" ^| "%ASM_OPTION_M% %ASM_OPTION_P%" 
                )
            ) ELSE (
                    setlocal DisableDelayedExpansion 
                        <nul SET /p=""
                            CALL :COLOURTEXT 4X "[#]~"
                            ECHO Compilation failed!. ERR? .. Yes
                    endlocal
                        IF "%BATCHSTS%"=="false" (
                            GOTO BATCHEND
                        )
                )
                ECHO .
            )
        )
    )
    IF not "%BATCHFILE%"=="true" (
        setlocal DisableDelayedExpansion 
            <nul SET /p=""
                    CALL :COLOURTEXT 4X "[#]~"
                    ECHO Compilation failed!.
        endlocal
        ECHO    ~ "!BATCHDIR!.lax" no files found.
    )
    IF "%BATCHSTS%"=="true" (
        GOTO BATCHEND
    )
