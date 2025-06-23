# Use Debian 12 as the base image
FROM debian:12

# Install jq
RUN apt-get update && apt-get install -y jq cron curl
WORKDIR /

# Copy the script into the container
COPY paperlessai_fix_perm.sh /paperlessai_fix_perm.sh
COPY start.sh /start.sh

# Give execution permissions to the script
RUN chmod +x /paperlessai_fix_perm.sh;  chmod +x /start.sh


# Add the cron job to execute the script every minute
RUN (crontab -l ; echo "* * * * * /paperlessai_fix_perm.sh >> /proc/1/fd/1 2>&1") | crontab -

# Start cron in the foreground
CMD /start.sh
