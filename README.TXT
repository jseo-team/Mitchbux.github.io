::::: / DEMO x86 ASSEMBLY for BIOS / :::::

[FILES]{

- RUSH.ASM : BLANK DEMO, FRAMEWORK INCLUDED < 100b

- DEMO.ASM : LATEST PROD, JUST IN CASE THE PURPOSE IS BOOTLOADER

- FASM.EXE : ASSEMBLE & COMPILE AS .COM ANY .ASM USAGE> FASM FILE.ASM

- FASMD.EXE : EDITOR. USE F-KEYS:
[F2] SAVE
[F4] LOAD
[F7] SEARCH
[F9] RUN (ALSO PRODUCES THE EXECUTABLE .COM)


- CWSDPMI.EXE : RUN BEFORE FASM or FASMD
   you can use editor.bat to load your favorite source code

}

[X86 ASM]{

- REGISTERS
ESI,	EDI,	(EBP,ESP : reserved by OS & stack)
EAX,	EBX,	ECX,	EDX    (32bits : DWORD - var dd 0, 0, 0, 0)

AX   ,	BX,	CX,	DX     (16bits : WORD - var dw 0, 0)

AH|AL	BH|BL	CH,CL	DH|DL  (8bits  : High | Low BYTE var db 0)

-INTERUPTS     (BIOS)
INT 10h : VIDEO
INT 16h : KEYBOARD
INT 20h : EXIT
Please read the documentation carefully about those

-INSTRUCTIONS
MOV destination, data
  ex : mov ax, word [var] ; set ax with word data inside 'var'
       mov ax, bx	  ; set ax with word data inside 'bx'

ADD,SUB,IMUL,IDIV destination, data : add substract multiply divide
  ex : add ax, 2 ; set ax with the word data inside ax + 2

SHR destination, data : shift right
  ex : shr ax, 2 ; shift ax register by 2 bits.
		 ; If the value vas 0110b it is now 01b
		 ; also divide by 2^data
SHL destination, data : shift left
  ex : shl ax, 2 ; shift ax register by 2 bits.
		 ; If the value vas 0110b it is now 011000b
		 ; also multiply by 2^data

ROR, ROL destination, data : like shift, rotate bits left or right
  ex : ror ax , 2 ; will shift right then rotate the lost bits to the left

PUSH, POP data : pushes and then pop first-in-first-out
  ex : push eax      ; eax is saved
       mov ebx, [var]
       add eax, ebx  ; eax is now EAX+[VAR]
       pop eax	     ; eax is back to the previous content


JMP label : jump immediately to the label
  ex :
     start:
	add eax, 2
	jmp start   ; infinite loop between here and start

(COMPARISON & CONDITION)
CMP what, data : compares what to data
  ex : cmp eax, 2
       jne outside ; jumps only if ( eax , 2 ) are not equal to each other

JNE : Jump Not Equal
JNZ : Jump Non Zero
JG : Jump if Greater
JGE : Jump if Greater or Equal
JB : Jump if Below
JBE : Jump if Below or Equal

etc...

instructions such as AND,OR,NOT,XOR can set the condition to jump
(todo...)

you can read the documentation about special instructions such as
stosb, rep, etc...

}