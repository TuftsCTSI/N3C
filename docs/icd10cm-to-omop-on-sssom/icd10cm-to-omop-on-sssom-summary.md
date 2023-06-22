# ICD10CM-to-OMOP-on-SSSOM Workflow Summary


The entire corpus of ICD-10-CM codes consists of 98,583 entities. Our objective was to convert existing open-source mappings from ICD-10-CM to OMOP Standardized Vocabularies, specifically SNOMED (14,409, 99.6%), Cancer Modifier (31, 0.3%), OMOP Extension (4), and CVX (1), into the SSSOM standard. To achieve this, we followed the process outlined below.

In the first iteration, we conducted a structural (field-level) mapping and transformed the OMOP Vocabulary data stored in the concept and concept\_relationship tables into SSSOM. We assigned the exactMatch predicate\_id to all one-to-one mappings, while all one-to-many mappings were labeled as broadMatch without verifying the mapping precision.

In the second iteration, we assigned ICD-10-CM categories (22) and normalized ICD names to reduce the total number of source terms (69,159 normalized versus 96,037 raw). We applied an SQL-based heuristic to ensure mapping quality and generate mapping precision metadata. This process helps to identify semantic gaps among standards and detect erroneous matches.

Out of the total number of codes, 96,745 (98.1%) codes were deemed valid for use in clinical settings. We transformed their mappings to standard terms from OMOP CDM Standardized Vocabularies into the SSSOM format to evaluate mapping precision and reliability. However, 1,838 (1.9%) codes were identified as invalid for utilization since 2011. As these codes were not encountered in real data and lacked available mappings in OHDSI Athena, we did not process them using SSSOM at this stage of our work. Out of the valid codes, only 4 remained unmapped.

We assigned predicate\_ids to indicate the preservation of source details in the assigned standard targets. Here are the details:

- exactMatch: 10,765 (10.9%) mappings, signifying a direct one-to-one correspondence between the ICD-10-CM codes and OMOP standards.

- broadMatch:

A) 47,406 (48.1%) instances were classified as one-to-one broad matches. These ICD-10-CM codes were mapped to one broader category, resulting in a loss of details present in the source.

B) 28,886 (29.3%) mappings were identified as one-to-many broad matches. These codes were linked to broader semantic categories (semantic parents) represented by several less granular standard concepts. They complement each other and are treated with an "AND" logic.

- uncheckedMatch: 9,915 (10.1%) codes, which require further expert validation in subsequent iterations. The focus of the next iterations will be on ICD categories of high priority, as per Tufts' requirements.

Additionally, we defined mapping justification methods, utilizing the Semantic Mapping Vocabulary (semapv) classes as follows:

- ManualMappingCuration: 49,737 (50.4%) mappings, representing valid and unknown mappings manually curated by the OHDSI Vocabulary team.

- LexicalSimilarityThresholdMatching: 21,016 (21.3%) mappings, indicating valid mappings established based on lexical similarity between code terms, using techniques such as fuzzymatch (difference), Levenshtein, and Jaro-Winkler.

- LexicalMatching: 19,448 (19.7%) mappings, representing valid mappings established purely based on lexical matching between the source name and target name or synonym.

- CompositeMatching: 4,902 (5.0%) mappings, denoting valid mappings established using a combination of different matching techniques (e.g., regexps, case, digit, character suppression) and criteria (similarity thresholds).

- LevenshteinEditDistance: 886 (0.9%) mappings, indicating valid mappings established solely based on the Levenshtein Edit Distance algorithm.

- DigitSuppression: 692 (0.7%) mappings, representing valid mappings confirmed by suppressing or ignoring digits in names.

- LinkStripping: 61 (0.1%) mappings, indicating valid mappings confirmed by removing or stripping specific parts of the codes. This category accounted for a very small percentage, approximately 0.1% of the mappings.

- noMap: 3 codes that were not mapped.

Thus, the mapping justification metadata provides insights into the distribution of different approaches employed to validate mapping accuracy. Manual curation, lexical similarity threshold matching, and lexical matching emerged as the primary methods utilized during the mapping process.

Another important aspect of the mapping precision metadata we assigned was confidence levels based on the mapping semantics and mapping\_justification outcomes. Here are the results:

- 0.7: 42,797 (43.4%)

- 0.9: 33,827 (34.3%)

- 1: 10,206 (10.4%)

- 0.5: 9,915 (10.1%)

- 0.8: 232 (0.2%)

Based on the above findings, we can conclude that only 10.4% of the mappings are deemed trustworthy. Mappings with a confidence level of less than 1 should be prioritized based on the ICD category and reviewed with greater attention to lower confidences.

The next iteration of the ICD-10-CM-to-OMOP-on-SSSOM mapping process will involve further validation of high-priority ICD categories (Psychiatry, SDoH, Infections, Pulmonology, Cardiology, Neurology, etc. ).
