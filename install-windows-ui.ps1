Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$PluginName = "boss-resume-agent-plugin"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourcePluginDir = Join-Path $Root "plugins\$PluginName"
$TargetPluginParent = Join-Path $HOME "plugins"
$TargetPluginDir = Join-Path $TargetPluginParent $PluginName
$MarketplaceDir = Join-Path $HOME ".agents\plugins"
$MarketplaceFile = Join-Path $MarketplaceDir "marketplace.json"

function Update-Marketplace {
    if (Test-Path $MarketplaceFile) {
        $raw = Get-Content -LiteralPath $MarketplaceFile -Raw -Encoding UTF8
        if ($raw.Trim().Length -gt 0) {
            $payload = $raw | ConvertFrom-Json
        } else {
            $payload = [pscustomobject]@{}
        }
    } else {
        $payload = [pscustomobject]@{}
    }

    if (-not ($payload.PSObject.Properties.Name -contains "name")) {
        $payload | Add-Member -MemberType NoteProperty -Name "name" -Value "personal"
    }
    if (-not ($payload.PSObject.Properties.Name -contains "interface") -or $null -eq $payload.interface) {
        $payload | Add-Member -MemberType NoteProperty -Name "interface" -Value ([pscustomobject]@{ displayName = "Personal" }) -Force
    }
    if (-not ($payload.interface.PSObject.Properties.Name -contains "displayName")) {
        $payload.interface | Add-Member -MemberType NoteProperty -Name "displayName" -Value "Personal"
    }
    if (-not ($payload.PSObject.Properties.Name -contains "plugins") -or $null -eq $payload.plugins) {
        $payload | Add-Member -MemberType NoteProperty -Name "plugins" -Value @() -Force
    }

    $entry = [pscustomobject]@{
        name = $PluginName
        source = [pscustomobject]@{
            source = "local"
            path = "./plugins/$PluginName"
        }
        policy = [pscustomobject]@{
            installation = "AVAILABLE"
            authentication = "ON_INSTALL"
        }
        category = "Productivity"
    }

    $plugins = @($payload.plugins | Where-Object { $_.name -ne $PluginName })
    $plugins += $entry
    $payload.plugins = $plugins

    New-Item -ItemType Directory -Force -Path $MarketplaceDir | Out-Null
    $payload | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $MarketplaceFile -Encoding UTF8
}

function Install-Plugin {
    if (-not (Test-Path $SourcePluginDir)) {
        throw "Cannot find plugin directory: $SourcePluginDir"
    }

    New-Item -ItemType Directory -Force -Path $TargetPluginParent | Out-Null
    if (Test-Path $TargetPluginDir) {
        Remove-Item -LiteralPath $TargetPluginDir -Recurse -Force
    }
    Copy-Item -LiteralPath $SourcePluginDir -Destination $TargetPluginDir -Recurse
    Update-Marketplace
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "BOSS Resume Agent Installer"
$form.Size = New-Object System.Drawing.Size(520, 300)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

$title = New-Object System.Windows.Forms.Label
$title.Text = "Install BOSS Resume Agent for Codex App"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$title.Location = New-Object System.Drawing.Point(24, 24)
$title.Size = New-Object System.Drawing.Size(460, 32)
$form.Controls.Add($title)

$body = New-Object System.Windows.Forms.Label
$body.Text = "This installer copies the plugin to your personal Codex plugin folder and updates your personal marketplace.json. After installation, restart Codex App, open Plugins, and choose Add to Codex."
$body.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$body.Location = New-Object System.Drawing.Point(26, 72)
$body.Size = New-Object System.Drawing.Size(450, 92)
$form.Controls.Add($body)

$status = New-Object System.Windows.Forms.Label
$status.Text = "Ready"
$status.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$status.Location = New-Object System.Drawing.Point(26, 172)
$status.Size = New-Object System.Drawing.Size(450, 24)
$form.Controls.Add($status)

$installButton = New-Object System.Windows.Forms.Button
$installButton.Text = "Install"
$installButton.Location = New-Object System.Drawing.Point(286, 210)
$installButton.Size = New-Object System.Drawing.Size(92, 32)
$installButton.Add_Click({
    try {
        $installButton.Enabled = $false
        $status.Text = "Installing..."
        Install-Plugin
        $status.Text = "Installed successfully"
        [System.Windows.Forms.MessageBox]::Show(
            "Installation complete.`n`nNext steps:`n1. Restart Codex App`n2. Open Plugins`n3. Add BOSS Resume Agent`n4. Start a new thread",
            "Installed",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        ) | Out-Null
    } catch {
        $status.Text = "Install failed"
        [System.Windows.Forms.MessageBox]::Show(
            $_.Exception.Message,
            "Install failed",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
    } finally {
        $installButton.Enabled = $true
    }
})
$form.Controls.Add($installButton)

$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = "Close"
$closeButton.Location = New-Object System.Drawing.Point(394, 210)
$closeButton.Size = New-Object System.Drawing.Size(92, 32)
$closeButton.Add_Click({ $form.Close() })
$form.Controls.Add($closeButton)

[void]$form.ShowDialog()
