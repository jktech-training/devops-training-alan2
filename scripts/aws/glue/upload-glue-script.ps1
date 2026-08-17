# Upload the local Glue ETL script to the S3 scripts bucket

$ScriptPath = Join-Path $PSScriptRoot "../../../backend/aws/glue/etl-sales-transform.py"

$Bucket = "etl-project-sales-scripts-alan"
$S3Key = "glue/etl-sales-transform.py"
$Region = "us-east-1"

Write-Host "Uploading Glue ETL script..."
Write-Host "Source: $ScriptPath"
Write-Host "Destination: s3://$Bucket/$S3Key"

aws s3 cp `
    $ScriptPath `
    "s3://$Bucket/$S3Key" `
    --region $Region

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Glue script uploaded successfully."
}
else {
    Write-Host ""
    Write-Host "Glue script upload failed."
    exit 1
}