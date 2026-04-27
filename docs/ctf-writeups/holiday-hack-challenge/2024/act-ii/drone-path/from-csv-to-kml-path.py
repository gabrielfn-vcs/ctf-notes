import csv
from simplekml import Kml, AltitudeMode, Color

# Input and output files
csv_file = "ELF-HAWK-dump.csv"
kml_file = "ELF-HAWK-dump-Path.kml"

# Columns to extract
lat_col = "OSD.latitude"
lon_col = "OSD.longitude"
alt_col = "OSD.height [ft]"  # Optional
timestamp_col = "CUSTOM.date [local]"  # Optional

# Create KML object
kml = Kml()

# List to store coordinates for LineString
coordinates = []

# Read CSV and gather coordinates
with open(csv_file, mode='r', encoding='utf-8') as file:
    reader = csv.DictReader(file)
    for row in reader:
        # Extract coordinates and optional fields
        latitude = row.get(lat_col)
        longitude = row.get(lon_col)
        altitude = row.get(alt_col, None)

        # Skip rows without valid coordinates
        if not latitude or not longitude:
            continue

        # Append coordinates to the list
        coordinates.append((float(longitude), float(latitude), float(altitude) if altitude else 0))

# Create LineString in KML
if coordinates:
    linestring = kml.newlinestring(name="Flight Path")
    linestring.coords = coordinates
    linestring.altitudemode = AltitudeMode.absolute  # Optional, for altitude visualization
    linestring.style.linestyle.width = 3
    linestring.style.linestyle.color = Color.blue  # Blue line

# Save KML
kml.save(kml_file)
print(f"KML file saved as {kml_file}")

