#Requires AutoHotkey v2.0

; ==================== 配置区域 ====================
; 保留的小数位数（整数，0 或正整数）
; 例如：2 表示四舍五入保留两位小数，4 表示保留四位小数
; 设置为 0 表示只保留整数（四舍五入）
global g_DecimalPlaces := 5
CapsLock & F3::CapsCaculator()
; =================================================

; 主函数：计算选中算式，并在其后输出 “=计算结果”
CapsCaculator() {
    ; 保存当前剪贴板内容
    ClipSaved := ClipboardAll()
    A_Clipboard := ""

    ; 复制选中的文本
    Send "^c"
    if !ClipWait(1) {
        A_Clipboard := ClipSaved
        return
    }

    expression := A_Clipboard
    A_Clipboard := ClipSaved

    if (expression = "") {
        return
    }

    ; 计算表达式的值
    result := Eval(expression)

    ; 计算出错时退出
    if (result = "") {
        return
    }

    ; 按配置保留小数位数（四舍五入）
    if (Type(result) = "Float" || Type(result) = "Integer") {
        result := Round(result, g_DecimalPlaces)
    }

    ; 用原算式和结果替换选中区域
    SendInput("{Text}" expression "=" result)
}

; 安全的算式求值函数（基于 JavaScript 引擎）
Eval(expr) {
    ; 允许的字符：数字、小数点、加减乘除、取余、括号、空格、指数符号
    if !RegExMatch(expr, "^[\d\s\.\+\-\*\/\%\(\)\^]+$") {
        return ""
    }

    ; 替换指数符号 ^ 为 JavaScript 的 ** 运算符
    expr := StrReplace(expr, "^", "**")

    try {
        html := ComObject("HTMLFile")
        html.write("<meta http-equiv='X-UA-Compatible' content='IE=Edge'><script>")
        result := html.parentWindow.eval(expr)

        if (result = "" || Type(result) != "Float" && Type(result) != "Integer") {
            return ""
        }
        return result
    } catch {
        return ""
    }
}