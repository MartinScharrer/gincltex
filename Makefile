TEXMF=${HOME}/texmf
INSTALLDIR=${TEXMF}/tex/latex/gincltex
DOCINSTALLDIR=${TEXMF}/doc/latex/gincltex
CP=cp
RMDIR=rm -rf
PDFLATEX=pdflatex -interaction=batchmode
LATEXMK=latexmk -pdf -silent

PACKEDFILES=gincltex.sty
DOCFILES=gincltex.pdf
SRCFILES=gincltex.dtx gincltex.ins README Makefile

all: unpack doc

package: unpack
class: unpack

${PACKEDFILES}: gincltex.dtx gincltex.ins
	yes | pdflatex gincltex.ins

unpack: ${PACKEDFILES}

# 'doc' and 'gincltex.pdf' call itself until everything is stable
doc: gincltex.pdf
	@${MAKE} --no-print-directory gincltex.pdf

pdfopt: doc
	@-pdfopt gincltex.pdf .temp.pdf && mv .temp.pdf gincltex.pdf

%.pdf: %.dtx
	${PDFLATEX} $<
	-makeindex -s gind.ist -o "$@" "$<"
	-makeindex -s gglo.ist -o "$@" "$<"
	${PDFLATEX} $<
	${PDFLATEX} $<


clean:
	-latexmk -C gincltex.dtx
	${RM} ${PACKEDFILES} *.zip *.log *.aux *.toc *.vrb *.nav *.pdf *.snm *.out *.fdb_latexmk *.glo *.gls *.hd *.sta *.stp
	${RMDIR} tds

install: unpack doc ${INSTALLDIR} ${DOCINSTALLDIR}
	${CP} ${PACKEDFILES} ${INSTALLDIR}
	${CP} ${DOCFILES} ${DOCINSTALLDIR}
	texhash ${TEXMF}

${INSTALLDIR}:
	mkdir -p $@

${DOCINSTALLDIR}:
	mkdir -p $@

ctanify: ${SRCFILES} ${DOCFILES} gincltex.tds.zip
	${RM} gincltex.zip
	zip gincltex.zip $^ 
	unzip -t gincltex.zip
	unzip -t gincltex.tds.zip

zip: gincltex.zip

tdszip: gincltex.tds.zip

gincltex.zip: ${SRCFILES} ${DOCFILES} | pdfopt
	${RM} $@
	zip $@ $^ 

gincltex.tds.zip: ${SRCFILES} ${PACKEDFILES} ${DOCFILES} | pdfopt
	${RMDIR} tds
	mkdir -p tds/tex/latex/gincltex
	mkdir -p tds/doc/latex/gincltex
	mkdir -p tds/source/latex/gincltex
	${CP} ${DOCFILES}    tds/doc/latex/gincltex
	${CP} ${PACKEDFILES} tds/tex/latex/gincltex
	${CP} ${SRCFILES}    tds/source/latex/gincltex
	cd tds; zip -r ../$@ .

