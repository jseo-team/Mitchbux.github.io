org 0x0100
jmp start
frame:
	;once a frame-ish 
	;insert geometry [parameters]
	inc word [frames]
		
	; try keyboard
	jmp esc

render:
 mov ax, 0x0C14 ;[store] 0x14 : color
 mov word [x], cx
 mov word [y], dx

; ::: / Your Demo Here / ::: 
	mov si, 	word [frames]
	mov di, 	word [color]

	;triangle with side squareV( 50 )
	cmp dx, 	cx  ; up-down sided : switch cx and dx
	jg	@f	    ; to have
	add dx, 	cx  ; the same geometry 				
	cmp dx, 	100 ; left sided						
	jbe  @f 	     ; switch to jbe to have it right sided

	;lighter grey color [change]
	mov al, 	byte [color]			
	add al, 	2						

@@: ; ::: / Main Framework Loop / ::: {
xor al, 2		;half dark and darker grey				

mov ah, 0x0C	;setmode	[store]
mov cx, [x]		;clear		[horizontal]
mov dx, [y]		;external	[vertical]
int	10h		;video		

				;(BOUNDARIES)
dec cx			;trigger	[horizontal]
cmp cx, 0		;horizontal	[empty] 			
jg		render	;or			{render}
mov cx, 320		;initial	[horizontal]

dec dx			;trigger	[vertical]
cmp dx, 0		;vertical	[empty] 			
jge	render	;orelse 	{render}
mov dx, 200		;initial	[vertical]

				;(INTERFACE)
dec bx			;trigger	[FPS]
jnz	frame	;sync		{frame} every BX frame stored

	; [NO-SYNC] fps delay (bigger is longer) 
	; SYNC [0xFFFF] NO-SYNC [0x0001]
	; mov bx, 0xFFFF

	; ::: / Keyboard Routine / ::: {
esc:			;(KEYBOARD)
mov ah, 01h		;setmode	[direct]
int	16h		;keyboard	[direct]
cmp al, 27		;key press	[esc]				
jne	render

	; ::: / Cleanup Routine / ::: {
				;(CLEANUP)
xor ax, ax		;graphic	[register]
int	16h		;keyboard	[buffer]
xor cx, cx		;clear		[register]
mov ax, 3h		;graphic	[restore]
int	10h		;video		
int	20h		;exit		

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
frames dd 0x0
color dw 0x15
x dw 320
y dw 200

black db 0x10, 0x11
grey db 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A
white db 0x1d, 0x1e
green db 0x2F, 0x30, 0x31, 0x32
