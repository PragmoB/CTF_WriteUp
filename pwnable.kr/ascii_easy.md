# 풀이과정

사실 나는 이 문제를 풀지 못했다.

다른분들 블로그 들어가서 write up 읽은게 전부기 때문에

간략하게만 서술한다

페이로드는 모양은

'A' * 32 + [&call execve] + [&대충 아무 문자열] + [&NULL] + [&NULL]

이렇게 된다.

'A' * 32로 RET까지 접근하고 call execve로 점프해서 execve를 호출하면

넣어준 문자열을 커맨드로 실행하게 된다.

주어진 libc 안에 /bin/sh 문자열이 존재하긴 하지만 주소값이 0x20 ~ 0x7e 범위에서 입력할 수 없는 문자가 포함되어 있기에

다른 문자열을 써줘야 한다.

만약 error라는 문자열을 쓴다고 하면

```C
#include <stdio.h>
#include <unistd.h>

int main()
{
	system("/bin/sh");
	return 0;
}
```
처럼 간단하게 코딩 후 프로그램 이름을 error로 바꾸고 PATH경로에 포함시키면 된다

# 비하인드

## 의문점#1

문자열 "UWVS"는 왜 안될까?

```
페이로드A

AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjgaUp#]UxTkUxTkU
```
이건 내가 작성한 페이로드다. "UWVS"의 주소를 첫번째 인자로 사용한다.

```
페이로드B

AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjgaUV|kU@voU@voU
```
이건 한 블로그에서 가져온 페이로드고 "error"의 주소를 첫번째 인자로 사용한다.

내가 만든건 터지고, 퍼온건 잘 작동한다.

왜 그럴까?

이 그림은 각각 페이로드A와 페이로드B를 적용했을때 ret 직전 스택 상태를 관찰한 것이다.

각 값이 의도한대로 자리를 잘 잡았고 리턴만 하면 쉘을 얻을 수 있을거라 기대된다

페이로드 자체는 문제가 없다

이후 여러가지 시도를 해보다가 얻어걸린게 하나 있다.

/bin 경로에 심어둔 error파일을 지우고 두가지 페이로드를 실행해보면

똑같은 위치에서 똑같은 에러(SIGSEGV)가 발생한다.

쉘이 UWVS라는 파일을 찾지 못해 오류를 낸거라고 하면 딱 들어맞는다.

이게 맞는거 같긴 한데 왜그런진 아무리 생각해도 모름

전부 대문자라 안되나? 소문자로 변경

```
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjgaUJyWUxTkUxTkU
```
entiu로 바꿨는데 얘도 안됨

## 의문점#2

페이로드B도 /bin경로에서 실행했을땐 잘되지만

다른 무슨 ~/Desktop같은데서 실행하면 얘도 segfault다

외부요인에 영향을 너무 많이 받아서 애초에 풀수가 없었을듯