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
CapsLock & Q::Send("{Delete}")
CapsLock & Z::Send("{Backspace}")
CapsLock & `;::Send("{Text}_")
CapsLock & '::Send("{Text}_")

#HotIf GetKeyState("CapsLock", "P")
LAlt & WheelUp::Volume_Up               ; LAlt + 滚轮上 -> 音量加
LAlt & WheelDown::Volume_Down           ; LAlt + 滚轮下 -> 音量减
#HotIf 