SRC_PREFIX=src/
BIN_PREFIX=bin/
OBJS_PREFIX=.objs/

CC=gcc

CFLAGS=-g -Wall -Wextra -std=c89 -O3

all: $(BIN_PREFIX)bio-alignment

UTILS_SRC_PREFIX=$(SRC_PREFIX)utils/

FASTA_SRC_PREFIX=$(SRC_PREFIX)fasta/
FASTA_SRC=$(shell find $(FASTA_SRC_PREFIX) -maxdepth 1 -name '*.c')
FASTA_OBJS_PREFIX=$(OBJS_PREFIX)fasta/
FASTA_OBJS=$(patsubst $(FASTA_SRC_PREFIX)%.c,$(FASTA_OBJS_PREFIX)%.o,$(FASTA_SRC))

$(FASTA_OBJS_PREFIX)%.o: $(FASTA_SRC_PREFIX)%.c $(FASTA_SRC_PREFIX)%.h
	mkdir -p $(FASTA_OBJS_PREFIX)
	$(CC) $(CFLAGS) -c $< -o $@

NW_SRC_PREFIX=$(SRC_PREFIX)needleman-wunsch/
NW_SRC=$(shell find $(NW_SRC_PREFIX) -maxdepth 1 -name '*.c')
NW_OBJS_PREFIX=$(OBJS_PREFIX)needleman-wunsch/
NW_OBJS=$(patsubst $(NW_SRC_PREFIX)%.c,$(NW_OBJS_PREFIX)%.o,$(NW_SRC))

$(NW_OBJS_PREFIX)%.o: $(NW_SRC_PREFIX)%.c $(NW_SRC_PREFIX)%.h
	mkdir -p $(NW_OBJS_PREFIX)
	$(CC) $(CFLAGS) -I$(UTILS_SRC_PREFIX) -c $< -o $@

SW_SRC_PREFIX=$(SRC_PREFIX)smith-waterman/
SW_SRC=$(shell find $(SW_SRC_PREFIX) -maxdepth 1 -name '*.c')
SW_OBJS_PREFIX=$(OBJS_PREFIX)smith-waterman/
SW_OBJS=$(patsubst $(SW_SRC_PREFIX)%.c,$(SW_OBJS_PREFIX)%.o,$(SW_SRC))

$(SW_OBJS_PREFIX)%.o: $(SW_SRC_PREFIX)%.c $(SW_SRC_PREFIX)%.h
	mkdir -p $(SW_OBJS_PREFIX)
	$(CC) $(CFLAGS) -I$(UTILS_SRC_PREFIX) -c $< -o $@

HIRSCH_SRC_PREFIX=$(SRC_PREFIX)hirschberg/
HIRSCH_SRC=$(shell find $(HIRSCH_SRC_PREFIX) -maxdepth 1 -name '*.c')
HIRSCH_OBJS_PREFIX=$(OBJS_PREFIX)hirschberg/
HIRSCH_OBJS=$(patsubst $(HIRSCH_SRC_PREFIX)%.c,$(HIRSCH_OBJS_PREFIX)%.o,$(HIRSCH_SRC))

$(HIRSCH_OBJS_PREFIX)%.o: $(HIRSCH_SRC_PREFIX)%.c $(HIRSCH_SRC_PREFIX)%.h
	mkdir -p $(HIRSCH_OBJS_PREFIX)
	$(CC) $(CFLAGS) -I$(UTILS_SRC_PREFIX) -c $< -o $@

SCORING_FUNCTIONS_SRC_PREFIX=$(SRC_PREFIX)scoring-functions/
SCORING_FUNCTIONS_SRC=$(shell find $(SCORING_FUNCTIONS_SRC_PREFIX) -maxdepth 1 -name '*.c')
SCORING_FUNCTIONS_OBJS_PREFIX=$(OBJS_PREFIX)scoring-functions/
SCORING_FUNCTIONS_OBJS=$(patsubst $(SCORING_FUNCTIONS_SRC_PREFIX)%.c,$(SCORING_FUNCTIONS_OBJS_PREFIX)%.o,$(SCORING_FUNCTIONS_SRC))

$(SCORING_FUNCTIONS_OBJS_PREFIX)%.o: $(SCORING_FUNCTIONS_SRC_PREFIX)%.c $(SCORING_FUNCTIONS_SRC_PREFIX)%.h
	mkdir -p $(SCORING_FUNCTIONS_OBJS_PREFIX)
	$(CC) $(CFLAGS) -I$(UTILS_SRC_PREFIX) -c $< -o $@

MAIN_SRC_PREFIX=$(SRC_PREFIX)
MAIN_SRC=$(shell find $(MAIN_SRC_PREFIX) -maxdepth 1 -name '*.c')
MAIN_OBJS_PREFIX=$(OBJS_PREFIX)
MAIN_OBJS=$(patsubst $(MAIN_SRC_PREFIX)%.c,$(MAIN_OBJS_PREFIX)%.o,$(MAIN_SRC))

$(MAIN_OBJS_PREFIX)%.o: $(MAIN_SRC_PREFIX)%.c
	mkdir -p $(MAIN_OBJS_PREFIX)
	$(CC) $(CFLAGS) -I$(FASTA_SRC_PREFIX) -I$(NW_SRC_PREFIX) -I$(SW_SRC_PREFIX) -I$(HIRSCH_SRC_PREFIX) -I$(SCORING_FUNCTIONS_SRC_PREFIX) -I$(UTILS_SRC_PREFIX) -c $< -o $@

$(BIN_PREFIX)bio-alignment: $(FASTA_OBJS) $(NW_OBJS) $(SW_OBJS) $(HIRSCH_OBJS) $(MAIN_OBJS) $(SCORING_FUNCTIONS_OBJS)
	mkdir -p $(BIN_PREFIX)
	$(CC) $(CFLAGS) -I$(UTILS_SRC_PREFIX) $^ -o $@


.PHONY: clean

clean:
	rm -rf $(BIN_PREFIX) $(OBJS_PREFIX)
