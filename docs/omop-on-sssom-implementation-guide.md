# OMOP-on-SSSOM Implementation Guide
###### _Andrew Williams, Polina Talapova, ‪Nicolas Matentzoglu, Davera Gabriel, Anna Ostropolets, Michael Kallfelz, Christian Reich, Melissa Haendel_

## Overview

[The OMOP CDM Standardized Vocabulary version 5.0 (OMOP Vocabulary)](https://athena.ohdsi.org/vocabulary/list) is a collection of terminologies and coding systems that is widely used for data mapping by those who build ETLs (Extract, Transform, Load processes) and transform source terms to the [OMOP CDM](https://ohdsi.github.io/CommonDataModel/). Additionally, there are external contributors who are interested in improving the OMOP vocabulary beyond what is supported by the core OMOP Vocabulary team.

While the OMOP Vocabulary is one of the best open-source compilations of standardized medical expressions, there is still a need for improvements in the areas of maintenance, provenance, precision, and justification of the mappings between the source terms and the OMOP Vocabulary concepts. [The Simple Standard for Sharing Ontological Mappings (SSSOM)](https://mapping-commons.github.io/sssom/about/) can help address these needs by allowing the storage of a comprehensive set of standard metadata elements to describe mappings.

Therefore, this collaborative effort aims to document and implement the use of SSSOM for mapping heterogeneous data to the standard concepts from the OMOP Vocabulary. By doing so, we hope to enhance the quality and reliability of the OMOP Vocabulary, and facilitate the sharing and reuse of mappings between different stakeholders.

## Use Cases

1. OMOP Vocabulary users at Tufts apply SSSOM to map semi-structured sources (EHR Flowsheets and MIMIC4) to OMOP standard concepts, where SSSOM metadata elements are utilized for multiple purposes, such as:
- A canonical representation for both mappings to OMOP and high-importance source terms which are not captured in controlled terminologies, but require extension of OMOP Vocabulary
- Serving as a typical part of the OMOP CDM ETL documentation reflecting the mapping process
- Producing computable objects that can be plugged into ETL code for reusability
- Offering an alternative representation of an entire complex ETL to be used by numerous investigators
- Serving as input data for tools that link OMOP standard concepts with knowledge graphs that use biomedical ontologies to identify the biological causes of observed clinical phenomena, including:
    - Biomarker discovery
    - Drug repurposing
    - Hypothesis generation for drug targets
    - Environmental exposure impacts on health
    - Constraining /informing inferences from animal models to health, etc.
- Being used as an instrument for mapping quality analytics and the integration of new vocabularies within the OMOP Vocabulary

2. External contributors to the OMOP Vocabulary at Tufts use SSSOM for the next purposes:
- Adding externally generated extensions to the OMOP Vocabulary that address gaps and use methods compatible with the OMOP Vocabulary build process. When the OHDSI Vocabulary team defines criteria for external contributions, the SSSOM format may enable increased automation, clearer justification, and traceable provenance
- Mapping OMOP standard concepts to Open Biomedical Ontologies (OBO), such as HPO or Mondo, which can serve as the following: 
    - Knowledge-based cross-domain classification vocabularies with relationships to standard OMOP concepts that are more formally defined, thereby increasing mapping precision and justifying "maps to" relationships more explicitly compared to existing model
    - An instrument for more meaningful feature engineering through dimension reduction, resulting in more efficient and accurate ML model in predicting outcomes.
    - Additional starter set of concepts in phenotype development, similar to [OHDSI Phoebe](https://data.ohdsi.org/PHOEBE/), but based on knowledge rather than concept frequency and semantic relatedness.
    - Enabling analytic tooling that exploits biological entity relationships known to impact health in clinical settings through the linkage to HPO and Mondo knowledge graphs

Based on the above, the core maintainers of the OMOP Vocabulary can utilize the experience and knowledge gained from SSSOM to enhance its schema and content with machine-readable information by integrating mapping-related metadata obtained from SSSOM mapping tables into the vocabulary.

## Methodology

In order to map source data to the OMOP Vocabulary using SSSOM, we identified required SSSOM metadata elements to be utilized and performed field-level mapping to the OMOP CDM, as shown below:

| **Field Name** | **Required** | **Data Type** | **Description** | **Target OMOP Field** | **Data Example** |
| --- | --- | --- | --- | --- | --- |
| mapping_source | Y | text | Initial mapping source in the form of a structured code instead of natural language string | concept_relationship_stage. vocabulary_id_1 | PHYSIONET:MIMIC4 |
| mapping_set_id | N | numeric | A globally unique identifier for the mapping set (auto-generated) | mapping_metadata*. mapping_set_id | 40100000001 |
| mapping_set_label | Y | text | The mapping set name | mapping_metadata. mapping_set_label | MIMIC4 to LOINC Labevents Mapping |
| subject_category | N | text | The conceptual category to which the subject belongs to. This can be a string denoting the category or a term from a controlled vocabulary | mapping_metadata. subject_category | Blood Gas |
| subject_id | Y | text | The ID of the subject of the mapping, can be auto-generated if not provided by the source or populated with a label of the subject | concept_relationship_stage. concept_code_1 | MIMIC4:50817 |
| subject_label | Y | text | The label of the subject of the mapping. When creating mappings for Measurements, it is recommended to include the concatenation of the event description with any available specimens and units as the label for the subject. This can provide a more complete and informative representation of the measurement being described | concept_stage. concept_name | Oxygen Saturation\|Blood\|% |
| predicate_id | Y | text | Indicates the relation between a subject_id and object_id | concept_relationship_stage. relationship_id | skos:exactMatch (lower case 'skos') |
| object_id | Y | text | The ID of the object of the mapping (target OMOP concept_id) | concept_relationship_stage. concept_id_2 | OMOP:3013502 (if you use OMOP concept ids) or LOINC:20564-1 |
| object_label | Y | text | The label of the object of the mapping (target OMOP concept name) | concept_stage. concept_name | Oxygen saturation in Blood |
| confidence | Y | numeric | A score between 0 and 1 to denote the confidence or probability that the match is correct, where 1 denotes total confidence. | mapping_metadata. confidence | 1 |
| mapping_cardinality | Y | text | A string indication whether this mapping is from a 1:1 (the subject_id maps to a single object_id), 1:n (the subject maps to more that one object_id), n:1, 1:0, 0:1 or n:n group. Note that this is a convenience field that should be derivable from the mapping set | mapping_metadata. mapping_cardinality | 1:1 |  
| mapping_justification | Y | text | A mapping justification is an action (or the written representation of that action) of showing a mapping to be right or reasonable | mapping_metadata. mapping_justification | Domain Expertise |
| author_id | N | numeric | A unique identifier for the persons or groups responsible for asserting the mappings (auto-generated) | mapping_metadata. author_id | 40200000001 |
| author_label | Y | text | The names or descriptors of persons or groups responsible for asserting the mappings | mapping_metadata. author_label | Odysseus Vocabulary team |
| reviewer_id | N | numeric | A unique identifier for the persons or groups that reviewed and confirmed the mapping (auto-generated) | mapping_metadata. reviewer_id | 40300000001 |
| reviewer_label | Y | text | The names or descriptors of persons or groups that reviewed and confirmed the mapping | mapping_metadata. reviewer_label | Tufts Domain Expert |
| mapping_provider | N | text |URL or description of the source that provided the mapping | mapping_metadata. mapping_provider | Odysseus |
| mapping_date | Y | date/text | The date the mapping was created. If the same mapping has different mmapping dates, choose the mapping with the most recent date | concept_relationship_stage. valid_start_date | 2023-01-15 (YYYY-MM-DD) |
| mapping_tool | N | text | Represents an individual mapping between a pair of terms | mapping_metadata. mapping_tool | OHDSI Usagi |
| mapping_tool_version | N | text | Description of an instrument used for mapping | mapping_metadata. mapping_tool_version | v1.4.3 |
| subject_source_version | N | text | Version IRI or version string of the source of the subject term | vocabulary_stage. vocabulary_version | v.1.0 |
| subject_type | N | text | The type of entity that is being mapped (can be applicable to Values flagging) | N/A | N/A |
  
 _\*- the candidate table which does not exist in OMOP CDM yet_

In mapping, additional data elements can be utilized by Tufts users of the OMOP Vocabulary:

| **Field Name** | **Description** |
| --- | --- |
| cnt | Frequency of term occurrence in the source data |
| object\_class | The semantic class of a target standard concept |
| object\_domain | The semantic domain of a target standard concept |
| object\_vocabulary | The vocabulary of a target standard concept |

These fields are specific to certain domains or use cases, so there is no need for them to be officially added to SSSOM.

Please note, that any interim fields that facilitate the mapping process can be added for convenience.

To create a short human-readable version of the mapping table in SSSOM, the following fields can be included:

1. mapping_source
2. mapping_set_label
3. subject_category
4. cnt
5. subject_id
6. subject_label
7. predicate_id
8. object_id
9. object_label
10. confidence
11. mapping_cardinality
12. mapping_justification
13. author_label
14. reviewer_label
15. mapping_date
16. subject_source_version

A machine-readable version of the SSSOM mapping table to be used in ETL can have the following representation:

| **mapping_set_id** | **subject_id** | **predicate_id** | **object_id** | **confidence** | **mapping_cardinality** |
| --- | --- | --- | --- | --- | --- |
| 40100000001 | MIMIC4:50817 | skos:exactMatch | OMOP:3013502 | 1 | 1:1 |

After applying the OMOP-on-SSSOM approach to our mapping efforts, we have gathered some suggestions that may be useful for future mapping endeavors:
- predicate_id, confidence, mapping_cardinality and mapping_justification should be assigned by a domain expert
- object_ids as target OMOP concepts can be selected by machinery if source terms are mapped to codes from the OMOP CDM supported vocabularies (i.e. ICDs, HCPCS, CPT4, NDC, ATC), which have crosswalks to standard concept_ids in the concept_relationship table. Otherwise, source terms require domain expert curation
- subject_ids in the ETL process should be parsed to extract values to populate concept_stage.vocabulary_id and concept_stage.concept_code (!)
- object_ids in the ETL process should be parsed to obtain concept.vocabulary_id and concept.concept_id values to populate respective fields in the staging tables
- To compare any competing mapping approaches, mappings or mapping sets, certified domain expertise is required. Each methodological decision ought to be based on a particular use case, be documented and made public using OHDSI Forums. It is important to note that the general [mapping strategy](https://ohdsi.github.io/TheBookOfOhdsi/ExtractTransformLoad.html#step-2-create-the-code-mappings), as described in the OHDSI Book of OHDSI, remains unchanged, and any proposed modifications or additions to OMOP CDM should be carefully evaluated and documented with domain expertise and made public on [OHDSI Forums](https://forums.ohdsi.org/) and [CDM & THEMIS Working group](https://www.ohdsi.org/web/wiki/doku.php?id=projects:workgroups:cdm-wg).
- To incorporate a SSSOM mapping table into an OMOP CDM instance, you can use a Python tool that generates INSERTS into the OMOP Vocabulary staging tables (concept_stage, concept_relationship_stage, concept_ancestor_stage, concept_synonym_stage, vocabulary_stage). For optimal results, ensure that the script is tailored to correspond with the fields utilized in the SSSOM mapping table.

## Using SSSOM for Identifying Issues in OMOP Vocabulary

Based on an end-to-end analysis of real-world data and the OMOP Vocabulary content, the following SSSOM metadata elements can be used to identify different mappings issues:

| **Field name** | **Field Value** | **Meaning** | **Issue** |
| --- | --- | --- | --- |
| predicate_id | skos:exactMatch | one-to-one full equivalent mapping: semantics of one subject (source) is fully covered by an object (target) | No issues |
| | skos:broadMatch | 1. An object is semantically broader than a subject; 2. It is the same as the "Is a" hierarchical relationship in OMOP CDM, that indicates a link to a semantic parent (more generic and less granular term) | Mapping results in loss of source term detail (granularity) |
| | skos:narrowMatch | 1. An object is semantically narrower than a subject; 2. It is the same as the "Subsumes" hierarchical relationship in OMOP CDM, that indicates a link to a semantic child (more specific and granular term that a source one) | Mapping brings extra details which are not mentioned in the source |
| | skos:closeMatch | indicates a standard OMOP concepts which has relations to a subject but is anything listed above (e.g. to store information about devices which relate to intervention or manipulation) | If there is only predicate_id, an OMOP extension concept might be required |
| mapping_cardinality | 1:1 | one-to-one full equivalent mapping: semantics of one subject (source) is fully covered by an object (target) | No issues |
| | 1:n | one-to-many mapping: semantics of a subject (source) is covered by several objects (targets) | Mapping is hierarchical and/or brings extra details which are not mentioned in the source |
| | n:1 | many-to-one mapping: object can be associated with multiple subjects | Mapping is hierarchical and/or results in loss of source term detail |
| | 1:0 | one-to-zero mapping can indicate the absence of a standard OMOP equivalent | Potential OMOP Vocabulary gap |
| | 0:1 | zero-to-one mapping can indicate a mapping to a new OMOP extension concept | Particular OMOP extension concept which is required |
| | n:n | many-to-many - several terms are mapped to several terms (e.g. can be used for mapping of a set of questions from one questionnaire to questions from different standard assessment tools) | Mapping of an assessment panel |
| confidence | between 0 and 1 | "1" denotes full confidence in mapping while "0" - absence of such a confidence | Level of confidence in mapping |

Therefore, to enhance the transparency of the OMOP Vocabulary, we suggest adding a mapping_metadata table to OMOP CDM that can capture additional details about the mapping development process and the resulting mapping quality.

## Next steps

To assess effectiveness of SSSOM by: 
1. measuring user experience in mapping-related manipulations
2. evaluating impact of mapping corrections to a cohort
3. creating a SSSOM representation of ICD-10-CM-to-OMOP mapping, starting with Neuropsychiatric codes
