﻿action_copy_selected_file_path()
{
    clipboard := Explorer_GetSelection().selected
    tip("复制了: " clipboard, -1000)
}

action_open_selected_with(toRun, cmdArgs)
{
    ; msgbox, % cmdArgs
    ActivateOrRun("", toRun, cmdArgs) 
}

set_window_position_and_size(x, y, width, height)
{
    WinExist("A")
    WinGet, state, MinMax
    if state
        WinRestore
    WinMove, , , %x%, %y% , %width%, %height%
}

action_enter_task_switch_mode()
{
    global TASK_SWITCH_MODE, CapslockMode
    CapslockMode := false
    TASK_SWITCH_MODE := true
    send, ^!{tab}
    WinWaitActive, ahk_group TASK_SWITCH_GROUP,, 0.5
    if (!ErrorLevel) {
        WinWaitNotActive, ahk_group TASK_SWITCH_GROUP
    }
    TASK_SWITCH_MODE := false
}

action_hold_down_shift_key()
{
    send, {LShift down}
    key := LTrim(A_ThisHotkey, "*")
    keywait, %key%
    send, {LShift up}
}