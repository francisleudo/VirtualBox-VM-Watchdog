# ============================================================
# VIRTUALBOX VM WATCHDOG
# ============================================================

$VM_NAME = "debian 12 server"
$VM_IP   = "192.168.1.3"

$VBOX = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

$PASTA_ATUAL = $PSScriptRoot

$HTML_FILE = Join-Path $PASTA_ATUAL "dashboard.html"
$LOG_FILE  = Join-Path $PASTA_ATUAL "log.txt"


# ============================================================
# FUNÃ‡ÃƒO DE LOG
# ============================================================

function Registrar-Log {
    param (
        [string]$Mensagem
    )

    $DataHora = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    Add-Content `
        -Path $LOG_FILE `
        -Value "[$DataHora] $Mensagem" `
        -Encoding UTF8
}


# ============================================================
# FUNÃ‡ÃƒO DO DASHBOARD
# ============================================================

function Gerar-Dashboard {

    param (
        [string]$Status
    )

    $Hora = Get-Date -Format "HH:mm:ss"


    # --------------------------------------------------------
    # DEFINIR STATUS
    # --------------------------------------------------------

    if ($Status -eq "ONLINE") {

        $Cor = "#00ff66"
        $TextoStatus = "Dispon&iacute;vel"

    }
    elseif ($Status -eq "REBOOTING") {

        $Cor = "#ffcc00"
        $TextoStatus = "Reiniciando Sistema"

    }
    else {

        $Cor = "#ff3b30"
        $TextoStatus = "Indispon&iacute;vel"

    }


    # --------------------------------------------------------
    # HTML
    # --------------------------------------------------------

    $ConteudoHTML = @(

        '<!DOCTYPE html>'

        '<html lang="pt-BR">'

        '<head>'

        '<meta charset="UTF-8">'

        '<meta name="viewport" content="width=device-width, initial-scale=1.0">'

        '<meta http-equiv="refresh" content="5">'

        '<title>VirtualBox Watchdog</title>'


        '<style>'

        '* {'
        '    box-sizing: border-box;'
        '}'

        'body {'
        '    margin: 0;'
        '    background: #0d0d11;'
        '    color: #ffffff;'
        '    font-family: "Segoe UI", Arial, sans-serif;'
        '    display: flex;'
        '    align-items: center;'
        '    justify-content: center;'
        '    height: 100vh;'
        '}'

        '.card {'
        '    background: #16161a;'
        '    border: 1px solid #333333;'
        '    border-radius: 16px;'
        '    padding: 30px;'
        '    width: 300px;'
        '    text-align: center;'
        '    box-shadow: 0 10px 30px rgba(0,0,0,0.5);'
        '}'

        '.logo {'
        '    font-size: 11px;'
        '    color: #888888;'
        '    text-transform: uppercase;'
        '    letter-spacing: 2px;'
        '}'

        '.led {'
        '    width: 20px;'
        '    height: 20px;'
        '    border-radius: 50%;'
        '    background: COR;'
        '    box-shadow: 0 0 15px COR;'
        '    margin: 25px auto 15px;'
        '}'

        '.status {'
        '    font-size: 20px;'
        '    font-weight: bold;'
        '}'

        '.vm {'
        '    font-size: 14px;'
        '    color: #888888;'
        '    margin-top: 8px;'
        '}'

        '.time {'
        '    font-size: 11px;'
        '    color: #666666;'
        '    margin-top: 20px;'
        '}'

        '</style>'

        '</head>'


        '<body>'

        '<div class="card">'

        '<div class="logo">Monitoramento</div>'

        '<div class="led"></div>'

        '<div class="status">STATUS</div>'

        '<div class="vm">VMNAME</div>'

        '<div class="time">&Uacute;ltima checagem: TIME</div>'

        '</div>'

        '</body>'

        '</html>'

    )


    # --------------------------------------------------------
    # MONTAR HTML
    # --------------------------------------------------------

    $SaidaHTML = $ConteudoHTML -join "`r`n"


    # --------------------------------------------------------
    # SUBSTITUIR DADOS
    # --------------------------------------------------------

    $SaidaHTML = $SaidaHTML.Replace("COR", $Cor)

    $SaidaHTML = $SaidaHTML.Replace("STATUS", $TextoStatus)

    $SaidaHTML = $SaidaHTML.Replace("VMNAME", $VM_NAME)

    $SaidaHTML = $SaidaHTML.Replace("TIME", $Hora)


    # --------------------------------------------------------
    # SALVAR DASHBOARD
    # --------------------------------------------------------

    Set-Content `
        -Path $HTML_FILE `
        -Value $SaidaHTML `
        -Encoding UTF8 `
        -Force
}


# ============================================================
# INÃCIO
# ============================================================

Clear-Host

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       VIRTUALBOX VM WATCHDOG" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "VM : $VM_NAME"
Write-Host "IP : $VM_IP"
Write-Host ""


# ============================================================
# VERIFICAR VBOXMANAGE
# ============================================================

if (-not (Test-Path $VBOX)) {

    Write-Host "ERRO: VBoxManage.exe nÃ£o encontrado!" -ForegroundColor Red

    Write-Host ""

    Write-Host "Caminho configurado:" -ForegroundColor Yellow

    Write-Host $VBOX -ForegroundColor Yellow

    Write-Host ""

    exit 1
}


Write-Host "VBoxManage encontrado." -ForegroundColor Green

Write-Host "Monitoramento iniciado." -ForegroundColor Cyan

Write-Host ""


# ============================================================
# LOG INICIAL
# ============================================================

Registrar-Log "=================================================="

Registrar-Log "Monitoramento iniciado."

Registrar-Log "VM: $VM_NAME"

Registrar-Log "IP: $VM_IP"

Registrar-Log "=================================================="


# ============================================================
# GERAR DASHBOARD INICIAL
# ============================================================

Gerar-Dashboard "OFFLINE"


# ============================================================
# LOOP PRINCIPAL
# ============================================================

while ($true) {


    # --------------------------------------------------------
    # HORÃRIO
    # --------------------------------------------------------

    $Agora = Get-Date -Format "HH:mm:ss"


    # --------------------------------------------------------
    # TESTAR PING
    # --------------------------------------------------------

    Write-Host "[$Agora] Testando $VM_IP..." -ForegroundColor Gray


    $Ping = Test-Connection `
        -ComputerName $VM_IP `
        -Count 1 `
        -Quiet `
        -ErrorAction SilentlyContinue


    # ========================================================
    # VM ONLINE
    # ========================================================

    if ($Ping) {

        Write-Host "[$Agora] VM ONLINE." -ForegroundColor Green

        Registrar-Log "VM ONLINE."

        Gerar-Dashboard "ONLINE"

    }


    # ========================================================
    # VM OFFLINE
    # ========================================================

    else {

        Write-Host ""

        Write-Host "[$Agora] VM OFFLINE!" -ForegroundColor Red

        Registrar-Log "VM OFFLINE. Iniciando rotina de recuperaÃ§Ã£o."

        Gerar-Dashboard "REBOOTING"


        # ----------------------------------------------------
        # CONSULTAR ESTADO DA VM
        # ----------------------------------------------------

        Write-Host "[$Agora] Consultando estado da VM..." -ForegroundColor Yellow


        $InfoVM = & $VBOX showvminfo "$VM_NAME" --machinereadable 2>&1


        $EstadoLinha = $InfoVM |
            Where-Object {
                $_ -match '^VMState='
            } |
            Select-Object -First 1


        $Estado = ""


        if ($EstadoLinha) {

            $Estado = $EstadoLinha -replace '^VMState="', ''

            $Estado = $Estado.TrimEnd('"')

        }


        Write-Host "Estado atual da VM: $Estado" -ForegroundColor Yellow

        Registrar-Log "Estado atual da VM: $Estado"


        # ====================================================
        # SE ESTIVER LIGADA, DESLIGAR
        # ====================================================

        if ($Estado -eq "running") {

            Write-Host ""

            Write-Host "VM estÃ¡ ligada. Executando poweroff..." -ForegroundColor Yellow

            Registrar-Log "VM estÃ¡ em execuÃ§Ã£o. Executando poweroff."


            & $VBOX controlvm "$VM_NAME" poweroff


            Start-Sleep -Seconds 5

        }


        # ====================================================
        # INICIAR VM
        # ====================================================

        Write-Host ""

        Write-Host "Iniciando VM..." -ForegroundColor Cyan

        Registrar-Log "Executando startvm."


        & $VBOX startvm "$VM_NAME" --type headless


        # ====================================================
        # AGUARDAR VM
        # ====================================================

        Write-Host ""

        Write-Host "Aguardando 120 segundos para a VM iniciar..." -ForegroundColor Yellow

        Registrar-Log "Aguardando 120 segundos para estabilizaÃ§Ã£o."


        Start-Sleep -Seconds 120


        # ====================================================
        # TESTAR NOVAMENTE
        # ====================================================

        Write-Host ""

        Write-Host "Testando VM novamente..." -ForegroundColor Cyan


        $Ping2 = Test-Connection `
            -ComputerName $VM_IP `
            -Count 1 `
            -Quiet `
            -ErrorAction SilentlyContinue


        # ====================================================
        # RECUPERADA
        # ====================================================

        if ($Ping2) {

            Write-Host ""

            Write-Host "VM voltou a responder!" -ForegroundColor Green

            Registrar-Log "VM recuperada com sucesso."

            Gerar-Dashboard "ONLINE"

        }


        # ====================================================
        # AINDA OFFLINE
        # ====================================================

        else {

            Write-Host ""

            Write-Host "VM ainda nÃ£o responde." -ForegroundColor Red

            Registrar-Log "VM ainda nÃ£o responde apÃ³s tentativa de reboot."

            Gerar-Dashboard "OFFLINE"

        }

    }


    # ========================================================
    # AGUARDAR PRÃ“XIMA VERIFICAÃ‡ÃƒO
    # ========================================================

    Write-Host ""

    Write-Host "PrÃ³xima verificaÃ§Ã£o em 15 segundos." -ForegroundColor DarkGray

    Write-Host ""


    Start-Sleep -Seconds 15

}
