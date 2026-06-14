Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("C:\Users\USER\.gemini\antigravity\brain\2d3f5198-1c20-4297-a36c-6149f6cbac8e\media__1781268320848.png")
$bmp = new-object System.Drawing.Bitmap($img)
$colors = @{}

for ($x = 0; $x -lt $bmp.Width; $x += 1) {
    for ($y = 0; $y -lt $bmp.Height; $y += 1) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -lt 200 -and $c.G -lt 200 -and $c.B -lt 200) {
            $hex = "{0:X2}{1:X2}{2:X2}" -f $c.R, $c.G, $c.B
            $colors[$hex]++
        }
    }
}

$colors.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5
