@echo off
cls
set version=1.0
title Record Checker v%version% (%date%)

:var
set g=[92m
set r=[91m
set red=[04m
set l=[1m
set w=[0m
set b=[94m
set m=[95m
set p=[35m
set c=[35m
set d=[96m
set u=[0m
set z=[91m
set n=[96m
set y=[40;33m
set g2=[102m
set r2=[101m
set t=[40m
set bo=[01m
chcp 65001 >nul
echo.
echo.
echo.
echo	%c% 	███╗░░░███╗░█████╗░██╗░░░██╗░██████╗░██████╗███████╗
echo		████╗░████║██╔══██╗██║░░░██║██╔════╝██╔════╝██╔════╝
echo		██╔████╔██║██║░░██║██║░░░██║╚█████╗░╚█████╗░█████╗░░
echo		██║╚██╔╝██║██║░░██║██║░░░██║░╚═══██╗░╚═══██╗██╔══╝░░
echo		██║░╚═╝░██║╚█████╔╝╚██████╔╝██████╔╝██████╔╝███████╗
echo		╚═╝░░░░░╚═╝░╚════╝░░╚═════╝░╚═════╝░╚═════╝░╚══════╝                                                   
echo.
echo.
echo.                                                                                              
chcp 850 >nul
ping localhost -n 5 >nul
:check_process
setlocal enabledelayedexpansion
set "processes=mirillis wmcap playclaw XSplit Screencast camtasia dxtory nvcontainer obs64 bdcam RadeonSettings Fraps CamRecorder XSplit.Core ShareX Action lightstream streamlabs webrtcvad openbroadcastsoftware movavi.screen.recorder icecreamscreenrecorder smartpixel d3dgear gadwinprintscreen apowersoftfreescreenrecorder bandicamlauncher hypercam loiloilgamerecorder nchexpressions captura vokoscreenNG simple.screen.recorder recordmydesktop kazam gtk-recordmydesktop screenstudio screenkey jupyter-notebook psr"
for %%p in (%processes%) do (
    tasklist /fi "ImageName eq %%p.exe" /fo csv 2>nul | find /I "%%p" >nul
    if !errorlevel! equ 0 (
        echo %d%%%%p Is Recording
    )
)
pause
