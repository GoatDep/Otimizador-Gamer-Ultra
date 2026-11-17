# 🚀 Otimizador Gamer ULTRA

Utilitário desenvolvido em **PowerShell + Windows Forms** focado em extrair o máximo desempenho do Windows para jogos competitivos, reduzindo latência de rede, liberando memória RAM, limpando caches de shaders da GPU e desativando processos/telemetria em segundo plano.

> **Desenvolvido por:** Marcos Mendes (`GOAT_DEV011`)  
> **Última Atualização:** Novembro/2026  
> **Sistema Operacional:** Windows 10 / Windows 11 (64-bit)

---

## ✨ Funcionalidades Principais

* 🛡️ **Backup Automático (Ponto de Restauração):** Cria automaticamente um Ponto de Restauração do Windows antes de aplicar qualquer modificação completa, garantindo segurança total ao usuário.
* 🌐 **Otimização de Rede (Baixa Latência):** Limpa caches DNS/ARP, renova concessão IP, reseta Winsock/TCP-IP e ajusta parâmetros globais do protocolo TCP (`timestamps`, `heuristics`, `rss`, `rsc`) para reduzir o *ping* e o *jitter*.
* 🧠 **Otimização de RAM:** Libera os *Working Sets* de processos ociosos em segundo plano e força a coleta de lixo do sistema em tempo real.
* 🧹 **Limpeza Profunda do Sistema:** Remove arquivos temporários do usuário e do Windows, cache do Windows Update, *CrashDumps*, arquivos recentes, logs principais de eventos e esvazia a Lixeira.
* 🎮 **Limpeza de Cache de Shaders (GPU):** Limpa caches acumulados da **NVIDIA**, **AMD**, **DirectX (`D3DSCache`)** e **Steam Shader Cache** para corrigir engasgos (*stuttering*) causados por shaders corrompidos.
* 🚫 **Desativação de Xbox Game Bar & Game DVR:** Desativa gravações em segundo plano e serviços associados (`XblAuthManager`, `XblGameSave`, `XboxNetApiSvc`, `XboxGipSvc`) para ganhar FPS e estabilidade.
* ⚡ **Otimização de SSD:** Executa o comando **TRIM** em todas as unidades fixas, desativa a desfragmentação agendada e encerra o serviço `SysMain` (Superfetch).
* 🔥 **Modo Jogo Extremo:** Ativa o plano de energia **Alto Desempenho**, desativa a hibernação, ajusta os efeitos visuais do Windows para foco em performance e desativa serviços pesados de telemetria e indexação (`DiagTrack`, `WSearch`, `WerSvc`).
* 🔄 **Restauração de Padrões:** Reverte todas as alterações de rede, serviços, energia e registro para o estado original do Windows com um clique.

---

## 📥 Como Usar

### Opção 1: Usando o Executável (`.exe`) — Recomendado
1. Acesse a aba **[Releases](../../releases)** deste repositório e baixe a versão mais recente do `OtimizadorUltra.exe`.
2. Clique com o botão direito sobre o arquivo e selecione **Executar como administrador** (ou dê duplo clique e aceite o aviso do UAC).
3. Clique em **`APLICAR TUDO (Cria Backup + Máxima Performance)`** para realizar a otimização completa, ou escolha os módulos individuais desejados.
4. **Reinicie o computador** ao finalizar para efetivar as alterações de rede e serviços.

### Opção 2: Executando via Código-Fonte (`.ps1`)
1. Clone este repositório ou baixe o arquivo `OtimizadorUltra.ps1`.
2. Abra o **PowerShell como Administrador**.
3. Libere a execução de scripts na sessão atual e inicie o programa:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\OtimizadorUltra.ps1

   ⚠️ Avisos Importantes
Privilégios de Administrador: O programa exige execução como Administrador para modificar chaves do Registro (HKLM), serviços do Windows e parâmetros de rede.

Recompilação de Shaders: Após utilizar a limpeza de GPU, é normal que seus jogos levem alguns segundos extras na primeira abertura enquanto recompilam os shaders limpos.

Falso Positivo em Antivírus: Como o executável é compilado a partir de um script PowerShell (PS2EXE) com certificado autoassinado e realiza alterações profundas no sistema, o Windows Defender pode exibir um alerta preventivo. Todo o código-fonte está aberto neste repositório para auditoria.

🛠️ Tecnologias Utilizadas
PowerShell 5.1+

.NET Windows Forms (System.Windows.Forms / System.Drawing)

P/Invoke (psapi.dll) para gerenciamento nativo de memória

PS2EXE para empacotamento do executável

📄 Licença
Este projeto é distribuído sob a licença MIT. Sinta-se à vontade para estudar, modificar e contribuir mantendo os créditos ao autor original (GOAT_DEV011).