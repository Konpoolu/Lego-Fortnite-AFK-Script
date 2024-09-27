#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent  ; Keeps the script running permanently
#SingleInstance, Force  ; Ensures only one instance of the script is running

; Toggle variable
toggle := false

; Array of movement keys
movementKeys := ["w", "a", "s", "d"]

; Hotkey to toggle the script (Ctrl+Shift+M)
^+m::
    toggle := !toggle
    if (toggle) {
        SetTimer, PressRandomKey, 599000
        ShowToolTip("Script is ON")
    } else {
        SetTimer, PressRandomKey, Off
        Send, {w up}{a up}{s up}{d up}  ; Release all movement keys
        ShowToolTip("Script is OFF")
    }
return

PressRandomKey:
    if (toggle) {
        ; Pick a random movement key
        Random, index, 1, % movementKeys.Length()
        key := movementKeys[index]
        
        ; Press and hold the key for 1 second
        Send, {%key% down}
        Sleep, 10000
        Send, {%key% up}
    }
return

; Function to show tooltip and set a timer to remove it
ShowToolTip(text) {
    ToolTip, %text%
    SetTimer, RemoveToolTip, -3000  ; Remove tooltip after 3 seconds
}

; Remove tooltip
RemoveToolTip:
    ToolTip
return

; Exit routine
OnExit, ExitSub
return

ExitSub:
    SetTimer, PressRandomKey, Off
    Send, {w up}{a up}{s up}{d up}  ; Release all movement keys
    SetTimer, RemoveToolTip, Off
    ToolTip  ; Try to remove tooltip
    Sleep, 100  ; Wait a bit
    ToolTip  ; Try again to remove tooltip
    FileAppend, Script exited at %A_Now%`n, %A_ScriptDir%\script_log.txt
ExitApp