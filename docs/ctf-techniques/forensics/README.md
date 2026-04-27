# Forensics

## Table of Contents
- [Forensics](#forensics)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Topics Covered](#topics-covered)
  - [Quick Reference](#quick-reference)
    - [PCAP Analysis with Wireshark](#pcap-analysis-with-wireshark)
    - [Disk Image Mounting](#disk-image-mounting)
    - [File Carving](#file-carving)
    - [EXIF Image Metadata](#exif-image-metadata)
  - [References](#references)
    - [Challenges](#challenges)
    - [Web Sites](#web-sites)

---

## Overview

Techniques for analyzing logs, network captures, file systems, and other artifacts to reconstruct events or extract hidden data.

## Topics Covered

**PCAP / network analysis** — Inspecting packet captures with Wireshark or scripted tools to extract credentials, files, C2 traffic, or flags.

**Log analysis / SIEM** — Querying structured log data using KQL (Kusto Query Language) or similar to identify attacker activity, lateral movement, or exfiltration.

**File carving** — Extracting embedded files from disk images, memory dumps, or binary blobs.

**Disk image analysis** — Mounting and inspecting `.img` files for hidden files, deleted data, or file system artifacts.

**Steganography** — Recovering data hidden within image or audio files.

**EXIF metadata** — Extracting embedded metadata from image files including GPS coordinates, camera model, timestamps, and author fields.

## Quick Reference

### PCAP Analysis with Wireshark
```bash
# Open in Wireshark
wireshark capture.pcap

# Filter by protocol
http / dns / ftp / smtp

# Follow TCP stream: right-click packet → Follow → TCP Stream
# Export objects: File → Export Objects → HTTP
```

### Disk Image Mounting
```bash
# Mount a raw disk image
sudo mount -o loop floppy.img /mnt/image

# Inspect with file system tools
ls /mnt/image
strings floppy.img | grep -i flag
```

### File Carving
```bash
# Carve files from a binary blob or image
foremost -i disk.img -o output/
binwalk -e firmware.bin
```

### EXIF Image Metadata

EXIF (Exchangeable Image File Format) data is metadata embedded in image files (JPEG, TIFF, etc.) by cameras and photo apps. It can contain GPS coordinates, timestamps, device information, and author/copyright fields. All of these are useful for CTF reconnaissance.

```bash
# Install exiftool
sudo apt install libimage-exiftool-perl

# Dump all EXIF metadata
exiftool image.jpg

# Extract GPS coordinates only
exiftool -GPSLatitude -GPSLongitude -GPSPosition image.jpg

# Extract all metadata from all images in a directory
exiftool /path/to/images/

# Output as JSON
exiftool -json image.jpg
```

**Common CTF-relevant EXIF fields:**

| Field | Description |
|---|---|
| `GPS Latitude` / `GPS Longitude` | Location where the photo was taken |
| `GPS Position` | Combined lat/lon in degrees-minutes-seconds |
| `Date/Time Original` | When the photo was taken |
| `Make` / `Camera Model Name` | Device manufacturer and model |
| `Artist` | Photographer or author field |
| `Copyright` | Copyright string, sometimes contains clues |
| `Comment` | Free-text comment field |

**Converting GPS coordinates:**

EXIF stores GPS as degrees/minutes/seconds (DMS). To look up a location, paste the DMS string directly into Google Maps or Google Earth search:
```
33 deg 27' 53.85" S, 115 deg 54' 37.62" E
```

Or convert to decimal degrees manually:
```
DD = degrees + (minutes / 60) + (seconds / 3600)
South and West values are negative.
```

## References

### Challenges
| Source | Name |
|---|---|
| Holiday Hack Challenge 2024, Act I | [Hadware Part I](../../ctf-writeups/holiday-hack-challenge/2024/act-i/hardware-part-i/README.md) |
| Holiday Hack Challenge 2025, Act III | [Gnome Tea](../../ctf-writeups/holiday-hack-challenge/2025/act-iii/gnome-tea/README.md) |

### Web Sites
- [HackTricks - Basic Forensic Methodology](https://angelica.gitbook.io/hacktricks/generic-methodologies-and-resources/basic-forensic-methodology)
- [HackTricks - Linux Forensics](https://angelica.gitbook.io/hacktricks/generic-methodologies-and-resources/basic-forensic-methodology/linux-forensics)
- [HackTricks - Anti-Forensic Techniques](https://angelica.gitbook.io/hacktricks/generic-methodologies-and-resources/basic-forensic-methodology/anti-forensic-techniques)
- [CyberChef](https://gchq.github.io/CyberChef/)
- [Wireshark Display Filters](https://wiki.wireshark.org/DisplayFilters)
- [ExifTool Documentation](https://exiftool.org/)
