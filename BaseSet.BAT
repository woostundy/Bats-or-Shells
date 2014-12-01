@echo off
echo =======================================================
echo =        1. ClearLogFile                              =
echo =        2. Change Port 3389 To 8989                  =
echo =        3. Close Some Port Dangerous                 =
echo =        4. Change Administrator To TestAccount       =
echo =        5. Windows Version                           =
echo =======================================================

:start
set "input="
set /p input=input your choose:
if "%input%"=="1" goto A
if "%input%"=="2" goto B
if "%input%"=="3" goto C
if "%input%"=="4" goto D
if "%input%"=="5" goto E

:A
ver|findstr /c:"6."&&goto A2008||goto A2003

:A2003
rem 清除日志 windows2003
wmic nteventlog where filename="AppEvent" call cleareventlog
rem 清除应用程序日志
wmic nteventlog where filename="SecEvent" call cleareventlog
rem 清除安全性日志
wmic nteventlog where filename="SysEvent" call cleareventlog
rem 清除系统日志
echo Success!
goto start

:A2008
rem 清除日志 windows2008
FOR /F "delims=" %%I IN ('WEVTUTIL EL') DO (WEVTUTIL CL "%%I") 
echo Success!
goto start

:B
rem change 3389 to 8989
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp" /v PortNumber /t REG_DWORD /d 8989 /f
echo Success!
goto start

:C
ver|findstr /c:"6."&&goto C2008||goto C2003

:C2003
rem 禁用端口 windows2003
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1029" -f *+0:135:TCP -n BLOCK -x >nul 
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1033" -f *+0:139:TCP -n BLOCK -x >nul 
ipseccmd  -w REG -p "HFUT_SECU" -r "Block UDP/139" -f *+0:139:UDP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1038" -f *+0:443:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/445" -f *+0:445:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block UDP/445" -f *+0:445:UDP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1025" -f *+0:1025:TCP -n BLOCK -x >nul
goto start
 
:C2008
rem 禁用端口 windows2008
netsh advfirewall firewall add rule name="deny tcp 135" dir=in protocol=tcp localport=135 action=block
netsh advfirewall firewall add rule name="deny tcp 139" dir=in protocol=tcp localport=139 action=block
netsh advfirewall firewall add rule name="deny tcp 139" dir=in protocol=tcp localport=139 action=block
netsh advfirewall firewall add rule name="deny udp 139" dir=in protocol=udp localport=139 action=block
netsh advfirewall firewall add rule name="deny udp 445" dir=in protocol=udp localport=445 action=block
netsh advfirewall firewall add rule name="deny tcp 445" dir=in protocol=tcp localport=445 action=block
netsh advfirewall firewall add rule name="deny tcp 1025" dir=in protocol=tcp localport=1025 action=block
rem 恢复初始防火墙设置
rem netsh advfirewall reset
echo Success!
goto start

:D
rem 禁用administrator，添加新用户
wmic USERACCOUNT where name="Administrator" set FullName="testaccount" 
echo Success!
goto start

:E
wmic os get Caption,CSDVersion,InstallDate,SerialNumber,CodeSet,CountryCode /value
goto start