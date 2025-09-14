import re
import json
import pandas as pd

def extract_and_load_data(script_element, data_type):
    if script_element:
        script_text = script_element.text
        # match = re.search(f"var {data_type}\\s+=\\s+JSON\\.parse\\('(.+?)'\\)", script_text)
        match = re.search(f"var {data_type}\\s*=\\s*JSON\\.parse\\((?:'|\")(.+?)(?:'|\")\\)", script_text)

        if match:
            json_data_encoded = match.group(1)

            try:
                json_data = json.loads(json_data_encoded.encode('utf-8').decode('unicode_escape'))
                df_data = pd.DataFrame(json_data)
                print(f"✅ Successfully loaded {data_type} data into DataFrame.")
                return df_data
            except Exception as e:
                print(f"❌ Error decoding JSON data for {data_type}: {str(e)}")
                return None
        else:
            print(f"⚠️ JSON data not found for {data_type}.")
            return None
    else:
        print(f"⚠️ Script element for {data_type} not found on the page.")
        return None
