#Requires AutoHotkey v2.0

global CapsLockState := false
CapsLockPlusCore(*){
    global CapsLockState
    if (A_PriorHotkey != "CapsLock" or A_TimeSincePriorHotkey > 200) ; 判断是否为单独按下
    {
        CapsLockState := !CapsLockState
        SetCapsLockState(CapsLockState ? "On" : "Off")
    }
    else
    {
        ; 如果 CapsLock 是组合键的一部分，则不切换大小写
        KeyWait("CapsLock") ; 等待 CapsLock 释放
    }
    return
}