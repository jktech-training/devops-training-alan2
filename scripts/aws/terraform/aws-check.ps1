# AWS ETL infrastructure verification
# Region: us-east-1

$Region = "us-east-1"

Write-Host "===== S3 Buckets ====="
aws s3 ls --region $Region

Write-Host ""
Write-Host "===== DynamoDB Tables ====="
aws dynamodb list-tables --region $Region

Write-Host ""
Write-Host "===== Glue Jobs ====="
aws glue list-jobs --region $Region

Write-Host ""
Write-Host "===== Glue Databases ====="
aws glue get-databases --region $Region

Write-Host ""
Write-Host "===== Lambda Functions ====="
aws lambda list-functions --region $Region `
    --query "Functions[].FunctionName" `
    --output table