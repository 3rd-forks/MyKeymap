﻿#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 70
#NoTrayIcon
#WinActivateForce               ; 解决「 winactivate 最小化的窗口时不会把窗口放到顶层(被其他窗口遮住) 」
#InstallKeybdHook               ; 可能是 ahk 自动卸载 hook 导致的丢失 hook,  如果用这行指令, ahk 是否就不会卸载 hook 了呢?
#include bin/functions.ahk
#include bin/actions.ahk


StringCaseSense, On
SetWorkingDir %A_ScriptDir%\..
requireAdmin()
closeOldInstance()

SetBatchLines -1
ListLines Off
process, Priority,, H
; 使用 sendinput 时,  通过 alt+3+j 输入 alt+1 时,  会发送 ctrl+alt
SendMode Input
; SetKeyDelay, 0
; SetMouseDelay, 0

SetMouseDelay, 0  ; 发送完一个鼠标后不会 sleep
SetDefaultMouseSpeed, 0
coordmode, mouse, screen
settitlematchmode, 2

; win10、win11 任务切换、任务视图
GroupAdd, TASK_SWITCH_GROUP, ahk_class MultitaskingViewFrame
GroupAdd, TASK_SWITCH_GROUP, ahk_class XamlExplorerHostIslandWindow

scrollOnceLineCount := 1
scrollDelay1 = T0.2
scrollDelay2 = T0.03

fastMoveSingle := 110
fastMoveRepeat := 70
slowMoveSingle := 10
slowMoveRepeat := 13
moveDelay1 = T0.13
moveDelay2 = T0.01

SemicolonAbbrTip := true

allHotkeys := []
allHotkeys.Push("*3")
allHotkeys.Push("*9")
allHotkeys.Push("*j")
allHotkeys.Push("*capslock")
allHotkeys.Push("*;")
allHotkeys.Push("RButton")

Menu, Tray, NoStandard
Menu, Tray, Add, 暂停, trayMenuHandler
Menu, Tray, Add, 退出, trayMenuHandler
Menu, Tray, Add, 重启程序, trayMenuHandler
Menu, Tray, Add, 打开设置, trayMenuHandler 
Menu, Tray, Add, 帮助文档, trayMenuHandler 
Menu, Tray, Add, 查看窗口标识符, trayMenuHandler 
Menu, Tray, Add 

Menu, Tray, Icon
Menu, Tray, Icon, bin\logo.ico,, 1
Menu, Tray, Tip, MyKeymap 1.1 by 咸鱼阿康
; processPath := getProcessPath()
; SetWorkingDir, %processPath%


CoordMode, Mouse, Screen
; 多显示器不同缩放比例导致的问题,  https://www.autohotkey.com/boards/viewtopic.php?f=14&t=13810
DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")


global typoTip := new TypoTipWindow()

semiHook := InputHook("C", "{Space}{BackSpace}{Esc}", "xk,ss,sk,zk,dk,gt,zh,gg,ver,fs,red,gre")
semiHook.OnChar := Func("onTypoChar")
semiHook.OnEnd := Func("onTypoEnd")
capsHook := InputHook("C", "{BackSpace}{Esc}", "ss,sl,rb,dd,se,no,ld,we,st,bb,dm,rex,tm,sp,lj,help,bd ,ex")
capsHook.OnChar := Func("capsOnTypoChar")
capsHook.OnEnd := Func("capsOnTypoEnd")

#include data/custom_functions.ahk
return

RAlt::LCtrl

!+'::
    Suspend, Permit
    toggleSuspend()
    return
!'::
    Suspend, Toggle
    ReloadProgram()
    return

!capslock::toggleCapslock()

*capslock::
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    CapslockMode := true
    keywait capslock
    CapslockMode := false
    if (A_ThisHotkey == "*capslock" && A_PriorKey == "CapsLock" && A_TimeSinceThisHotkey < 450) {
        enterCapslockAbbr(capsHook)
    }
    enableOtherHotkey(thisHotkey)
    return


*j::
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    JMode := true
    DisableCapslockKey := true
    keywait j
    JMode := false
    DisableCapslockKey := false
    if (A_PriorKey == "j" && A_TimeSinceThisHotkey < 350)
            send,  {blind}j
    enableOtherHotkey(thisHotkey)
    return


*`;::
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    PunctuationMode := true
    DisableCapslockKey := true
    keywait `; 
    PunctuationMode := false
    DisableCapslockKey := false
    if (A_PriorKey == ";" && A_TimeSinceThisHotkey < 350)
        enterSemicolonAbbr(semiHook)
    enableOtherHotkey(thisHotkey)
    return

*3::
    start_tick := A_TickCount
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    DigitMode := true
    keywait 3 
    DigitMode := false
    if (A_PriorKey == "3" && (A_TickCount - start_tick < 250))
        send, {blind}3 
    enableOtherHotkey(thisHotkey)
    return
*9::
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    Mode9 := true
    keywait 9 
    Mode9 := false
    if (A_PriorKey == "9" && A_TimeSinceThisHotkey < 350)
        send, {blind}9 
    enableOtherHotkey(thisHotkey)
    return




RButton::
enterRButtonMode()
{
	global RButtonMode
    thisHotkey := A_ThisHotkey
    RButtonMode := true
	timeOut = T0.01
	movedMouse := false
	MouseGetPos, initialX, initialY

	; 当按下右键时跑一个循环,  移动鼠标 / 弹起鼠标右键才能跳出这个循环
	keywait, RButton, %timeOut%
    while (errorlevel != 0)
    {
		MouseGetPos, x, y
		if (Abs(x - initialX) > 20 || Abs(y - initialY) > 20) {
			movedMouse := true
			break
		}
		keywait, RButton, %timeOut%
    }

    RButtonMode := false
	triggerOtherHotkey := thisHotkey != A_ThisHotkey
	Hotkey, %thisHotkey%, Off

	; 如果移动了鼠标,  那么按下鼠标右键,  以兼容其他软件的鼠标手势,  需要等待 RButton 弹起后才能重新启用热键
	if (!triggerOtherHotkey && movedMouse) {
		SendInput, {Blind}{RButton down}
		keywait, RButton
	} 
	else if (!triggerOtherHotkey) {
		SendInput, {Blind}{RButton}
	}
    ; 这里睡眠很重要, 否则会触发无限循环的 bug, 因为发送 RButton 触发 RButton 热键
    sleep, 70
	Hotkey, %thisHotkey%, On
    return

}








#if JModeL
l::return
*B::send, {blind}+{del}
*D::send, {blind}+{down}
*G::send, {blind}+{end}
*X::send, {blind}+{esc}
*A::send, {blind}+{home}
*S::send, {blind}+{left}
*F::send, {blind}+{right}
*E::send, {blind}+{up}
*I::send, {blind}^+{left}
*K::send, {blind}^+{right}
*C::send, {blind}{bs}


#if JMode
l::enterJModeL()
*,::send, {blind}+{home}{bs}
*W::send, {blind}+{Tab}
*2::send, {blind}^+{tab}
*V::send, {blind}^{bs}
*I::send, {blind}^{left}
*K::send, {blind}^{right}
*3::send, {blind}^{tab}
*Z::send, {blind}{appskey}
*C::send, {blind}{bs}
*B::send, {blind}{del}
*D::send, {blind}{down}
*G::send, {blind}{end}
*Space::send, {blind}{enter}
*X::send, {blind}{esc}
*A::send, {blind}{home}
*.::send, {blind}{insert}
*S::send, {blind}{left}
*F::send, {blind}{right}
*R::send, {blind}{tab}
*E::send, {blind}{up}

    

#if PunctuationMode
*U::send, {blind}$
*R::send, {blind}&
*Q::send, {blind}(
*A::send, {blind}*
*M::send, {blind}-
*C::send, {blind}.
*N::send, {blind}/
*I::send, {blind}:
*S::send, {blind}<
*D::send, {blind}=
*F::send, {blind}>
*Y::send, {blind}@
*Z::send, {blind}\
*X::send, {blind}_
*B::send, {blind}`%
*J::send, {blind}`;
*K::send, {blind}``
*G::send, {blind}{!}
*W::send, {blind}{#}
*H::send, {blind}{+}
*E::send, {blind}{^}
*O::send, {blind}{end};
*V::send, {blind}|
*T::send, {blind}~




#if DigitMode
*H::send, {blind}0
*J::send, {blind}1
*K::send, {blind}2
*L::send, {blind}3
*U::send, {blind}4
*I::send, {blind}5
*O::send, {blind}6
*B::send, {blind}7
*N::send, {blind}8
*M::send, {blind}9
*0::send, {blind}{f10}
*P::send, {blind}{f11}
*`;::send, {blind}{f12}
*1::send, {blind}{f1}
*Space::send, {blind}{f1}
*2::send, {blind}{f2}
*E::send, {blind}{f3}
*4::send, {blind}{f4}
*R::send, {blind}{f5}
*T::send, {blind}{f6}
*Y::send, {blind}{f7}
*8::send, {blind}{f8}
*9::send, {blind}{f9}



#if Mode9
*E::Mode9__136()
*T::Mode9__138()
*U::Mode9__140()
*S::Mode9__145()
*D::Mode9__146()
*F::Mode9__147()
*G::Mode9__148()
*X::Mode9__155()
*C::Mode9__156()
*V::Mode9__157()



#if CapslockMode

E::action_enter_task_switch_mode()
S::center_window_to_current_monitor(1200, 800)
A::center_window_to_current_monitor(1370, 930)
*I::fastMoveMouse("I", 0, -1)
*J::fastMoveMouse("J", -1, 0)
*K::fastMoveMouse("K", 0, 1)
*L::fastMoveMouse("L", 1, 0)
*,::lbuttonDown()
*N::leftClick()
*.::moveCurrentWindow()
*M::rightClick()
C::run, SoundControl.exe
*`;::scrollWheel(";", 4)
*H::scrollWheel("H", 3)
*O::scrollWheel("O", 2)
*U::scrollWheel("U", 1)
W::send, !{tab}
D::send, #+{right}
*T::send, {blind}#{left}
Y::send, {LControl down}{LWin down}{Left}{LWin up}{LControl up}
P::send, {LControl down}{LWin down}{Right}{LWin up}{LControl up}
0::set_window_position_and_size(10, 10, "DEFAULT", "DEFAULT")
X::SmartCloseWindow()
R::SwitchWindows()
G::ToggleTopMost()
Q::winmaximize, A
B::winMinimizeIgnoreDesktop()


f::
    FMode := true
    CapslockMode := false
    SLOWMODE := false
    keywait f
    FMode := false
    return
space::
    CapslockSpaceMode := true
    CapslockMode := false
    SLOWMODE := false
    keywait space
    CapslockSpaceMode := false
    return

#if SLOWMODE
*I::slowMoveMouse("I", 0, -1)
*J::slowMoveMouse("J", -1, 0)
*K::slowMoveMouse("K", 0, 1)
*L::slowMoveMouse("L", 1, 0)
*,::lbuttonDown()
*N::leftClick()
*.::moveCurrentWindow()
*M::rightClick(true)
*`;::scrollWheel(";", 4)
*H::scrollWheel("H", 3)
*O::scrollWheel("O", 2)
*U::scrollWheel("U", 1)



Esc::exitMouseMode()
*Space::exitMouseMode()


#if FMode
f::return

B::ActivateOrRun("", "" A_ProgramsCommon "\Google Chrome.lnk", "", "")
H::ActivateOrRun("- Microsoft Visual Studio", "" A_ProgramsCommon "\Visual Studio 2019.lnk", "", "")
Z::ActivateOrRun("ahk_class CabinetWClass ahk_exe Explorer.EXE", "D:\", "", "")
Q::ActivateOrRun("ahk_class EVERYTHING", "" A_ProgramFiles "\Everything\Everything.exe", "", "")
K::ActivateOrRun("ahk_class PotPlayer64", "" A_ProgramFiles "\DAUM\PotPlayer\PotPlayerMini64.exe", "", "")
E::ActivateOrRun("ahk_class YXMainFrame", "C:\Program Files (x86)\Yinxiang Biji\印象笔记\Evernote.exe", "", "")
W::ActivateOrRun("ahk_exe chrome.exe", "" A_ProgramsCommon "\Google Chrome.lnk", "", "")
S::ActivateOrRun("ahk_exe Code.exe", "" A_Programs "\Visual Studio Code\Visual Studio Code.lnk", "", "")
U::ActivateOrRun("ahk_exe datagrip64.exe", "" A_Programs "\JetBrains Toolbox\DataGrip.lnk", "", "")
L::ActivateOrRun("ahk_exe EXCEL.EXE", "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk", "", "")
R::ActivateOrRun("ahk_exe FoxitReader.exe", "D:\install\Foxit Reader\FoxitReader.exe", "", "")
,::ActivateOrRun("ahk_exe goland64.exe", "" A_Programs "\JetBrains Toolbox\GoLand.lnk", "", "")
J::ActivateOrRun("ahk_exe idea64.exe", "" A_Programs "\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk", "", "")
D::ActivateOrRun("ahk_exe msedge.exe", "" A_ProgramsCommon "\Microsoft Edge.lnk", "", "")
P::ActivateOrRun("ahk_exe POWERPNT.EXE", "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk", "", "")
I::ActivateOrRun("ahk_exe Typora.exe", "C:\Program Files\Typora\Typora.exe", "", "")
A::ActivateOrRun("ahk_exe WindowsTerminal.exe", "shortcuts\Windows Terminal Preview.lnk", "", "")
O::ActivateOrRun("OneNote for Windows 10", "shortcuts\OneNote for Windows 10.lnk", "", "")
M::bindOrActivate(CapslockF__M)
N::bindOrActivate(CapslockF__N)

#if CapslockSpaceMode
space::return

S::ActivateOrRun("my_site - Visual Studio Code", "" A_Programs "\Visual Studio Code\Visual Studio Code.lnk", "D:\project\my_site", "")
M::ActivateOrRun("MyKeymap - Visual Studio Code", "" A_Programs "\Visual Studio Code\Visual Studio Code.lnk", "D:\MyFiles\MyKeymap", "")


#if DisableCapslockKey
*capslock::return
*capslock up::return


#if RButtonMode
*LButton::send, {blind}^!{tab}
*WheelUp::send, {blind}^+{tab}
*WheelDown::send, {blind}^{tab}
*C::send, {blind}{bs}
*Space::send, {blind}{enter}


#If TASK_SWITCH_MODE
*D::send, {blind}{down}
*E::send, {blind}{up}
*S::send, {blind}{left}
*F::send, {blind}{right}
*X::send,  {blind}{del}
*Space::send, {blind}{enter}
#If




execSemicolonAbbr(typo) {
    switch typo 
    {
        case "zk":
                send, {blind}[]{left}
        case "zh":
                send, {blind}{text} site:zhihu.com
        case "fs":
                send, {blind}{text}、
        case "gt":
                send, {blind}{text}🐶
        case "dk":
            SemicolonAbbr2__dk()
        case "gg":
            SemicolonAbbr2__gg()
        case "sk":
            SemicolonAbbr2__sk()
        case "ss":
            SemicolonAbbr2__ss()
        case "ver":
            SemicolonAbbr2__ver()
        case "xk":
            SemicolonAbbr2__xk()
        case "gre":
            setColor("#080")
        case "red":
            setColor("#D05")
        default: 
            return false
    }
    return true
}

execCapslockAbbr(typo) {
    switch typo 
    {
        case "dm":
           ActivateOrRun("", ".\", "", "")
        case "sp":
           ActivateOrRun("", "https://open.spotify.com/", "", "")
        case "bd ":
           ActivateOrRun("", "https://www.baidu.com", "", "")
        case "tm":
           ActivateOrRun("", "taskmgr.exe", "", "")
        case "bb":
           ActivateOrRun("Bing 词典", "C:\Program Files\Google\Chrome\Application\chrome.exe", "--app=https://cn.bing.com/dict/search?q=nice", "")
        case "st":
           ActivateOrRun("Microsoft Store", "shortcuts\Store.lnk", "", "")
        case "we":
           ActivateOrRun("网易云音乐", "shortcuts\网易云音乐.lnk", "", "")
        case "no":
           ActivateOrRun("记事本", "notepad.exe", "", "")
        case "sl":
           DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
        case "se":
           openSettings()
        case "ex":
           quit(false)
        case "rex":
           restartExplorer()
        case "ld":
           run, bin\ahk.exe bin\changeBrightness.ahk
        case "help":
           run, bin\site\help.html
        case "dd":
           run, shell:downloads
        case "lj":
           run, shell:RecycleBinFolder
        case "rb":
           slideToReboot()
        case "ss":
           slideToShutdown()
        default: 
            return false
    }
    return true
}

enterSemicolonAbbr(ih) 
{
    global DisableCapslockKey
    DisableCapslockKey := true

    typoTip.show("    ") 
    ih.Start()
    ih.Wait()
    ih.Stop()
    typoTip.hide()
    DisableCapslockKey := false


    if (ih.Match)
        execSemicolonAbbr(ih.Match)
}

onTypoChar(ih, char) {
    typoTip.show(ih.Input)
}

onTypoEnd(ih) {
    ; typoTip.show(ih.Input)
}
capsOnTypoChar(ih, char) {
    postCharToTipWidnow(char)
}

capsOnTypoEnd(ih) {
    ; typoTip.show(ih.Input)
}

enterCapslockAbbr(ih) 
{
    WM_USER := 0x0400
    SHOW_TYPO_WINDOW := WM_USER + 0x0001
    HIDE_TYPO_WINDOW := WM_USER + 0x0002

    postMessageToTipWidnow(SHOW_TYPO_WINDOW)
    result := ""


    ih.Start()
    endReason := ih.Wait()
    ih.Stop()
    if InStr(endReason, "EndKey") {
    }
    if InStr(endReason, "Match") {
        lastChar := SubStr(ih.Match, ih.Match.Length-1)
        postCharToTipWidnow(lastChar)
        SetTimer, delayedHideTipWindow, -50
    } else {
        postMessageToTipWidnow(HIDE_TYPO_WINDOW)
    }
    if (ih.Match)
        execCapslockAbbr(ih.Match)
}

delayedHideTipWindow()
{
    HIDE_TYPO_WINDOW := 0x0400 + 0x0002
    postMessageToTipWidnow(HIDE_TYPO_WINDOW)
}



Mode9__136()
{
    if winactive("ahk_exe explorer.exe") {
        sel := Explorer_GetSelection(), action_open_selected_with("" A_ProgramFiles "\Everything\Everything.exe", "-filename " sel.selected "")
        return
    }
    if winactive("- Visual Studio Code") {
        send, {blind}+!{f5}
        return
    }
    if winactive("- Microsoft Visual Studio") {
        send, {blind}+{f8}
        return
    }
}
Mode9__138()
{
    if winactive("ahk_exe explorer.exe") {
        sel := Explorer_GetSelection(), action_open_selected_with("wt.exe", "-d " sel.selected "")
        return
    }
}
Mode9__140()
{
    if winactive("- Microsoft Visual Studio") {
        send, {blind}^1s
        return
    }
}
Mode9__145()
{
    if winactive("- Microsoft Visual Studio") {
        send, {blind}^-
        return
    }
}
Mode9__146()
{
    if winactive("- Visual Studio Code") {
        send, {blind}!{f5}
        return
    }
    if winactive("- Microsoft Visual Studio") {
        send, {blind}{f8}
        return
    }
}
Mode9__147()
{
    if winactive("ahk_exe explorer.exe") {
        action_copy_selected_file_path()
        return
    }
    if winactive("- Microsoft Visual Studio") {
        send, {blind}^+-
        return
    }
}
Mode9__148()
{
    if winactive("- Visual Studio Code") {
        send, {blind}^+g
        return
    }
    if winactive("- Microsoft Visual Studio") {
        send, {blind}^0^g
        return
    }
}
Mode9__155()
{
    if winactive("ahk_exe explorer.exe") {
        sel := Explorer_GetSelection(), action_open_selected_with("C:\Program Files\7-Zip\7z.exe", "x " sel.selected " -o""" sel.current "\" sel.purename """")
        return
    }
}
Mode9__156()
{
    if winactive("ahk_exe explorer.exe") {
        sel := Explorer_GetSelection(), action_open_selected_with("" A_Programs "\Visual Studio Code\Visual Studio Code.lnk", "" sel.selected "")
        return
    }
}
Mode9__157()
{
    if winactive("- Microsoft Visual Studio") {
        send, {blind}+!.
        return
    }
}

SemicolonAbbr2__xk() {
    send, {blind}{text}()
    send, {blind}{left 1}
}
SemicolonAbbr2__ss() {
    send, {blind}{text}""
    send, {blind}{left}
}
SemicolonAbbr2__sk() {
    send, {blind}{text}「  」
    send, {blind}{left 2}
}
SemicolonAbbr2__dk() {
    send, {blind}{text}{}
    send, {blind}{left}
}
SemicolonAbbr2__gg() {
    send, {blind}{text}git add -A`; git commit -a -m ""`; git push origin (git branch --show-current)`;
    send, {blind}{left 47}
}
SemicolonAbbr2__ver() {
    send, {blind}#r
    sleep 700
    send, {blind}winver{enter}
}

