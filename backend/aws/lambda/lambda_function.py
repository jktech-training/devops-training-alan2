import json
import boto3
import urllib.parse

s3 = boto3.client("s3")
glue = boto3.client("glue")
dynamodb = boto3.resource("dynamodb")

TABLE_NAME = "TransformationRules"
GLUE_JOB_NAME = "etl-sales-transform"


def lambda_handler(event, context):

    # Read S3 Event
    bucket = event["Records"][0]["s3"]["bucket"]["name"]

    key = urllib.parse.unquote_plus(
        event["Records"][0]["s3"]["object"]["key"]
    )

    print(f"Bucket : {bucket}")
    print(f"File   : {key}")

    # Validate Filename
    if not key.endswith(".csv"):
        return {
            "statusCode": 400,
            "body": "Only CSV files are allowed."
        }

    # Read Metadata
    metadata = s3.head_object(
        Bucket=bucket,
        Key=key
    )

    print("File Size :", metadata["ContentLength"])
    print("Last Modified :", metadata["LastModified"])

    # Read Config from DynamoDB
    table = dynamodb.Table(TABLE_NAME)

    response = table.scan()

    print("Rules Found :", len(response["Items"]))

    # Start Glue Job
    glue.start_job_run(
        JobName=GLUE_JOB_NAME,
        Arguments={
            "--INPUT_FILE": key
        }
    )

    print("Glue Job Started")

    return {
        "statusCode": 200,
        "body": json.dumps("Glue Job Started Successfully")
    }