#Requires AutoHotkey >=v2.0-
#SingleInstance Force

if !IsSet(Loader) {
; -------- 可调整参数 ---------
minSpeed := 3              ; 最小速度
maxSpeed := 40             ; 最大速度
speedIncStep := 0.40       ; 加速线性速度
acceleration := 1.05       ; 加速系数
speedIncDelay := 100       ; 加速延迟（毫秒）
speedDecStep := 0.10       ; 减速线性系数
deceleration := 0.60       ; 减速系数
speedDecDelay := 40        ; 减速延迟（毫秒）
DPISwitchNum := 0.2        ; DPI切换速度系数
DelayDragSwitch := false   ; 拖拽模式开关
ClickDelay := 0.20         ; 拖拽模式长按延迟（秒）
; --------- 键位调整 ----------
; 鼠标控制
FunctionKey := "CapsLock"
SwitchDPIKey := "LAlt"
UpKey := "I"
DownKey := "K"
LeftKey := "J"
RightKey := "L"
LeftMouseClickKey := "D"
RightMouseClickKey := "A"
MiddleMouseClickKey := "E"
MouseWheelKey := "F"
MouseBackKey := "O"
MouseForwardKey := "U"
; ----------------------------
} 

; 全局变量
HotDPISwitch := 1
SwitchDPIKeyState := false
MouseButtonState := Map("LeftMouseClickKeyState", false, "RightMouseClickKeyState", false, "MiddleMouseClickKeyState", false) ; 按键状态

SetWorkingDir(A_ScriptDir)

; 初始化变量
moveSpeed := minSpeed ; 初始速度
lastMoveTime := 0   ; 上次移动时间
lastCheckTime := 0  ; 上次检查时间

; 速度检查函数
CheckSpeed() {
    global moveSpeed, minSpeed, lastMoveTime
    global acceleration, speedIncStep
    global deceleration, speedDecStep
    OutputDebug "Timer"
    currentTime := A_TickCount
    if (currentTime - lastMoveTime > speedDecDelay) {
        moveSpeed := Max(moveSpeed * deceleration, minSpeed)
        moveSpeed := Max(moveSpeed - speedDecStep, minSpeed)
    }
}

; 移动函数
MoveMouse(dx, dy) {
    global moveSpeed, maxSpeed, speedIncStep, lastMoveTime, HotDPISwitch

    ; 线性增加速度
    moveSpeed := Min(moveSpeed * acceleration, maxSpeed) 
    moveSpeed := Min(moveSpeed + speedIncStep, maxSpeed)

    lastMoveTime := A_TickCount
    
    finalDx := Round(dx * moveSpeed * HotDPISwitch)
    finalDy := Round(dy * moveSpeed * HotDPISwitch)
    
    MouseMove(finalDx, finalDy, , "R")
}

; 鼠标控制执行
Hotkey "~" FunctionKey, FunctionKeyState

FunctionKeyState(*) {
    Hotkey UpKey, UpAction, "On"
    Hotkey LeftKey, LeftAction, "On"
    Hotkey RightKey, RightAction, "On"
    Hotkey DownKey, DownAction, "On"
    Hotkey LeftMouseClickKey, LeftMouseClick, "On"
    Hotkey RightMouseClickKey, RightMouseClick, "On"
    Hotkey MiddleMouseClickKey, MiddleMouseClick, "On"
    Hotkey SwitchDPIKey, SwitchDPIKeyCheck, "On"
    Hotkey MouseWheelKey " & " UpKey, MouseWheelUp, "On"
    Hotkey MouseWheelKey " & " DownKey, MouseWheelDown, "On"
    Hotkey MouseBackKey, MouseBackKeyClick, "On"
    Hotkey MouseForwardKey, MouseForwardKeyClick, "On"
    SetTimer(CheckSpeed, speedDecDelay) ; 设置定时器，每50ms检查一次速度
    KeyWait(FunctionKey)
    Hotkey UpKey, "Off"
    Hotkey LeftKey, "Off"
    Hotkey RightKey, "Off"
    Hotkey DownKey, "Off"
    Hotkey LeftMouseClickKey, "Off"
    Hotkey RightMouseClickKey, "Off"
    Hotkey MiddleMouseClickKey, "Off"
    Hotkey SwitchDPIKey, "Off"
    Hotkey MouseWheelKey " & " UpKey, "Off"
    Hotkey MouseWheelKey " & " DownKey, "Off"
    Hotkey MouseBackKey, "Off"
    Hotkey MouseForwardKey, "Off"
    ResetMouseState()
    SetTimer(CheckSpeed, 0) ; 
}


; DPI切换检测
SwitchDPIKeyCheck(*) {
    global SwitchDPIKeyState, SwitchDPIKey, HotDPISwitch, DPISwitchNum
    HotDPISwitch := DPISwitchNum
    KeyWait(SwitchDPIKey)
    HotDPISwitch := 1
}

UpAction(*){
    while GetKeyState(UpKey, "P") {
        if GetKeyState(LeftKey, "P")
            MoveMouse(-0.8, -0.8)
        else if GetKeyState(RightKey, "P")
            MoveMouse(0.8, -0.8)
        else if GetKeyState(DownKey, "P")
            MoveMouse(0, 0.5)
        else
            MoveMouse(0, -1)
        Sleep(10)
    }
}

DownAction(*){
    while GetKeyState(DownKey, "P") {
        if GetKeyState(LeftKey, "P")
            MoveMouse(-0.8, 0.8)
        else if GetKeyState(RightKey, "P")
            MoveMouse(0.8, 0.8)
        else if GetKeyState(UpKey, "P")
            MoveMouse(0, -0.5)
        else
            MoveMouse(0, 1)
        Sleep(10)
    }
}

LeftAction(*){
    while GetKeyState(LeftKey, "P") {
        if GetKeyState(UpKey, "P")
            MoveMouse(-0.8, -0.8)
        else if GetKeyState(DownKey, "P")
            MoveMouse(-0.8, 0.8)
        else if GetKeyState(RightKey, "P")
            MoveMouse(0.5, 0)
        else
            MoveMouse(-1, 0)
        Sleep(10)
    }
}

RightAction(*){
    while GetKeyState(RightKey, "P") {
        if GetKeyState(UpKey, "P")
            MoveMouse(0.8, -0.8)
        else if GetKeyState(DownKey, "P")
            MoveMouse(0.8, 0.8)
        else if GetKeyState(LeftKey, "P")
            MoveMouse(-0.5, 0)
        else
            MoveMouse(1, 0)
        Sleep(10)
    }
}

LeftMouseClick(*) {
    if DelayDragSwitch == true {
        if !KeyWait(LeftMouseClickKey, "T" ClickDelay) {
            if MouseButtonState["LeftMouseClickKeyState"] {
                Click "Up Left"
                MouseButtonState["LeftMouseClickKeyState"] := false
            } else {
                Click "Down Left"
                MouseButtonState["LeftMouseClickKeyState"] := true
            }
        } else {
            if MouseButtonState["LeftMouseClickKeyState"] {
                Click "Up Left"
                MouseButtonState["LeftMouseClickKeyState"] := false
            } else {
                Click "Left"
            }
        }
    } else {
        Click "Down Left"
        KeyWait(LeftMouseClickKey)
        Click "Up Left"
    }
}

RightMouseClick(*) {
    if DelayDragSwitch == true {
        if !KeyWait(RightMouseClickKey, "T" ClickDelay) {
            if MouseButtonState["RightMouseClickKeyState"] {
                Click "Up Right"
                MouseButtonState["RightMouseClickKeyState"] := false
            } else {
                Click "Down Right"
                MouseButtonState["RightMouseClickKeyState"] := true
            }
        } else {
            if MouseButtonState["RightMouseClickKeyState"] {
                Click "Up Right"
                MouseButtonState["RightMouseClickKeyState"] := false
            } else {
                Click "Right"
            }
        }
    } else {
        Click "Down Right"
        KeyWait(RightMouseClickKey)
        Click "Up Right"
    }
}

MiddleMouseClick(*) {
    if DelayDragSwitch == true {
        if !KeyWait(MiddleMouseClickKey, "T" ClickDelay) {
            if MouseButtonState["MiddleMouseClickKeyState"] {
                Click "Up Middle"
                MouseButtonState["MiddleMouseClickKeyState"] := false
            } else {
                Click "Down Middle"
                MouseButtonState["MiddleMouseClickKeyState"] := true
            }
        } else {
            if MouseButtonState["MiddleMouseClickKeyState"] {
                Click "Up Middle"
                MouseButtonState["MiddleMouseClickKeyState"] := false
            } else {
                Click "Middle"
            }
        }
    } else {
        Click "Down Middle"
        KeyWait(MiddleMouseClickKey)
        Click "Up Middle"
    }
}

MouseBackKeyClick(*) {
    Send "{XButton1}"
}
MouseForwardKeyClick(*) {
    Send "{XButton2}"
}

MouseWheelUp(*) {
    send "{WheelUp}"
}

MouseWheelDown(*) {
    send "{WheelDown}"
}


; 重置鼠标状态的函数
ResetMouseState(*) {
    OutputDebug 'Reset'
    global MouseButtonState
    ; 检查并重置左键状态
    if MouseButtonState["LeftMouseClickKeyState"] {
        Click "Up Left"
        MouseButtonState["LeftMouseClickKeyState"] := false
    }
    ; 检查并重置右键状态
    if MouseButtonState["RightMouseClickKeyState"] {
        Click "Up Right"
        MouseButtonState["RightMouseClickKeyState"] := false
    }
    ; 检查并重置中键状态
    if MouseButtonState["MiddleMouseClickKeyState"] {
        Click "Up Middle"
        MouseButtonState["MiddleMouseClickKeyState"] := false
    }
}