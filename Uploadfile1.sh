#!/bin/bash

install_aws_cli() {
    if ! command -v aws &>/dev/null; then
        echo "AWS CLI not found. Installing..."
        sudo apt-get update
        sudo apt-get install -y awscli
    fi
}

authenticate_aws() {
    echo "Attempting to authenticate with AWS..."
    aws configure
    if ! aws sts get-caller-identity &>/dev/null; then
        echo "Authentication with AWS failed. Exiting..."
        exit 1
    fi
}

check_file_exists() {
    local FILE_PATH="$1"
    if [ ! -e "$FILE_PATH" ]; then
        echo "File not found: $FILE_PATH"
        exit 1
    fi
}

check_bucket_exists() {
    local BUCKET_NAME="$1"
    if ! aws s3api head-bucket --bucket "$BUCKET_NAME" &>/dev/null; then
        echo "Bucket $BUCKET_NAME does not exist. Exiting..."
        exit 1
    fi
}

upload_file() {
    local FILE_PATH="$1"
    local BUCKET_NAME="$2"
    echo "Uploading $FILE_PATH to bucket $BUCKET_NAME..."
    pv "$FILE_PATH" | aws s3 cp - "s3://$BUCKET_NAME/$(basename "$FILE_PATH")"
    if [ $? -eq 0 ]; then
        echo "File uploaded successfully to bucket $BUCKET_NAME."
    else
        echo "Upload failed for file '$FILE_PATH'."
        exit 1
    fi
}

generate_shareable_link() {
    local FILE_NAME="$1"
    local BUCKET_NAME="$2"
    echo "Generating shareable link for $FILE_NAME in bucket $BUCKET_NAME..."
    aws s3 presign "s3://$BUCKET_NAME/$FILE_NAME"
}

sync_file() {
    local FILE_PATH="$1"
    local BUCKET_NAME="$2"
    local FILE_NAME="$(basename "$FILE_PATH")"
    if aws s3 ls "s3://$BUCKET_NAME/$FILE_NAME" &>/dev/null; then
        read -p "The specified file already exists in the cloud. Do you want to overwrite, skip, or rename it? (overwrite/skip/rename): " sync_decision
        case "$sync_decision" in
            overwrite)
                aws s3 cp "$FILE_PATH" "s3://$BUCKET_NAME/$FILE_NAME" --acl public-read
                echo "File overwritten successfully in bucket $BUCKET_NAME."
                ;;
            skip)
                echo "Skipping upload for file '$FILE_NAME' in bucket $BUCKET_NAME."
                ;;
            rename)
                read -p "Enter new file name: " new_file_name
                aws s3 cp "$FILE_PATH" "s3://$BUCKET_NAME/$new_file_name" --acl public-read
                echo "File renamed and uploaded successfully to bucket $BUCKET_NAME."
                ;;
            *)
                echo "Invalid option. Exiting..."
                exit 1
                ;;
        esac
    else
        upload_file "$FILE_PATH" "$BUCKET_NAME"
    fi
}

encrypt_file() {
    local FILE_PATH="$1"
    local ENCRYPTED_FILE="$FILE_PATH.enc"
    echo "Encrypting $FILE_PATH..."
    openssl enc -aes-256-cbc -salt -in "$FILE_PATH" -out "$ENCRYPTED_FILE"
    if [ $? -eq 0 ]; then
        echo "Encryption successful. Encrypted file saved as $ENCRYPTED_FILE."
        FILE_PATH="$ENCRYPTED_FILE"
    else
        echo "Encryption failed for file '$FILE_PATH'. Exiting..."
        exit 1
    fi
}

# Main function
main() {
    install_aws_cli
    authenticate_aws

    if [ "$#" -eq 0 ]; then
        echo "No file paths provided. Please provide one or more file paths."
        exit 1
    fi

    for FILE_PATH in "$@"; do
        check_file_exists "$FILE_PATH"
        read -p "Enter S3 Bucket name for file '$FILE_PATH': " BUCKET_NAME
        check_bucket_exists "$BUCKET_NAME"
        encrypt_file "$FILE_PATH"
        sync_file "$FILE_PATH" "$BUCKET_NAME"
        generate_shareable_link "$(basename "$FILE_PATH")" "$BUCKET_NAME"
    done
}

# Execute main function
main "$@"
