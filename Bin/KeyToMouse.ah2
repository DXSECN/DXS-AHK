#Requires AutoHotkey v2.0
#SingleInstance Force
; --------- 默认模式参数 ----------
minSpeed := 5              ; 最小速度
maxSpeed := 40             ; 最大速度
speedIncStep := 0.20       ; 加速线性步长
acceleration := 1.05       ; 加速系数
speedIncDelay := 20       ; 加速延迟（毫秒）
speedDecStep := 0.10       ; 减速线性步长
deceleration := 0.60       ; 减速系数
speedDecDelay := 40        ; 减速延迟（毫秒，即速度检查定时器周期）
; --------- DPI模式参数 ----------
DPIMinSpeed := 2           ; DPI模式最小速度
DPIMaxSpeed := 5          ; DPI模式最大速度
DPISpeedIncStep := 0.20    ; DPI模式加速线性步长    l
DPIAcceleration := 1.00    ; DPI模式加速系数
DPISpeedIncDelay := 20    ; DPI模式加速延迟（毫秒）
DPISpeedDecStep := 0.05    ; DPI模式减速线性步长
DPIDeceleration := 0.60    ; DPI模式减速系数
DPISpeedDecDelay := 50     ; DPI模式减速延迟（毫秒）
; --------- 拖拽模式参数 ----------
DelayDragSwitch := false   ; 拖拽模式开关
ClickDelay := 0.20         ; 拖拽模式长按延迟（秒）
; --------- 默认键位设置 ----------
; 鼠标控制
FunctionKey := "CapsLock"
SwitchDPIKey := "LAlt"
UpKey := "I"
DownKey := "K"
LeftKey := "J"
RightKey := "L"
LeftMouseClickKey := "Q"
RightMouseClickKey := "W"
MiddleMouseClickKey := "A"
MouseWheelKey := "R"
MouseBackKey := "O"
MouseForwardKey := "U"
; ----------------------------

; 全局变量
isDPIMode := false                ; 当前是否处于 DPI 模式（LAlt 按下）
moveSpeed := minSpeed             ; 当前速度值（动态变化）
lastMoveTime := 0                 ; 上次移动时间
sequenceStartTime := 0            ; 当前移动序列的开始时间（用于加速延迟）
CapsLockFix := false              ; CapsLock 键状态（用于功能键激活）

; 鼠标按键拖拽状态（用于 DelayDragSwitch）
MouseButtonState := Map("LeftMouseClickKeyState", false, "RightMouseClickKeyState", false, "MiddleMouseClickKeyState", false)

SetWorkingDir(A_ScriptDir)

; ---------- 辅助函数：根据当前模式获取参数 ----------
GetCurrentParams() {
    global isDPIMode
    global minSpeed, maxSpeed, speedIncStep, acceleration, speedIncDelay, speedDecStep, deceleration, speedDecDelay
    global DPIMinSpeed, DPIMaxSpeed, DPISpeedIncStep, DPIAcceleration, DPISpeedIncDelay, DPISpeedDecStep, DPIDeceleration, DPISpeedDecDelay
    
    if isDPIMode {
        return {
            minSpeed: DPIMinSpeed,
            maxSpeed: DPIMaxSpeed,
            speedIncStep: DPISpeedIncStep,
            acceleration: DPIAcceleration,
            speedIncDelay: DPISpeedIncDelay,
            speedDecStep: DPISpeedDecStep,
            deceleration: DPIDeceleration,
            speedDecDelay: DPISpeedDecDelay
        }
    } else {
        return {
            minSpeed: minSpeed,
            maxSpeed: maxSpeed,
            speedIncStep: speedIncStep,
            acceleration: acceleration,
            speedIncDelay: speedIncDelay,
            speedDecStep: speedDecStep,
            deceleration: deceleration,
            speedDecDelay: speedDecDelay
        }
    }
}

; 速度检查函数（定时器调用，用于减速）
CheckSpeed() {
    global moveSpeed, lastMoveTime
    params := GetCurrentParams()
    
    currentTime := A_TickCount
    if (currentTime - lastMoveTime > params.speedDecDelay) {
        moveSpeed := Max(moveSpeed * params.deceleration, params.minSpeed)
        moveSpeed := Max(moveSpeed - params.speedDecStep, params.minSpeed)
    }
}

; 移动鼠标（根据当前模式计算速度增量，支持加速延迟）
MoveMouse(dx, dy) {
    global moveSpeed, lastMoveTime, sequenceStartTime
    params := GetCurrentParams()
    currentTime := A_TickCount
    
    ; ----- 加速延迟逻辑：检测是否为新移动序列的开始 -----
    ; 如果距离上次移动超过 200ms（或两倍减速延迟），认为是新的移动序列
    static SEQUENCE_TIMEOUT := 200  ; 毫秒，超过此时间视为新序列
    if (lastMoveTime = 0 || currentTime - lastMoveTime > SEQUENCE_TIMEOUT) {
        sequenceStartTime := currentTime   ; 记录新序列的开始时刻
    }
    
    ; 判断是否处于加速延迟期内
    if (currentTime - sequenceStartTime < params.speedIncDelay) {
        ; 延迟期内：速度保持最小值，不加速
        moveSpeed := params.minSpeed
    } else {
        ; 正常加速（乘法和加法）
        moveSpeed := Min(moveSpeed * params.acceleration, params.maxSpeed)
        moveSpeed := Min(moveSpeed + params.speedIncStep, params.maxSpeed)
    }
    
    lastMoveTime := currentTime
    
    ; 计算最终位移（速度已包含模式差异）
    finalDx := Round(dx * moveSpeed)
    finalDy := Round(dy * moveSpeed)
    
    MouseMove(finalDx, finalDy, , "R")
}

; ---------- 按键绑定与模式切换 ----------
Hotkey "~" FunctionKey, FunctionKeyState

FunctionKeyState(*) {
    ; 激活鼠标控制模式：开启所有方向键和鼠标功能键
    Hotkey UpKey, UpAction, "On"
    Hotkey LeftKey, LeftAction, "On"
    Hotkey RightKey, RightAction, "On"
    Hotkey DownKey, DownAction, "On"
    Hotkey LeftMouseClickKey, LeftMouseClick, "On"
    Hotkey RightMouseClickKey, RightMouseClick, "On"
    Hotkey MiddleMouseClickKey, MiddleMouseClick, "On"
    Hotkey SwitchDPIKey, SwitchDPIKeyDown, "On"
    Hotkey SwitchDPIKey " Up", SwitchDPIKeyUp, "On"
    Hotkey MouseWheelKey " & " UpKey, MouseWheelUp, "On"
    Hotkey MouseWheelKey " & " DownKey, MouseWheelDown, "On"
    Hotkey MouseBackKey, MouseBackKeyClick, "On"
    Hotkey MouseForwardKey, MouseForwardKeyClick, "On"
    
    ; 启动速度衰减定时器
    normalParams := GetCurrentParams()
    SetTimer(CheckSpeed, normalParams.speedDecDelay)
    
    ; 等待功能键松开
    KeyWait(FunctionKey)
    
    ; 退出鼠标控制模式，清理
    Hotkey UpKey, "Off"
    Hotkey LeftKey, "Off"
    Hotkey RightKey, "Off"
    Hotkey DownKey, "Off"
    Hotkey LeftMouseClickKey, "Off"
    Hotkey RightMouseClickKey, "Off"
    Hotkey MiddleMouseClickKey, "Off"
    Hotkey SwitchDPIKey, "Off"
    Hotkey SwitchDPIKey " Up", "Off"
    Hotkey MouseWheelKey " & " UpKey, "Off"
    Hotkey MouseWheelKey " & " DownKey, "Off"
    Hotkey MouseBackKey, "Off"
    Hotkey MouseForwardKey, "Off"
    ResetMouseState()
    SetTimer(CheckSpeed, 0)
    
    global CapsLockFix
    ; 重置CapsLock状态（如果功能键就是CapsLock）
    if (FunctionKey = "CapsLock" && CapsLockFix = true) {
        SetCapsLockState(!GetKeyState("CapsLock", "T"))
        CapsLockFix := false
    }

    ; 重置全局移动相关变量，避免下次进入时残留状态
    global moveSpeed, lastMoveTime, sequenceStartTime, isDPIMode
    isDPIMode := false
    moveSpeed := minSpeed
    lastMoveTime := 0
    sequenceStartTime := 0
}

; LAlt 按下：进入 DPI 模式
SwitchDPIKeyDown(*) {
    global isDPIMode, moveSpeed, DPIMinSpeed, lastMoveTime, sequenceStartTime
    if !isDPIMode {
        isDPIMode := true
        moveSpeed := DPIMinSpeed
        lastMoveTime := 0
        sequenceStartTime := 0
        dpiParams := GetCurrentParams()
        SetTimer(CheckSpeed, dpiParams.speedDecDelay)
    }
}

; LAlt 弹起：恢复普通模式
SwitchDPIKeyUp(*) {
    global isDPIMode, moveSpeed, minSpeed, lastMoveTime, sequenceStartTime
    if isDPIMode {
        isDPIMode := false
        moveSpeed := minSpeed
        lastMoveTime := 0
        sequenceStartTime := 0
        normalParams := GetCurrentParams()
        SetTimer(CheckSpeed, normalParams.speedDecDelay)
    }
}

; ---------- 方向移动（对角线逻辑保持不变，但 MoveMouse 已内置加速延迟） ----------
UpAction(*) {
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
    global CapsLockFix := true
}

DownAction(*) {
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
    global CapsLockFix := true
}

LeftAction(*) {
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
    global CapsLockFix := true
}

RightAction(*) {
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
    global CapsLockFix := true
}

; ---------- 鼠标按键（支持拖拽模式，未改动） ----------
LeftMouseClick(*) {
    global DelayDragSwitch, ClickDelay, MouseButtonState
    if DelayDragSwitch {
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
    global CapsLockFix := true
}

RightMouseClick(*) {
    global DelayDragSwitch, ClickDelay, MouseButtonState
    if DelayDragSwitch {
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
    global CapsLockFix := true
}

MiddleMouseClick(*) {
    global DelayDragSwitch, ClickDelay, MouseButtonState
    if DelayDragSwitch {
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
    global CapsLockFix := true
}

MouseBackKeyClick(*) {
    Send "{XButton1}"
    global CapsLockFix := true
}

MouseForwardKeyClick(*) {
    Send "{XButton2}"
    global CapsLockFix := true
}

MouseWheelUp(*) {
    Send "{WheelUp}"
    global CapsLockFix := true
}

MouseWheelDown(*) {
    Send "{WheelDown}"
    global CapsLockFix := true
}

; ---------- 重置鼠标按键状态（防止卡键） ----------
ResetMouseState(*) {
    global MouseButtonState
    if MouseButtonState["LeftMouseClickKeyState"] {
        Click "Up Left"
        MouseButtonState["LeftMouseClickKeyState"] := false
    }
    if MouseButtonState["RightMouseClickKeyState"] {
        Click "Up Right"
        MouseButtonState["RightMouseClickKeyState"] := false
    }
    if MouseButtonState["MiddleMouseClickKeyState"] {
        Click "Up Middle"
        MouseButtonState["MiddleMouseClickKeyState"] := false
    }
}

