#!/bin/bash

# Extract the CloudUploader script from the package archive
tar -xzvf CloudUploader.tar.gz

# Make the CloudUploader script executable
chmod +x clouduploader.sh

# Move the CloudUploader script to a directory in the user's PATH
mv clouduploader.sh /usr/local/bin

echo "CloudUploader CLI has been installed successfully."
