cd /opt/flatfiles
tar cp * | bzip2 > ../flatfiles-daily/flatfiles.`date --rfc-3339=date`.tar.bz2
rm /opt/flatfiles/*/*
