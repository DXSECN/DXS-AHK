#Requires AutoHotkey v2.0
#SingleInstance Force

; 今日日期
CapsTody(){
    ; 获取当前日期和时间
    currentDateTime := DateAdd(A_Now, 0, "days")
    
    ; 格式化日期为 YYYY/M/D 格式（例如 2026/4/14）
    ; FormatTime 的 Y 参数返回四位年份，M 返回月份（无前导零），D 返回日期（无前导零）
    formattedDate := FormatTime(currentDateTime, "yyyy/M/d")
    
    ; 将格式化后的日期发送到活动窗口
    SendText(formattedDate)
}


