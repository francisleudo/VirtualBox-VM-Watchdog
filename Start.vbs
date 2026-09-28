Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Descobre a pasta exata onde este arquivo VBS está
PastaAtual = FSO.GetParentFolderName(WScript.ScriptFullName)

' Caminho do script PowerShell na mesma pasta
CaminhoPS = PastaAtual & "\vbox-vm-watchdog.ps1"

' Executa o PowerShell oculto
WshShell.Run "powershell.exe -ExecutionPolicy Bypass -File """ & CaminhoPS & """", 0, False
