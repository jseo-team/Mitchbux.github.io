org 0x0100
jmp start
frame:
	;once a frame-ish 
	;insert geometry [parameters]

	mov si, word [frames]
	cmp si, 18
	jb @f

	mov ax, [color]
	add ax, 0x19
	cmp ax, 0x5f
	jb @ok
	mov ax, 0x2f
@ok:
	mov [color],ax

	mov eax, framer
	jmp word [eax]

@@:

	inc word [frames]
	; try keyboard
waitesc:


	jmp esc
dark:
	cmp [big], 0
	je esc
	sub [big], 200
	dec [gray]
	add [center], 4000
	jmp esc
render:

; save demo_pos
 mov word [x+2], cx
 mov word [y+2], dx

; ::: / Your Demo Here / :::

;background
	mov cx, word [frames]
	imul cx, 3
	mov si, cx
	add si, 230

	mov di, 50
	sub di, cx
	sub dx, di
	imul dx, dx
	mov cx, si
	sub cx, word [x+2]
	imul cx, cx
	imul cx, 3
	imul dx, 2
	add dx, cx
	mov al, byte [color]

	sub dx, [center]
	cmp dx, [big]
	jbe  @f

	mov al, [gray]
	jmp opt

@@:
	cmp dx, 680
	jb  @f
	mov ax , word [x+2]

;background blue-gray color mix
	shr al, 5
	and al, 0x3d
	add al, 0x15

@@:
opt:
;scene grab
	mov si, word [frames]
	cmp si, 18
	jne @f
	cmp [framer], dark
	je pix
@@:
;menu init
	mov cx, word [x+2]
	mov dx, word [y+2]
	mov di, 4

	cmp cx, 0x10
	jbe pix
	cmp cx, 105
	jg pix

	imul dx, si
	add dx, cx
	mov si, 310
	mov di, menu
	sub di, 2

;menu options
looth:
	add di, 2
	add si, 40
	cmp dx, si
	jbe @f
	add si, 350
	cmp dx, si
	jg @f
	mov al, 0x1c
	cmp word [di], 4
	je @f
	mov al, 0x1a
@@:
	cmp si, 2500
	jb looth

;mirror effect
	cmp dx, 2900
	jbe @f
	cmp cx, 0x10
	jb @f

	inc al

@@: ; ::: / Main Framework Loop / ::: {
pix:

;pixel store

cld
mov ah, 0x0C
mov cx, word [x+2]
mov dx, word [y+2]
int	10h

;screen boundary check
dec cx
cmp cx, 0
jg  render
mov cx, 320

dec dx
cmp dx, 0
jge	render
mov dx, 200

				;(INTERFACE)
dec bx		;trigger	[FPS]
jnz	frame	;sync		{frame} every BX frame stored

	; [NO-SYNC] fps delay (bigger is longer) 
	; SYNC [0xFFFF] NO-SYNC [0x0001]
	 mov bx, 0x01FF

	; ::: / Keyboard Routine / ::: {
esc:
mov ah, 01h		;setmode	[direct]
int	16h		;keyboard	[direct]
cmp al, 27		;key press	[esc]
je exit
cmp al, 0x0d		;key press	[enter]
je exit

mov di, [index]
mov si, -2
cmp ah, 0x48		;key press	[up]
je menusel
mov si, 2
cmp ah, 0x50		;key press	[down]
je menusel

jmp render


menusel:
xor ax, ax		;clear
int	16h		;keyboard	[buffer]

mov word [di], 2
add  [index], si
add di, si

;todo : menu boundary check
mov word [di], 4
jmp render


	; ::: / Cleanup Routine / ::: {
exit:	;(CLEANUP)

xor ax, ax		;clear
int	16h		;keyboard	[buffer]
cmp [framer], dark
jne @f

xor cx, cx		;clear
mov ax, 3h		;graphic	[restore]
int	10h		;video		
int	20h		;exit		

@@:
mov [framer], dark
jmp render

	; ::: / Start Entry Point / ::: {
start:			;(BIOS)
mov ax, 0013h	;graphic	[320x200]
int	10h		;video		
mov cx, 0x263f	;blue		[word]
mov dx, 0xd0d0	;external	[data]
mov ax, 0x1010	;graphic	[full screen]
int	10h		;video

mov cx, 320	;horizontal [x]
mov dx, 200	;vertical	[y]
jmp	render	;								

;vars
frames dd 0x01
framer dw waitesc
color dw 0x36
x dd 320
y dd 200
circle dw 0, 50, 800, 0
menu   dw 4,2,2,2,2,2,2,2
index  dw menu
item dw 2
big dw 1600
center dw 24500
gray db 0x18

times 512-2-($-$$) db 90h
signature dw 0x55AA

;fat12 \
;  "DEMO	 ASM", "demo.asm", ff0, \
;  "DEMO	 COM", "demo.com", ff1,  \
;  "FASM	 EXE", "fasm.exe", ff2,  \
;  "FASMD	 EXE", "fasmd.exe", ff3


