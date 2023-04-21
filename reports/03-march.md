# Tufts CTSI / N3C-CD2H March Activity

> For CD2H deliverables, please provide detailed quantitative metrics.
> Include links to products/websites/agenda created and any CD2H manuscripts.
> Who was involved? What work did you/they do? What was the outcome of the work?
> Where can I find the work you did? How was the work accomplished?
> If the work was not completed, please explain why.
> If a task or activity hasn’t started yet, please indicate that in your report.

## OHDSI Environment for N3C (Kyrylo)

Kyrylo attended 1h meeting to discuss deployment of the OHDSI tool stack on the Databricks platform and related compatibility concerns.

## ETL of EHR to OMOP (Kyle)

EHR data is being transformed from the Epic Clarity model to the OMOP CDM specification. Currently, the database contains:

- 3.59 million patients (1.48 million "active" patients)
- 57 million visits
- 92 million measurements

At this point, 709 unique concepts from Tufts' Epic Clarity data have been mapped to vocabularies supported by the OMOP CDM and OHDSI tools.

The ETL of EHR data to OMOP is nearly complete. After a review of ETL data quality, the ETL script will be ready to transform data from EHR to OMOP in production. Concepts will steadily continue to be mapped in order to meet researcher use cases and improve overall ETL quality.

## Concept Mapping (Polina)

### Deliverables
1. Extended MIMIC4 mapping set in the SSSOM format
2. Documentation on the representation of source data mapping to the OMOP Vocabulary in SSSOM format

### Quantitative Metrics
* Number of meetings within the project per month: 14 (12 hrs)
* Number of shared mapping tables by stakeholders: 2
* Number of files processed to obtain deliverables: 4
* Number of terms mapped to OMOP via SSSOM: (872)+1562
* Number of candidate OMOP Extension concepts to be validated: (27)+10

### Involved Stakeholders
* Internal: Andrew Williams, Marta Alvarez, Soojin Park, Gilles Clermont, Manlik Kwong, Kyle Zollo-Venecek, Kevin Auguste, Polina Talapova
* External: Nicolas Matentzoglu, Mik Kalfeltz

### Work Done and Outcomes
* Developed additional MIMIC4-to-OMOP-via-SSSOM mappings
* Collaborated with Nicolas and the team to create comprehensive documentation on OMOP-on-SSSOM
* Reviewed and refined previously developed documentation
* Held discussions on the next steps in the ECTO-to-OMOP implementation process with Andrew
* Expanded the collection of candidate OMOP Extension concepts to be validated
* Provided Mik Kalfeltz with feedback on the Odysseus' MIMIC4-to-OMOP mapping, including a list of discrepancies in their mapping with Tufts and MIT, and a TOP20 list of unmapped MIMIC4 concepts based on their counts

### Next Steps
* Continue extending MIMIC4-to-OMOP-via-SSSOM mapping collection
* Extend Flowsheets-to-OMOP-via-SSSOM mapping collection
* Optimize SSSOM-to-OMOP-Converter Python tool
* Continue extending the collection of candidate concepts
* Continue working on ECTO incorporation in the OMOP Vocabulary
* Revise and improve the developed documentation

## Where to Find Deliverables
To access the deliverables, please visit the [docs](https://github.com/TuftsCTSI/N3C/tree/main/docs) directory on the CD2H GitHub
