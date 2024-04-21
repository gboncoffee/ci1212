BEGIN {
	ADDR=0
}

/^[ \t]*[^; \t]/ {
	print ADDR, $0
	ADDR=ADDR+1
}
