import xml.etree.ElementTree as ET
from statistics import mean, median
from collections import Counter
import sys

def parse_xml(xml_file):
    tree = ET.parse(xml_file)
    root = tree.getroot()
    results = root.findall('Result')
    
    for result in results:
        raw_string = result.find('Data/Entry/RawString').text
        raw_values = [float(value) for value in raw_string.split(':')]
        
        result_mean = mean(raw_values)
        result_median = median(raw_values)
        result_mode = Counter(raw_values).most_common(1)[0][0]
        
        print(f"Result: {result.find('Description').text}")
        print("Mean:", result_mean)
        print("Median:", result_median)
        print("Mode:", result_mode)
        print()

# Check if the XML file path is provided as an argument
if len(sys.argv) < 2:
    print("Please provide the XML file path as an argument.")
else:
    xml_file_path = sys.argv[1]
    parse_xml(xml_file_path)
