# NCEAS-DF-SASAP-semantics

README needs to be updated 2021-02-23

* **Contributors:** Samantha Csik
* **Contact:** scsik@nceas.ucsb.edu

### Overview

Visit the State of Alaska's Salmon and People (SASAP) data portal [here](https://knb.ecoinformatics.org/projects/SASAP/Data)

This repository provides code for:

  * querying the SASAP corpus for package, entity, and attribute-level data (titles, keywords, abstracts, entities,  attribute) 
  * text mining and data wrangling necessary for extracting commonly used terms across various metadata fields; visualizing term frequencies
  * grouping similar attributes and assigning term URIs where possible (primarily from the [Ecosystem Ontology, ECSO](https://bioportal.bioontology.org/ontologies/ECSO/?p=summary))
  * noting which attributes need newly-defined ontological terms for annotation

### Getting Started

Scripts are numbered in the order of data processing workflow. Required packages (`00_libraries.R`) and custom functions (`00_functions.R`) are sourced into each script for streamlining setup and reducing clutter. Processed data are saved as .csv files in `data`, so it is not necessary to rerun code unless using an updated query.

### Repository Structure

```
NCEAS-DF-SASAP-semantics
  |_code
    |_assign_URIs_to_attributes
  |_data
   |_queries
    |_query2020-10-09
     |_xml
   |_unnested_terms
    |_indiv
    |_bigrams
    |_trigrams
   |_filtered_term_counts
    |_indiv
    |_bigrams
    |_trigrams
  |_figures
    |_term_frequencies
```
### Code

* `00_libraries.R`: packages required in subsequent scripts
* `00_functions.R`: custom functions for data wrangling & plotting; information regarding function purpose and arguments is included in the script 
* `01_query_download_metadata.R`: uses solr query to extract package identifiers; uses `eatocsv` package to parse associated xml files and tidy attribute information (including semantic annotations, if applicable)
* `02_unnest_terms.R`: unnest (i.e. separate) titles, keywords, abstracts & attribute information into individual words, bigrams, and trigrams; data are saved as .csv files to `data/unnested_terms/*`
* `03_filterStopWords_term_counts.R`: filter out stop words and count number of occurrances of unnested terms; data are saved as .csv files to `data/filtered_term_counts/*`
* `04_plot_term_frequencies.R` : plot most common terms across each metadata field 
* `05a_exploring_attributes.R` :
* `05b_combine_attributes_for_annotation.R`:

### Data

#### `data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_solr.csv`
* `identifier`: unique persistent identifier assigned to each ADC data package (in most cases, this is a DOI)
* `rightsHolder`: rights holder for corresponding data package
* `abstract`: data package abstract
* `keywords`: data package keywords
* `title`: data package title
* `project`: name of corresponding project (corresponds to portal name)
* `author`: first author (firstName lastName)
* `attribute`: data package attribute(s) and their corresponding attribute definitions (if available)

#### `data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv`
* `identifier`: unique persistent identifier assigned to each ADC data package (in most cases, this is a DOI)
* `entityName`: name of dataTable (or otherEnity)
* `attributeName`: The name of an attribute, as listed in a .csv file
* `attributeLabel`: A descriptive label that can be used to display the name of an attribute
* `attributeDefinition`: Longer description of the attribute, including the required context for interpreting the `attributeName`
* `attributeUnit`: Unit string for affiliated attribute
* `propertyURI`: predicate URI (if annotation exists)
* `valueURI`: object URI (if annotation exists)
* `viewURL`: URL of ADC data package
* `query_datetime_utc`: date/time of query

#### `data/unnested_terms/*`
* `identifier`: unique persistent identifier assigned to each ADC data package (in most cases, this is a DOI)
* `author`: first author of data package (if available)
* `word1/word2/word3`: individual tokens (i.e. words); the number of columns populated will depend on whether terms are being split into individual words (col: `word1`), bigrams (cols: `word1`, `word2`), or trigrams (cols: `word1`, `word2`, `word3`)

#### `data/filtered_term_counts/*`
* `word1/word2/word3`: individual tokens (i.e. words) with stop words removed (see `tidytext::stop_words()`); the number of columns populated will depend on whether terms are being split into individual words (col: `word1`), bigrams (cols: `word1`, `word2`), or trigrams (cols: `word1`, `word2`, `word3`)
* `n`: # of occurrances across SASAP corpus
* `unique_ids`: # of unique identifiers that term occurs in 
* `unique_authors`: # of unique authors that have used that term (NOTE: many SASAP data packages do not have an author listed, so this is not super informative...)

### Software

These analyses were performed in R (version 3.6.3). See [SessionInfo]() for dependencies.

### Acknowledgements

Work on this project was supported by: ...
