powershell -Command ^
"while ($true) {^
    Clear-Host;^
    Get-Content -Path '../user/superbmark.store.json';^
    Start-Sleep -Seconds 2^
}"