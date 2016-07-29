#!/bin/bash
DATE=`date --rfc-3339=date`
CUTOFF=`date -d "$DATE-30days" --rfc-3339=date`
cd /opt/flatfiles
tar cp * | bzip2 > ../flatfiles-daily/flatfiles.${DATE}.tar.bz2
rm /opt/flatfiles/*/*
if [ -f "/opt/flatfiles-daily/flatfiles.${CUTOFF}.tar.bz2" ] ; then
  rm /opt/flatfiles-daily/flatfiles.${CUTOFF}.tar.bz2
fi
