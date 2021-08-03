﻿#NoEnv
#SingleInstance Force
#UseHook
#MaxHotkeysPerInterval 200
#WinActivateForce               ; 解决「 winactivate 最小化的窗口时不会把窗口放到顶层(被其他窗口遮住) 」
#include keymap/functions.ahk

SetBatchLines -1
; ListLines Off
; process, Priority,, A
SetWorkingDir %A_ScriptDir%  
SendMode Input

SetMouseDelay, 0  ; 发送完一个鼠标后不会 sleep
SetDefaultMouseSpeed, 0
coordmode, mouse, screen
settitlematchmode, 2

SemicolonAbbrTip := true
time_enter_repeat = T0.2
delay_before_repeat = T0.01
fast_one := 110     
fast_repeat := 70
slow_one :=  10     
slow_repeat := 13

Menu, Tray, Icon, resource\logo.ico
Menu, Tray, Tip, MyKeymap 1.0 by 咸鱼康2333
processPath := getProcessPath()
SetWorkingDir, %processPath%


CoordMode, Mouse, Screen
; 多显示器不同缩放比例导致的问题,  https://www.autohotkey.com/boards/viewtopic.php?f=14&t=13810
DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")


global typoTip := new TypoTipWindow()

semiHook := InputHook("C", "{Space}", "xk,ss,sk,rr,sl,zk,dk,dh,jt,gt,lx,sm,ex,sd,rb,fi,fp,fo,fb,fg,fk,dd,dp,dv,da,dr,wy")
semiHook.OnChar := Func("onTypoChar")
semiHook.OnEnd := Func("onTypoEnd")

return

RAlt::LCtrl
+capslock::toggleCapslock()

*capslock::
    CapslockMode := true
    keywait capslock
    CapslockMode := false
    if (A_PriorKey == "CapsLock" && A_TimeSinceThisHotkey < 450) {
        enterCapslockAbbr()
    }
    return


*j::
    JMode := true
    keywait `j
    JMode := false
    if (A_PriorKey == "j" && A_TimeSinceThisHotkey < 350)
            send  {blind}`j
    return


*`;::
    PunctuationMode := true
    keywait `; 
    PunctuationMode := false
    if (A_PriorKey == ";" && A_TimeSinceThisHotkey < 350)
        enterSemicolonAbbr(semiHook)
    return


*3::
    DigitMode := true
    keywait 3 
    DigitMode := false
    if (A_PriorKey == "3" && A_TimeSinceThisHotkey < 350)
        send {blind}3 
    return

#if JMode
*capslock::return
*capslock up::return
    ^l::return
    +k::return
    *k::
        send {blind}{Rshift down}
        keywait k
        send {Rshift up}
        return
    *l::
        send {blind}{Lctrl down}
        keywait l
        send {Lctrl up}
        return

*W::send {blind}+{tab}
*Z::send {blind}{appskey}
*C::send {blind}{backspace}
*V::send {blind}{delete}
*D::send {blind}{down}
*G::send {blind}{end}
*X::send {blind}{esc}
*A::send {blind}{home}
*I::send {blind}{insert}
*S::send {blind}{left}
*T::send {blind}{pgdn}
*Q::send {blind}{pgup}
*F::send {blind}{right}
*R::send {blind}{tab}
*E::send {blind}{up}

*space::send  {blind}{enter}
    


#if PunctuationMode
*U::send {blind}$
*R::send {blind}&
*Q::send {blind}(
*I::send {blind}*
*M::send {blind}-
*C::send {blind}.
*N::send {blind}/
*A::send {blind}:
*S::send {blind}<
*D::send {blind}=
*F::send {blind}>
*Y::send {blind}@
*Z::send {blind}\
*X::send {blind}_
*B::send {blind}`%
*H::send {blind}`;
*K::send {blind}``
*G::send {blind}{!}
*W::send {blind}{#}
*J::send {blind}{+}
*E::send {blind}{^}
*O::send {blind}{space 4}
*V::send {blind}|
*T::send {blind}~


#if DigitMode

*H::send {blind}0
*J::send {blind}1
*K::send {blind}2
*L::send {blind}3
*U::send {blind}4
*I::send {blind}5
*O::send {blind}6
*P::send {blind}7
*N::send {blind}8
*M::send {blind}9

*r::
    DigitMode := false
    FnMode := true
    keywait r
    FnMode := false
    return

*space::f1
*2::backspace


#if FnMode
*r::return

*H::send {blind}{f10}
*,::send {blind}{f11}
*/::send {blind}{f12}
*J::send {blind}{f1}
*K::send {blind}{f2}
*L::send {blind}{f3}
*U::send {blind}{f4}
*I::send {blind}{f5}
*O::send {blind}{f6}
*P::send {blind}{f7}
*N::send {blind}{f8}
*M::send {blind}{f9}


#if CapslockMode

S::center_window_to_current_monitor(1200, 800)
A::center_window_to_current_monitor(1370, 930)
/::centerMouse()
I::fastMoveMouse("I", 0, -1)
J::fastMoveMouse("J", -1, 0)
K::fastMoveMouse("K", 0, 1)
L::fastMoveMouse("L", 1, 0)
`;::horizontalScroll(";", 1)
H::horizontalScroll("H", -1)
,::lbuttonDown()
*N::leftClick()
*O::MouseClick, WheelDown, , , 1
*U::MouseClick, WheelUp, , , 1
M::rightClick()
W::send !{tab}
D::send #+{right}
E::send ^!{tab}
Y::send {LControl down}{LWin down}{Left}{LWin up}{LControl up}
P::send {LControl down}{LWin down}{Right}{LWin up}{LControl up}
X::SmartCloseWindow()
R::SwitchWindows()
Q::winmaximize, A
B::winMinimizeIgnoreDesktop()


space::
    ; ShowDimmer()
    ShowCommandBar()
    return

f::
    hotkey, *`;, off
    FMode := true
    CapslockMode := false
    SLOWMODE := false
    keywait f
    FMode := false
    hotkey, *`;, on
    return




#if SLOWMODE

/::centerMouse()
I::slowMoveMouse("I", 0, -1)
J::slowMoveMouse("J", -1, 0)
K::slowMoveMouse("K", 0, 1)
L::slowMoveMouse("L", 1, 0)
`;::horizontalScroll(";", 1)
H::horizontalScroll("H", -1)
,::lbuttonDown()
*N::leftClick()
*O::MouseClick, WheelDown, , , 1
*U::MouseClick, WheelUp, , , 1
M::rightClick()


esc::exitMouseMode()
space::exitMouseMode()


#if FMode
f::return

L::
    path = %A_ProgramFiles%\DAUM\PotPlayer\PotPlayerMini64.exe
    ActivateOrRun("ahk_class PotPlayer64", path)
    return
Q::
    path = %A_ProgramFiles%\Everything\Everything.exe
    ActivateOrRun("ahk_class EVERYTHING", path)
    return
U::
    path = %A_Programs%\JetBrains Toolbox\DataGrip.lnk
    ActivateOrRun("ahk_exe datagrip64.exe", path)
    return
J::
    path = %A_Programs%\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk
    ActivateOrRun("ahk_exe idea64.exe", path)
    return
S::
    path = %A_Programs%\Visual Studio Code\Visual Studio Code.lnk
    ActivateOrRun("ahk_exe Code.exe", path)
    return
E::
    path = %A_Programs%\印象笔记\印象笔记.lnk
    ActivateOrRun("ahk_class YXMainFrame", path)
    return
W::
    path = %A_ProgramsCommon%\Google Chrome.lnk
    ActivateOrRun("ahk_exe chrome.exe", path)
    return
D::
    path = %A_ProgramsCommon%\Microsoft Edge.lnk
    ActivateOrRun("ahk_exe msedge.exe", path)
    return
H::
    path = %A_ProgramsCommon%\Visual Studio 2019.lnk
    ActivateOrRun("- Microsoft Visual Studio", path)
    return
I::
    path = C:\Program Files\Typora\Typora.exe
    ActivateOrRun("ahk_exe Typora.exe", path)
    return
P::
    path = C:\ProgramMicrosoft\Windows\Start Menu\Programs\paint.net.lnk
    ActivateOrRun("ahk_exe PaintDotNet.exe", path)
    return
Z::
    path = D:\
    ActivateOrRun("ahk_class CabinetWClass ahk_exe Explorer.EXE", path)
    return
R::
    path = D:\install\Foxit Reader\FoxitReader.exe
    ActivateOrRun("ahk_exe FoxitReader.exe", path)
    return
O::
    path = shortcuts\OneNote for Windows 10.lnk
    ActivateOrRun("OneNote for Windows 10", path)
    return
A::
    path = shortcuts\Windows Terminal Preview.lnk
    ActivateOrRun("ahk_exe WindowsTerminal.exe", path)
    return

#IfWinActive, ahk_exe explorer.exe ahk_class MultitaskingViewFrame
r::tab
d::down
e::up
s::Left
f::Right
*x::
    if GetKeyState("`j", "P")  
        send {Esc}
    else
        send,  {blind}{del}
    return
space::enter


#IfWinActive



matchCapslockAbbr(typo) {
    
    arr := [ "xk","ss","sk","rr","sl","zk","dk","dh","jt","gt","lx","sm","ex","sd","rb","fi","fp","fo","fb","fg","fk","dd","dp","dv","da","dr" ]

    return arrayContains(arr, typo)
}


matchSemicolonAbbr(typo) {
    
    arr := [ "xk","ss","sk","rr","sl","zk","dk","dh","jt","gt","lx","sm","ex","sd","rb","fi","fp","fo","fb","fg","fk","dd","dp","dv","da","dr","wy" ]

    return arrayContains(arr, typo)
}

execSemicolonAbbr(typo) {
    switch typo 
    {
        case "da":
            
    path = %A_WorkingDir%
    ActivateOrRun("", path)
    return
        case "dd":
            
    path = shell:downloads
    ActivateOrRun("", path)
    return
        case "dp":
            
    path = shell:my pictures
    ActivateOrRun("", path)
    return
        case "dv":
            
    path = shell:My Video
    ActivateOrRun("", path)
    return
        case "dr":
            
    path = shell:RecycleBinFolder
    ActivateOrRun("", path)
    return
        case "ex":
            quit(true)
        case "rr":
            ReloadProgram()
        case "wy":
            send {blind}"
        case "ss":
            send {blind}""{left}
        case "xk":
            send {blind}(){left 1}
        case "zk":
            send {blind}[]{left}
        case "dk":
            send {blind}{{}{}}{left}
        case "jt":
            send {blind}➤{space 1}
        case "dh":
            send {blind}、
        case "sm":
            send {blind}《》{left}
        case "sk":
            send {blind}「  」{left 2}
        case "sl":
            send {blind}【】{left 1}
        case "gt":
            send {blind}🐶
        case "lx":
            send {blind}💚
        case "fg":
            setColor("#080")
        case "fb":
            setColor("#2E66FF")
        case "fk":
            setColor("#7B68EE")
        case "fp":
            setColor("#b309bb")
        case "fi":
            setColor("#D05")
        case "fo":
            setColor("#FF00FF")
        case "rb":
            slideToReboot()
        case "sd":
            slideToShutdown()
        default: 
            return false
    }
    return true
}

execCapslockAbbr(typo) {
    switch typo 
    {
        case "da":
            
    path = %A_WorkingDir%
    ActivateOrRun("", path)
    return
        case "dd":
            
    path = shell:downloads
    ActivateOrRun("", path)
    return
        case "dp":
            
    path = shell:my pictures
    ActivateOrRun("", path)
    return
        case "dv":
            
    path = shell:My Video
    ActivateOrRun("", path)
    return
        case "dr":
            
    path = shell:RecycleBinFolder
    ActivateOrRun("", path)
    return
        case "ex":
            quit(true)
        case "rr":
            ReloadProgram()
        case "ss":
            send {blind}""{left}
        case "xk":
            send {blind}(){left 1}
        case "zk":
            send {blind}[]{left}
        case "dk":
            send {blind}{{}{}}{left}
        case "jt":
            send {blind}➤{space 1}
        case "dh":
            send {blind}、
        case "sm":
            send {blind}《》{left}
        case "sk":
            send {blind}「  」{left 2}
        case "sl":
            send {blind}【】{left 1}
        case "gt":
            send {blind}🐶
        case "lx":
            send {blind}💚
        case "fg":
            setColor("#080")
        case "fb":
            setColor("#2E66FF")
        case "fk":
            setColor("#7B68EE")
        case "fp":
            setColor("#b309bb")
        case "fi":
            setColor("#D05")
        case "fo":
            setColor("#FF00FF")
        case "rb":
            slideToReboot()
        case "sd":
            slideToShutdown()
        default: 
            return false
    }
    return true
}

enterSemicolonAbbr(ih) 
{
    typoTip.show("    ") 
    hotkey, *`j, off
    ih.Start()
    ih.Wait()
    ih.Stop()
    hotkey, *`j, on
    typoTip.hide()
    if (ih.Match)
        execSemicolonAbbr(ih.Match)
}

onTypoChar(ih, char) {
    typoTip.show(ih.Input)
}

onTypoEnd(ih) {
    ; typoTip.show(ih.Input)
}

enterCapslockAbbr() 
{
    WM_USER := 0x0400
    SHOW_TYPO_WINDOW := WM_USER + 0x0001
    HIDE_TYPO_WINDOW := WM_USER + 0x0002

    postMessageToTipWidnow(SHOW_TYPO_WINDOW)
    result := ""

    hotkey, *`j, off
    Loop 
    {
        Input, key, L1, {LControl}{RControl}{LAlt}{RAlt}{Space}{Esc}{LWin}{RWin}{CapsLock}

        if InStr(ErrorLevel, "EndKey:") {
            break
        }
        if (ErrorLevel == "NewInput") {
            break
        }
            
        typo := typo . key
        postCharToTipWidnow(key)

        if matchCapslockAbbr(typo) {
            result := typo
            break
        }
    }
    hotkey, *`j, on

    typo := ""
    postMessageToTipWidnow(HIDE_TYPO_WINDOW)
    if (result)
        execCapslockAbbr(result)
}
