#Requires AutoHotkey v2.0
#SingleInstance Force

; ================= 配置区 =================
ClickInterval := 40      ; 连点间隔（毫秒），50ms ≈ 20次/秒
InitialDelay := 200      ; 长按多久后开始连点（毫秒），防止误触普通点击
; ==========================================

; 当按住 CapsLock 时，接管鼠标左键和右键
CapsLock & LButton:: {
    global ClickInterval, InitialDelay
    
    ; 先发送一次普通的按下事件，保证不丢失第一次点击
    Send("{Blind}{LButton Down}")
    
    ; 等待初始延迟，如果在此期间松开则只是普通点击
    if !KeyWait("LButton", "T" . InitialDelay / 1000) {
        ; 超时未松开，进入连点循环
        Send("{Blind}{LButton Up}") ; 释放之前的按下状态
        
        while GetKeyState("LButton", "P") && GetKeyState("CapsLock", "P") {
            Click("Left")
            Sleep(ClickInterval)
        }
    } else {
        ; 在延迟内松开了，正常释放按键
        Send("{Blind}{LButton Up}")
    }
}

CapsLock & RButton:: {
    global ClickInterval, InitialDelay
    
    Send("{Blind}{RButton Down}")
    
    if !KeyWait("RButton", "T" . InitialDelay / 1000) {
        Send("{Blind}{RButton Up}")
        
        while GetKeyState("RButton", "P") && GetKeyState("CapsLock", "P") {
            Click("Right")
            Sleep(ClickInterval)
        }
    } else {
        Send("{Blind}{RButton Up}")
    }
}
