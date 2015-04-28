#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ColorConstants.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Array.au3>

Dim $SongFile
Global $StopSend = 0

HotKeySet("{PAUSE}", "_SongStop")

_GetHandle()

Opt("GUICoordMode", 2)
Opt("GUIResizeMode", 1)
Opt("GUIOnEventMode", 1)

GUICreate("GW2 Songmaster", 300, 200, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
GUISetBkColor (0xffffff)

GUISetOnEvent($GUI_EVENT_CLOSE, "_CloseSongmaster")
;$idLabel = GUICtrlCreateLabel("", 0, 0, 300, 10)

GUICtrlCreateButton("Play", 10, 10, 50)
GUICtrlSetOnEvent(-1, "_SongPlay")

$Button_Stop = GUICtrlCreateButton("Stop", 5, -1)
GUICtrlSetOnEvent($Button_Stop, "_SongStop")

GUICtrlCreateButton("Add Song", 5, -1, 70)
GUICtrlSetOnEvent(-1, "_SongAdd")

GUICtrlCreateButton("Clear List", 5, -1, 70)
GUICtrlSetOnEvent(-1, "_ClearList")

GUISetCoord(10,40)
Global $Playlist = GuiCtrlCreateList("", -1, -1, 280, 150)


GUISetState()

; Intercept Windows command messages with out own handler
 GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND")

; Just idle around
While 1
  Sleep(10)
WEnd


;--------------------------------------FUNCTIONS START--------------------------------------------------------
;----------------CloseSongmaster
Func _CloseSongmaster()
   Exit
EndFunc

;----------------ClearList
Func _ClearList()
   GUICtrlSetData( $Playlist,"" )
   $SongFile = Null
EndFunc

;----------------SongAdd
Func _SongAdd()

   Global $SongFile = FileOpenDialog ( "Song auswaehlen", "", "Songdatei(*.txt)" )

   If not @error Then
	  $SongArr = StringRegExp( $SongFile, '[^\\/:*?"<>|\r\n]+(?=\.)', 1 )
	  GUICtrlSetData( $Playlist, $SongArr[0] )
   Endif

EndFunc

;----------------Handle
Func _GetHandle()
   Global $Handle = WinGetHandle( "Guild Wars 2" )
EndFunc

;----------------SongStop
Func _SongStop()
   $StopSend = 2
EndFunc


;----------------SongPlay
Func _SongPlay()

   ; Prüft ob GW2 überhaupt läuft
   if Not($Handle) Then
	  _GetHandle()
	  MsgBox( $MB_SYSTEMMODAL, "Fehler", "Guild Wars 2 nicht aktiv!", 10 )
	  Return False
  EndIf

  ; Prüft ob ein Song geladen ist
  if Not $SongFile Then
	 MsgBox( $MB_SYSTEMMODAL, "Kein Song geladen!", "Bitte einen Song auswählen!", 10 )
	 Return False
  EndIf

   ; Sicherstellen dass StopSend clean ist
   $StopSend = 0

   ; Hier spielt die Musik
   $SongContent = FileReadToArray( $SongFile )
   For $i = 0 To UBound( $SongContent ) - 1

	  ; Check StopSend
	  If $StopSend <> 0 Then
		 ; StopSend wurde gesetzt
		 Switch $StopSend
		 Case 1
			ConsoleWrite("!SongPlay wurde durch SongStop unterbrochen" & @CRLF)
		 Case 2
			ConsoleWrite("!SongPlay wurde durch Hotkey unterbrochen" & @CRLF)
		 EndSwitch
		 Return
	  EndIf

	  If StringRegExp( $SongContent[$i], "\bSleep?\b" ) Then
		 ; Pausen
		 Execute( $SongContent[$i] )
		 ConsoleWrite( "Pause: " & $SongContent[$i] & @CRLF )
	  ElseIf StringRegExp( $SongContent[$i], "{Numpad[0-9](}|\s(down|up)})" ) Then
		 ; Noten
		 ControlSend($Handle, "", "", $SongContent[$i])
		 ConsoleWrite( "Note: " & $SongContent[$i] & @CRLF )
	  Else
		 ; Bei Fehler in Songdatei anhalten
		 ConsoleWrite( "Error: " & $SongContent[$i] & @CRLF )
		 ExitLoop
	  EndIf

   Next

EndFunc

Func _WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
     ; Wenn der Stop Button gedrueckt wurde
     If BitAND($wParam, 0x0000FFFF) =  $Button_Stop Then $StopSend = 1
     Return $GUI_RUNDEFMSG
EndFunc
;--------------------------------------FUNCTIONS END-------------------------------------------------------- }