$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$maven = "C:\Users\Admin\AppData\Local\Programs\Apache\apache-maven-3.9.9\bin\mvn.cmd"
$tomcat = Join-Path $root "apache-tomcat-10.1.28"
$war = Join-Path $root "target\libman.war"
$deployedWar = Join-Path $tomcat "webapps\libman.war"
$authDll = Join-Path $root "native\mssql-jdbc_auth-12.8.1.x64.dll"

if (-not (Test-Path $maven)) {
    throw "Maven not found: $maven"
}
if (-not (Test-Path (Join-Path $tomcat "bin\startup.bat"))) {
    throw "Tomcat not found: $tomcat"
}
if (-not (Test-Path $authDll)) {
    throw "SQL Server authentication DLL not found: $authDll"
}

Push-Location $root
try {
    & $maven -q clean package
    if ($LASTEXITCODE -ne 0) {
        throw "Maven build failed."
    }
}
finally {
    Pop-Location
}

Copy-Item $war $deployedWar -Force

$portInUse = Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue
if (-not $portInUse) {
    $env:CATALINA_HOME = $tomcat
    $env:CATALINA_BASE = $tomcat
    $env:JAVA_OPTS = "-Djava.library.path=`"$root\native;$tomcat\bin`""
    Start-Process -FilePath $env:ComSpec `
        -ArgumentList @("/c", "call `"$tomcat\bin\startup.bat`"") `
        -WorkingDirectory $tomcat `
        -WindowStyle Hidden
}

$deadline = (Get-Date).AddSeconds(30)
do {
    Start-Sleep -Seconds 1
    try {
        $status = (Invoke-WebRequest -Uri "http://localhost:8080/libman/" -UseBasicParsing).StatusCode
    }
    catch {
        $status = 0
    }
} while ($status -ne 200 -and (Get-Date) -lt $deadline)

if ($status -ne 200) {
    throw "Tomcat did not respond at http://localhost:8080/libman/."
}

Write-Host "LibMan is running at http://localhost:8080/libman/"
