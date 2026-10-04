$ErrorActionPreference = 'SilentlyContinue'
$proof = Join-Path $env:USERPROFILE 'antigravity-project-browser-hook-host-proof.txt'
$self = Get-CimInstance Win32_Process -Filter ("ProcessId=$PID")
$parentPid = if ($self) { $self.ParentProcessId } else { 0 }
$parent = if ($parentPid) {
    (Get-CimInstance Win32_Process -Filter ("ProcessId=$parentPid")).Name
} else {
    'unknown'
}
if ([string]::IsNullOrWhiteSpace($parent)) { $parent = 'unknown' }
$integrity = (whoami.exe /groups | Select-String -SimpleMatch 'Mandatory Label' | Select-Object -First 1).Line
if ([string]::IsNullOrWhiteSpace($integrity)) { $integrity = 'unavailable' } else { $integrity = $integrity.Trim() }
$lines = @(
    'ANTIGRAVITY_PROJECT_BROWSER_HOOK_HOST_PROOF'
    "PID=$PID"
    "PPID=$parentPid"
    "PARENT=$parent"
    "USER=$([Environment]::UserDomainName)\$([Environment]::UserName)"
    "INTEGRITY=$integrity"
)
[IO.File]::WriteAllLines($proof, $lines)
Write-Output '{"injectSteps":[]}'
