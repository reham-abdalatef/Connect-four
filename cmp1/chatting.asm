 EXTRN msg4:BYTE
        EXTRN EnterChar:BYTE   
  EXTRN row :BYTE  
  EXTRN column:BYTE  
  EXTRN temp1:BYTE  
  EXTRN temp2 :BYTE  
  EXTRN r1  :BYTE  
  EXTRN c1    :BYTE  
        PUBLIC sub_chatting
.MODEL SMALL
.CODE
sub_chatting PROC  FAR
       push Ax   
       push bx
       push cx
       push dx 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
call initialization ;initilaize the serial port 
call cls            ;clear screen
call split          ;splitting the screen

Mn:

call setcur         ;update the cursor position
call checkkeypress  ;check if key pressed 
					;if key is present in buffer read it and display
call Receive        ;then check the revice buffer  
                    ;if not empty -read the charcter and displays it
jmp Mn
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

cls proc near
mov ax,0b800h
mov es,ax
mov ax,0720h
mov di,0
mov cx,2000
rep stosw 
ret
cls endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

split proc near
;upper
mov ah,06
mov al,0   ;NULL Character
mov bh,7   ;Attribute of upper screen

mov ch,0   ;upper left coordinates of upper screen(0,0)
mov cl,0

mov dh,11  ;lower right coordinates of upper screen(79,11)
mov dl,79
;lower
mov ah,06
mov al,0
mov bh,125 ;Attribute of lower screen
mov ch,12  ;upper left coordinates of lower screen(0,12)
mov cl,0
mov dh,24  ;lower right coordinates of lower screen(79,24)
mov dl,79
int 10h
ret
split endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

setcur proc near
mov ah,03
mov bh,0
int 10h
mov ah,02
mov dh,DS:[row]
mov dl,DS:[column]
int 10h
ret
setcur endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

setcur1 proc near
mov ah,03
mov bh,0
int 10h
mov ah,02
mov dh,DS:[r1]
mov dl,DS:[c1]
int 10h
ret
setcur1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

prnt proc near
mov ah,09           ;Function 9 =write char and attrib at [preset] cursor position
mov bl,07           ;attribute =7 [as we wrote in the upper screen ]
mov bh,0            ;page zero = current page display
mov al,DS:[temp1]   ;ACII of character 
mov cx,1            ;single char to be displayed
int 10h             
ret
prnt endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

prnt1 proc near
mov ah,09
mov bl,125
mov bh,0
mov al,DS:[temp2]
mov cx,1
int 10h
ret
prnt1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

scrllup proc near
mov ah,06      
mov al,1      ;scroll one line up
mov bh,7      ;attribute of upper screen
mov ch,0      ;upper left coordinates of upper screen(0,0)
mov cl,0
mov dh,11     ;lower right coordinates of upper screen(79,11)
mov dl,79
int 10h
ret
scrllup endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

scrllup1 proc near
mov ah,06
mov al,1         ;scroll one line up
mov bh,125       ;attribute of lower screen
mov ch,12        ;upper left coordinates of lower screen(0,12)
mov cl,0         
mov dh,24        ;lower right coordinates of lower screen(79,24)
mov dl,79
int 10h
ret
scrllup1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

initialization proc near

mov dx,3FBh            ;Address of line control register
mov al,10000000b       ;Data to be outputted on LCR =1000 0000 [To make DLAB=1]
Out dx,al              ;OUT DX,AL   Put Data on AL on the port of address DX

mov dx,3F8h            ;Divisor Latch Low [DLAB=1]
mov al,0Ch              
Out dx,al

mov dx,3F9h            ;Divisor Latch High [DLAB=0]
mov al,0
Out dx,al
;Divisor = 00 0C ; The Baud Rate =9600

mov dx,3FBh              ;Return to LCR
mov al,00011011b         ;Data =8 bit - 1 stop bit - even parity
Out dx,al

ret
initialization endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
movcur proc near
A:
inc DS:[column]
cmp DS:[column],80    
je D
jne exit

B:
mov DS:[column],0
inc DS:[row]
jmp exit

D:
cmp DS:[row],11
jne B

mov DS:[row],11
mov DS:[column],0
call scrllup
exit:
ret
movcur endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

movcur1 proc near
AA:
inc DS:[c1] 
cmp DS:[c1],80
je DE
jne exitt
BB:
mov DS:[c1],0
inc DS:[r1]
jmp exitt
DE:
cmp DS:[r1],24
jne BB
mov DS:[r1],24
mov DS:[c1],0
call scrllup1
exitt:
ret
movcur1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

checkkeypress proc near
mov ah,01      ;check the status of the keyboard buffer 
int 16h       
  
jz e           ;if ZF=1 No waiting characters in the buffer 

mov ah,0       ;read the character from the keyboard buffer 
int 16h
mov DS:[temp1],al
cmp al,27
je e1
call prnt      ;take temp1 and print it into the current cursor position 
call movcur    ;update the cursor position
call Send      
jmp e
e1:mov ax,4c00h ; exit program
int 21h

e:
ret
checkkeypress endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Receive proc near
mov dx,3FDh        ;Line status register
In al,dx

test al,00000001b ; Test if DR=1
jz ee             ;Jump if zero [DR=0] No data is ready to be picked up 

mov dx,3F8h       ;Read data from Receive buffer [3F8] into AL    
In al,dx

mov DS:[temp2],al ;Then move it to temp2
call setcur1
call prnt1
call movcur1
ee:
ret
Receive endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Send proc near
CheckSend:
mov dx,3FDh   ;Read the line status register`
In al,dx
test al,20h   ;test the THRE [Transmit hold register empty] 
jz CheckSend  ; if THRE=0 then loop until it = 1 [until the old data is sent
mov dx,3F8h     
mov al,DS:[temp1] ;mov temp1 [the data read from the user to THR]
Out dx,al
eee:
ret
Send endp


       
       pop dx 
       pop cx
       pop bx
       pop ax
        RET
sub_chatting ENDP
END
