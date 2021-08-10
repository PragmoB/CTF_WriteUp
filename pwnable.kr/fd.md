# 시작

![시작](https://user-images.githubusercontent.com/67177785/128855123-7670ac55-32e6-4ac2-a257-b84772ceb3a2.PNG)

카드에 보이는대로 리눅스에서 fd@pwnable.kr에 접속해주자.

접속 직후 파일을 보게되면 fd, fd.c, flag가 있는데 이 flag파일에 정답이 들어있다.

cat flag로 파일을 보려 했으나 당연히 안됨

fd.c를 보니 fd를 실행해서 flag파일을 열면 될듯 하다.

![코드](https://user-images.githubusercontent.com/67177785/128855128-861c6071-76d3-47a9-97cd-34451b95b1f8.PNG)

조건을 보면 인자로 넘겨준 파일 디스크립터 번호에서 값을 읽어들여 LETMEWIN이면 통과인데,

4년전에 학원에서 배운 내용이 문득 생각났다.

리눅스에서 0번은 입력 화면이고, 1번은 출력 화면이고, 2번은 에러 출력 화면이다.

0번에서 값을 읽어들인다는건 입력 화면에서 값을 읽는것이므로 키보드 입력을 통해 저 buf값을 조작할 수 있다.

인자로 넘겨준 번호에서 4660(0x1234)를 빼므로 4660을 넘겨주면 된다.

![성공](https://user-images.githubusercontent.com/67177785/128856442-fad99116-8dff-4586-a6b5-8d54dd059095.PNG)

flag : mommy! I think I know what a file descriptor is!!