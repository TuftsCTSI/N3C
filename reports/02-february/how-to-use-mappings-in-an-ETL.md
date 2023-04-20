# How to use mappings to OMOP in an ETL

## Overview

* The process described in this document integrates source terms (custom concepts) into the OMOP vocabulary, including the same attributes and metadata as the existing 'Athena package' concepts. As a result, tools such as Atlas will treat custom concepts in the same manner as Athena concepts. It is important to note that these custom concepts are unique and stable within the context of a single project.
* The OMOP Vocabulary encompasses code sets, terminologies, vocabularies, nomenclatures, lexicons, thesauri, ontologies, taxonomies, classifications, abstractions, and other necessary data for generating transformed data from raw datasets into the OMOP CDM. It also enable searching, querying, and extraction of transformed data, browsing and navigating hierarchies of classes and abstractions inherent in transformed data, and interpreting the meaning of data.
* All patient-level data in OMOP CDM requires representation using concepts from the OMOP Vocabulary, which is an essential component of OMOP CDM and can be downloaded for free from the [OHDSI Athena](https://athena.ohdsi.org/search-terms/start).
* The majority of Standardized Vocabularies is open source unless otherwise specified. The OMOP Vocabulary provides a consistent representation of data in clinical domains such as demographics, conditions, drugs, procedures, measurements, observations, notes, devices, specimens, units, visits, death, provider, and cost.
In the OMOP Vocabulary, there are 121 vocabularies, many of which are adopted from third-party sources such as ICD10CM, SNOMED CT or LOINC. 

## OMOP Vocabulary Architecture

The OMOP Vocabulary provides comprehensive information about the concepts used in all the OMOP CDM Event tables. Rather than generating new content for each CDM implementation, the Vocabulary is centrally maintained as a service to the community. To design the OMOP Vocabulary tables, several assumptions were made:

1. The design accommodates all different source terminologies and classifications.
2. All terminologies are loaded into the CONCEPT table.
3. The key is a newly created concept_id, not the original code of the terminology, as source codes are not unique identifiers across terminologies.
4. Some concepts are declared standard concepts, representing a certain clinical entity in the data. All concepts can be source concepts, representing how the entity was coded in the source. Standard concepts are identified through the standard_concept field in the CONCEPT table.
5. Semantic relationships, which can be hierarchical (parent-child) or lateral (sibling), between concepts are defined in the CONCEPT_RELATIONSHIP table
6. The CONCEPT_RELATIONSHIP table is used to map source codes to standard Concepts.
7. Chains of hierarchical relationships are recorded in the CONCEPT_ANCESTOR table. Ancestry relationships would only be recorded between standard concepts that are valid (not deprecated) and connected through valid and hierarchical relationships (Is a - Subsumes) in the RELATIONSHIP table (flag concept_ancestor.defines_ancestry).

More information about the OMOP Vocabulary tables is available [here](https://ohdsi.github.io/CommonDataModel/cdm54.html#Vocabulary_Tables).

The approach offers several advantages, including the preservation of codes and relationships between them without adhering to multiple source data structures, a simple design for standardized access, and optimized performance for analysis. Navigation among Standard Concepts does not require familiarity with the source vocabulary, and the approach is scalable, allowing for integration of future vocabularies. However, it requires extensive transformation of source data to fit into the OMOP Vocabulary, and not all source data structures and hierarchies can be retained.

## Mapping

Mapping is a process that involves transforming one concept into another. The [Standardized Clinical Data Tables](https://ohdsi.github.io/CommonDataModel/cdm54.html#Clinical_Data_Tables) in the OMOP CDM only allow for the use of standard concepts. Therefore, any codes used in the source databases that are not standard concepts must be translated into standard concepts.

The mapping process is accomplished through the use of records in the CONCEPT_RELATIONSHIP table. These records connect each concept to a standard concept through a set of special relationship IDs.

| **relationship ID** | **purpose** | **features** |
| --- | --- | --- |
| **Maps to** | Mapping of a source concept to a standard concept to populate the following fields within the Standardized Clinical Data Tables: condition_concept_id, observation_concept_id, measurement_concept_id, drug_concept_id, procedure_concept_id, device_concept_id, etc. | Stands for either **a full equivalence** or an **"uphill" mapping** (a mapping to a more general semantic category). It can be **1:1** or **1:n (one-to-many)** for each non-standard concept |
| **Maps to value** | Additional mapping between a source concept and a standard concept to populate **value_as_concept_id** field of the MEASUREMENT and OBSERVATION tables. | Points to a concept, indicating value of Measurements or content of Observations. It is used only in combination with a single "Maps to" |

#### **"Maps to" Relationships**

The "Maps to" relationships are built to connect source (non-standard) concepts and equivalent standard concepts. "Equivalent" means that the target concept carries the same meaning and, importantly, the children in the hierarchy (if there are any) are either equivalent or cover the same semantic space. If an equivalent concept is not available, the mapping attempts to match to a broader concept. This ensures that a query in the target vocabulary will retrieve the same records as if they were queried in the original source vocabulary.

In general, source concepts and standard concepts are mapped as follows:
- Source concepts are mapped to one or several standard concepts. If they are mapped to more than one standard concept, then in the resulting OMOP CDM Event table more than one record is created for each record in the source.
- Standard concepts are also mapped to standard concepts, resulting in a map to itself.
- Classification concepts (with standard_concept='C') do not have a mapping to a standard concept.

#### Glossary
- **Event tables** - OMOP Clinical Data Tables, Health System Data Tables, Health Economics Data Tables, Standardized Derived Elements
- **Basic tables** - the fundamental tables of particular structure, forming the OMOP Vocabulary: concept, concept_relationship, concept_ancestor, concept_synonym, vocabulary.
- **Staging tables** - interim tables with the \_stage postfix used to populate basic tables of the same name, but without postfix:
  - concept_stage =\> concept
  - concept_relationship\_stage =\> concept_relationship
  - concept_ancestor_stage =\> concept_ancestor
  - concept_synonym_stage=\> concept_synonym
  - vocabulary_stage =\> vocabulary
- **Mandatory staging tables** (required for any project): concept_stage, concept_relationship_stage, vocabulary_stage
- **Optional staging tables:** concept_ancestor_stage, concept_synonym_stage

| **table** | **content** | **columns** |
| --- | --- | --- |
| concept_stage | all source concepts | concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason |
| concept_relationship_stage | mapping of source concepts to standard concepts as well as standard concepts to itself, hierarchical relationships, and metadata links if required | concept_id_1, concept_id_2, concept_code_1, concept_code_2, vocabulary_id_1, vocabulary_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason |
| vocabulary_stage | all source vocabularies (sets of source terms) | vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version |
| concept_ancestor_stage | hierarchy for standard concepts | ancestor_concept_id, descendant_concept_id, ancestor_concept_code, descendant_concept_code, ancestor_vocabulary_id, descendant_vocabulary_id, min_levels_of_separation, max_levels_of_separation |
| concept_synonym_stage | Synonymous names of source terms and/or related codes for facilitating concept search | synonym_concept_id, synonym_name, synonym_concept_code, synonym_vocabulary_id, language_concept_id |

- **standard_concept** - the field indicating the role of a concept in the OMOP Vocabulary:

| **standard_concept value** | **description** |
| --- | --- |
| S | concepts marked with 'S' can be used as normative expressions of a clinical entity within the OMOP CDM and within standardized analytics. Eeach standard concept belongs to one domain, which defines the location where the concept would be expected to occur within OMOP CDM Event tables. Note that some source concepts can be customized as standard in a case of need |
| C | Concepts marked with 'C' are classification concepts which do not represent clinical facts per se but the group. Can be used for concept set creation, but not for the analytics on patient data. |
| NULL | Non-standard concepts which can have mapping to standard concept or not. The presence of mapping of particular non-standard concepts depends on the presence of the respective entry in the concept_relationship table. |

- **source_vocabulary_id/mapping_set_id** is a unique custom vocabulary name created by a data analyst. It is an analogue of vocabulary\_id from CDM vocabularies.
Conventions on naming custom vocabularies/mapping sets:
* SSSOM:[ORGANIZATION]\:[SOURCE DATA LABEL]-[SOURCE TABLE NAME], e.g. TUFTS:MIMIC4-LABEVENTS
* OMOP: [Country Code]\_[Source Data Type]\_[Source Data Label]\_[Source Table Name]: US_EHR_MIMIC4_Labevents
- **concept_code/subject_id** is a source entity which uniquely identifies information which should be mapped to the OMOP Vocabulary. 
- **subject_id population rule**: when assigning subject IDs in a dataset, it is recommended to follow the "vocabulary name:identifier" format. This means that the name of the source vocabulary used in the database should be added before the identifier, separated by a colon (':')., e.g. MIMIC4:52355.
- **concept_name/subject_label** is a definition of source identifier (concept_code/subject_id). If source data has source identifiers and definitions of these identifiers, it is recommended to populate concept_code/subject_id with source identifiers and concept_name/subject_label with definitions of identifiers. If the source data lacks either source identifiers or definitions, there are 2 scenarios: 1) concept_codes/subject_ids and concept_names/subject_labels are populated with the same values; 2) concept_codes/subject_ids are auto-generated. To bring more granularity to source term definition for facilitating mapping, concatenation of multiple source fields is allowed, e.g. 'label||'|'||specimen||'|'||unit'.
- **count** is a number of source records associated with concept_code/subject_id.
- **percentage** (optional) is a percentage of source records associated with concept\_code. It is an optional field which allows evaluating mapping rate.

## Sequence of Steps for Implementing Mapping in an ETL Process

1. Define concepts to map. The minimum required fields for custom mapping are (OMOP/SSSOM):
- source_vocabulary_id/mapping_set_id
- concept_code/subject_id
- concept_name/subject_label
- count
2. Create a human-readable table in OMOP or in SSSOM format for mapping, map source concepts, perform QA.
3. Using a validated mapping table, populate the staging tables in a database.
4. Perfrom QA of staging tables:
```sql
SELECT reason, COUNT(*) FROM (
		--concept_relationship_stage
		SELECT
			CASE 
				WHEN crs.valid_end_date IS NULL THEN 'concept_relationship_stage.valid_end_date is null'
				WHEN ((crs.invalid_reason IS NULL AND crs.valid_end_date <> TO_DATE('20991231', 'yyyymmdd'))
					OR (crs.invalid_reason IS NOT NULL AND crs.valid_end_date = TO_DATE('20991231', 'yyyymmdd')))
					THEN 'wrong concept_relationship_stage.invalid_reason: '||crs.invalid_reason||' for '||TO_CHAR(crs.valid_end_date,'YYYYMMDD')
				WHEN crs.valid_end_date < crs.valid_start_date THEN 'concept_relationship_stage.valid_end_date < concept_relationship_stage.valid_start_date: '||TO_CHAR(crs.valid_end_date,'YYYYMMDD')||'+'||TO_CHAR(crs.valid_start_date,'YYYYMMDD')
				WHEN date_trunc('day', (crs.valid_start_date)) <> crs.valid_start_date THEN 'wrong format for concept_relationship_stage.valid_start_date (not truncated): '||TO_CHAR(crs.valid_start_date,'YYYYMMDD HH24:MI:SS')
				WHEN date_trunc('day', (crs.valid_end_date)) <> crs.valid_end_date THEN 'wrong format for concept_relationship_stage.valid_end_date (not truncated to YYYYMMDD): '||TO_CHAR(crs.valid_end_date,'YYYYMMDD HH24:MI:SS')
				WHEN COALESCE(crs.invalid_reason, 'D') <> 'D' THEN 'wrong value for concept_relationship_stage.invalid_reason: '||crs.invalid_reason
				WHEN crs.concept_code_1 = '' THEN 'concept_relationship_stage contains concept_code_1 which is empty ('''')'
				WHEN crs.concept_code_2 = '' THEN 'concept_relationship_stage contains concept_code_2 which is empty ('''')'
				WHEN c1.concept_code IS NULL AND cs1.concept_code IS NULL THEN 'concept_code_1+vocabulary_id_1 not found in the concept/concept_stage: '||crs.concept_code_1||'+'||crs.vocabulary_id_1
				WHEN c2.concept_code IS NULL AND cs2.concept_code IS NULL THEN 'concept_code_2+vocabulary_id_2 not found in the concept/concept_stage: '||crs.concept_code_2||'+'||crs.vocabulary_id_2
				WHEN rl.relationship_id IS NULL THEN 'relationship_id not found in the relationship: '||CASE WHEN crs.relationship_id='' THEN '''''' ELSE crs.relationship_id END
				WHEN crs.valid_start_date > CURRENT_DATE THEN 'concept_relationship_stage.valid_start_date is greater than the current date: '||TO_CHAR(crs.valid_start_date,'YYYYMMDD')
				WHEN crs.valid_start_date < TO_DATE ('19000101', 'yyyymmdd') THEN 'concept_stage.valid_start_date is before 1900: '||TO_CHAR(crs.valid_start_date,'YYYYMMDD')
				ELSE NULL
			END AS reason
			FROM concept_relationship_stage crs
				LEFT JOIN concept c1 ON c1.concept_code = crs.concept_code_1 AND c1.vocabulary_id = crs.vocabulary_id_1
				LEFT JOIN concept_stage cs1 ON cs1.concept_code = crs.concept_code_1 AND cs1.vocabulary_id = crs.vocabulary_id_1
				LEFT JOIN concept c2 ON c2.concept_code = crs.concept_code_2 AND c2.vocabulary_id = crs.vocabulary_id_2
				LEFT JOIN concept_stage cs2 ON cs2.concept_code = crs.concept_code_2 AND cs2.vocabulary_id = crs.vocabulary_id_2
				LEFT JOIN vocabulary v1 ON v1.vocabulary_id = crs.vocabulary_id_1
				LEFT JOIN vocabulary v2 ON v2.vocabulary_id = crs.vocabulary_id_2
				LEFT JOIN relationship rl ON rl.relationship_id = crs.relationship_id
		UNION ALL
		SELECT
			'duplicates in concept_relationship_stage were found: '||crs.concept_code_1||'+'||crs.concept_code_2||'+'||crs.vocabulary_id_1||'+'||crs.vocabulary_id_2||'+'||crs.relationship_id AS reason
			FROM concept_relationship_stage crs
			GROUP BY crs.concept_code_1, crs.concept_code_2, crs.vocabulary_id_1, crs.vocabulary_id_2, crs.relationship_id HAVING COUNT (*) > 1
		UNION ALL
		--concept_stage
		SELECT
			CASE 
				WHEN cs.valid_end_date < cs.valid_start_date THEN 'concept_stage.valid_end_date < concept_stage.valid_start_date: '||TO_CHAR(cs.valid_end_date,'YYYYMMDD')||'+'||TO_CHAR(cs.valid_start_date,'YYYYMMDD')
				WHEN COALESCE(cs.invalid_reason, 'D') NOT IN ('D','U') THEN 'wrong value for concept_stage.invalid_reason: '||CASE WHEN cs.invalid_reason='' THEN '''''' ELSE cs.invalid_reason END
				WHEN date_trunc('day', (cs.valid_start_date)) <> cs.valid_start_date THEN 'wrong format for concept_stage.valid_start_date (not truncated): '||TO_CHAR(cs.valid_start_date,'YYYYMMDD HH24:MI:SS')
				WHEN date_trunc('day', (cs.valid_end_date)) <> cs.valid_end_date THEN 'wrong format for concept_stage.valid_end_date (not truncated to YYYYMMDD): '||TO_CHAR(cs.valid_end_date,'YYYYMMDD HH24:MI:SS')
				WHEN (((cs.invalid_reason IS NULL AND cs.valid_end_date <> TO_DATE('20991231', 'yyyymmdd')) AND cs.vocabulary_id NOT IN ('CPT4', 'HCPCS', 'ICD9Proc', 'ICD10PCS'))
					OR (cs.invalid_reason IS NOT NULL AND cs.valid_end_date = TO_DATE('20991231', 'yyyymmdd'))) THEN 'wrong concept_stage.invalid_reason: '||cs.invalid_reason||' for '||TO_CHAR(cs.valid_end_date,'YYYYMMDD')
				WHEN d.domain_id IS NULL AND cs.domain_id IS NOT NULL THEN 'domain_id not found in the domain: '||CASE WHEN cs.domain_id='' THEN '''''' ELSE cs.domain_id END
				WHEN cc.concept_class_id IS NULL AND cs.concept_class_id IS NOT NULL THEN 'concept_class_id not found in the concept_class: '||CASE WHEN cs.concept_class_id='' THEN '''''' ELSE cs.concept_class_id END
				WHEN COALESCE(cs.standard_concept, 'S') NOT IN ('C','S') THEN 'wrong value for standard_concept: '||CASE WHEN cs.standard_concept='' THEN '''''' ELSE cs.standard_concept END
				WHEN cs.valid_start_date IS NULL THEN 'concept_stage.valid_start_date is null'
				WHEN cs.valid_end_date IS NULL THEN 'concept_stage.valid_end_date is null'
				WHEN cs.valid_start_date < TO_DATE ('19000101', 'yyyymmdd') THEN 'concept_stage.valid_start_date is before 1900: '||TO_CHAR(cs.valid_start_date,'YYYYMMDD')
				WHEN COALESCE(cs.concept_name, '') = '' THEN 'empty concept_stage.concept_name ('''')'
				WHEN cs.concept_code = '' THEN 'empty concept_stage.concept_code ('''')'
				WHEN cs.concept_name<>TRIM(cs.concept_name) THEN 'concept_stage.concept_name not trimmed for concept_code: '||cs.concept_code
				WHEN cs.concept_code<>TRIM(cs.concept_code) THEN 'concept_stage.concept_code not trimmed for concept_name: '||cs.concept_name
				ELSE NULL
			END AS reason
		FROM concept_stage cs
			LEFT JOIN vocabulary v ON v.vocabulary_id = cs.vocabulary_id
			LEFT JOIN domain d ON d.domain_id = cs.domain_id
			LEFT JOIN concept_class cc ON cc.concept_class_id = cs.concept_class_id
		UNION ALL
		--concept_synonym_stage
		SELECT
			CASE 
				WHEN css.synonym_name = '' THEN 'empty synonym_name ('''')'
				WHEN css.synonym_concept_code = '' THEN 'empty synonym_concept_code ('''')'
				WHEN c.concept_code IS NULL AND cs.concept_code IS NULL THEN 'synonym_concept_code+synonym_vocabulary_id not found in the concept/concept_stage: '||css.synonym_concept_code||'+'||css.synonym_vocabulary_id
				WHEN css.synonym_name<>TRIM(css.synonym_name) THEN 'synonym_name not trimmed for concept_code: '||css.synonym_concept_code
				WHEN css.synonym_concept_code<>TRIM(css.synonym_concept_code) THEN 'synonym_concept_code not trimmed for synonym_name: '||css.synonym_name
				WHEN c_lng.concept_id IS NULL THEN 'language_concept_id not found in the concept: '||css.language_concept_id
				ELSE NULL
			END AS reason
		FROM concept_synonym_stage css
			LEFT JOIN vocabulary v ON v.vocabulary_id = css.synonym_vocabulary_id
			LEFT JOIN concept c ON c.concept_code = css.synonym_concept_code AND c.vocabulary_id = css.synonym_vocabulary_id
			LEFT JOIN concept_stage cs ON cs.concept_code = css.synonym_concept_code AND cs.vocabulary_id = css.synonym_vocabulary_id
			LEFT JOIN concept c_lng ON c_lng.concept_id = css.language_concept_id
		UNION ALL
		SELECT
			'duplicates in concept_stage were found: '||cs.concept_code||'+'||cs.vocabulary_id AS reason
			FROM concept_stage cs
			GROUP BY cs.concept_code, cs.vocabulary_id HAVING COUNT (*) > 1
		UNION ALL
		--pack_content_stage
		SELECT
			'duplicates in pack_content_stage were found: '||pcs.pack_concept_code||'+'||pcs.pack_vocabulary_id||pcs.drug_concept_code||'+'||pcs.drug_vocabulary_id||'+'||pcs.amount AS reason
			FROM pack_content_stage pcs
			GROUP BY pcs.pack_concept_code, pcs.pack_vocabulary_id, pcs.drug_concept_code, pcs.drug_vocabulary_id, pcs.amount HAVING COUNT (*) > 1
		UNION ALL
		--drug_strength_stage
		SELECT
			'duplicates in drug_strength_stage were found: '||dcs.drug_concept_code||'+'||dcs.vocabulary_id_1||
				dcs.ingredient_concept_code||'+'||dcs.vocabulary_id_2||'+'||TO_CHAR(dcs.amount_value, 'FM9999999999999999999990.999999999999999999999') AS reason
			FROM drug_strength_stage dcs
			GROUP BY dcs.drug_concept_code, dcs.vocabulary_id_1, dcs.ingredient_concept_code, dcs.vocabulary_id_2, dcs.amount_value HAVING COUNT (*) > 1
	) AS s0
	WHERE reason IS NOT NULL
	GROUP BY reason;

-- erroneously standard concepts - should return nothing
SELECT *
FROM concept_stage
WHERE standard_concept = 'S'
AND   (concept_code,vocabulary_id) IN (SELECT concept_code_1,
                                              vocabulary_id_1
                                       FROM concept_relationship_stage
                                       WHERE relationship_id = 'Maps to');
```
5. Populate the basic tables.
6. Using concept_relationship table, populate OMOP Event tables.
