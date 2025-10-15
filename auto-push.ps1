# Auto-push script for continuous deployment
# This script watches for file changes and automatically commits and pushes them

Write-Host "🚀 Starting continuous push mode..." -ForegroundColor Green
Write-Host "📁 Watching directory: $(Get-Location)" -ForegroundColor Yellow
Write-Host "⚠️  Press Ctrl+C to stop" -ForegroundColor Red

$lastCommitTime = Get-Date

while ($true) {
    try {
        # Check if there are any changes
        $status = git status --porcelain 2>$null
        
        if ($status) {
            Write-Host "📝 Changes detected:" -ForegroundColor Cyan
            Write-Host $status -ForegroundColor White
            
            # Add all changes
            git add . 2>$null
            
            # Create commit with timestamp
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $commitMessage = "Auto-commit: $timestamp"
            
            git commit -m $commitMessage 2>$null
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Committed: $commitMessage" -ForegroundColor Green
                
                # Push to origin
                git push origin main 2>$null
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "🚀 Pushed to GitHub successfully" -ForegroundColor Green
                    $lastCommitTime = Get-Date
                } else {
                    Write-Host "❌ Failed to push to GitHub" -ForegroundColor Red
                }
            }
        }
        
        # Wait 10 seconds before checking again
        Start-Sleep -Seconds 10
        
    } catch {
        Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
        Start-Sleep -Seconds 5
    }
}
