MANDE=../../lab/mande
DABA=$(MANDE)/daba/daba
makelexicon=PYTHONPATH=$(MANDE):$(DABA) python $(DABA)/ad-hoc/tt-make-lexicon.py
corpus=$(MANDE)/corbama-build

test:
	$(MAKE) -s -C $(corpus) print-netfiles-fullpath | tr " " "\n" | grep .  

results/metadata.dump:
	$(MAKE) -C $(corpus) print-netfiles-fullpath | tr " " "\n" | grep .  | while read f ; do metaprint -a "$$f" ; done > $@

results/metadata.tsv:
	make -s -C $(corpus) print-netfiles-fullpath | tr " " "\n" | grep .  | while read f ; do metaprint -d "	" -a "$$f" ; done > $@

data/%.lemma.tsv: data/%.lemma.vert scripts/vert2tsv.awk
	gawk -f scripts/vert2tsv.awk $< > $@

results/%.lemma.tsv: data/%.lemma.tsv scripts/tsv2ngrams.awk
	gawk -f scripts/tsv2ngrams.awk $< | sort -nr -k5 -k3 -k4 > $@

results/%.lemma.bydoc.tsv: data/%.lemma.tsv scripts/tsv2ngrams.awk
	gawk -f scripts/tsv2ngrams.awk -v bydoc=1 $< | sort -k1,1 -k6,6nr > $@


results/corbama-net-tonal.lemma.counts.tsv: data/corbama-net-tonal.tsv scripts/ngram.count.awk
	cat $< | gawk -f scripts/ngram.count.awk | sort -nr -k5 > $@

%.ppmi.csv: %.counts.tsv
	python3 scripts/sppmi.vec.py $< $@

lexicon-bamadaba.txt:
	$(makelexicon) -r $(corpus)/run/ | LC_ALL=bm_ML sort > $@

# join -j1 data/folk.sorted results/corbama-net-tonal.lemma.bydoc.tsv > results/folk.lemma.bydoc.tsv
# join -j1 data/news.sorted results/corbama-net-tonal.lemma.bydoc.tsv > results/news.lemma.bydoc.tsv
#
# gawk -f scripts/ngrams.aggregate.awk results/folk.lemma.bydoc.tsv | sort -nr -k5 -k3 -k4 > results/folk.lemma.tsv
