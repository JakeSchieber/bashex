:: Create a wrapper to the windows bash cmd
:: Must be added to Windows Environment in order to perform global wrap

:: Do not print any of the executed cmds. If any cmd has output then pipe to >nul
@echo off

:: Create a bashex label which will allow for us to recursively enter bash
:bashex

:: files under under cmdQueue.temp
set "filename=cmdQueue.temp"
set "file=C:\CmdLovesBash\%filename%"

:: clear the contents of the queue before going in
IF EXIST %file% (
    echo NOTE: bashex enterred with commands on the queue... These commands were overwritten.
    del %file%
)

:: execute bash until exit has been called
bash

:: if cmdQueue exists then loop through each line in cmdQueue and store in array
:: else exit called with no cmdQueue args -> Just close
IF EXIST %file% (
    set /A i=0
    for /F "usebackq delims=" %%a in ("%file%") do (
        set /A i+=1
        call set array[%%i%%]=%%a
        call set n=%%i%%
    )
) else (
    exit /b
)

:: delete the queue after it has been read in
del "%file%"

:: if the cmdQueue is not 1 or 2 lines long then it is not valid
:: there is no or in batch so use a flag on either true case (n = 1 OR n = 2)
set flag=0
if %n% == 1 (
    set flag=1
)
if %n% == 2 (
    set flag=1
)
IF NOT %flag% == 1 (
    echo ERROR - Improperly formatted '%filename%'
    exit /b
)

:: First line in cmdQueue is the directory to change to.
:: if it is not valid then show error to user and fall back to bash.
:: else cd into it
:: WARNING: cd will not hold if powershell called batch filed
IF NOT EXIST "%array[1]%" (
    echo ERROR - Unable to cd to mimed directory
    call :bashex
)
cd /D "%array[1]%"

:: if cmdQueue was of length 1 then simple exit to specified directory
if %n% == 1 (
    exit /b >nul
)

:: if cmdQueue was of length 2 then execute the command.
:: TODO: support multiple commands.
:: POSSIBLE TODO: Validate the command execution return
call %array[2]% >nul

:: return to the top of the script and enter bash again
call :bashex
