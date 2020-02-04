[![Travis-CI Build
Status](https://api.travis-ci.org/PolMine/MigParl.svg?branch=master)](https://travis-ci.org/PolMine/MigParl)


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

See the GermaParl documentation on [GitHub](https://github.com/PolMine/GermaParl) for further information. A preliminary documentation can be found in the vignette of this package.