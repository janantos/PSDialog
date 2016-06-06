Import-Module .\PSDialog.psm1

# TextBox Example
# dialogTextBox $title  $text  $width  $height
$title = "TextBox Example"
$text  = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

dialogTextBox $title $text  30  20

# InfoBox Example
# dialogInfoBox $title  $text  $width  $height
$title = "TextBox Example"
$text  = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

dialogInfoBox $title $text  30  20
Start-Sleep -s 5
cls

# InputBox Example
# dialogInputBox $title $width $height
$title = "InputBox Example"
$x = dialogInputBox $title 30 6
$x
Start-Sleep -s 3

# InputPasswordBox Example
# dialogInputBox $title $width $height
$title = "InputPasswordBox Example"
$x = dialogInputPasswordBox $title 30 6
$x
Start-Sleep -s 3

# MenuBox Example
# dialogMenuBox $title $items $width $height
$title = "MenuBox Example"
$items = [ordered]@{"1" = "Item 1"; "2" = "Item 2"; "3" = "Item 3"; "4" = "Item 4"}
$x = dialogMenuBox $title $items 20 10
$x
Start-Sleep -s 3

# MultiselectBox Example
#dialogMultiselectBox $title $items $width $height
$title = "MultiselectBox Example"
$items = [ordered]@{"1" = "Item 1"; "2" = "Item 2"; "3" = "Item 3"; "4" = "Item 4"}
$x = dialogMultiselectBox $title $items 20 10
$x
Start-Sleep -s 3

# RadioButtonBox Example
# dialogRadioButtonBox $title $items $width $height
$title = "RadioButtonBox Example"
$items = [ordered]@{"1" = "Item 1"; "2" = "Item 2"; "3" = "Item 3"; "4" = "Item 4"}
$x = dialogRadioButtonBox $title $items 20 10
$x
Start-Sleep -s 3

# ConfirmationTextBox Example
# dialogConfirmationTextBox $title $text $width $height $ok
$title = "TextBox Example"
$text  = "Change buttom by TAB key and confirm by Enter key"
$x = dialogConfirmationTextBox $title $text 30 20 $true
$x
