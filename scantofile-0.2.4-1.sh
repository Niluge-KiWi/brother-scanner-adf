#! /bin/bash
set +o noclobber

# patched by Thomas on 2017-12-25 after ubuntu 16.04 upgrade and brother drivers reinstall
# patched by Thomas on 2018-12-28: ADF scan
# followed https://doc.ubuntu-fr.org/imprimantes_brother
#
#   $1 = scanner device
#   $2 = friendly name
#

#   
#       100,200,300,400,600
#
device=$1
friendly_name=$2

resolution=300
jpg_quality=80 # %
merge_to_pdf=0 # 1 to enable
output_dir=$HOME/brscan
output_file=$output_dir/scan_`date +%Y-%m-%d-%H-%M-%S`


mkdir -p $output_dir
echo scanning from $friendly_name to $output_file

sleep 0.5
scanimage --device-name "$device" --resolution $resolution --batch=$output_file-%d.pnm
if [ $? -ne 0 ]; then
  echo "first scan failed, sleeping 1 second"
  sleep  1
  scanimage --device-name "$device" --resolution $resolution --batch=$output_file-%d.pnm
fi

# convert to jpg
for f in ${output_file}-*.pnm; do
  output_file_jpg="${f%.pnm}.jpg"
  convert $f -quality ${jpg_quality}% $output_file_jpg
done
rm ${output_file}-*.pnm
echo  ${output_file}-*.jpg scanned from $friendly_name

# merge to pdf
if [ "${merge_to_pdf}" -eq 1 ]; then
 output_file_merged=${output_file}.pdf
 convert ${output_file}-*.jpg $output_file_merged
 echo  $output_file_merged scanned from $friendly_name
fi
