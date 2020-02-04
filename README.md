# MigParl - Data Package

The MigParl package consists of two main components: 1) A small sample corpus of linguistically annotated, CWB indexed plenary protocols of the German regional states which regard the subject of migration and integration and 2) a method to download the full corpus of thematically subset plenary protocols from about the year 2000 onwards.

# Download and Installation

As the data is in closed beta at the time of writing, the download method for the entire corpus is restricted by password. If you have been provided with a password by the authors of the package, the download will be started via:

```{r}
migparl_download_corpus()
```

after which you will be prompted to enter username and password. 

# Data 

The MigParl data package itself closely follows the structure of the [GermaParl corpus](https://github.com/PolMine/GermaParl) which was developed within the [PolMine](https://polmine.github.io) project. As such the plenary protocol data was linguistically annotated and imported into the [Corpus Workbench (CWB)](http://cwb.sourceforge.net). It was prepared to be used with the toolset of **polmineR**.

See the GermaParl documentation on [GitHub](https://github.com/PolMine/GermaParl) for further information. A preliminary documentation can be found in the vignette of this package.