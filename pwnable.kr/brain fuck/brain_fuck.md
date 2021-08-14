# 풀이과정

![카드](https://user-images.githubusercontent.com/67177785/129441339-009f3529-da94-4e9f-ac5c-f1a8352aa0f6.PNG)

실행파일 bf와 bf_libc.so를 다운받자.

소스코드가 없으므로 어셈블리를 분석해야한다.

![main1](https://user-images.githubusercontent.com/67177785/129441344-9374dd6f-dd00-4801-81e6-942ab9c139fb.PNG)
![main2](https://user-images.githubusercontent.com/67177785/129441345-9858a936-b155-47f0-b33f-8a38fc34a1a4.PNG)

디버거에 올려놓고 보게되면 메모리 보호기법을 사용하고

fgets에서 길이제한을 걸고 있으므로 bof문제는 아닌듯 하다.

0x8048743부터 0x8048772까지의 반복문을 보면 입력 문자열에서 글자를 하나씩 빼면서

brain fuck? 하는걸 볼 수 있는데 자세히 분석해보면

![brainfuck1](https://user-images.githubusercontent.com/67177785/129441347-9f0a1386-540d-4852-b85d-e0dd498e8d9d.PNG)
![brainfuck2](https://user-images.githubusercontent.com/67177785/129441349-fe285f6d-1062-4947-85ea-7fb3e6f78e2a.PNG)

글자값이 2b이상 5b이하가 아니면 조건문에 의해 작업을 종료하고

아니면 미리 계산된 주소 테이블에서 값을 꺼내 점프한다

즉 저건 c언어의 switch문이다. 주소 테이블을 분석하면 어떤 값이 어떤 주소에 맵핑됬는지 알수 있는데

< > + - . , 에 대해서만 switch문 안의 코드에 맵핑이 되어있다.

c언어 문법으로 설명하면 case는 < > + - . , 이 있다. 그림에 주석 달아놓은거 참고.

각각의 case들이 뭘 하는지 디버깅하며 자세히 살펴봤다.

```C

case '<' : [0x804a080]의 값에 1 뺀다

case '>' : [0x804a080]의 값에 1 더한다

case '+' : [[0x804a080]]의 값에 1 더한다

case '-' : [[0x804a080]]의 값에 1 뺀다

case '.' : [[0x804a080]]의 값을 1바이트 읽어들여 화면에 출력한다

case ',' : 값을 1바이트 입력받아 [[0x804a080]]에 저장한다

```

참고로 [0x804a080]의 초기값은 0x804a0a0으로 정해져있다!

따라서 위의 명령들을 잘 조합해서 메모리값을 마음대로 조작할 수 있다

하지만 입력 문자열 길이제한이 0x400으로 걸려있기에 조작가능한 메모리 영역은 0x804a0a0 내외로 한정되어 있음

그래서 메모리 조작을 어떻게 해야 효율적일까 생각해본 결과

주소 0x804a0a0은 GOT 주소와 **매우** 가깝다는걸 발견했다.

또한 main 프로시저의 시작 주소와도 가깝다.

저 명령어들을 조합해 GOT에 기록된 api의 주소를 바꿀수 있다

여기까지 생각이 도달했으니

그럼 GOT에서 putchar의 주소를 조작해서 원하는 주소로 점프할 수 있지 않을까?

하는 시나리오를 만들수 있고 실제로 테스트하기 위해

페이로드를 구성해보면 다음과 같이 된다

```Python
payload = bytes(b'\x3C' * 0x70 + # 
                b'\x2C\x3E\x2C\x2C\x3E\x2C\x2C\x3E\x2C\x2C\x3E\x2C\x2E\x00' + b'\n' + # putchar GOT 조작코드, 마지막에 putchar 실행

                b'\x12\n\x34\n\x56\n\x78\n' # 변경될 putchar 주소
            ) 
```

과정을 디버거로 직접 관찰하기 위해 mov ebp, esp 부분을

jmp short -2 (제자리걸음 도는 코드)로 바꾸고 attach하는 방법을 썼다.

![putchar segfault](https://user-images.githubusercontent.com/67177785/129441350-b6d8ee2b-d1e8-424b-ac5c-d04532baac07.PNG)

와!! 성공

이제 스킬을 하나 얻었음 어떤 스킬이냐

![리턴 투 어드레스](https://user-images.githubusercontent.com/67177785/129441351-657c59f0-29bc-49db-88b6-b8d9d6556327.png)

원하는 주소로 한번 점프 가능

한번 뿐인 기회를 어떻게 유용하게 쓸지 정말 오랜 시간동안 고민했다

고민하는 과정은 비하인드 항목에 작성하고, 여기는 고민한 결과만 작성한다.

main 프로시저에서 memset과 fgets를 호출하는 부분이 이어져있음을 발견했다.

만약에 GOT를 조작해서 memset를 gets로 바꾸고 fgets를 system으로 바꾼다면?

main이 다시 실행된다고 하면 gets로 입력받은 커맨드가 system으로 실행된다.

매개변수 형식도 놀라울 정도로 딱딱 들어맞는다.

```C
void *memset(void *dest, int c, size_t count);
char *gets(char *buffer);

char *fgets (char *string, int n, FILE *stream);
int system(const char *command);
```

아까 얻은 기회로 main 프로시저로 다시 한번 점프한다면 위의 아이디어를 구현 할 수 있다

그런데 문제가 하나 있다

공유 라이브러리의 베이스 주소는 실행할 때마다 바뀌기에

서버의 gets와 system api의 주소를 정확히 알 수 없다

어? 근데 putchar로 GOT에 있는 값을 출력하게 할 수 있지 않을까?

문제에 putchar를 넣은것도 putchar를 사용하라는 출제의도일 것이라 생각이 들었다.

putchar를 사용해야 하므로 출력은 GOT의 putchar 주소를 조작하기 전에 이뤄져야 한다

주어진 libc에서 putchar의 오프셋은 0x61920이므로

GOT의 putchar 주소를 읽어들여 libc 로딩 주소를 구할 수 있다

```
libc_base = putchar_addr - 0x61920
```

libc 로딩 주소에 각 api 오프셋을 더해 api의 주소를 구한다
```
system_addr = libc_base + system_offset
gets_addr = libc_base + gets_offset
```

구한 주소를 잘 가공해 페이로드에 붙이고 전송하면 된다.

putchar의 로딩 주소 정보를 받을 필요가 있으므로

info leak 페이로드 한 번,

실제 공격 페이로드 한 번

두번으로 나눠 전송한다.

실제 서버 환경과 똑같이 테스트 하기 위해

bf_libc.so에 맞는 라이브러리 로더로 교체한뒤 진행했다

```zsh
patchelf --set-interpreter /home/kali/Desktop/ld_bf.so.2 ./bf
```

그리고 몇 시간의 디버깅 후 페이로드를 완성했다

exploit_brain_fuck.py로 올려놓음

![정답](https://user-images.githubusercontent.com/67177785/129444354-338fdbf8-0bf4-4981-bf24-114c5d6a0eaf.PNG)

flag : Brainfuck? what a weird language..

# 비하인드

write up도 장난 아니네

문제 푸는게 30시간쯤 걸린 것 같은데

이건 오늘 점심부터 작성했으니까

5시간 ㄷㄷ

## 삽질#1

![canary](https://user-images.githubusercontent.com/67177785/129444868-41f4cd58-1679-4549-a179-e79fca18db16.PNG)

아니 이거는 security cookie?

리눅스에도 비슷한게 있구나~

이거 우회해서 bof 성공시키는건갑네

윈도우에선 SEH 덮어서 우회하니까

리눅스도 뭐 그렇게 하면 되겠지?

![canary검색](https://user-images.githubusercontent.com/67177785/129444989-2702e1f8-48bf-4de7-8f57-18273b5d6482.PNG)

![canary 우회법검색](https://user-images.githubusercontent.com/67177785/129445187-238a2799-689b-471f-8ab2-325252aa7f2b.PNG)

**(시간낭비)**

## 삽질#2

아아~ 그래그래 우회기법 쓰는건 아니지만

stack_chk_failed 주소 조작하는거 맞지?

그러면 canary 건드려도 종료 안되니까

마침 스택 타이밍도 절묘했지

![canary직전](https://user-images.githubusercontent.com/67177785/129445405-511946c5-ac62-4cd6-b0b4-aa2bd448328b.PNG)

canary 실행 직전에

![직전스택](https://user-images.githubusercontent.com/67177785/129445407-28762fe2-4943-4f67-a521-c62fde89ada3.PNG)

스택 최상단에 입력한 문자열이 딱 뜨니까

stack chk failed가 system으로 바뀌면 완벽하네

근데 fgets에 길이제한 있었더라

카나리형에게 닿을수 없어

아니 어차피 길이제한 할거면 카나리는 대체 왜 넣은겨

## 삽질#3

libc가.. 로딩이 안돼

뭐 검색을 어떻게 해야 하는지 모르겠고 암담하다

![검색기록](https://user-images.githubusercontent.com/67177785/129445814-7c15b59e-1538-4599-87ef-93cdf9104e2b.PNG)

**진짜 무수한 검색의 흔적들 (중간에 노동요 복용해주고)**

그러다 한줄기의 빛을 발견

https://typemiss.tistory.com/2

진짜 참고 많이 됐어요

https://github.com/matrix1001/welpwn/tree/master/PwnContext/libs/ld.so

여기서 로더 다운 가능하대네

patchelf로 로더 교체하면 bf_libc.so 로딩 가능

## 고뇌

![리턴 투 어드레스](https://user-images.githubusercontent.com/67177785/129441351-657c59f0-29bc-49db-88b6-b8d9d6556327.png)

어디로 점프해야 제일 효율적일까

만약에 RET을 덮어쓰고

```asm
leave
ret
```

로 점프한다면 

아니지 위쪽 RET은 덮을 수 없잖아

그럼 leave가 2번 연속으로 있는

```asm
leave
leave
ret
```

가젯을 찾아서 점프한다면?

아니지 애초에 RET을 덮을수 있단 전제가 잘못됐어

실행흐름은 변하지 않겠지

근데 만약에 된다면 스택까지 같이 컨트롤 되니까

RTL을 시도해 볼 수도 있었겠네 근데 스택을 맘대로 조작할 수 있었다면

애초에 이런 방법은 쓰지 않았을테니까

아니면 만약 system 주소로 점프한다면?

이것도 매개변수가 안맞으니까 안되고

스택 조작이 자유롭지 못하니까 어렵네

매개변수가 맞는건 memset이랑 fgets정도가 있으니까

그럼 memset호출 아니면 fgets호출 쪽으로 점프를 한다면..

그럼 그 전에 스택이 깔끔히 정리가 되어있어야 하네 딱 맞는 가젯도 필요하고

너무 복잡해서 안되고

main으로 다시 한번 점프해서

만약에 memset을 gets로 바꾸고 fgets을 system으로 바꾼다면? 

\=\> 스택 프레임도 깔끔하게 새로 하나 만들어지고 실현 가능성이 보임

그리고 문제풀이 성공.

## 성인물?

![성인인증](https://user-images.githubusercontent.com/67177785/129446907-e8e17235-1b20-45e7-a05d-2896f9eb3815.PNG)

구글코리아 선정 청소년에게 유해한 문제ㅋㅋ