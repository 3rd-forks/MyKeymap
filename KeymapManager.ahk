#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook true

ProcessSetPriority "High"

init()

RAlt::LCtrl
!r::
{
    SoundBeep
    Reload
}

init()
{
    ; Capslock 和子模式
    Caps := KeymapManager.NewKeymap("*capslock")
    Caps.Map("*c", arg => Run("bin/SoundControl.exe"))
    Caps.Map("*x", arg => WinClose("A"))
    Caps.Map("*d", arg => Run("MyKeymap.exe bin/CustomShellMenu.ahk"))
    Caps.SendKeys("*w", "!{tab}")

    CapsF := KeymapManager.AddSubKeymap(Caps, "*f")
    CapsF.Map("*f", NoOperation)
    CapsF.Map("*n", arg => Run("notepad.exe"))

    CapsSpace := KeymapManager.AddSubKeymap(Caps, "*space")
    CapsSpace.Map("*space", NoOperation)

    ; Win10 和 Win11 的 Alt-Tab 任务切换视图
    TaskSwitch := TaskSwitchKeymap("e", "d", "s", "f", "x", "space")
    Caps.Map("*e", arg => Send("^!{tab}"), TaskSwitch)

    ; 可以自定义模式
    m := KeymapManager.NewKeymap("!f")
    m.Map("*n", arg => Run("notepad.exe"))
    m := KeymapManager.NewKeymap("f1 & f2")
    m.Map("*n", arg => Run("notepad.exe"))

    ; 鼠标模式相关
    Fast := MouseKeymap(110, 70, "T0.13", "T0.01", 1, "T0.2", "T0.03", KeymapManager.ClearLock)
    Slow := MouseKeymap(10, 13, "T0.13", "T0.01", 1, "T0.2", "T0.03", KeymapManager.UnLock)

    Caps.Map("*i", Fast.MoveMouseUp, Slow)
    Caps.Map("*k", Fast.MoveMouseDown, Slow)
    Caps.Map("*j", Fast.MoveMouseLeft, Slow)
    Caps.Map("*l", Fast.MoveMouseRight, Slow)

    Slow.Map("*i", Slow.MoveMouseUp)
    Slow.Map("*k", Slow.MoveMouseDown)
    Slow.Map("*j", Slow.MoveMouseLeft)
    Slow.Map("*l", Slow.MoveMouseRight)

    Caps.Map("*u", Fast.ScrollWheelUp)
    Caps.Map("*o", Fast.ScrollWheelDown)
    Caps.Map("*h", Fast.ScrollWheelLeft)
    Caps.Map("*;", Fast.ScrollWheelRight)

    Slow.Map("*u", Slow.ScrollWheelUp)
    Slow.Map("*o", Slow.ScrollWheelDown)
    Slow.Map("*h", Slow.ScrollWheelLeft)
    Slow.Map("*;", Slow.ScrollWheelRight)

    Caps.Map("*n", Fast.LButton())
    Caps.Map("*m", Fast.RButton())
    Caps.Map("*,", Fast.LButtonDown())

    Slow.Map("*n", Slow.LButton())
    Slow.Map("*m", Slow.RButton())
    Slow.Map("*,", Slow.LButtonDown())
    Slow.Map("*space", Slow.LButtonUp())

    ; 单按 3 锁定 3 模式
    Three := KeymapManager.NewKeymap("*3")
    Three.MapSinglePress(Three.ToggleLock)

    Three.RemapKey("h", "0")
    Three.RemapKey("j", "1")
    Three.RemapKey("k", "2")
    Three.RemapKey("l", "3")
    Three.RemapKey("u", "4")
    Three.RemapKey("i", "5")
    Three.RemapKey("o", "6")
    Three.RemapKey("b", "7")
    Three.RemapKey("n", "8")
    Three.RemapKey("m", "9")
    Three.RemapKey("w", "volume_down")
    Three.RemapKey("t", "volume_up")
    Three.RemapKey("space", "f1")
    Three.RemapKey("2", "f2")
    Three.RemapKey("4", "f4")
    Three.RemapKey("5", "f5")
    Three.RemapKey("9", "f9")
    Three.RemapKey("0", "f10")
    Three.RemapKey("e", "f11")
    Three.RemapKey("r", "f12")


    J := KeymapManager.NewKeymap("*j")
    J.MapSinglePress(arg => Send("{blind}j"))
    J.RemapKey("e", "up")
    J.RemapKey("d", "down")
    J.RemapKey("s", "left")
    J.RemapKey("f", "right")
    J.RemapKey("a", "home")
    J.RemapKey("g", "end")
    J.RemapKey("c", "backspace")
    J.RemapKey("x", "esc")
    J.RemapKey("r", "tab")
    J.RemapKey("q", "appskey")
    J.RemapKey(",", "delete")
    J.RemapKey(".", "insert")
    J.RemapKey("space", "enter")

    J.SendKeys("*w", "{blind}+{tab}")
    J.SendKeys("*b", "{blind}^{backspace}")
    J.SendKeys("*z", "{blind}^{left}")
    J.SendKeys("*v", "{blind}^{right}")
    J.SendKeys("*2", "{blind}^+{tab}")
    J.SendKeys("*3", "{blind}^{tab}")

    JK := KeymapManager.AddSubKeymap(J, "*k")
    JK.Map("*k", NoOperation)
    JK.SendKeys("*e", "{blind}+{up}")
    JK.SendKeys("*d", "{blind}+{down}")
    JK.SendKeys("*s", "{blind}+{left}")
    JK.SendKeys("*f", "{blind}+{right}")
    JK.SendKeys("*a", "{blind}+{home}")
    JK.SendKeys("*g", "{blind}+{end}")
    JK.SendKeys("*x", "{blind}+{esc}")
    JK.SendKeys("*z", "{blind}^+{left}")
    JK.SendKeys("*v", "{blind}^+{right}")
    JK.SendKeys("*c", "{blind}{backspace}")

    Semicolon := KeymapManager.NewKeymap("*;")
    Semicolon.MapSinglePress(arg => Send(";"))
    Semicolon.SendKeys("*u", "{blind}$")
    Semicolon.SendKeys("*r", "{blind}&")
    Semicolon.SendKeys("*a", "{blind}*")
    Semicolon.SendKeys("*m", "{blind}-")
    Semicolon.SendKeys("*c", "{blind}.")
    Semicolon.SendKeys("*n", "{blind}/")
    Semicolon.SendKeys("*i", "{blind}:")
    Semicolon.SendKeys("*s", "{blind}<")
    Semicolon.SendKeys("*d", "{blind}=")
    Semicolon.SendKeys("*f", "{blind}>")
    Semicolon.SendKeys("*y", "{blind}@")
    Semicolon.SendKeys("*z", "{blind}\")
    Semicolon.SendKeys("*x", "{blind}_")
    Semicolon.SendKeys("*b", "{blind}%")
    Semicolon.SendKeys("*j", "{blind};")
    Semicolon.SendKeys("*k", "{blind}``")
    Semicolon.SendKeys("*g", "{blind}{!}")
    Semicolon.SendKeys("*w", "{blind}{#}")
    Semicolon.SendKeys("*h", "{blind}{+}")
    Semicolon.SendKeys("*e", "{blind}{^}")
    Semicolon.SendKeys("*v", "{blind}|")
    Semicolon.SendKeys("*t", "{blind}~")
}

NoOperation(thisHotkey) {
}

ShowToolTip(msg, show := true) {
    if !show {
        return
    }
    ToolTip(msg)
}


class KeymapManager {
    static M := Map()
    static Locked := false

    static NewKeymap(globalHotkey) {
        ; 创建 keymap, 并注册它的全局触发热键
        waitKey := this.ExtractWaitKey(globalHotkey)
        k := Keymap(globalHotkey, waitKey)
        handler := thisHotkey => this.Activate(k)
        Hotkey(globalHotkey, handler, "On")

        ; keymap 激活时可能会改掉全局热键的功能
        ; 所以要记住全局热键的功能, 以便在 Activate 方法返回前恢复全局热键
        this.M[globalHotkey] := handler
        return k
    }

    static Activate(keymap) {
        ; 临时关掉锁定, 避免两个模式同时启用
        ; 如果同时存在 *a 和 a 两个热键, 执行哪个是未定义的
        if KeymapManager.Locked {
            KeymapManager.Locked.Disable()
        }

        ; 在按住 Caps 模式的情况下, 临时使用 3 模式输入数字, 当 3 模式退出时应该还原到 Caps 模式

        keymap.Enable()
        startTick := A_TickCount
        KeyWait(keymap.WaitKey)
        if (A_PriorKey = keymap.WaitKey && (A_TickCount - startTick < 300)) {
            keymap.SinglePressAction()
        }
        keymap.Disable()
        KeymapManager.RestoreGlobalHotkey()

        ; 比如直接锁定 3 模式
        ; 比如锁住 3 模式然后使用 9 模式热键, 9 模式退出前要恢复 3 模式
        if KeymapManager.Locked {
            KeymapManager.Locked.Enable()

            ; 在系统 AltTab 窗口中激活 TaskSwitch 模式, 等 AltTab 窗口关闭后要关闭 TaskSwitch 模式
            if KeymapManager.Locked.AfterLocked {
                SetTimer(KeymapManager.Locked.AfterLocked, -1)
            }
        }
    }

    static AddSubKeymap(parent, theHotkey) {
        waitKey := this.ExtractWaitKey(theHotkey)
        subKeymap := Keymap(theHotkey, waitKey)

        ; 进入子模式时执行如下代码
        handler(arg) {
            startTick := A_TickCount
            parent.Disable()
            KeymapManager.RestoreGlobalHotkey()
            subKeymap.Enable()
            KeyWait(subKeymap.WaitKey)
            if (A_PriorKey = subKeymap.WaitKey && (A_TickCount - startTick < 300)) {
                subKeymap.SinglePressAction()
            }
            if KeymapManager.Locked == subKeymap {
                return
            }
            subKeymap.Disable()
            parent.Enable()
        }

        ; 在 parent 中添加一个 theHotkey, 用来激活 sub keymap
        parent.Map(theHotkey, handler)
        return subKeymap
    }

    static LockKeymap(toLock, toggle, show) {
        ; 未锁定
        if !KeymapManager.Locked {
            ShowToolTip("已锁定 " toLock.Name, show)
            KeymapManager.Locked := toLock
            return
        }
        ; 已经锁定了自己
        if KeymapManager.Locked == toLock {
            if !toggle {
                return
            }
            ShowToolTip("取消锁定", show)
            KeymapManager.UnLock()
            return
        }
        ; 锁定了别的模式, 那么切换成锁定自己
        ShowToolTip("锁定切换: " KeymapManager.Locked.Name " -> " toLock.Name, show)
        KeymapManager.Locked := toLock
    }

    static UnLock() {
        if KeymapManager.Locked {
            KeymapManager.Locked.Disable()
            KeymapManager.RestoreGlobalHotkey()
            KeymapManager.Locked := false
        }
    }
    static ClearLock() {
        KeymapManager.Locked := false
    }

    static ExtractWaitKey(hotkey) {
        waitKey := Trim(hotkey, " #!^+<>*~$")
        if InStr(waitKey, "&") {
            sp := StrSplit(waitKey, "&")
            waitKey := Trim(sp[2])
        }
        return waitKey
    }

    static RestoreGlobalHotkey() {
        ; 恢复全局热键
        for globalHotkey, handler in this.M {
            Hotkey(globalHotkey, handler, "On")
        }
    }
}


class Keymap {
    __New(name := "", waitKey := "") {
        this.Name := name
        this.WaitKey := waitKey
        this.SinglePressAction := NoOperation
        this.M := Map()
        this.ToggleLock := this._lockOrUnlock.Bind(this)
        this.AfterLocked := false
    }

    Map(hotkeyName, handler, keymapToLock := false, toggle := false) {
        wrapper(thisHotkey) {
            handler(thisHotkey)
            if !keymapToLock {
                return
            }
            KeymapManager.LockKeymap(keymapToLock, false, false)
        }
        if hotkeyName == "SinglePress" {
            this.SinglePressAction := wrapper
            return
        }
        this.M[hotkeyName] := wrapper
    }

    MapSinglePress(handler) {
        this.Map("SinglePress", handler)
    }

    Enable() {
        for hotkeyName, handler in this.M {
            Hotkey(hotkeyName, handler, "On")
        }
    }

    Disable() {
        for hotkeyName, handler in this.M {
            Hotkey(hotkeyName, "Off")
        }
    }

    _lockOrUnlock(thiHotkey) {
        KeymapManager.LockKeymap(this, true, true)
    }

    RemapKey(a, b) {
        downHandler(thisHotkey) {
            Send "{Blind}{" b " DownR}"
        }
        upHandler(thisHotkey) {
            Send "{Blind}{" b " Up}"
        }
        this.Map("*" a, downHandler)
        this.Map("*" a " up", upHandler)
    }

    SendKeys(hk, keys) {
        handler(thisHotkey) {
            Send(keys)
        }
        this.Map(hk, handler)
    }
}

class MouseKeymap extends Keymap {

    __New(single, repeat, delay1, delay2, scrollOnceLineCount, scrollDelay1, scrollDelay2, lockHandler) {
        super.__New()
        this.single := single
        this.repeat := repeat
        this.delay1 := delay1
        this.delay2 := delay2
        this.scrollOnceLineCount := scrollOnceLineCount
        this.scrollDelay1 := scrollDelay1
        this.scrollDelay2 := scrollDelay2
        this.lockHandler := lockHandler

        this.MoveMouseUp := this._moveMouse.Bind(this, 0, -1)
        this.MoveMouseDown := this._moveMouse.Bind(this, 0, 1)
        this.MoveMouseLeft := this._moveMouse.Bind(this, -1, 0)
        this.MoveMouseRight := this._moveMouse.Bind(this, 1, 0)
        this.ScrollWheelUp := this._scrollWheel.Bind(this, 1)
        this.ScrollWheelDown := this._scrollWheel.Bind(this, 2)
        this.ScrollWheelLeft := this._scrollWheel.Bind(this, 3)
        this.ScrollWheelRight := this._scrollWheel.Bind(this, 4)
    }

    _moveMouse(directionX, directionY, thisHotkey) {
        key := KeymapManager.ExtractWaitKey(thisHotkey)
        MouseMove(directionX * this.single, directionY * this.single, 0, "R")
        release := KeyWait(key, this.delay1)
        if release {
            return
        }
        while !release {
            MouseMove(directionX * this.repeat, directionY * this.repeat, 0, "R")
            release := KeyWait(key, this.delay2)
        }
    }

    _scrollWheel(direction, thisHotkey) {
        key := KeymapManager.ExtractWaitKey(thisHotkey)
        switch (direction) {
            case 1: MouseClick("WheelUp", , , this.scrollOnceLineCount)
            case 2: MouseClick("WheelDown", , , this.scrollOnceLineCount)
            case 3: MouseClick("WheelLeft", , , this.scrollOnceLineCount)
            case 4: MouseClick("WheelRight", , , this.scrollOnceLineCount)
        }
        release := KeyWait(key, this.scrollDelay1)
        if release {
            return
        }
        while !release {
            switch (direction) {
                case 1: MouseClick("WheelUp", , , this.scrollOnceLineCount)
                case 2: MouseClick("WheelDown", , , this.scrollOnceLineCount)
                case 3: MouseClick("WheelLeft", , , this.scrollOnceLineCount)
                case 4: MouseClick("WheelRight", , , this.scrollOnceLineCount)
            }
            release := KeyWait(key, this.scrollDelay2)
        }
    }

    LButton() {
        handler(thisHotkey) {
            Send("{blind}{LButton}")
            this.lockHandler()
        }
        return handler
    }

    RButton() {
        handler(thisHotkey) {
            Send("{blind}{RButton}")
            this.lockHandler()
        }
        return handler
    }

    LButtonDown() {
        handler(thisHotkey) {
            Send("{blind}{LButton DownR}")
        }
        return handler
    }

    LButtonUp() {
        handler(thisHotkey) {
            Send("{blind}{LButton Up}")
            this.lockHandler()
        }
        return handler
    }
}


class TaskSwitchKeymap extends Keymap {

    __New(up, down, left, right, delete, enter) {
        super.__New("TaskSwitchKeymap")
        this.RemapKey(up, "up")
        this.RemapKey(down, "down")
        this.RemapKey(left, "left")
        this.RemapKey(right, "right")
        this.RemapKey(delete, "delete")
        this.RemapKey(enter, "enter")
        this.AfterLocked := this.DeactivateTaskSwitch.Bind(this)
        GroupAdd("TASK_SWITCH_GROUP", "ahk_class MultitaskingViewFrame")
        GroupAdd("TASK_SWITCH_GROUP", "ahk_class XamlExplorerHostIslandWindow")
    }

    DeactivateTaskSwitch() {
        ; 先等 AltTab 窗口出现, 再等它消失, 然后解锁
        notTimedOut := WinWaitActive("ahk_group TASK_SWITCH_GROUP", , 1)
        if (notTimedOut) {
            WinWaitNotActive("ahk_group TASK_SWITCH_GROUP")
        }
        ; 在 AltTab 窗口出现时, 把锁定的模式切换到 3 模式, 这种情况无需解锁
        if KeymapManager.Locked == this {
            KeymapManager.UnLock()
        }
    }
}