# 풀이과정

![카드](https://user-images.githubusercontent.com/67177785/129737210-17a5f315-35d6-4ae3-9f4c-e33e2d89ed01.PNG)

rookiss 난이도에 ssh라..

```C
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>

int main(int argc, char* argv[]){
        char fname[128];
        unsigned long long otp[2];

        if(argc!=2){
                printf("usage : ./otp [passcode]\n");
                return 0;
        }

        int fd = open("/dev/urandom", O_RDONLY); // urandom 디바이스로 난수 생성
        if(fd==-1) exit(-1);

        if(read(fd, otp, 16)!=16) exit(-1); // 생성한 난수값에서 16바이트를 읽어들임
                close(fd);

        sprintf(fname, "/tmp/%llu", otp[0]); // 첫번째 8바이트 값으로 파일 이름 설정
        FILE* fp = fopen(fname, "w"); // 한 뒤 열기
        if(fp==NULL){ exit(-1); }
        fwrite(&otp[1], 8, 1, fp); // 두번째 8바이트 값을 작성
        fclose(fp);

        printf("OTP generated.\n");

        unsigned long long passcode=0;
        FILE* fp2 = fopen(fname, "r"); // 아까 그 파일 열고
        if(fp2==NULL){ exit(-1); }
        fread(&passcode, 8, 1, fp2); // 파일 내용 읽어들임(그냥 otp[1]값)
        fclose(fp2);

        if(strtoul(argv[1], 0, 16) == passcode){ // 읽어들인 값과 같으면 
                printf("Congratz!\n");
                system("/bin/cat flag"); // 플래그 출력
        }
        else{
                printf("OTP mismatch\n");
        }

        unlink(fname); // 파일 삭제
        return 0;
}
```
들어가면 소스코드와 실행파일을 주는데

난수를 생성해서 입력한 숫자와 같으면 플래그를 출력해주는 문제다.

자세한 해석은 소스코드에 주석으로 달아놈

소스코드를 다 읽어봤다면 otp[1]하고 비교할거면 그냥 그렇게 하지

왜 굳이 파일을 열어서 거기서 읽어들여서 비교할까 하는 의문이 들것이다.

딱봐도 당연히 수상해보인다. 근데 그거 써서 푸는거 맞댄다

```
ulimit -f 0
```

명령으로 쉘에서 파일에 쓸 수 있는 데이터의 크기를 0으로 제한하면

fwrite은 아무것도 하지 못할것이다.

fwrite에서 데이터를 쓰지 못했으므로

fread로 읽어들인 passcode 값은 무조건 NULL이됨

하지만 직접 해보면 fwrite에서 SIGXFSZ가 발생하며 프로그램이 종료되기에

SIGXFSZ를 무시하도록 대책을 따로 마련해야한다.

```C
// setfilefree.c

#include <stdio.h>
#include <signal.h>
#include <unistd.h>

int main(int argc, char* argv[])
{
        sigset_t set;

        sigemptyset(&set);
        sigaddset(&set, SIGXFSZ);

        sigprocmask(SIG_BLOCK, &set, NULL);

        char* proc_argv[] = { argv[0], "0", NULL };
        char* proc_env[] = { NULL };

        execve((const char*)argv[1], proc_argv, proc_env);

        return 0;
}
```

SIGXFSZ를 무시하게 설정하고 otp를 실행하면 인증을 통과하며

플래그를 보여준다

![정답](https://user-images.githubusercontent.com/67177785/129737202-67331f1a-e031-48dc-bb33-27225d64c840.PNG)

flag : Darn... I always forget to check the return value of fclose() :(

# 느낀점

굴욕적이다

내 힘으로 푼게 아니라서 write up도 작성하기 싫어짐

블로그에 이거 문제풀이 한거 보면 문제 진짜 기발하다! 하는데

난 전혀 그런걸 느끼지 못했다. 관련 지식이 아예 없었고 답 안보면 풀 수 없었으니까

ulimit이랑 시그널 둘다 처음 접한개념이었음

그래도 어떡해

시간 지나면 남는건 기록밖에 없는걸

# 비하인드

## 삽질#1

edb가 안돼서 어쩔수 없이 gdb를 쓰게 됐어

응애 나 애기 리버서

![gdb뉴비](https://user-images.githubusercontent.com/67177785/129736957-08eb10b9-a804-460e-a937-28f88dd59700.PNG)

응애...?

![gdb 사용법](https://user-images.githubusercontent.com/67177785/129736961-7b75fd1a-a0d6-4e5b-bf27-db30c25decbb.PNG)

으음..

![gdb뉴비2](https://user-images.githubusercontent.com/67177785/129736965-2173ac98-e7cd-4e83-a117-f2501d879795.PNG)

하 씨발 좇구데기 새끼

cui 좋아하는 사람들 이해 안됨

## 삽질#2

진짜 행동으로 실현하진 않았지만 밥먹으면서, 애니보면서, 잠자면서 생각해봤던 아이디어가 몇 개 있었다.

제일 먼저 생각 해봤던게 fclose로 파일이 닫힐때 otp 프로그램보다 더 빠른 속도로

파이썬으로 파일을 열어 이 안의 내용물을 조작한 뒤 닫는거.

물론 말도 안됀다고 생각했고 카드에서도 race condition은 아니라고 했으므로 패스

두번째로 /dev/urandom은 열때마다 바뀌는데 혹시라도 만약에 xxd같은 커맨드로 여는건 해당이 안되지 않을까?

하는 생각 하지만 실패

굳이 파일에 쓰고 읽고 비교하는걸 괜히 넣지는 않았을텐데 의문이 들긴 했지만

이걸 활용할 아이디어는 떠오르지 않아서 답을 보게 됐다.

당연히 내가 풀 수 없는 문제였음

## 여기서 삽질 하지 말것

![여기서삽질하지말것](https://user-images.githubusercontent.com/67177785/129737074-cc214b18-7d6d-45bf-afcf-5b60a2c5cc52.PNG)

감사합니다!ㅠㅠ
