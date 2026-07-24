import boto3

glue = boto3.client("glue")


def lambda_handler(event, context):

    response = glue.start_job_run(
        JobName="etl-sales-transform"
    )

    return {
        "statusCode": 200,
        "message": "Glue job started successfully",
        "JobRunId": response["JobRunId"]
    }