# Analyzing GDRP Fines

Analyzing GDPR fines imposed by the European data protection authorities could reveal the main 
reasons and focus areas of the authorities for non-compliance and could allow our organization 
to timely address similar gaps in their data privacy strategy.


# Project Summary
On May 25, 2018, the European Union (EU) “General Data Protection Regulation” (GDPR) became effective. The GDPR is a new data privacy initiative adopted by the EU to provide enhanced protection to EU citizens and their personal data. The penalties violations can result in up to twenty million euros or four percent of the company’s global annual revenue from the previous year, whichever number is higher. In addition, EU legislators impose fines for penalties to enforce data protection compliance.

## Objective
The purpose of the project is to analyze GDPR fines that have been issued since 2018 and to get: 

- **Basic insights regarding**:
  - Which industry sectors have been penalized the most?
  - Which individual companies have been penalized the most?
  - Which EU countries have the most violations?
  - Which GDPR articles have been violated the most?
  - What are the “average costs” of a violation per sector?

- **Advanced insights** by correlating the GDPR fine dataset with the population by country (POP), gross domestic product (GDP), and corruption perception index (CPI) by country, the project intents to verify the following assumptions:
  - **A higher GDP** could lead to more reported cases, because a higher GDP could mean more companies in the country
  - **A higher CPI** could lead to more reported cases, because the public sector is maybe less influenced by the companies (higher CPI score = less corrupted)
  - **A higher population** could lead to more reported cases because more data subjects could execute their rights


# Project Organization

    ├── README.md          <- The top-level README for developers using this project.
    ├── data
    │   ├── external       <- Data from third party sources.
    │   ├── interim        <- Intermediate data that has been transformed.
    │   ├── processed      <- The final, canonical data sets for modeling.
    │   └── raw            <- The original, immutable data dump.
    │
    ├── docs               <- A default Sphinx project; see sphinx-doc.org for details
    │
    ├── models             <- Trained and serialized models, model predictions, or model summaries
    │
    ├── notebooks          <- Jupyter notebooks. Naming convention is a number (for ordering),
    │                         the creator's initials, and a short `-` delimited description, e.g.
    │                         `01-data_load_and_cleaning`.
    │
    ├── references         <- Data dictionaries, manuals, and all other explanatory materials.
    │
    ├── reports            <- Generated analysis as HTML, PDF, LaTeX, etc.
    │   └── figures        <- Generated graphics and figures to be used in reporting
    │
    ├── requirements.txt   <- The requirements file for reproducing the analysis environment, e.g.
    │                         generated, e.g., with `pip freeze > requirements.txt`


# Dataset
The project created, collectd, cleaned, manipulated and stored the datasets according to the following process flow:

![Process Flow](reports/figures/dataset_process_flow.png)

> 🤝 **Decisions**: 
> - For all datasets (tables), the same unique key is created and used: country+year.
> - All cleaned datasets will be stored in the SQLite file “project_GDPR-fines.sqlite” for the following reasons:
>    - Retain data types and structure (compared to xlsx or csv)
>    - Improve access outside of Python, e.g. via an SQLite DB Browser


**Legend**
- WS: Web scraping
- DCO: Data collection
- DCL: Data cleaning and manipulation

## Primary Dataset
### GDPR fines
The GDPR fines data is the primary dataset. The information is scraped from the GDPR Enforcement Tracker website and contains details about the imposed GDPR fines. 

The information is scrapped with the Selenium library, because the GDPR information is dynamically loaded via Javascript and not available as a text in the html source code. The parsing process was written by the project team and is documented in the notebook: “01_DCO-WS_GDPR-Fines_enforcementtracker.ipynb”. 

| Column | dtype | atype | Rel. | Description |
|--------|-------|-------|------|-------------|
| ETid | str | O | No | Unique identifier assigned by the GDPR Enforcement Tracker |
| Country | str | N | Yes | Name of country |
| Date of Decision | str | O | Yes | Date when the fine was imposed |
| Fine [€] | int | Q | Yes | Amount of the fine in EUR |
| Controller/Processor | str | N | Yes | Data controller / processor / organization fined |
| Quoted Art. | str | N | Yes | Relevant GDPR article which was quoted for the imposed fine |
| Type | str | N | Yes | Reason/cause for the fine |
| Summary | str | N | Yes | Short explanation of the case |
| Authority | str | N | Yes | Name of the data protection authority who imposed the fine |
| Sector | str | N | Yes | Industry sector of the the controller/processor |


| Item | Source | Target |
|------|--------|--------|
| Access method | Web scraping (initial): Last scrap on 2021-11-28 | |
| Last update | | |
| Estimated size | | 926 records |
| No. of attributes | | 10 |
| Location | https://www.enforcementtracker.com/ | /data/external/ |
| Filename | Not applicable | gdpr_fines_enforcementtracker_p2.pkl |
| File format | HTML | Parsed: PKL |


> ⚠️ **Attention**: The initial parsing takes several hours, because for the detailed information (Summary, Authority and Sector) the page for every single case has to be opened and closed in sequence. The process also needs to be monitored due to potential timeout issues.

## Secondary Datasets
### Population
Countries of the world with their population over the years (1955 - 2020). The data is scraped from the Worldometer website. 234 out of 235 countries were parsed. Micronesia was excluded due to parsing issues. For the parsing the Beautiful Soup library is used. The parsing code was written by the project team and is documented in the notebook: “01_DCO-WS_population_worldmeter.ipynb”.

| Column | dtype | atype | Rel. | Description |
|--------|-------|-------|------|-------------|
| Country | str | N | Yes | Name of the country |
| Year | int | O | Yes | Year of population |
| Population | int | Q | Yes | Amount of population |
| Yearly % Change | float | Q | No | Yearly change of the population |
| Urban Population | int | Q | No | Amount of urban population |


| Item | Source | Target |
|------|--------|--------|
| Access method | Web scraping (initial): Last scrap on 2021-11-28 | |
| Last update | N/A | |
| Estimated size | | 4212 (Micronesia excluded) |
| No. of attributes | | 5 |
| File location | https://www.worldometers.info/population/ | /data/external/ |
| Filename | Not applicable | population_by_country_p2.pkl |
| File format | HTML table | PKL |

> 🤝 **Decisions**: Micronesia was excluded due to parsing issues. Reasons for the parsing issues are related to the fact that Micronesia does not have all the data/columns compared to the other countries in the Worldmeter dataset. Considering that this country is not relevant for our analysis (no GDPR fines in Micronesia) the project team decided not to invest more time to cover this specific parsing case and decided to exclude the country.

### CPI Scores
The CPI dataset describes the Corruption Perceptions Index (CPI) per country. The CPI scores and ranks countries/territories based on how corrupt a country’s public sector is perceived to be. It is a composite index, a combination of surveys and assessments of corruption, collected by a variety of reputable institutions. 

The data is manually downloaded from the “Transparency International” website.

| Column | dtype | atype | Rel. | Description |
|--------|-------|-------|------|-------------|
| Country | str | N | Yes | Name of country |
| ISO3 | str | N | Yes | ISO code of the country name |
| CPI Score 20xx | int | Q | Yes | Corruption Perceptions Index (CPI) score of the year |

| Item | Source | Target |
|------|--------|--------|
| Access method | Download: Last download on 2021-11-29 | |
| Estimated size | 180 records | |
| No. of attributes | 34 | |
| File location | https://www.transparency.org/en/cpi/2020/index/ | /data/external/ |
| Filename | CPI2020_GlobalTablesTS_210125.xlsx | CPI2020_GlobalTablesTS_210125.xlsx |
| File format | XLSX | XLSX |

