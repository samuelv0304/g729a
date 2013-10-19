/**
 *  g729a codec for iPhone and iPod Touch
 *  Copyright (C) 2009 Samuel <samuelv0304@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */
/****************************************************************************************
Portions of this file are derived from the following ITU standard:
   ITU-T G.729A Speech Coder    ANSI-C Source Code
   Version 1.1    Last modified: September 1996

   Copyright (c) 1996,
   AT&T, France Telecom, NTT, Universite de Sherbrooke
****************************************************************************************/

/*-----------------------------------------------------------------*
 * Main program of the G.729a 8.0 kbit/s decoder.                  *
 *                                                                 *
 *    Usage : decoder  bitstream_file  synth_file                  *
 *-----------------------------------------------------------------*/

#include <stdlib.h>
#include <stdio.h>

#include "typedef.h"
#include "basic_op.h"
#include "ld8a.h"

#  if defined(CONTROL_OPT) && (CONTROL_OPT!=0)
#    include "g729a-ctrl.h"
#  else /* CONTROL_OPT */
#    include "g729a.h"
#endif /* CONTROL_OPT */

 Word16 bad_lsf;        /* bad LSF indicator   */

/*
   This variable should be always set to zero unless transmission errors
   in LSP indices are detected.
   This variable is useful if the channel coding designer decides to
   perform error checking on these important parameters. If an error is
   detected on the  LSP indices, the corresponding flag is
   set to 1 signalling to the decoder to perform parameter substitution.
   (The flags should be set back to 0 for correct transmission).
*/

/*-----------------------------------------------------------------*
 *            Main decoder routine                                 *
 *-----------------------------------------------------------------*/

int main(int argc, char *argv[] )
{
  Word32 size;
  void *decState;
  Word16  synth[L_FRAME]; /* Synthesis                   */
  Flag badFrame;

  Word16  serial[SERIAL_SIZE];          /* Serial stream               */


  Word16  i, frame;
  FILE   *f_syn, *f_serial;

  printf("\n");
  printf("************   G.729a 8.0 KBIT/S SPEECH DECODER  ************\n");
  printf("\n");
  printf("------------------- Fixed point C simulation ----------------\n");
  printf("\n");
  printf("------------ Version 1.1 (Release 2, November 2006) --------\n");
  printf("\n");

   /* Passed arguments */

   if ( argc != 3)
     {
        printf("Usage :%s bitstream_file  outputspeech_file\n",argv[0]);
        printf("\n");
        printf("Format for bitstream_file:\n");
        printf("  One (2-byte) synchronization word \n");
        printf("  One (2-byte) size word,\n");
        printf("  80 words (2-byte) containing 80 bits.\n");
        printf("\n");
        printf("Format for outputspeech_file:\n");
        printf("  Synthesis is written to a binary file of 16 bits data.\n");
        exit( 1 );
     }

   /* Open file for synthesis and packed serial stream */

   if( (f_serial = fopen(argv[1],"rb") ) == NULL )
     {
        printf("%s - Error opening file  %s !!\n", argv[0], argv[1]);
        exit(0);
     }

   if( (f_syn = fopen(argv[2], "wb") ) == NULL )
     {
        printf("%s - Error opening file  %s !!\n", argv[0], argv[2]);
        exit(0);
     }

   printf("Input bitstream file  :   %s\n",argv[1]);
   printf("Synthesis speech file :   %s\n",argv[2]);

/*-----------------------------------------------------------------*
 *           Initialization of decoder                             *
 *-----------------------------------------------------------------*/
  size = g729a_dec_mem_size ();
  decState = malloc(size);
  g729a_dec_init(decState);

/*-----------------------------------------------------------------*
 *            Loop for each "L_FRAME" speech data                  *
 *-----------------------------------------------------------------*/

  frame = 0;
  while( fread(serial, sizeof(Word16), SERIAL_SIZE, f_serial) == SERIAL_SIZE)
  {
    //printf("Frame =%d\r", frame++);
    badFrame = 0;
    /* the hardware detects frame erasures by checking if all bits
       are set to zero */
    for (i=2; i < SERIAL_SIZE; i++)
      if (serial[i] == 0 ) badFrame = 1; /* frame erased     */
      
	g729a_dec_process(decState, &serial[2], synth, badFrame);

    fwrite(synth, sizeof(short), L_FRAME, f_syn);

  }
  
  g729a_dec_deinit(decState);
  free(decState);

  fclose(f_serial);
  fclose(f_syn);

  return(0);
}

