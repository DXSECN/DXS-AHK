#Requires AutoHotkey v2.0
#SingleInstance Force

global CapsLockState := false

; 当 CapsLock 被按下时，记录按下时间，并启动一个定时器用于后续判断
*CapsLock:: {
    global CapsLockPressTime := A_TickCount
    ; 设置一个短暂的定时器，用于检测是否在短时间内弹起且没有其他键按下
    SetTimer(CheckCapsLockRelease, -150)  ; 150 毫秒后检查，可根据需要调整
}

CheckCapsLockRelease() {
    global CapsLockPressTime
    ; 如果 CapsLock 仍然处于按下状态，说明用户可能正在组合键，不做处理
    if GetKeyState("CapsLock", "P")
        return
    ; 如果弹起时间距离按下时间小于 150ms，视为单独短按
    if (A_TickCount - CapsLockPressTime < 150) {
        ; 切换大小写状态
        global CapsLockState := !CapsLockState
        SetCapsLockState(CapsLockState)
    }
}

; 注意：原有的 CapsLock:: 标签热键不再需要，因为组合键依然通过 & 定义工作。
; 但是为了保持 Loader 中的调用兼容，可以留一个空函数或删除。
CapsLockPlusCore(*) {
    ; 这个函数现在不会被调用，因为 CapsLock 热键已被 *CapsLock 替代。
    ; 如果你有其他代码调用了它，可以保留空函数体。
}