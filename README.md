[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)
[![Travis-CI Build Status](https://api.travis-ci.org/PolMine/MigParl.svg?branch=master)](https://travis-ci.org/PolMine/MigParl)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/PolMine/MigParl?branch=master&svg=true)](https://ci.appveyor.com/project/PolMine/MigParl)
[![codecov](https://codecov.io/gh/PolMine/MigParl/branch/master/graph/badge.svg)](https://codecov.io/gh/PolMine/MigParl/branch/master)

# MigParl

## A Corpus of Parliamentary Debates on Migration and Integration Affairs in Germany's Parliaments

### About

The MigParl corpus, a corpus of parliamentary debates on migration and integration affairs in Germany's parliaments, has been 
prepared in the project "MigTex - Language Ressources for Migration and Integration Research". The funding of Germany's Federal
Ministry for Family Affairs, Senior Citizens, Women and Youth (BMFSFJ) within the context of the establishment of Germany's
Centre for Integration and Migration Research (DeZIM) is gratfully acknowledged.

This repository has been created to host the website for the MigParl corpus and in order to use GitHub Issues. User feedback is
highly welcome. We encourage using this repository's issues as a feedback and quality control mechanism.


### Installing MigParl

The MigParl release is a linguistically annotated corpus that has been indexed using the Corpus Workbench (CWB) and that can be
used with the Corpus Query Processor (CQP). It is designed to be used in combination with the polmineR R package, which relies
on the CWB/CQP as an efficient backend for large, linguistically and indexed corpora.

MigParl is shipped as an R data package (unsurprisingly called MigParl) that is available via PolMine's drat repository. First
make sure you  have polmineR installed. If necessary, consult the instructions of the README file of the polmineR repository.
Then run the following lines of code.

```r
install.packages("polmineR")
library(polmineR)

install.packages("drat") # if necessary
drat::addRepo("polmine") # lowercasing "PolMine" necessary here
install.packages("MigParl")
```

The MigParl package includes a small sample drawn from the full MigParl corpus ("MIGPARLMINI"). Use the `migparl_download_corpus()`
function to download the full corpus from the webserver of the PolMine Project.

```r
library(MigParl)
migparl_download_corpus()
use("MigParl")
``` 



### MigParl - Data Package

The MigParl package consists of two main components: 1) A small sample corpus of linguistically annotated, CWB indexed plenary protocols of the German regional states which regard the subject of migration and integration and 2) a method to download the full corpus of thematically subset plenary protocols from about the year 2000 onwards.

### Download and Installation

As the data is in closed beta at the time of writing, the download method for the entire corpus is restricted by password. If you have been provided with a password by the authors of the package, the download will be started via:

```{r}
migparl_download_corpus()
```

after which you will be prompted to enter username and password. 

### Data 

The MigParl data package itself closely follows the structure of the [GermaParl corpus](https://github.com/PolMine/GermaParl) which was developed within the [PolMine](https://polmine.github.io) project. As such the plenary protocol data was linguistically annotated and imported into the [Corpus Workbench (CWB)](http://cwb.sourceforge.net). It was prepared to be used with the toolset of **polmineR**.

See the GermaParl documentation on [GitHub](https://github.com/PolMine/GermaParl) for further information. A preliminary documentation can be found in the vignette of this package.# Workflow

## Towards indexed CWB-Corpora

MigParl is a consolidated, thematically subset subcorpus of a collection of plenary protocols of the German regional states. As such, the documentation of indexiation of the entire regional state corpora is at the location of this data, which is currently not available for public. 

## From CWB to subset

### Topic Modelling

On the 16 individual collections of the German regional states a topic modelling was performed.

After that, topic relevance was estimated based on a dictionary.

### Subsetting

In order to extract only relevant speeches from the initial corpora, we add two structural attributes to the corpus: speech and migration_integration_probability (which contains the sum of the probability of a speech containing to any of the relevant topics). We then get the speeches which sum probability is greater than a predefined threshold. After extracting the tokenstream and the metadata per regional state, the raw data is stored on disk for later reencoding.

### Dicitonary Approach

In addition to the topic modelling approach, we use a dictionary approach derived from the creation process of the MigPress corpus of newspaper articles to determine relevancy. 

### Reencoding

Previously extracted tokenstreams and metadata are encoded again as a new corpus, MigParl.

### Version history of the package

[1.0.1-RC]
* added additional dictionary based sampling as a foundation for speech selection

[1.0.0-RC]
* prepared for release before the November 2019 Workshop of the MigTex project

[0.1.0]
* major update based on new initial corpora versions
* changed sampling strategy to probability based sampling
* removed workshop tutorials for general dissemination

[0.0.1.9001]
Some provisional functions to update tutorials and to find topics added.

[0.0.1.9000]
Updated tutorial references for Workshop.

[0.0.1]
First Beta for MMD Workshop.  