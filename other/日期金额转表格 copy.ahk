#Requires AutoHotkey v2.0
#SingleInstance Force

; 热键：Ctrl+Alt+Q 触发转换
^!q::
{
    ; 保存当前剪贴板内容
    originalClipboard := ClipboardAll()
    
    ; 发送Ctrl+C复制选中的文本
    Send("^c")
    Sleep(100)  ; 等待复制完成
    
    ; 获取剪贴板内容
    inputText := A_Clipboard
    
    if (inputText = "") {
        MsgBox("请先选择要转换的租金文本", "错误", 0x10)
        return
    }
    
    ; 处理文本转换
    result := ConvertRentText(inputText)
    
    if (result = "") {
        MsgBox("未找到有效的租金信息，请检查文本格式", "错误", 0x10)
        return
    }
    
    ; 将结果放回剪贴板
    A_Clipboard := result
    
    ; 提示用户
    MsgBox("转换完成！结果已复制到剪贴板，请粘贴到WPS Excel中。", "完成", 0x40)
    
    ; 恢复原始剪贴板内容（如果需要）
    ; Clipboard := originalClipboard
}

; 转换租金文本的函数（只保留日期）
ConvertRentText(inputText) {
    result := ""
    
    ; 使用正则表达式匹配租金信息
    ; 匹配模式：期数 + 开始日期 + 结束日期
    pattern := "第\S+?租金：(\d{4})年(\d{1,2})月(\d{1,2})日.*?至\s*(\d{4})年(\d{1,2})月(\d{1,2})日"
    
    ; 查找所有匹配项
    foundPos := 1
    while (foundPos := RegExMatch(inputText, pattern, &match, foundPos)) {
        ; 提取日期组件
        startYear := match[1]
        startMonth := Format("{:02}", match[2])  ; 格式化为两位数
        startDay := Format("{:02}", match[3])
        
        endYear := match[4]
        endMonth := Format("{:02}", match[5])
        endDay := Format("{:02}", match[6])
        
        ; 构建表格行（只包含日期）
        startDate := startYear "/" startMonth "/" startDay
        endDate := endYear "/" endMonth "/" endDay
        
        ; 添加到结果
        result .= startDate "`t" endDate "`n"
        
        ; 移动到下一个匹配位置
        foundPos += match.Len[0]
    }
    
    ; 移除最后的换行符
    if (result != "") {
        result := RTrim(result, "`n")
    }
    
    return result
}

; 备用热键：Ctrl+Shift+Q 用于直接处理剪贴板内容
^+q::
{
    inputText := A_Clipboard
    
    if (inputText = "") {
        MsgBox("剪贴板为空", "错误", 0x10)
        return
    }
    
    result := ConvertRentText(inputText)
    
    if (result = "") {
        MsgBox("未找到有效的租金信息", "错误", 0x10)
        return
    }
    
    A_Clipboard := result
    MsgBox("转换完成！结果已复制到剪贴板。", "完成", 0x40)
}

; 显示帮助信息
^!h::
{
    helpText := 
    (
    "租金文本转换工具使用方法：
    
    方法1（推荐）：
    1. 选中包含租金信息的文本
    2. 按下 Ctrl+Alt+Q
    3. 结果会自动复制到剪贴板
    4. 在WPS Excel中粘贴即可
    
    方法2：
    1. 复制租金文本到剪贴板
    2. 按下 Ctrl+Shift+Q
    3. 在WPS Excel中粘贴结果
    
    支持的文本格式示例：
    第一期租金：2025年10月01日至2025年12月31日，当期租金人民币：23,652.00元；
    第二期租金：2026年01月01日至2026年03月31日，当期租金人民币：23652.00元；
    
    转换结果（只包含日期）：
    2025/10/01    2025/12/31
    2026/01/01    2026/03/31
    "
    )
    MsgBox(helpText, "使用说明", 0x40)
}