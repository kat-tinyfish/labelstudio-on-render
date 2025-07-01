import json
import pandas as pd

input_path = "Wayfair/test-matches-kat.jsonl"
output_path = "Wayfair/test-matches-kat.csv"

rows = []
with open(input_path, "r") as f:
    for line in f:
        if line.strip():
            obj = json.loads(line)
            # Flatten nested fields
            flat = obj.copy()
            # Convert lists to comma-separated strings
            for key in ['images', 'categories']:
                if key in flat:
                    flat[key] = ', '.join(flat[key])
            # Flatten 'specs' dictionary
            if 'specs' in flat:
                for spec_key, spec_val in flat['specs'].items():
                    flat[f"specs_{spec_key}"] = spec_val
                del flat['specs']
            rows.append(flat)

df = pd.DataFrame(rows)
df.to_csv(output_path, index=False)
print(f"CSV written to {output_path}")
