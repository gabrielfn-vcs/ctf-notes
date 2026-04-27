import csv
from simplekml import Kml

# Input and output files
#csv_file = "Preparations-drone-name.csv"
#kml_file = "Preparations-drone-name-Points.kml"
csv_file = "ELF-HAWK-dump.csv"
kml_file = "ELF-HAWK-Points.kml"

# Columns to extract
lat_col = "OSD.latitude"
lon_col = "OSD.longitude"
alt_col = "OSD.height [ft]"  # Optional
timestamp_col = "CUSTOM.date [local]"  # Optional

# Create KML object
kml = Kml()

# Read CSV and populate KML
with open(csv_file, mode='r', encoding='utf-8') as file:
    reader = csv.DictReader(file)
    index = 0
    for row in reader:
        index += 1
        # Extract coordinates and optional fields
        latitude = row.get(lat_col)
        longitude = row.get(lon_col)
        altitude = row.get(alt_col, None)
        timestamp = row.get(timestamp_col, None)

        # Skip rows without valid coordinates
        if not latitude or not longitude:
            continue

        # Create placemark
        pnt = kml.newpoint(name=f"Point {index}")
        pnt.coords = [(float(longitude), float(latitude), float(altitude) if altitude else 0)]
        pnt.description = f"Timestamp: {timestamp}\nAltitude: {altitude} ft" if timestamp else f"Altitude: {altitude} ft"

# Save KML
kml.save(kml_file)
print(f"KML file saved as {kml_file}")

