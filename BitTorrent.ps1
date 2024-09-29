param (
    [string]$finalCsvPath = "captured_data.csv",
    [string]$pcapFilePath = "captured.pcapng"
)

# Initialize the final CSV file with headers
"FrameNumber,Timestamp,IPSource,IPDestination,SourcePort,DestinationPort,Host,Port,Infohash" | Out-File -FilePath $finalCsvPath -Encoding UTF8

# Process each line of Tshark's output
& "C:\Program Files\Wireshark\tshark.exe" -r $pcapFilePath `
    -Y "not icmp and (udp or tcp)" `
    -T fields `
    -e frame.number -e frame.time -e ip.src -e ip.dst -e udp.srcport -e udp.dstport -e udp.payload -e tcp.srcport -e tcp.dstport | ForEach-Object {
    
    $fields = $_ -split "\t"
    
    # Determine if it's UDP or TCP
    $isUDP = ($fields[4] -ne "")  # If the UDP port field is not empty, it's UDP
    $isTCP = ($fields[6] -ne "")  # If the TCP port field is not empty, it's TCP

    if ($isUDP) {
        $srcPort = $fields[4]
        $dstPort = $fields[5]
        $hexPayload = $fields[6] -replace ':', ''
    } elseif ($isTCP) {
        $srcPort = $fields[6]
        $dstPort = $fields[7]
        $hexPayload = $fields[8] -replace ':', ''
    }

    # Convert the payload to ASCII if present
    $asciiPayload = if ($hexPayload -ne "") {
        -join ($hexPayload -split '(..)' | Where-Object { $_ } | ForEach-Object { [char][convert]::ToInt32($_, 16) })
    } else {
        ""
    }

    if ($asciiPayload -match "Infohash:") {
        # Clean the time string and convert the format
        $cleanedTime = $fields[1] -replace "Hora de verano romance|Romance Daylight Time|Romance Standard Time", ""
        $timestamp = Get-Date $cleanedTime -Format 'yyyy-MM-dd HH:mm:ss'
        
        # Clean the payload of line breaks
        $cleanPayload = $asciiPayload -replace "`r`n|`n", " "

        # Extract Host, Port, and Infohash
        if ($cleanPayload -match "Host: (\S+)") { $PayloadHost = $matches[1] } else { $PayloadHost = "" }
        if ($cleanPayload -match "Port: (\d+)") { $PayloadPort = $matches[1] } else { $PayloadPort = "" }
        if ($cleanPayload -match "Infohash: (\S+)") { $infohash = $matches[1] } else { $infohash = "" }
        
        # Create a CSV line without the Payload column
        $csvLine = "$($fields[0]),$timestamp,$($fields[2]),$($fields[3]),$srcPort,$dstPort,$PayloadHost,$PayloadPort,$infohash"
        
        # Write the line to the final CSV file
        $csvLine | Out-File -FilePath $finalCsvPath -Append -Encoding UTF8
    }
}

# Verify if the final CSV file has been created correctly
Write-Output "New CSV file created: $finalCsvPath"

# Read the final CSV file
$finalCsvContent = Import-Csv -Path $finalCsvPath

# Display the top 5 most seen IPs and infohashes
$topIPs = $finalCsvContent | Group-Object -Property IPSource | Sort-Object -Property Count -Descending | Select-Object -First 5
$topInfohashes = $finalCsvContent | Group-Object -Property Infohash | Sort-Object -Property Count -Descending | Select-Object -First 5

"Top 5 Most Seen IPs:"
$topIPs | ForEach-Object { "$($_.Name): $($_.Count)" }

"Top 5 Most Seen Infohashes:"
$topInfohashes | ForEach-Object { "$($_.Name): $($_.Count)" }
