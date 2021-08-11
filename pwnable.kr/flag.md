# 풀이과정

![카드](https://user-images.githubusercontent.com/67177785/129003585-c008aac0-add4-4759-827d-7528a7223bff.PNG)

오래간만의 리버싱 문제

![flag 실행](https://user-images.githubusercontent.com/67177785/129003648-11e74528-30cd-4f13-8f44-603e4782e1ed.PNG)

메모리에 복사했다고 하니까 디버깅하면 찾을 수 있을듯

근데 이상한점이

![puts추적](https://user-images.githubusercontent.com/67177785/129003700-19008169-5b4c-4403-bf5b-64a8b460dd9c.PNG)

printf에 bp를 걸려고 봤더니 안됨 puts도 안되고

문제에서 packed present라고 한거 보니까 패킹되있는거 같음

![upx패킹확인](https://user-images.githubusercontent.com/67177785/129003783-d611ab17-e986-4e38-9d87-8c87a9ac10e2.PNG)

elf viewer로 보니까 upx 패킹을 확인할 수 있었다 

upx는 분석을 방해하기 위한 패커가 아니므로 쉽게 풀 수 있음

푼 다음에 puts함수를 추적해서 나오는 코드를 분석하면

![정답](https://user-images.githubusercontent.com/67177785/129003880-0364dff9-61c8-454b-b9c0-2323da307c0c.PNG)

malloc으로 할당한 공간에 작성한 플래그를 확인 할 수 있다.

flag : UPX...? sounds like a delivery service :)

# 번외

## 삽질

![rw-](https://user-images.githubusercontent.com/67177785/129004256-344cfd5e-a6bf-40ec-a4b0-e75707e68f38.PNG)

아니 근데 flag이거 제대로 실행안되는데? 

bof도 이렇더만 문제가.. 실행파일이 잘못된건지

검색해도 안나오고.. 그럼 대충 생각할 수 있는게

rwx가 안된건가?

![ls](https://user-images.githubusercontent.com/67177785/129004525-f1f74c09-3ebe-4173-a860-e0b79680f6b1.PNG)

그러네 내가 컴맹이었네

chmod 700 flag

## 환경설정

![elf viewer download](https://user-images.githubusercontent.com/67177785/129004614-d8564f87-9ee8-4f04-aa4f-08d2c253aec3.PNG)

elf viewer 깔고

![upx download](https://user-images.githubusercontent.com/67177785/129004513-5bda61f7-f360-4982-b3e3-1a231b0b50ac.PNG)

upx도 깔고

내가 리눅스는 분석환경이 좀 열악했네

그래도 ctf대회 나가서 이러지 않는게 다행
