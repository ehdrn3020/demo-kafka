## AWS에 KAFKA 설정 

### 스크립트를 통해 스팟 인스턴스를 생성
```commandline
env_file_example.txt 파일을 통해 .env파일생성
.env 파일에 적절한 aws 설정 값으로 수정

cd 02.install_aws/
sh ./setup_ec2.sh ${EC2_NAME}
```

### etc/hosts 설정
```commandline

```