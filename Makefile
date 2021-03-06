MANDE=../../lab/mande
DABA=$(MANDE)/daba/daba
makelexicon=PYTHONPATH=$(MANDE):$(DABA) python $(DABA)/ad-hoc/tt-make-lexicon.py
corpus=$(MANDE)/corbama-build
metafields=_auto:words _auto:sentences text:title source:type source:date corpus:adddate source:year text:script source:title text:date source:address text:genre text:medium text:translation text:theme source:pagetotal text:pages source:number source:editor corpus:operator author:name author:sex author:native_lang source:publisher corpus:sponsor source:url text:rubric text:transcription text:original_lang author:dialect text:transldata source:misc author:addon author:birth_year author:spelling
datafiles=$(patsubst %,results/corbama-net-tonal.%,lemma.tsv lemma.bydoc.tsv word.tsv word.bydoc.tsv)

test:
	$(MAKE) -s -C $(corpus) print-netfiles-fullpath | tr " " "\n" | grep .  

results/metadata.dump:
	$(MAKE) -C $(corpus) print-netfiles-fullpath | tr " " "\n" | grep .  | while read f ; do metaprint -a "$$f" ; done > $@

results/metadata.tsv:
	echo "fileid	" "$(metafields)" | tr " " "	" > $@
	make -s -C $(corpus) print-netfiles-fullpath | tr " " "\n" | grep .  | while read f ; do metaprint -d "	" $(patsubst %,-f % ,$(metafields)) "$$f" ; done | sed 's,/home[^\\t]corbama/,,' >> $@

data/%.lemma.tsv: data/%.lemma.vert scripts/vert2tsv.awk
	gawk -f scripts/vert2tsv.awk $< > $@

results/%.lemma.tsv: data/%.lemma.tsv scripts/tsv2ngrams.awk
	gawk -f scripts/tsv2ngrams.awk $< | sort -nr -k5 -k3 -k4 > $@

results/%.word.tsv: data/%.lemma.tsv scripts/tsv2ngrams.awk
	gawk -f scripts/tsv2ngrams.awk -v useword=1 $< | sort -nr -k5 -k3 -k4 > $@

results/%.word.bydoc.tsv: data/%.lemma.tsv scripts/tsv2ngrams.awk
	gawk -f scripts/tsv2ngrams.awk -v useword=1 -v bydoc=1 $< | sort -k1,1 -k6,6nr > $@

results/%.lemma.bydoc.tsv: data/%.lemma.tsv scripts/tsv2ngrams.awk
	gawk -f scripts/tsv2ngrams.awk -v bydoc=1 $< | sort -k1,1 -k6,6nr > $@


results/corbama-net-tonal.lemma.counts.tsv: data/corbama-net-tonal.tsv scripts/ngram.count.awk
	cat $< | gawk -f scripts/ngram.count.awk | sort -nr -k5 > $@

README.html: README.md
	pandoc -t html $< > $@

%.ppmi.csv: %.counts.tsv
	python3 scripts/sppmi.vec.py $< $@

lexicon-bamadaba.txt:
	$(makelexicon) -r $(corpus)/run/ | LC_ALL=bm_ML sort > $@

dataset: $(datafiles) results/metadata.tsv README.html
	zip -j -r ngrams-corbama-net-tonal-$(shell date +%Y%m%d).zip $^

# join -j1 data/folk.sorted results/corbama-net-tonal.lemma.bydoc.tsv > results/folk.lemma.bydoc.tsv
# join -j1 data/news.sorted results/corbama-net-tonal.lemma.bydoc.tsv > results/news.lemma.bydoc.tsv
#
# gawk -f scripts/ngrams.aggregate.awk results/folk.lemma.bydoc.tsv | sort -nr -k5 -k3 -k4 > results/folk.lemma.tsv
