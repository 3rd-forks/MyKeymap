﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#UseHook
#SingleInstance Force
#include functions.ahk
DetectHiddenWindows, 1


time_enter_repeat = T0.2
delay_before_repeat = T0.01
fast_one := 110     
fast_repeat := 70
slow_one :=  10     
slow_repeat := 13

WinGet, winList, List, ahk_exe idea64.exe
result := ""
loop %winList%
{
    item := winList%A_Index%
    WinGetTitle, title, ahk_id %item%
    result := result . item . "-> " . "'"  . title . "'" . "`n"
}
; str = 1j        %A_ProgramsCommon%\Google Chrome.lnk      k
; tooltip, % str
; MsgBox, %result%
return

8::
horizontalScroll("8", 1, 1)
return



f9::
return
0::Reload

loopWindows() {
    DetectHiddenWindows, off
    WinGet, id, list,,, ahk_exe Listary.exe
    Loop, %id%
    {
        this_id := id%A_Index%
        WinShow, ahk_id %this_id%
        WinActivate, ahk_id %this_id%
        WinGetClass, this_class, ahk_id %this_id%
        WinGetTitle, this_title, ahk_id %this_id%
        MsgBox, 4, , Visiting All Windows`n%a_index% of %id%`nahk_id %this_id%`nahk_class %this_class%`n%this_title%`n`nContinue?
        IfMsgBox, NO, break
    }
}
