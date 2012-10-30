# Script Variables
$default_sublime_packages_path = "W:\LiberKey\MyApps\Sublime Text 2\Data\Packages"
# http://stackoverflow.com/questions/10484192/powershell-browse-for-folder-a-better-way-to-do-this
#Functions
Function Create-Settings {
  Write-Output "{" > "tmp_prefs.sublime-settings"
  Get-Content "preferences\Preferences.sublime-settings" >> "tmp_prefs.sublime-settings"
  Get-Content "windows\Preferences.sublime-settings" >> "tmp_prefs.sublime-settings"
  Write-Output "}" >> "tmp_prefs.sublime-settings"
  $path = $sublime_packages_path+"\User\Preferences.sublime-settings"
  $my_file = Get-Content "tmp_prefs.sublime-settings"
  [System.IO.File]::WriteAllLines($path , $my_file )
  Remove-Item "tmp_prefs.sublime-settings"
}

Function Get-Value ( $file , $name ) {
  Get-Content $file | %{ $a = $_.Split(':'); if ($a[0] -eq $name) { Write-Output $a[1]; } }
}

# Script Start
Get-Value "messages_en" "welcome_message" #"This is a script to install some sublime packages, snippets and settings."
Get-Value "messages_en" "package_question"
$continue =  Read-Host "Do you want to install the settings file? [Yes to continue, no to abort]"
if ($continue -ne "Yes" -and $continue -ne "Y" -and $continue-ne "y") {
  Write-Output "Aborting"
  Exit-PSSession
}
$sublime_packages_path = Read-Host "Where is your sublime Packages path? [$default_sublime_packages_path]"
if ($sublime_packages_path -eq "") {
  $sublime_packages_path = $default_sublime_packages_path
}
Create-Settings

