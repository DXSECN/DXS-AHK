#Requires AutoHotkey v2.0
#SingleInstance Force

global custom_clip := ""  ; 独立剪贴板容器
global CapsLockState := false

; CapsLock + C：复制到独立剪贴板
CapsLock & c:: {
    global custom_clip
    try {
        original_clip := ClipboardAll()   ; 保存系统剪贴板
        A_Clipboard := ""                  ; 清空剪贴板用于检测
        Send "^c"                          ; 发送复制命令
        if ClipWait(0.7)                   ; 等待内容复制
            custom_clip := A_Clipboard     ; 保存到独立剪贴板
    } finally {
        ToolTip "已复制到独立剪贴板"
        SetTimer () => ToolTip(), -1000
        A_Clipboard := original_clip       ; 恢复系统剪贴板
    }
}

; CapsLock + X：剪切到独立剪贴板
CapsLock & x:: {
    global custom_clip
    try {
        original_clip := ClipboardAll()
        A_Clipboard := ""
        Send "^x"                          ; 发送剪切命令
        if ClipWait(0.7)
            custom_clip := A_Clipboard
    } finally {
        ToolTip "已剪切到独立剪贴板"
        SetTimer () => ToolTip(), -1000
        A_Clipboard := original_clip
    }
}

; CapsLock + V：从独立剪贴板粘贴
CapsLock & v:: {
    global custom_clip
    if  custom_clip == ""   {
        ToolTip "独立剪贴板为空"
        SetTimer () => ToolTip(), -1000
        return
    }
    try {
        original_clip := ClipboardAll()
        A_Clipboard := custom_clip        ; 临时使用系统剪贴板
        if ClipWait(0.5)                  ; 确保内容加载
            Send "^v"                     ; 发送粘贴命令
    } finally {
        ToolTip "已粘贴"
        SetTimer () => ToolTip(), -1000
        A_Clipboard := original_clip      ; 恢复系统剪贴板
    }
}