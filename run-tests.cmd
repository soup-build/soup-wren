@echo off
SETLOCAL
SET RootDir=%~dp0

soup run ..\soup\code\generate-test\ -args %RootDir%\code\run-tests.wren %RootDir%\out\Wren\Local\Wren\0.5.4\J_HqSstV55vlb-x6RWC_hLRFRDU\script\bundles.sml
if %ERRORLEVEL% NEQ  0 exit /B %ERRORLEVEL%