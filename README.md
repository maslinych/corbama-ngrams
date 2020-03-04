## Positional skipgrams for Bambara Reference Corpus (Disambiguated subcorpus)

This dataset contains linguistically rich n-gram frequency data for
Bambara based on the disambiguated part of the Bambara Reference
Corpus (corbama-net-tonal). The n-grams in the dataset are *positional
skipgrams* that capture information about co-occurrence of lexical
items with grammatical categories at various relative positions. These
n-grams were constructed with the aim to leverage those types of
information that are available in the morphologically annotated
corpus of Bambara given the limited amount of textual data.

The idea of positional skipgrams is discussed in the accompanying
paper, along with the description of methodology and data used for
constructing n-grams for Bambara and a brief illustration of how the
positional skipgrams data may be employed in corpus-based linguistic
research. 

The paper:

* *Kirill Maslinsky*, « Positional skipgrams for Bambara: a resource for
  corpus-based studies », Mandenkan 62 | 2019. 
  <http://journals.openedition.org/mandenkan>

Please cite the accompanying paper if you use this dataset in research.

This dataset is made available under the Open Data Commons Attribution
License: <http://opendatacommons.org/licenses/by/1.0>

The current version of the dataset is available at: 
<http://cormand.huma-num.fr/ngrams/corbama-net-tonal-latest.zip>

The source code for the dataset generation, and for the paper is
available at: <http://github.com/maslinych/corbama-ngrams>

### Files included in the dataset

This version of the data was produced from the corpus
(corbama-net-tonal) on March, 4, 2020. 

For the convenience of dataset users, the skipgram frequency data is
presented in several variants. First, the data is split according to
the basic lexical item used for building skipgrams that is either an
orthographically normalized wordform, or a canonical lemma. Second,
frequency data on both wordfrom-based and lemma-based skipgrams are
presented in two forms: an aggregated variant showing total counts for
a whole corpus, and a disaggregated variant showing document-level
frequencies.

* `corbama-net-tonal.lemma.tsv` — lemma-based skipgrams, counts
  aggregated for the whole corpus;
* `corbama-net-tonal.lemma.bydoc.tsv` — lemma-based skipgrams, counts
  aggregated on the document level;
* `corbama-net-tonal.word.tsv` — wordform-based skipgrams, counts
  aggregated for the whole corpus;
* `corbama-net-tonal.word.bydoc.tsv` — wordform-based skipgrams, counts
  aggregated on the document level;
* `metadata.tsv` — metadata for all the corpus files with ids matching
  the ids in the data.
* `README.html` — this file.

### The format of the data files 

The data is presented in a text-based tabular format. Skipgram frequency
tables are in the TSV (tab separated values) format and contain the following
columns:

* document id matching id in the metadata table [present only in *.bydoc.* files];
* lexical item, tag or standard gloss;
* its positional collocate;
* total frequency of the lexical item/tag/gloss;
* total frequency of the collocate;
* frequency of the co-occurrence of the item with the collocate (n-gram frequency);
* a label indicating the type of the collocate (word–tag, tag–tag, etc.) to facilitate filtering.

All data are in encoded in the UTF-8.
