# VirtualBox VM Watchdog

This is a simple automation project designed to monitor and keep the <strong>Home Assistant</strong> virtual machine (or any other VM) running on VirtualBox. The system runs <strong>100% in the background</strong>, generates a web page (<strong>Dashboard</strong>) for real-time monitoring, and keeps a history of events (<strong>Logs</strong>).

---

## 📂 Project Structure

For the system to work correctly, place the following files inside the <strong>same folder</strong>:

* <code>vbox-vm-watchdog.ps1</code>: The monitoring engine (PowerShell).
* <code>start.vbs</code>: The launcher that hides the terminal window (VBScript).
* <code>dashboard.html</code>: The modern dashboard automatically generated for viewing in a web browser.
* <code>log.txt</code>: The history of VM startups and failures, generated automatically.

---

## 🛠️ How to Use

1. Make sure your VM name in VirtualBox and its corresponding IP address are correctly configured at the top of the <code>vbox-vm-watchdog.ps1</code> file.
2. To start monitoring, <strong>double-click the <code>Start.vbs</code> file</strong>.
3. No window will appear, but the script will already be running in the background.
4. Open the <code>dashboard.html</code> file in your default browser to monitor the status and the last check!

---

## 🛑 How to Stop Monitoring

Since the script runs invisibly, if you need to stop it for maintenance or change a configuration, do the following:

1. Press <strong><code>Ctrl + Shift + Esc</code></strong> to open the Windows <strong>Task Manager</strong>.
2. In the Processes tab, look for <strong>Windows PowerShell</strong>.
3. Right-click it and select <strong>End Task</strong>.
