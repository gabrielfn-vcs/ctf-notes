import boto3
from botocore.config import Config
from botocore.exceptions import ClientError
from botocore import UNSIGNED

# Initialize the S3 client without credentials for public access
s3 = boto3.client("s3", config=Config(signature_version=UNSIGNED))

# List of S3 buckets to enumerate
buckets = [
    "haunted-hollow-sable-e0741516",
    "haunted-hollow-scary-e0741516",
    "haunted-hollow-scream-inducing-e0741516",
    "haunted-hollow-shadowy-e0741516",
    "haunted-hollow-shocking-e0741516",
    "haunted-hollow-sinister-e0741516",
    "haunted-hollow-skeletal-e0741516",
    "haunted-hollow-sombre-e0741516",
    "haunted-hollow-specter-like-e0741516",
    "haunted-hollow-spectral-e0741516",
    "haunted-hollow-spine-chilling-e0741516",
    "haunted-hollow-spirit-like-e0741516",
    "haunted-hollow-spooky-e0741516",
    "haunted-hollow-startling-e0741516",
    "haunted-hollow-stealthy-e0741516",
    "haunted-hollow-stormy-e0741516",
    "haunted-hollow-strange-e0741516",
    "haunted-hollow-supernatural-e0741516",
    "haunted-hollow-suspensful-e0741516",
]


def get_bucket_acl(bucket_name):
    try:
        acl = s3.get_bucket_acl(Bucket=bucket_name)
        print(f"Bucket: {bucket_name} ACL: {acl}")
    except ClientError as e:
        print(f"Error getting ACL for {bucket_name}: {e}")


def list_bucket_objects(bucket_name):
    try:
        response = s3.list_objects_v2(Bucket=bucket_name)
        if "Contents" in response:
            print(f"Objects in {bucket_name}:")
            for obj in response["Contents"]:
                print(f"  {obj['Key']}")
        else:
            print(f"No objects found in {bucket_name}.")
    except ClientError as e:
        print(f"Error listing objects for {bucket_name}: {e}")


def get_bucket_policy(bucket_name):
    try:
        policy = s3.get_bucket_policy(Bucket=bucket_name)
        print(f"Bucket: {bucket_name} Policy: {policy['Policy']}")
    except ClientError as e:
        print(f"Error getting policy for {bucket_name}: {e}")


# Loop through all buckets and perform actions
for bucket in buckets:
    print(f"\n--- Enumerating {bucket} ---")
    get_bucket_acl(bucket)
    list_bucket_objects(bucket)
    get_bucket_policy(bucket)
