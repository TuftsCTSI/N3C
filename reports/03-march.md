## Tufts CTSI / N3C-CD2H March Activity

> For CD2H deliverables, please provide detailed quantitative metrics.
> Include links to products/websites/agenda created and any CD2H manuscripts.
> Who was involved? What work did you/they do? What was the outcome of the work?
> Where can I find the work you did? How was the work accomplished?
> If the work was not completed, please explain why.
> If a task or activity hasn’t started yet, please indicate that in your report.

### OHDSI Environment for N3C (Kyrylo)

Kyrylo attended 1h meeting to discuss deployment of the OHDSI tool stack on the Databricks platform and related compatibility concerns.

### ETL of EHR to OMOP (Kyle)

EHR data is being transformed from the Epic Clarity model to the OMOP CDM specification. Currently, the database contains:

- 3.59 million patients (1.48 million "active" patients)
- 57 million visits
- 92 million measurements

At this point, 709 unique concepts from Tufts' Epic Clarity data have been mapped to vocabularies supported by the OMOP CDM and OHDSI tools.

The ETL of EHR data to OMOP is nearly complete. After a review of ETL data quality, the ETL script will be ready to transform data from EHR to OMOP in production. Concepts will steadily continue to be mapped in order to meet researcher use cases and improve overall ETL quality.
