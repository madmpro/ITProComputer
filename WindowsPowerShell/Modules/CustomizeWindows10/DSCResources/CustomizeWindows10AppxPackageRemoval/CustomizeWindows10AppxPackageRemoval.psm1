function Get-TargetResource
{
  [CmdletBinding()]
  [OutputType([System.Collections.Hashtable])]
  param
  (
    [parameter(Mandatory = $true)]
    [System.String]
    $PackageName
  )

 $query =  Get-AppxPackage -Name $PackageName -User $env:username

  if ($query) 
  {
    Write-Verbose -Message "AppxPackage $($PackageName) present for user $($env:username)"
  }
  else 
  {
    Write-Verbose -Message "AppxPackage $($PackageName) not present for user $($env:username)"
  }


  $returnValue = @{
    PackageName          = $PackageName
  }

  return $returnValue
 
}


function Set-TargetResource
{
  [CmdletBinding()]
  param
  (
    [parameter(Mandatory = $true)]
    [System.String]
    $PackageName
  )



    Write-Verbose -Message "Removing package $($PackageName)"

    $null = Get-AppxPackage -Name $PackageName -User $env:username | Remove-AppxPackage
  
     if (Get-AppxPackage -Name $PackageName -AllUsers) {

      $null = Get-AppxPackage -Name $PackageName -AllUsers | Remove-AppxPackage

     }

}


function Test-TargetResource
{
  [CmdletBinding()]
  [OutputType([System.Boolean])]
  param
  (
    [parameter(Mandatory = $true)]
    [System.String]
    $PackageName
  )

    $query =  Get-AppxPackage -Name $PackageName -User $env:username


    if ($query)
  {
    Write-Verbose -Message "Package $($PackageName) exists for user $($env:username)"
    
      $returnvalue = $false
    
  }
    else 
  {
    Write-Verbose -Message "Package $($PackageName) does not exist for user $($env:username)"

      $returnvalue = $true

  }

       if (Get-AppxPackage -Name $PackageName -AllUsers) {

      $returnvalue = $false

     }

  return $returnvalue

}


Export-ModuleMember -Function *-TargetResource