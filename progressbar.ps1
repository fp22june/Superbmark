# adapted https://stackoverflow.com/a/72004427
param (
    [Parameter(Mandatory=$true)]
    [string]$VideoPath,
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$FFmpegArgs
)
$videoDuration = ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VideoPath"
$videoWidth = ffprobe -v quiet -select_streams v -show_entries stream=width -of csv=p=0:s=x "$VideoPath"
$videoHeight = ffprobe -v quiet -select_streams v -show_entries stream=height -of csv=p=0:s=x "$VideoPath"
$videoDuration = $videoDuration.Trim()
$videoWidth = $videoWidth.Trim()
$videoHeight = $videoHeight.Trim()
$barHeight = [math]::Floor(([int]$videoHeight / 100) +1)
$newHeight = [int]$videoHeight + $barHeight
$conv = ("pad=width=iw:height=${newHeight}:x=0:y=0:color=black[padded];" ,
        "color=c=#f44336@.7:s=${videoWidth}x${barHeight}[bar];",
        "[padded][bar]overlay=-w+(w/${videoDuration})*t:H-h:shortest=1"#,format=yuv420p"
        )-join ''
$out = "output.gif" 
$allArgs = @("-i", "$VideoPath"
            , "-filter_complex", "$conv"
            )
if ($FFmpegArgs) {
    $allArgs += $FFmpegArgs
}
$allArgs += "$out"
Write-Host "Running: ffmpeg $($allArgs -join ' ')"
& ffmpeg @allArgs