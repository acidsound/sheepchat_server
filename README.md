# client쪽 사정
* 대기자 확인을 위해 waiter라는 topic으로 자신의 UUID를 전송하고
* 결과를 듣기 위해 queue/<UUID> 형태로 subs를 한다.
* 만일 자신의 UUID가 돌아오면 대기상태, 다른 기기의 UUID가 들어오면 해당 채널로 chat/<UUID> subscr
ibe 를 진행하면 된다.

# server쪽 사정
* 서버에선 waiter topic 으로 무언가가 들어오면
* 대기자가 있을 경우 대기자의 UUID를 
* 아니면 스스로의 UUID를 요청자의 queue/<UUID>로 publish한다.
