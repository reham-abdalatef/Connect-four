          EXTRN sub_chatting:FAR
        EXTRN sub_playing:FAR  
        PUBLIC msg4, msg5, EnterChar,row ,column,temp1,temp2 ,r1  ,c1 , COL1 ,COL2 ,COL3 ,COL4 ,TIME 
	PUBLIC	Counter1 ,Counter2 ,Counter3 ,Counter4 ,ARRAY ,counter ,COLO1  ,COLO2   ,COLO11 
     PUBLIC  ROW11 ,COLOR ,P1COLOR ,P2COLOR ,PCOLOR ,PLAYER ,val ,CWIN ,player1 ,player2 ,count2,flag,MESDRAW
.MODEL large
.STACK 64
.DATA
       msg1 DB 'To Start chatting  Press C' ,'$'
	    msg2 DB 'To Start playing Game  Press P' ,'$'
		msg3 DB 'To End Program Press Esc' ,'$'
		  msg4 DB ' Start chatting  $' 
		    msg5 DB ' Start playing  $'
	      EnterChar DB 10, 13, '$' 
row    db    0
column db    0
temp1  db    ? 
temp2  db    ?
r1     db   12
c1     db    0
COL1 DB 0H,0H,0H,0H,0H
COL2 DW 0H,0H,0H,0H,0H
COL3 DW 0H,0H,0H,0H,0H
COL4 DW 0H,0H,0H,0H,0H
TIME DW 0H
Counter1 Dw 0H 
Counter2 DW 0H
Counter3 DW 0H
Counter4 DW 0H
ARRAY  DW 60H,0B6H,111H,16CH,1C7H 
counter db 2
COLO1  DW ?
COLO2    DW ? 
COLO11  DW ?
ROW11  DW ?
COLOR DB 02H
P1COLOR DB 04H
P2COLOR DB 07H
PCOLOR  DB ?
PLAYER DB 01h
val DB 02H
CWIN DB 0H
player1 dB "THE WINNER IS PLAYER ONE .", "$"
player2 dB "THE WINNER IS PLAYER TWO ." , "$"
count2 db ?
flag db ?
MESDRAW dB "THERE IS NO WINNER THE GAME IS DRAW." , "$"       
.CODE
MAIN PROC FAR
        Mov Ax,@DATA
        MOV DS,Ax
            
       ;***************Printing Messages***********
        mov ah,9
        mov dx, offset msg1
        int 21h
          ;----------------
         mov ah,9
        mov dx, offset EnterChar
        int 21h
          ;----------------
         
        
        mov ah,9
        mov dx,offset  msg2
        int 21h
         ;-------------------
      
             mov ah,9
        mov dx, offset EnterChar
        int 21h
       ;-------------------
		 mov ah,9
        mov dx,offset  msg3
        int 21h
	    ;-----------------------------------------------------------
	  AGAIN:   
      MOV AH , 01   ;LOOPS UNTIL A KEY IS PRESSED
      INT 16H
      JZ AGAIN  
      
	   MOV AH , 0
      INT 16H   
	               cmp aL,063h  ; press f1
	                je label1 
	                
	               cmp aL,070h  ; press f2
	                jE label2 
	                 
	               cmp aL,1bh  ; press Esc
	                jE Ending
	           JMP Ending      
	                
	    label1: call sub_chatting
	          jmp Ending
	        
	          
	                   
         label2:
            call sub_playing
	          jmp Ending
	        
	        
	          
	                
	    
        ;***************Ending***********
      Ending :
        MOV AH,4CH
        INT 21H ;GO BACK TO DOS
MAIN ENDP
 

  
 END MAIN 