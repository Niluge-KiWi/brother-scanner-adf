Brother network scanner script for linux, with support for ADF (automatic document feeder), generating jpgs and merged pdf.

Tested on Brother MFC-J825DW with ubuntu 16.04.

# Config
- Get `scantofile-0.2.4-1.sh` from this git repo
- Install `brscan-skey-0.2.4-1.amd64.deb` from https://support.brother.com/g/b/downloadlist.aspx?c=en&lang=en&prod=mfcj825dw_all&os=128&flang=English
- Edit `/opt/brother/scanner/brscan-skey/brscan-skey-0.2.4-0.cfg` to point `FILE` to `scantofile-0.2.4-1.sh`

# See also
https://support.brother.com/g/s/id/linux/en/instruction_scn5.html?c=us_ot&lang=en&comple=on&redirect=on
https://coderwall.com/p/trq4hw/brother-scanner-linux-ubuntu-server
