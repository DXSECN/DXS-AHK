; --------------------------------------
; 最新版本AHK自带类似功能，根据版本需求启动
; --------------------------------------

#Requires AutoHotkey v2.0
#SingleInstance Force

global CapsLockState := false

; 当 CapsLock 被按下时，记录按下时间，并启动一个定时器用于后续判断
*CapsLock:: CapsLockPlusCore()

CapsLockPlusCore() {
    global CapsLockPressTime := A_TickCount
    ; 启动一个定时器，在 150ms 后检查 CapsLock 是否仍然处于按下状态
    SetTimer(CheckCapsLockRelease, -150)
    ; 如果 CapsLock 已经处于按下状态，则切换大小写状态
    if CapsLockState {
        ; 切换大小写状态
        Send("{CapsLock}")
        ; 更新 CapsLock 状态
        global CapsLockState := !CapsLockState
    }
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
