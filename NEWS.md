# Workflow

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