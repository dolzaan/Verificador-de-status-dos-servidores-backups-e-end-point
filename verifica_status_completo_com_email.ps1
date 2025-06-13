# ...existing code...

# =============================
# 1. Verificar status dos WTS e outros servidores
# =============================
$statusServidores = "<h3>🖥️ STATUS DOS SERVIDORES:</h3>"

# Servidores da Matriz
$statusServidores += "<h4>🏢 MATRIZ:</h4><ul>"
$servidoresMatriz = @(
    @{ Nome = "WTS MATRIZ"; IP = "172.16.1.240" },
    @{ Nome = "BANCO DE DADOS PROTHEUS"; IP = "172.16.1.250" },
    @{ Nome = "SERVIDOR DE ARQUIVOS"; IP = "172.16.1.245" }
)

foreach ($srv in $servidoresMatriz) {
    $resposta = Test-Ping -ip $srv.IP
    if ($resposta) {
        $statusServidores += "<li>✅ <b>$($srv.Nome)</b> ($($srv.IP)) está <span style='color:green'>ONLINE</span></li>"
    } else {
        $statusServidores += "<li>❌ <b>$($srv.Nome)</b> ($($srv.IP)) está <span style='color:red'>OFFLINE</span></li>"
    }
}
$statusServidores += "</ul>"

# Outros servidores (exemplo: filiais)
$statusServidores += "<h4>🏢 OUTRAS LOCALIDADES:</h4><ul>"
$servidoresOutros = @(
    @{ Nome = "WTS PROTHEUS"; IP = "172.16.1.220" },
    @{ Nome = "WTS COYOTE"; IP = "172.16.4.222" },
    @{ Nome = "WTS CARAZINHO"; IP = "172.16.5.222" },
    @{ Nome = "WTS ALFREDO WAGNER"; IP = "172.16.3.240" },
    @{ Nome = "WTS MACHS"; IP = "177.221.67.222" },
    @{ Nome = "WTS SCI-CONTABILIDADE"; IP = "172.16.1.232" }
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

# ...existing code...