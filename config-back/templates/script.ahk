#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 70
#NoTrayIcon
#WinActivateForce               ; 解决「 winactivate 最小化的窗口时不会把窗口放到顶层(被其他窗口遮住) 」
#InstallKeybdHook               ; 可能是 ahk 自动卸载 hook 导致的丢失 hook,  如果用这行指令, ahk 是否就不会卸载 hook 了呢?
#include keymap/functions.ahk

StringCaseSense, On
SetWorkingDir %A_ScriptDir%\..
rqeruireAdmin()
closeOldInstance()

SetBatchLines -1
; ListLines Off
process, Priority,, H
; 使用 sendinput 时,  通过 alt+3+j 输入 alt+1 时,  会发送 ctrl+alt
SendMode Input
; SetKeyDelay, 0
; SetMouseDelay, 0

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

; Menu, Tray, NoStandard
Menu, Tray, Add, 视频教程, trayMenuHandler
Menu, Tray, Add, 参考/示例, trayMenuHandler 
Menu, Tray, Add 
Menu, Tray, Add, 退出, trayMenuHandler
Menu, Tray, Add, 打开设置, trayMenuHandler 
Menu, Tray, Add 

Menu, Tray, Icon
Menu, Tray, Icon, bin\logo.ico
Menu, Tray, Tip, MyKeymap 1.0 by 咸鱼阿康12333
; processPath := getProcessPath()
; SetWorkingDir, %processPath%


CoordMode, Mouse, Screen
; 多显示器不同缩放比例导致的问题,  https://www.autohotkey.com/boards/viewtopic.php?f=14&t=13810
DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")


global typoTip := new TypoTipWindow()

semiHook := InputHook("C", "{Space}", {{{ SemicolonAbbrKeys|join(',')|ahkString }}})
semiHook.OnChar := Func("onTypoChar")
semiHook.OnEnd := Func("onTypoEnd")

return

RAlt::LCtrl
!'::ReloadProgram()
+capslock::toggleCapslock()

*capslock::
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    CapslockMode := true
    keywait capslock
    CapslockMode := false
    if (A_PriorKey == "CapsLock" && A_TimeSinceThisHotkey < 450) {
        enterCapslockAbbr()
    }
    enableOtherHotkey(thisHotkey)
    return


*j::
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    JMode := true
    keywait j
    JMode := false
    if (A_PriorKey == "j" && A_TimeSinceThisHotkey < 350)
            send  {blind}j
    enableOtherHotkey(thisHotkey)
    return


*`;::
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    PunctuationMode := true
    keywait `; 
    PunctuationMode := false
    if (A_PriorKey == ";" && A_TimeSinceThisHotkey < 350)
        enterSemicolonAbbr(semiHook)
    enableOtherHotkey(thisHotkey)
    return


*3::
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    DigitMode := true
    keywait 3 
    DigitMode := false
    if (A_PriorKey == "3" && A_TimeSinceThisHotkey < 350)
        send {blind}3 
    enableOtherHotkey(thisHotkey)
    return

*9::
    thisHotkey := A_ThisHotkey
    disableOtherHotkey(thisHotkey)
    Mode9 := true
    keywait 9 
    Mode9 := false
    if (A_PriorKey == "9" && A_TimeSinceThisHotkey < 350)
        send {blind}9 
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
		if (Abs(x - initialX) > 3 || Abs(y - initialY) > 3) {
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
    sleep, 50
	Hotkey, %thisHotkey%, On
    return

}


~LButton::
enterLButtonMode()
{
	global LButtonMode
    LButtonMode := true
    keywait LButton
    LButtonMode := false
    return
}


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

{% for key,value in JMode.items()|sort(attribute="1.value") %}
    {% if value.value %}
{{{ value.prefix }}}{{{ escapeAhkHotkey(key) }}}::{{{ value.value }}}
    {% endif %}
{% endfor %}

    


#if PunctuationMode
{% for key,value in Semicolon.items()|sort(attribute="1.value") %}
    {% if value.value %}
{{{ value.prefix }}}{{{ escapeAhkHotkey(key) }}}::{{{ value.value }}}
    {% endif %}
{% endfor %}


#if DigitMode

{% for key,value in Mode3.items()|sort(attribute="1.value") %}
    {% if value.value %}
{{{ value.prefix }}}{{{ escapeAhkHotkey(key) }}}::{{{ value.value }}}
    {% endif %}
{% endfor %}

*r::
    DigitMode := false
    FnMode := true
    keywait r
    FnMode := false
    return

*2::send {blind}{backspace}

#if Mode9
{% for key,value in Mode9.items()|sort(attribute="1.value") %}
    {% if value.value %}
{{{ value.prefix }}}{{{ escapeAhkHotkey(key) }}}::{{{ value.value }}}
    {% endif %}
{% endfor %}

#if FnMode
*r::return

{% for key,value in Mode3R.items()|sort(attribute="1.value") %}
    {% if value.value %}
{{{ value.prefix }}}{{{ escapeAhkHotkey(key) }}}::{{{ value.value }}}
    {% endif %}
{% endfor %}


#if CapslockMode

{% for key,value in Capslock.items()|sort(attribute="1.value") %}
    {% if value.value %}
{{{ value.prefix }}}{{{ escapeAhkHotkey(key) }}}::{{{ value.value }}}
    {% endif %}
{% endfor %}


f::
    FMode := true
    CapslockMode := false
    SLOWMODE := false
    keywait f
    FMode := false
    return




#if SLOWMODE

{% for key,value in Capslock.items()|sort(attribute="1.value") %}
    {% if value.value and value.type == "鼠标操作" %}
{{{ value.prefix }}}{{{ escapeAhkHotkey(key) }}}::{{{ value.value | replace("fast", "slow") }}}
    {% endif %}
{% endfor %}


esc::exitMouseMode()
space::exitMouseMode()


#if FMode
f::return

{% for key,value in CapslockF.items()|sort(attribute="1.value") %}
    {% if value.value %}
{{{ value.prefix }}}{{{ escapeAhkHotkey(key) }}}::{{{ value.value }}}
    {% endif %}
{% endfor %}

#IfWinActive, ahk_exe explorer.exe ahk_class MultitaskingViewFrame
d::send, {blind}{down}
e::send, {blind}{up}
s::send, {blind}{left}
f::send, {blind}{right}
*x::send,  {blind}{del}
space::send, {blind}{enter}

#if LButtonMode

*E::
    send {LButton up}
    send {blind}{enter}
return
*W::
    send {LButton up}
    send {blind}^+{tab}
return
*Z::
    send {LButton up}
    send {blind}^z
return
*C::
    send {LButton up}
    send {blind}{backspace}
return
*V::
    send {LButton up}
    send {blind}{delete}
return
*D::
    send {LButton up}
    send {blind}{down}
return
*G::
    send {LButton up}
    send {blind}^v
return
*A::
    send {LButton up}
    send {blind}^c
return
*X::
    send {LButton up}
    send {blind}{esc}
return
*I::
    send {LButton up}
    send {blind}{insert}
return
*S::
    send {LButton up}
    send {blind}{left}
return
*T::
    send {LButton up}
    send {blind}^{End}
return
*Q::
    send {LButton up}
    send {blind}^{Home}
return
*F::
    send {LButton up}
    send {blind}{right}
return
*R::
    send {LButton up}
    send {blind}^{tab}
return

#if RButtonMode

*Space::send {blind}{enter}
~LButton::send ^!{tab}
WheelUp::send ^+{tab}
WheelDown::send ^{tab}
*W::send {blind}^+{tab}
*Z::send {blind}{appskey}
*C::send {blind}{backspace}
*V::send {blind}{delete}
*D::send {blind}{down}
*G::send {blind}^v
*A::send {blind}^c
*X::SmartCloseWindow()
*I::send {blind}{insert}
*S::send {blind}{left}
*T::send {blind}{pgdn}
*Q::send {blind}{pgup}
*F::send {blind}{right}
*R::send {blind}^{tab}
*E::send {blind}{up}

#If



matchCapslockAbbr(typo) {
    
    arr := [ {{{ CapslockAbbrKeys|map('ahkString')|join(',') }}} ]

    return arrayContains(arr, typo)
}


matchSemicolonAbbr(typo) {
    
    arr := [ {{{ SemicolonAbbrKeys|map('ahkString')|join(',') }}} ]

    return arrayContains(arr, typo)
}

execSemicolonAbbr(typo) {
    switch typo 
    {
{% for key,value in SemicolonAbbr.items()|sort(attribute="1.value") %}
    {% if value.value %}
        case {{{ key|ahkString }}}:
            {{{ value.value }}}
    {% endif %}
{% endfor %}
        default: 
            return false
    }
    return true
}

execCapslockAbbr(typo) {
    switch typo 
    {
{% for key,value in CapslockAbbr.items()|sort(attribute="1.value") %}
    {% if value.value %}
        case {{{ key|ahkString }}}:
           {{{ value.value }}}
    {% endif %}
{% endfor %}
        default: 
            return false
    }
    return true
}

enterSemicolonAbbr(ih) 
{
    typoTip.show("    ") 
    ih.Start()
    ih.Wait()
    ih.Stop()
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
    SoundPlay, bin\bingo.wav
    result := ""

    Loop 
    {
        Input, key, C L1, {LControl}{RControl}{LAlt}{RAlt}{Space}{Esc}{LWin}{RWin}{CapsLock}

        if InStr(ErrorLevel, "EndKey:") {
            SoundPlay, bin\beatmiss.wav
            break
        }
        if (ErrorLevel == "NewInput") {
            break
        }
            
        typo := typo . key
        postCharToTipWidnow(key)
        SoundPlay, bin\bingo.wav

        if matchCapslockAbbr(typo) {
            result := typo
            break
        }
    }

    typo := ""
    postMessageToTipWidnow(HIDE_TYPO_WINDOW)
    if (result) {
        if (StrLen(result) < 4) {
        } else {
            SoundPlay, bin\cool.wav
            ; SoundPlay, bin\perfect.wav
        }
        execCapslockAbbr(result)
    }
}