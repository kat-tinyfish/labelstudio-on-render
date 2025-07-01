import pandas as pd
import argparse
import sys

# Define which columns are considered "dimensions/weights"
PROD_WD_COLS = [
    'specs_Product Width (in.)',
    'specs_Product Height (in.)',
    'specs_Product Depth (in.)',
    'specs_Product Weight (lb.)',
    'specs_Overall Product Height (in.)',
    'specs_Overall Product Width (in.)',
    'specs_Overall Product Depth (in.)',
    # Add more as needed
]

def format_kv(col, val):
    if pd.isna(val) or str(val).strip() == '':
        return None
    key = col.replace('specs_', '').replace('(in.)', '').replace('(lb.)', '').replace('(qt.)', '').replace('(%)', '').replace('(W)', '').replace('(Fahrenheit)', '').replace('(cu. ft.)', '').replace('(sq. ft)', '').replace('(in)', '').replace('(in)', '').replace('_', ' ').strip()
    if 'Width' in key or 'Height' in key or 'Depth' in key or 'Thickness' in key or 'Diameter' in key or 'Length' in key:
        if 'in' not in str(val) and 'Inch' not in str(val):
            val = f"{val} Inches"
    if 'Weight' in key:
        if 'lb' not in str(val) and 'Pound' not in str(val):
            val = f"{val} Pounds"
    return f"'{key}' = '{val}'"

def combine_kvs(row, columns):
    kvs = [format_kv(col, row[col]) for col in columns if col in row and not pd.isna(row[col]) and str(row[col]).strip() != '']
    return '; '.join(kvs)

def main():
    parser = argparse.ArgumentParser(description="Convert a CSV to a structured CSV with WF-URL, WF-prod-wd, WF-prod-spec columns.")
    parser.add_argument('--input', '-i', required=True, help='Input CSV file path')
    parser.add_argument('--output', '-o', required=True, help='Output CSV file path')
    args = parser.parse_args()

    df = pd.read_csv(args.input)
    spec_cols = [col for col in df.columns if col.startswith('specs_')]
    prod_spec_cols = [col for col in spec_cols if col not in PROD_WD_COLS]

    out_df = pd.DataFrame()
    out_df['HD-URL'] = df['url']
    out_df['HD-prod-wd'] = df.apply(lambda row: combine_kvs(row, PROD_WD_COLS), axis=1)
    out_df['HD-prod-spec'] = df.apply(lambda row: combine_kvs(row, prod_spec_cols), axis=1)

    out_df.to_csv(args.output, index=False)
    print(f"Done! Output written to {args.output}")

if __name__ == '__main__':
    main() 