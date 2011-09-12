#
#   Makefile
#

MAINTEX = qcont 
CP = cp
RM = rm -f
LATEX = latex
PDFLATEX = pdflatex
LHS = lhs2TeX
LHSPAR = --poly
LHSFILES = $(MAINTEX)
EXT = *.ptb *.blg *.log *.aux *.lof *.lot *.bit *.idx *.glo *.bbl *.ilg *.toc *.out *.ind *~ *.ml* *.mt* *.th* *.bmt *.xyc
PAG =
NUM =

default: pdflatex

all: lhs2TeX dvi ps pdf

lhs2TeX:
	for LHSFILE in $(LHSFILES) ;\
	  do \
		$(LHS) $(LHSPAR) $$LHSFILE.lhs -o $$LHSFILE.tex ;\
	  done

dvi: lhs2TeX
	$(LATEX) $(MAINTEX).tex
	#bibtex $(MAINTEX)

	@latex_count=5 ; \
	while egrep -s '(Rerun (LaTeX|to get cross-references right)|rerun LaTeX)' $(MAINTEX).log && [ $$latex_count -gt 0 ] ;\
	    do \
	      echo "Rerunning latex...." ;\
	      $(LATEX) $(MAINTEX).tex ;\
	      latex_count=`expr $$latex_count - 1` ;\
	    done

ps: dvi
	dvips -f $(MAINTEX).dvi > $(MAINTEX).ps

pdflatex: lhs2TeX
	$(PDFLATEX) $(MAINTEX).tex
	bibtex $(MAINTEX)
	@latex_count=5 ; \
	while egrep -s 'Rerun (LaTeX|to get cross-references right)' $(MAINTEX).log && [ $$latex_count -gt 0 ] ;\
	    do \
	      echo "Rerunning latex...." ;\
	      $(PDFLATEX) $(MAINTEX).tex ;\
	      latex_count=`expr $$latex_count - 1` ;\
	    done

clean:
	$(RM) $(EXT)
	for LHSFILE in $(LHSFILES) ;\
	  do \
		rm -f $$LHSFILE.tex ;\
	  done

clean-all: clean
	$(RM) *.dvi
	$(RM) PS/*.ps
	$(RM) PDF/*.pdf

tar: clean
	alias NOMBRE="basename `pwd`";\
	tar -cvjf `NOMBRE`.tar.bz2\
	        --exclude "*.bz2"\
	        --exclude "*.dvi"\
		--exclude "*.tar.bz2"\
	        ../`NOMBRE`/ ;\
	unalias NOMBRE

help:
	@echo "    make dvi"
	@echo "    make all           -- tex dvi ps pdf"
	@echo "    make ps"
	@echo "    make pdflatex      -- default"
	@echo "    make clean"
	@echo "    make clean-all"
	@echo "    make tar"

