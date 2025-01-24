#Requires AutoHotkey >=v2.0-a

;=============调用示例==============
;CapsLock & c::CapsLockC()
;CapsLock & x::CapsLockX()
;CapsLock & v::CapsLockV()
;===================================

; ## 独立剪贴板变量
IndependentClipboard := ""

; CapsLock + C 复制到独立剪贴板
CapsLockC(){
    global IndependentClipboard
    ; 保存当前系统剪贴板内容
    SavedClipboard := A_Clipboard
    A_Clipboard := "" ; 清空系统剪贴板
    Send("^c") ; 发送 Ctrl+C 复制
    if ClipWait(1) ; 等待剪贴板内容更新
    {
        IndependentClipboard := A_Clipboard ; 将内容保存到独立剪贴板
        ToolTip("已复制到独立剪贴板") ; 显示提示
        Sleep(1000) ; 显示提示 1 秒
        ToolTip() ; 清除提示
    }
    ; 恢复系统剪贴板内容
    A_Clipboard := SavedClipboard
    return
}

; CapsLock + X 剪切到独立剪贴板
CapsLockX(){
    global IndependentClipboard
    ; 保存当前系统剪贴板内容
    SavedClipboard := A_Clipboard
    A_Clipboard := "" ; 清空系统剪贴板
    Send("^x") ; 发送 Ctrl+X 剪切
    if ClipWait(1) ; 等待剪贴板内容更新
    {
        IndependentClipboard := A_Clipboard ; 将内容保存到独立剪贴板
        ToolTip("已剪切到独立剪贴板") ; 显示提示
        Sleep(1000) ; 显示提示 1 秒
        ToolTip() ; 清除提示
    }
    ; 恢复系统剪贴板内容
    A_Clipboard := SavedClipboard
    return
}

; CapsLock + V 从独立剪贴板粘贴
CapsLockV(){
    global IndependentClipboard
    if (IndependentClipboard != "") ; 如果独立剪贴板有内容
    {
        ; 保存当前系统剪贴板内容
        SavedClipboard := A_Clipboard
        A_Clipboard := IndependentClipboard ; 将独立剪贴板内容复制到系统剪贴板
        Send("^v") ; 发送 Ctrl+V 粘贴
        ; 恢复系统剪贴板内容
        A_Clipboard := SavedClipboard
    }
    else
    {
        ToolTip("独立剪贴板为空") ; 显示提示
        Sleep(1000) ; 显示提示 1 秒
        ToolTip() ; 清除提示
    }
    return
}