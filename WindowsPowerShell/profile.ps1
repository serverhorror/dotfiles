# Contains AI-generated code
# MODEL USED: GPT-5.4

# $PROFILE.CurrentUserAllHosts

function prompt {
  $currentPath = (Get-Location).Path
  # trim it down to ~/...
  if ("$currentPath" -like "$HOME*") {
    $currentPath = "~" + $currentPath.Substring($HOME.Length)
  }

  return "$currentPath$('>' * ($nestedPromptLevel + 1)) "
}
