#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn All, MsgBox ; 保持严格警告，确保代码规范

; ==========================================
; 🔑 按键映射区 (Hotkey Bindings)
; ==========================================
global custom_clip := ""

CapsLock & c:: CustomCopy()
CapsLock & x:: CustomCut()
CapsLock & v:: SafePaste(custom_clip)

; ==========================================
; ⚙️ 核心功能区 (Core Functions)
; ==========================================

/**
 * 安全粘贴：API优先 + 剪贴板兜底，杜绝时序竞争导致的串数据
 */
SafePaste(content) {
    if !content {
        ShowTip("独立剪贴板为空")
        return
    }

    hwnd := ControlGetFocus("A")
    pasted := false

    ; 策略1：对标准编辑控件直接注入文本（零剪贴板交互）
    if hwnd && IsStandardEdit(hwnd) {
        try {
            SendMessage(0x00C2, 0, StrPtr(content), hwnd) ; EM_REPLACESEL
            pasted := true
        }
    }

    ; 策略2：非标准控件走系统剪贴板 + WM_PASTE 同步通知
    if !pasted {
        original_clip := ClipboardAll()
        try {
            A_Clipboard := content
            if !ClipWait(1)
                throw Error("ClipWait timeout")

            if hwnd
                SendMessage(0x0302, 0, 0, hwnd) ; WM_PASTE
            else
                Send "^v"
            
            pasted := true
        } catch as e {
            ShowTip("粘贴失败: " e.Message, 2000)
        } finally {
            if IsSet(original_clip) {
                Sleep 50
                A_Clipboard := original_clip
                original_clip := ""
            }
        }
    }

    if pasted
        ShowTip("已粘贴[独立]")
}

/**
 * 复制到独立剪贴板
 */
CustomCopy() {
    global custom_clip
    ClipToCustom("^c", "已复制[独立]")
}

/**
 * 剪切到独立剪贴板
 */
CustomCut() {
    global custom_clip
    ClipToCustom("^x", "已剪切[独立]")
}

/**
 * 底层剪贴板捕获封装（供复制/剪切复用）
 */
ClipToCustom(sendKey, successMsg) {
    global custom_clip
    original_clip := ClipboardAll()
    try {
        A_Clipboard := ""
        Send sendKey
        if ClipWait(0.8) {
            custom_clip := A_Clipboard
            ShowTip(successMsg, 1200)
        } else {
            ShowTip("操作超时，未捕获内容", 1200)
        }
    } finally {
        A_Clipboard := original_clip
        original_clip := ""
    }
}

/**
 * 判断是否为标准 Win32 编辑控件
 */
IsStandardEdit(hwnd) {
    className := ""
    try className := WinGetClass("ahk_id " hwnd)
    return RegExMatch(className, "i)^(Edit|RichEdit|Scintilla|ATL:Edit)$")
}

/**
 * 统一提示框封装，自动定时清除
 */
ShowTip(msg, duration := 1000) {
    ToolTip msg
    SetTimer () => ToolTip(), -duration
}

/**
 * 官方映射函数自带安全切换，无需重复实现，如有特殊需求自行开启
 * 安全切换 CapsLock 状态（兼容 v2 语法，无 ErrorLevel 警告）
 */
; ToggleCapsLock() {
;     if !KeyWait("CapsLock", "T0.2")
;         SetCapsLockState(!GetKeyState("CapsLock", "T"))
; }