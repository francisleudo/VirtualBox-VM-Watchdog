Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

' Descobre a pasta exata onde este arquivo VBS está rodando
PastaAtual = FSO.GetParentFolderName(WScript.ScriptPosition)

' Monta o caminho do script do PowerShell na mesma pasta
CaminhoPS = PastaAtual & "\vbox-vm-watchdog.ps1"

' Executa o PowerShell em segundo plano (totalmente oculto)
WshShell.Run "powershell.exe -ExecutionPolicy Bypass -File """ & CaminhoPS & """", 0, False