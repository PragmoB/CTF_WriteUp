#include <iostream>
#include <cstdio>
#include <conio.h>

using namespace std;

#define NUM_BITS_IN_INT (sizeof(int) * 8)

int main()
{
	int i;
	for (i = 0; i < 0xffffffff; i++)
	{
		int temp;
		_asm {
			mov eax, 0xb7aac296
			mov cl, al
			mov ebx, i
			rol ebx, cl
			xor eax, ebx
			mov cl, bh
			ror eax, cl
			mov temp, eax
		};
		if (temp == 0x5a5a7e05)
			printf("EBX : 0x%X\n", i);
	}
	_getch();
	return 0;
}
