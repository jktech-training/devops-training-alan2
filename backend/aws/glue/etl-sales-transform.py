import sys
import boto3

from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

from pyspark.sql.functions import col, upper


# --------------------------------------------------
# Glue job arguments
# --------------------------------------------------

args = getResolvedOptions(
    sys.argv,
    ["JOB_NAME", "INPUT_FILE"]
)


# --------------------------------------------------
# Initialize Glue / Spark
# --------------------------------------------------

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

job = Job(glueContext)
job.init(args["JOB_NAME"], args)


# --------------------------------------------------
# Configuration
# --------------------------------------------------

RAW_BUCKET = "etl-project-sales-raw-alan"
PROCESSED_BUCKET = "etl-project-sales-processed-alan"
DYNAMODB_TABLE = "TransformationRules"

input_file = args["INPUT_FILE"]

input_path = f"s3://{RAW_BUCKET}/{input_file}"
output_path = f"s3://{PROCESSED_BUCKET}/"


# --------------------------------------------------
# Read sales CSV from S3
# --------------------------------------------------

print(f"Reading input file: {input_path}")

df = spark.read \
    .option("header", "true") \
    .option("inferSchema", "true") \
    .csv(input_path)

print("Input data:")
df.show()


# --------------------------------------------------
# Read transformation rules from DynamoDB
# --------------------------------------------------

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(DYNAMODB_TABLE)

response = table.scan()
rules = response.get("Items", [])

print("Transformation rules:")
print(rules)


# --------------------------------------------------
# Apply transformation rules
# --------------------------------------------------

for rule in rules:

    operation = rule.get("Operation")

    if operation == "UPPERCASE":
        column_name = rule.get("Column")

        if column_name in df.columns:
            print(f"Applying UPPERCASE to {column_name}")

            df = df.withColumn(
                column_name,
                upper(col(column_name))
            )

    elif operation == "MULTIPLY":
        column1 = rule.get("Column1")
        column2 = rule.get("Column2")
        output_column = rule.get("OutputColumn")

        if column1 in df.columns and column2 in df.columns:
            print(
                f"Multiplying {column1} and {column2} "
                f"into {output_column}"
            )

            df = df.withColumn(
                output_column,
                col(column1).cast("double")
                * col(column2).cast("double")
            )