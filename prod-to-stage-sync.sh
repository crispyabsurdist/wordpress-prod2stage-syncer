#!/bin/bash

# Define the SSH connection information
ssh_connection="--ssh=SSH-USER@IP:PORT/www/SSH-USER/public/current/web/wp"

# Export the production database and import it into the staging server
/usr/local/bin/wp db export --path=/www/SSH-USER/public/current/web/wp - | /usr/local/bin/wp $ssh_connection db import --path=/www/SSH-USER/public/current/web/wp -

# Search and replace domain names on the staging server
/usr/local/bin/wp $ssh_connection search-replace 'site-url' 'staging-url' --all-tables --path=/www/SSH-USER/public/current/web/wp

# If its a multisite, jsut add more lines for each site.
#/usr/local/bin/wp $ssh_connection search-replace 'site-url' 'staging-url' --all-tables --path=/www/SSH-USER/public/current/web/wp

# Activate the wp-force-login plugin network-wide on the staging server
/usr/local/bin/wp $ssh_connection plugin activate wp-force-login --network --path=/www/SSH-USER/public/current/web/wp

# Flush rewrite rules on the staging server
/usr/local/bin/wp $ssh_connection rewrite flush --path=/www/SSH-USER/public/current/web/wp

