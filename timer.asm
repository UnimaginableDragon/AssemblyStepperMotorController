SHOW MACRO COUNT 
    ;CLRSCR
    CURSOR 0AH, 23H
    MOV AX, COUNT
    MOV BL, 3CH ; BL = 60
    DIV BL
    MOV AH, 0H  
    MOV BL, 3CH
    DIV BL
    MOV MIN, AH
    MOV HR,  AL
    MOV AH, 0H
    MOV BL, 10
    DIV BL
    MOV H2,AL
    MOV H1,AH
    MOV AH,0H
    MOV AL, MIN
    DIV BL
    MOV M2, AL
    MOV M1, AH
    MOV AH,2H
    MOV DL,H2
    ADD DL,30H
    INT 21H
    MOV AH,2H
    MOV DL,H1
    ADD DL,30H
    INT 21H
    MOV AH,2H
    MOV DL,':'
    INT 21H   
    
    MOV AH,2H
    MOV DL,M2
    ADD DL,30H
    INT 21H  
    
    MOV AH,2H
    MOV DL,M1
    ADD DL,30H
    INT 21H

ENDM

MSGDISPLAY MACRO MES
MOV AH, 09
MOV DX, OFFSET MES
INT 21H
ENDM

DELAY MACRO
mov     cx, 0fh ; should be ofh
mov     dx, 4240h
mov     ah, 86h
int     15h
ENDM

CLRSCR MACRO
MOV AX,0600H
MOV BH, 7
MOV CX,0000
MOV DX,184FH
INT 10H
ENDM
CHKPRS  MACRO
MOV     AH, 1
INT     16H
ENDM

GETKEY   MACRO
MOV    CX, 0
XOR    CL, CH
MOV    AH, 0
INT     16h
ENDM

CURSOR MACRO ROW, COL
XOR BX, BX
MOV AH, 02
MOV BL, 00
MOV DH, ROW
MOV DL, COL
INT 10H
ENDM
.MODEL SMALL
.STACK 64H
.DATA 

COUNT DW 0 
MIN   DB 0
HR    DB 0
H1    DB 0
H2    DB 0
M1    DB 0
M2    DB 0 

USERMESSAGE1 DB 'press S/s to start timer$'
USERMESSAGE2 DB 'press E/e to stop timer$'
USERMESSAGE3 DB 'press to go out by Q/q$'
.CODE
MAIN:
MOV AX,@DATA
MOV DS,AX

CLRSCR
CURSOR 0AH, 24H
MSGDISPLAY USERMESSAGE1;
;DELAY
CURSOR 0BH, 24H
MSGDISPLAY USERMESSAGE2
;DELAY
CURSOR 0CH, 24H
MSGDISPLAY USERMESSAGE3



;CLRSCR

MOV AX,0
xor AX,AX
MOV COUNT,AX
start:
MOV AH, 07H
INT 21H 
;CLRSCR
CMP AL,'S' 
JZ lop

CMP AL,'s' 
JZ lop     

CMP AL, 'Q'
JZ exit
CMP AL, 'q'
JZ exit

JMP start

lop:
    
    CLRSCR
    MOV AX, COUNT
    CALL SHD
    INC COUNT 
    DELAY   
   
    
   
    
    CHKPRS
    JZ lop       ; IF NOT PRESSED
    GETKEY       ; KEY IN AL
    
    
    CMP AL,'S'
    JZ lop
    CMP AL, 's'
    JZ lop
    CMP AL, 'E'
    JZ start
    CMP AL, 'e'
    JZ start
    CMP AL, 'Q'
    JZ exit
    CMP AL, 'q'
    JZ exit
    
    JMP lop

exit:MOV AH, 4CH
INT 21H
SHD PROC

PUSH BX
    
    
    MOV BL, 3CH ; BL = 60   
    ;MOV BL,3 ; DEBUG
    DIV BL
    MOV MIN, AL
    MOV AX,0000H
    MOV AL,MIN
    MOV AH,0
    DIV BL
    MOV MIN, AH
    MOV HR,  AL
    ;MOV AH, 0H
    MOV BL, 10
    MOV AX,0000H
    MOV AL,HR
    MOV AH,0
    DIV BL
    MOV H2,AL
    MOV H1,AH
    ;MOV AH,0H
    MOV AL, MIN
    MOV AH,0H
    DIV BL
    MOV M2, AL
    MOV M1, AH
    
    PUSH AX
    CLRSCR
    CURSOR 0AH, 23H    
    POP  AX
    
    MOV AH,2H
    MOV DL,H2
    ADD DL,30H
    INT 21H
    MOV AH,2H
    MOV DL,H1
    ADD DL,30H
    INT 21H
    MOV AH,2H
    MOV DL,':'
    INT 21H   
    
    MOV AH,2H
    MOV DL,M2
    ADD DL,30H
    INT 21H  
    
    MOV AH,2H
    MOV DL,M1
    ADD DL,30H
    INT 21H

POP BX
RET
SHD ENDP

END MAIN

