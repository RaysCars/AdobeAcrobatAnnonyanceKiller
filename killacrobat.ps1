$process = $process="acrotray","AcrobatNotificationClient","armsvc"
$services="AdobeARMservice","AGMService","AGSService" 

#stop processes and services
Get-Process $process -ErrorAction:SilentlyContinue | Stop-Process -Verbose
Get-Service $services | Stop-Service -Verbose
Get-Service $services | Set-Service -StartupType:Disabled   -Verbose

#ms office reg keys to remove for acrobat
$regkeys = "
   HKLM:\SOFTWARE\Microsoft\Office\Outlook\Addins\AdobeAcroOutlook.SendAsLink
   HKLM:\SOFTWARE\Microsoft\Office\Outlook\Addins\PDFMOutlook.PDFMOutlook
   HKCU:\SOFTWARE\Microsoft\Office\Outlook\AddIns\PDFMOutlook.PDFMOutlook
   HKCU:\SOFTWARE\Microsoft\Office\Outlook\AddIns\AdobeAcroOutlook.SendAsLink
   HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office\Outlook\Addins\PDFMOutlook.PDFMOutlook
   HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office\Outlook\Addins\AdobeAcroOutlook.SendAsLink
   HKLM:\SOFTWARE\Microsoft\Office\Excel\Addins\PDFMaker.OfficeAddin
   HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office\Excel\Addins\PDFMaker.OfficeAddin
   HKLM:\SOFTWARE\Microsoft\Office\PowerPoint\Addins\PDFMaker.OfficeAddin
   HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office\PowerPoint\Addins\PDFMaker.OfficeAddin
   HKLM:\SOFTWARE\Microsoft\Office\Word\Addins\PDFMaker.OfficeAddin
   HKCU:\SOFTWARE\Microsoft\Office\Word\Addins\PDFMaker.OfficeAddin
   HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office\Word\Addins\PDFMaker.OfficeAddin
   HKLM:\SOFTWARE\WOW6432Node\Microsoft\Active Setup\Installed Components\{AC76BA86-0000-0000-7760-7E8A45000000}
   HKLM:\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\Adobe.Acrobat.ContextMenu
   HKLM:\SOFTWARE\Classes\Folder\shellex\ContextMenuHandlers\Adobe.Acrobat.ContextMenu
   HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{F4971EE7-DAA0-4053-9964-665D8EE6A077}
   HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{AE7CD045-E861-484f-8273-0445EE161910}
   HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{F4971EE7-DAA0-4053-9964-665D8EE6A077}
   HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{F4971EE7-DAA0-4053-9964-665D8EE6A077}
   HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{AE7CD045-E861-484f-8273-0445EE161910}
".split("`n") | %  { $_.trim() } | ? { $_ } 

Remove-Item -LiteralPath $regkeys -ErrorAction:SilentlyContinue -Verbose

Remove-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "*Acrobat*"
Remove-ItemProperty -path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "Adobe*"
Remove-ItemProperty -path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" -Name "*Acrobat*"
Remove-ItemProperty -path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" -Name "Adobe*"
Remove-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Toolbar" -Name "Adobe*"
Remove-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Toolbar" -Name "*Acrobat*"
Remove-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Toolbar" -Name "{47833539-D0C5-4125-9FA8-0819E2EAAC93}"
Remove-ItemProperty -path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Toolbar" -Name "{47833539-D0C5-4125-9FA8-0819E2EAAC93}" -Verbose

Get-ScheduledTask -TaskName adobe*  | ? { $_ -match "Adobe|Acrobat" } | Disable-ScheduledTask

write-host -foreg yellow "`n pausing 5 seconds "
start-sleep 5  
