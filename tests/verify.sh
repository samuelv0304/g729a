#!/bin/sh

#ldid -S armv6_coder
#ldid -S armv6_decoder

CURRENTPATH=`pwd`
LOG="${CURRENTPATH}/checkv6.log"

rm *.g729 *.pcm $LOG

for file in *.in; 
do
  name=`basename $file .in`
  time ./armv6_coder $file $name.g729 >> "${LOG}" 2>&1
#  time ./armv6coder $file $name.g729 >> "${LOG}" 2>&1
  if !(cmp $name.bit $name.g729); then
#    echo "##################################################"
#    echo "# g729a encoder verification successful          #"
#    echo "##################################################"
#  else
    echo "#############################################################"
    echo "# \!\!\! ERROR in g729a encoder verification (armv6) \!\!\! #"
    echo "#############################################################"
    exit -1;
  fi
done

for file in *.pst; 
do
  name=`basename $file .pst`
  time ./armv6_decoder $name.bit $name.pcm >> "${LOG}" 2>&1
#  time ./armv6decoder $name.bit $name.pcm >> "${LOG}" 2>&1
  if !(cmp $name.pst $name.pcm); then
#    echo "##################################################"
#    echo "# g729a decoder verification successful          #"
#    echo "##################################################"
#  else
    echo "#############################################################"
    echo "# \!\!\! ERROR in g729a decoder verification (armv6) \!\!\! #"
    echo "#############################################################"
    exit -1;
  fi 
done

## ARM V7

CURRENTPATH=`pwd`
LOG="${CURRENTPATH}/checkv7.log"

rm *.g729 *.pcm $LOG

for file in *.in; 
do
  name=`basename $file .in`
  time ./armv7_coder $file $name.g729 >> "${LOG}" 2>&1
#  time ./armv7coder $file $name.g729 >> "${LOG}" 2>&1
  if !(cmp $name.bit $name.g729); then
#    echo "##################################################"
#    echo "# g729a encoder verification successful          #"
#    echo "##################################################"
#  else
    echo "#############################################################"
    echo "# \!\!\! ERROR in g729a encoder verification (armv7) \!\!\! #"
    echo "#############################################################"
    exit -1;
  fi
done

for file in *.pst; 
do
  name=`basename $file .pst`
  time ./armv7_decoder $name.bit $name.pcm >> "${LOG}" 2>&1
#  time ./armv7decoder $name.bit $name.pcm >> "${LOG}" 2>&1
  if !(cmp $name.pst $name.pcm); then
#    echo "##################################################"
#    echo "# g729a decoder verification successful          #"
#    echo "##################################################"
#  else
    echo "#############################################################"
    echo "# \!\!\! ERROR in g729a decoder verification (armv7) \!\!\! #"
    echo "#############################################################"
    exit -1;
  fi 
done
