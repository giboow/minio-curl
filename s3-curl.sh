#!/bin/bash

# Usage: ./s3-curl.sh http localhost:9000 test testAzertyuiop bucket-test test.txt

schema=$1
host=$2
s3_key=$3
s3_secret=$4

bucket=$5
file=$6

resource="/${bucket}/${file}"
content_type="application/octet-stream"
date=`date -R`
metadataKey="x-amz-meta-custom"
metadataValue="custom-value"
metadata="${metadataKey}:${metadataValue}"

_signature="PUT\n\n${content_type}\n${date}\n${metadata}\n${resource}"
signature=`echo -en ${_signature} | openssl sha1 -hmac ${s3_secret} -binary | base64`
curl -X PUT -T "${file}" \
          -H "Host: ${host}" \
          -H "Date: ${date}" \
          -H "Content-Type: ${content_type}" \
          -H "Authorization: AWS ${s3_key}:${signature}" \
          -H "${metadata}" \
          ${schema}://${host}${resource}


content_type="text/plain"
date=`date -R`
_signature="GET\n\n${content_type}\n${date}\n${resource}"
signature=`echo -en ${_signature} | openssl sha1 -hmac ${s3_secret} -binary | base64`
response=$(curl -vs  -X GET -H "Host: ${host}" \
          -H "Date: ${date}" \
          -H "Content-Type: ${content_type}" \
          -H "Authorization: AWS ${s3_key}:${signature}" \
          ${schema}://${host}${resource}  2>&1 >/dev/null)

# echo  "$response"
if [[ "$response" == *"${metadataKey}"* ]]; then
  echo "Metadata found"
else
  echo "Metadata not found"
fi


content_type="text/plain"
date=`date -R`
_signature="DELETE\n\n${content_type}\n${date}\n${resource}"
signature=`echo -en ${_signature} | openssl sha1 -hmac ${s3_secret} -binary | base64`
response=$(curl -vs  -X DELETE -H "Host: ${host}" \
          -H "Date: ${date}" \
          -H "Content-Type: ${content_type}" \
          -H "Authorization: AWS ${s3_key}:${signature}" \
          ${schema}://${host}${resource}  2>&1 >/dev/null)

