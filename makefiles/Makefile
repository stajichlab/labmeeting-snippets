# Test-load a GFF file into the database.
# We need to run a bunch of converter scripts on the file to transform it into a "pseudo-gff" file.
# provider file -> genome.gtf -> genome.gff3 -> genome.gff
# genome.gff -> report.txt
# genome.gff -> insert features

# ?= is a special type of variable assignment.  It won't override a variable if the variable is already defined.  So if the current makefile is included in another one, if ID is specified in that make file, it will keep its value.
# In most cases, just plain = will work fine.
ID            ?= CcinOk7h130
TAXID         ?= 240176
SOURCE        ?= Broad
TYPE          ?= chromosome
VERSION       ?= 3
PROVIDER_FILE ?= ../fromProvider/*.gtf.gz
ZIP           ?= true

ifeq ($(ZIP), true)
  CAT := zcat
else
  CAT := cat
endif

FORMAT_GTF        = format_gff
FORMAT_GTF_OPTS   = --filetype gtf --species $(ID) --type $(TYPE) --provider $(SOURCE)
# ga:
INSERT_FEAT       = GUS::Supported::Plugin::InsertSequenceFeatures
INSERT_FEAT_OPTS  = --extDbRlsVer $(VERSION) --inputFileExtension gff --fileFormat gff3 --soCvsVersion 1.417 --organism $(TAXID) --seqSoTerm $(TYPE) --seqIdColumn source_id --naSequenceSubclass ExternalNASequence --sqlVerbose

# += concatenates text to an existing variable
ifeq ($(SOURCE), JGI)
  FORMAT_GTF_OPTS += --nostart
endif


files: genome.gff report.txt

all: insertf
	${MAKE} link

clean:
	rm genome.* report.txt

genome.gtf:
	# Copy provider file and rename the id and source (first two columns).
	$(CAT) $(PROVIDER_FILE) | $(FORMAT_GTF) $(FORMAT_GTF_OPTS) > $@

genome.gff3: genome.gtf
ifeq ($(SOURCE), JGI)
	# JGI GTF transcript ids need to be prefixed when converting.
	gtf2gff3_3level.pl $< > $@
else
        # Convert Broad GTF to GFF3 format.
	convertGTFToGFF3 $< > $@
endif

genome.gff: genome.gff3
	# Convert GFF3 to pseudo GFF3 format (compatible with ISF).
	preprocessGFF3 --input_gff $< --output_gff $@

report.txt: genome.gff
	# Generate feature qualifiers for genome.gff.
	reportFeatureQualifiers --format gff3 --file_or_dir $< > $@

link: genome.gtf
	# Link files to the final directory.
	mkdir -p ../final
	cd ../final && \
	for file in $^; do \
	  ln -s ../workspace/$$file; \
	done

insertf: genome.gff
	# Run ISF to insert features.
	ga $(INSERT_FEAT) $(INSERT_FEAT_OPTS) --inputFileOrDir $< --validationLog val.log --bioperlTreeOutput bioperlTree.out > error.log 2>&1


.PHONY: files all clean link insertf
