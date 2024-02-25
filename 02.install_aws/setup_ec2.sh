#!/bin/bash

# EC2 이름
ec2_name=$1

# AWS 인증 정보 설정 ( .env )
if [[ -f .env ]]; then
    source .env
else
    echo "Error: .env 파일을 찾을 수 없습니다."
    exit 1
fi

# AWS 인증 정보 설정
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION

# Spot 인스턴스 생성
spot_instance_request_id=$(aws ec2 request-spot-instances \
    --instance-count 1 \
    --type "one-time" \
    --launch-specification "{
        \"ImageId\": \"$AMI_ID\",
        \"InstanceType\": \"$INSTANCE_TYPE\",
        \"SubnetId\": \"$SUBNET_ID\",
        \"SecurityGroupIds\": [\"$SECURITY_GROUP_IDS\"],
        \"KeyName\": \"$KEY_NAME\"
    }" \
    --spot-price $SPOT_PRICE \
    --query 'SpotInstanceRequests[0].SpotInstanceRequestId' \
    --output text)

# Spot 인스턴스가 생성될 때까지 대기
aws ec2 wait spot-instance-request-fulfilled --spot-instance-request-ids $spot_instance_request_id

# 생성된 Spot 인스턴스의 ID 가져오기
instance_id=$(aws ec2 describe-spot-instance-requests \
    --spot-instance-request-ids $spot_instance_request_id \
    --query 'SpotInstanceRequests[0].InstanceId' \
    --output text)

# 생성된 Spot 인스턴스에 태그 추가
aws ec2 create-tags \
    --resources $instance_id \
    --tags Key=Name,Value=$ec2_name

# 생성된 Spot 인스턴스 확인
# aws ec2 describe-spot-instance-requests
