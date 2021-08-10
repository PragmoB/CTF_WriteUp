# 풀이과정

![카드](https://user-images.githubusercontent.com/67177785/128904695-da4c26bf-50c1-4ca4-8f28-e886ca9649cd.PNG)

링크에 있는 bof실행파일과 소스코드를 다운받자.

![소스코드](https://user-images.githubusercontent.com/67177785/128904698-3cce013b-bdf8-47fb-8809-0d15abff97dc.PNG)

소스코드를 보면 gets함수 부분에서 bof 취약점이 발생하는걸 확인 할 수 있는데

이 부분에서 key값을 0xcafebabe로 덮어씌워야 한다.

key값을 0xcafebabe로 오차없이 조작하기 위해선 스택에서 overflowme와 key사이 공간의 크기를 **정확히**

알 필요가 있기에 bof실행파일을 분석해줘야 한다.

![func 디스어셈](https://user-images.githubusercontent.com/67177785/128904705-337660b9-bf39-4d03-aac6-fce4d4306588.PNG)

+29 부분의 ebp-0x2c가 overflowme, +40부분의 ebp+0x8가 key의 시작주소이다.

따라서 overflowme와 key사이 공간의 크기는 0x34(52)이다.

이 정보를 토대로 익스플로잇을 구성하면

```python
print 'a'*52 + '\xbe\xba\xfe\xca'
```

이렇게 된다.

이제 이 값을 전송하기만 하면

![정답](https://user-images.githubusercontent.com/67177785/128906010-37cd4d16-e301-492a-ba79-7283718624b9.PNG)

플래그를 얻을 수 있다.

flag : daddy, I just pwned a buFFer :)

# 느낀점

시스템 해킹 지식은 충분했지만

리눅스 환경에 익숙하지 않아

개인적으로 많이 헤맸던 문제

# 번외

## 삽질#1

overflowme와 key사이의 공간을 구하기 위해

bof 실행파일을 동적분석 해보자

![bof디버거](https://user-images.githubusercontent.com/67177785/128907749-7a03bb7c-9d7d-4e2b-b9f1-3763ece2ed50.PNG)

??

근데 실행자체가 안되는데 분석을 어떻게 하나

그렇다면 실행파일을 직접 만들면 되지! 소스코드도 있으니까

이렇게 하면.. overflowme와 key사이 공간은 48byte네!

하지만 당연히 안먹히고

bof는 실행할순 없지만 gdb로 정적분석 할 순 있더라

깨닫기 전까지 1시간 날렸다

## 삽질#2

드디어 익스플로잇을 완성했다! 하 힘들었다 진짜ㅠㅠ

```
(python -c "print 'a'*52 + '\xbe\xba\xfe\xca'") | nc pwnable.kr 9000
```

Nah가 안뜨는걸로 봐서

분명 /bin/sh는 제대로 실행됬는데.. ls ls ls ls
cat flag

명령어가 말을 안듣는데..  이건 답지를 볼 수 밖에 없다

저기 ;cat은 왜 붙여야 하는지 모르겠지만 그렇지만

어쨌든 flag는 떴네