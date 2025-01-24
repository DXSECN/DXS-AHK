#Requires AutoHotkey >=v2.0-a

;=============调用示例==============
;CapsLock & d::TrayedWindow()
;===================================

; ## 隐藏窗口到系统托盘
; 存储最小化窗口信息的数组
global minimizedWindows := Map()
global iconIndex := 1

; 创建主托盘菜单
mainTrayMenu := A_TrayMenu
mainTrayMenu.Add()  ; 添加分隔符
mainTrayMenu.Add("无托盘", (*) => {})
mainTrayMenu.Disable("无托盘")

TrayedWindow(){
    ; 获取活动窗口
    activeWin := WinExist("A")
    if !activeWin
        return

    ; 获取窗口标题和进程名
    title := WinGetTitle(activeWin)
    processName := WinGetProcessName(activeWin)
    
    if !title || !processName
        return

    ; 最小化并隐藏窗口（在添加到托盘之前）
    WinHide(activeWin)
    WinSetStyle("-0x10000000", activeWin)  ; 移除 WS_VISIBLE
    WinSetStyle("-0x00C00000", activeWin)  ; 移除标题栏和边框
    
    ; 添加到最小化窗口列表
    AddMinimizedWindow(title, processName, activeWin)
}

; 添加最小化窗口
AddMinimizedWindow(title, process, hwnd) {
    global iconIndex, minimizedWindows
    
    ; 如果是第一个托盘程序，删除"无托盘"提示
    if (minimizedWindows.Count = 0) {
        mainTrayMenu.Delete("无托盘")
    }
    
    ; 生成唯一的菜单标题
    menuTitle := title
    suffix := 1
    while HasMenuTitle(menuTitle) {
        suffix++
        menuTitle := title " (" suffix ")"
    }
    
    ; 保存窗口信息
    minimizedWindows[iconIndex] := {
        hwnd: hwnd,
        title: menuTitle,
        originalTitle: title,
        process: process
    }
    
    ; 添加菜单项到末尾
    mainTrayMenu.Add(menuTitle, RestoreWindow.Bind(iconIndex))
    
    ; 尝试设置图标
    try {
        processPath := WinGetProcessPath(hwnd)
        if processPath
            TraySetIcon(processPath)
    }
    
    iconIndex++
    
    UpdateRestoreAllMenu()
}

; 检查菜单标题是否已存在
HasMenuTitle(title) {
    global minimizedWindows
    for _, info in minimizedWindows {
        if (info.title = title)
            return true
    }
    return false
}

; 更新"还原全部窗口"菜单
UpdateRestoreAllMenu() {
    global minimizedWindows
    
    ; 处理"还原全部窗口"选项
    try mainTrayMenu.Delete("还原全部窗口")
    
    ; 重新整理菜单顺序
    if (minimizedWindows.Count >= 2) {
        ; 保存现有窗口项
        menuItems := []
        for _, info in minimizedWindows {
            menuItems.Push({
                title: info.title,
                handler: RestoreWindow.Bind(A_Index)
            })
            mainTrayMenu.Delete(info.title)
        }
        
        ; 添加"还原全部窗口"选项
        mainTrayMenu.Add("还原全部窗口", RestoreAllWindows)
        
        ; 重新添加窗口项
        for item in menuItems {
            mainTrayMenu.Add(item.title, item.handler)
        }
    }
    
    ; 如果没有托盘程序了，显示"无托盘"提示
    if (minimizedWindows.Count = 0) {
        mainTrayMenu.Add("无托盘", (*) => {})
        mainTrayMenu.Disable("无托盘")
    }
}

; 还原所有窗口
RestoreAllWindows(*) {
    ; 创建索引列表的副本，因为还原过程中会修改 minimizedWindows
    indices := []
    for index, _ in minimizedWindows
        indices.Push(index)
    
    ; 还原所有窗口
    for index in indices
        RestoreWindow(index)
}

; 还原窗口函数
RestoreWindow(index, *) {
    global minimizedWindows
    if minimizedWindows.Has(index) {
        winInfo := minimizedWindows[index]
        
        ; 恢复窗口样式
        WinSetStyle("+0x10000000", winInfo.hwnd)  ; 恢复 WS_VISIBLE
        WinSetStyle("+0x00C00000", winInfo.hwnd)  ; 恢复标题栏和边框
        
        ; 显示并激活窗口
        WinShow(winInfo.hwnd)
        WinActivate(winInfo.hwnd)
        
        ; 从菜单中移除
        mainTrayMenu.Delete(winInfo.title)
        
        ; 从列表中移除
        minimizedWindows.Delete(index)
        
        UpdateRestoreAllMenu()
    }
}

; 退出前确认
OnExit(ExitHandler)

ExitHandler(ExitReason, ExitCode) {
    global minimizedWindows
    
    if (minimizedWindows.Count > 0) {
        try {
            result := MsgBox(
                "是否还原托盘中的 " minimizedWindows.Count " 个窗口？`n`n点击“是”将还原所有窗口`n点击“否”将关闭所有窗口`n十秒后将自动关闭所有窗口",
                "退出确认",
                "4 48 T10"  ; 4 = Yes/No buttons, 48 = Question Icon, T10 = 10秒超时
            )
            
            if (result = "Yes") {
                ; 还原所有窗口
                RestoreAllWindows()
            } else {  ; "No" 或 "Timeout"
                ; 关闭所有窗口
                for _, winInfo in minimizedWindows {
                    WinClose(winInfo.hwnd)
                }
            }
        }
    }
}
; 