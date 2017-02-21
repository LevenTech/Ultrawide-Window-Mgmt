#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Left = -8
Top = 0

Col1Width = 1150
Left2ColWidth = 2305

Col2Width = 1170

Right2ColWidth = 2282
Col3Width = 1170

LeftHalfWidth = 1736
RightHalfWidth = 1736
RightHalfStart = 1712
EndOfCol1 = 1127

FullHeight = 1400
StandardHeight = 1200
StandardWidth = 2200

HalfHeight = 705
TopOfBottomHalf = 697

StandardLeft = 620
StandardTop = 100
HalfStandardWidth = 1109

^NumPadLeft::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %Left%,%Top%,%Col1Width%,%FullHeight%
	Return

^!NumPadLeft::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %Left%,%Top%,%LeftHalfWidth%,%FullHeight%
	Return

!NumPadLeft::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %Left%,%Top%,%Left2ColWidth%,%FullHeight%
	Return

#NumPadUp::
^NumPadUp::
^!NumPadUp::
!NumPadUp::
^#NumPadUp::
	SendLevel 1
	Send !{ESC}
	Return
	
#NumPadClear::
^NumPadClear::
#^NumPadClear::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %EndOfCol1%,%Top%,%Col2Width%,%FullHeight%
	Return

!NumPadRight::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %Right2ColWidth%,%Top%,%Col3Width%,%FullHeight%
	Return

^!NumPadRight::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %RightHalfStart%,%Top%,%RightHalfWidth%,%FullHeight%
	Return

^NumPadRight::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %EndOfCol1%,%Top%,%Right2ColWidth%,%FullHeight%
	Return



NumPadIns::
^!Space::
^Space::
#Space::
!Space::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %StandardLeft%,%StandardTop%,%StandardWidth%,%StandardHeight%
	Return

#NumPadLeft::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %StandardLeft%,%StandardTop%,%HalfStandardWidth%,%StandardHeight%
	Return

#NumPadRight::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %RightHalfStart%,%StandardTop%,%HalfStandardWidth%,%StandardHeight%
	Return



#NumPadEnd::
^NumPadEnd::
^#NumPadEnd::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %Left%,%TopOfBottomHalf%,%LeftHalfWidth%,%HalfHeight%
	Return

#NumPadPgDn::
^NumPadPgDn::
^#NumPadPgDn::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %RightHalfStart%,%TopOfBottomHalf%,%RightHalfWidth%,%HalfHeight%
	Return

#NumPadHome::
^NumPadHome::
^#NumPadHome::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %Left%,%Top%,%LeftHalfWidth%,%HalfHeight%
	Return

#NumPadPgUp::
^NumPadPgUp::
^#NumPadPgUp::
	WinGetTitle, Title, A
	WinRestore, %Title%
	WinMove, %Title% ,, %RightHalfStart%,%Top%,%RightHalfWidth%,%HalfHeight%
	Return


NumpadRight::
	Send, ^#{Right}
	Return

NumpadClear::
	Send, #{Tab}
	Return
	
NumpadLeft::
	Send, ^#{Left}
	Return

NumPadUp::
    global CurrentDesktop, DesktopCount
    mapDesktopsFromRegistry()
	switchDesktopByNumber(DesktopCount)
	Return

NumPadDown::
#^1::
#^NumPad1::
	switchDesktopByNumber(1)
	Return

#^2::
#^NumPad2::
	switchDesktopByNumber(2)
	Return

#^3::
#^NumPad3::
	switchDesktopByNumber(3)
	Return

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
