#Requires AutoHotkey >=v2.0-
#SingleInstance Force
; ============================
;    CapsLock++ 自定义版本
; ============================
; github.com/DXSECN/YH-AHK
; ---------------------------------------------------------------------
; # CapsLockPlus2 基础
global Loader := true
#include default/CapsCore.ahk
CapsLock::CapsLockPlusCore()        ; 单独按下 CapsLock 时切换大小写
; ---------------------------------------------------------------------
; # 基础按键映射
#Include default/CapsBaseKey.ahk
#HotIf GetKeyState("CapsLock", "P")
LAlt & WheelUp::Volume_Up               ; LAlt + 滚轮上 -> 音量加
LAlt & WheelDown::Volume_Down           ; LAlt + 滚轮下 -> 音量减
#HotIf 
; ---------------------------------------------------------------------
; # 脚本基本功能定义  
CapsLock & F5::Reload() ; CapsLock + F5 重载脚本
CapsLock & F1::Help     ; CapsLock + F1 帮助信息
; ---------------------------------------------------------------------
; # Capslock 独立剪贴板
#include default/CapsCV.ahk
; ---------------------------------------------------------------------
; # 模拟鼠标
; ## 可调整参数
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
; ## 键位定义
FunctionKey := "CapsLock"
SwitchDPIKey := "LAlt"
UpKey := "I"
DownKey := "K"
LeftKey := "J"
RightKey := "L"
LeftMouseClickKey := "Space"
RightMouseClickKey := "A"
MiddleMouseClickKey := "E"
MouseWheelKey := "F"
MouseBackKey := "O"
MouseForwardKey := "U"
; ## 功能加载
#include default/CapsKeyToMouse.ahk
; ---------------------------------------------------------------------

; ============================
;        其他自定义插件
; ============================

; ---------------------------------------------------------------------
; # 窗口托盘化
;#include plugin/TrayedWindow_v1.ahk
;CapsLock & D::TrayedWindow()      ; CapsLock + N 最小化窗口到托盘
; ---------------------------------------------------------------------