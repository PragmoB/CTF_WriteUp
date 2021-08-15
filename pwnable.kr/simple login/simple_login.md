# 풀이과정

![카드](https://user-images.githubusercontent.com/67177785/129471761-2408fd7b-56b0-4f1e-a961-f816c8f03733.PNG)

brain fuck 푸느라 힘 다뺐지만

다시 활기차게 해봅시다

로그인이면 어렵게 나올수가 없지~

bin/login 다운받고 실행흐름을 파악해보자

![main1](https://user-images.githubusercontent.com/67177785/129485399-da5a0089-d862-4327-b232-ba0a6fa5047d.PNG)

입력받은 문자열을 base64로 디코딩

![main2](https://user-images.githubusercontent.com/67177785/129485401-8c006afd-8db7-4987-bcdb-d31f14a5d987.PNG)

디코딩된 문자열은 12바이트를 넘으면 안되고

그리고 문자열을 0x811eb40에 복사하고

to be continued in auth

auth도 보면 매우 간단하다

![auth](https://user-images.githubusercontent.com/67177785/129472139-6a68d399-a89f-4ba9-a1f9-8ec9dc106751.PNG)

어딘가에 문자열 복사 후 md5 돌려서 f87cd601aa7fedca99018a8be88eda34랑 비교하고 맞으면 1, 아니면 0리턴

당연히 디코딩한 문자열을 md5후에 저거랑 비교할거라 생각해서 저 md5값을 깨려고 했으나 db에 값이 없는걸 보고

만만치 않겠구나 생각했음

그리고 또 한가지 이상한점이 있었는데

분명 같은값을 입력했는데도 실행할때마다 md5로 해쉬한 값이 계속 바뀐다는 점이었다.

이렇게

![랜덤 md5](https://user-images.githubusercontent.com/67177785/129485541-b31fe82f-5670-4041-9e68-bfddbff9c9bd.PNG)

혼란스러움을 느끼고 auth 프로시저를 한번 더 꼼꼼히 분석해보니 md5해쉬를 만들때 사용하는 값은

사용자가 입력한 문자열이 아니었다.

![auth stackframe before md5](https://user-images.githubusercontent.com/67177785/129485463-844e0af6-3e79-4d0a-a562-e0945f9625e4.PNG)

calc_md5 호출 직전에 스택 프레임을 관찰하면 0xffc76144주소에서 12바이트 만큼을 해쉬하는걸 볼수 있는데

이건 사용자가 입력한 비밀번호와도 완벽히 떨어져있고 더군다나 아무 의미도 없는 쓰레기 값임

조금 더 고민에 분석을 반복 해본 결과

해쉬값으로 인증을 통과하긴 확률이 매우 낮음을 깨달았다(쓰레기값은 랜덤이니까 인생 운 다끌어모아서 한 번 통과하는 경우도 있긴 있을듯?)

이건 해쉬값으로 인증을 통과하는 문제가 아니다. 나름대로 헷갈리게 연막을 친듯함

calc_md5 호출 직전 스택 프레임을 다시 보면 사용자 입력값 바로 밑에 SFP 값이 들어있는데

아까 길이 제한이 12바이트 였으므로 저 SFP값을 덮어씌워 실행흐름을 조작할 수 있다

새로 덮어쓸 SFP 값으로는 main proc 0x80493f6 위치를 보면 0x811eb40 고정된 위치에 입력한 비밀번호를 옮기므로

0x811eb40로 덮어쓰면

auth 나갈때 한번, main 나갈때 한번으로

```asm
leave
ret
```

명령어가 2번 연속 실행되면서 리턴주소까지도 조작할 수 있다.

리턴 주소는 call correct 값으로 설정

여기까지 공격문을 구성해보면

```hex
[공간 채우기 용 4바이트] [리턴 주소 4바이트] [새로 덮어쓸 SFP값]
41 41 41 41 0c 94 04 08 40 eb 11 08
```

이 되는데 correct 내부에서 첫 4바이트가 0xdeadbeef인지 검사하므로

```hex
ef be ad de 0c 94 04 08 40 eb 11 08
```

이렇게 바꿔주면 공격구문이 완성된다.

![base64plain](https://user-images.githubusercontent.com/67177785/129485548-4080fd7f-0179-43db-bea8-b6c537ec424e.PNG)

hex editor로 이 값을 작성하고

![online base64 converter](https://user-images.githubusercontent.com/67177785/129485549-03cda5a3-9aa3-4d09-95c4-0fd52e696abb.PNG)

온라인 base64 컨버터에 파일을 올려 최종적으로 입력할 값을 구한다

![정답](https://user-images.githubusercontent.com/67177785/129485551-169ed2b0-0c16-42c5-8102-af6771d154ac.PNG)

flag : control EBP, control ESP, control EIP, control the world~

# 비하인드

## 삽질

md5 해쉬할때 저 쓰레기 값이 어느정도 규칙이 있는거 같아서 그걸 또 자세히 분석했다 -_-;

![auth stackframe before md5](https://user-images.githubusercontent.com/67177785/129485463-844e0af6-3e79-4d0a-a562-e0945f9625e4.PNG)

md5 직전 스택을 보면 0x00000006두개 있는건 입력값 길이인거 같으니까 패스.

0x91b99e8은 어디서 온걸까 분석~~시간낭비~~ 해보자

auth proc 내부에는 calc_md5로 넘겨주는 평문 값을 컨트롤 하는 코드가 아예 없기에

0x00000006 두개 포함해서 0x91b99e8은 다른 프로시저를 실행하다 생긴 값이라 보는게 타당하다.

그래서 내가 쓰레기 값이라 부르는거고.

![dummy over main stack frame](https://user-images.githubusercontent.com/67177785/129487400-a936c821-49f8-4958-9337-522b29843591.PNG)

다음 그림은 main proc 실행중 스택 상태를 캡처한것이다

보라색으로 색칠된 주소가 esp값, 스택 최상단이다.

회색으로 색칠된 부분은 쓰레기값임

리턴 주소 위 하나 둘 셋.. 6번째가 저 값이 있던 자리이므로 저짝에 Hardware BP를 걸어보자

참고로 base64 문자열은 YXNkZmdn로 입력했다

셋팅 뒤 실행하면

![hardware bp #1](https://user-images.githubusercontent.com/67177785/129487401-d9c96443-4693-4de3-ac72-f303ba92843f.PNG)

base64decode 안에서 걸림

한번 더 실행하면 call auth까지 오니까 저 쓰레기 값은 base64 디코딩 할때 만들어진다는걸 알 수 있다

코드를 좀 더 자세히보면 fmemopen 호출 후 리턴값을 저장한건데 비인기 api라 한글 문서는 아예 없었다

찾은걸 정리하면

```C
FILE *fmemopen(void *buf, size_t size, const char *mode);
```

원형은 이렇게 되고 버퍼를 파일 스트림 형식으로 열어준다고 함

리턴 값이 파일 포인터니까 당연히 컨트롤 불가능, 완전 랜덤

여기까지 분석하고 이 문제는 해쉬값을 인위적으로 맞춰서 통과하는건 불가능함을 깨달았다

## 로또방지

![로또방지](https://user-images.githubusercontent.com/67177785/129487404-362e8d97-2061-4471-9443-e162c569a94b.PNG)

저거 확률 얼마나 된다고ㅋㅋ 이걸 막아버리네