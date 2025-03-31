import requests

# Define parameters
base_url = "https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl"
params = {
    "file": "gfs.t00z.pgrb2.0p25.f000",  # Change f000 to the desired forecast hour
    "lev_10_m_above_ground": "on",  # 10m wind
    "lev_surface": "on",  # Surface pressure
    "var_TMP": "on",  # Temperature
    "var_UGRD": "on",  # U-component wind
    "var_VGRD": "on",  # V-component wind
    "subregion": "",  # Enables subregion selection
    "leftlon": -35.0,  # Longitude of Itamaracá
    "rightlon": -34.7,
    "toplat": -7.6,  # Latitude of Itamaracá
    "bottomlat": -7.9,
    "dir": "/gfs.20220321/00/atmos/"
}

# Make request
try:
    response = requests.get(base_url, params=params)
    response.raise_for_status()  # Raise an error for bad status codes (e.g., 404 or 500)

    # Save the file
    with open("gfs_itamaraca.grib2", "wb") as file:
        file.write(response.content)

    print("Download complete!")

except requests.exceptions.RequestException as e:
    print(f"Error downloading file: {e}")
