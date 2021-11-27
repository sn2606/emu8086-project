.model small 
.stack 1000h 
.data
    
    subject db 10,13,'MICROPORCESSOR AND INTERFACING $'
    
    course db 10,13,'CSE2006 $'
    
    heading db 10,13,  'BANK MANAGEMENT SYSTEM: ADMIN INTERFACE $'
        
    exitmsg db 10,13, 'SYSTEM CLOSED! $'
    
    createmsg db 10,13, 'INSERT NEW USER $'

    pinmsg db 10,13,'SEARCH ACCOUNTS BY PINCODE $'

    citymsg db 10,13, 'SEARCH ACCOUNTS BY CITY $'

    statemsg db 10,13, 'SEARCH ACCOUNTS BY STATE $'
    
    usermsg db 10,13, 'TOTAL NUMBER OF USERS IN THE SYSTEM $'

    mainmsg0 db 10,13,'0. Exit$'                         
    mainmsg1 db 10,13,'1. Insert New User$'
    mainmsg2 db 10,13,'2. Search Accounts by Pincode$'
    mainmsg3 db 10,13,'3. Search Accounts by City$'
    mainmsg4 db 10,13,'4. Search Accounts by State$'
    mainmsg5 db 10,13,'5. Total number of users$'
    mainmsg7 db 10,13,'Press Enter to return to main menu $'

    detailmsg1 db 10,13, 'Admin Username : $'
    detailmsg2 db 10, 13, 'Admin Password : $'
    
    pinmsg1 db 10,13, 'Enter Pincode you want to search : $'
    citymsg1 db 10,13, 'Enter City you want to search : $' 
    statemsg1 db 10,13, 'Enter State you want to search : $' 
    usermsg1 db 10,13, 'The number of users are : $' 

    inputmsg db 'Choose an option >>  $'
    inputCode db ? 

    accountName db 20 dup('$')
    accountPIN db 20 dup('$')
    accountPhone db 20 dup('$')
    accountCity db 20 dup('$')
    accountState db 20 dup('$')
    accountPinCode db 20 dup('$')
    selectedPinCode db 20 dup('$')
    selectedCity db 20 dup('$')
    selectedState db 20 dup('$')
    countUsers dw 0
    inputAmountOption db ? 
    resetDone db 10,13,'Account has been reset. $'

    create1 db 10,13,'1. Enter User Account Name : $'
    create2 db 10,13,'2. Enter User Account Pin :  $'
    create5 db 10,13,'3. Enter User Phone No. :  $'
    create6 db 10,13,'4. Enter User City :  $'
    create7 db 10,13,'5. Enter User State :  $'
    create8 db 10,13,'6. Enter User Address Pincode :  $'
    create3 db 10,13,'Account Created. $'
    create4 db 10,13,'Press Enter to Confirm. $' 

    pinMsgAuth db 10,13,'Enter Pin >> $'

    blank db 10,13,'>>  $'   ;for input blinker
    blank2 db 10,13, '    $' ;For Newline

    modAccMsg1 db 10,13,'1. New Account Name ( Old: $'
    modAccMsg2 db ' ) : >> $'
    modPinMsg1 db 10,13,'2. New Account Pin ( Old: $' 
    modPinMsg2 db ' ) : >>$' 
    modSuccess db 10,13,'Account Details Updated. $' 
    
    filename  db "..\..\Users\S K Nayak\Documents\CSE2006 Project\admin\users.txt", 0
    handle    dw ?
    hellomsg   db 10, "hello world$"
    buffer    db 10 dup(?)
    msg_open  db 10, 13, "Error opening file!$"
    msg_seek  db 10, 13, "Error seeking file!$"
    msg_write db 10, 13, "Error writing file!$"
    msg_close db 10, 13, "Error closing file!$"
    new_line db 10, 13 
    cha db ?

.code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;                                                                   ;
;                           U T I L I T Y                           ;
;                         F U N C T I O N S                         ;
;                                                                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
insert proc
   mov ah, 3dh
   mov al, 2
   lea dx, filename
   int 21h
   jc err_open

   mov handle, ax

   mov bx, ax
   mov ah, 42h  ; "lseek"
   mov al, 2    ; position relative to end of file
   mov cx, 0    ; offset MSW
   mov dx, 0    ; offset LSW
   int 21h
   jc err_seek

   mov bx, handle
   lea dx, new_line
   mov cx, 2
   mov ah, 40h
   int 21h
   lea dx, accountName
   mov cx, 20
   mov ah, 40h
   int 21h ; write to file...
   lea dx, accountPin
   mov cx, 20
   mov ah, 40h
   int 21h ; write to file...
   lea dx, accountPhone
   mov cx, 20
   mov ah, 40h
   int 21h ; write to file...
   lea dx, accountCity
   mov cx, 20
   mov ah, 40h
   int 21h ; write to file...
   lea dx, accountState
   mov cx, 20
   mov ah, 40h
   int 21h ; write to file...
   lea dx, accountPinCode
   mov cx, 20
   mov ah, 40h
   int 21h ; write to file...
   jc err_write

   mov bx, handle
   mov ah, 3eh
   int 21h ; close file...
   jc err_close

err_open:
   lea dx, msg_open
   jmp error

err_seek:   
   lea dx, msg_seek
   jmp error

err_write:
   lea dx, msg_write
   jmp error

err_close:
   lea dx, msg_close
   jmp error

error:
   ;mov ah, 09h
   ;int 21h
ret
endp insert


macro printString str 
    lea dx, str
    mov ah, 09h
    ; mov dx, offset str 
    int 21h 
endm 

displaySub proc near 
    printString subject
    printString blank2
    printString course
    printString blank2

    ret
displaySub endp

displayHeading proc near 
    printString heading
    printString blank2
    ret 
displayHeading endp

displayinputMenu proc near
    printString mainmsg0
    printString mainmsg1
    printString mainmsg2
    printString mainmsg3
    printString mainmsg4
    printString mainmsg5
    printString mainmsg7
    printString blank2 
    ret
displayinputMenu endp 

inputMenu proc near 
    printString inputmsg 
    printString blank
    mov ah, 1
    int 21h 
    mov inputCode, al 
    ret 
inputMenu endp 

displayBye proc near  
    printString exitmsg
    printString blank2
    ret 
displayBye endp


waiting proc near 
    mov cx, 0fh
    mov dx, 4240h
    mov ah, 86h
    int 15h
waiting endp

clearScreen proc near
    printString blank2
    printString blank2
    ret    
clearScreen endp


; ##############################################################################################################################
; ##############################################################################################################################
; INSERT NEW USER
; ##############################################################################################################################
; ##############################################################################################################################


macro account_name str 
    mov si, offset str 
    input: 
        mov ah, 1
        int 21h 
        cmp al, 13 
        je create_pin
        mov [si], al 
        inc si 
        jmp input 
    exitMac:
        ret 
endm 

macro account_pin str 
    mov si, offset str 
    input2: 
        mov ah, 1
        int 21h
        cmp al, 13 
        je create_phone 
        mov [si], al 
        inc si 
        jmp input2 
    exitMac2:
        ret 
endm 

macro account_phone str 
    mov si, offset str 
    input3: 
        mov ah, 1
        int 21h
        cmp al, 13 
        je create_city 
        mov [si], al 
        inc si 
        jmp input3 
    exitMac3:
        ret 
endm

macro account_city str 
    mov si, offset str 
    input4: 
        mov ah, 1
        int 21h
        cmp al, 13 
        je create_state
        mov [si], al 
        inc si 
        jmp input4 
    exitMac4:
        ret 
endm

macro account_state str 
    mov si, offset str 
    input5: 
        mov ah, 1
        int 21h
        cmp al, 13 
        je create_pincode 
        mov [si], al 
        inc si 
        jmp input5 
    exitMac5:
        ret 
endm

macro account_pincode str 
    mov si, offset str 
    input6: 
        mov ah, 1
        int 21h
        cmp al, 13 
        je account_created 
        mov [si], al 
        inc si 
        jmp input6 
    exitMac6:
        ret 
endm

; Enter to continue
proc etc
   etcin:
      mov ah,1
      int 21h
      cmp al,13
      je mainloop
      jmp etcin
   ret 
etc endp

create_account proc 
    call clearScreen 
    printString createmsg
    
    printString blank2
    printString create1
    printString blank
    account_name accountName
        

    create_pin: 
        printString create2 
        printString blank 
        account_pin accountPIN
        
    create_phone: 
        printString create5 
        printString blank 
        account_phone accountPhone
    
    create_city: 
        printString create6 
        printString blank 
        account_city accountCity
    
    create_state: 
        printString create7 
        printString blank 
        account_state accountState
        
    create_pincode: 
        printString create8 
        printString blank 
        account_pincode accountPinCode
    
    account_created: 
        printString create4
        printString create3
        call insert 
        call etc

    ret
create_account endp 


clearkeyboardbuffer	proc near
    clearin:
        mov ah, 1   ; peek
        int 16h
        jz  NoKey
        mov ah, 0   ; get
        int 16h    
        jmp clearin:
    NoKey:
        ret
clearkeyboardbuffer	 endp 

; ##############################################################################################################################
; ##############################################################################################################################
; SEARCH BY PINCODE
; ##############################################################################################################################
; ##############################################################################################################################

macro get_pincode str
    mov si, offset str 
    inputpin: 
        mov ah, 1
        int 21h
        cmp al, 13 
        je read_from_file 
        mov [si], al 
        inc si 
        jmp inputpin 
    exitMacpin:
        ret 
endm 


macro read_str str
    lea dx,str	 ; Offset of text to be read to in memory
    mov bx,handle; Store handle of file in BX
	mov cx,20	 ; Number of bytes to read
	mov ah,3fh	 ; Read file
	int 21h
	jc myexit	 ; Exit if error occurs. 
endm   


search_pincode proc
    call clearScreen 
    printString pinmsg
    
    printString blank2
    printString pinmsg1
    printString blank
    get_pincode selectedPinCode
    
    mov countUsers,0

read_from_file:  
    
    lea dx,filename	; Offset of file name
    mov al,00h	    ; Open file for read.
	mov ah,3dh	    ; Open file
    int 21h
	jc myexit	    ; Exit if error occurs.
	mov handle,ax	; Store handle of file for future usage
	
	readMorePin: 
      
       lea dx,cha	; Offset of text to be read to in memory
       mov bx,handle; Store handle of file in BX
	   mov cx,2	    ; Number of bytes to read
	   mov ah,3fh	; Read file
	   int 21h
       
       read_str accountName	    ; Offset of text to be read to in memory
       read_str accountPin	    ; Offset of text to be read to in memory
       read_str accountPhone	; Offset of text to be read to in memory
       read_str accountCity	    ; Offset of text to be read to in memory
       read_str accountState	; Offset of text to be read to in memory
       read_str accountPinCode	; Offset of text to be read to in memory

	   cmp ax, 0
       je  endOfFilePin
       jne cmpPin 
       
    cmpPin:
       lea si, selectedPinCode   
       lea di, accountPinCode
       xor bx, bx
       innerloop:                ; do { 
            mov al, [si + bx]        ; load a source byte
            cmp al, [di + bx]        ; check it against the other string
            jne not_equal_pin        ; if (str1[i] != str2[i]) break;

            inc bx                   ; index++ 
            cmp al, '$'              ; check for 0.  Use cmp al, '$' for a $ terminator
            jnz innerloop            ; }while(str1[i] != terminator);

            ; fall through (ZF=1) means we found the terminator
            ; in str1 *and* str2 at the same position, thus they match
       jmp equal_pin
       
    not_equal_pin:
       mov cha,1
       jmp after_pin
    
    equal_pin:
       mov cha,0
       jmp after_pin
	
	after_pin:
	   cmp cha,0
	   je matchedPin
	   jne readMorePin

    matchedPin: 
       inc countUsers
       printString blank2
       printString blank2
       printString accountName
       printString blank2
       printString accountCity
       printString blank2
       printString accountState
       printString blank2
       printString accountPinCode
       printString blank2
       printString blank2
       jmp readMorePin 
       
    
    endOfFilePin:
	   mov bx,handle; Store handle of file in BX
	   mov ah,3eh	; Close file
	   int 21h
	   jc myexit	; Exit if error occurs.
	   call etc
	   
	myexit:	
	   mov ah,4ch
	   int 21h
	   
ret    
endp search_pincode

; ##############################################################################################################################
; ##############################################################################################################################
; SEARCH BY CITY
; ##############################################################################################################################
; ##############################################################################################################################

macro get_city str
    mov si, offset str 
    inputcity: 
        mov ah, 1
        int 21h
        cmp al, 13 
        je read_from_file2 
        mov [si], al 
        inc si 
        jmp inputcity 
    exitMaccity:
        ret 
endm   


search_city proc
    call clearScreen 
    printString citymsg
    
    printString blank2
    printString citymsg1
    printString blank
    get_city selectedCity
    
    mov countUsers,0

read_from_file2:  
    
    lea dx,filename	; Offset of file name
    mov al,00h	    ; Open file for read.
	mov ah,3dh	    ; Open file
    int 21h
	jc myexit2	    ; Exit if error occurs.
	mov handle,ax	; Store handle of file for future usage
	
	readMoreCity: 
      
       lea dx,cha	; Offset of text to be read to in memory
       mov bx,handle; Store handle of file in BX
	   mov cx,2	    ; Number of bytes to read
	   mov ah,3fh	; Read file
	   int 21h
       
       read_str accountName	    ; Offset of text to be read to in memory
       read_str accountPin	    ; Offset of text to be read to in memory
       read_str accountPhone	; Offset of text to be read to in memory
       read_str accountCity	    ; Offset of text to be read to in memory
       read_str accountState	; Offset of text to be read to in memory
       read_str accountPinCode	; Offset of text to be read to in memory

	   cmp ax, 0
       je  endOfFileCity
       jne cmpCity 
       
    cmpCity:
       lea si, selectedCity   
       lea di, accountCity
       xor bx, bx
       innerloop2:                ; do { 
            mov al, [si + bx]        ; load a source byte
            cmp al, [di + bx]        ; check it against the other string
            jne not_equal_city       ; if (str1[i] != str2[i]) break;

            inc bx                   ; index++ 
            cmp   al, '$'            ; check for 0.  Use cmp al, '$' for a $ terminator
            jnz   innerloop2      ; }while(str1[i] != terminator);

            ; fall through (ZF=1) means we found the terminator
            ; in str1 *and* str2 at the same position, thus they match
       jmp equal_city
       
    not_equal_city:
       mov cha,1
       jmp after_city
    
    equal_city:
       mov cha,0
       jmp after_city
	
	after_city:
	   cmp cha,0
	   je matchedCity
	   jne readMoreCity

    matchedCity: 
       inc countUsers
       printString blank2
       printString blank2
       printString accountName
       printString blank2
       printString accountCity
       printString blank2
       printString accountState
       printString blank2
       printString accountPinCode
       printString blank2
       printString blank2
       jmp readMoreCity 
       
    
    endOfFileCity:
	   mov bx,handle; Store handle of file in BX
	   mov ah,3eh	; Close file
	   int 21h
	   jc myexit	; Exit if error occurs.
	   call etc
	   
	myexit2:	
	   mov ah,4ch
	   int 21h
	   
ret    
endp search_city

; ##############################################################################################################################
; ##############################################################################################################################
; SEARCH BY STATE
; ##############################################################################################################################
; ##############################################################################################################################

macro get_state str
    mov si, offset str 
    inputstate: 
        mov ah, 1
        int 21h
        cmp al, 13 
        je read_from_file3 
        mov [si], al 
        inc si 
        jmp inputstate 
    exitMacstate:
        ret 
endm   


search_state proc
    call clearScreen 
    printString statemsg
    
    printString blank2
    printString statemsg1
    printString blank
    get_state selectedState
    
    mov countUsers,0

read_from_file3:  
    
    lea dx,filename	; Offset of file name
    mov al,00h	    ; Open file for read.
	mov ah,3dh	    ; Open file
    int 21h
	jc myexit3	    ; Exit if error occurs.
	mov handle,ax	; Store handle of file for future usage
	
	readMoreState:
      
       lea dx,cha	; Offset of text to be read to in memory
       mov bx,handle; Store handle of file in BX
	   mov cx,2	    ; Number of bytes to read
	   mov ah,3fh	; Read file
	   int 21h
       
       read_str accountName	    ; Offset of text to be read to in memory
       read_str accountPin	    ; Offset of text to be read to in memory
       read_str accountPhone	; Offset of text to be read to in memory
       read_str accountCity	    ; Offset of text to be read to in memory
       read_str accountState	; Offset of text to be read to in memory
       read_str accountPinCode	; Offset of text to be read to in memory

	   cmp ax, 0
       je  endOfFileState
       jne cmpState 
       
    cmpState:
       lea si, selectedState   
       lea di, accountState
       xor bx, bx
       innerloop3:                ; do { 
            mov al, [si + bx]        ; load a source byte
            cmp al, [di + bx]        ; check it against the other string
            jne not_equal_state      ; if (str1[i] != str2[i]) break;

            inc bx                   ; index++ 
            cmp al, '$'              ; check for 0.  Use cmp al, '$' for a $ terminator
            jnz innerloop3        ; }while(str1[i] != terminator);

            ; fall through (ZF=1) means we found the terminator
            ; in str1 *and* str2 at the same position, thus they match
       jmp equal_state
       
    not_equal_state:
       mov cha,1
       jmp after_state
    
    equal_state:
       mov cha,0
       jmp after_state
	
	after_state:
	   cmp cha,0
	   je matchedState
	   jne readMoreState

    matchedState: 
       inc countUsers
       printString blank2
       printString blank2
       printString accountName
       printString blank2
       printString accountCity
       printString blank2
       printString accountState
       printString blank2
       printString accountPinCode
       printString blank2
       printString blank2
       jmp readMoreState 
       
    
    endOfFileState:
	   mov bx,handle; Store handle of file in BX
	   mov ah,3eh	; Close file
	   int 21h
	   jc myexit3	; Exit if error occurs.
	   call etc
	   
	myexit3:	
	   mov ah,4ch
	   int 21h
	   
ret    
endp search_state  

; ##############################################################################################################################
; ##############################################################################################################################
; TOTAL NUMBER OF USERS
; ##############################################################################################################################
; ##############################################################################################################################

print_num proc
	;initialize count
	mov cx,0
	mov dx,0
	label1:
		; if ax is zero
		cmp ax,0
		je print1	
		;initialize bx to 10
		mov bx,10		
		; extract the last digit
		div bx		
		;push it in the stack
		push dx		
		;increment the count
		inc cx		
		;set dx to 0
		xor dx,dx
		jmp label1
	print1:
		;check if count
		;is greater than zero
		cmp cx,0
		je over
		
		;pop the top of stack
		pop dx
		
		;add 48 so that it
		;represents the ASCII
		;value of digits
		add dx,48
		
		;interrupt to print a
		;character
		mov ah,02h
		int 21h
		
		;decrease the count
		dec cx
		jmp print1
    over:
        ret
endp print_num


total_users proc
    call clearScreen 
    printString usermsg
    
    mov countUsers,0 
 
    lea dx,filename	; Offset of file name
    mov al,00h	    ; Open file for read.
	mov ah,3dh	    ; Open file
    int 21h
	jc myexit3	    ; Exit if error occurs.
	mov handle,ax	; Store handle of file for future usage
	
	readMore:
      
       lea dx,cha	; Offset of text to be read to in memory
       mov bx,handle; Store handle of file in BX
	   mov cx,2	    ; Number of bytes to read
	   mov ah,3fh	; Read file
	   int 21h
       
       read_str accountName	    ; Offset of text to be read to in memory
       read_str accountPin	    ; Offset of text to be read to in memory
       read_str accountPhone	; Offset of text to be read to in memory
       read_str accountCity	    ; Offset of text to be read to in memory
       read_str accountState	; Offset of text to be read to in memory
       read_str accountPinCode	; Offset of text to be read to in memory
       
       inc countUsers

	   cmp ax, 0
       je  endOfFile
       jne readMore 
       
    
    endOfFile:
	   mov bx,handle; Store handle of file in BX
	   mov ah,3eh	; Close file
	   int 21h
	   jc myexittu	; Exit if error occurs.
	   dec countUsers 
	   printString blank2
       printString usermsg1
       mov ax,countUsers
       call print_num
       printString blank2
	   call etc
	   
	myexittu:	
	   mov ah,4ch
	   int 21h
	   
ret    
endp search_state

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;                                                                   ;
;                     E N T R Y    P O I N T                        ;
;                                                                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Main proc 
    mov ax, @data 
    mov ds, ax 

    call clearScreen
    call displaySub
    printString blank2
    mainLoop:
        call clearkeyboardbuffer
        call clearScreen
        call displayHeading
        printString blank2
        call displayinputMenu
        call clearkeyboardbuffer
        printString blank2
        call inputMenu 

        cmp inputCode, '0' 
        je exit 

        cmp inputCode, '1'
        je create_account

        cmp inputCode, '2'
        je search_pincode

        cmp inputCode, '3'
        je search_city 

        cmp inputCode, '4'
        je search_state 

        cmp inputCode, '5'
        je total_users

        jmp mainLoop
    exit:
        printString blank2 
        printString blank2 
        call displayBye
        printString blank2
        printString blank2

        mov ah,4ch
        int 21h
    main endp 
end main 