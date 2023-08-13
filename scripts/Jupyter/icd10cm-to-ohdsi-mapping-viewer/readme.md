# ICD-10-CM to OHDSI Mappings Jupyter Notebook

This Jupyter notebook offers an efficient workflow to fetch, process, and interactively explore the mappings from ICD-10-CM codes to OHDSI Standardized Vocabularies, complete with detailed mapping precision metadata.

## Features
* Automated download: The code automatically fetches the most recent mapping Excel file from a provided GitHub link.
* Excel to CSV conversion: The notebook reads the "ICD10CM-to-OHDSI-Mappings" tab from the Excel file and saves it as a CSV file.
* Optimized search: Users can efficiently search through the mappings using specified columns with an interactive search bar.

## Usage
* Run the notebook: Execute all cells to perform the download, conversion, and initialize the search bar.
* Interactive search: Use the search bar widget to search for specific ICD codes, descriptions, or mapping precision metadata present in the predefined search columns. Results will be displayed directly below the search bar.

## Dependencies:
* pandas
* requests
* ipywidgets
* openpyxl

Ensure all dependencies are installed in your Jupyter environment for seamless execution.
