# install
```
npm install
```

# how to run
```
  HOST=yourchat.server PORT=1883 USERNAME=yourid PASSWORD=yourpassword coffee sheepchat_server.coffee
```
# client쪽 사정
* 대기자 확인을 위해 waiter라는 topic으로 자신의 UUID를 전송하고
* 결과를 듣기 위해 queue/<UUID> 형태로 subs를 한다.
* 만일 자신의 UUID가 돌아오면 대기상태, 다른 기기의 UUID가 들어오면 해당 채널로 chat/<UUID> subscr
ibe 를 진행하면 된다.

# server쪽 사정
* 서버에선 waiter topic 으로 무언가가 들어오면
* 대기자가 있을 경우 대기자의 UUID를 
* 아니면 스스로의 UUID를 요청자의 queue/<UUID>로 publish한다.

# Dockerize
* npm 으로 자동화
1. mosquitto broker를 위한 사용자 설정을 ```mosquitto_passwd /etc/mosquitto/passwd <사용자명>```으로 추가
1. ```npm run build``` - docker image 생성
1. ```npm start``` - server 실행
1. ```npm run rm``` - container 삭제 
