DECIMAL MACRO DATA
    MOV AL, 02
    MOV DX, DATA
    OR DL, 30H
    INT 21H
ENDM

DISPCHAR MACRO CHAR
    MOV AH, 02
    MOV DL, CHAR
    INT 21H
ENDM

CLRSCR MACRO
    MOV AX,0600H
    MOV BH, 7
    MOV CX,0000
    MOV DX,184FH
    INT 10H
    ENDM

GETKEY MACRO
    MOV AH, 01H
   INT 16H
ENDM

GETMOUSE MACRO
    XOR BL, BL
    MOV AX, 3
    INT 33H
ENDM

CURSOR MACRO ROW, COL 
    XOR BX, BX
    MOV AH, 02
    MOV BL, 00
    MOV DH, ROW
    MOV DL, COL
    INT 10H
ENDM

CLEAR MACRO
    XOR BX, BX
    MOV AX, 0600H
    MOV BH, 07
    MOV CX, 0000
    MOV DX, 184FH
    INT 10H
ENDM

CLEARBOTTOM MACRO
    XOR BX, BX
    MOV AX,0600H
    MOV BH,6
    MOV CX,1800
    MOV DX,1847
    INT 10H
ENDM    

MSGDISPLAY MACRO MES
    MOV AH, 09
    MOV DX, OFFSET MES
    INT 21H
ENDM
; ***start of the main program
.MODEL SMALL
.STACK 64H
.DATA
     USERMESSAGE1 DB 'semih turk   -- 140079$'
     USERMESSAGE2 DB 'seckin guzel -- 140073$'
     MESSAGE1 DB 'increase speed with right click U$'
     MESSAGE2 DB 'decrease speed with left click D$'
     MESSAGE3 DB 'right f CLOCKSWISE$'
     MESSAGE4 DB 'left  R ANTICLOCKWISE$'
     MESSAGE5 DB 'quit the program with Q$'
     MSGUP DB 'increased$'
     MSGDOWN DB 'decreased$'
     MSGRIGHT DB 'right', '$'
     MSGLEFT DB 'left', '$'     
     SPEED DW ?
     DIR DB ?
     ROTATING DB 01100110B

.CODE 
MAIN:
         MOV AX,@DATA
         MOV DS,AX
         CLRSCR
         
         MOV AH,09H
         MOV BL,3
         MOV CX, 11
         INT 10H
   ; displaying messages on screen
         MOV DIR, 1
         MOV SPEED, 0
         CURSOR 02H, 1DH
         MSGDISPLAY USERMESSAGE1
         CURSOR 03H, 1DH
         MSGDISPLAY USERMESSAGE2
         CURSOR 08H, 1DH
         MSGDISPLAY MESSAGE1
         CURSOR 09H, 1DH
         MSGDISPLAY MESSAGE2
         CURSOR 0AH, 1DH
         MSGDISPLAY MESSAGE3
         CURSOR 0BH, 1DH
         MSGDISPLAY MESSAGE4
         CURSOR 0CH, 1DH
         MSGDISPLAY MESSAGE5
         CURSOR 19,30
         DECIMAL SPEED
    
START:  
        CMP DIR, 1
        JE MOUSEKEY1
        JB LEFT 
RIGHT:  
         ROR ROTATING, 1
         MOV AL, ROTATING
         MOV CL, 4
         SHL AL, CL
         MOV CL, AL
         MOV AX, SPEED
         OR AL, CL
         MOV DX, 0378H
         OUT DX, AL
         CALL delay
         JMP MOUSEKEY1
LEFT:
         ROL ROTATING, 1
         MOV AL, ROTATING
         MOV CL, 4
         SHL AL, CL
         MOV CL, AL
         MOV AX, SPEED
         OR AL, CL
         MOV DX, 0378H
         OUT DX, AL
         CALL delay
MOUSEKEY1: 
         GETMOUSE
         CMP BX, 1
         JE SPEEDUP
         JA decrease        
         MOV AH, 01H
         INT 16H
         JZ START                  
         MOV AH, 00H
         INT 16H         
         CMP AL, 'U'
         JE mouseleft
         CMP AL,  'u'
         JE mouseleft
         CMP AL, 'D'
         JE mouseright
         CMP AL, 'd'
         JE mouseright
         CMP AL, 'Q'
         JE EXIT1
         CMP AL, 'q'
         JE EXIT1
         JB MOUSEKEY1
         
decrease:    	 JMP slowing
mouseright:           JMP rotateright         
SPEEDUP:
         INC SPEED
         CMP SPEED, 11
         JE uplimit
         MOV AX,SPEED         
         MOV DX,0378H
         OUT DX,AL
         CLEARBOTTOM
         CURSOR 19,15
         MSGDISPLAY MSGUP
         CURSOR 19,30
         DECIMAL SPEED
         JMP START
exit1:   JMP EXIT
mouseleft:  JMP rotateleft
downlimit:
         MOV SPEED, 0
         CLEARBOTTOM               
         JMP START
uplimit:
         MOV SPEED, 10        
         CLEARBOTTOM        
         CURSOR 19,30
         DECIMAL SPEED         
         JMP START
slowing:
         DEC SPEED
         CMP SPEED, 11111111B
         JE downlimit
         MOV AX,SPEED         
         MOV DX,0378H
         OUT DX,AL           
         CLEARBOTTOM
         CURSOR 19,15
         MSGDISPLAY MSGDOWN
         CURSOR 19,30
         DECIMAL SPEED    
         JMP START
rotateright:
         MOV DIR, 2
         CLEARBOTTOM
         CURSOR 19, 45
         MSGDISPLAY MSGRIGHT
         JMP START
rotateleft:
         MOV DIR, 0
         CLEARBOTTOM
         CURSOR 19, 45
         MSGDISPLAY MSGLEFT
         JMP START 
delay:  
    CMP SPEED,0
    JNE next1
    MOV CX,2 
    JMP STOP
next1:  CMP SPEED,1
	JNE next2
        MOV CX,5264
	JMP STOP
next2:  CMP SPEED,2
	JNE next3
	MOV CX,12486
	JMP STOP
next3:  CMP SPEED,3
	JNE next4
	MOV CX,20564
	JMP STOP
next4:  CMP SPEED,4
	JNE next5
	MOV CX, 30516
	JMP STOP
next5:  CMP SPEED,5
	JNE next6
	MOV CX,38266
	JMP STOP
next6:  CMP SPEED,6
	JNE next7
	MOV CX,46774 
	JMP STOP
next7:  CMP SPEED,7
	JNE next8
	MOV CX,48266
	JMP STOP
next8:  CMP SPEED,8
		JNE next9
		MOV CX,50403 
		JMP STOP
next9:  CMP SPEED,9
	JNE next10
	MOV CX,52266
	JMP STOP

next10: CMP SPEED,10
		MOV CX,64032 
STOP:
		CALL waitdelay
		RET

waitdelay:  PUSH AX

waitdelay1:
		IN  AL,61H
		AND AL,10H
		CMP AL,AH
		JE  waitdelay1
		MOV AH,AL
		LOOP waitdelay1
		POP AX
		RET
		SUB CX,CX
		RET    
EXIT:               
        MOV AH, 4CH
        INT 21H    
        END MAIN 
