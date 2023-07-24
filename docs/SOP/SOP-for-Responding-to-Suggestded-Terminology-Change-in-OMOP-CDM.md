# Standard Operating Procedure (SOP) for Responding to Suggested Terminology Change in OMOP CDM

## Purpose

The purpose of this Standard Operating Procedure (SOP) is to establish a standardized process for responding to suggested terminology changes within the Observational Medical Outcomes Partnership (OMOP) Common Data Model (CDM). This SOP aims to ensure consistency, accuracy, and transparency in incorporating terminology updates while maintaining data integrity and promoting collaboration among stakeholders.

## Scope

This SOP applies to all personnel involved in managing and maintaining the OMOP CDM terminology, including data modelers, ETL specialists, terminology experts, and other relevant stakeholders.

## Definitions

**OMOP CDM:** The Observational Medical Outcomes Partnership Common Data Model is a standardized data structure used to organize and represent observational healthcare data.

**Terminology:** Refers to medical vocabularies and coding systems used to encode clinical concepts in the OMOP CDM, such as SNOMED CT, RxNorm, ICD10CM, etc.

**Suggested Terminology Change:** Any proposed update, addition, or modification to existing terminologies used within the OMOP CDM.

## Procedure

## Step 1: Identification of Suggested Terminology Change

When a stakeholder identifies or receives information about a potential terminology change, they are required to initiate the process by submitting a formal request through a designated form provided by [OHDSI Vocabulary team](https://github.com/OHDSI/Vocabulary-v5.0/wiki/The-Vocabulary-Team). This request should include the following information:

- Description of the proposed change
- Rationale or supporting evidence for the change
- Affected terminology or concept IDs
- Impact on data and downstream processes

Comprehensive details about the submission process can be found on the ["Community Contribution"](https://github.com/OHDSI/Vocabulary-v5.0/wiki/Community-contribution) page of the OHDSI GitHub Wiki.

The submission process may take anywhere from 3 to 6 months. However, during this waiting period for the official release of changes, it is possible to make the necessary modifications locally in your OMOP CDM instance. To achieve this, you can implement the changes using the [staging tables](https://github.com/OHDSI/Vocabulary-v5.0/wiki/Vocabulary-development-process#i--------------staging). When modifying content, it is essential to maintain consistent attributes and metadata as used in the existing ["Athena package](https://athena.ohdsi.org/search-terms/terms) concepts. By doing so, your Atlas instance or other tools will handle custom concepts similarly to how they handle officially released concepts on Athena. However, a drawback of this approach is that local changes cannot be shared with external data owners unless they replicate the steps you followed. Nevertheless, these changes remain stable and consistent within a single project. The information about working with staging tables is provided in this document's Addendum paragraph.

## Step 2: Review by Terminology Expert

A designated terminology expert from OHDSI Vocabulary team should review the suggested change. The expert(s) should evaluate the proposed modification against established criteria, including, but not limited to:

- Relevance to OMOP CDM's research objectives
- Compatibility with the OMOP CDM structure
- Consistency with existing standards and guidelines
- Potential impact on data integrity and analytical results

## Step 3: Consultation with Stakeholders

If necessary, the terminology expert(s) should engage relevant stakeholders, such as data modelers, domain experts, and data users, to gather additional insights and feedback on the proposed change.

## Step 4: Decision and Documentation

Based on the review and consultation, the terminology expert(s) should make an informed decision regarding the acceptance, rejection, or modification of the suggested terminology change. The decision should be documented, along with the reasoning behind it.

## Step 5: Implementation of Approved Changes

If the suggested terminology change is approved, the terminology expert(s) should update the OMOP CDM terminology database accordingly. This update is conducted following established data management protocols to ensure accuracy and consistency.

## Step 6: Communication of Changes

All relevant stakeholders should be informed of the implemented terminology change. This communication should include clear documentation of the updated terminologies, version control information, and any necessary guidance on adapting to the changes.

## Step 7: Monitoring and Feedback

After the implementation of the terminology change, ongoing monitoring is crucial to identify any unexpected issues or impacts. Stakeholders should provide feedback and report any encountered problems to the designated team for continuous improvement.

## Revision History

This SOP should be reviewed periodically, or whenever significant changes occur in the OMOP CDM or its related terminologies. Any updates or modifications to this procedure should be documented with the date and reason for the revision.

## Addendum

## Local changes to an OMOP CDM instance

When dealing with a local terminology change, additional substeps involving the use of the staging tables in the OMOP CDM can help ensure a smooth and controlled process. These substeps focus on the temporary staging of concepts and relationships related to the proposed terminology change. Here's an expanded version of the procedure:

### SubStep 1: Ensure Acquiring the Necessary Knowledge

- [**Standardized Vocabularies**](https://github.com/OHDSI/Vocabulary-v5.0/wiki/Standardized-Vocabularies)
- [**Vocabulary development process**](https://github.com/OHDSI/Vocabulary-v5.0/wiki/Vocabulary-development-process)
- [**Clinical Data Tables**](https://ohdsi.github.io/CommonDataModel/cdm54.html)

**Glossary**

**Basic tables:** These are the fundamental tables with a specific structure that form the Standardized Vocabularies in OMOP CDM. They include the following tables: concept, concept\_relationship, concept\_ancestor, concept\_synonym, vocabulary, relationship, domain, and concept\_class.

**Staging tables** (Table 1): These are interim tables identified by the "\_stage" postfix. They are used to populate the corresponding basic tables:

- concept\_stage =\> concept
- concept\_relationship\_stage =\> concept\_relationship
- concept\_ancestor\_stage =\> concept\_ancestor
- concept\_synonym\_stage =\> concept\_synonym
- vocabulary\_stage =\> vocabulary

**Obligatory staging tables:** The following staging tables are mandatory for any change: concept\_stage, concept\_relationship\_stage, vocabulary\_stage.

**Optional staging tables:** The following staging tables are optional and may be used based on specific needs: concept\_ancestor\_stage (if changes in the hierarchy are required), concept\_synonym\_stage (if you want to add or modify synonyms).

**Table 1. Staging tables content description**

| **table** | **content** | **columns** |
| --- | --- | --- |
| concept\_stage | all concepts to be modified | concept\_id, concept\_name, domain\_id, vocabulary\_id, concept\_class\_id, standard\_concept, concept\_code, valid\_start\_date, valid\_end\_date, invalid\_reason |
| concept\_relationship\_stage | modified terminology mappings to standard OMOP concepts | concept\_id\_1, concept\_id\_2, concept\_code\_1, concept\_code\_2, vocabulary\_id\_1, vocabulary\_id\_2, relationship\_id, valid\_start\_date, valid\_end\_date, invalid\_reason |
| vocabulary\_stage | all affected vocabulary\_ids | vocabulary\_id, vocabulary\_name, vocabulary\_reference, vocabulary\_version |
| concept\_ancestor\_stage | new hierarchical nodes for modified concepts | ancestor\_concept\_id, descendant\_concept\_id, ancestor\_concept\_code,descendant\_concept\_code, ancestor\_vocabulary\_id, descendant\_vocabulary\_id, min\_levels\_of\_separation, max\_levels\_of\_separation |
| concept\_synonym\_stage | synonymous names for modified concepts | synonym\_concept\_id, synonym\_name, synonym\_concept\_code, synonym\_vocabulary\_id, language\_concept\_id |

**Standard\_concept:** This field indicates the role of a concept within OMOP CDM (Table 2).

**Table 2. Standard concept value meaning**

| **standard\_concept value** | **description** |
| --- | --- |
| S | Concepts marked with "S" are designated as normative expressions of clinical entities within the OMOP Common Data Model and standardized analytics. Each Standard Concept belongs to a specific domain, which determines the expected location of the Concept within the data tables of the CDM. It is important to note that in certain cases, some source concepts can be customized and designated as Standard when required. |
| C | Concepts marked with "C" are classification concepts that do not directly represent clinical facts but instead represent groups or categories. While they can be used for creating concept sets, they should not be utilized in patient data within the CDM. |
| NULL | Non-standard concepts may or may not have mappings. The presence of a mapping for a particular non-standard concept depends on the existence of the respective entry in the concept\_relationship table. |

**Source vocabulary\_id:** This is a unique custom vocabulary name utilized by the data source. It can be created by an Extract, Transform, Load (ETL) specialist or represent commonly used coding systems (e.g., ICD10CM, NDC). It serves as an analogous concept to the vocabulary\_id in CDM vocabularies.

**Source concept\_code:** This refers to the source value that uniquely identifies information to be mapped to a standard concept. It corresponds to the concept\_code used in CDM vocabularies. In cases where the source data lacks specific source identifiers and contains only definitions, concept\_code and concept\_name will be populated with the same values. Additionally, if required, concatenation of multiple source fields to generate a concept code is allowed to achieve greater granularity during mapping.

**Source concept\_name:** This field provides a description of the concept\_code. It serves as an analogous entity to the concept\_name used in CDM vocabularies.

### SubStep 2: Create Staging Tables

For the proposed local terminology change, create a temporary staging table, such as concept\_stage, concept\_relationship\_stage, vocabulary\_stage to hold the modified or new concepts. This table should follow the structure of the concept table in the OMOP CDM. Skip this step if staging tables are already created in the database.

**Example:**

``` sql
DROP TABLE IF EXISTS @cdm_schema.concept_stage;
CREATE TABLE @cdm_schema.concept_stage
(
   concept_id          INTEGER,
   concept_name        TEXT,
   domain_id           VARCHAR(50),
   vocabulary_id       VARCHAR(100),
   concept_class_id    VARCHAR(20),
   standard_concept    VARCHAR(1),
   concept_code        TEXT,
   valid_start_date    DATE,
   valid_end_date      DATE,
   invalid_reason      VARCHAR(1)
);

DROP TABLE IF EXISTS @cdm_schema.concept_relationship_stage;
CREATE TABLE @cdm_schema.concept_relationship_stage
(
   concept_id_1        INTEGER,
   concept_id_2        INTEGER,
   concept_code_1      TEXT,
   concept_code_2      TEXT,
   vocabulary_id_1     VARCHAR(100),
   vocabulary_id_2     VARCHAR(100),
   relationship_id     VARCHAR(50),
   valid_start_date    DATE,
   valid_end_date      DATE,
   invalid_reason      VARCHAR(1)
);

DROP TABLE IF EXISTS @cdm_schema.concept_synonym_stage;
CREATE TABLE @cdm_schema.concept_synonym_stage
(
   synonym_concept_id          INTEGER,
   synonym_name                VARCHAR (1000),
   synonym_concept_code        TEXT,
   synonym_vocabulary_id       VARCHAR(100),
   language_concept_id         INTEGER
);

DROP TABLE IF EXISTS @cdm_schema.concept_ancestor_stage;
CREATE TABLE @cdm_schema.concept_ancestor_stage
(
   ancestor_concept_id         INTEGER,
   descendant_concept_id       INTEGER,
   ancestor_concept_code       TEXT,
   descendant_concept_code     TEXT,
   ancestor_vocabulary_id      VARCHAR(100),
   descendant_vocabulary_id    VARCHAR(100),
   min_levels_of_separation    INTEGER,
   max_levels_of_separation    INTEGER
);

DROP TABLE IF EXISTS @cdm_schema.vocabulary_stage;
CREATE TABLE @cdm_schema.vocabulary_stage
(
   vocabulary_id           VARCHAR(100),
   vocabulary_name         VARCHAR(255),
   vocabulary_reference    VARCHAR(255),
   vocabulary_version      VARCHAR(255),
   vocabulary_concept_id   INTEGER
);
```

### SubStep 3: Populate Staging Tables with the required changes

**Example: You need to correct the erroneous mapping of ICD10CM code C44.621.**

1. Insert the modified or new concepts, along with their relevant attributes/metadata (if required) into the concept\_stage.
``` sql
INSERT INTO concept_stage
(
  concept_name,
  domain_id,
  vocabulary_id,
  concept_class_id,
  standard_concept,
  concept_code,
  valid_start_date,
  valid_end_date,
  invalid_reason
)
SELECT
       'Squamous cell carcinoma skin/ unsp upper limb, inc shoulder' AS concept_name,
       'Condition' AS domain_id,
       'ICD10CM' AS vocabulary_id,
       '6-char billing code' AS concept_class_id,
       NULL AS standard_concept,
       'C44.621' AS concept_code,
       TO_DATE('2006-12-30','yyyy-mm-dd') AS valid_start_date, 
       TO_DATE('2099-12-31','yyyy-mm-dd') AS valid_end_date,
       NULL AS invalid_reason;

-- OR 

INSERT INTO concept_stage
(
  concept_name,
  domain_id,
  vocabulary_id,
  concept_class_id,
  standard_concept,
  concept_code,
  valid_start_date,
  valid_end_date,
  invalid_reason
)
SELECT
       concept_name AS concept_name,
       domain_id AS domain_id,
       vocabulary_id AS vocabulary_id,
       concept_class_id AS concept_class_id,
       standard_concept AS standard_concept,
       concept_code AS concept_code,
       valid_start_date AS valid_start_date, 
       valid_end_date AS valid_end_date,
       invalid_reason AS invalid_reason FROM @cdm_schema.concept
WHERE concept_code = 'C44.621' AND vocabulary_id = 'ICD10CM';
```
2) Insert the modified or new relationships between concepts into the concept\_relationship\_stage table. Use the concept\_codes (not concept\_ids) to assign concept\_code\_1 and concept\_code\_2 columns of concept\_relationship\_stage.
``` sql
INSERT INTO concept_relationship_stage
(
  concept_code_1,
  concept_code_2,
  vocabulary_id_1,
  vocabulary_id_2,
  relationship_id,
  valid_start_date,
  valid_end_date,
  invalid_reason
)
SELECT 'C44.621' AS concept_code_1, -- code of a source concept to be modified
      '403897007' AS concept_code_2, -- code of a correct target standard concept 
      'ICD10CM' AS vocabulary_id_1, -- source vocabulary
      'SNOMED' AS vocabulary_id_2, -- target vocabulary
      'Maps to' AS relationship_id, -- new relationship_id
       current_date AS valid_start_date,
       TO_DATE('2099-12-31','yyyy-mm-dd') AS valid_end_date,     
       NULL AS invalid_reason;

-- OR 

INSERT INTO concept_relationship_stage
(
  concept_code_1,
  concept_code_2,
  vocabulary_id_1,
  vocabulary_id_2,
  relationship_id,
  valid_start_date,
  valid_end_date,
  invalid_reason
)
SELECT 'C44.621' AS concept_code_1, -- code of a source concept to be modified
      concept_code AS concept_code_2, -- code of a correct target standard concept 
      'ICD10CM' AS vocabulary_id_1, -- source vocabulary
      vocabulary_id AS vocabulary_id_2, -- target vocabulary
      'Maps to' AS relationship_id, -- new relationship_id
       current_date AS valid_start_date,
       TO_DATE('2099-12-31','yyyy-mm-dd') AS valid_end_date,     
       NULL AS invalid_reason
FROM @cdm_schema.concept WHERE concept_id = 4301427; --new target concept’s concpet_id
```
3) Insert the affected vocabulary\_id into the vocabulary\_stage table.

``` sql
INSERT INTO vocabulary_stage
(
  vocabulary_id,
  vocabulary_name,
  vocabulary_reference,
  vocabulary_version
) WITH t1
AS
(SELECT DISTINCT vocabulary_id
FROM concept_stage) 
       SELECT DISTINCT b.vocabulary_id,
       b.vocabulary_id,
       b.vocabulary_reference, 
       b.vocabulary_version
FROM t1 a 
JOIN @cdm_schema.vocabulary b ON b.vocabulary_id = a.vocabulary_id;
```
### SubStep 4: Perform Validation Checks

Perform thorough validation and testing of the staged concepts and relationships to ensure they adhere to the OMOP CDM standards and do not introduce any data integrity issues.

``` sql
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
```

### SubStep 5: Run [Generic Update](https://github.com/OHDSI/Vocabulary-v5.0/blob/master/working/generic_update.sql)

The Generic Update script is supported by the OHDSI Vocabulary team and designed to work with staging tables, which are interim tables used to hold the updated or new data before it is merged into the basic OMOP CDM tables. By utilizing staging tables, the script ensures that changes are carefully validated and checked before they are applied to the main CDM tables, preventing data integrity issues and preserving data quality.

### SubStep 6: Finalization and Cleanup

After the approved changes have been implemented successfully and verified, remove or truncate the temporary staging tables.

### SubStep 7: Versioning

Ensure appropriate versioning of your OMOP CDM instance after the changes have been finalized to track and document the modifications for future reference.
