function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("Balanced","High performance","Power saver")]
		[System.String]
		$ActivePowerPlan
	)


$ActivePowerPlanObject = Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powerplan -Filter "IsActive = 'True'"

$ActivePowerPlanId = (Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powerplan -Filter "IsActive = 'True'").InstanceID.Replace('Microsoft:PowerPlan\','')

$SleepAfterSettingId = (Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powersetting -Filter "Elementname = 'Sleep After'").InstanceID.Replace('Microsoft:PowerSetting\','')

$SleepAfterOnACValue = Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powersettingdataindex -Filter "InstanceID like '%$ActivePowerPlanId%ac%$SleepAfterSettingId'"

$SleepAfterOnDCValue = Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powersettingdataindex -Filter "InstanceID like '%$ActivePowerPlanId%dc%$SleepAfterSettingId'"

$TurnOffDisplayAfterSettingId = (Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powersetting -Filter "Elementname = 'Turn Off Display After'").InstanceID.Replace('Microsoft:PowerSetting\','')

$TurnOffDisplayAfterSettingOnACValue = Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powersettingdataindex -Filter "InstanceID like '%$ActivePowerPlanId%ac%$TurnOffDisplayAfterSettingId'"

$TurnOffDisplayAfterSettingOnDCValue = Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powersettingdataindex -Filter "InstanceID like '%$ActivePowerPlanId%dc%$TurnOffDisplayAfterSettingId'"



	
	$returnValue = @{
		ActivePowerPlan = $ActivePowerPlanObject.ElementName
		SleepAfterOnAC = ($SleepAfterOnACValue.SettingIndexValue/60)
		SleepAfterOnDC = ($SleepAfterOnDCValue.SettingIndexValue/60)
		TurnOffDisplayAfterOnAC = ($TurnOffDisplayAfterSettingOnACValue.SettingIndexValue/60)
		TurnOffDisplayAfterOnDC = ($TurnOffDisplayAfterSettingOnDCValue.SettingIndexValue/60)
	}

	$returnValue
	
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("Balanced","High performance","Power saver")]
		[System.String]
		$ActivePowerPlan,

		[System.String]
		$SleepAfterOnAC,

		[System.String]
		$SleepAfterOnDC,

		[System.String]
		$TurnOffDisplayAfterOnAC,

		[System.String]
		$TurnOffDisplayAfterOnDC
	)


#region PowerPlan


$ActivePowerPlanObject = Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powerplan -Filter "IsActive = 'True'"

if ($ActivePowerPlanObject.ElementName -ne $ActivePowerPlan) {

$null = Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powerplan -Filter "ELementName = '$ActivePowerPlan'" | Invoke-CimMethod -MethodName Activate

}

$ActivePowerPlanId = (Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powerplan -Filter "IsActive = 'True'").InstanceID.Replace('Microsoft:PowerPlan\','')
#endregion 

#region Sleep After

$SleepAfterSettingId = (Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powersetting -Filter "Elementname = 'Sleep After'").InstanceID.Replace('Microsoft:PowerSetting\','')

$SleepAfterOnACValue = Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powersettingdataindex -Filter "InstanceID like '%$ActivePowerPlanId%ac%$SleepAfterSettingId'"

$SleepAfterOnDCValue = Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powersettingdataindex -Filter "InstanceID like '%$ActivePowerPlanId%dc%$SleepAfterSettingId'"



if (($SleepAfterOnACValue.SettingIndexValue / 60) -ne $SleepAfterOnAC) 
{

$SleepAfterOnACValue  | Set-CimInstance -Property @{SettingIndexValue = ([int]$SleepAfterOnAC * 60)}
    
}

if (($SleepAfterOnDCValue.SettingIndexValue / 60) -ne $SleepAfterOnDC) 
{

$SleepAfterOnDCValue  | Set-CimInstance -Property @{SettingIndexValue = ([int]$SleepAfterOnDC * 60)}
    
}

#endregion
 
$TurnOffDisplayAfterSettingId = (Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powersetting -Filter "Elementname = 'Turn Off Display After'").InstanceID.Replace('Microsoft:PowerSetting\','')

$TurnOffDisplayAfterSettingOnACValue = Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powersettingdataindex -Filter "InstanceID like '%$ActivePowerPlanId%ac%$TurnOffDisplayAfterSettingId'"

$TurnOffDisplayAfterSettingOnDCValue = Get-CimInstance -Namespace root\cimv2\power -ClassName win32_powersettingdataindex -Filter "InstanceID like '%$ActivePowerPlanId%dc%$TurnOffDisplayAfterSettingId'"

if (($TurnOffDisplayAfterSettingOnACValue.SettingIndexValue / 60) -ne $TurnOffDisplayAfterOnAC) 
{

$TurnOffDisplayAfterSettingOnACValue  | Set-CimInstance -Property @{SettingIndexValue = ([int]$TurnOffDisplayAfterOnAC * 60)}
    
}

if (($TurnOffDisplayAfterSettingOnDCValue.SettingIndexValue / 60) -ne $TurnOffDisplayAfterOnDC) 
{

$TurnOffDisplayAfterSettingOnDCValue  | Set-CimInstance -Property @{SettingIndexValue = ([int]$TurnOffDisplayAfterOnDC * 60)}
    
}


}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[ValidateSet("Balanced","High performance","Power saver")]
		[System.String]
		$ActivePowerPlan,

		[System.String]
		$SleepAfterOnAC,

		[System.String]
		$SleepAfterOnDC,

		[System.String]
		$TurnOffDisplayAfterOnAC,

		[System.String]
		$TurnOffDisplayAfterOnDC
	)

$PowerPlanSettings = Get-TargetResource -ActivePowerPlan $ActivePowerPlan

if ($PowerPlanSettings.ActivePowerPlan -eq $ActivePowerPlan) {

$valid = $true

} else {

$valid = $false

}

if ($SleepAfterOnAC) {
if ($PowerPlanSettings.SleepAfterOnAC -eq $SleepAfterOnAC) {

$valid = $true -and $valid

} else {

$valid = $false -and $valid

}
}

if ($SleepAfterOnDC) {
if ($PowerPlanSettings.SleepAfterOnDC -eq $SleepAfterOnDC) {

$valid = $true -and $valid

} else {

$valid = $false -and $valid

}
}

if ($TurnOffDisplayAfterOnAC) {
if ($PowerPlanSettings.TurnOffDisplayAfterOnAC -eq $TurnOffDisplayAfterOnAC) {

$valid = $true -and $valid

} else {

$valid = $false -and $valid

}
}

if ($TurnOffDisplayAfterOnDC) {
if ($PowerPlanSettings.TurnOffDisplayAfterOnDC -eq $TurnOffDisplayAfterOnDC) {

$valid = $true -and $valid

} else {

$valid = $false -and $valid

}
}

	
	$valid
	
}


Export-ModuleMember -Function *-TargetResource

