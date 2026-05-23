#Requires AutoHotkey >=v2.0-
#SingleInstance Force

; github.com\DXSECN\DXS-AHK
; ---------------------------------------------------------------------
; # 外部依赖
; ---------------------------------------------------------------------
; # 自定义依赖
#UseHook
global Loader := true
#include ..\Core\CapsCore.ah2 ; # CapsLock 大小写切换检测
; ---------------------------------------------------------------------
; # 基本功能
CapsLock & F5::Reload() ; CapsLock + F5 重载脚本
CapsLock & F1::Help     ; CapsLock + F1 帮助信息
; ---------------------------------------------------------------------
; # 基础功能组件
#Include CapsBaseKey.ah2 ; # 基础按键映射
#include CapsCV.ah2 ; # Capslock 独立剪贴板
#include KeyToMouse.ah2 ; # 键盘模拟鼠标
#Include CapsClick.ah2 ; # Capslock 鼠标连点
; ---------------------------------------------------------------------
; # 自定义功能加载
#include ..\Core\FunctionCore.ah2 ; # 自定义函数功能核心
CapsLock & T::CapsTody() ; CapsLock + T 显示当前时间
; ---------------------------------------------------------------------
; # 其他功能组件
; # 窗口托盘化
#include ..\Modules\TrayedWindow.ah2
CapsLock & N::TrayedWindow() ; CapsLock + N 最小化窗口到托盘
; ---------------------------------------------------------------------