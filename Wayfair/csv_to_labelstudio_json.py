import csv
import json
import argparse

parser = argparse.ArgumentParser(description="Convert a CSV to Label Studio JSON task format.")
parser.add_argument('--input', '-i', required=True, help='Input CSV file path')
parser.add_argument('--output', '-o', required=True, help='Output JSON file path')
args = parser.parse_args()

tasks = []
with open(args.input, newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for idx, row in enumerate(reader, start=1):
        # Optionally, clean up whitespace from keys/values
        data = {k.strip(): (v.strip() if isinstance(v, str) else v) for k, v in row.items()}
        tasks.append({
            "id": idx,
            "data": data,
            "annotations": [],
            "predictions": []
        })

with open(args.output, 'w', encoding='utf-8') as jsonfile:
    json.dump(tasks, jsonfile, indent=2, ensure_ascii=False)

print(f"Done! Output written to {args.output}") 