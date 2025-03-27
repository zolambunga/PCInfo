#Este script recolhe todas as informações do seu computador e gera um resumo detalhado das suas especificações. Ideal para avaliar o desempenho do PC e compartilhar com amigos.
#versao exclusiva pra windows
#para veres as informações deves fazer Ctrl+V para colar o texto resumo de todas as specs do teu pc.

#no powershell desativa restrições temporárias
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

function Show-Progress {
    param([string]$message, [int]$steps)
    Write-Host "`n$message"
    
    for ($i = 1; $i -le $steps; $i++) {
        $percent = [math]::Round(($i / $steps) * 100)
        $bar = "█" * $i + " " * ($steps - $i)  # Construção da barra
        Write-Host -NoNewline "`r[$bar] $percent% "
        Start-Sleep -Milliseconds 150  # Simula tempo de carregamento
    }
    
    Write-Host "`nConcluído!" -ForegroundColor Green
}

# Verifica se o script está a rodar como administrador
$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$Principal = New-Object System.Security.Principal.WindowsPrincipal($CurrentUser)
$IsAdmin = $Principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)

# Se não estiver a rodar como admin, reexecuta como admin automaticamente
if (-Not $IsAdmin) {
    Write-Host "Por favor, execute este script como Administrador!" -ForegroundColor Red
    Pause
    exit
}

Write-Host "Iniciando coleta de informações..." -ForegroundColor Yellow
Show-Progress "Carregando" 20

#coleta todas as informações do computador para a variavel info
$info = @"

=== INFORMAÇÕES DO PC ===

- Fabricante: $(Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty Manufacturer)
- Modelo: $(Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty Model)

- Nome do Computador: $(Get-ComputerInfo | Select-Object -ExpandProperty CsName)
- Sistema Operacional: $(Get-ComputerInfo | Select-Object -ExpandProperty OsName)
- Versão do SO: $(Get-ComputerInfo | Select-Object -ExpandProperty OsVersion)
- Arquitetura: $(Get-ComputerInfo | Select-Object -ExpandProperty OsArchitecture)
- Tipo do Sistema: $(Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty SystemType)
- Usuário Atual: $(Get-ComputerInfo | Select-Object -ExpandProperty CsUserName)

=== PROCESSADOR (CPU) ===
- Modelo: $(Get-CimInstance Win32_Processor | Select-Object -ExpandProperty Name)
- Fabricante: $(Get-CimInstance Win32_Processor | Select-Object -ExpandProperty Manufacturer)
- Núcleos Físicos: $(Get-CimInstance Win32_Processor | Select-Object -ExpandProperty NumberOfCores)
- Threads (Lógicos): $(Get-CimInstance Win32_Processor | Select-Object -ExpandProperty NumberOfLogicalProcessors)
- Velocidade Máxima: $(Get-CimInstance Win32_Processor | Select-Object -ExpandProperty MaxClockSpeed) MHz
- Cache L3: $(Get-CimInstance Win32_Processor | Select-Object -ExpandProperty L3CacheSize) KB

=== PLACA DE VÍDEO (GPU) ===
$(Get-CimInstance Win32_VideoController | ForEach-Object {
    "- Modelo: $($_.Name)
     - Memória: $([math]::Round($_.AdapterRAM / 1GB, 2)) GB

"
})

=== MEMÓRIA RAM ===
$(Get-CimInstance Win32_PhysicalMemory | ForEach-Object {
    "- Slot: $($_.BankLabel)
     - Capacidade: $([math]::Round($_.Capacity / 1GB, 2)) GB
     - Velocidade: $($_.Speed) MHz - Tipo: $($_.MemoryType)"
})

- Total de RAM: $([math]::Round((Get-ComputerInfo | Select-Object -ExpandProperty CsTotalPhysicalMemory) / 1GB, 2)) GB
- Memória Virtual Total: $([math]::Round((Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty TotalVirtualMemorySize) / 1MB, 2)) GB

=== ARMAZENAMENTO (SSD/HDD) ===
$(Get-PhysicalDisk | ForEach-Object {
    "- Modelo: $($_.Model)
     - Tipo: $($_.MediaType)
     - Tamanho: $([math]::Round($_.Size / 1GB, 2)) GB
     - Conexão: $($_.BusType)"
})

=== PLACA-MÃE ===
- Fabricante: $(Get-WmiObject Win32_BaseBoard | Select-Object -ExpandProperty Manufacturer)
- Modelo: $(Get-WmiObject Win32_BaseBoard | Select-Object -ExpandProperty Product)
- Versão: $(Get-WmiObject Win32_BaseBoard | Select-Object -ExpandProperty Version)
- Versão da BIOS: $(Get-WmiObject Win32_BIOS | Select-Object -ExpandProperty SMBIOSBIOSVersion)
- Data da BIOS: $(Get-WmiObject Win32_BIOS | Select-Object -ExpandProperty ReleaseDate)

=== REDE ===
$(Get-NetAdapter | ForEach-Object {
    "- Nome: $($_.Name)
     - Tipo: $($_.InterfaceDescription)
     - Status: $($_.Status) - MAC: $($_.MacAddress)"
})

=== DISPOSITIVOS USB ===
$(Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -match '^USB' } | ForEach-Object {
    "- $($_.FriendlyName)
"
})

=== TEMPERATURA DA CPU (se disponível) ===
$(Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi" | ForEach-Object {
    "- Temperatura: $([math]::Round(($_.CurrentTemperature - 2732) / 10, 2))°C"
})

"@

# copia as informações para a área de transferência
$info | Set-Clipboard

# exibe mensagem de conclusão
Write-Host "As informações do seu PC foram copiadas para a área de transferência! Basta colar (Ctrl + V)." -ForegroundColor Green

# Aguarda Enter antes de fechar, só pra cuiar mais
Pause
