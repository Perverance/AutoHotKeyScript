#SingleInstance

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initial setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetKeyDelay (0)
SetCapsLockState "AlwaysOff"
isSuspended := 0

#SuspendExempt

; Capslock+Esc turns on/off the script
CapsLock & Escape:: {
  CoordMode "ToolTip"

  global isSuspended := !isSuspended
  if (isSuspended) {
    Suspend
    SetCapsLockState "Off"
    ToolTip("`n Script OFF `n ", 960, 960)
    Sleep (800)
    ToolTip
  }
  else {
    Suspend
    SetCapsLockState "AlwaysOff"
    ToolTip("`n Script ON `n ", 960, 960)
    Sleep (800)
    ToolTip
  }
}
#SuspendExempt False


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Script related functionality
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CapsLock & F5:: Reload		; Capslock+F5 reloads the script
CapsLock & F6:: Edit			; Capslock+F6 opens the script in the default text editor configured by AutoHotkey

; Capslock+F7 opens the location of the current script file
; I have a copy of mine in the following folder so it auto starts with my system
; CapsLock & F7:: Run "C:\Users\{your_username}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
; Change {your_username} for your Windows user folder name and then uncomment the line

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CAPSLOCK KEY RELATED FUNCTIONALITY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; WASD as arrow keys
CapsLock & w::Up
CapsLock & a::Left
CapsLock & s::Down
CapsLock & d::Right

; Navigation
CapsLock & q::Home             ; 'Home' (useful for going to the start of a line or page)
CapsLock & e::End              ; 'End' (useful for going to the end of a line or page)
CapsLock & `::^Home            ; 'Ctrl+Home' (useful for going to the start of a page/document)
CapsLock & 4::^End             ; 'Ctrl+End' (useful for going to the end of a page/document)
CapsLock & 1::^PgUp            ; 'Ctrl+PgUp' (useful for changing tabs in many programs)
CapsLock & 3::^PgDn            ; 'Ctrl+PgDown' (useful for changing tabs in many programs)
CapsLock & z::PgUp             ; 'PgUp'
CapsLock & c::PgDn             ; 'PgDn'

; Content modification
CapsLock & r::Delete
CapsLock & Tab::Backspace
CapsLock & f::Enter            ; Super useful for confirming actions or opening files and folders

; Mouse buttons
CapsLock & v:: Click "Left"
CapsLock & b:: Click "Middle"
CapsLock & n:: Click "Right"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TEXT EXPANSIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; In my own script I have text expansions for common form fields, like full name, main email address...
; Something like these:
:*:;;ma::Marco
:*:;;po::Polo
:*:;;mp::Marco Polo

; This one inserts today's date
:*:;;td:: {
  Send (FormatTime(, "ShortDate"))
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; OTHERS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Space::^+F14           ; Alt+Space for selection expand (editor.action.smartSelect.expand) in VS Code (I can't assign it otherwise)
!Esc::Esc               ; It cancels the default Alt+Esc combination of Windows

; Opens Windows calculator (or focus it if already opened)
#c:: {
  if WinExist("Calculator")
    WinActivate ; Use the window found by WinExist.
  Else
    Run "C:\Windows\System32\calc.exe"
}


#f1::Media_Play_Pause   ; Win+F1 to play/pause multimedia
#f2::Media_Next         ; Win+F2 to play next multimedia

; In my laptop, Fn+F3 and Fn+F4 controls brightness, so I use the same analogy fow controlling volume, but with Win key instead of Fn
#f3::Volume_Down
#f4::Volume_Up


; Navigation in Windows explorer
#HotIf WinActive("ahk_exe explorer.exe")
CapsLock & 2::!Up       ; Alt+Up for going to parent folder
CapsLock & g::!Enter    ; Alt+Enter for opening properties panel

; Go to parent folder with '\' key (below the Enter key in my US keyboard)
\:: {
  Send "!{Up}"
}
#HotIf

; Navigation in Firefox
#HotIf WinActive("ahk_exe firefox.exe")
CapsLock & 2::!Left     ; Alt+Left for going backwards one page
#HotIf


; Do you happen to have a lot of PDF files that you want open to see what are about and close them quickly?
; I use it like this: Capslock+F in the explorer to open a PDF, Capslock+H to close it and go back to the explorer
CapsLock & h:: {
  ; If the current window is a PDF opened in Firefox, pressing Capslock+H sends Ctrl+W and Alt+Tab
  if WinActive(".pdf — Mozilla Firefox") {
    Send "^{w}"
    Send "!{Tab}"
  }
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONTROLS FOR FIREFOX PIP WINDOW
; These ones work if a PIP (picture-in-picture) window of Firefox is already opened
; Really useful for studying or transcribing, since you can quickly control the PIP content with the keyboard
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

msg := "Win+J:`tbackwards 10s`nWin+K:`tplay/pause`nWin+H:`tclose PIP"

; Win+K pauses/plays the current PIP window
#K:: {
  actualWindow := WinGetTitle("A")
  if WinExist("Picture-in-Picture ahk_exe firefox.exe") {
    WinActivate
    Send "{Space}"
    WinActivate(actualWindow)
  }
  else {
    MsgBox msg
  }
}

; Win+J rewinds 10 seconds
#J:: {
  actualWindow := WinGetTitle("A")
  if WinExist("Picture-in-Picture ahk_exe firefox.exe") {
    WinActivate
    Send "{Left}"
    Send "{Left}"
    WinActivate(actualWindow)
  }
  else {
    MsgBox msg
  }
}

; Win+H closes the PIP window
#H:: {
  actualWindow := WinGetTitle("A")
  if WinExist("Picture-in-Picture ahk_exe firefox.exe") {
    WinActivate
    Send "{Escape}"
    WinActivate(actualWindow)
  }
  else {
    MsgBox msg
  }
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NUMSLOCK INDICATOR
; A simple tooltip that shows the state of the Num Lock key
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

~*NumLock:: {
  Sleep (10)
  msg := ""
  msg := msg "`n" (GetKeyState("NumLock", "T") ? "  Numlock ON  " : "  Numlock OFF  ") "`n" " "
  CoordMode "ToolTip", "Screen"
  ToolTip msg, 960, 960
  Sleep (500)
  ToolTip
  return
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; RESTORE GROUP OF WINDOWS
; When I do webdev, I like to have VS Code and Firefox side by side in 3/4 ratio
; Win+` quickly restores both windows, so you can be anywhere and quickly return to your workspace!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#`::
{
  Sleep 120

  if WinExist("Firefox Developer Edition")
  {
    WinRestore
  }

  if WinExist("ahk_exe Code.exe")
  {
    WinRestore
    WinActivate
  }
}
