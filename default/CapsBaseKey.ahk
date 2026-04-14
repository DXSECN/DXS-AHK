#Requires AutoHotkey v2.0
#SingleInstance Force

CapsLock & F5:: Reload()
CapsLock & j::Send("{Numpad1}")
CapsLock & k::Send("{Numpad2}")
CapsLock & l::Send("{Numpad3}")
CapsLock & u::Send("{Numpad4}")
CapsLock & i::Send("{Numpad5}")
CapsLock & o::Send("{Numpad6}")
CapsLock & 7::Send("{Numpad7}")
CapsLock & 8::Send("{Numpad8}")
CapsLock & 9::Send("{Numpad9}")
CapsLock & 0::Send("{Numpad0}")
CapsLock & ,::Send("{Numpad0}")
CapsLock & M::Send("{Numpad0}")
CapsLock & .::Send("{NumpadDot}")
CapsLock & /::Send("{NumpadDiv}")
CapsLock & +::Send("{NumpadAdd}")
CapsLock & -::Send("{NumpadSub}")
CapsLock & Space::Send("{NumpadEnter}")
CapsLock & X::Send("{Delete}")
CapsLock & Z::Send("{Backspace}")
CapsLock & `;::Send("{Text}_")
CapsLock & '::Send("{Text}_")

; 今日日期
CapsLock & t:: {
    ; 获取当前日期和时间
    currentDateTime := DateAdd(A_Now, 0, "days")
    
    ; 格式化日期为 YYYY/M/D 格式（例如 2026/4/14）
    ; FormatTime 的 Y 参数返回四位年份，M 返回月份（无前导零），D 返回日期（无前导零）
    formattedDate := FormatTime(currentDateTime, "yyyy/M/d")
    
    ; 将格式化后的日期发送到活动窗口
    SendInput(formattedDate)
}
