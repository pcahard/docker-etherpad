#!/bin/bash
set -e

if [ ! -f /deluge/core.conf ]; then

	: ${DELUGE_USER:=deluge}

	if [ -z "$DELUGE_PASSWORD" ]; then
		cat >&2 << EOF
error: missing DELUGE_PASSWORD environment variable. The DELUGE_USER and
DELUGE_PASSWORD environment variables are used to generate an initial working
configuration for deluged.
EOF
	exit 1
	fi

	cat > /deluge/core.conf <<- EOF
	{
	  "file": 1, 
	  "format": 1
	}{
	  "info_sent": 0.0, 
	  "lsd": true, 
	  "max_download_speed": -1.0, 
	  "send_info": false, 
	  "natpmp": true, 
	  "move_completed_path": "/deluge/Downloads", 
	  "peer_tos": "0x00", 
	  "enc_in_policy": 1, 
	  "queue_new_to_top": false, 
	  "ignore_limits_on_local_network": true, 
	  "rate_limit_ip_overhead": true, 
	  "daemon_port": 58846, 
	  "torrentfiles_location": "/deluge/Downloads", 
	  "max_active_limit": 8, 
	  "geoip_db_location": "/usr/share/GeoIP/GeoIP.dat", 
	  "upnp": true, 
	  "utpex": true, 
	  "max_active_downloading": 3, 
	  "max_active_seeding": 5, 
	  "allow_remote": true, 
	  "outgoing_ports": [
	    0, 
	    0
	  ], 
	  "enabled_plugins": [], 
	  "max_half_open_connections": 50, 
	  "download_location": "/deluge/Downloads", 
	  "compact_allocation": false, 
	  "max_upload_speed": -1.0, 
	  "plugins_location": "/deluge/plugins", 
	  "max_connections_global": 200, 
	  "enc_prefer_rc4": true, 
	  "cache_expiry": 60, 
	  "dht": true, 
	  "stop_seed_at_ratio": false, 
	  "stop_seed_ratio": 2.0, 
	  "max_download_speed_per_torrent": -1, 
	  "prioritize_first_last_pieces": false, 
	  "max_upload_speed_per_torrent": -1, 
	  "auto_managed": true, 
	  "enc_level": 2, 
	  "copy_torrent_file": false, 
	  "max_connections_per_second": 20, 
	  "listen_ports": [
	    6881, 
	    6891
	  ], 
	  "max_connections_per_torrent": -1, 
	  "del_copy_torrent_file": false, 
	  "move_completed": false, 
	  "autoadd_enable": false, 
	  "proxies": {
	    "peer": {
	      "username": "", 
	      "password": "", 
	      "hostname": "", 
	      "type": 0, 
	      "port": 8080
	    }, 
	    "web_seed": {
	      "username": "", 
	      "password": "", 
	      "hostname": "", 
	      "type": 0, 
	      "port": 8080
	    }, 
	    "tracker": {
	      "username": "", 
	      "password": "", 
	      "hostname": "", 
	      "type": 0, 
	      "port": 8080
	    }, 
	    "dht": {
	      "username": "", 
	      "password": "", 
	      "hostname": "", 
	      "type": 0, 
	      "port": 8080
	    }
	  }, 
	  "dont_count_slow_torrents": false, 
	  "add_paused": false, 
	  "random_outgoing_ports": true, 
	  "max_upload_slots_per_torrent": -1, 
	  "new_release_check": false, 
	  "enc_out_policy": 1, 
	  "seed_time_ratio_limit": 7.0, 
	  "remove_seed_at_ratio": false, 
	  "autoadd_location": "/deluge/Downloads", 
	  "max_upload_slots_global": 4, 
	  "seed_time_limit": 180, 
	  "cache_size": 512, 
	  "share_ratio_limit": 2.0, 
	  "random_port": true, 
	  "listen_interface": ""
	}
	EOF

	echo "${DELUGE_USER}:${DELUGE_PASSWORD}:10" >> /deluge/auth
fi

exec "$@"
