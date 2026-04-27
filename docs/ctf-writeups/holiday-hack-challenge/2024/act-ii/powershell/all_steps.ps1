#
# Step1: Show content of file "./welcome.txt"
#
$file = "./welcome.txt"
type $file
Start-Sleep -Seconds 1

#
# Step 2: Count the number of words in the file
#
Get-Content -Path $file | Measure-Object -Word
Start-Sleep -Seconds 1

#
# Step 3: Check port the server is llistening for incoming connections
#
# Run netstat command and capture the output
$response = netstat -ano | Out-String
Write-Host $response
Start-Sleep -Seconds 1

#
# Step 4: Check webserver by communicating to it using HTTP and checking the return status
#
# Filter lines that show TCP connections on localhost and are LISTENING
$filteredLine = $response -split "`n" | Where-Object { $_ -match "127\.0\.0\.1.*LISTEN" }

# Extract the local port number using regex
if ($filteredLine -match "127\.0\.0\.1:(\d+)\s+") {
    $port = $matches[1]
}
$webserver = "http://127.0.0.1:$port"

Invoke-WebRequest -Uri $webserver
Start-Sleep -Seconds 1

#
# Step 5: Try again authenticating with a standard admin username and password (admin:admin)
#
# Set the authorization header
$authHeader = @{ Authorization = "Basic $( [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes('admin:admin')) )" }
# Check the webserver again
$response = Invoke-WebRequest -Uri $webserver -Headers $authHeader
Write-Host $response.Content
Start-Sleep -Seconds 1

#
# Step 6: Loop through the endpoints, download the contents of each page and find the one with 138 words.
#         When you find it, communicate with the URL and print the contents to the terminal.
#
# Fetch the main page that lists the endpoints
$response = Invoke-WebRequest -Uri $webserver -Method GET -Headers $authHeader

# Extract all the links (endpoints) from the page
$links = $response.Links | Where-Object { $_.outerHTML -match "endpoints/\d+" } | Select-Object -ExpandProperty href

# Loop through each endpoint
foreach ($endpoint in $links) {
    $response = Invoke-WebRequest -Uri $endpoint -Headers $authHeader
    $content = $response.Content

    # Count the number of words in the page content
    $wordCount = ($content -split '\s+').Length

    # If the word count is 138, print the content
    if ($wordCount -eq 138) {
        Write-Host "Found endpoint with 138 words: $endpoint"
        Write-Host "Content: "
        Write-Host $content
        break
    }
}
Start-Sleep -Seconds 1

#
# Step 7: Read the contents of the CSV file
#
# Extract the URL for the CSV file
if ($content -match "http://[^\s]+\.csv") {
    $csvPath = $matches[0]
    Write-Output "Extracted CSV Path: $csvPath"
} else {
    Write-Output "CSV Path not found."
}

# Get the file
$response = Invoke-WebRequest -Uri $csvPath -Headers $authHeader
Write-Host $response.Content
Start-Sleep -Seconds 1

#
# Step 8: Communicate with unredacted endpoint
#
# Split response into lines
$lines = $response -split "`n"

# Extract non-redacted lines, skiping the first line (header)
foreach ($line in $lines[1..($lines.Length - 1)]) {
    if ($line -match "^([^,]+),([^,]+)$") {
        $token = $matches[1].Trim()
        $sha256sum = $matches[2].Trim()
        if ( $sha256sum -ne "REDACTED") {
            $response = Invoke-WebRequest -Uri $webserver/tokens/$sha256sum -Headers $authHeader
            Write-Host $response.Content
        }
    }
}

# Another option
#$nonRedacted = $lines[1..($lines.Length - 1)] | Where-Object { ($_ -match "^[^,]+,([^,]+)$") -and $matches[1].Trim() -ne "REDACTED" }
#$nonRedacted | ForEach-Object { Invoke-WebRequest -Uri $webserver/tokens/$matches[1].Trim() -Headers $authHeader }
Start-Sleep -Seconds 1

#
# Step 9: Set the cookie 'token' and try again
#

# Create a web session
$webSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession

# Add the 'token' cookie to the session
$webSession.Cookies.Add((New-Object System.Net.Cookie("token", $token, "/", "127.0.0.1")))

# Retry the request with the session containing the cookie
# This request will return the temporary 'mfa_code value.
$response = Invoke-WebRequest -Uri $webserver/tokens/$sha256sum -Headers $authHeader -WebSession $webSession

# Display the response content
Write-Host = $response.Content
Start-Sleep -Seconds 1

#
# Step 10: Validate the MFA token at the endpoint
#
# Extract the MFA token (the value inside the <a href=''> tag)
$mfa_token = ($response.Content | Select-String -Pattern "<a href='([^']+)'>" | ForEach-Object { $_.Matches.Groups[1].Value })

# Use the extracted token as the value for the 'mfa_token' cookie in the next request
# Note: First time, tried to use 'mfa_code' as it says in the original message,
#       but it failed complaining that the 'mfa_token' was missing.
$webSession.Cookies.Add((New-Object System.Net.Cookie("mfa_token", $mfa_token, "/", "127.0.0.1")))

# Now send the next request with the mfa_token cookie set
$response = Invoke-WebRequest -Uri "$webserver/mfa_validate/$sha256sum" -Headers $authHeader -WebSession $webSession

# Display the response content of the validation request
Write-Host $response.Content
Start-Sleep -Seconds 1

#
# Step 11: Decode the Base64 message to get the final secret!
#
# Extract and decode the message
$base64Value = ($response.Content | Select-String -Pattern "<p>(.*?)</p>" | ForEach-Object { $_.Matches.Groups[1].Value })
#Write-Host "Decoding [$base64Value]"
$decodedValue = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64Value))
Write-Host $decodedValue

