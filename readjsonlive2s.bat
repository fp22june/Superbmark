powershell -Command ^
"while ($true) {^
    Clear-Host;^
    Get-Content -Path '../user/sigbk.store.json';^
    Start-Sleep -Seconds 2^
}"