#!/bin/ash

rspamd -u rspamd -g rspamd -f
cat /var/log/rspamd/rspamd.log
