echo off
CLS
ECHO.     =================================  ɾ������ķ����ļ� ===================
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