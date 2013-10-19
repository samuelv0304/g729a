# /* G.729a  Version 1.1    Last modified: September 1996 */

#makefile for ANSI-C version of G.729A
#options for ? C compiler
# NOTE: Edit these options to reflect your particular system

#CC= cc
#CFLAGS= -w2 -std

#options for HP C compiler
#CC= c89
#CFLAGS= -O -Aa

# options for SGI C compiler
#CC=cc
#CFLAGS= -O2 -mips2 -float -fullwarn -ansi
#CFLAGS= -g -mips2 -float -fullwarn

# Options for GCC C compiler
#CC= gcc
#CFLAGS = -O2 -Wall

# Options for Sun C compiler
#CC= cc
#CFLAGS = -O2 -Xc -D__sun

# objects needed for encoder

OBJECTS= \
 acelp_ca.o\
 basic_op.o\
 bits.o\
 cod_ld8a.o\
 dspfunc.o\
 filter.o\
 gainpred.o\
 lpc.o\
 lpcfunc.o\
 lspgetq.o\
 oper_32b.o\
 p_parity.o\
 pitch_a.o\
 pre_proc.o\
 pred_lt3.o\
 qua_gain.o\
 qua_lsp.o\
 tab_ld8a.o\
 util.o\
 taming.o\
 cor_func.o\
 g729a_encoder.o
 
OBJECTS+= coder.o

OBJS = $(foreach file, $(OBJECTS), $(OBJDIR)/$(file))

coder : $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJS) -o $(EXEDIR)/$(ARCH)_coder

# Dependencies for each file

%.o: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $(OBJDIR)/$@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $(OBJDIR)/$@
