# ...existing code...

# =============================
# 1. Verificar status dos WTS e outros servidores
# =============================
$servidores = @(
    @{ Nome = "WTS MATRIZ"; IP = "ip" },
    @{ Nome = "WTS PROTHEUS"; IP = "ip" },
    @{ Nome = "WTS COYOTE"; IP = "ip" },
    @{ Nome = "WTS CARAZINHO"; IP = "ip" },
    @{ Nome = "WTS ALFREDO WAGNER"; IP = "ip" },
    @{ Nome = "WTS MACHS"; IP = "ip" },
    @{ Nome = "WTS SCI-CONTABILIDADE"; IP = "ip" }
)

foreach ($srv in $servidoresOutros) {
    $resposta = Test-Ping -ip $srv.IP
    if ($resposta) {
        $statusServidores += "<li>✅ <b>$($srv.Nome)</b> ($($srv.IP)) está <span style='color:green'>ONLINE</span></li>"
    } else {
        $statusServidores += "<li>❌ <b>$($srv.Nome)</b> ($($srv.IP)) está <span style='color:red'>OFFLINE</span></li>"
    }
}
$statusServidores += "</ul>"

# =============================
# 2. Verificar backups dos PDVs
# =============================
$pastasBackup = @(
    @{ Nome = "PDV TAIO"; Caminho = "caminho" },
    @{ Nome = "PDV ALFREDO WAGNER"; Caminho = "caminho" }
)

$statusBackup = "<h3>📦 STATUS DOS BACKUPS DE PDV:</h3>"
foreach ($pasta in $pastasBackup) {
    $statusBackup += "<h4>🔍 $($pasta.Nome):</h4><ul>"
    if (Test-Path $pasta.Caminho) {
        $arquivosBackup = Get-ChildItem -Path $pasta.Caminho -Filter "PDV_*.rar" | Sort-Object LastWriteTime -Descending
        if ($arquivosBackup.Count -gt 0) {
            foreach ($arquivo in $arquivosBackup) {
                $data = $arquivo.LastWriteTime.ToString("dd/MM/yyyy HH:mm")
                $statusBackup += "<li>$($arquivo.Name): $data</li>"
            }
        } else {
            $statusBackup += "<li>⚠️ Nenhum backup encontrado.</li>"
        }
    } else {
        $statusBackup += "<li>❌ Não foi possível acessar <code>$($pasta.Caminho)</code></li>"
    }
    $statusBackup += "</ul>"
}

# =============================
# 3. Verificar arquivos TXT da Máxima
# =============================
$statusJsonMaxima = "<h3>📂 ÚLTIMOS ARQUIVOS DO ENDPOINT DA MÁXIMA:</h3><ul>"
$pastaJson = "caminho"

if (Test-Path $pastaJson) {
    $arquivosTxt = Get-ChildItem -Path $pastaJson -Filter *.txt | Sort-Object LastWriteTime -Descending
    if ($arquivosTxt.Count -gt 0) {
        $top5 = $arquivosTxt | Select-Object -First 5
        foreach ($arquivo in $top5) {
            $dataTxt = $arquivo.LastWriteTime.ToString("dd/MM/yyyy HH:mm")
            $statusJsonMaxima += "<li>$($arquivo.Name): $dataTxt</li>"
        }

        $arquivosErro = $arquivosTxt | Where-Object { $_.Name -like "*erro*" }
        if ($arquivosErro.Count -gt 0) {
            $statusJsonMaxima += "</ul><h4 style='color:red'>❗ ARQUIVOS COM 'ERRO' DETECTADOS:</h4><ul>"
            foreach ($erro in $arquivosErro) {
                $dataErro = $erro.LastWriteTime.ToString("dd/MM/yyyy HH:mm")
                $statusJsonMaxima += "<li>❌ $($erro.Name): $dataErro</li>"
            }
        } else {
            $statusJsonMaxima += "<li>✅ Nenhum arquivo com 'erro' no nome encontrado.</li>"
        }
    } else {
        $statusJsonMaxima += "<li>⚠️ Nenhum arquivo TXT encontrado.</li>"
    }
} else {
    $statusJsonMaxima += "<li>❌ Não foi possível acessar a pasta da Máxima.</li>"
}
$statusJsonMaxima += "</ul>"

# =============================
# 4. Gerar corpo final do HTML
# =============================
$htmlFooter = "</body></html>"
$smtpBody = $htmlHeader + $statusServidores + $statusBackup + $statusJsonMaxima + $htmlFooter

# =============================
# 5. Enviar e-mail
# =============================
$smtpServer = "smtp"
$smtpFrom = "de"
$smtpTo = "para"
$smtpSubject = "Relatório diário - Status dos Servidores, Backups e Arquivos Máxima"
$smtpPort = porta_smtp
$smtpUser = "usuario"
$smtpPass = "senha"

$mailmessage = New-Object system.net.mail.mailmessage
$mailmessage.from = ($smtpFrom)
$mailmessage.To.add($smtpTo)
$mailmessage.Subject = $smtpSubject
$mailmessage.IsBodyHtml = $true
$mailmessage.Body = $smtpBody

$smtp = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
$smtp.EnableSsl = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPass)

$smtp.Send($mailmessage)

Write-Host "Relatório enviado com sucesso para $smtpTo"
