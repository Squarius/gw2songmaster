;--------------------------------------FUNCTIONS START--------------------------------------------------------
Func SelectSong()
   Global $SongFile = FileOpenDialog ( "Song auswaehlen", "", "Songdatei(*.txt)" )

   If not @error Then
	  $SongArr = StringRegExp( $SongFile, '[^\\/:*?"<>|\r\n]+(?=\.)', 1 )
	  GUICtrlSetData( $Playlist, $SongArr[0] )
   Endif

EndFunc


Func GetHandle()
   Global $Handle = WinGetHandle( "Guild Wars 2" )
EndFunc


Func PlaySong()

   ; Prüft ob GW2 überhaupt läuft
   if Not($Handle) Then
	  GetHandle()
	  MsgBox($MB_SYSTEMMODAL, "Fehler", "Guild Wars 2 nicht aktiv!", 10)
	  Return False
  EndIf

  ; Prüft ob ein Song geladen ist
  if Not IsDeclared("SongFile") Then
	 MsgBox($MB_SYSTEMMODAL, "Kein Song geladen!", "Bitte einen Song auswählen!", 10)
	 Return False
   EndIf

   ; Hier spielt die Musik
   $SongContent = FileReadToArray($SongFile)
   For $i = 0 To UBound($SongContent) - 1
	  If StringRegExp($SongContent[$i], "\bSleep?\b") Then
		 ; Pausen
		 Execute($SongContent[$i])
	  Else
		 ; Noten
		 ;{Numpad[0-9]?(\s(down|up))
		 ConsoleWrite($SongContent[$i] & @CRLF)
	  EndIf
   Next

EndFunc
;--------------------------------------FUNCTIONS END-------------------------------------------------------- }