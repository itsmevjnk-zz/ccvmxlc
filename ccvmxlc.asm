; Con Ca Vang Mau Xanh La Cay
; original music by Nguyen Tuan Huy @ HSGS
; adapted to x86 assembly by Nguyen Thanh Vinh @ CVA

BITS 16
ORG 0x100

jmp start

; delay - waits for [AX] milisecond(s).
delay:
pushf
push ax
push cx
push dx
mov cx, 1000 ; ms to us
mul cx
mov cx, dx
mov dx, ax
mov ah, 0x86
int 0x15
pop dx
pop cx
pop ax
popf
ret

; sound - makes an [AX] Hz beep. AX<19 to stop.
sound:
pushf
push ax
push bx
push dx
cmp ax, 19
jb .stop
mov bx, ax
mov al, 0xb6
out 0x43, al
; DX:AX=1193180
mov dx, 0x12
mov ax, 0x34dc
div bx
out 0x42, al
mov al, ah
out 0x42, al
in al, 0x61
mov ah, al
or ah, 3
cmp ah, al
je .ok ; no need
or al, 3
out 0x61, al
.ok:
pop dx
pop bx
pop ax
popf
ret
.stop:
in al, 0x61
and al, 0xfc
out 0x61, al
jmp .ok

; play - plays a [AX] Hz sound for [BX] miliseconds.
play:
push ax
call sound
mov ax, bx
call delay
pop ax
ret

; stop - stops playing for [AX] miliseconds.
stop:
push ax
xor ax, ax
call sound
pop ax
call delay
ret


str0: db "Con $"
str1: db "ca $"
str2a: db "vang...", 0x0d, 0x0a, "$"
str2b: db "vang... $"
str3: db "mau $"
str4: db "xanh $"
str5: db "la $"
str6: db "cay!", 0x0d, 0x0a, "$"
str7:
db 0x0d, 0x0a, 0x0d, 0x0a
db "original music by:", 0x0d, 0x0a
db " Nguyen Tuan Huy @ A2 K22 Sinh HSGS", 0x0d, 0x0a
db "written for x86 by:", 0x0d, 0x0a
db " Nguyen Thanh Vinh @ K113 Ly CVA", 0x0d, 0x0a
db "$"

%define NOTE_C 262
%define NOTE_D 294
%define NOTE_E 330
%define NOTE_F 349
%define NOTE_G 392
%define NOTE_A 440
%define NOTE_B 494

%define INTV_16 100
%define INTV_8 (INTV_16 * 2)
%define INTV_4 (INTV_8 * 2)
%define INTV_2 (INTV_4 * 2)
%define INTV_1 (INTV_2 * 2)

start:
mov dx, str0
mov ah, 9
int 0x21
mov ax, NOTE_E
mov bx, INTV_4
call play

mov dx, str1
mov ah, 9
int 0x21
mov ax, NOTE_G
mov bx, INTV_8
call play

mov dx, str2a
mov ah, 9
int 0x21
mov ax, NOTE_C
mov bx, (INTV_8 + INTV_4)
call play

mov ax, INTV_4
call stop

mov dx, str0
mov ah, 9
int 0x21
mov ax, NOTE_A
mov bx, INTV_4
call play

mov dx, str1
mov ah, 9
int 0x21
mov ax, (NOTE_C * 2)
mov bx, INTV_8
call play

mov dx, str2a
mov ah, 9
int 0x21
mov ax, NOTE_F
mov bx, (INTV_8 + INTV_4)
call play

mov ax, INTV_4
call stop

mov dx, str0
mov ah, 9
int 0x21
mov ax, NOTE_B
mov bx, INTV_4
call play

mov dx, str1
mov ah, 9
int 0x21
mov ax, (NOTE_D * 2)
mov bx, INTV_8
call play

mov dx, str2b
mov ah, 9
int 0x21
mov ax, NOTE_G
mov bx, (INTV_8 * 2)
call play

mov dx, str3
mov ah, 9
int 0x21
mov ax, NOTE_A
mov bx, INTV_8
call play

mov dx, str4
mov ah, 9
int 0x21
mov ax, NOTE_B
mov bx, INTV_8
call play

mov dx, str5
mov ah, 9
int 0x21
mov ax, (NOTE_D * 2)
mov bx, INTV_8
call play

mov dx, str6
mov ah, 9
int 0x21
mov ax, (NOTE_C * 2)
mov bx, (INTV_2 + INTV_4)
call play

mov ax, INTV_4
call stop

xor ax, ax
call sound

mov dx, str7
mov ah, 9
int 0x21

mov ax, 0x4c00
int 0x21
