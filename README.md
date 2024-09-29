# BitTorrent Analysis Tool

This PowerShell script (`BitTorrent.ps1`) processes a PCAPNG capture file to extract and analyze BitTorrent traffic. It identifies frames with relevant IP, port, and infohash data, and outputs the results into a structured CSV file. Additionally, the script provides a summary of the top 5 most frequent IP addresses and infohashes found in the capture.

## Key Features

- **BitTorrent Traffic Analysis**: Extracts key data from BitTorrent traffic including IP source, IP destination, ports, host, and infohash.
- **PCAPNG Processing**: Processes PCAPNG files generated from tools like Wireshark or Tshark.
- **CSV Output**: Saves the captured data in a CSV format for easy analysis and further processing.
- **Top 5 Insights**: Displays the top 5 most frequent IP addresses and infohashes seen in the capture.

## Prerequisites

- **Wireshark/Tshark**: This script relies on Tshark (part of the Wireshark suite) for reading and filtering the PCAPNG file. Ensure it is installed and available at the default path (`C:\Program Files\Wireshark\tshark.exe`).
- **PowerShell**: The script is written in PowerShell and should work on Windows systems with PowerShell 5.1 or later.

## Installation

1. Install **Wireshark** and ensure Tshark is included in your installation.
2. Place the `BitTorrent.ps1` script in your working directory.

## Usage

Run the script by specifying the PCAPNG file path and the output CSV file:

```bash
.\BitTorrent.ps1 -finalCsvPath "output.csv" -pcapFilePath "capture.pcapng"
```

### Parameters

- `-finalCsvPath`: The path where the final CSV file will be stored. Defaults to `captured_data.csv`.
- `-pcapFilePath`: The path to the PCAPNG file to be processed. Defaults to `captured.pcapng`.

### Example

```bash
.\BitTorrent.ps1 -finalCsvPath "resultados.csv" -pcapFilePath "captura.pcapng"
```

This will analyze the specified PCAPNG file, extract the relevant BitTorrent traffic, and save the results to `resultados.csv`.

## Output

The output CSV file contains the following columns:

- `FrameNumber`: The number of the frame in the capture.
- `Timestamp`: The timestamp of the captured frame.
- `IPSource`: The source IP address.
- `IPDestination`: The destination IP address.
- `SourcePort`: The source port.
- `DestinationPort`: The destination port.
- `Host`: The host extracted from the BitTorrent payload (if available).
- `Port`: The port from the BitTorrent payload (if available).
- `Infohash`: The BitTorrent infohash extracted from the payload.

### Example CSV Output

| FrameNumber | Timestamp           | IPSource   | IPDestination | SourcePort | DestinationPort | Host      | Port | Infohash                              |
|-------------|---------------------|------------|---------------|------------|-----------------|-----------|------|---------------------------------------|
| 1234        | 2023-09-01 12:34:56 | 192.168.1.1| 10.0.0.2      | 6881       | 51413           | example.com | 80   | a3b5f8d6a1b2c3d4e5f6g7h8i9j0k1l2     |

## Analysis

After running the script, it will also display a summary of the top 5 most frequent IP addresses and infohashes found in the capture.

### Example Top 5 Results

```
Top 5 Most Seen IPs:
192.168.1.1: 15
10.0.0.2: 12
...

Top 5 Most Seen Infohashes:
a3b5f8d6a1b2c3d4e5f6g7h8i9j0k1l2: 5
...
```

## System Language Considerations

If your system uses a language other than Spanish, you may need to modify the following line in the script to match the system's time zone and format:

```powershell
$cleanedTime = $fields[1] -replace "Hora de verano romance", ""
```

For example, change `"Hora de verano romance"` to match the time zone formatting in your system.

## Legal Disclaimer

This tool is intended for educational purposes and lawful network traffic analysis only. Do not use it to capture or analyze traffic that you do not have explicit permission to monitor. Misuse of this tool may result in legal consequences.

## License

This project is provided under the GNU Affero General Public License v3.0. You can find the full license text in the [LICENSE](LICENSE) file.
