BEGIN { OFS = "\t" }
/<doc/ { match($0, /id="([^"]+)"/, meta); docid=meta[1] ; sentid = 0 ; next}
$3 == "Tag" {next}
/<s>/ { sentid += 1 ; tokid = 1 ; next}
/<\/?[sp]>/ {next}
/<\/doc>/ {next}
{ split($4, glosses, "|"); 
	for (g in glosses) { 
		if (glosses[g] ~ /^([0-9.]+)?[[:upper:]][[:upper:].0-9]+$/ && glosses[g] != "CARDINAL") 
		{ if (gram) { gram = gram "|" glosses[g] } else { gram = glosses[g] } }
	} 
  if (gram == "") { gram = "_" }
  if ($2 == "") { $3 = $1 }
  if ($3 == "") { $3 = "_" }
  print docid, sentid, tokid, $1, $2, $3, gram
  gram = ""
  tokid += 1
}
