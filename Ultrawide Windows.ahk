#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;-----------------------------------|
;                                   |
; Ultrawide Windows by LevenTech    |
;                                   |
; Version 1.5 (9-21-17)             |
;                                   |
; Optional Add-Ons:                 |
;  - Files2Folder                   |
;-----------------------------------|




; TRAY ICON CONFIGURATION
;-------------------------
	Menu, Tray, Tip,Ultrawide Windows by LevenTech
	Menu, Tray, Icon, %A_ScriptDir%\Icons\Ultrawide` Windows.ico, 1, 0
	 
	Menu, Tray, NoStandard

	Menu, Tray, Add, Instructions, MyHelp
	Menu, Tray, Default, Instructions
	Menu, Tray, Add, Edit Script, EditScript
	Menu, Tray, Add


; SCREEN PIXEL CONFIGURATION
;----------------------------
	Left = -8
	Top = 0

	Col1Width = 1152
	Left2ColWidth = 2307

	Col2Width = 1172

	Right2ColWidth = 2322
	Col3Width = 1170

	LeftHalfWidth = 1736
	RightHalfWidth = 1736
	RightHalfStart = 1712
	EndOfCol1 = 1127
	BegOfCol3 = 2282

	FullHeight = 1400
	StandardHeight = 1200
	StandardWidth = 2200

	HalfHeight = 705
	TopOfBottomHalf = 697

	StandardLeft = 620
	StandardTop = 100
	HalfStandardWidth = 1109

	#Include %A_ScriptDir%\..\SeeThroughOrNot\
	#Include SeeThroughOrNot_addon.ahk

Return
;--------------------------------------------------------------------------
;-----------------     END OF INITIAL RUN       ---------------------------
;--------------------------------------------------------------------------


EditScript: 
	Run, notepad++.exe "%A_ScriptDir%\Ultrawide` Windows.ahk"
Return


; HELP TEXT
;-----------
MyHelp: 
	message = NumLock should be OFF

	message = %message%`n`n
	message = %message%`n  DESKTOP
	message = %message%`n -------------------------------------------
	message = %message%`n  "." (period): `t`tNext Desktop Background

	message = %message%`n`n
	message = %message%`n  BRIGHTNESS
	message = %message%`n -------------------------------------------
	message = %message%`n  Ctrl + Alt + "-" (minus): `tIncrease Brightness
	message = %message%`n  Ctrl + Alt + "+" (plus): `tReduce Brightness

	message = %message%`n`n
	message = %message%`n  VIRTUAL DESKTOPS
	message = %message%`n -------------------------------------------
	message = %message%`n  Numpad 4/Left: `t`tMove Left 1 Desktop
	message = %message%`n  Numpad 6/Right: `t`tMove Right 1 Desktop
	message = %message%`n  Numpad 2/Down: `t`tGo to First Desktop
	message = %message%`n  Numpad 8/Up: `t`tGo to Last Desktop
	message = %message%`n
	message = %message%`n  Ctrl + Windows + 1: `tGo to Desktop #1
	message = %message%`n  Ctrl + Windows + 2: `tGo to Desktop #2
	message = %message%`n  Ctrl + Windows + 3: `tGo to Desktop #3
	message = %message%`n  Ctrl + Windows + 4: `tGo to Desktop #4

	message = %message%`n`n
	message = %message%`n  WINDOW POSITION/SIZE
	message = %message%`n -------------------------------------------
	message = %message%`n  NumPad 0: `t`tRegular Widescreen, Centered
	message = %message%`n  NumPad /: `t`tMaximize/Restore Toggle
	message = %message%`n
	message = %message%`n  Windows + NumPad 7: `tTop Left Corner
	message = %message%`n  Windows + NumPad 9: `tTop Right Corner
	message = %message%`n  Windows + NumPad 1: `tBottom Left Corner
	message = %message%`n  Windows + NumPad 3: `tBottom Right Corner
	message = %message%`n
	message = %message%`n  Ctrl `t+ NumPad 4: `tLeft Third
	message = %message%`n  Alt `t+ NumPad 4: `tLeft Third Fill (Center and Right Thirds)
	message = %message%`n
	message = %message%`n  Ctrl `t+ NumPad 5: `tCenter Third
	message = %message%`n
	message = %message%`n  Ctrl `t+ NumPad 6: `tRight Third
	message = %message%`n  Alt `t+ NumPad 6: `tRight Third Fill (Left and Center Thirds)
	MsgBox, , Ultrawide Windows by LevenTech, %message%
Return

#IfWinActive ahk_class WorkerW
; Next Desktop Background
;---------------------------------
NumPadDel::
	Send, {AppsKey}
	Sleep 100
	Send, n
Return

NumPadDot::
	if (GetKeyState("NumLock", "T"))
	{
		MsgBox, 4, ,NumLock is ON. Turn it OFF and RETRY?, 3
		IfMsgBox, No
			Return
		IfMsgBox, Timeout
			Return
		SetNumLockState , Off
		Send, #d
		Sleep 100
		Send, {AppsKey}
		Sleep 100
		Send, n
	}
Return

#IfWinActive

; ACTUAL HOTKEYS AND ACTIONS
;----------------------------

NumPadDiv::
	if (GetKeyState("NumLock", "T"))
	{
		Send, /
		TrayTip "/" Pressed, Turn off NumLock to Maximize Windows, , 16
	} else
	{
		WinGetTitle, Title, A
		WinGetPos, X, Y, Width, Height, %Title%
		if (Width>3400 AND Height>1400)
		{
			WinRestore, %Title%
		} else
		{
			WinMaximize, %Title%
		}
	}
Return

; LEFT THIRD OF SCREEN
^NumPadLeft::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %Left%,%Top%,%Col1Width%,%FullHeight%
Return

; LEFT HALF OF SCREEN
LeftHalf:
^!NumPadLeft::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %Left%,%Top%,%LeftHalfWidth%,%FullHeight%
Return

; LEFT TWO-THIRDS OF SCREEN
!NumPadLeft::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %Left%,%Top%,%Left2ColWidth%,%FullHeight%
Return

; ALT-TAB FOR WINDOW SWITCHING
#NumPadUp::
^NumPadUp::
^!NumPadUp::
!NumPadUp::
^#NumPadUp::
	SendLevel 1
	Send !{ESC}
Return

; MIDDLE THIRD OF SCREEN	
#NumPadClear::
^NumPadClear::
#^NumPadClear::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %EndOfCol1%,%Top%,%Col2Width%,%FullHeight%
Return

; RIGHT THIRD OF SCREEN
!NumPadRight::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %BegOfCol3%,%Top%,%Col3Width%,%FullHeight%
Return

; RIGHT HALF OF SCREEN
^!NumPadRight::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %RightHalfStart%,%Top%,%RightHalfWidth%,%FullHeight%
Return

; RIGHT TWO THIRDS OF SCREEN
^NumPadRight::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %EndOfCol1%,%Top%,%Right2ColWidth%,%FullHeight%
Return


; CENTER
NumPadIns::
	if GetKeyState("Capslock","T") {
		WinGetTitle, Title, A
		WinRestore, %Title%
		WinMove, %Title% ,, %StandardLeft%,%StandardTop%,%StandardWidth%,%StandardHeight%
	}
Return

; LEFT-CENTER
#NumPadLeft::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %StandardLeft%,%StandardTop%,%HalfStandardWidth%,%StandardHeight%
Return

; RIGHT-CENTER
#NumPadRight::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %RightHalfStart%,%StandardTop%,%HalfStandardWidth%,%StandardHeight%
Return


; BOTTOM-LEFT CORNER
#NumPadEnd::
^NumPadEnd::
^#NumPadEnd::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %Left%,%TopOfBottomHalf%,%LeftHalfWidth%,%HalfHeight%
Return

; BOTTOM-RIGHT CORNER
#NumPadPgDn::
^NumPadPgDn::
^#NumPadPgDn::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %RightHalfStart%,%TopOfBottomHalf%,%RightHalfWidth%,%HalfHeight%
Return

; TOP-LEFT CORNER
#NumPadHome::
^NumPadHome::
^#NumPadHome::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %Left%,%Top%,%LeftHalfWidth%,%HalfHeight%
Return

; TOP-RIGHT CORNER
#NumPadPgUp::
^NumPadPgUp::
^#NumPadPgUp::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %RightHalfStart%,%Top%,%RightHalfWidth%,%HalfHeight%
Return

; MOVE 1 SCREEN RIGHT
NumpadRight::
	if GetKeyState("Capslock","T") {
		Send, ^#{Right}
	}
Return

; WIN-TAB (SHOW ALL DESKTOPS AND WINDOWS)
NumpadClear::
	if GetKeyState("Capslock","T") {
		Send, #{Tab}
	}
Return
	
; MOVE 1 SCREEN LEFT
NumpadLeft::
	if GetKeyState("Capslock","T") {
		Send, ^#{Left}
	}
Return

; GO TO LAST DESKTOP
NumPadUp::
	if GetKeyState("Capslock","T") {
		global CurrentDesktop, DesktopCount
		mapDesktopsFromRegistry()
		switchDesktopByNumber(DesktopCount)
	}
Return

; GO TO FIRST DESKTOP
NumPadDown::
#^1::
#^NumPad1::
	if GetKeyState("Capslock","T") {
		switchDesktopByNumber(1)
	}
Return

; GO TO DESKTOP 2
#^2::
#^NumPad2::
	switchDesktopByNumber(2)
Return

; GO TO DESKTOP 3
#^3::
#^NumPad3::
	switchDesktopByNumber(3)
Return

; GO TO DESKTOP 4
#^4::
#^NumPad4::
	switchDesktopByNumber(4)
Return



mapDesktopsFromRegistry() {
    global CurrentDesktop, DesktopCount

    ; Get the current desktop UUID. Length should be 32 always, but there's no guarantee this couldn't change in a later Windows release so we check.
    IdLength := 32
    SessionId := getSessionId()
    if (SessionId) {
        RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%SessionId%\VirtualDesktops, CurrentVirtualDesktop
        if (CurrentDesktopId) {
            IdLength := StrLen(CurrentDesktopId)
        }
    }

    ; Get a list of the UUIDs for all virtual desktops on the system
    RegRead, DesktopList, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
    if (DesktopList) {
        DesktopListLength := StrLen(DesktopList)
        ; Figure out how many virtual desktops there are
        DesktopCount := DesktopListLength / IdLength
    }
    else {
        DesktopCount := 1
    }

    ; Parse the REG_DATA string that stores the array of UUID's for virtual desktops in the registry.
    i := 0
    while (CurrentDesktopId and i < DesktopCount) {
        StartPos := (i * IdLength) + 1
        DesktopIter := SubStr(DesktopList, StartPos, IdLength)
        OutputDebug, The iterator is pointing at %DesktopIter% and count is %i%.

        ; Break out if we find a match in the list. If we didn't find anything, keep the
        ; old guess and pray we're still correct :-D.
        if (DesktopIter = CurrentDesktopId) {
            CurrentDesktop := i + 1
            OutputDebug, Current desktop number is %CurrentDesktop% with an ID of %DesktopIter%.
            break
        }
        i++
    }
}


getSessionId()
{
    ProcessId := DllCall("GetCurrentProcessId", "UInt")
    DllCall("ProcessIdToSessionId", "UInt", ProcessId, "UInt*", SessionId)
    return SessionId
}

switchDesktopByNumber(targetDesktop)
{
    global CurrentDesktop, DesktopCount
    mapDesktopsFromRegistry()
    while(CurrentDesktop < targetDesktop) {
        Send ^#{Right}
        CurrentDesktop++
	Sleep 100
    }
    while(CurrentDesktop > targetDesktop) {
        Send ^#{Left}
        CurrentDesktop--
	Sleep 100
    }
}
