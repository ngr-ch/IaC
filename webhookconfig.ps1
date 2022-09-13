$webhook = "webhookurl"



$payload = @{
    title = "$(Build.DefinitionName) completed ."
    text = "Review [Report]($Report)"
    themeColor = "Green"
}
Invoke-RestMethod -Method POST -Uri $webhook -Body ($payload | ConvertTo-Json -Depth 4) -ContentType 'application/json; charset=utf-8'
