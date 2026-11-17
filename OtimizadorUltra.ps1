# =============================================================================
# PROGRAMA DESENVOLVIDO POR MARCOS MENDES (GOAT_DEV011)
# Otimizado com Criação Automática de Ponto de Restauração
# Execute como ADMINISTRADOR | ULTIMA ATUALIZACAO 16/11/26
# =============================================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Verifica privilégios de Administrador
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    [System.Windows.Forms.MessageBox]::Show("Execute este script como ADMINISTRADOR!", "Atenção", "OK", "Warning") | Out-Null
    exit
}

# Compila API nativa de memória apenas uma vez na inicialização
if (-not ([System.Management.Automation.PSTypeName]'NativeMemory').Type) {
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class NativeMemory {
    [DllImport("psapi.dll")] public static extern int EmptyWorkingSet(IntPtr hwProc);
}
"@ -ErrorAction SilentlyContinue
}

# ==================== CONFIGURAÇÃO DO FORMULÁRIO ====================
$form = New-Object System.Windows.Forms.Form -Property @{
    Text            = "Otimização AGRESSIVA para Gamers - ULTRA"
    Size            = New-Object System.Drawing.Size(700, 650)
    StartPosition   = "CenterScreen"
    FormBorderStyle = "FixedSingle"
    MaximizeBox     = $false
    BackColor       = [System.Drawing.Color]::FromArgb(22, 22, 26)
}

# Carregamento seguro do ícone
$iconCandidates = @($PSScriptRoot, $PWD.Path) | Where-Object { $_ } | ForEach-Object { Join-Path $_ "goat.ico" }
foreach ($iconPath in $iconCandidates) {
    if (Test-Path $iconPath) {
        try { $form.Icon = New-Object System.Drawing.Icon($iconPath); break } catch {}
    }
}

$lblTitle = New-Object System.Windows.Forms.Label -Property @{
    Text      = "OTIMIZAÇÃO AGRESSIVA PARA GAMING - ULTRA"
    Font      = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    ForeColor = [System.Drawing.Color]::Cyan
    AutoSize  = $true
    Location  = New-Object System.Drawing.Point(18, 12)
}
$form.Controls.Add($lblTitle)

$txtStatus = New-Object System.Windows.Forms.RichTextBox -Property @{
    Multiline   = $true
    ReadOnly    = $true
    ScrollBars  = "Vertical"
    Font        = New-Object System.Drawing.Font("Consolas", 9.5)
    BackColor   = [System.Drawing.Color]::FromArgb(12, 12, 15)
    ForeColor   = [System.Drawing.Color]::Lime
    Location    = New-Object System.Drawing.Point(18, 48)
    Size        = New-Object System.Drawing.Size(648, 340)
    BorderStyle = "None"
}
$form.Controls.Add($txtStatus)

# ==================== HELPER DE INTERFACE E LOG ====================
function Write-Log {
    param(
        [string]$Mensagem,
        [string]$Cor = "White"
    )
    if ($txtStatus.IsDisposed) { return }
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    $txtStatus.SelectionStart = $txtStatus.TextLength
    $txtStatus.SelectionLength = 0
    $txtStatus.SelectionColor = [System.Drawing.Color]::FromName($Cor)
    
    if ([string]::IsNullOrEmpty($Mensagem)) {
        $txtStatus.AppendText("`r`n")
    } else {
        $txtStatus.AppendText("[$timestamp] $Mensagem`r`n")
    }
    
    $txtStatus.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

function New-ActionButton {
    param(
        [string]$Text,
        [int]$X, [int]$Y, [int]$W, [int]$H,
        [System.Drawing.Color]$BackColor,
        [System.Drawing.Font]$Font = (New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold))
    )
    $btn = New-Object System.Windows.Forms.Button -Property @{
        Text      = $Text
        Location  = New-Object System.Drawing.Point($X, $Y)
        Size      = New-Object System.Drawing.Size($W, $H)
        BackColor = $BackColor
        ForeColor = [System.Drawing.Color]::White
        FlatStyle = "Flat"
        Font      = $Font
        Cursor    = [System.Windows.Forms.Cursors]::Hand
    }
    $btn.FlatAppearance.BorderSize = 0
    $form.Controls.Add($btn)
    return $btn
}

# ==================== CRIAÇÃO DOS BOTÕES ====================
$fontBoldLarge = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)

$btnTudo        = New-ActionButton -Text "APLICAR TUDO (Cria Backup + Máxima Performance)" -X 18  -Y 402 -W 648 -H 42 -BackColor ([System.Drawing.Color]::FromArgb(200, 20, 50)) -Font $fontBoldLarge
$btnRede        = New-ActionButton -Text "Rede"                -X 18  -Y 456 -W 100 -H 35 -BackColor ([System.Drawing.Color]::FromArgb(0, 110, 200))
$btnRAM         = New-ActionButton -Text "RAM"                 -X 126 -Y 456 -W 100 -H 35 -BackColor ([System.Drawing.Color]::FromArgb(0, 140, 90))
$btnLimpeza     = New-ActionButton -Text "Limpeza"             -X 234 -Y 456 -W 100 -H 35 -BackColor ([System.Drawing.Color]::FromArgb(170, 90, 0))
$btnGPU         = New-ActionButton -Text "GPU"                 -X 342 -Y 456 -W 100 -H 35 -BackColor ([System.Drawing.Color]::FromArgb(0, 160, 160))
$btnXbox        = New-ActionButton -Text "Xbox/GameBar"        -X 450 -Y 456 -W 112 -H 35 -BackColor ([System.Drawing.Color]::FromArgb(16, 124, 16))
$btnSSD         = New-ActionButton -Text "SSD"                 -X 570 -Y 456 -W 96  -H 35 -BackColor ([System.Drawing.Color]::FromArgb(120, 60, 180))
$btnJogos       = New-ActionButton -Text "Otimizar para Jogos" -X 18  -Y 502 -W 200 -H 35 -BackColor ([System.Drawing.Color]::FromArgb(140, 0, 160))
$btnPontoBackup = New-ActionButton -Text "Criar Ponto Backup"  -X 226 -Y 502 -W 210 -H 35 -BackColor ([System.Drawing.Color]::FromArgb(30, 130, 76))
$btnRestaurar   = New-ActionButton -Text "Restaurar Padrões"   -X 444 -Y 502 -W 222 -H 35 -BackColor ([System.Drawing.Color]::FromArgb(80, 80, 85))

$allButtons = @($btnTudo, $btnRede, $btnRAM, $btnLimpeza, $btnGPU, $btnXbox, $btnSSD, $btnJogos, $btnPontoBackup, $btnRestaurar)

$lblAviso = New-Object System.Windows.Forms.Label -Property @{
    Text      = "Após otimizar Rede -> REINICIE o PC  |  Um Ponto de Restauração é criado automaticamente no APLICAR TUDO"
    Font      = New-Object System.Drawing.Font("Segoe UI", 8.5)
    ForeColor = [System.Drawing.Color]::Yellow
    AutoSize  = $true
    Location  = New-Object System.Drawing.Point(18, 552)
}
$form.Controls.Add($lblAviso)

$lblAviso2 = New-Object System.Windows.Forms.Label -Property @{
    Text      = "Xbox Game Bar e telemetria são desativados permanentemente até você clicar em Restaurar Padrões"
    Font      = New-Object System.Drawing.Font("Segoe UI", 8.5)
    ForeColor = [System.Drawing.Color]::LightGray
    AutoSize  = $true
    Location  = New-Object System.Drawing.Point(18, 574)
}
$form.Controls.Add($lblAviso2)

# ==================== FUNÇÕES DE OTIMIZAÇÃO ====================

function Invoke-SafeAction {
    param([scriptblock]$Action, [bool]$ClearLog = $true)
    
    $allButtons | ForEach-Object { $_.Enabled = $false }
    if ($ClearLog) { $txtStatus.Clear() }
    try {
        & $Action
    } finally {
        $allButtons | ForEach-Object { $_.Enabled = $true }
    }
}

function Criar-PontoRestauracao {
    param([string]$Descricao = "Pre-Otimizacao Gamer ULTRA (GOAT_DEV011)")
    
    Write-Log "========== PONTO DE RESTAURAÇÃO DO WINDOWS ==========" "Cyan"
    try {
        $sysDrive = "$($env:SystemDrive)\"
        Write-Log "Verificando serviço de Cópia de Sombra de Volume (VSS)..." "White"
        Set-Service -Name "VSS" -StartupType Manual -ErrorAction SilentlyContinue
        Start-Service -Name "VSS" -ErrorAction SilentlyContinue

        Write-Log "Habilitando Restauração do Sistema na unidade $sysDrive..." "White"
        Enable-ComputerRestore -Drive $sysDrive -ErrorAction SilentlyContinue

        # Remove o bloqueio de 24h do Windows para permitir criar pontos consecutivos
        $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore"
        if (Test-Path $regPath) {
            Set-ItemProperty -Path $regPath -Name "SystemRestorePointCreationFrequency" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
        }

        Write-Log "Criando ponto de restauração (pode levar alguns segundos)..." "Yellow"
        Checkpoint-Computer -Description $Descricao -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop

        Write-Log "Ponto de Restauração criado com sucesso OK!" "Lime"
        return $true
    } catch {
        Write-Log "AVISO ao criar Ponto de Restauração: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Otimizar-Rede {
    Write-Log "========== OTIMIZAÇÃO DE REDE ==========" "Cyan"
    try {
        Write-Log "Limpando caches DNS e ARP..." "White"
        ipconfig /flushdns | Out-Null
        netsh interface ip delete arpcache | Out-Null

        Write-Log "Renovando concessão DHCP/IP..." "White"
        ipconfig /release | Out-Null
        Start-Sleep -Milliseconds 500
        ipconfig /renew | Out-Null

        Write-Log "Resetando Winsock e pilha TCP/IP..." "White"
        netsh winsock reset | Out-Null
        netsh int ip reset | Out-Null

        Write-Log "Ajustando parâmetros TCP para baixa latência..." "White"
        netsh int tcp set global autotuninglevel=normal | Out-Null
        netsh int tcp set global timestamps=disabled | Out-Null
        netsh int tcp set global ecncapability=disabled | Out-Null
        netsh int tcp set heuristics disabled | Out-Null
        netsh int tcp set global rss=enabled | Out-Null
        netsh int tcp set global rsc=disabled | Out-Null

        Write-Log "Rede otimizada! REINICIE o PC para efetivar." "Lime"
    } catch {
        Write-Log "ERRO Rede: $($_.Exception.Message)" "Red"
    }
}

function Otimizar-RAM {
    Write-Log "========== OTIMIZAÇÃO DE RAM ==========" "Cyan"
    try {
        Write-Log "Liberando Working Sets dos processos em segundo plano..." "White"
        $processes = Get-Process | Where-Object { $_.Handle -ne [IntPtr]::Zero }
        foreach ($proc in $processes) {
            try { [NativeMemory]::EmptyWorkingSet($proc.Handle) | Out-Null } catch {}
        }

        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()

        $os = Get-CimInstance Win32_OperatingSystem
        $total = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
        $livre = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
        Write-Log "RAM otimizada OK | Livre: $livre GB de $total GB" "Lime"
    } catch {
        Write-Log "ERRO RAM: $($_.Exception.Message)" "Red"
    }
}

function Limpar-Caches {
    Write-Log "========== LIMPEZA DE CACHES E TEMPORÁRIOS ==========" "Cyan"
    $pastas = @{
        "Temp Usuário"       = "$env:TEMP\*"
        "LocalAppData Temp"  = "$env:LOCALAPPDATA\Temp\*"
        "Windows Temp"       = "C:\Windows\Temp\*"
        "Prefetch"           = "C:\Windows\Prefetch\*"
        "INetCache"          = "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*"
        "WebCache"           = "$env:LOCALAPPDATA\Microsoft\Windows\WebCache\*"
        "Windows Update"     = "C:\Windows\SoftwareDistribution\Download\*"
        "Arquivos Recentes"  = "$env:APPDATA\Microsoft\Windows\Recent\*"
        "CrashDumps"         = "$env:LOCALAPPDATA\CrashDumps\*"
    }

    foreach ($item in $pastas.GetEnumerator()) {
        Write-Log "Limpando $($item.Key)..." "White"
        Remove-Item $item.Value -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Log "Limpando logs principais de eventos do Windows..." "White"
    @("Application", "System", "Security", "Setup") | ForEach-Object {
        wevtutil cl $_ 2>$null
    }

    Write-Log "Esvaziando Lixeira..." "White"
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Log "Limpeza de sistema concluída OK!" "Lime"
}

function Limpar-GPU {
    Write-Log "========== LIMPEZA DE CACHE DA GPU ==========" "Cyan"
    try {
        $gpuPaths = @(
            "$env:LOCALAPPDATA\NVIDIA\DXCache",
            "$env:LOCALAPPDATA\NVIDIA\GLCache",
            "$env:PROGRAMDATA\NVIDIA Corporation\NV_Cache",
            "$env:LOCALAPPDATA\NVIDIA Corporation\NV_Cache",
            "$env:LOCALAPPDATA\AMD\DxCache",
            "$env:LOCALAPPDATA\AMD\GLCache",
            "$env:LOCALAPPDATA\AMD\CN",
            "$env:LOCALAPPDATA\D3DSCache",
            "${env:ProgramFiles(x86)}\Steam\steamapps\shadercache"
        )

        foreach ($path in $gpuPaths) {
            if (Test-Path $path) {
                Write-Log "Limpando: $path" "White"
                Remove-Item "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        Write-Log "Cache de Shaders da GPU limpo OK!" "Lime"
        Write-Log "Obs: Os jogos recompilarão shaders na próxima abertura." "Yellow"
    } catch {
        Write-Log "ERRO GPU: $($_.Exception.Message)" "Red"
    }
}

function Desativar-XboxGameBar {
    Write-Log "========== DESATIVAR XBOX GAME BAR / GAME DVR ==========" "Cyan"
    try {
        $regConfigs = @(
            @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR"; Name = "AppCaptureEnabled"; Value = 0 },
            @{ Path = "HKCU:\System\GameConfigStore"; Name = "GameDVR_Enabled"; Value = 0 },
            @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"; Name = "AllowGameDVR"; Value = 0 },
            @{ Path = "HKCU:\Software\Microsoft\GameBar"; Name = "AutoGameModeEnabled"; Value = 0 },
            @{ Path = "HKCU:\Software\Microsoft\GameBar"; Name = "AllowAutoGameMode"; Value = 0 },
            @{ Path = "HKCU:\Software\Microsoft\GameBar"; Name = "UseNexusForGameBarEnabled"; Value = 0 },
            @{ Path = "HKCU:\Software\Microsoft\GameBar"; Name = "ShowStartupPanel"; Value = 0 }
        )

        foreach ($cfg in $regConfigs) {
            if (-not (Test-Path $cfg.Path)) { New-Item -Path $cfg.Path -Force | Out-Null }
            Set-ItemProperty -Path $cfg.Path -Name $cfg.Name -Value $cfg.Value -Type DWord -Force
        }

        @("XblAuthManager", "XblGameSave", "XboxNetApiSvc", "XboxGipSvc") | ForEach-Object {
            Stop-Service -Name $_ -Force -ErrorAction SilentlyContinue
            Set-Service -Name $_ -StartupType Disabled -ErrorAction SilentlyContinue
        }

        Write-Log "Xbox Game Bar e serviços desativados OK!" "Lime"
    } catch {
        Write-Log "ERRO Xbox: $($_.Exception.Message)" "Red"
    }
}

function Otimizar-SSD {
    Write-Log "========== OTIMIZAÇÃO DE SSD ==========" "Cyan"
    try {
        $volumes = Get-Volume | Where-Object { $_.DriveType -eq 'Fixed' -and $_.DriveLetter }
        foreach ($vol in $volumes) {
            Write-Log "Executando TRIM no volume $($vol.DriveLetter):..." "White"
            Optimize-Volume -DriveLetter $vol.DriveLetter -ReTrim -ErrorAction SilentlyContinue
        }

        schtasks /Change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Disable 2>$null
        Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue

        Write-Log "Otimização de SSD e SysMain concluída OK!" "Lime"
    } catch {
        Write-Log "ERRO SSD: $($_.Exception.Message)" "Red"
    }
}

function Otimizar-Para-Jogos {
    Write-Log "========== OTIMIZAÇÕES GERAIS PARA JOGOS ==========" "Cyan"
    try {
        Write-Log "Ativando plano de energia Alto Desempenho..." "White"
        $highPerfGuid = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
        powercfg /setactive $highPerfGuid 2>$null
        if ($LASTEXITCODE -ne 0) {
            powercfg -duplicatescheme $highPerfGuid | Out-Null
            powercfg /setactive $highPerfGuid | Out-Null
        }

        powercfg /hibernate off | Out-Null
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Type DWord -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

        @("SysMain", "DiagTrack", "WSearch", "WerSvc") | ForEach-Object {
            Stop-Service -Name $_ -Force -ErrorAction SilentlyContinue
            Set-Service -Name $_ -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Log "Serviço $_ desativado OK" "White"
        }

        Write-Log "Otimizações gerais para jogos concluídas OK!" "Lime"
    } catch {
        Write-Log "ERRO Jogos: $($_.Exception.Message)" "Red"
    }
}

# ==================== EVENTOS DOS BOTÕES ====================

$btnTudo.Add_Click({
    Invoke-SafeAction {
        $btnTudo.Text = "CRIANDO BACKUP E OTIMIZANDO... AGUARDE"
        $btnTudo.BackColor = [System.Drawing.Color]::DarkOrange

        Write-Log "Iniciando OTIMIZAÇÃO ULTRA COMPLETA..." "Cyan"
        Write-Log ""

        # 1. Cria automaticamente o Ponto de Restauração antes de qualquer alteração
        $backupOk = Criar-PontoRestauracao
        Write-Log ""

        # Se falhar ao criar o ponto, pergunta ao usuário se deseja continuar mesmo assim
        if (-not $backupOk) {
            $resp = [System.Windows.Forms.MessageBox]::Show(
                "Não foi possível criar o Ponto de Restauração automático. Deseja continuar com a otimização mesmo assim?",
                "Aviso de Segurança",
                "YesNo",
                "Warning"
            )
            if ($resp -ne "Yes") {
                Write-Log "Operação cancelada pelo usuário." "Yellow"
                $btnTudo.Text = "APLICAR TUDO (Cria Backup + Máxima Performance)"
                $btnTudo.BackColor = [System.Drawing.Color]::FromArgb(200, 20, 50)
                return
            }
        }

        Otimizar-Rede;          Write-Log ""
        Otimizar-RAM;           Write-Log ""
        Limpar-Caches;          Write-Log ""
        Limpar-GPU;             Write-Log ""
        Desativar-XboxGameBar;  Write-Log ""
        Otimizar-SSD;           Write-Log ""
        Otimizar-Para-Jogos;    Write-Log ""

        Write-Log "==============================================" "Lime"
        Write-Log "   OTIMIZAÇÃO ULTRA FINALIZADA COM SUCESSO!" "Lime"
        Write-Log "   -> REINICIE o computador agora" "Red"
        Write-Log "==============================================" "Lime"

        $btnTudo.Text = "APLICAR TUDO (Cria Backup + Máxima Performance)"
        $btnTudo.BackColor = [System.Drawing.Color]::FromArgb(200, 20, 50)
    }
})

$btnRede.Add_Click({        Invoke-SafeAction { Otimizar-Rede } })
$btnRAM.Add_Click({         Invoke-SafeAction { Otimizar-RAM } })
$btnLimpeza.Add_Click({     Invoke-SafeAction { Limpar-Caches } })
$btnGPU.Add_Click({         Invoke-SafeAction { Limpar-GPU } })
$btnXbox.Add_Click({        Invoke-SafeAction { Desativar-XboxGameBar } })
$btnSSD.Add_Click({         Invoke-SafeAction { Otimizar-SSD } })
$btnJogos.Add_Click({       Invoke-SafeAction { Otimizar-Para-Jogos } })
$btnPontoBackup.Add_Click({ Invoke-SafeAction { Criar-PontoRestauracao -Descricao "Ponto Manual Gamer ULTRA" } })

$btnRestaurar.Add_Click({
    $confirm = [System.Windows.Forms.MessageBox]::Show("Restaurar TODAS as configurações para o padrão do Windows?", "Confirmar", "YesNo", "Question")
    if ($confirm -eq "Yes") {
        Invoke-SafeAction {
            Write-Log "Restaurando configurações padrão do Windows..." "Cyan"

            netsh int tcp set global autotuninglevel=normal | Out-Null
            netsh int tcp set global timestamps=enabled | Out-Null
            netsh int tcp set global ecncapability=enabled | Out-Null
            netsh int tcp set heuristics default | Out-Null
            netsh int tcp set global rsc=enabled | Out-Null

            powercfg /hibernate on | Out-Null
            schtasks /Change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Enable 2>$null

            @("SysMain", "WSearch", "DiagTrack", "WerSvc", "XblAuthManager", "XblGameSave", "XboxNetApiSvc", "XboxGipSvc") | ForEach-Object {
                Set-Service -Name $_ -StartupType Automatic -ErrorAction SilentlyContinue
                Start-Service -Name $_ -ErrorAction SilentlyContinue
            }

            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
            Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -ErrorAction SilentlyContinue
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

            Write-Log "Padrões restaurados com sucesso! Reinicie o PC." "Lime"
            [System.Windows.Forms.MessageBox]::Show("Padrões restaurados! Reinicie o PC para concluir.", "Sucesso") | Out-Null
        }
    }
})

# ==================== INICIALIZAÇÃO ====================
Write-Log "Interface ULTRA carregada. Pronto para máxima performance." "Cyan"
Write-Log "Clique em APLICAR TUDO (cria Ponto de Restauração automático) ou escolha uma opção." "White"
[void]$form.ShowDialog()