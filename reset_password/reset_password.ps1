$Password = ConvertTo-SecureString "Wvbl12!@" -AsPlainText -Force  
$UserAccount = Get-LocalUser -Name "Alex"  
$UserAccount | Set-LocalUser -Password $Password