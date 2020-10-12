# NCEAS-DF-SASAP-semantics

* **Contributors:** Samantha Csik
* **Contact:** scsik@nceas.ucsb.edu

### Overview

Semantic annotations can help to improve data discoverablity within the State of Alaska's Salmon and People (SASAP) [data portal](https://knb.ecoinformatics.org/projects/SASAP/Data). A current need is to evaluate metadata across the SASAP's data archive for commonly used (and perhaps "semantically important") terms, which may provide useful for constructing a salmon-specific ontology.

This repository provides code for:

  * querying the SASAP corpus for specific metadata fields (titles, keywords, abstracts, and entity- & attribute-level information) -- LAST QUERIED ON 2020-10-09
  * text mining and data wrangling necessary for extracting commonly used terms across various metadata fields
  * visualizing term frequencies

### Getting Started

Scripts are numbered in the order of data processing workflow. Required packages (`0_libraries.R`) and custom functions (`0_functions.R`) are sourced into each script for streamlining setup and reducing clutter. Processed data are saved as .csv files in `data`, so it is not necessary to rerun code unless using an updated query.

### Repository Structure

```
NCEAS-DF-SASAP-semantics
  |_code
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

* `0_libraries.R`: packages required in subsequent scripts
* `0_functions.R`: custom functions for data wrangling & plotting; information regarding function purpose and arguments is included in the script 
* `1_query_download_metadata.R`: uses solr query to extract package identifiers; use `eatocsv` package to parse associated xml files to tidy attribute information (including semantic annotations, if applicable)
* `2_unnest_terms.R`: unnest (i.e. separate) titles, keywords, abstracts & attribute information into individual words, bigrams, and trigrams; data are saved as .csv files to `data/unnested_terms/*`
* `3_filterStopWords_term_counts.R`: filter out stop words and count number of occurrances of unnested terms; data are saved as .csv files to `data/filtered_term_counts/*`
* `4_plot_term_frequencies.R` : plot most common terms across each metadata field 

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
* `word1/word2/word3`: individual tokens (i.e. words); the number of columns populated will depend on whether terms are being split into individual words (col: `word`), bigrams (cols: `word1`, `word2`), or trigrams (cols: `word1`, `word2`, `word3`)

#### `data/filtered_term_counts/*`
* `word1/word2/word3`: individual tokens (i.e. words) with stop words removed (see `tidytext::stop_words()`); the number of columns populated will depend on whether terms are being split into individual words (col: `word`), bigrams (cols: `word1`, `word2`), or trigrams (cols: `word1`, `word2`, `word3`)
* `n`: # of occurrances across SASAP corpus
* `unique_ids`: # of unique identifiers that term occurs in 
* `unique_authors`: # of unique authors that have used that term (NOTE: many SASAP data packages do not have an author listed, so this is not super informative...)

### Software

These analyses were performed in R (version 3.6.3). See [SessionInfo]() for dependencies.

### Acknowledgements

Work on this project was supported by: ...
