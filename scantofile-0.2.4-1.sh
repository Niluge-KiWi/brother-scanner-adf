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

resolution=300 # dpi
jpg_quality=80 # %
merge_to_pdf=1 # bool; 1 to enable; 0 to disable
output_dir=$HOME/brscan
output_filename=scan_`date +%Y-%m-%d-%H-%M-%S`
output_file=$output_dir/$output_filename
notification_icon=/usr/share/icons/gnome/256x256/devices/scanner.png

mkdir -p $output_dir
echo scanning from $friendly_name to $output_file

notify-send --icon=$notification_icon Scan "Scan en cours..." --expire-time=60000 --urgency=low

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

# merge to pdf if multiple pages scanned
if [ "${merge_to_pdf}" -eq 1 -a -f ${output_file}-2.jpg ]; then
 output_file_merged=${output_file}.pdf
 convert ${output_file}-*.jpg $output_file_merged
 echo  $output_file_merged scanned from $friendly_name
fi

notify-send --icon=$notification_icon Scan "Scan terminé: ${output_filename}" --expire-time=60000 --urgency=normal

# open directory
xdg-open $output_dir
