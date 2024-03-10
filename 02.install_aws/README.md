## AWS에 KAFKA 설정 

### AWS 환경설정
```commandline
VPC 
IPv4 CIDR를 확인한다. 예시) 172.31.0.0/16

보안그룹
보안그룹을 생성하고 
인바운드 규칙에 2개의 규칙을 추가하고
- 사용자지정 TCP / 접속허용할 public IP (예시. 내IP)
- 모든트래픽 / VPC IPv4 CIDR (예시. 172.31.0.0/16)
아웃바운드 규칙에 아래의 규칙을 추가한다.
- 모든트래픽 / 전체 (0.0.0.0/0) 
```

### 스크립트를 통해 스팟 인스턴스를 생성
```commandline
설정파일 생성
- env_file_example.txt 파일을 참고하여 .env파일생성
- .env 파일에 적절한 aws 설정 값으로 수정

스크립트를 실행하여 동일한 환경의 kafka broker를 손쉽게 추가해 테스트하기 용이하게 한다.
- cd 02.install_aws/
- sh ./setup_ec2.sh ${EC2_NAME}
```

### ec2 접속해서 확인
```commandline
ssh -i /Users/my/key.pem ec2-user@15.155.174.11
```

### etc/hosts 설정
```commandline
카프카 서버의 /etc/hosts/의 내용을 "privateip 호스트명" 으로 설정한다.
- 예시)
172.31.44.51 kafka01
172.31.44.52 kafka02
172.31.44.53 kafka03

접속확인 
- [ec2-user@kafka01] ping -c 2 ec2-user@kafka02
```

### aws keypair.pem 파일 복사
```commandline
aws keypair.pem 파일 생성
- 서로다른 서버의 ssh 접속을 위해 keypair.pem 파일명으로 git프로젝트 경로에 키페어 복사

aws cli로 로컬에서 ec2(ansible 배포서버)에 복사
- chmod 600 keypair.pem
- scp -i keypair.pem keypair.pem ec2-user@15.155.174.11:~

ec2에 접속하여 keypair.pem를 이용해 ssh 접속
- [ec2-user@kafka01] ssh -i keypair.pem ec2-user@kafka02

keypair.pem파일 없이 ssh 접근가능하게 키 등록 
- 등록시 -i keypair.pem 옵션이 없이도 접근가능
- 단점은 ec2 cmd 로그아웃 후에 초기화 됨 ( ssh-keygen을 통해 해결 )

- 아래 명령어 실행
- ssh-agent bash
- ssh-add keypair.pem
ssh 접속확인
- [ec2-user@kafka01] ssh ec2-user@kafka02
```