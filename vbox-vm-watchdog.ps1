# ================= CONFIGURAÇÃO =================
$VM_NAME = "Home Assistant"
$VM_IP = "192.168.1.117"
$VBOX_PATH = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

# Proteção para descobrir a pasta atual em qualquer cenário do Windows
if ($PSScriptRoot) {
    $PASTA_ATUAL = $PSScriptRoot
} else {
    $PASTA_ATUAL = Split-Path -Parent $MyInvocation.MyCommand.Definition
    if (-not $PASTA_ATUAL) { $PASTA_ATUAL = $pwd }
}

$HTML_FILE = "$PASTA_ATUAL\dashboard.html"
$LOG_FILE  = "$PASTA_ATUAL\log.txt"
# ================================================

function Gerar-HTML($status) {
    $hora = Get-Date -Format "HH:mm:ss"
    
    switch ($status) {
        "ONLINE"    { $classe = "online"; $texto = "Disponível" }
        "OFFLINE"   { $classe = "offline"; $texto = "Indisponível" }
        "REBOOTING" { $classe = "rebooting"; $texto = "Reiniciando Sistema" }
    }

    # Estrutura HTML com meta tag de charset UTF-8
    $htmlContent = "<!DOCTYPE html><html lang='pt-BR'><head><meta charset='UTF-8'><meta http-equiv='refresh' content='5'><title>Painel HA</title><style>body { margin: 0; padding: 0; background-color: #0d0d11; font-family: 'Segoe UI', sans-serif; color: #f5f5f7; display: flex; justify-content: center; align-items: center; height: 100vh; } .card { background: rgba(22, 22, 26, 0.85); border: 1px solid rgba(255, 255, 255, 0.08); border-radius: 16px; padding: 30px; width: 280px; text-align: center; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5); } .logo { font-size: 11px; font-weight: 700; color: #8a8a8f; text-transform: uppercase; letter-spacing: 1.5px; } .status-box { display: flex; flex-direction: column; align-items: center; margin: 20px 0; } .led { width: 20px; height: 20px; border-radius: 50%; margin-bottom: 15px; } .online { background-color: #00ff66; box-shadow: 0 0 15px #00ff66; } .offline { background-color: #ff3b30; box-shadow: 0 0 15px #ff3b30; } .rebooting { background-color: #ffcc00; box-shadow: 0 0 15px #ffcc00; } .status-text { font-size: 20px; font-weight: 600; } .system-name { font-size: 14px; color: #8a8a8f; margin-top: 5px; } .divider { height: 1px; background: rgba(255, 255, 255, 0.08); margin: 15px 0; } .footer-time { font-size: 11px; color: #636366; }</style></head><body><div class='card'><div class='logo'>Monitoramento</div><div class='status-box'><div class='led " + $classe + "'></div><div class='status-text'>" + $texto + "</div><div class='system-name'>" + $VM_NAME + "</div></div><div class='divider'></div><div class='footer-time'>Última checagem: " + $hora + "</div></div></body></html>"

    # Salva forçando a codificação UTF-8 para corrigir a acentuação no navegador
    Set-Content -Path $HTML_FILE -Value $htmlContent -Force -Encoding utf8
}

function Registrar-Log($mensagem) {
    $dataHora = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $linhaLog = "[$dataHora] $mensagem"
    Add-Content -Path $LOG_FILE -Value $linhaLog
}

# Inicialização do Script
Clear-Host
Write-Host "Iniciando monitoramento da VM $VM_NAME..." -ForegroundColor Cyan
Registrar-Log "MÓDULO: Monitoramento iniciado para a VM $VM_NAME ($VM_IP)."

while ($true) {
    $pingTest = Test-Connection -ComputerName $VM_IP -Count 1 -Quiet

    if (-not $pingTest) {
        Write-Host "[$(Get-Date)] Falha de ping! Reiniciando VM..." -ForegroundColor Red
        Registrar-Log "ALERTA: VM fora do ar! Iniciando rotina de reboot."
        Gerar-HTML "REBOOTING"
        
        Start-Process $VBOX_PATH -ArgumentList "controlvm `"$VM_NAME`" poweroff" -NoNewWindow -Wait
        Start-Sleep -Seconds 3
        Start-Process $VBOX_PATH -ArgumentList "startvm `"$VM_NAME`" --type headless" -NoNewWindow -Wait
        
        Registrar-Log "INFO: Comandos de reboot enviados. Aguardando 120s para estabilização."
        Start-Sleep -Seconds 120
        Registrar-Log "INFO: Tempo de espera concluído. Retornando checagem padrão."
    } else {
        Write-Host "[$(Get-Date)] VM operando normalmente." -ForegroundColor Green
        Gerar-HTML "ONLINE"
    }

    Start-Sleep -Seconds 15
}