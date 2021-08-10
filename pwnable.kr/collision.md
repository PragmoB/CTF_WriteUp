# 풀이과정

![카드](https://user-images.githubusercontent.com/67177785/128886542-ad491fd2-93a4-4638-b0a5-e4a1752aa75b.PNG)

카드에 나온대로

ssh col@pwnable.kr -p2222로 접속을 하면

파일이 col, col.c, flag 이렇게 3가지가 있다.

당연히 flag를 직접적으로 여는건 안되고 col을 실행해서 여는건데

col.c에 소스코드가 나와있으므로 한번 살펴보자.

![소스코드](https://user-images.githubusercontent.com/67177785/128880077-66c93bdb-e2df-40ea-8619-5257441da301.PNG)

인자로 들어온 20자의 문자열을 4바이트 단위로 더해서 결과값이 0x21DD09EC면 통과다.

? 아니 잠깐만 0x21DD09EC를 5로 나누면 0x06C5CEC8인데 ascii 06같은걸 키보드로 입력할 수 있나?

0x21DD09EC 이건 수가 너무 작은거 아닌가? 생각이 들었지만 더하는 과정에서 오버플로우가 일어나면 그 비트는 버려진다.

그 말은 즉 더한 값이 0x121DD09EC여도 앞의 1은 버려지므로 통과라는 소리다. 이걸 이용해서 풀었다

0x121DD09EC는 5로 나누면 0x39F901FC이므로 조금만 가공해주면 키보드로 입력하기 적절하다.

키보드로 입력할 수 있도록 0x121DD09EC를 0x3A5F6862 + 0x3A5F6862 + 0x3A5F6862 + 0x395F6862 + 0x395F6864 로 쪼갰다.

byte order는 보통 little endian을 사용하므로 배열을 거꾸로해서 아스키코드표로 바이트들을 치환해주면

dh_9bh_9bh_:bh_:bh_:

이 된다. 이 값을 저 해시 알고리즘에 넣어주면 합은 0x121DD09EC이지만 오버플로우된건 날아가므로 실제로 실행해보면

결과는 0x21DD09EC이 된다.

![정답](https://user-images.githubusercontent.com/67177785/128878807-6ac2bd49-7774-4b44-b7b5-c35a3d1262c9.PNG)

flag : daddy! I just managed to create a hash collision :)

# 느낀점

이 문제풀이의 핵심은 오버플로우를 이용한 트릭이다.

그래서 문제 이름도 collision(충돌)이다. 입력값은 다르지만 결과값은 같은

해시함수의 특징을 잘 설명한 이름이다

해시 충돌의 가장 근본적인 원인을 잘 녹여낸 문제라고 생각한다.

아무튼 재밌게 풀었음

# 번외

![노가다](https://user-images.githubusercontent.com/67177785/128878828-0fd36928-1e83-4b6d-a206-12db48860f30.jpg)

야가다의 흔적..ㅋㅋ