@echo off
TITLE ethminer
setlocal enabledelayedexpansion
set "adapter=Ethernet adapter Ethernet"
set ipv4= n/a 
set adapterfound=false
for /f "usebackq tokens=1-2 delims=:" %%f in (`ipconfig /all`) do (
    set "item=%%f"
    if /i "!item!"=="!adapter!" (
        set adapterfound=true
    ) else if not "!item!"=="!item:IPv4 Address=!" if "!adapterfound!"=="true" (
        set adapterfound=false
		set ipv4=%%g
	)
)
set ipv4=%IPv4:(Preferred)=%
set ipv4=%ipv4:~1,-1%
echo.%ipv4% >ip_log.txt
cd /d %~dp0 && cd..

set port=8080
set client=pcname

setx GPU_FORCE_64BIT_PTR 0
setx GPU_MAX_HEAP_SIZE 100
setx GPU_USE_SYNC_OBJECTS 1
setx GPU_MAX_ALLOC_PERCENT 100
setx GPU_SINGLE_ALLOC_PERCENT 100

start /wait /b ethminer.exe --cl-local-work 240 --farm-recheck 1000 -G -F http://%ipv4%:%port%/%client% 
wmic process where name="ethminer.exe" CALL setpriority 256