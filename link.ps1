$user_id = $env:USERNAME + "-" + $env:USERDOMAIN
$user_id = $user_id -ireplace "\W", "-"
git checkout -b $user_id

$url = "https://script.googleusercontent.com/macros/echo?user_content_key=vGMLE-RZCFsSCJc1w6158TqbM-Vf7h7kHBN7ZEzyE1OFCubKThUA0KIEaVHZh2PV2Hqyx_rRKieiYIk2ljOUVsajDLQ_l0Vum5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnOGBNwLEIyNeZObY2zAO6DMnMypMsqSSxgJBqHdLuB-AfLXWQrK_0f45RrrOtU29nwKQ8NpLbEBSbMa4fIQx_33eRgqRiMbZsw&lib=Mg37eTNQc0jY1NGm1GWiFViTmmKHkEHEC"
$csv = Invoke-RestMethod $url | ConvertFrom-Csv
$data = $csv | Where-Object { $_.windowspath.length -gt 0 }

function mklink {
    cmd /c mklink $args
}

$cwd = (Get-Location).Path
if (-not(test-path "./configs")) {
    mkdir configs
}
$configs = Join-Path $cwd "./configs"

$data | ForEach-Object {
    # write-output $_.id
    $target = Join-Path $configs $_.id

    if (Test-Path $_.windowspath) {
        $source = Resolve-Path $_.windowspath
        $obj = get-childitem $source
        while ($obj.LinkType -eq "SymbolicLink") {
            $source = $obj.Target
            $obj = get-childitem $source
        }

        if (Test-Path $target) {
            Remove-Item $target
        }

        mklink /h $target $source

    } elseif (Test-Path $target) {
        $source = $target
        $target = Split-Path $_.windowspath | Resolve-Path
        if (-not(test-path $target)) {
            mkdir $target -ea 0
        }
        mklink /h $target $source
    } else {
        Write-Output "Not found: " $_.id
    }
}

git add .
git commit -m "Update configs"
git push origin $user_id
git branch -u origin/$user_id