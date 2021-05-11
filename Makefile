PHONY: clean

clean:
	rm -f trialsimulation.pdf trialsimulation.tar.gz

trialsimulation.pdf: trialsimulation.tar.gz
	rm -rf tmp_extract
	mkdir tmp_extract
	tar xvzf trialsimulation.tar.gz --directory tmp_extract
	cd tmp_extract/trialsimulation && R -e "devtools::build_manual()"
	cp tmp_extract/trialsimulation_`cat DESCRIPTION | grep Version | cut -d' ' -f2`.pdf ./trialsimulation.pdf
	rm -rf tmp_extract

trialsimulation.tar.gz:
	R CMD build .
	mv trialsimulation_`cat DESCRIPTION | grep Version | cut -d' ' -f2`.tar.gz trialsimulation.tar.gz




