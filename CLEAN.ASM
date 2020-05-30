org 100h

;change color mode
mov ax,0013h
int 10h

;set blue color
mov cx,0x263f
mov dx,0xd0d0

;full screen
mov ax,0x1010
int 10h

;mov byte [di], 14h

mov cx, 320 ;coordinate x
mov dx, 200 ;coordinate y



render:

mov ax, 0x0C14 ;pixel write : 0x__14 : color
mov [x], cx
mov [y], dx

;your demo here

	;once a pixel
	mov si , word [frames]
	mov di , word [color]

	mov cx, [x]
	mov dx, [y]

	cmp dx, cx
	jg @f
	add dx, cx
	cmp dx, 100
	jg @f

	;light
	mov al, byte [color]
	add al, 2

;half dark and light
xor al, 2

;pixel looper
mov cx, [x]
mov dx, [y]
int 10h
dec cx
cmp cx, 0
jg render
mov cx, 320
dec dx
cmp dx, 0
jge render
mov dx, 200

;trigger some multi-task-ish
dec bx
jnz frame

frame:
	;once a frame-ish
	mov si, word [frames]
	add si, 1
	mov word [frames], si


;trigger some multi-task-ish
dec bx
jnz esc

esc:
	;exit on [esc] key press
	mov ah, 01h
	int 16h
	cmp al, 27
	jne render

;cleanup and quit
xor ax, ax
int 16h
xor cx,cx
mov ax,3h
int 10h
int 20h

;vars
circle dw 1
hundred dw 255
frames dd 0x0
color dw 0x15
x dw 320
y dw 200

black db 0x10, 0x11
grey db 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A
white db 0x1d, 0x1e
green db 0x2F, 0x30, 0x31, 0x32
