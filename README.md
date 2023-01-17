# MinioCurl

Project that tests upload and get file infos of S3 endpoint, with defined and verified metadata.

## Command

```bash
./s3-curl.sh sheme s3Url s3Key s3Secret bucketName FileName
```

## Test
exemple : 
```bash
docker-compose up -d
./s3-curl.sh http localhost:9000 test testAzertyuiop bucket-test test.txt
```