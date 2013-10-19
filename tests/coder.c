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

/*-------------------------------------------------------------------*
 * Main program of the ITU-T G.729A  8 kbit/s encoder.               *
 *                                                                   *
 *    Usage : coder speech_file  bitstream_file                      *
 *-------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>

#include "typedef.h"
#include "basic_op.h"
#include "ld8a.h"

#  if defined(CONTROL_OPT) && (CONTROL_OPT!=0)
#    include "g729a-ctrl.h"
#  else /* CONTROL_OPT */
#    include "g729a.h"
#endif /* CONTROL_OPT */

int main(int argc, char *argv[] )
{
  FILE *f_speech;               /* File of speech data                   */
  FILE *f_serial;               /* File of serial bits for transmission  */

  Word16 serial[SERIAL_SIZE];    /* Output bitstream buffer               */
  Word16 new_speech[L_FRAME];     /* Pointer to new speech data            */
  Word32 size;
  void *encState;

  Word16 frame;                  /* frame counter */


  printf("\n");
  printf("***********    ITU G.729A 8 KBIT/S SPEECH CODER    ***********\n");
  printf("\n");
  printf("------------------- Fixed point C simulation -----------------\n");
  printf("\n");
  printf("------------ Version 1.1 (Release 2, November 2006) --------\n");
  printf("\n");


/*--------------------------------------------------------------------------*
 * Open speech file and result file (output serial bit stream)              *
 *--------------------------------------------------------------------------*/

  if ( argc != 3 )
    {
       printf("Usage : coder speech_file  bitstream_file\n");
       printf("\n");
       printf("Format for speech_file:\n");
       printf("  Speech is read from a binary file of 16 bits PCM data.\n");
       printf("\n");
       printf("Format for bitstream_file:\n");
       printf("  One (2-byte) synchronization word \n");
       printf("  One (2-byte) size word,\n");
       printf("  80 words (2-byte) containing 80 bits.\n");
       printf("\n");
       exit(1);
    }

  if ( (f_speech = fopen(argv[1], "rb")) == NULL) {
     printf("%s - Error opening file  %s !!\n", argv[0], argv[1]);
     exit(0);
  }
  printf(" Input speech file    :  %s\n", argv[1]);

  if ( (f_serial = fopen(argv[2], "wb")) == NULL) {
     printf("%s - Error opening file  %s !!\n", argv[0], argv[2]);
     exit(0);
  }
  printf(" Output bitstream file:  %s\n", argv[2]);

/*--------------------------------------------------------------------------*
 * Initialization of the coder.                                             *
 *--------------------------------------------------------------------------*/
  size = g729a_enc_mem_size ();
  encState = malloc(size);
  g729a_enc_init(encState);

  /* Loop for each "L_FRAME" speech data. */

  frame =0;
  while( fread(new_speech, sizeof(Word16), L_FRAME, f_speech) == L_FRAME)
  {
    //printf("Frame =%d\r", frame++);
    
	g729a_enc_process  (encState, new_speech, serial);

    fwrite(serial, sizeof(Word16), SERIAL_SIZE, f_serial);
  }
  
  g729a_enc_deinit(encState);
  free(encState);

  fclose(f_speech);
  fclose(f_serial);
  
  return (0);
}

