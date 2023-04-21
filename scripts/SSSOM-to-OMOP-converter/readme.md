# SSSOM-to-OMOP Converter

The SSSOM-to-OMOP Converter is a Python tool that generates INSERTS from a SSSOM mapping table into the OMOP Vocabulary staging tables (concept_stage, concept_relationship_stage, concept_ancestor_stage, concept_synonym_stage, vocabulary_stage).

## Instructions
1. Review the Field Req.xlsx to understand what fields are required in the source table
2. Ensure that the required fields are present in the source table
3. Modify db_conf.py with your database settings
4. Run the main.py script using the following command: main.py --path_to_the_file/--path_to_lookup (path_to_lookup is optional)

As a result, a file called _**sssom_to_omop.log**_ will be created in the working folder, which will show the progress of the conversion.

## Next Steps
1. Preprocessing of a SSSOM mapping table, such as deduplication and filling empty fields
2. Processing of unmapped source terms in a SSSOM mapping table
