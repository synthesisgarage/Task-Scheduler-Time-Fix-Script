@ECHO OFF

REM Created: 14JUN2024
REM Author: Dakota Stewart
REM Purpose: Compensate for a malfunctioning CMOS chip to fix Date/Time upon login

REM Enable Delayed Expansion to handle variables inside loops or code blocks
SETLOCAL EnableDelayedExpansion

REM Refresh log
ECHO ^>^>^> Running Dakota's Time Fix Script... > C:\Users\synth\Documents\Logs\time-fix-log.txt


REM Initialize CYCLE variable based on input parameter %1
SET /A CYCLE=2
SET /A CYCLE=%1

REM Validate input and set default value if CYCLE is not provided
IF "%CYCLE%"=="" SET /A CYCLE=2

REM We should really check if we are even connected...
PING -n 1 time.windows.com
IF %ERRORLEVEL% NEQ 0 (
    ECHO Unable to Access Windows Time Service. Exiting... >> C:\Users\synth\Documents\Logs\time-fix-log.txt
    GOTO END
)

REM Start W32Time service
NET START W32TIME

REM Check if service start was successful
IF %ERRORLEVEL% EQU 0 (
    REM Retry synchronization if initial attempt fails
    :SYNC
    W32TM /RESYNC
    
    REM Check if synchronization was successful
    IF %ERRORLEVEL% NEQ 0 (
        SET /A CYCLE-=1
        IF %CYCLE% LSS 0 GOTO FAIL
        GOTO SYNC
    )

    ECHO Sync Successful.
    ECHO Sync Successful on: %DATE% ^| %TIME% >> C:\Users\synth\Documents\Logs\time-fix-log.txt
    GOTO END
)

REM Handle sync failure
:FAIL
ECHO Sync Unsuccessful.
ECHO Sync Unsuccessful. >> C:\Users\synth\Documents\Logs\time-fix-log.txt
GOTO END

REM Handle negative input error
:NEG_ERROR
ECHO Please enter positive numbers only as input.

REM End script and stop W32Time service
:END
NET STOP W32TIME