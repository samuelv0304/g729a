# /* G.729a  Version 1.1    Last modified: September 1996 */

#makefile for ANSI-C version of G.729
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

# Options for Sun C compiler
#CC= cc
#CFLAGS = -O2 -Xc -D__sun


# objects needed for decoder

OBJECTS = \
 basic_op.o\
 bits.o\
 de_acelp.o\
 dec_gain.o\
 dec_lag3.o\
 dec_ld8a.o\
 dspfunc.o\
 filter.o\
 gainpred.o\
 lpcfunc.o\
 lspdec.o\
 lspgetq.o\
 oper_32b.o\
 p_parity.o\
 post_pro.o\
 pred_lt3.o\
 postfilt.o\
 tab_ld8a.o\
 util.o\
 g729a_decoder.o
 
OBJECTS+= decoder.o

OBJS = $(foreach file, $(OBJECTS), $(OBJDIR)/$(file))

# linker
decoder : $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJS) -o $(EXEDIR)/$(ARCH)_decoder 

# Dependencies for each routine

%.o: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $(OBJDIR)/$@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $(OBJDIR)/$@

