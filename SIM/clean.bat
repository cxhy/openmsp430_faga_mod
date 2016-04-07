echo off
CLS
ECHO.     =================================  删除多余的仿真文件 ===================
ECHO.     =                                  done                                 =
ECHO.     =========================================================================


rd work /s /q
del modelsim.ini
del *.bak
del transcript
del *.wlf
del *.mti
del *.mpf

:_Exit
ECHO.
PAUSE