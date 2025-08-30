# Sistema de Monitoramento de Atualizacoes do GitHub - ELIS-V1
# Script para notificar sobre commits, progresso de tarefas e atualizacoes
# Versao 2.0 - Passo 3 do projeto

param(
    [string]$Action = "check",
    [switch]$Verbose,
    [switch]$ShowNotifications = $true
)

# Configuracoes
$ProjectName = "ELIS-V1"
$RepoUrl = "https://github.com/GustavoRizieri/ELIS-V1.git"
$LogFile = "github-updates.log"
$LastCheckFile = "last-check.txt"
$NotificationFile = "notifications.txt"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    # Colorir output baseado no nivel
    switch ($Level) {
        "ALERT" { Write-Host $logEntry -ForegroundColor Red }
        "SUCCESS" { Write-Host $logEntry -ForegroundColor Green }
        "SUMMARY" { Write-Host $logEntry -ForegroundColor Cyan }
        "PROGRESS" { Write-Host $logEntry -ForegroundColor Yellow }
        "STATUS" { Write-Host $logEntry -ForegroundColor Magenta }
        default { Write-Host $logEntry }
    }
    
    Add-Content -Path $LogFile -Value $logEntry
}

# Funcao para criar notificacao
function Create-Notification {
    param([string]$Title, [string]$Message, [string]$Type = "INFO")
    
    $notification = @{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Title = $Title
        Message = $Message
        Type = $Type
    }
    
    $notificationJson = $notification | ConvertTo-Json -Compress
    Add-Content -Path $NotificationFile -Value $notificationJson
    
    if ($ShowNotifications) {
        Write-Host "`nNOTIFICACAO: $Title" -ForegroundColor Yellow
        Write-Host "   $Message" -ForegroundColor White
        Write-Host "   Horario: $($notification.Timestamp)`n" -ForegroundColor Gray
    }
}

function Get-LastCheckTime {
    if (Test-Path $LastCheckFile) {
        return Get-Content $LastCheckFile
    }
    return (Get-Date).AddDays(-1).ToString("yyyy-MM-dd HH:mm:ss")
}

function Set-LastCheckTime {
    $currentTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Set-Content -Path $LastCheckFile -Value $currentTime
}

# Funcao para verificar atualizacoes remotas
function Check-RemoteUpdates {
    Write-Log "Verificando atualizacoes remotas do repositorio..."
    
    try {
        # Buscar atualizacoes do remoto
        git fetch origin 2>&1 | Out-Null
        
        # Verificar se ha commits novos
        $localCommit = git rev-parse HEAD
        $remoteCommit = git rev-parse origin/main
        
        if ($localCommit -ne $remoteCommit) {
            Write-Log "NOVA ATUALIZACAO DETECTADA!" "ALERT"
            
            # Obter detalhes dos novos commits
            $newCommits = git log --oneline $localCommit..$remoteCommit
            $commitCount = ($newCommits | Measure-Object).Count
            
            Create-Notification "Atualizacoes Disponiveis" "$commitCount novo(s) commit(s) detectado(s) no repositorio" "UPDATE"
            
            Get-UpdateSummary $newCommits
            return $true
        } else {
            Write-Log "Repositorio esta atualizado" "SUCCESS"
            return $false
        }
    }
    catch {
        Write-Log "Erro ao verificar atualizacoes: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Funcao para gerar resumo de atualizacoes
function Get-UpdateSummary {
    param([array]$Commits)
    
    Write-Log "RESUMO DE ATUALIZACOES:" "SUMMARY"
    Write-Log "   • Total de novos commits: $($Commits.Count)" "SUMMARY"
    Write-Log "   • Detalhes dos commits:" "SUMMARY"
    
    foreach ($commit in $Commits) {
        Write-Log "     - $commit" "SUMMARY"
    }
    
    # Analisar progresso de tarefas
    Analyze-TaskProgress $Commits
}

# Funcao para analisar progresso de tarefas
function Analyze-TaskProgress {
    param([array]$Commits)
    
    Write-Log "ANALISE DE PROGRESSO DE TAREFAS:" "PROGRESS"
    
    $taskPatterns = @{
        "Passos" = @("Passo", "Step", "Etapa")
        "Implementacoes" = @("Implementar", "Criar", "Adicionar", "Desenvolver")
        "Correcoes" = @("Corrigir", "Fix", "Bug", "Resolver")
        "Documentacao" = @("Documentar", "Doc", "README", "Documentacao")
        "Testes" = @("Testar", "Test", "Verificar")
        "Configuracoes" = @("Configurar", "Config", "Setup", "Instalar")
    }
    
    $progressSummary = @{}
    
    foreach ($category in $taskPatterns.Keys) {
        $patterns = $taskPatterns[$category]
        $matchingCommits = @()
        
        foreach ($commit in $Commits) {
            foreach ($pattern in $patterns) {
                if ($commit -match $pattern) {
                    $matchingCommits += $commit
                    break
                }
            }
        }
        
        if ($matchingCommits.Count -gt 0) {
            $progressSummary[$category] = $matchingCommits.Count
            Write-Log "   • $category`: $($matchingCommits.Count) commit(s)" "PROGRESS"
        }
    }
    
    # Criar notificacao de progresso
    if ($progressSummary.Count -gt 0) {
        $progressMessage = "Progresso detectado: "
        $progressDetails = @()
        foreach ($key in $progressSummary.Keys) {
            $progressDetails += "$key ($($progressSummary[$key]))"
        }
        $progressMessage += $progressDetails -join ", "
        
        Create-Notification "Progresso de Tarefas" $progressMessage "PROGRESS"
    }
}

function Get-GitStatus {
    Write-Log "Verificando status atual do repositorio..."
    
    # Get current branch
    $currentBranch = git branch --show-current
    
    # Check if there are new commits
    $localCommit = git rev-parse HEAD
    $remoteCommit = git rev-parse "origin/$currentBranch"
    
    # Status do working directory
    $gitStatus = git status --porcelain
    $hasLocalChanges = $gitStatus.Count -gt 0
    
    # Ultimo commit local
    $lastCommit = git log -1 --oneline
    
    # Verificar commits pendentes para push
    $unpushedCommits = git log origin/main..HEAD --oneline 2>$null
    $hasPendingPush = $unpushedCommits.Count -gt 0
    
    Write-Log "   • Branch atual: $currentBranch" "STATUS"
    Write-Log "   • Ultimo commit: $lastCommit" "STATUS"
    
    if ($hasLocalChanges) {
        Write-Log "   • Arquivos modificados localmente: $($gitStatus.Count)" "STATUS"
    } else {
        Write-Log "   • Working directory limpo" "STATUS"
    }
    
    if ($hasPendingPush) {
        Write-Log "   • Commits pendentes para push: $($unpushedCommits.Count)" "STATUS"
    }
    
    # Ultima verificacao
    if (Test-Path $LastCheckFile) {
        $lastCheck = Get-Content $LastCheckFile
        Write-Log "   • Ultima verificacao: $lastCheck" "STATUS"
    }
}

# Funcao para sincronizar com remoto
function Sync-WithRemote {
    Write-Log "Sincronizando com repositorio remoto..."
    
    try {
        git pull origin main
        Write-Log "Sincronizacao concluida com sucesso!" "SUCCESS"
        
        Create-Notification "Sincronizacao Completa" "Repositorio local atualizado com sucesso" "SUCCESS"
        
        # Atualizar timestamp da ultima verificacao
        Set-LastCheckTime
    }
    catch {
        Write-Log "Erro na sincronizacao: $($_.Exception.Message)" "ERROR"
        Create-Notification "Erro de Sincronizacao" $_.Exception.Message "ERROR"
    }
}

# Funcao principal
function Main {
    Write-Log "Sistema de Monitoramento GitHub - $ProjectName" "STATUS"
    Write-Log "Acao solicitada: $Action" "STATUS"
    
    switch ($Action.ToLower()) {
        "check" {
            Get-GitStatus
            $hasUpdates = Check-RemoteUpdates
            if ($hasUpdates) {
                Create-Notification "Acao Requerida" "Execute 'github-monitor.ps1 -Action sync' para sincronizar" "INFO"
            }
        }
        "sync" {
            $hasUpdates = Check-RemoteUpdates
            if ($hasUpdates) {
                Sync-WithRemote
            }
            Get-GitStatus
        }
        "status" {
            Get-GitStatus
        }
        "monitor" {
            Write-Log "Iniciando monitoramento continuo (verificacao a cada 5 minutos)..." "STATUS"
            while ($true) {
                Check-RemoteUpdates
                Start-Sleep -Seconds 300
            }
        }
        "notifications" {
            if (Test-Path $NotificationFile) {
                Write-Log "HISTORICO DE NOTIFICACOES:" "STATUS"
                $notifications = Get-Content $NotificationFile | ForEach-Object { $_ | ConvertFrom-Json }
                foreach ($notif in $notifications | Sort-Object Timestamp -Descending | Select-Object -First 10) {
                    Write-Log "   [$($notif.Timestamp)] $($notif.Title): $($notif.Message)" "STATUS"
                }
            } else {
                Write-Log "Nenhuma notificacao encontrada" "STATUS"
            }
        }
        default {
            Write-Log "Acao invalida. Use: check, sync, status, monitor, ou notifications" "ERROR"
            Write-Log "Exemplos de uso:" "STATUS"
            Write-Log "   .\github-monitor.ps1 -Action check" "STATUS"
            Write-Log "   .\github-monitor.ps1 -Action sync" "STATUS"
            Write-Log "   .\github-monitor.ps1 -Action status" "STATUS"
            Write-Log "   .\github-monitor.ps1 -Action notifications" "STATUS"
        }
    }
    
    Write-Log "Monitoramento concluido." "SUCCESS"
}

# Executar funcao principal
Main