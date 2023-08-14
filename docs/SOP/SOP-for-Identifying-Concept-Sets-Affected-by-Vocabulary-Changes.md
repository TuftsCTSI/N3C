# Standard Operating Procedure (SOP) for Identifying Concept Sets Affected by Vocabulary Changes

## Purpose

The purpose of this Standard Operating Procedure (SOP) is to provide a systematic approach for identifying and assessing concept sets impacted by changes in the Observational Medical Outcomes Partnership (OMOP) Standardized Vocabularies. By implementing this SOP, we aim to ensure the accuracy and consistency of cohort definitions and data analysis despite evolving vocabulary versions.

## Scope

This SOP applies to all researchers and data analysts working with the OMOP Common Data Model (CDM) and utilizing concept sets within cohort definitions.

## Definitions

**OMOP CDM:** The Observational Medical Outcomes Partnership (OMOP) Common Data Model (CDM) is a standardized data structure used to organize and represent observational healthcare data.

**OMOP Standardized Vocabularies:** Refers to the medical terminologies and coding systems used to encode clinical concepts in the OMOP CDM, such as SNOMED CT, LOINC, RxNorm, ICD10CM, etc.

**Concept Set**: a list of concepts (concept IDs) from the OMOP Vocabulary that taken together describe a topic of interest for a study.

## Procedure

## Step 1: Vocabulary Change Monitoring

Engage a responsible person to monitor updates and changes to the OMOP Standardized Vocabularies, including the [release schedules](https://github.com/OHDSI/Vocabulary-v5.0/wiki/Release-planning), [release notes](https://github.com/OHDSI/Vocabulary-v5.0/wiki/Releases) and [upcoming changes](https://github.com/OHDSI/Vocabulary-v5.0/wiki/Upcoming-changes) provided by the OHDSI Vocabulary Team.

## Step 2: Identify Affected Concept Sets by Vocabulary Update

Upon receiving information about vocabulary updates, to evaluate the changes, use the R package [PhenotypeChangesInVocabUpdate](https://github.com/OHDSI/PhenotypeChangesInVocabUpdate/tree/master) to assess changes in cohort definitions and concept sets resolution when switching between OMOP vocabulary versions.

**SubStep 2.1:** Check input data. Ensure that the script will use data from the most recent OMOP vocabulary version and the target version where vocabulary changes are expected.

**SubStep 2.2:** Execute the script.

The script employs 4 key metrics to predict the impact of cohort changes:

1. **Hierarchy Changes: The script identifies**"Peak concepts", which are concepts within a given concept set where alterations to the hierarchy occur. For instance, the addition of a new relationship to this concept can result in the inclusion of a new branch, whereas the deletion of a relationship can lead to the exclusion of a branch.
2. **Source Concept Changes** : Source concepts may undergo changes in their mapping, and as a result, a new target concept may no longer belong to a hierarchy. To assess these changes, the script resolves concept sets in a cohort definition using two versions of the OMOP vocabulary. It extracts their source concept counterparts, generating two concept lists. These lists are then compared using set operations to identify additions and deletions. The user specifies the list of source vocabularies for this process.
3. **Non-Standard Nodes** in Concept Set Definition and Replacement Mapping: This metric presents non-standard concepts that are used in concept set definitions.
4. **Domain Changes in Included Concepts** : This metric provides information about concepts that have experienced changes in their domain assignment. For example, if a concept previously belonged to the "Procedure" domain but has now been moved to the "Measurement" domain, the correct event tables must be used for the affected concept sets.

**SubStep 2.3:** Analyze an output xlsx file. The script generates an Excel file with multiple tabs, each containing specific information related to concept set changes.

## Step 3: Concept Set Analysis

Using the generated report, conduct a thorough analysis of the identified concept sets to determine the severity of the impact on research and data interpretation. Categorize the affected concept sets based on the extent of changes required:

a. High Impact: Concept sets with significant changes necessitating immediate attention and modifications.

b. Moderate Impact: Concept sets with moderate changes that should be promptly addressed.

c. Low Impact: Concept sets with minor changes that are unlikely to significantly impact research outcomes.

It is essential to note that the concept set definition JSON does not automatically update with vocabulary changes.

## Step 4: Documentation

Document the identified affected concept sets, detailing the changes required for each concept set. Include information about the nature of the vocabulary change and its implications for research and analysis.

## Step 5: Communication and Prioritization

Communicate the identified affected concept sets and their impact to relevant stakeholders, including data modelers, domain experts, and data users. Seek their input and feedback on the prioritization of concept set modifications. Prioritize the affected concept sets based on their impact and urgency. Collaborate with stakeholders to decide the order in which modifications will be carried out.

## Step 6: Concept Set Modification

With respect to previous prioritization, make changes to the affected concept sets. For instance, if there are changes in the hierarchy, consider adding the necessary expression as a parent concept to the concept set. In the case of changes in mapping, incorporate a new target concept(s). If the domain is altered, ensure the respective OMOP CDM event table is populated accordingly. If there are any non-standard concepts, determine their replacement mapping, if applicable.

## Step 7: Validation and Quality Assurance

After the modification of concept sets, perform thorough data validation and quality assurance to ensure that the changes align with the CDM version and maintain data integrity.

## Step 8: Version Control and Change Log

Maintain a centralized repository for vocabulary versions and concept sets, clearly indicating the version of each vocabulary used in the OMOP CDM. Document changes made to each concept set, including the date of modification and the reason for the update. Create a change log to record all modifications made to concept sets due to vocabulary changes. This log should include details such as the affected concept set, the vocabulary change that necessitated the modification, the date of the change, and the personnel responsible for the update.

## Step 9: Monitoring and Continuous Improvement

Continuously monitor the OMOP Standardized Vocabularies and concept sets for any unexpected issues resulting from the vocabulary changes. Encourage stakeholders to provide feedback and report any encountered problems for ongoing improvement.

## Step 10: Collaboration and Knowledge Sharing

Engage in collaboration with other participating institutions within the N3C and the broader OHDSI community. Share experiences to identify concept sets affected by vocabulary changes. Promote knowledge sharing among personnel involved in managing the concept sets.

## Revision History

This SOP should be reviewed periodically or whenever significant changes occur in the OMOP Standardized Vocabularies or data management processes. Any updates or modifications to this procedure should be documented with the date and reason for the revision.
