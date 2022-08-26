if (!A_IsAdmin)
	Run *RunAs %A_ScriptFullPath%
FileEncoding UTF-8-RAW
OnExit("ExitFunc")

Menu Tray,NoStandard
Menu Tray,Add,Record
Menu Tray,Add,Exit

Gui New,HwndRecordUI +AlwaysOnTop +Resize
Gui Font,s12,Microsoft YaHei UI
Gui Add,Edit,w350 R10 vRecord


SetTimer FileUpdate,3600000 ;Edit your aoto save interval

RecordFileName:=A_Year "-" A_Mon "-" A_MDay ".txt" ;Record group by date
if !FileExist(RecordFileName)
{
    LastRecordFileName:=Format("{}{2:02}{}",A_Year "-" A_Mon "-",A_MDay-1,".txt")
    FileRead LastRecordFile,%LastRecordFileName%
    if (!LastRecordFile)
        FileDelete %LastRecordFileName%
    FileAppend,,%RecordFileName%
}
else
{
    FileRead RecordFile,%RecordFileName% ;Read today's record
    GuiControl,%RecordUI%:,Record,%RecordFile%
}
return

FileUpdate:
Gui %RecordUI%:Submit,NoHide
RecordFileName:=A_Year "-" A_Mon "-" A_MDay ".txt"
if !FileExist(RecordFileName)
{
    LastRecordFileName:=Format("{}{2:02}{}",A_Year "-" A_Mon "-",A_MDay-1,".txt")
    FileRead LastRecordFile,%LastRecordFileName%
    if (!LastRecordFile)
        FileDelete %LastRecordFileName%
    FileAppend,,%RecordFileName%
}
else
{
    FileRead RecordFile,%RecordFileName%
    if (RecordFile!=Record)
    {
        FileDelete %RecordFileName%
        FileAppend %Record%,%RecordFileName%
    }
}
return


#NoEnv
#SingleInstance Force

GuiClose:
	Gui Hide
return

GuiSize:
	if (A_EventInfo==1)
		return
	GuiControl Move,Record,% "w" A_GuiWidth-30 "h" A_GuiHeight-18
return

Record:
	Gui %RecordUI%:Show,,Record
return


RecordSave:
Gui %RecordUI%:Submit,NoHide
RecordFileName:=A_Year "-" A_Mon "-" A_MDay ".txt"
FileRead RecordFile,%RecordFileName%
if (Record && Record!=RecordFile)
    FileAppend %Record%,%A_Now%.txt
return


Exit:
	ExitApp
    
ExitFunc()
{
    gosub RecordSave
}

#IfWinActive Record ahk_exe AutoHotkey.exe
^s::goto RecordSave ;Manual save