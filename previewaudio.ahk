#SingleInstance Force
;previews sound files as you select them in explorer

oldSelection:=""
Loop {
	;first wait till explorer is the active window...
	WinWaitActive, ahk_class CabinetWClass 
	
	;next we get the explorer window's com object & 
	;find out what is selected...
	hwnd := WinExist("A")	
	for window in ComObjCreate("Shell.Application").Windows
		if (window.hwnd==hwnd){
			selected := window.document.SelectedItems
			selString := ""
			for item in selected {
				selString := item.path
				break ;we only care ahout the first file,
				;there has to be a better way of doing this...
				}
			if( selString != oldSelection) {
				oldSelection:=selString
				FileSize := 0 
				FileGetSize, FileSize, %selString% ; Retrieve the size in bytes.
				;now we have a new selection, send it to soundplay.
				;ideally we should check here if it's an audio file,
				;but soundplay fails silently, so who cares.
				;also: soundPlay works for most files on my system,
				;but not all. ex: mp3 & wav play but ogg doesn't
				;MsgBox %FileSize%
				if( FileSize < 1500000 ){
					SoundPlay, %selString%, wait
				}
			}
			
	lastInput:=A_TimeIdle
	Loop { ;wait for any input that could change the selected file
		Sleep, 25
		if( A_TimeIdle != lastInput)
			break
		}
	}
}