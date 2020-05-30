org 0x0100
jmp start
frame:
	;once a frame-ish [insert geometry parameters]
	inc word [frames]
	;trigger some multi-task-ish
	jmp esc

render:
mov ax, 0x0C14 ;pixel write : 0x__14 : color
mov word [x], cx
mov word [y], dx
; __________________________
; ::: / your demo here / ::: 

	mov si, 	word [frames]
	mov di, 	word [color]

	mov cx, 	[x]
	mov dx, 	[y]

	;triangle with side squareV( 50 )
	cmp dx, 	cx	;down side : switch cx and dx 
	jg 	@f			;			 to have
	add dx, 	cx  ;			 the same geometry
	cmp dx, 	100 ;			 left sided
	jg @f			;			 switch to jbe to have it upwards

	;lighter grey outer color
	mov al, 	byte [color]
	add al, 	2

@@: ; ::: / Main Framework Loop / :::
xor al, 2		;half dark and light

mov cx, [x]		
mov dx, [y]
int 10h			;pixel store
dec cx
cmp cx, 0
jge render
mov cx, 320		;initial x-coordinate
dec dx
cmp dx, 0
jge render
mov dx, 200		;initial y-coordinate
dec bx 			;trigger some multi-task-ish
jnz frame 

esc:
mov ah, 01h
int 16h
cmp al, 27		;exit on [esc] key press
jne render

xor ax, ax 		;cleanup and quit
int 16h
xor cx,cx
mov ax,3h
int 10h
int 20h

start:			;[BIOS]
mov ax,0013h	;graphic [mode] : 320x200
int 10h
mov cx,0x263f	;blue
mov dx,0xd0d0
mov ax,0x1010	;graphic [full screen]{}
int 10h
mov cx, 320 	;coordinate x
mov dx, 200 	;coordinate y
jmp render

;vars
frames dd 0x0
color dw 0x15
x dw 320
y dw 200

black db 0x10, 0x11
grey db 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A
white db 0x1d, 0x1e
green db 0x2F, 0x30, 0x31, 0x32
