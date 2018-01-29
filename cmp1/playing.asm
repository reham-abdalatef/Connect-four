    EXTRN msg5:BYTE
	EXTRN MESDRAW :BYTE
        EXTRN EnterChar:BYTE
		EXTRN  COL1 :BYTE
EXTRN  COL2 :WORD
EXTRN  COL3 :WORD
EXTRN  COL4 :WORD
EXTRN  TIME :WORD
EXTRN  Counter1 :WORD
EXTRN  Counter2:WORD
EXTRN Counter3 :WORD
EXTRN Counter4 :WORD
EXTRN ARRAY  :WORD
 EXTRN counter:BYTE
EXTRN COLO1 :WORD
EXTRN COLO2   :WORD
EXTRN COLO11 :WORD
EXTRN ROW11 :WORD
EXTRN COLOR :BYTE
EXTRN P1COLOR :BYTE
EXTRN P2COLOR :BYTE
EXTRN PCOLOR :BYTE
EXTRN PLAYER :BYTE
EXTRN val :BYTE
EXTRN CWIN :BYTE
EXTRN player1 :BYTE
EXTRN player2 :BYTE
EXTRN count2 :BYTE
EXTRN flag :BYTE
        PUBLIC sub_playing
Clear MACRO 
Push AX
MOV AX,0600H
MOV BH,07
MOV CX,0000
MOV DX ,184FH
INT 10
POP AX
ENDM


Drawlinehoz macro X1, Y1, W, color
Local	again
push cx
push dx
push ax
push bx

mov cx, X1
mov dx, Y1
mov al, color
mov ah, 0ch
mov bx, X1
add bx, W
again:	
int 10h
inc cx


cmp cx, bx
JNE again

pop bx
pop ax
pop dx
pop cx
endm Drawlinehoz

Drawlinever macro X1, Y1, W, color
Local	again
push cx
push dx
push ax
push bx

mov cx, X1
mov dx, Y1
mov al, color
mov ah, 0ch

again:	
int 10h
inc dx

mov bx, Y1
add bx, W

cmp dx, bx
JNE again

pop bx
pop ax
pop dx
pop cx
endm Drawlinever

.MODEL SMALL
.CODE
                   
 sub_playing PROC FAR
       push Ax   
       push bx
       push cx
       push dx 
     
      


     ;MOV AX,0600h 
    ; MOV BH,1fh   
    ; MOV CX,0000h  
    ; MOV DX,184Fh  
    ; INT 10h
     mov dx,3fbh 			; Line Control Register
    mov al,10000000b		;Set Divisor Latch Access Bit
     out dx,al			;Out it
                 ;Set LSB byte of the Baud Rate Divisor Latch register.
     mov dx,3f8h			
     mov al,0ch			
     out dx,al
;Set MSB byte of the Baud Rate Divisor Latch register.
     mov dx,3f9h
     mov al,00h
     out dx,al
;Set port configuration
     mov dx,3fbh
     mov al,00011011b
    out dx,al


    
	  mov ah,00
      mov al,13h
      int 10h
	  
	  
	 ; DRAW INTERFACE
     Drawlinehoz 00h, 90H,140h, COLOR
	 
	 Drawlinehoz 00h, 80H,140h, COLOR
	 
	 
	 Drawlinehoz 00h, 0B9H,140h, COLOR
  

  
  Drawlinever  30H, 15H, 6BH, COLOR
  Drawlinever  60H, 15H, 6BH, COLOR
  Drawlinever  90H, 15H, 6BH, COLOR
  Drawlinever  0C0H, 15H, 6BH, COLOR
  Drawlinever  0F0H, 15H, 6BH, COLOR

	 
	   Drawlinehoz 30h, 15H,0C0h, COLOR
	 Drawlinehoz 30h, 2AH,0C0h, COLOR
	  Drawlinehoz 30h, 3FH,0C0h, COLOR
	   Drawlinehoz 30h, 54H,0C0h, COLOR
	    Drawlinehoz 30h, 69H,0C0h, COLOR
	 
	
	 
        
     
	  ;DRAW THE  RECTANGLE
	   Drawlinehoz 06AH, 03H,17h, 01
	  Drawlinehoz 06AH, 12H,17h, 01
	  Drawlinever   06AH,03H, 10H, 01
	   Drawlinever   080H,03H, 10H, 01
	
	  
	  
      
      
 DOWN: 

  

; check who palyer ,player1 or palyer2
checkplayer:
	  ADD TIME,1
	  MOV AX,TIME
	  DIV val
	  CMP AH,1
	  JNE PLLL1
	  DEC TIME 
     
      AGAIN:   
      MOV AH , 01   ;LOOPS UNTIL A KEY IS PRESSED
      INT 16H
      JZ AGAIN  
      
      MOV AH , 0
      INT 16H 
      CMP AL,'R'
      JE labelright
      CMP AL,'r'
      JE labelright 
      CMP AL,'L'
      JE labelLEFT
      CMP AL,'l'
      JE labelLEFT 
      CMP AL,'D'
      JE labelDOWN
      CMP AL,'d'
      JE labelDOWN 
	  
      jmp AGAIN
      
      
     labelright: jmp right
     labelLEFT: jmp LEFT1  
     labelDOWN: jmp DOWN1
	 PLLL1: JMP APLLL1
     UP4: LOOP DOWN   
      
    RIGHT:
    ADD COUNTER , 1 
    CMP COUNTER , 2   ;the rectangle is IN THE 2ND SLOT
    JE SECOND
    CMP COUNTER , 3   ;the rectangle is IN THE 3D SLOT
    JE labelTHIRD
    CMP COUNTER , 4   ;the rectangle is IN THE FOURTH SLOT
    JE LABELFOURTH1 
    CMP COUNTER , 4   ;the rectangle is IN THE FOURTH SLOT
    JNC TT2
    JNC UP4
    
    TT2: 
    MOV COUNTER , 4
     JMP UP4
    SECOND:  ; 1- DRAW THE BLACK ONE , 2- DRAW THE NEW GREEN ONE.
     Drawlinehoz  3AH , 03h ,18h, 00h
	 Drawlinehoz  3AH , 12h,  18h, 00h
     
    JMP CON1
    LABELTHIRD: JMP THIRD
    LABELFOURTH1: JMP FOURTH1 
    LEFT1: JMP LEFT2
    DOWN1: JMP DOWN2
    UP3: JMP UP4  
    APLLL1: JMP APLLL2
  CON1:   
     Drawlinever  3AH, 03H, 10H, 00H
     Drawlinever  51H, 03H, 10H, 00H  
     
     Drawlinehoz  6AH, 03H ,18h, 01h
	 Drawlinehoz  6AH ,12h ,18h, 01h    
	 Drawlinever  6AH, 03H, 10H, 01H
     Drawlinever  80H, 03H, 10H, 01H  
      JMP UP2
    
    FOURTH1: JMP FOURTH2
     THIRD:
  Drawlinever  6AH, 03H, 10H, 00H
  Drawlinever  80H, 03H, 10H, 00H
      
      JMP CON2       
      FOURTH2: JMP FOURTH
      UP2: JMP UP3 
      LEFT2: JMP LEFT3
      DOWN2: JMP DOWN3
	  APLLL2: JMP APLLL3
  CON2:
      
     Drawlinehoz  6AH, 03H ,18h, 00h
     Drawlinehoz  6AH ,12h ,18h, 00h
    
     Drawlinehoz  9AH, 03H ,18h, 01h
	 Drawlinehoz  9AH ,12h ,18h, 01h    
	 Drawlinever  9AH, 03H, 10H, 01H
     Drawlinever  0B1H, 03H, 10H, 01H  
      JMP UP1 
      
      FOURTH:  
     Drawlinever  9AH,  03H, 10H, 00H
     Drawlinever  0B1H, 03H, 10H, 00H                    
      JMP CON3
      UP1: JMP UP2 
      LEFT3: jmp LEFT4
      DOWN3: JMP DOWN4
	   APLLL3: JMP APLLL4
  CON3:
         
     Drawlinehoz  9AH, 03H ,18h, 00h
	 Drawlinehoz  9AH ,12h ,18h, 00h
	  
     Drawlinehoz  0CAH, 03H ,18h, 01h
	 Drawlinehoz  0CAH ,12h ,18h, 01h    
	 Drawlinever  0CAH, 03H, 10H, 01H
     Drawlinever  0E1H, 03H, 10H, 01H  
      JMP END1 
      
    LEFT4:
    SUB COUNTER , 1
    CMP COUNTER , 3
    JE THIRD2
    CMP COUNTER , 2
    JE SECOND2
    CMP COUNTER , 1
    JE FIRST2
    CMP COUNTER , 0
    JE TT
    JMP END1
      
    TT: MOV COUNTER , 1
    JMP END1  
    THIRD2:
    Drawlinehoz  0CAH, 03H ,18h, 00h
	Drawlinehoz  0CAH ,12h ,18h, 00h    
	 
               
      JMP CON33
 SECOND2:   jmp second3
 FIRST2: JMP FIRST3 
 DOWN4: JMP DOWN5
 APLLL4: JMP PL2
  CON33:
     Drawlinever  0CAH, 03H, 10H, 00H
     Drawlinever  0E1H, 03H, 10H, 00H 
      
     Drawlinehoz  9AH, 03H ,18h, 01h
	 Drawlinehoz  9AH ,12h ,18h, 01h    
	 Drawlinever  9AH, 03H, 10H, 01H
     Drawlinever  0B1H, 03H, 10H, 01H  
      JMP END1   
      
    second3:
     Drawlinehoz  9AH, 03H ,18h, 00h
	 Drawlinehoz  9AH ,12h ,18h, 00h    
	
    JMP CON333
    FIRST3: JMP FIRST4
     
    CON333:
     Drawlinever  9AH, 03H, 10H, 00H
     Drawlinever  0B1H, 03H, 10H, 00H 
      
     Drawlinehoz  6AH, 03H ,18h, 01h
	 Drawlinehoz  6AH ,12h ,18h, 01h    
	 Drawlinever  6AH, 03H, 10H, 01H
     Drawlinever  80H, 03H, 10H, 01H    
      JMP END1  
      
    FIRST4:
     Drawlinehoz  6AH, 03H ,18h, 00h
	 Drawlinehoz  6AH ,12h ,18h, 00h    
	 
    JMP CON3333
    
    CON3333:
     Drawlinever  6AH, 03H, 10H, 00H
     Drawlinever  80H, 03H, 10H, 00H
     
     Drawlinehoz  3AH , 03h ,18h, 01h
	 Drawlinehoz  3AH , 12h,  18h, 01h    
	 Drawlinever  3AH, 03H, 10H, 01H
     Drawlinever  51H, 03H, 10H, 01H  
      JMP END1      
        
      PL1:

      mov dx , 3FDH		; Line Status Register
    AGAIN2:  	In al , dx 			;Read Line Status
 AND al , 00100000b
 JZ AGAIN2

send:

mov al,counter
  mov flag,al ; put the palce that player playing in it
	 
mov dx , 3F8H		; Transmit data register
  		mov  al, COUNTER ; palyer1 send place that palying in it to player2
  		out dx , al 

	  MOV AL,P1COLOR
	  MOV PCOLOR,AL
	  MOV PLAYER,1
	  JMP DDD
      PL2:
	  
  mov al,counter 
	 mov flag,al
	
      checkreceive:
      mov dx , 3FDH		; Line Status Register
	   CHK:	in al , dx 
  		AND al , 1
  		JZ CHK

receve:

     mov dx , 03F8H
    in al , dx 
     mov count2 , al
	   mov al,count2
	  mov counter,al ; palyer1 receve place that palyer2 palying in it
	  MOV AL,P2COLOR
	  MOV PCOLOR,AL
	  MOV PLAYER,2
	  JMP DDD2
	  
	  
      DOWN5:
	  ADD TIME,1
	  PUSH AX
	  MOV AX,TIME
	  DIV val
	  CMP AH,1; check who palying
	  JE PL1
	  ;JNE PL2
	  DDD:; palyer1
	  POP AX
	  ; compare where palyer playing 
      CMP COUNTER ,1
      JE F1 
      CMP COUNTER ,2
      JE F22
      CMP COUNTER ,3
      JE F33
      CMP COUNTER ,4
      JE F44
	  DDD2:;palyer2
      CMP count2 ,1
      JE F1 ;coloum 1
      CMP count2 ,2
      JE F22 ;coloum 2
      CMP count2 ,3
      JE F33 ;coloum 3
      CMP count2 ,4
      JE F44; coloum 4
	  
      F22:JMP F2
      F33: JMP F333
      F44: JMP F444
	  ;;;;;;;;;;;;;;;;	  
      F1:
	  MOV DI,OFFSET COL1
	  CMP COUNTER1,5 ; check if this coloum is full
	  JGE NOCHANGE1
	  PUSH DX
	  ADD COUNTER1,1
	  CMP COUNTER1,1
      JE MOM11 
	  CMP COUNTER1,2
      JE MOM12
	  CMP COUNTER1,3
      JE MOM13
	  CMP COUNTER1,4
      JE MOM14
	  CMP COUNTER1,5
      JE MOM15
	  
	  
	  NOCHANGE1:
	  DEC TIME
	  JMP END1
	  
	  
	  MOM11:
	  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI],AL ; put the number of player in this coloum
	  POP AX
	  MOV DX,6BH
	  JMP MOM111 ; draw rectangle
	  
	    MOM12:
		  PUSH AX
	      MOV AL,PLAYER
		MOV [DI+1],AL
		POP AX
	   MOV DX,56H
	   JMP MOM122
	   
	    MOM13:
		  PUSH AX
	  MOV AL,PLAYER
		MOV [DI+2],AL
		POP AX
	  MOV DX,41H
	  JMP MOM133
	  
	    MOM14:
		  PUSH AX
	  MOV AL,PLAYER
		MOV [DI+3],AL
		POP AX
	   MOV DX,2CH
	   JMP MOM144
	  
	    MOM15:
		  PUSH AX
	  MOV AL,PLAYER
		MOV [DI+4],AL
		POP AX
	   MOV DX,17H
	   JMP MOM155
	  
	  MOM111:
	  Drawlinehoz 32h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,7FH
	  JNE MOM111
	  POP DX
	  JMP CHECKK ; check if any player win
      ;JMP END1
	  
	 
	   MOM122:
	   Drawlinehoz 32h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,068H
	  JNE MOM122
	  POP DX
      JMP CHECKK
      ;JMP END1
	  
	  
	  
	MOM133:
      Drawlinehoz 32h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,053H
	  JNE MOM133
	  POP DX
	  JMP CHECKK
      ;JMP END1
	  
	
	   MOM144:
      Drawlinehoz 32h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,03EH
	  JNE MOM144
	  POP DX
	 JMP CHECKK
      ;JMP END1
      
	
	   MOM155:
      Drawlinehoz 32h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,029H
	  JNE MOM155
	  POP DX
	  JMP CHECKK
      ;JMP END1
	  
	  CHECKK:
     JMP CHECKK1

	  ;;;;;;;;;;;;;;;;	  
      F2:
	  MOV DI,OFFSET COL2
	  CMP COUNTER2,5
	  JGE NOCHANGE2
	  PUSH DX
	  ADD COUNTER2,1
	  CMP COUNTER2,1
      JE MOM21
	  CMP COUNTER2,2
      JE MOM22
	  CMP COUNTER2,3
      JE MOM23
	  CMP COUNTER2,4
      JE MOM24
	  CMP COUNTER2,5
      JE MOM25
	  
	  
	   NOCHANGE2:
	   DEC TIME
	   JMP END1
	  
	  
	  MOM21:
	   	  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI],AL
	  POP AX
	 MOV DX,6BH
	  JMP MOM211
	  
	    MOM22:
	 PUSH AX
	  MOV AL,PLAYER
	  MOV [DI+1],AL
	  POP AX
	   MOV DX,56H
	   JMP MOM222
	   
	    MOM23:
	  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI+2],AL
	  POP AX
	  MOV DX,41H
	  JMP MOM233
	  
	    MOM24:
	  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI+3],AL
	  POP AX
	   MOV DX,2CH
	   JMP MOM244
	  
	    MOM25:
	  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI+4],AL
	  POP AX
	   MOV DX,17H
	   JMP MOM255
	  
	  MOM211:
	  Drawlinehoz 62h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,7FH
	  JNE MOM211
	  POP DX
	   JMP CHECKK
     ; JMP END1
	  
	 
	   MOM222:
     Drawlinehoz 62h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,068H
	  JNE MOM222
	  POP DX
	   JMP CHECKK
      ;JMP END1
	  
	  
	  
	MOM233:
     Drawlinehoz 62h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,053H
	  JNE MOM233
	  POP DX
	   JMP CHECKK
      ;JMP END1
	  
	
	   MOM244:
     Drawlinehoz 62h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,03EH
	  JNE MOM244
	  POP DX
	   JMP CHECKK
      ;JMP END1
      
	
	   MOM255:
     Drawlinehoz 62h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,029H
	  JNE MOM255
	  POP DX
	   JMP CHECKK
      ;JMP END1
	  
	CHECKK1:
	JMP CHECKK2
	  ;;;;;;;;;;;;;;;;	  
 
      
      F444: JMP F4444
      F333:
	  	  MOV DI,OFFSET COL3
	  CMP COUNTER3,5
	  JGE NOCHANGE3
	  PUSH DX
	  ADD COUNTER3,1
	  CMP COUNTER3,1
      JE MOM31
	  CMP COUNTER3,2
      JE MOM32
	  CMP COUNTER3,3
      JE MOM33
	  CMP COUNTER3,4
      JE MOM34
	  CMP COUNTER3,5
      JE MOM35
	  
	  
	   NOCHANGE3:
	   DEC TIME
	   JMP END1
	  
	  
	  MOM31:
	  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI],AL
	  POP AX
	   MOV DX,6BH
	  JMP MOM311
	  
	    MOM32:
	  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI+1],AL
	  POP AX
	   MOV DX,56H
	   JMP MOM322
	   
	    MOM33:
		  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI+2],AL
	  POP AX
	  MOV DX,41H
	  JMP MOM333
	  
	    MOM34:  PUSH AX
	  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI+3],AL
	  POP AX
	   MOV DX,2CH
	   JMP MOM344
	  
	    MOM35:
		  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI+4],AL
	  POP AX
	   MOV DX,17H
	   JMP MOM355
	  
	  MOM311:
	  
	  Drawlinehoz 92h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,07EH
	  JNE MOM311
	  POP DX
	   JMP CHECKK2
      ;JMP END1
	  
	 
	   MOM322:
      Drawlinehoz 92h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,068H
	  JNE MOM322
	  POP DX
	   JMP CHECKK2
     ; JMP END1
	  
	  
	  
	MOM333:
      Drawlinehoz 92h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,053H
	  JNE MOM333
	  POP DX
	   JMP CHECKK2
      ;JMP END1
	  
	
	   MOM344:
      Drawlinehoz 92h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,03EH
	  JNE MOM344
	  POP DX
	   JMP CHECKK2
      ;JMP END1
      
	
	   MOM355:
      Drawlinehoz 92h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,029H
	  JNE MOM355
	  POP DX
	   JMP CHECKK2
     ; JMP END1
	  ;;;;;;;;;;;;;;;;	  
	  CHECKK2:
       JMP CHECKK3
      F4444:

	  	  MOV DI,OFFSET COL4
	  CMP COUNTER4,5
	  JGE NOCHANGE4
	  PUSH DX
	  ADD COUNTER4,1
	  CMP COUNTER4,1
      JE MOM41
	  CMP COUNTER4,2
      JE MOM42
	  CMP COUNTER4,3
      JE MOM43
	  CMP COUNTER4,4
      JE MOM44
	  CMP COUNTER4,5
      JE MOM45
	  
	  
	   NOCHANGE4:
	   DEC TIME
	   JMP END1
	  
	  
	  MOM41:
	  	  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI],AL
	  POP AX
	  MOV DX,6BH
	  JMP MOM411
	  
	    MOM42:
		  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI+1],AL
	  POP AX
	   MOV DX,56H
	   JMP MOM422
	   
	    MOM43:
		  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI+2],AL
	  POP AX
	  MOV DX,41H
	  JMP MOM433
	  
	    MOM44:
		  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI+3],AL
	  POP AX
	   MOV DX,2CH
	   JMP MOM444
	  
	    MOM45:
		  PUSH AX
	  MOV AL,PLAYER
	  MOV [DI+4],AL
	  POP AX
	   MOV DX,17H
	   JMP MOM455
	  
	  MOM411:
	  Drawlinehoz 0C2h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,07EH
	  JNE MOM411
	  POP DX
	   JMP CHECKK3
      ;JMP END1
	  
	 
	   MOM422:
       Drawlinehoz 0C2h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,068H
	  JNE MOM422
	  POP DX
	   JMP CHECKK3
      ;JMP END1
	  
	  
	  
	MOM433:
       Drawlinehoz 0C2h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,052H
	  JNE MOM433
	  POP DX
	   JMP CHECKK3
      ;JMP END1
	  
	
	   MOM444:
        Drawlinehoz 0C2h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,03EH
	  JNE MOM444
	  POP DX
	   JMP CHECKK3
      ;JMP END1
      
	
	   MOM455:
       Drawlinehoz 0C2h, DX,2Dh, PCOLOR
	  INC DX
	  CMP DX,029H
	  JNE MOM455
	  POP DX
	   JMP CHECKK3
      ;JMP END1
;;;;;;;;;;;;;;;;	  
    
      JMP END1
        
	CHECKK3:
	cmp TIME,6 ; no one can win if time of playing less than 7
	JG checkver
	 
      
      END1:
	  JMP UP1
	  
checkver: ; check if palyer win vertical in last place that palyer playing in it
PUSH BX
PUSH CX
MOV CWIN,0H
MOV BL,PLAYER
CMP counter,1
JE COLL1v
CMP counter,2
JE COLLL2v
CMP counter,3
JE COLLL3v
CMP counter,4
JE COLLL4v

COLLL2v:
JMP COLL2v

COLL1v: ;two case to win vertical in one coloum
MOV CWIN,00H
MOV SI,OFFSET COL1
CMP [SI] ,BL
JNE ELSE1
ADD CWIN,01H
CMP [SI+1] ,BL
JNE ELSE1
ADD CWIN,01H
CMP [SI+2] ,BL
JNE ELSE1
ADD CWIN,01H
CMP [SI+3] ,BL
JNE ELSE1
ADD CWIN,01H

CMP CWIN,04H
JE KKv1

COLLL3V:
JMP  COLL3v
COLLL4v:
JMP COLL4v

ELSE1:
MOV CWIN,00H
CMP [SI+1] ,BL
JNE LP
ADD CWIN,01H
CMP [SI+2] ,BL
JNE LP
ADD CWIN,01H
CMP [SI+3] ,BL
JNE LP
ADD CWIN,01H
CMP [SI+4] ,BL
JNE LP
ADD CWIN,01H

CMP CWIN,04H
JE KKv1 ; if palyer win 

KKV1:
JMP KKV2

LP:
JMP checkhor


COLL2v:

MOV CWIN,00H
MOV SI,OFFSET COL2
CMP [SI] ,BL
JNE ELSE2
ADD CWIN,01H
CMP [SI+1] ,BL
JNE ELSE2
ADD CWIN,01H
CMP [SI+2] ,BL
JNE ELSE2
ADD CWIN,01H
CMP [SI+3] ,BL
JNE ELSE2
ADD CWIN,01H

CMP CWIN,04H
JE KKv2

ELSE2:
MOV CWIN,00H
CMP [SI+1] ,BL
JNE LP2
ADD CWIN,01H
CMP [SI+2] ,BL
JNE LP2
ADD CWIN,01H
CMP [SI+3] ,BL
JNE LP2
ADD CWIN,01H
CMP [SI+4] ,BL
JNE LP2
ADD CWIN,01H
CMP CWIN,04H
JE KKv2
LP2:
JMP checkhor

KKV2:
JMP KKV

COLL3v:

MOV CWIN,00H
MOV SI,OFFSET COL3
CMP [SI] ,BL
JNE ELSE3
ADD CWIN,01H
CMP [SI+1] ,BL
JNE ELSE3
ADD CWIN,01H
CMP [SI+2] ,BL
JNE ELSE3
ADD CWIN,01H
CMP [SI+3] ,BL
JNE ELSE3
ADD CWIN,01H

CMP CWIN,04H
JE KKv3

ELSE3:
MOV CWIN,00H
CMP [SI+1] ,BL
JNE LP3
ADD CWIN,01H
CMP [SI+2] ,BL
JNE LP3
ADD CWIN,01H
CMP [SI+3] ,BL
JNE LP3
ADD CWIN,01H
CMP [SI+4] ,BL
JNE LP3
ADD CWIN,01H
CMP CWIN,04H
JE KKv3
LP3:
JMP checkhor

KKV3:
JMP KKV

COLL4v:

MOV CWIN,00H
MOV SI,OFFSET COL4
CMP [SI] ,BL
JNE ELSE4
ADD CWIN,01H
CMP [SI+1] ,BL
JNE ELSE4
ADD CWIN,01H
CMP [SI+2] ,BL
JNE ELSE4
ADD CWIN,01H
CMP [SI+3] ,BL
JNE ELSE4
ADD CWIN,01H

CMP CWIN,04H
JE KKv4

ELSE4:
MOV CWIN,00H
CMP [SI+1] ,BL
JNE LP4
ADD CWIN,01H
CMP [SI+2] ,BL
JNE LP4
ADD CWIN,01H
CMP [SI+3] ,BL
JNE LP4
ADD CWIN,01H
CMP [SI+4] ,BL
JNE LP4
ADD CWIN,01H
CMP CWIN,04H
JE KKv4

LP4:
JMP checkhor ; if no one win in vertical .. check if any palyer win in horizental

KKV4:
JMP KKV



KKv: ; if any player win
Drawlinehoz 02h, 0B9H,140h, 01h
mov dl, player 
cmp dl , 01h
je player11
cmp dl , 02h
je player22
;;;;; write the code for player 2
; INTERUPET ELY BY MOVE EL CUROSER
; INTERUPT ELY BE PRINT STRING
 
player11:
; INTERUPET ELY BY MOVE EL CUROSER
mov dh, 10h
mov dl, 28h
mov bh, 0
mov ah, 2
int 10h
; INTERUPT ELY BE PRINT STRING
 mov dx, offset player1
mov ah, 9
int 21h
JMP END5ALES
player22:
; INTERUPET ELY BY MOVE EL CUROSER
mov dh, 10h
mov dl, 28h
mov bh, 0
mov ah, 2
int 10h
; INTERUPT ELY BE PRINT STRING
mov dx, offset player2
mov ah, 9
int 21h
JMP END5ALES

checkhor:
PUSH BX
PUSH DX
MOV CWIN,00H
MOV BL,PLAYER
; check where the last player palying
CMP counter,1 
JE CHCOL1
CMP counter,2
JE CHCOL2
CMP counter,3
JE CHCOL3
CMP counter,4
JE CHCOL4

END4: JMP END3

CHCOL1:
MOV DX,COUNTER1 ; that row the last player playing in it
CMP DX,01H
JE row1h11
CMP DX,02H
JE row2h11
CMP DX,03H
JE row3h11
CMP DX,04H
JE row4h11
CMP DX,05H
JE row5h11

CHCOL2:
MOV DX,COUNTER2
CMP DX,01H
JE row1h11
CMP DX,02H
JE row2h11
CMP DX,03H
JE row3h11
CMP DX,04H
JE row4h11
CMP DX,05H
JE row5h11
END5: JMP END4
END5ALES: JMP END5ALES1
CHCOL3:
MOV DX,COUNTER3
CMP DX,01H
JE row1h11
CMP DX,02H
JE row2h11
CMP DX,03H
JE row3h11
CMP DX,04H
JE row4h11
CMP DX,05H
JE row5h11

ROW1H11: JMP ROW1H1
ROW2H11: JMP ROW2H1
ROW3H11: JMP ROW3H1
ROW4H11: JMP ROW4H1
ROW5H11: JMP ROW5H1

CHCOL4:
MOV DX,COUNTER4
CMP DX,01H
JE row1h11
CMP DX,02H
JE row2h11
CMP DX,03H
JE row3h11
CMP DX,04H
JE row4h11
CMP DX,05H
JE row5h11




row1h:
MOV SI,OFFSET COL1
add SI,00H
CMP [si],BL
JNE diagonal2 ; if one of this row is not equal player number .. check diagonal
ADD CWIN,01H
MOV SI,OFFSET COL2
add SI,00H
CMP [SI],BL
JNE diagonal2
ADD CWIN,01H
MOV SI,OFFSET COL3
add SI,00H
CMP [SI],BL
JNE diagonal2
ADD CWIN,01H
MOV SI,OFFSET COL4
add SI,00H
CMP [SI] ,BL
JNE diagonal2
ADD CWIN,01H

cmp CWIN,04H
JE  KKv5
ROW1H1: JMP ROW1H
ROW2H1: JMP ROW2H
ROW3H1: JMP ROW3H
ROW4H1: JMP ROW4H
ROW5H1: JMP ROW5H
diagonal2: jmp diagonal1
END5ALES1: JMP END5ALES2
row2h:

MOV SI,OFFSET COL1
add SI,01H
CMP [si],BL
JNE diagonal1
ADD CWIN,01H
MOV SI,OFFSET COL2
add SI,01H
CMP [SI],BL
JNE diagonal1
ADD CWIN,01H
MOV SI,OFFSET COL3
add SI,01H
CMP [SI],BL
JNE diagonal1
ADD CWIN,01H
MOV SI,OFFSET COL4
add SI,01H
CMP [SI] ,BL
JNE diagonal1
ADD CWIN,01H

cmp CWIN,04H
JE  KKv5

END3:
JMP END1
diagonal1: jmp diagonal
END5ALES2: JMP END5ALES3
KKV5:
JMP KKV3
row3h:

MOV SI,OFFSET COL1
add SI,02H
CMP [si],BL
JNE diagonal
ADD CWIN,01H
MOV SI,OFFSET COL2
add SI,02H
CMP [SI],BL
JNE diagonal
ADD CWIN,01H
MOV SI,OFFSET COL3
add SI,02H
CMP [SI],BL
JNE diagonal
ADD CWIN,01H
MOV SI,OFFSET COL4
add SI,02H
CMP [SI] ,BL
JNE diagonal
ADD CWIN,01H

cmp CWIN,04H
JE  KKv5
KKV6: JMP KKV5
KKV7: JMP KKV6
END5ALES3: JMP END5ALES4
diagonal : jmp checkdia
row4h:

MOV SI,OFFSET COL1
add SI,03H
CMP [si],BL
JNE checkdia1
ADD CWIN,01H
MOV SI,OFFSET COL2
add SI,03H
CMP [SI],BL
JNE checkdia1
ADD CWIN,01H
MOV SI,OFFSET COL3
add SI,03H
CMP [SI],BL
JNE checkdia1
ADD CWIN,01H
MOV SI,OFFSET COL4
add SI,03H
CMP [SI] ,BL
JNE checkdia1
ADD CWIN,01H

cmp CWIN,04H
JE  KKv6
KKV71: JMP KKV7
checkdia1: jmp checkdia
row5h:

MOV SI,OFFSET COL1
add SI,04H
CMP [si],BL
JNE checkdia
ADD CWIN,01H
MOV SI,OFFSET COL2
add SI,04H
CMP [SI],BL
JNE checkdia
ADD CWIN,01H
MOV SI,OFFSET COL3
add SI,04H
CMP [SI],BL
JNE checkdia
ADD CWIN,01H
MOV SI,OFFSET COL4
add SI,04H
CMP [SI] ,BL
JNE checkdia
ADD CWIN,01H

cmp CWIN,04H
JE  KKv71
END6:JMP END3
END5ALES4: JMP END5ALES5
checkdia: ;check if any winner by diagonal
push ax
mov al,flag
mov counter,al 
pop ax
push Dx
push Bx
CASE1: ; there is 4 case that palyer can win by diagonal 
MOV CWIN,00H
MOV SI,OFFSET COL1
MOV BL,[SI]
CMP BL,00H
JE CASE2
ADD CWIN,01H
MOV SI,OFFSET COL2
CMP [SI+1],BL
JNE CASE2
ADD CWIN,01H
MOV SI,OFFSET COL3
CMP [SI+2],BL
JNE CASE2
ADD CWIN,01H
MOV SI,OFFSET COL4
CMP [SI+3],BL
JNE CASE2
ADD CWIN,01H
CMP CWIN,04H
JE KKV711

KKV711:JMP KKV71
CASE2:
MOV CWIN,00H
MOV SI,OFFSET COL4
MOV BL,[SI]
CMP BL,00H
JE CASE3
ADD CWIN,01H
MOV SI,OFFSET COL3
CMP [SI+1],BL
JNE CASE3
ADD CWIN,01H
MOV SI,OFFSET COL2
CMP [SI+2],BL
JNE CASE3
ADD CWIN,01H
MOV SI,OFFSET COL1
CMP [SI+3],BL
JNE CASE3
ADD CWIN,01H
CMP CWIN,04H
JE KKV711
END8: JMP END6
KKV721: JMP KKV711
END5ALES5: JMP END5ALES6
CASE3:
MOV CWIN,00H
MOV SI,OFFSET COL1
MOV BL,[SI+1]
CMP BL,00H
JE CASE4
ADD CWIN,01H
MOV SI,OFFSET COL2
CMP [SI+2],BL
JNE CASE4
ADD CWIN,01H
MOV SI,OFFSET COL3
CMP [SI+3],BL
JNE CASE4
ADD CWIN,01H
MOV SI,OFFSET COL4
CMP [SI+4],BL
JNE CASE4
ADD CWIN,01H
CMP CWIN,04H
JE KKV721
END7: JMP END8
KKV7211: JMP KKV721
CASE4:
MOV CWIN,00H
MOV SI,OFFSET COL4
MOV BL,[SI+1]
CMP BL,00H
JE CASE5
ADD CWIN,01H
MOV SI,OFFSET COL3
CMP [SI+2],BL
JNE CASE5
ADD CWIN,01H
MOV SI,OFFSET COL2
CMP [SI+3],BL
JNE CASE5
ADD CWIN,01H
MOV SI,OFFSET COL1
CMP [SI+4],BL
JNE CASE5
ADD CWIN,01H
CMP CWIN,04H
JE KKV7211
END5ALES6: JMP END5ALES7
CASE5:
JMP END2 ; if no case to win 

EN1v:
POP CX
POP BX
jmp END2
  END2:
  cmp COUNTER1,5
 JNE END7
 cmp COUNTER2,5
 JNE END7
 cmp COUNTER3,5
 JNE END7
 cmp COUNTER4,5
 JNE END7
 JMP Draw
	
Draw: 
; INTERUPET ELY BY MOVE EL CUROSER
mov dh, 10h
mov dl, 28h
mov bh, 0
mov ah, 2
int 10h
; INTERUPT ELY BE PRINT STRING
 mov dx, offset MESDRAW
mov ah, 9
int 21h
JMP END5ALES7

	  
	  END5ALES7:
       pop dx 
       pop cx
       pop bx
       pop ax
        RET
sub_playing ENDP
END
