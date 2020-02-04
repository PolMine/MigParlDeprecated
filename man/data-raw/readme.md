# Structure of the data-raw directory
[2019-11-03]
* adapted workflow described below, documents in making-of directory
* data_report directory holds the data report

[2019-06-04]
* restructured the creation workflow of MigParl as follows
	* coming from the PopParl indexation 2019-03-25, topic modelling is performed on all corpora. The workflow and the lda topic models themselves are stored with the PopParl package
	* we use a dictionary approach to determine the relevant topics for migration and integration research. This workflow is explained in 01_Topic_Selection_By_Dictionary.Rmd
	* we encode speeches and the probabilities of a speech belonging in the "migration and integration" category in the PopParl corpora. This workflow is documented in 02_Encode_Speeches_and_Topic_Probabilities.Rmd
	* we subset the corpora we enriched with topic probabilities and decode the resulting subcorpora, saving the token stream and metadata seperately. This is documented in 03_Subset_Corpora_By_Migration_and_Integration_Probability.Rmd
	* we merge and reencode these token streams and metadata tables, performing CWB-indexation in the process. This is explained in 04_Reencode_Token_Streams_To_CWB.Rmd.

