_DATA SEGMENT

format db "input data : ", 0
aS db "%s", 0
aFlagIsS db "Flag is %s", 0

_DATA ENDS

_TEXT SEGMENT

EXTERN _printf : PROC
EXTERN ___isoc99_scanf : PROC

PUBLIC the_asm

the_asm PROC

	push    rbp
	mov    rbp, rsp
	sub     rsp, 410h
	mov     rax, fs:28h
	mov     [rbp+0x8], rax
	xor     eax, eax
	mov     edi, offset format ; "input data : "
	mov     eax, 0
	call    _printf
	lea     rax, [rbp+0x410]
	mov     rsi, rax
	mov     edi, offset aS  ; "%s"
	mov     eax, 0
	call    ___isoc99_scanf
	lea     rax, [rbp+0x410]
	mov     rdi, rax
	call    Boom
	mov     esi, offset KCTF
	mov     edi, offset aFlagIsS ; "Flag is %s.\n"
	mov     eax, 0
	call    _printf
	mov     eax, 0
	mov     rdx, [rbp+0x8]
	xor     rdx, fs:28h
	jz      short locret_400674
	push    rbp
	mov     rbp, rsp
	mov     [rbp+0x8], rdi
	mov     rax, [rbp+0x8]
	movzx   eax, byte ptr [rax]
	cmp     al, 4Eh ; 
	jz      short loc_400692
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

the_asm ENDP

Boom PROC
	loc_400692:
	mov     cs:byte_601080, 32h ; 
	mov     rax, [rbp+0x8]
	add     rax, 1
	movzx   eax, byte ptr [rax]
	cmp     al, 61h ; 
	jz      short loc_4006B1
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_4006B1:
	mov     cs:byte_601081, 30h ; 
	mov     rax, [rbp+0x8]
	add     rax, 2
	movzx   eax, byte ptr [rax]
	cmp     al, 63h ; 
	jz      short loc_4006D0
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_4006D0:
	mov     cs:byte_601082, 32h ; 
	mov     rax, [rbp+0x8]
	add     rax, 3
	movzx   eax, byte ptr [rax]
	cmp     al, 68h ; 
	jz      short loc_4006EF
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_4006EF:
	mov     cs:byte_601083, 31h ; 
	mov     rax, [rbp+0x8]
	add     rax, 4
	movzx   eax, byte ptr [rax]
	cmp     al, 6Fh ; 
	jz      short loc_40070E
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_40070E:
	mov     cs:byte_601084, 5Fh ; 
	mov     rax, [rbp+0x8]
	add     rax, 5
	movzx   eax, byte ptr [rax]
	cmp     al, 5Fh ; 
	jz      short loc_40072D
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_40072D:
	mov     cs:byte_601085, 4Bh ; 
	mov     rax, [rbp+0x8]
	add     rax, 6
	movzx   eax, byte ptr [rax]
	cmp     al, 4Ch ; 
	jz      short loc_40074C
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_40074C:
	mov     cs:byte_601086, 43h ; 
	mov     rax, [rbp+0x8]
	add     rax, 7
	movzx   eax, byte ptr [rax]
	cmp     al, 69h ; 
	jz      short loc_40076B
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_40076B:
	mov     cs:byte_601087, 54h ; 
	mov     rax, [rbp+0x8]
	add     rax, 8
	movzx   eax, byte ptr [rax]
	cmp     al, 62h ; 
	jz      short loc_40078A
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_40078A:
	mov     cs:byte_601088, 46h ; 
	mov     rax, [rbp+0x8]
	add     rax, 9
	movzx   eax, byte ptr [rax]
	cmp     al, 72h ; 
	jz      short loc_4007A9
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_4007A9:
	mov     cs:byte_601089, 7Bh ; 
	mov     rax, [rbp+0x8]
	add     rax, 0Ah
	movzx   eax, byte ptr [rax]
	cmp     al, 65h ; 
	jz      short loc_4007C8
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_4007C8:
	mov     cs:byte_60108A, 68h ; 
	mov     rax, [rbp+0x8]
	add     rax, 0Bh
	movzx   eax, byte ptr [rax]
	cmp     al, 5Fh ; 
	jz      short loc_4007E7
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_4007E7:
	mov     cs:byte_60108B, 34h ; 
	mov     rax, [rbp+0x8]
	add     rax, 0Ch
	movzx   eax, byte ptr [rax]
	cmp     al, 4Ah ; 
	jz      short loc_400806
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_400806:
	mov     cs:byte_60108C, 70h ; 
	mov     rax, [rbp+0x8]
	add     rax, 0Dh
	movzx   eax, byte ptr [rax]
	cmp     al, 61h ; 
	jz      short loc_400825
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_400825:
	mov     cs:byte_60108D, 70h ; 
	mov     rax, [rbp+0x8]
	add     rax, 0Eh
	movzx   eax, byte ptr [rax]
	cmp     al, 63h ; 
	jz      short loc_400844
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_400844:
	mov     cs:byte_60108E, 79h ; 
	mov     rax, [rbp+0x8]
	add     rax, 0Fh
	movzx   eax, byte ptr [rax]
	cmp     al, 6Bh ; 
	jz      short loc_400863
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_400863:
	mov     cs:byte_60108F, 5Fh ; 
	mov     rax, [rbp+0x8]
	add     rax, 10h
	movzx   eax, byte ptr [rax]
	cmp     al, 5Fh ; 
	jz      short loc_400882
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_400882:
	mov     cs:byte_601090, 68h ; 
	mov     rax, [rbp+0x8]
	add     rax, 11h
	movzx   eax, byte ptr [rax]
	cmp     al, 62h ; 
	jz      short loc_4008A1
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_4008A1:
	mov     cs:byte_601091, 34h ; 
	mov     rax, [rbp+0x8]
	add     rax, 12h
	movzx   eax, byte ptr [rax]
	cmp     al, 6Ch ; 
	jz      short loc_4008C0
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_4008C0:
	mov     cs:byte_601092, 70h ; 
	mov     rax, [rbp+0x8]
	add     rax, 13h
	movzx   eax, byte ptr [rax]
	cmp     al, 61h ; 
	jz      short loc_4008DF
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_4008DF:
	mov     cs:byte_601093, 70h ; 
	mov     rax, [rbp+0x8]
	add     rax, 14h
	movzx   eax, byte ptr [rax]
	cmp     al, 63h ; 
	jz      short loc_4008FE
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_4008FE:
	mov     cs:byte_601094, 79h ; 
	mov     rax, [rbp+0x8]
	add     rax, 15h
	movzx   eax, byte ptr [rax]
	cmp     al, 6Bh ; 
	jz      short loc_40091D
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_40091D:
	mov     cs:byte_601095, 5Fh ; 
	mov     rax, [rbp+0x8]
	add     rax, 16h
	movzx   eax, byte ptr [rax]
	cmp     al, 5Fh ; 
	jz      short loc_40093C
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_40093C:
	mov     cs:byte_601096, 32h ; 
	mov     rax, [rbp+0x8]
	add     rax, 17h
	movzx   eax, byte ptr [rax]
	cmp     al, 61h ; 
	jz      short loc_400958
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_400958:
	mov     cs:byte_601097, 6Dh ; 
	mov     rax, [rbp+0x8]
	add     rax, 18h
	movzx   eax, byte ptr [rax]
	cmp     al, 63h ; 
	jz      short loc_400974
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_400974:
	mov     cs:byte_601098, 34h ; 
	mov     rax, [rbp+0x8]
	add     rax, 19h
	movzx   eax, byte ptr [rax]
	cmp     al, 74h ; 
	jz      short loc_400990
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_400990:
	mov     cs:byte_601099, 72h ; 
	mov     rax, [rbp+0x8]
	add     rax, 1Ah
	movzx   eax, byte ptr [rax]
	cmp     al, 6Fh ; 
	jz      short loc_4009AC
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_4009AC:
	mov     cs:byte_60109A, 74h ; 
	mov     rax, [rbp+0x8]
	add     rax, 1Bh
	movzx   eax, byte ptr [rax]
	cmp     al, 72h ;
	jz      short loc_4009C8
	mov     rax, [rbp+0x8]
	jmp     loc_4009CF

	loc_4009C8:
	mov     cs:byte_60109B, 7Dh ;

	loc_4009CF:
	pop     rbp
	retn
Boom ENDP

_TEXT ENDS

END