#!/usr/bin/gawk
BEGIN {back_window=5; front_window=5; FS="\t"; OFS="\t"; c=0; split("", xglosses)}
# throw out rows of incorrect format
NF != 7 {next}
# end of sentece processing
$3 == 1 { 
	for (t in xpos) {
		if (xpos[t] != "c" && xpos[t] != "SENT" && xpos[t] != "num" && xpos[t] !~ "/" ) {
			icw_min = t - back_window
			if (icw_min < 0) {icw_min = 0}
			icw_max = t + front_window
			if (icw_max > c) { icw_max = c }
			if (gloss[t]) {
				split(gloss[t], xglosses, "|")
				for (x in xglosses) { token_freq[xglosses[x]] += 1 }
			}
			for (i=icw_min;i<=icw_max;++i) {
				pos = i - t
				if (i == 0) {
					tagpos = "SENT:" pos
				} else {
					tagpos = xpos[i] ":" pos
				}
				lemmapos = lemma[t] "_" xpos[t]
				ngrams[lemmapos][tagpos] += 1
				token_freq[tagpos] += 1
				if (reverse) {
					ngrams[tagpos][lemmapos] += 1
				}
				if (pos != 0) {
					ngrams[xpos[t]][tagpos] += 1
				}
				if (gloss[i]) {
					split(gloss[i], posglosses, "|")
					for (g in posglosses) {
						glosspos = posglosses[g] ":" pos
						ngrams[lemmapos][glosspos] += 1
						#ngrams[xpos[t]][glosspos] += 1
						token_freq[glosspos] += 1
						if (pos != 0 && length(xglosses) > 0) {
							for (x in xglosses) {
								ngrams[xglosses[x]][glosspos] += 1
								#ngrams[xglosses[x]][tagpos] += 1
							}

						}

					}
					delete posglosses
				}
			}
			token_freq[xpos[t]] += 1
			delete xglosses 
		}
	}
	delete xpos
	delete lemma
	delete gloss
}
# every row
{ xpos[$3] = $6 ; lemma[$3] = $5 ; c = $3; docid = $1; token_freq[$5 "_" $6] += 1 }
$7 != "_" { gloss[$3] = $7 }
# end of document
$1 != docid { 
	if (bydoc) {
		for (j in ngrams) {
			for (k in ngrams[j]) {
				print j, k, token_freq[j], token_freq[k], ngrams[j][k] 
				}
			}
		delete ngrams
		delete token_freq
	}
}
# end of data
END {
	for (j in ngrams) {
		for (k in ngrams[j]) {
			print j, k, token_freq[j], token_freq[k], ngrams[j][k] 
			}
		}

}
