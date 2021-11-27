.model small 
.stack 1000h 
.data 

    subject db 10,13,'MICROPORCESSOR AND INTERFACING $'
    
    course db 10,13,'CSE2006 $'
    
    heading db 10,13,  'BANK MANAGEMENT SYSTEM: USER INTERFACE $'
        
    exitmsg db 10,13, 'SYSTEM CLOSED! $'
    
    createmsg db 10,13, 'CREATE NEW ACCOUNT $'

    detailmsg db 10,13,'YOUR ACCOUNT DETAILS $'

    withdrawmsg db 10,13, 'WITHDRAW $'

    DEPOSITMSG db 10,13, 'DEPOSIT $'

    resetmsg db 10,13,'CAUTION! YOU WILL RESET YOUR ACCOUNT $'

    modmsg db 10, 13, 'CAUTION! YOU WILL PROCEED TO MODIFY YOUR ACCOUNT $'

    mainmsg0 db 10,13,'0. Exit$'                         
    mainmsg1 db 10,13,'1. Create New Account$'
    mainmsg2 db 10,13,'2. Retrieve Account Details$'
    mainmsg3 db 10,13,'3. Withdraw Money$'
    mainmsg4 db 10,13,'4. Deposit Money$'
    mainmsg5 db 10,13,'5. Reset Account$'
    mainmsg6 db 10,13,'6. Update Account$'
    mainmsg7 db 10,13,'Press Enter to return to main menu $'

    detailmsg1 db 10,13, 'Account Name : $'
    detailmsg2 db 10, 13, 'Your City : $' 
    detailmsg3 db 10, 13, 'No Accounts Currently Saved!!$' 
    detailmsg4 db 10, 13, 'Total Money Left : $' 
    detailmsg5 db 10, 13, 'Account Balance is Zero $'
    detailmsg6 db 10, 13, 'Your State : $'
    detailmsg7 db 10, 13, 'Your Phone No. : $' 

    moneymsg1 db 10,13,'1.  Rs. 1000$'
    moneymsg2 db 10,13,'2.  Rs  2000$'
    moneymsg3 db 10,13,'3.  Rs. 5000$'
    moneymsg4 db 10,13,'4.  Rs. 10000$'
    moneymsg5 db 10,13,'Enter Code >> $'
    moneymsg6 db 10,13,'Withdraw Limit Exceeded. Process Terminated. $'
    moneymsg7 db 10,13,'Money Withdrawn Successfully. $' 
    moneymsg8 db 10,13,'Money Deposited Successfully. $'

    inputmsg db 'Choose an option >>  $'
    inputCode db ? 

    accountName db 20 dup('$')
    accountPIN db 20 dup('$')
    accountPhone db 20 dup('$')
    accountCity db 20 dup('$')
    accountState db 20 dup('$')
    accountPinCode db 20 dup('$')
    accountPINcount dw 0       ;This keeps track how many digit a pin is
    totalAmount dw 0
    inputAmountOption db ? 
    resetDone db 10,13,'Account has been reset. $'

    create1 db 10,13,'1. Enter Account Name : $'
    create2 db 10,13,'2. Enter Account Pin :  $'
    create5 db 10,13,'3. Enter Phone No. :  $'
    create6 db 10,13,'4. Enter Your City :  $'
    create7 db 10,13,'5. Enter Your State :  $'
    create8 db 10,13,'6. Enter Address Pincode :  $'
    create3 db 10,13,'Account Created. $'
    create4 db 10,13,'Press Enter to Confirm. $' 

    pinMsg db 10,13,'Enter Pin >> $'

    blank db 10,13,'>>  $'   ;for input blinker
    blank2 db 10,13, '    $' ;For Newline

    modAccMsg1 db 10,13,'1. New Account Name ( Old: $'
    modAccMsg2 db ' ) : >> $'
    modPinMsg1 db 10,13,'2. New Account Pin ( Old: $' 
    modPinMsg2 db ' ) : >>$' 
    modSuccess db 10,13,'Account Details Updated. $' 
    
    filename  db "..\..\Users\S K Nayak\Documents\CSE2006 Project\admin\users.txt", 0
    handle    dw ?
    usermsg   db 10, "hello world$"
    buffer    db 10 dup(?)
    msg_open  db 10, 13, "Error opening file!$"
    msg_seek  db 10, 13, "Error seeking file!$"
    msg_write db 10, 13, "Error writing file!$"
    msg_close db 10, 13, "Error closing file!$"
    new_line db 10,13

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
    printString mainmsg6
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
;  CREATE NEW ACCOUNT
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
        inc accountPINcount 
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

; ##############################################################################################################################
; ##############################################################################################################################
;  RETRIEVE ACCOUNT DETAILS
; ##############################################################################################################################
; ##############################################################################################################################   

checkAccountCreated proc 
    cmp accountPINCount, 0 
    je accountNotCreated 
    ret 

    accountNotCreated:
        call clearScreen 
        printString detailmsg3 
        printString mainmsg7
        printString blank2
        call etc 
checkAccountCreated endp 

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



getPinInput proc 
    call clearScreen 
    printString pinMsg
    printString blank 

    mov si, offset accountPIN
    mov cx, accountPINCount 

    getInput: 
        mov ah, 7
        int 21h 
        cmp al, [si] 
        mov dl, '*' 
        mov ah, 2
        int 21h 
        jne mainLoop 
        inc si 
    loop getInput 
    ret
getPinInput endp 

printNumber proc 
    mov cx, 0
    mov dx, 0 

    label1: 
        cmp ax, 0 
        je print1 
        mov bx, 10 
        div bx 
        push dx 
        inc cx 
        xor dx, dx 
        jmp label1 

    print1:
        cmp cx, 0 
        je exitprint 
        pop dx 
        add dx, 48 
        mov ah, 02h 
        int 21h 
        dec cx 
        jmp print1 

    exitprint:
        ret 
printNumber endp 

print_details proc 
    call checkAccountCreated
    call getPinInput
    call clearScreen


    printString detailmsg
    printString blank2 
    printString blank2 

    printString detailmsg1
    printString accountName 
    printString blank2 

    printString detailmsg7
    printString accountPhone
    printString blank2
    
    printString detailmsg2
    printString accountCity
    printString blank2
    
    printString detailmsg6
    printString accountState
    printString blank2 

    printString detailmsg4
    mov ax, totalAmount 
    cmp ax, 0
    je noMoneyError 
    call printNumber 
    printString mainmsg7
    printString blank2
    call etc

    noMoneyError:
        printString blank2
        printString detailmsg5
        printString mainmsg7
        printString blank2 
        call etc 
    ret 
print_details endp

; ##############################################################################################################################
; ##############################################################################################################################
;  WITHDRAW MONEY
; ##############################################################################################################################
; ##############################################################################################################################     


proc inputAmountCode 
    printString blank2
    printString moneymsg5 
    printString blank
    mov ah, 1 
    int 21h 
    mov inputAmountOption, al 
    ret 
inputAmountCode endp

withdraw proc 
    call checkAccountCreated 
    call getPinInput 

    call clearScreen 
    printString withdrawmsg

    printString blank2 
    printString moneymsg1
    printString moneymsg2
    printString moneymsg3
    printString moneymsg4

    call inputAmountCode 

    cmp inputAmountOption, '1' 
    je withdraw_1000 

    cmp inputAmountOption, '2' 
    je withdraw_2000

    cmp inputAmountOption, '3' 
    je withdraw_5000

    cmp inputAmountOption, '4' 
    je withdraw_10000

    withdraw_1000:
        mov bx, totalAmount 
        cmp bx, 1000 
        jl lessMoney
        sub totalAmount, 1000 
        printString moneymsg7
        printString blank2
        jmp mainLoop

    withdraw_2000:
        mov bx, totalAmount 
        cmp bx, 2000 
        jl lessMoney
        sub totalAmount, 2000 
        printString moneymsg7
        printString blank2
        jmp mainLoop

    withdraw_5000:
        mov bx, totalAmount 
        cmp bx, 5000 
        jl lessMoney
        sub totalAmount, 5000 
        printString moneymsg7
        printString blank2
        jmp mainLoop
    
    withdraw_10000:
        mov bx, totalAmount 
        cmp bx, 10000 
        jl lessMoney
        sub totalAmount, 10000 
        printString moneymsg7
        printString blank2
        jmp mainLoop

    lessMoney:
        printString blank2 
        printString moneymsg6
        printString mainmsg7
        printString blank2
        call etc 

    ret 
withdraw endp 

; ##############################################################################################################################
; ##############################################################################################################################
;  DEPOSIT MONEY
; ##############################################################################################################################
; ##############################################################################################################################      


deposit proc 
    call checkAccountCreated 
    call getPinInput 
    call clearScreen 

    printString DEPOSITMSG;

    printString blank2 
    printString moneymsg1
    printString moneymsg2
    printString moneymsg3
    printString moneymsg4

    call inputAmountCode 

    cmp inputAmountOption, '1' 
    je deposit_1000 

    cmp inputAmountOption, '2' 
    je deposit_2000

    cmp inputAmountOption, '3' 
    je deposit_5000

    cmp inputAmountOption, '4' 
    je deposit_10000

    deposit_1000:
        add totalAmount, 1000 
        printString moneymsg8
        printString blank2
        jmp mainLoop 

    deposit_2000:
        add totalAmount, 2000 
        printString moneymsg8
        printString blank2
        jmp mainLoop 

    deposit_5000:
        add totalAmount, 5000 
        printString moneymsg8
        printString blank2
        jmp mainLoop 

    deposit_10000:
        add totalAmount, 10000 
        printString moneymsg8
        printString blank2
        jmp mainLoop 

    ret 
deposit endp 

; ##############################################################################################################################
; ##############################################################################################################################
; RESET ACCOUNT
; ##############################################################################################################################
; ##############################################################################################################################     

reset proc 
    call checkAccountCreated 
    call getPinInput 
    call clearScreen 

    printString resetmsg;

    mov si, offset accountName 
    mov cx, 30
    l1:
        mov [si],' '
        inc si 
    loop l1 

    mov cx, 30 
    mov si, offset accountPIN
    l2:
        mov [si],' '
        inc si 
    loop l2 

    mov totalAmount, 0 
    mov accountPINcount, 0 

    printString blank2
    printString resetDone 
    printString mainmsg7
    printString blank2
    call etc 
    ret 
reset endp 

; ##############################################################################################################################
; ##############################################################################################################################
;  UPDATE
; ##############################################################################################################################
; ##############################################################################################################################

macro modify_account str 
    mov si, offset str 

    modify_account_in: 
        mov ah, 1 
        int 21h 
        cmp al, 13 
        je mod_pin 
        mov [si], al 
        inc si 
        jmp modify_account_in
endm 

macro modify_pin str 
    mov si, offset str 
    mov accountPINcount, 0

    modify_pin_in:
        mov ah, 1
        int 21h 
        cmp al, 13 
        je modify_success 
        inc accountPINcount 
        mov [si], al 
        inc si 
        jmp modify_pin_in 
endm 

modify proc 
    call checkAccountCreated 
    call getPinInput 
    call clearScreen 

    printString modmsg

    ; Account name modify 
    printString modAccMsg1 
    printString accountName 
    printString modAccMsg2
    printString blank
    modify_account accountName 
    mod_pin:
        printString blank2
        printString modPinMsg1
        printString accountPIN 
        printString modPinMsg2
        printString blank
        modify_pin accountPIN 

    modify_success:
        call clearScreen 
        printString create4
        printString modSuccess 
        call etc 
modify endp 


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
        je print_details

        cmp inputCode, '3'
        je withdraw 

        cmp inputCode, '4'
        je deposit 

        cmp inputCode, '5'
        je reset 

        cmp inputCode, '6'
        je modify 

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