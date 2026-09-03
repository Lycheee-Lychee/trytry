# Launch post-reboot recovery inside Ubuntu WSL (run after Windows reboot).
$workspace = "C:\Users\Lychee\Desktop\跑跑"
Write-Host "Waiting for WSL..."
for ($i = 1; $i -le 30; $i++) {
    $out = wsl -d Ubuntu-22.04 -- echo ok 2>&1
    if ($LASTEXITCODE -eq 0 -and $out -match 'ok') {
        Write-Host "WSL ready."
        break
    }
    Start-Sleep -Seconds 5
}
Write-Host "Windows nvidia-smi:"
nvidia-smi
Write-Host "Starting recovery in WSL..."
wsl -d Ubuntu-22.04 -- bash -lc "chmod +x '/mnt/c/Users/Lychee/Desktop/跑跑/post_reboot_recovery.sh' && '/mnt/c/Users/Lychee/Desktop/跑跑/post_reboot_recovery.sh'"
