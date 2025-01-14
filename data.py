import json

# Path to the JSON file
json_file_path = "/Users/ahuja/Desktop/ImProver2/repl/out.json"

# Load the JSON data
with open(json_file_path, "r") as file:
    data = json.load(file)

# Get the number of elements in "infotree"
infotree_elements_count = len(data.get("infotree", []))

print(f'Number of elements in "infotree": {infotree_elements_count}')


for it in data.get("infotree", []):
    print(it["node"]["stx"]["pp"])
