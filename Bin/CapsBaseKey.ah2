#Requires AutoHotkey v2.0
#SingleInstance Force

CapsLock & 1::Send("{Numpad1}")
CapsLock & 2::Send("{Numpad2}")
CapsLock & 3::Send("{Numpad3}")
CapsLock & 4::Send("{Numpad4}")
CapsLock & 5::Send("{Numpad5}")
CapsLock & 6::Send("{Numpad6}")
CapsLock & 7::Send("{Numpad7}")
CapsLock & 8::Send("{Numpad8}")
CapsLock & 9::Send("{Numpad9}")
CapsLock & 0::Send("{Numpad0}")
CapsLock & .::Send("{NumpadDot}")
CapsLock & /::Send("{NumpadDiv}")
CapsLock & +::Send("{NumpadAdd}")
CapsLock & -::Send("{NumpadSub}")
CapsLock & Space::Send("{NumpadEnter}")
CapsLock & `::Send("{Delete}")
CapsLock & Z::Send("{Backspace}")
CapsLock & `;::Send("{Text}_")

<<<<<<< Updated upstream
CapsLock & E::Send("{Up}")
CapsLock & D::Send("{Down}")
CapsLock & S::Send("{Left}")
CapsLock & F::Send("{Right}")
 
#HotIf GetKeyState("LAlt", "P")
CapsLock & WheelUp::Volume_Up               ; LAlt + 滚轮上 -> 音量加
CapsLock & WheelDown::Volume_Down           ; LAlt + 滚轮下 -> 音量减
#HotIf 
=======
#HotIf GetKeyState("CapsLock", "P")
LAlt & MButton::Volume_Mute             ; LAlt + 滚轮上 -> 静音
LAlt & WheelUp::Volume_Up               ; LAlt + 滚轮上 -> 音量加
LAlt & WheelDown::Volume_Down           ; LAlt + 滚轮下 -> 音量减
LAlt & WheelLeft::Send("#^{Left}")       ; LAlt + 滚轮左 -> 窗口左移
LAlt & WheelRight::Send("#^{Right}")     ; LAlt + 滚轮右 -> 窗口右移
#HotIf 
>>>>>>> Stashed changes
