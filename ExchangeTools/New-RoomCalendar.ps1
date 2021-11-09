#Add step to check if connected to Exchange Online
#Use this process for Shared Calendars without a UCInetID

#Set Variables here
$RoomName         = "Conference Room"
$RoomOUPath       = "OU=Shared Mailboxes,OU=Department,OU=General,OU=Managed,DC=ad,DC=xxx,DC=com"
$RoomID           = "ConfRoom"
$RoomGroupName    = "ConfRoom(FullSendAs)"
$RoomGroupAlias   = "ConfRoom-FullSendAs"
$RoomGroupPath    = "OU=Resource Groups,OU=Groups,OU=Department,OU=General,OU=Managed,DC=ad,DC=xxx,DC=com"
$RoomGroupOwner   = "MailEnabledGroupOwners"

#Parameters for Room ADObject creation
$NewRoomParams = @{
    GivenName         = $RoomName
    DisplayName       = $RoomName
    Enabled           = $false
    UserPrincipalName = ($RoomID + "@ad.uci.edu")
    Verbose           = $true
}

#Create AD User Object 
New-ADUser @NewRoomParams 

#Parameters for the Remote Mailbox creation
$EnableRemoteMailboxParams = @{
    Identity              = $RoomID
    RemoteRoutingAddress  = ($RoomID + "@ucirvine.mail.onmicrosoft.com")
    Room                  = $true
    Verbose               = $true
}

#Enable the remote mailbox in exchange online
Enable-RemoteMailbox @EnableRemoteMailboxParams

$NewRoomGroupParams = @{
    Name            = $RoomGroupName
    DisplayName     = $RoomGroupName
    GroupCategory   = "Security"
    GroupScope      = "Universal"
    SamAccountName  = $RoomGroupName
    Verbose         = $true
}
New-ADGroup @NewRoomGroupParams

$NewDistributionGroupParams = @{
    Name                = $RoomGroupName
    DisplayName         = $RoomGroupName
    Type                = "Security"
    OrganizationalUnit  = $RoomGroupPath
    Alias               = $RoomGroupAlias
    ManagedBy           = $RoomGroupOwner
    Verbose             = $true
}

New-DistributionGroup @NewDistributionGroupParams
