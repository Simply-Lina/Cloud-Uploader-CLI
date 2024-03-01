# CloudUploader CLI

## Overview

CloudUploader CLI is a command-line tool that allows users to securely upload files to cloud storage providers such as AWS S3. It simplifies the process of uploading files to the cloud directly from the terminal.
AWS Simple Storage Service (S3) is provides object storage through a web service interface.

## Prerequisites

Before using the CloudUploader CLI, ensure you have the following prerequisites installed:

- **AWS CLI**: Install the AWS Command Line Interface by following the instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html).
- **Bash Shell**: The tool is built using bash scripting, so make sure you have bash installed on your system.
- **AWS S3 bucket created**
        To create an AWS S3 bucket using the AWS CLI, you can use the `aws s3api create-bucket` command. Here's the basic syntax:

        ```bash
        aws s3api create-bucket --bucket BUCKET_NAME --region REGION
        ```

        Replace `BUCKET_NAME` with the name you want to give to your bucket and `REGION` with the AWS region where you want to create the bucket. Additionally, you can specify additional options such as ACLs, encryption, and tags.

        Here's an example command to create an S3 bucket named `my-bucket` in the `us-east-1` region:

        ```bash
        aws s3api create-bucket --bucket my-bucket --region us-east-1
        ```

        Refer to the [AWS CLI documentation](https://docs.aws.amazon.com/cli/latest/reference/s3api/create-bucket.html) for more options and detailed information on creating S3 buckets using the AWS CLI.

## Setup

### Download the tool as a package and add it to your path
Save the script named as ``install-aws-cli-fileuploader.sh``, and make it executable using chmod +x ``install-aws-cli-fileuploader.sh``. Users can then run ./install-aws-cli-fileuploader to install the CloudUploader CLI.
### Manual Setup
1. Clone the CloudUploader repository to your local machine:

    ```bash
    git clone https://github.com/Simply-Lina/Cloud-Uploader-CLI.git
    ```


2. Make the bash script executable:

    ```bash
    chmod +x Uploadfile1.sh
    ```

## Usage

To upload a file to AWS S3 using the CloudUploader CLI, follow these steps:

1. Open a terminal.
2. Navigate to the directory containing the CloudUploader script.
3. Run the following command:

    ```bash
    ./Uploadfile1.sh.sh /path/to/your/file.txt
    ```

   Replace `/path/to/your/file.txt` with the path to the file you want to upload.

4. Follow the prompts to enter your AWS S3 bucket name and make any additional choices regarding file synchronization and encryption.

## Troubleshooting

### AWS CLI Configuration

If you encounter authentication issues with AWS, make sure you have configured the AWS CLI properly using the `aws configure` command. Ensure that the Access Key ID and Secret Access Key provided during configuration are correct.

### File Upload Errors

If you encounter errors during file upload, double-check the following:

- Ensure that the file path provided is correct and the file exists.
- Verify that the specified S3 bucket exists and you have the necessary permissions to upload files to it.

### Encryption

If you experience issues with file encryption, ensure that OpenSSL is installed on your system. You can install it using your package manager (e.g., `apt-get` for Ubuntu).

## Usage Examples

### Basic File Upload

```bash
./Uploadfile1.shr.sh /path/to/your/file.txt
```

### Encrypt and Upload File

```bash
./Uploadfile1.sh.sh /path/to/your/file.txt --encrypt
```

### Sync File with S3 Bucket

```bash
./Uploadfile1.sh.sh /path/to/your/file.txt --sync
```

To clean up the project by deleting objects and an S3 bucket, you can follow these steps:

### Using AWS CLI for Cleanup:

If you prefer to use the AWS CLI for cleanup, you can use the following commands:

1. To delete objects in an S3 bucket:

    ```bash
    aws s3 rm s3://bucket-name --recursive
    ```

    Replace `bucket-name` with the name of your S3 bucket. The `--recursive` option ensures that all objects in the bucket are deleted.

2. To delete an empty S3 bucket:

    ```bash
    aws s3 rb s3://bucket-name
    ```

    Replace `bucket-name` with the name of your S3 bucket. This command will only work if the bucket is empty.

Remember to exercise caution when performing deletion operations, as they cannot be undone. Always double-check that you are deleting the correct objects and buckets.
