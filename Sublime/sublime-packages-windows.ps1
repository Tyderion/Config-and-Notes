$default_sublime_packages_path = "W:\LiberKey\MyApps\Sublime Text 2\Data\Packages"
Function create_settings {
  Write-Output "{" > "tmp_prefs.sublime-settings"
  Get-Content "preferences\Preferences.sublime-settings" >> "tmp_prefs.sublime-settings"
  Get-Content "windows\Preferences.sublime-settings" >> "tmp_prefs.sublime-settings"
  Write-Output "}" >> "tmp_prefs.sublime-settings"
  Get-Content "tmp_prefs.sublime-settings" > $sublime_packages_path"\User\Preferences.sublime-settings"
  rm "tmp_prefs.sublime-settings"
}


Write-Output "This is a script to install some sublime packages, snippets and settings."
$continue =  Read-Host "Do you want to install the settings file? [Yes to continue, no to abort]"
if ($continue -ne "Yes" -and $continue -ne "Y" -and $continue-ne "y") {
  Write-Output "Aborting"
  Exit-PSSession
}
$sublime_packages_path = Read-Host "Where is your sublime Packages path? [$default_sublime_packages_path]"
if ($sublime_packages_path -eq "") {
  $sublime_packages_path = $default_sublime_packages_path
}
create_settings

