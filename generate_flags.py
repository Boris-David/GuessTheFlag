import os
import json
import urllib.request
import subprocess
import sys
import ssl

# Configuration
ASSETS_DIR = "GuessTheFlag/Assets.xcassets"
BASE_URL = "https://flagcdn.com/w640" # Get high quality source
EXISTING_COUNTRIES = [
    d.replace(".imageset", "") 
    for d in os.listdir(ASSETS_DIR) 
    if d.endswith(".imageset") and os.path.exists(os.path.join(ASSETS_DIR, d, "Contents.json"))
]

# Bypass SSL verification
ssl._create_default_https_context = ssl._create_unverified_context

# Mapping specific codes to maintain project conventions if needed, 
# but mostly we will fetch names dynamically.
# However, to ensure "clean" names, a manual map is safer than raw API data for 190+ countries.
# Here is a comprehensive list of country codes to Common English Names.
COUNTRIES = {
    "af": "Afghanistan", "al": "Albania", "dz": "Algeria", "ad": "Andorra", "ao": "Angola", 
    "ar": "Argentina", "am": "Armenia", "au": "Australia", "at": "Austria", "az": "Azerbaijan",
    "bs": "Bahamas", "bh": "Bahrain", "bd": "Bangladesh", "bb": "Barbados", "by": "Belarus",
    "be": "Belgium", "bz": "Belize", "bj": "Benin", "bt": "Bhutan", "bo": "Bolivia",
    "ba": "Bosnia and Herzegovina", "bw": "Botswana", "br": "Brazil", "bn": "Brunei", "bg": "Bulgaria",
    "bf": "Burkina Faso", "bi": "Burundi", "kh": "Cambodia", "cm": "Cameroon", "ca": "Canada",
    "cv": "Cape Verde", "cf": "Central African Republic", "td": "Chad", "cl": "Chile", "cn": "China",
    "co": "Colombia", "km": "Comoros", "cg": "Congo", "cr": "Costa Rica", "hr": "Croatia",
    "cu": "Cuba", "cy": "Cyprus", "cz": "Czech Republic", "dk": "Denmark", "dj": "Djibouti",
    "dm": "Dominica", "do": "Dominican Republic", "ec": "Ecuador", "eg": "Egypt", "sv": "El Salvador",
    "gq": "Equatorial Guinea", "er": "Eritrea", "et": "Ethiopia", "fj": "Fiji", "fi": "Finland",
    "ga": "Gabon", "gm": "Gambia", "ge": "Georgia", "gh": "Ghana", "gr": "Greece",
    "gd": "Grenada", "gt": "Guatemala", "gn": "Guinea", "gw": "Guinea-Bissau", "gy": "Guyana",
    "ht": "Haiti", "hn": "Honduras", "hu": "Hungary", "is": "Iceland", "in": "India",
    "id": "Indonesia", "ir": "Iran", "iq": "Iraq", "il": "Israel", "jm": "Jamaica",
    "jp": "Japan", "jo": "Jordan", "kz": "Kazakhstan", "ke": "Kenya", "ki": "Kiribati",
    "kp": "North Korea", "kr": "South Korea", "kw": "Kuwait", "kg": "Kyrgyzstan", "la": "Laos",
    "lv": "Latvia", "lb": "Lebanon", "ls": "Lesotho", "lr": "Liberia", "ly": "Libya",
    "li": "Liechtenstein", "lt": "Lithuania", "lu": "Luxembourg", "mk": "North Macedonia", "mg": "Madagascar",
    "mw": "Malawi", "my": "Malaysia", "mv": "Maldives", "ml": "Mali", "mt": "Malta",
    "mh": "Marshall Islands", "mr": "Mauritania", "mu": "Mauritius", "mx": "Mexico", "fm": "Micronesia",
    "md": "Moldova", "mn": "Mongolia", "me": "Montenegro", "ma": "Morocco", "mz": "Mozambique",
    "mm": "Myanmar", "na": "Namibia", "nr": "Nauru", "np": "Nepal", "nl": "Netherlands",
    "nz": "New Zealand", "ni": "Nicaragua", "ne": "Niger", "no": "Norway", "om": "Oman",
    "pk": "Pakistan", "pw": "Palau", "pa": "Panama", "pg": "Papua New Guinea", "py": "Paraguay",
    "pe": "Peru", "ph": "Philippines", "pt": "Portugal", "qa": "Qatar", "ro": "Romania",
    "ru": "Russia", "rw": "Rwanda", "kn": "Saint Kitts and Nevis", "lc": "Saint Lucia", "vc": "Saint Vincent",
    "ws": "Samoa", "sm": "San Marino", "st": "Sao Tome and Principe", "sa": "Saudi Arabia", "sn": "Senegal",
    "rs": "Serbia", "sc": "Seychelles", "sl": "Sierra Leone", "sg": "Singapore", "sk": "Slovakia",
    "si": "Slovenia", "sb": "Solomon Islands", "so": "Somalia", "za": "South Africa", "ss": "South Sudan",
    "lk": "Sri Lanka", "sd": "Sudan", "sr": "Suriname", "se": "Sweden", "ch": "Switzerland",
    "sy": "Syria", "tj": "Tajikistan", "tz": "Tanzania", "th": "Thailand", "tl": "Timor-Leste",
    "tg": "Togo", "to": "Tonga", "tt": "Trinidad and Tobago", "tn": "Tunisia", "tr": "Turkey",
    "tm": "Turkmenistan", "tv": "Tuvalu", "ug": "Uganda", "ae": "UAE", "uy": "Uruguay",
    "uz": "Uzbekistan", "vu": "Vanuatu", "va": "Vatican City", "ve": "Venezuela", "vn": "Vietnam",
    "ye": "Yemen", "zm": "Zambia", "zw": "Zimbabwe"
}

def create_asset(code, name):
    # Check if already exists (handling case sensitivity if needed, but simple check here)
    if name in EXISTING_COUNTRIES:
        print(f"Skipping {name} (already in existing list)")
        return False
        
    imageset_path = os.path.join(ASSETS_DIR, f"{name}.imageset")
    if os.path.exists(os.path.join(imageset_path, "Contents.json")):
         print(f"Skipping {name} (Contents.json exists)")
         return False

    # Skip US/UK as they are likely already there under those specific names
    if code in ['us', 'gb']: 
        print(f"Skipping {name} (US/UK special handling)")
        return False

    print(f"Processing {name} ({code})...")
    
    imageset_path = os.path.join(ASSETS_DIR, f"{name}.imageset")
    os.makedirs(imageset_path, exist_ok=True)
    
    # Download Image
    temp_img_path = f"temp_{code}.png"
    url = f"{BASE_URL}/{code}.png"
    
    try:
        urllib.request.urlretrieve(url, temp_img_path)
    except Exception as e:
        print(f"Failed to download {name}: {e}")
        return False

    # Resize to 3x (600x300) and 2x (400x200) forcing 2:1 ratio
    # sips --resampleHeightWidth 300 600 input --out output
    
    img_3x_path = os.path.join(imageset_path, f"{name}@3x.png")
    img_2x_path = os.path.join(imageset_path, f"{name}@2x.png")
    
    subprocess.run(["sips", "--resampleHeightWidth", "300", "600", temp_img_path, "--out", img_3x_path], capture_output=True)
    subprocess.run(["sips", "--resampleHeightWidth", "200", "400", temp_img_path, "--out", img_2x_path], capture_output=True)
    
    # Clean up temp
    if os.path.exists(temp_img_path):
        os.remove(temp_img_path)

    # Write Contents.json
    contents_json = {
        "images": [
            {"idiom": "universal", "scale": "1x"},
            {"filename": f"{name}@2x.png", "idiom": "universal", "scale": "2x"},
            {"filename": f"{name}@3x.png", "idiom": "universal", "scale": "3x"}
        ],
        "info": {"author": "xcode", "version": 1}
    }
    
    with open(os.path.join(imageset_path, "Contents.json"), "w") as f:
        json.dump(contents_json, f, indent=2)
        
    return True

added_countries = []
for code, name in COUNTRIES.items():
    if create_asset(code, name):
        added_countries.append(name)

# Print list for Swift array
full_list = EXISTING_COUNTRIES + added_countries
# Filter out .DS_Store or non-folders if any crept in
full_list = [c for c in full_list if not c.startswith(".")]
full_list.sort()

print("\n--- SWIFT ARRAY DATA ---")
print(json.dumps(full_list))