# Tufts CTSI / N3C-CD2H February Activity

> For CD2H deliverables, please provide detailed quantitative metrics.
> Include links to products/websites/agenda created and any CD2H manuscripts.
> Who was involved? What work did you/they do? What was the outcome of the work?
> Where can I find the work you did? How was the work accomplished?
> If the work was not completed, please explain why.
> If a task or activity hasn’t started yet, please indicate that in your report.
 
## Datavant PPRL (Kyle)
Kyle has attended ~2hrs of instructional meetings in order to incorporate Datavant PPRL software into the new TRDW for the purpose of deduplicating patient data. In ~12hrs of development time, Kyle has worked to set up an SFTP account to the LHB (Regenstrief), draft a script to automate tokenization of N3C cohort, and troubleshoot and tokenize the latest N3C submission using the Datavant software.
 
## Concept Mapping (Polina)

### Deliverables
1. MIMIC4 mapping set in the SSSOM format - a reference collection of MIMIC4 terms mapped to the OMOP Vocabulary via SSSOM
2. Flowsheets mapping set in the SSSOM format - a reference collection of terms derived from EHR Flowsheets mapped to the OMOP Vocabulary
3. Python tool for converting mapping in SSSOM to SQL inserts (v.1.0)
4. Documentation on how to use mappings in an ETL, that covers the steps required to incorporate the mappings into an ETL pipeline
5. Documentation on the process of identifying and filling gaps in the OMOP Vocabulary, that outlines the steps required to detect any missing standard concepts and add them to the system
6. Collection of ECTO terms in the OMOP CDM format, including their internal relationships, to facilitate their integration with the OMOP vocabulary in the future
7. Python tool for converting ECTO in the OMOP CDM format (v.1.0)

### Quantitative Metrics
* Number of meetings within the project per month: 15
* Number of shared mapping tables by stakeholders: 4
* Number of files processed to obtain deliverables: 7
* Number of terms mapped to OMOP via SSSOM: 872
* Number of candidate OMOP Extension concepts to be validated: 27

### Involved Stakeholders
* Internal: Andrew Williams, Marta Alvarez, Soojin Park, Gilles Clermont, Manlik Kwong, Kyle Zollo-Venecek, Kevin Auguste, Polina Talapova
* External: Tom Pollard, Abdulrahman Chahin, Nicolas Matentzoglu, Mik Kalfeltz, Anna Ostropolets, Christian Reich, Melissa Hendel, Davera Gabriel
* Organizations: Tufts, MIT Laboratory for Computational Physiology, Washington University, Semanticly Ltd, Odysseus Solutions, OHDSI, Columbia University, 
University of Pittsburgh Medical Center, University of Colorado, Johns Hopkins University School of Medicine

### Work done
* Andrew played a critical role in defining the vision and direction for the strategy, while also ensuring active communication among stakeholders to maintain alignment and progress; he also shared the Flowsheets-to-OMOP mappings that had been provided to him by Washington University representatives
* Marty was responsible for the project management and organizing the workflow
* Soojin and Gilles participated in the CHoRUS Bridge2AI Standards Calls, sharing their valuable thoughts and insights in accordance with the concept mapping approach
* Kyle assisted with enriching the MIMIC4 mapping set by incorporating Tufts MIMIC4 data, which was instrumental in achieving a more relevant mapping for Tufts
* Kevin played an important role in organizing meetings
* Tom and Abdulrahman shared the MIMIC4-to-OMOP mappings made by MIT
* Mik shared Odysseus' MIMIC4-to-OMOP approach, as well as participated in the definition of the strategy for applying SSSOM to OMOP
* Anna and Christian shared their ideas and expertise on SSSOM implementation in OMOP CDM ETL; they also proposed to implement SSSOM to ICD-10-CM-to-OMOP mappings
* Melissa and Davera shared their extensive knowledge on SSSOM, providing valuable insights and contributing significantly to the success of the project
* Nicolas provided valuable assistance with SSSOM operational definitions, as well as evaluating and validating the work done on the OMOP-on-SSSOM approach
* Manlik was the first to implement the SSSOM mapping table in his work, providing valuable feedback and contributing to the development of the project
* Polina utilized the knowledge and materials gained from communication and collaboration with stakeholders to create deliverables that met project requirements and objectives

### Outcomes
* Developed a model for the representation of source data mapping to the OMOP Vocabulary in SSSOM format
* Implemented the processing of mappings to the OMOP Vocabulary in SSSOM format
* Improved navigation through the mapping process, which is an integral part of the ETL workflow
* Formulated a strategy for identifying and filling gaps in the OMOP Vocabulary
* Initiated the integration of ECTO into the OMOP Vocabulary system

### Accomplishment Methodology
* Defined clear deliverables and established quantitative metrics to track progress
* Involved a diverse group of stakeholders from various organizations, both internal and external, to provide different perspectives and expertise
* Assigned specific roles and responsibilities to team members to ensure effective collaboration and progress towards deliverables
* Utilized feedback and insights from stakeholders to improve the mapping process and develop strategies for identifying and filling gaps in the OMOP Vocabulary

### Next Steps
* Extend MIMIC4-to-OMOP-via-SSSOM mapping collection
* Extend Flowsheets-to-OMOP-via-SSSOM mapping collection
* Optimize the Python tool for converting SSSOM mapping table into OMOP CDM format
* Revise and improve the developed documentation
* Extend collection of candidate OMOP Extension concepts to be added to the OMOP Vocabulary and process them according to the developed algorithm
* Continue working on ECTO incorporation in the OMOP Vocabulary
* Consider which additional ontologies or vocabularies can be useful to meet project objectives

### Where to Find Concept Mapping Work
To access the deliverables, interested individuals can visit the [docs](https://github.com/TuftsCTSI/N3C/tree/main/docs) directory on the CD2H GitHub.
