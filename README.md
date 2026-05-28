# VirtualBox VM Watchdog

Este é um projeto simples de automação para monitorar e manter online a máquina virtual do **Home Assistant** (ou qualquer outra VM) rodando no VirtualBox. O sistema roda 100% em segundo plano, gera uma página web (Dashboard) para acompanhamento em tempo real e mantém um histórico de eventos (Logs).

---

## 📂 Estrutura do Projeto

Para o funcionamento correto, coloque os seguintes arquivos dentro da **mesma pasta**:

* `vbox-vm-watchdog.ps1`: O cérebro do monitoramento (PowerShell).
* `start.vbs`: O inicializador que esconde a janela do terminal (VBScript).
* `dashboard.html`: O painel moderno gerado automaticamente para ver no navegador.
* `log.txt`: O histórico de inicializações e quedas da VM gerado automaticamente.

---

## 🛠️ Como Usar

1. Certifique-se de que o nome da sua VM no VirtualBox e o IP correspondente estão configurados corretamente no topo do arquivo `vbox-vm-watchdog.ps1`.
2. Para iniciar o monitoramento, dê **dois cliques no arquivo `Start.vbs`**.
3. Nenhuma janela vai se abrir, mas o script já estará trabalhando nas sombras.
4. Abra o arquivo `dashboard.html` no seu navegador padrão para acompanhar o status e a última checagem!

---

## 🛑 Como Parar o Monitoramento

Como o script roda de forma invisível, se você precisar pará-lo para manutenção ou para alterar alguma configuração, faça o seguinte:

1. Pressione **`Ctrl + Shift + Esc`** para abrir o **Gerenciador de Tarefas** do Windows.
2. Na aba de Processos, procure por **Windows PowerShell**.
3. Clique com o botão direito em cima dele e selecione **Finalizar Tarefa**.