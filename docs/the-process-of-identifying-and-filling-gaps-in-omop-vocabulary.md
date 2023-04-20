# The Process of Identifying & Filling Gaps in OMOP Vocabulary

## Overview
The purpose of the document is to outline a process for gap detection and resolutionin the OMOP Vocabulary v.5.0. This effort is a part of the ultimate goal of the Tufts Standards Module, which implies unification of mapping approach at sites and extension of the OMOP Vocabulary, that is a critical part of the broader initiative to develop a comprehensive data infrastructure that will support research in critical care to leverage the power of big data to improve patient outcomes and facilitate research across multiple domains.

## Methodology
The process for discovering missing standard terms in OMOP CMD involves the following steps:
1. Identification of candidate concepts
2. Prioritization of candidate concepts
3. Validation of candidate concepts
4. Modeling of new standard terms
5. Local deployment
6. User acceptance testing (UAT)
7. Production deployment
8. User feedback
9. Maintenance and support
10. Presenting proposal for new concepts to the OHDSI community

## Identification of candidate concepts
To identify candidate concepts, it is essential to analyze ICU-specific data from Electronic Health Records (EHRs), open-source domain resources and use cases. That is why there are three possible scenarios:
1. Collecting unmapped codes after the initial OMOP ETL conversion at a site. This involves compiling all source terms that have no mapping to OMOP standard codes ([event_table]\_source\_concept\_id and [event_table]\_concept\_id fields have a value of 0), into one table which should contain a "count" field to show the frequency of occurrence of each source term in patient records. This step is critical in preparing for the prioritization.
2. Collecting terms from publicly available databases or resources that contain de-identified health information.
3. Creating terms in accordance with a particular use case from the site.

## Prioritization of candidate concepts
Among best practices, there are several starting points to prioritize candidate concepts to be added to the OMOP Vocabulary:
- Clinical relevance - prioritize source terms that are clinically relevant to the ICU setting and essential for monitoring or managing critically ill patients.
- Frequency of use - prioritize concepts that appear frequently in the ICU-derived EHR data.
- Uniqueness - prioritize concepts that are unique and not adequately represented in the existing OMOP Vocabulary.
- Alignment with standards - prioritize concepts that align with existing clinical practice guidelines or regulatory requirements.
- Stakeholder input - prioritize concepts that are relevant to the stakeholders' specific use cases.

After prioritization of candidate concepts, a data analyst at the site should convert the table with unmapped codes into SSSOM-like format (required fields: subject\_category, subject\_id, subject\_label, subject\_unit, subject\_specimen, subject\_value, count) and provide it with a Standard Module's domain expert using Google Drive or GitHub.

## Validation of candidate concepts
The domain expert conducts a systematic evaluation of the unmapped codes by analyzing if there are any standard OMOP equivalents that could not be found at the site, confirming the clinical relevance of the candidate concepts and verifying their alignment with established clinical practice guidelines or regulatory requirements.

## Modeling of new standard terms
After the validation process, to create a new OMOP extension concept, the domain expert doing the following:
1. Choosing the proper semantic domain and concept class;
2. Considering the unit, specimen, related device, value, or any additional information; that may be required to preserve the source term meaning;
3. Formulating preferable concept names and collecting synonyms;
4. Building hierarchical relationships with existing OMOP concepts;
5. Building attributive relationships if necessary (LOINC or SNOMED-like);
6. Recording the date when the new concept was created;
7. Unit testing;

## Local deployment
The domain expert assembles a final SSSOM mapping table for unmapped source expressions and incorporates candidate concepts into a local OMOP CDM instance by converting the SSSOM mapping table using Python into SQL inserts to populate OMOP CDM staging or basic tables:
- concept\_stage/concept
- concept\_relationship\_stage/concept\_relationship
- concept\_ancestor\_stage/concept\_ancestor
- vocabulary\_stage/vocabulary
- concept\_synonym\_stage/concept\_synonym
- domain
- concept\_class

## UAT
The domain expert performs unit testing on a local test instance of the OMOP CDM database to ensure that OMOP extension concepts work as expected. The OMOP CDM domain expert is responsible for preparing test data that includes the newly added concepts and developing test scenarios that cover all possible use cases of the concepts. A data analyst at the site executes the test cases and records any issues or defects encountered during testing. These issues are then sent to the domain expert.
The domain expert verifies the results of the tests to ensure that the newly added OMOP extension concepts are functioning as intended, checking for accuracy, completeness, and consistency. Any issues encountered during testing are documented, and the domain expert addresses them by performing fine-tuning and amendments. Testing is then repeated until all issues are resolved.
Once testing is complete and all issues have been addressed, the site signs off on the newly added concepts and ensures that they are ready for use in production. The domain expert provides ongoing support to the site to ensure that the new concepts continue to function correctly and are aligned with the OMOP CDM standards. Documentation of the testing process and any issues encountered is provided to the site for their records.

## Production deployment
The Standards Module coordinates with the site to schedule the deployment of the new OMOP extension standard concepts. The domain expert provides the site with the validated .xlsx file and the SQL queries for inserting the new concepts into the OMOP CDM database.
A data engineer at the site executes the SQL queries to insert the new concepts into the OMOP CDM database and verifies that the new concepts have been inserted correctly with no errors or issues. Also, the data engineer tests the newly added standard concepts to ensure that they are functioning as expected and meeting the requirements.
During this process and later on, the Standards Module team provides ongoing support to the site as needed to ensure that the new concepts continue to function correctly and are aligned with the OMOP CDM standards. the Standards Module team also documents the deployment process and any issues encountered during testing and deployment for future reference.

## User feedback
The newly added OMOP extension standard concepts are tested and evaluated by end-users. User feedback is collected and analyzed by the Standards Module team to identify any issues or areas for improvement. The domain expert addresses these issues and makes any necessary changes to the concepts based on the user feedback.

## Maintenance and support
The Standards Module team provides ongoing support to the sites to ensure that the new concepts continue to function correctly and are aligned with the OMOP CDM standards. Any issues or defects that arise during production use are addressed by the domain expert, and changes to the concepts are made as needed.

## Presenting new concepts to the OHDSI community
The Standards Module team presents the proposal for the new OMOP Extension concepts to the OHDSI community for review and feedback at the respective OHDSI working groups and [OHDSI Forums](https://forums.ohdsi.org/c/vocabulary-users/14). If the proposal is evaluated by the community and any necessary changes or revisions are made, the Standards Module team requests that candidate concepts be added to the OHDSI Vocabulary Team through an issue raised on the [OHDSI GitHub repository](https://github.com/OHDSI/Vocabulary-v5.0).
