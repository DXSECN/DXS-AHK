#Requires AutoHotkey >=v2.0-
#SingleInstance Force

; github.com/DXSECN/DXS-AHK
; ---------------------------------------------------------------------
; # 基础依赖
global Loader := true
#include default/CapsCore.ahk
CapsLock::CapsLockPlusCore()        ; 单独按下 CapsLock 时切换大小写
; ---------------------------------------------------------------------
; # 基本功能
CapsLock & F5::Reload() ; CapsLock + F5 重载脚本
CapsLock & F1::Help     ; CapsLock + F1 帮助信息
; ---------------------------------------------------------------------
; # 基础按键映射
#Include default/CapsBaseKey.ahk
; ---------------------------------------------------------------------
; # Capslock 独立剪贴板
#include default/CapsCV.ahk
; ---------------------------------------------------------------------
; # 模拟鼠标
#include default/KeyToMouse.ahk
; ---------------------------------------------------------------------


; ============================
;        其他自定义插件
; ============================


; ---------------------------------------------------------------------
; # 窗口托盘化
#include plugin/TrayedWindow.ahk
CapsLock & N::TrayedWindow()      ; CapsLock + N 最小化窗口到托盘
; ---------------------------------------------------------------------