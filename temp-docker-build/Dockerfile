FROM weaversnodes/shannon:v0.1.29

# Replace the old binary with the correct v0.1.29 binary
COPY pocketd /usr/local/bin/pocketd

# Ensure the binary is executable
RUN chmod +x /usr/local/bin/pocketd

# Verify the version
RUN /usr/local/bin/pocketd version
