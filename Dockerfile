FROM node:current

# Install dependencies
RUN apt-get update && apt-get install -y \
    cifs-utils 

# Copy the script and configuration file into the container
COPY app/ /app

# Set the working directory
WORKDIR /app

# Install node dependencies
RUN npm install

# Copy the config files and keys
COPY keys/ /app/keys
RUN chmod 600 -R /app/keys
COPY config.json /app/

CMD [ "node", "run.js" ]

#ENTRYPOINT [ "bash" ]
