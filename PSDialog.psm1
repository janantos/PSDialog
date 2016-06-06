function _dialogIsPSConsole(){
if(($host.Name -match 'consolehost')) {return $true}else{Write-host "Not running in PowerShell Console..."; return $false}
}

function _dialogDrawBox($width, $height)
{
[Console]::Clear()
#[Console]::SetBufferSize($Host.UI.RawUI.WindowSize.Width,$Host.UI.RawUI.WindowSize.Height)
[Console]::CursorVisible = $true

$originalBackgroundcolor = $Host.UI.RawUI.Backgroundcolor
$originalForegroundcolor = $Host.UI.RawUI.Foregroundcolor



$bufferWidth = $host.ui.rawui.BufferSize.Width
$bufferHeight = $host.ui.rawui.BufferSize.Height

$jj = [math]::Round(($Host.UI.RawUI.WindowSize.Width - $width)/2)
$ii = [math]::Round(($Host.UI.RawUI.WindowSize.Height - $height)/2)
$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $jj,$ii
$chr = "┌"
$Host.UI.Write($chr)
$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+$width),$ii
$chr = "┐"
$Host.UI.Write($chr)
$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $jj,$($ii+$height)
$chr="└"
$Host.UI.Write($chr)
$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+$width),$($ii+$height)
$chr="┘"
$Host.UI.Write($chr)
$chr = "─"
for($x=1; $x -lt $width; $x++){
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+$x),$ii
    $Host.UI.Write($chr)
}
for($x=1; $x -lt $width; $x++){
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+$x),$($ii+$height)
    $Host.UI.Write($chr)
}
$chr = "│"
for($x=1; $x -lt $height; $x++){
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $jj,$($ii+$x)
    $Host.UI.Write($chr)
}
for($x=1; $x -lt $height; $x++){
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+$width),$($ii+$x)
    $Host.UI.Write($chr)
}
$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $jj,$($ii+2)
$chr="├"
$Host.UI.Write($chr)
$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+$width),$($ii+2)
$chr="┤"
$Host.UI.Write($chr)
$chr = "─"
for($x=1; $x -lt $width; $x++){
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+$x),$($ii+2)
    $Host.UI.Write($chr)
}

}


function dialogTextBox($title, $text, $width, $height)
{

if(!$(_dialogIsPSConsole)){return $null}

$jj = [math]::Round(($Host.UI.RawUI.WindowSize.Width - $width)/2)
$ii = [math]::Round(($Host.UI.RawUI.WindowSize.Height - $height)/2)
$originalBackgroundcolor = $Host.UI.RawUI.Backgroundcolor
$originalForegroundcolor = $Host.UI.RawUI.Foregroundcolor



$words = $text.Split(' ')
$textlines = @()
$sb = New-Object -TypeName System.Text.StringBuilder

$maxlinelen = $width-4
$blankline = " "*$maxlinelen


$words.Count

for($x = 0; $x -le $words.Count; $x++) {
    $wordlen=$words[$x].Length
    if($($sb.Length+$wordlen+1) -le $maxlinelen) {
        if($x -ne 0) { $null = $sb.Append(" ") }
        $null = $sb.Append($words[$x])
        
    }
    else {
        $textlines += $sb.ToString()
        
        $null = $sb.Clear()
        $null = $sb.Append($words[$x])
    } 
}

$textlines += $sb.ToString()


$escenter = 13, 27
$position = 0
[Console]::Clear()
_dialogDrawBox $width $height
$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+1)
$Host.UI.Write($title.Substring(0,$(if($title.Length -gt $width-2){$($width-2)}else{$title.Length})))
$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj-10+$width),$($ii-1+$height)

$Host.UI.RawUI.Backgroundcolor = "Yellow"
$Host.UI.RawUI.Foregroundcolor = "Black"
$Host.UI.Write("[   OK   ]")
$Host.UI.RawUI.Backgroundcolor = $originalBackgroundcolor
$Host.UI.RawUI.Foregroundcolor = $originalForegroundcolor

while($escenter -notcontains $keypress.VirtualKeyCode){
    if($keypress.VirtualKeyCode -eq 38 -and $position -ne 0){
         $position-- 
    }
          
    if($keypress.VirtualKeyCode -eq 40 -and $position -ne $textlines.Count-1){
        $position++
        
    }
    
    for($i = 0; $i -lt $height-5; $i++) {
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$i)
        Write-Host $blankline
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$i)
        Write-Host $textlines[$($position+$i)]
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+$width-1), $($ii+3+$i)
        
        if ([math]::Round($position/($textlines.Count/($height-6))) -eq $i) {
            Write-Host "*"
        } else {
            Write-Host "│"
        }
    }
    
    $keypress = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
}







[Console]::Clear()
[Console]::CursorVisible = $true
}


function dialogInfoBox($title, $text, $width, $height)
{

if(!$(_dialogIsPSConsole)){return $null}

$jj = [math]::Round(($Host.UI.RawUI.WindowSize.Width - $width)/2)
$ii = [math]::Round(($Host.UI.RawUI.WindowSize.Height - $height)/2)
$originalBackgroundcolor = $Host.UI.RawUI.Backgroundcolor
$originalForegroundcolor = $Host.UI.RawUI.Foregroundcolor



$words = $text.Split(' ')
$textlines = @()
$sb = New-Object -TypeName System.Text.StringBuilder

$maxlinelen = $width-4
$blankline = " "*$maxlinelen


$words.Count

for($x = 0; $x -le $words.Count; $x++) {
    $wordlen=$words[$x].Length
    if($($sb.Length+$wordlen+1) -le $maxlinelen) {
        if($x -ne 0) { $null = $sb.Append(" ") }
        $null = $sb.Append($words[$x])
        
    }
    else {
        $textlines += $sb.ToString()
        
        $null = $sb.Clear()
        $null = $sb.Append($words[$x])
    } 
}

$textlines += $sb.ToString()

[Console]::Clear()
_dialogDrawBox $width $height
$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+1)

$Host.UI.Write($title.Substring(0,$(if($title.Length -gt $width-2){$($width-2)}else{$title.Length})))

    
    for($i = 0; $i -lt $height-3; $i++) {
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$i)
        Write-Host $blankline
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$i)
        Write-Host $textlines[$i]
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+$width-1), $($ii+3+$i)
    }
    

[Console]::CursorVisible = $true
}



function dialogInputBox($title, $width, $height)
{
if(!$(_dialogIsPSConsole)){return $null}
_dialogDrawBox $width $height

$jj = [math]::Round(($Host.UI.RawUI.WindowSize.Width - $width)/2)
$ii = [math]::Round(($Host.UI.RawUI.WindowSize.Height - $height)/2)
$originalBackgroundcolor = $Host.UI.RawUI.Backgroundcolor
$originalForegroundcolor = $Host.UI.RawUI.Foregroundcolor

$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+1)
$Host.UI.Write($title.Substring(0,$(if($title.Length -gt $width-2){$($width-2)}else{$title.Length})))


$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj-6+$width),$($ii-1+$height)

$Host.UI.RawUI.Backgroundcolor = "Yellow"
$Host.UI.RawUI.Foregroundcolor = "Black"
$Host.UI.Write("[ OK ]")
$Host.UI.RawUI.Backgroundcolor = $originalBackgroundcolor
$Host.UI.RawUI.Foregroundcolor = $originalForegroundcolor

$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3)
$returnValue = Read-Host 

[Console]::Clear()

return $returnValue
}



function dialogInputPasswordBox($title, $width, $height)
{
if(!$(_dialogIsPSConsole)){return $null}

while ($Host.UI.RawUI.KeyAvailable) {
    $Host.UI.RawUI.ReadKey() | Out-Null
}

_dialogDrawBox $width $height

$jj = [math]::Round(($Host.UI.RawUI.WindowSize.Width - $width)/2)
$ii = [math]::Round(($Host.UI.RawUI.WindowSize.Height - $height)/2)
$originalBackgroundcolor = $Host.UI.RawUI.Backgroundcolor
$originalForegroundcolor = $Host.UI.RawUI.Foregroundcolor

$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+1)
$Host.UI.Write($title.Substring(0,$(if($title.Length -gt $width-2){$($width-2)}else{$title.Length})))


$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj-6+$width),$($ii-1+$height)

$Host.UI.RawUI.Backgroundcolor = "Yellow"
$Host.UI.RawUI.Foregroundcolor = "Black"
$Host.UI.Write("[ OK ]")
$Host.UI.RawUI.Backgroundcolor = $originalBackgroundcolor
$Host.UI.RawUI.Foregroundcolor = $originalForegroundcolor

$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3)


$sb = New-Object -TypeName System.Text.StringBuilder


$escenter = 13, 27
$escenterbs = 13, 27, 8

while($escenter -notcontains $keypress.VirtualKeyCode){
    $keypress = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
    if($escenterbs -notcontains $keypress.VirtualKeyCode) {
        $null = $sb.Append($keypress.Character)
        }
    if($keypress.VirtualKeyCode -eq 8 -and $sb.Length -gt 0){
        $null = $sb.Remove($sb.Length-1,1)
    }
}


if($sb -ne $null){
    $returnValue = $sb.ToString() | ConvertTo-SecureString -AsPlainText -Force
}
[Console]::Clear()

return $returnValue
} 


function dialogMenuBox($title, $items, $width, $height)
{
if(!$(_dialogIsPSConsole)){return $null}

while ($Host.UI.RawUI.KeyAvailable) {
    $Host.UI.RawUI.ReadKey() | Out-Null
}

_dialogDrawBox $width $height

$jj = [math]::Round(($Host.UI.RawUI.WindowSize.Width - $width)/2)
$ii = [math]::Round(($Host.UI.RawUI.WindowSize.Height - $height)/2)
$originalBackgroundcolor = $Host.UI.RawUI.Backgroundcolor
$originalForegroundcolor = $Host.UI.RawUI.Foregroundcolor

$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+1)
$Host.UI.Write($title.Substring(0,$(if($title.Length -gt $width-2){$($width-2)}else{$title.Length})))


$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj-6+$width),$($ii-1+$height)

$Host.UI.RawUI.Backgroundcolor = "Yellow"
$Host.UI.RawUI.Foregroundcolor = "Black"
$Host.UI.Write("[ OK ]")
$Host.UI.RawUI.Backgroundcolor = $originalBackgroundcolor
$Host.UI.RawUI.Foregroundcolor = $originalForegroundcolor


$maxlinelen = $width-4
$blankline = " "*$maxlinelen

$escenter = 13, 27

$selecteditemindex = 0

while($escenter -notcontains $keypress.VirtualKeyCode){
    #[Console]::Clear()
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3)
    for($i = 0; $i -lt $height-5; $i++) {
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$i)
        Write-Host $blankline
    }

    If($($items.Values).Count -gt $height-5)
    {
    for($x = $selecteditemindex; $x -lt $selecteditemindex+$height-5; $x++){
            
                
                if($x -eq $selecteditemindex){
                    #$curY = $Host.UI.RawUI.CursorPosition.Y
                    
                    if($x -lt $($items.Values).Count) {
                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$x-$selecteditemindex)
                        Write-Host $blankline
                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$x-$selecteditemindex)
                        Write-Host -ForegroundColor Black -BackgroundColor Yellow $($items.Values).Item($x)
                    }
                }
                if($x -ne $selecteditemindex){
                    #$curY = $Host.UI.RawUI.CursorPosition.Y
                    if($x -lt $($items.Values).Count) {
                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$x-$selecteditemindex)
                        Write-Host $blankline
                        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$x-$selecteditemindex)
                        Write-Host -ForegroundColor White -BackgroundColor DarkMagenta $($items.Values).Item($x)
                    }
                }
                

              
    }
    } else {
    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3)
    for($x = 0; $x -lt $items.Keys.Count; $x++){
            $curY = $Host.UI.RawUI.CursorPosition.Y
            if($x -eq $selecteditemindex){
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $curY
                Write-Host -ForegroundColor Black -BackgroundColor Yellow $($items.Values).Item($x)
            }
            if($x -ne $selecteditemindex){
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $curY
                Write-Host -ForegroundColor White -BackgroundColor DarkMagenta $($items.Values).Item($x)
            }    
    }      
    }
   
    $keypress = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  
    
    if($keypress.VirtualKeyCode -eq 38 -and $selecteditemindex -ne 0){
         $selecteditemindex-- 
    }
        
  
    if($keypress.VirtualKeyCode -eq 40 -and $selecteditemindex -ne $items.Keys.Count-1){
        $selecteditemindex++
        
    }


}

[Console]::Clear()

if ($keypress.VirtualKeyCode -eq 13){
    return $($items.Keys).Item($selecteditemindex)
}else {
    return $null
}
}


function dialogMultiselectBox($title, $items, $width, $height)
{
if(!$(_dialogIsPSConsole)){return $null}

while ($Host.UI.RawUI.KeyAvailable) {
    $Host.UI.RawUI.ReadKey() | Out-Null
}

_dialogDrawBox $width $height

$jj = [math]::Round(($Host.UI.RawUI.WindowSize.Width - $width)/2)
$ii = [math]::Round(($Host.UI.RawUI.WindowSize.Height - $height)/2)
$originalBackgroundcolor = $Host.UI.RawUI.Backgroundcolor
$originalForegroundcolor = $Host.UI.RawUI.Foregroundcolor

$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+1)
$Host.UI.Write($title.Substring(0,$(if($title.Length -gt $width-2){$($width-2)}else{$title.Length})))


$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj-6+$width),$($ii-1+$height)

$Host.UI.RawUI.Backgroundcolor = "Yellow"
$Host.UI.RawUI.Foregroundcolor = "Black"
$Host.UI.Write("[ OK ]")
$Host.UI.RawUI.Backgroundcolor = $originalBackgroundcolor
$Host.UI.RawUI.Foregroundcolor = $originalForegroundcolor

$maxlinelen = $width-4
$blankline = " "*$maxlinelen

$itemsselection = [ordered]@{}
for ($y = 0; $y -ne $items.Keys.Count; $y++) {
    $itemsselection.Add($($items.Keys).Item($y), $false)
}



$escenter = 13, 27

$selecteditemindex = 0

while($escenter -notcontains $keypress.VirtualKeyCode){
#    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3)

    If($($items.Values).Count -gt $height-5)
    {
        for($i = 0; $i -lt $height-5; $i++) {
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$i)
            Write-Host $blankline
        }
        for($x = $selecteditemindex; $x -lt $selecteditemindex+$height-5; $x++){
            if($x -lt $($items.Values).Count) {           

                if($x -eq $selecteditemindex){
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$x-$selecteditemindex)
                    if ($($itemsselection.Values).Item($x) -eq $false) {
                        Write-Host -ForegroundColor Black -BackgroundColor Yellow "[ ]" $($items.Values).Item($x).Substring(0,$(if($($items.Values).Item($x).Length -gt $width-5){$($width-5)}else{$($items.Values).Item($x).Length}))
                    }
                    if ($($itemsselection.Values).Item($x) -eq $true) {
                        Write-Host -ForegroundColor Black -BackgroundColor Yellow "[x]" $($items.Values).Item($x).Substring(0,$(if($($items.Values).Item($x).Length -gt $width-5){$($width-5)}else{$($items.Values).Item($x).Length}))
                    }
                }
                if($x -ne $selecteditemindex){
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$x-$selecteditemindex)
                    if ($($itemsselection.Values).Item($x) -eq $false) {
                        Write-Host -ForegroundColor White -BackgroundColor DarkMagenta "[ ]" $($items.Values).Item($x).Substring(0,$(if($($items.Values).Item($x).Length -gt $width-5){$($width-5)}else{$($items.Values).Item($x).Length}))
                    }
                    if ($($itemsselection.Values).Item($x) -eq $true) {
                        Write-Host -ForegroundColor White -BackgroundColor DarkMagenta "[x]" $($items.Values).Item($x).Substring(0,$(if($($items.Values).Item($x).Length -gt $width-5){$($width-5)}else{$($items.Values).Item($x).Length}))
                    }
                }
            }    
        }    
    } else {
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3)
        for($x = 0; $x -lt $items.Keys.Count; $x++){
            $curY = $Host.UI.RawUI.CursorPosition.Y
            if($x -eq $selecteditemindex){
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $curY
                if ($($itemsselection.Values).Item($x) -eq $false) {
                        Write-Host -ForegroundColor Black -BackgroundColor Yellow "[ ]" $($items.Values).Item($x)
                }
                if ($($itemsselection.Values).Item($x) -eq $true) {
                    Write-Host -ForegroundColor Black -BackgroundColor Yellow "[x]" $($items.Values).Item($x)
                }
            }
            if($x -ne $selecteditemindex){
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $curY
                if ($($itemsselection.Values).Item($x) -eq $false) {
                    Write-Host -ForegroundColor White -BackgroundColor DarkMagenta "[ ]" $($items.Values).Item($x)
                }
                if ($($itemsselection.Values).Item($x) -eq $true) {
                    Write-Host -ForegroundColor White -BackgroundColor DarkMagenta "[x]" $($items.Values).Item($x)
                }
            }    
        } 
    }
   
    $keypress = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  
    
    if($keypress.VirtualKeyCode -eq 38 -and $selecteditemindex -ne 0){
         $selecteditemindex-- 
    }
        
  
    if($keypress.VirtualKeyCode -eq 40 -and $selecteditemindex -ne $items.Keys.Count-1){
        $selecteditemindex++
        
    }

    if($keypress.VirtualKeyCode -eq 32 ){
        $itemsselection[$selecteditemindex] = !$itemsselection[$selecteditemindex]
        
    }

}
[Console]::Clear()
if ($keypress.VirtualKeyCode -eq 13){
    return $itemsselection
} else {
    return $null
}
}


function dialogConfirmationTextBox($title, $text, $width, $height, $ok)
{

if(!$(_dialogIsPSConsole)){return $null}

$jj = [math]::Round(($Host.UI.RawUI.WindowSize.Width - $width)/2)
$ii = [math]::Round(($Host.UI.RawUI.WindowSize.Height - $height)/2)
$originalBackgroundcolor = $Host.UI.RawUI.Backgroundcolor
$originalForegroundcolor = $Host.UI.RawUI.Foregroundcolor



$words = $text.Split(' ')
$textlines = @()
$sb = New-Object -TypeName System.Text.StringBuilder

$maxlinelen = $width-4
$blankline = " "*$maxlinelen



for($x = 0; $x -le $words.Count; $x++) {
    $wordlen=$words[$x].Length
    if($($sb.Length+$wordlen+1) -le $maxlinelen) {
        if($x -ne 0) { $null = $sb.Append(" ") }
        $null = $sb.Append($words[$x])
        
    }
    else {
        $textlines += $sb.ToString()
        
        $null = $sb.Clear()
        $null = $sb.Append($words[$x])
    } 
}

$textlines += $sb.ToString()

$esc = 27
$escenter = 13, 27
$enter = 13
$position = 0


[Console]::Clear()
_dialogDrawBox $width $height
$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+1)
$Host.UI.Write($title.Substring(0,$(if($title.Length -gt $width-2){$($width-2)}else{$title.Length})))
$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj-10+$width),$($ii-1+$height)

if($ok -eq $true){
    $Host.UI.RawUI.Backgroundcolor = "Yellow"
    $Host.UI.RawUI.Foregroundcolor = "Black"
} else {
    $Host.UI.RawUI.Backgroundcolor = "Gray"
    $Host.UI.RawUI.Foregroundcolor = "Black"
}
$Host.UI.Write("[   OK   ]")
$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj-21+$width),$($ii-1+$height)


if($ok -ne $true){
    $Host.UI.RawUI.Backgroundcolor = "Yellow"
    $Host.UI.RawUI.Foregroundcolor = "Black"
} else {
    $Host.UI.RawUI.Backgroundcolor = "Gray"
    $Host.UI.RawUI.Foregroundcolor = "Black"
}

$Host.UI.Write("[ Cancel ]")

$Host.UI.RawUI.Backgroundcolor = $originalBackgroundcolor
$Host.UI.RawUI.Foregroundcolor = $originalForegroundcolor

while($enter -notcontains $keypress.VirtualKeyCode){
    if($keypress.VirtualKeyCode -eq 38 -and $position -ne 0){
         $position-- 
    }
          
    if($keypress.VirtualKeyCode -eq 40 -and $position -ne $textlines.Count-1){
        $position++
        
    }

    if($keypress.VirtualKeyCode -eq 9){
        [bool]$ok = ![bool]$ok
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj-10+$width),$($ii-1+$height)

        if($ok -eq $true){
            $Host.UI.RawUI.Backgroundcolor = "Yellow"
            $Host.UI.RawUI.Foregroundcolor = "Black"
        } else {
            $Host.UI.RawUI.Backgroundcolor = "Gray"
            $Host.UI.RawUI.Foregroundcolor = "Black"
        }
        $Host.UI.Write("[   OK   ]")
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj-21+$width),$($ii-1+$height)
        
        
        if($ok -ne $true){
            $Host.UI.RawUI.Backgroundcolor = "Yellow"
            $Host.UI.RawUI.Foregroundcolor = "Black"
        } else {
            $Host.UI.RawUI.Backgroundcolor = "Gray"
            $Host.UI.RawUI.Foregroundcolor = "Black"
        }
        
        $Host.UI.Write("[ Cancel ]")
        $Host.UI.RawUI.Backgroundcolor = $originalBackgroundcolor
        $Host.UI.RawUI.Foregroundcolor = $originalForegroundcolor
        
    }
    if($keypress.VirtualKeyCode -eq 38 -or $keypress.VirtualKeyCode -eq 40 -or $keypress.VirtualKeyCode -eq $null){
    
    for($i = 0; $i -lt $height-5; $i++) {
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$i)
        Write-Host $blankline
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$i)
        Write-Host $textlines[$($position+$i)]
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+$width-1), $($ii+3+$i)
        
        if ([math]::Round($position/($textlines.Count/($height-6))) -eq $i) {
            Write-Host "*"
        } else {
            Write-Host "│"
        }
    }
    }
   
    $keypress = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
}







$null = [Console]::Clear()
$null = [Console]::CursorVisible = $true
return $ok
}

function dialogRadioButtonBox($title, $items, $width, $height)
{
if(!$(_dialogIsPSConsole)){return $null}

while ($Host.UI.RawUI.KeyAvailable) {
    $Host.UI.RawUI.ReadKey() | Out-Null
}

_dialogDrawBox $width $height

$jj = [math]::Round(($Host.UI.RawUI.WindowSize.Width - $width)/2)
$ii = [math]::Round(($Host.UI.RawUI.WindowSize.Height - $height)/2)
$originalBackgroundcolor = $Host.UI.RawUI.Backgroundcolor
$originalForegroundcolor = $Host.UI.RawUI.Foregroundcolor

$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+1)
$Host.UI.Write($title.Substring(0,$(if($title.Length -gt $width-2){$($width-2)}else{$title.Length})))


$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj-6+$width),$($ii-1+$height)

$Host.UI.RawUI.Backgroundcolor = "Yellow"
$Host.UI.RawUI.Foregroundcolor = "Black"
$Host.UI.Write("[ OK ]")
$Host.UI.RawUI.Backgroundcolor = $originalBackgroundcolor
$Host.UI.RawUI.Foregroundcolor = $originalForegroundcolor

$maxlinelen = $width-4
$blankline = " "*$maxlinelen

$itemsselection = [ordered]@{}
for ($y = 0; $y -ne $items.Keys.Count; $y++) {
    $itemsselection.Add($($items.Keys).Item($y), $false)
}



$escenter = 13, 27

$selecteditemindex = 0

while($escenter -notcontains $keypress.VirtualKeyCode){
#    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3)

If($($items.Values).Count -gt $height-5)
    {
        for($i = 0; $i -lt $height-5; $i++) {
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$i)
            Write-Host $blankline
        }
        for($x = $selecteditemindex; $x -lt $selecteditemindex+$height-5; $x++){
            if($x -lt $($items.Values).Count) {           

                if($x -eq $selecteditemindex){
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$x-$selecteditemindex)
                    if ($($itemsselection.Values).Item($x) -eq $false) {
                        Write-Host -ForegroundColor Black -BackgroundColor Yellow "( )" $($items.Values).Item($x)
                    }
                    if ($($itemsselection.Values).Item($x) -eq $true) {
                        Write-Host -ForegroundColor Black -BackgroundColor Yellow "(*)" $($items.Values).Item($x)
                    }
                }
                if($x -ne $selecteditemindex){
                    $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3+$x-$selecteditemindex)
                    if ($($itemsselection.Values).Item($x) -eq $false) {
                        Write-Host -ForegroundColor White -BackgroundColor DarkMagenta "( )" $($items.Values).Item($x)
                    }
                    if ($($itemsselection.Values).Item($x) -eq $true) {
                        Write-Host -ForegroundColor White -BackgroundColor DarkMagenta "(*)" $($items.Values).Item($x)
                    }
                }
            }    
        }    
    } else {
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $($ii+3)
        for($x = 0; $x -lt $items.Keys.Count; $x++){
            $curY = $Host.UI.RawUI.CursorPosition.Y
            if($x -eq $selecteditemindex){
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $curY
                if ($($itemsselection.Values).Item($x) -eq $false) {
                        Write-Host -ForegroundColor Black -BackgroundColor Yellow "( )" $($items.Values).Item($x)
                }
                if ($($itemsselection.Values).Item($x) -eq $true) {
                    Write-Host -ForegroundColor Black -BackgroundColor Yellow "(*)" $($items.Values).Item($x)
                }
            }
            if($x -ne $selecteditemindex){
                $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $($jj+1), $curY
                if ($($itemsselection.Values).Item($x) -eq $false) {
                    Write-Host -ForegroundColor White -BackgroundColor DarkMagenta "( )" $($items.Values).Item($x)
                }
                if ($($itemsselection.Values).Item($x) -eq $true) {
                    Write-Host -ForegroundColor White -BackgroundColor DarkMagenta "(*)" $($items.Values).Item($x)
                }
            }    
        } 
    }    

   
    $keypress = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  
    
    if($keypress.VirtualKeyCode -eq 38 -and $selecteditemindex -ne 0){
         $selecteditemindex-- 
    }
        
  
    if($keypress.VirtualKeyCode -eq 40 -and $selecteditemindex -ne $items.Keys.Count-1){
        $selecteditemindex++
        
    }

    if($keypress.VirtualKeyCode -eq 32 ){
        for($x=0;$x -lt $itemsselection.Count; $x++){$itemsselection[$x]=$false}
        $itemsselection[$selecteditemindex] = $true
        
    }

}
[Console]::Clear()
if ($keypress.VirtualKeyCode -eq 13){
    return $($itemsselection.keys)[$($itemsselection.Values).indexOf($true)]
} else {
    return $null
}
}


Export-ModuleMember -Function 'dialog*'


