#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <ColorConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <GW2SMFunctions.au3>

GetHandle()

 ;--------------------------------------VARS--------------------------------------------------------
Dim $SongPath = @ScriptDir & "\Song.txt"
Global $isPlaying = False

;--------------------------------------VARS END--------------------------------------------------------

;--------------------------------------GUI START--------------------------------------------------------
Global $GUI = GUICreate("GW2 Songmaster", 300, 100, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
GUISetBkColor (0xffffff)
Global $idLabel = GUICtrlCreateLabel("", 0, 0, 300, 10)
Local $ButtonPlay = GUICtrlCreateButton("Play", 10, 10, 50, 30)
Local $ButtonStop = GUICtrlCreateButton("Stop", 65, 10, 50, 30)
Local $ButtonSelectSong = GUICtrlCreateButton("+ Select Song", 210, 10, 80, 30)
Local $Playlist = GuiCtrlCreateList("", 10, 45, 280, 50)

GUISetState (@SW_SHOW)
;---------------------------------------GUI END---------------------------------------------------------


;--------------------------------------START--------------------------------------------------------
While 1
  Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE
		  ExitLoop
	  Case $ButtonSelectSong
		; Add Song Function
		SelectSong()
	 Case $ButtonPlay
		; Play Song
		PlaySong()
  EndSwitch
Wend
;--------------------------------------END--------------------------------------------------------