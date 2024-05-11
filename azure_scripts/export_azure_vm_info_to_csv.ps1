Connect-AzAccount

$subscriptions = Get-AzSubscription
$allVMsInfo = @()

foreach ($sub in $subscriptions) {
    try {
        # Set the context to the current subscription
        Set-AzContext -SubscriptionId $sub.Id -ErrorAction Stop

        # Get list of VMs in the current subscription
        $vms = Get-AzVM -ErrorAction Stop

        # Check if the VM list is empty and collect information if not
        if ($vms.Count -gt 0) {
            foreach ($vm in $vms) {
                $vmInfo = [PSCustomObject]@{
                    SubscriptionName = $sub.Name
                    VMName = $vm.Name
                    ResourceGroupName = $vm.ResourceGroupName
                    Location = $vm.Location
                    VMSize = $vm.HardwareProfile.VmSize
                    OSType = $vm.StorageProfile.OsDisk.OsType
                }
                $allVMsInfo += $vmInfo
            }
        }
    } catch {
        Write-Error "Error processing subscription $($sub.Name): $_"
    }
}

if ($allVMsInfo.Count -gt 0) {
    # Prepare CSV file path using the script's directory
    $csvFilePath = "$PSScriptRoot\azure_vm_info.csv"
    $allVMsInfo | Export-Csv -Path $csvFilePath -NoTypeInformation
    Write-Output "Data collection complete. Data saved to $csvFilePath"
} else {
    Write-Output "No virtual machines were found across all subscriptions. No CSV file was created"
}
