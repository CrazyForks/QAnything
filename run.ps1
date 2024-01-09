# @echo off
# 转换文件格式
$content = Get-Content -Raw -Path .\scripts\run_for_local.sh -Encoding utf8
$content = $content -replace "`r`n", "`n"

# 移除文件结尾的空白字符
$content = $content -replace "\s+$"

$content | Set-Content -Path .\scripts\run_for_local.sh -Encoding utf8

# 判断Docker容器是否启动
$dockerStatus = Get-Service | Where-Object {$_.DisplayName -like '*Docker*'} | Select-Object -ExpandProperty Status

if ($dockerStatus -eq 'Running') {
    Write-Host "Docker is running."
} else {
    Write-Host "Docker is not run."
    return
}

# 启动 Docker 容器
docker-compose -f docker-compose-windows.yaml up qanything_local
