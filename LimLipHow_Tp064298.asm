.model small
.stack 100h
.data
    ; Define data section for storing strings and variables
    main_header db 0ah,"==================[ INVENTORY SYSTEM ]==================",0ah,0ah,"$"  ; Header text
    
    home_option    db "__________________[       MENU       ]__________________",0ah,0ah
                   db "1. View All Inventory",0Ah  ; Main menu options
                   db "2. View Low Stock Inventory",0Ah
                   db "3. Restock Item",0Ah
                   db "4. Sell Item",0Ah
                   db "0. Exit",0Ah,0ah,"$"

    home_input_prompt   db "Enter a number between 0 and 4: $"  ; Input prompt
    home_Validinput     db 0,1,2,3,4,5,6,7,8,9  ; Array of valid input values and a terminating null character.
    home_MsgCorrect     db 0Ah,'Yes, it s a valid input!', '$'  ; Message for valid input.
    home_MsgWrong       db 0Ah,'INVALID OPTION ENTERED !!!', 0Ah, 13,10 ,'$'  ; Message for invalid input.
    home_MsgWrong_len = $ - home_MsgWrong
    ;View All Inventory--------------------------------------------------------------------------------------
    
    viewAll_header          db "__________________[     VIEW ALL     ]__________________",13,10,13,10,'ID',9,'Name',9,9, 'Quantity',9,9, 'Price',13,10,'$'
    viewAll_ID db 0,1,2,3,4,'$'
    viewAll_Item db "USB       ","CABLE     ","ADAPTER   ","SDCARD    ","MOUSE     ","$"
    viewAll_Quantity db 10,4,12,5,3,'$'
    viewAll_Price db 9,4,6,9,8,'$'
    item_Pointer dw 0  ; Global variable  to control the current item
    qua_Pointer dw 0;
    next_line db 0Ah,"$"
    tab db 9,"$"
    viewAll_low_stock_Msg    db 0Ah,"________[ Please Restock Blinking Blue Item(s) ]________",0ah,0ah, 'Press Any Key To Go Back:   ', '$'  
    viewAll_Msg     db 0Ah,'   Press Any Key To Go Back:   ', '$'  
    
    ;View Low Inventory--------------------------------------------------------------------------------------
    viewLow_header          db "__________________[     VIEW LOW     ]__________________",13,10,13,10,'ID',9,'Name',9,9, 'Quantity',9,9, 'Price',13,10,'$'

    ;Restock Inventory--------------------------------------------------------------------------------------
    restock_header          db "__________________[     RESTOCK     ]__________________",13,10,13,10,'ID',9,'Name',9,9, 'Quantity',9,9, 'Price',13,10,'$'
    restock_low_stock_Msg    db 0Ah,"________[ Please Restock Blinking Blue Item(s) ]________",0ah,0ah, ' Select Item ID (0-4) To Restock Or',0ah,' Press 9 To Go Back :   ', '$'  
    restockQuantity_Msg     db 0Ah,0Ah,' Select Quantity To Restock ( 1-9 ) :   ', '$'  
    restockiteminvalid_Msg db 'INVALID INPUT ITEM ID!!!', 0Ah, 13,10
    restockiteminvalid_Msg_len = $ - restockiteminvalid_Msg
    restockquantityinvalid_Msg db 'INVALID INPUT QUANTITY!!!', 0Ah, 13,10
    restockquantityinvalid_Msg_len = $ - restockquantityinvalid_Msg
    restock_ID_selected db 0
    restock_quantity db 0
    add_quantity db 0
    restock_success_Msg     db 0Ah,0Ah,'INVENTORY UPDATED!!!', 0Ah, 13,10
    restock_success_Msg_len = $ - restock_success_Msg
    restock_max_Msg     db 0Ah,0Ah,'MAXIMUM QUANLITY IS 127!!!', 0Ah, 13,10
    restock_max_Msg_len = $ - restock_max_Msg

    ;Sell Inventory--------------------------------------------------------------------------------------
    Restock_Sell db 0
    sale_header          db "__________________[      SALE      ]__________________",13,10,13,10,'ID',9,'Name',9,9, 'Quantity',9,9, 'Price',13,10,'$'
    sale_stock_Msg    db 0Ah,0ah,0ah, ' Select Item ID (0-4) To Sell Or',0ah,' Press 9 To Go Back :   ', '$'  
    sale_min_Msg     db 0Ah,0Ah,'SELECTED ITEM IS OUT OF STOCK!!!', 0Ah, 13,10
    sale_min_Msg_len = $ - sale_min_Msg
    saleQuantity_Msg     db 0Ah,0Ah,' Select Quantity To Sell ( 1-9 ) :   ', '$'  
    
    ;BYEBYE MSG--------------------------------------------------------------------------------------
    byebye          db  0Ah,0ah,0ah,"[Thank You For Using]", 0Ah, 13,10
    byebye_len = $ - byebye

    ;Password
    password db '1234'
    len equ ($-password)
    msg1 db 10,13,'Password: $'
    pwcorrect db 10,13,'Password Correct! Press ENTER To Proceed$'
    pwwrong db 10,13,'Incorrect Password, Force Log Out For Security Purpose!$'
    new db 10,13,'$'
    inst db 10 dup(0)
    loginpw db 'ENTER PASSCODE TO PROCEED: ','$'


.code

Main proc
    mov ax, @data  ; Load data segment address into AX
    mov ds, ax     ; Set DS register to point to the data segment
    mov es, ax              ; Segment needed for Int 10h/AH=13h
    mov ah, 09h   ; DOS function to display a string
    lea dx, loginpw  ; Load the address of the "msgCorrect" string into DX
    int 21h  
    call loginpasscode
    call displayHome


; Define a procedure for password validation
loginpasscode PROC

upperFirst:;read uinp

    mov ah, 08h
    int 21h
    cmp al, 0dh
    je downTwo
    mov [inst+si], al
    mov dl, '*'
    mov ah, 02h
    int 21h
    inc si
    jmp upperFirst

downTwo: ;end u input
    mov bx, 00
    mov cx, len

checking:
    mov al, [inst+bx]
    mov dl, [password+bx]
    cmp al, dl
    jne failed
    inc bx
    loop checking

correct:
    mov ah, 09h   ; DOS function to display a string
    lea dx, pwcorrect  ; Load the address of the "msgCorrect" string into DX
    int 21h  
    mov ah, 01h
    int 21h
    ret

failed:
    call clear_screen
    mov ah, 09h   ; DOS function to display a string
    lea dx, pwwrong  ; Load the address of the "msgCorrect" string into DX
    int 21h  
    mov ah, 4Ch   ; DOS function to exit the program
    int 21h        ; Call DOS interrupt 21h to exit
    ret

    

finish:
    ret
loginpasscode ENDP



displayHome:

    call display_main_header
    call display_home_option
    call home_input_prompt_read
    

display_main_header:
    mov ah, 09h   ; Function to display a string
    mov dx, offset main_header  ; Load the offset address of the header string
    int 21h        ; Call DOS interrupt 21h to display the header
    ret

display_home_option:
    mov ah, 09h   
    mov dx, offset home_option  ;
    int 21h        ; Call DOS interrupt 21h to display the main menu options
    ret

home_input_prompt_read:
    mov ah, 09h   ; Function to display a string
    mov dx, offset home_input_prompt  
    int 21h       

    mov ah, 01h   
    int 21h        
    sub al, '0'  
    jmp home_input_CheckLoop

home_input_CheckLoop:
    cmp al, 1
    je display_viewAll 
    cmp al, 2
    je display_viewLow 
    cmp al, 3
    je display_restock_point
    cmp al, 4
    je pre_display_sale
    cmp al, 0
    je pre_to_exit 

    call clear_screen
    lea bp, home_MsgWrong            ; ES:BP = Far pointer to string
    mov cx, home_MsgWrong_len        ; CX = Length of string
    mov bl, 8Eh             ; blinking yellow (Bit7 set, works at least in DOSBox)
    call print
    call displayHome
    ret
pre_to_exit:
    call exitProgram

pre_display_sale:
    call clear_screen
    call display_sale


display_restock_point:
    call clear_screen
    call display_restock
    ret

clear_screen:
    mov ah, 06h   ; Function to clear the screen
    mov al, 0
    mov bh, 07h
    mov cx, 0
    mov dx, 184Fh
    int 10h        ; Call BIOS interrupt 10h to clear the screen
    ret

display_viewAll: 
    call clear_screen
    call display_main_header
    mov ah, 09h   
    mov dx, offset viewAll_header  
    int 21h        ; Call DOS interrupt 21h to display the inventory table
    call ViewAll
    call viewall_input_prompt_read
    ret

display_viewLow:
    call clear_screen
    call display_main_header
    mov ah, 09h   ; Function to display a string
    mov dx, offset viewLow_header  
    int 21h        
    mov qua_Pointer, 0    ; Initialize the quantity pointer to 0
    mov item_Pointer, 0
        lowloop:
        call compare_viewLow
        add qua_Pointer, 1
        add item_Pointer, 10  ; Move to the next item
        cmp qua_Pointer, 5     ; Check if we've processed all items (assuming there are 5 items)
        jl lowloop         ; If not, continue the loop
        call viewall_input_prompt_read
        ret
    ret


pre_display_restock:
    call clear_screen
    call display_restock



display_restock:
    call display_main_header
    mov ah, 09h   ; 
    mov dx, offset restock_header  ; 
    int 21h        
    ;call display all item to view which to restock
    call ViewAll
    ;display select id prompt
    mov ah, 09h   ;
    mov dx, offset restock_low_stock_Msg  
    int 21h        
    mov ah, 01h   
    int 21h       
    sub al, '0'  
    mov [restock_ID_selected], al  
    jmp restock_ID_check
    call exitProgram

going_home:
    call clear_screen
    call displayHome

restock_ID_check:
    cmp restock_ID_selected, 0
    je restock_quantity_prompt
    cmp restock_ID_selected, 1
    je restock_quantity_prompt
    cmp restock_ID_selected, 2
    je restock_quantity_prompt
    cmp restock_ID_selected, 3
    je restock_quantity_prompt
    cmp restock_ID_selected, 4
    je restock_quantity_prompt
    cmp restock_ID_selected, 9
    je going_home
    call clear_screen
    lea bp, restockiteminvalid_Msg            ;
    mov cx, restockiteminvalid_Msg_len        
    mov bl, 8Eh             ; blinking yellow (Bit7 set, works at least in DOSBox)
    call print
    jmp display_restock
    ret

restock_quantity_prompt:
    mov ah, 09h   
    mov dx, offset restockQuantity_Msg  ; Load the offset address of the input prompt
    int 21h        
    mov ah, 01h   ; DOS function to read a character from standard input
    int 21h        
    sub al, '0'   ; Convert the ASCII character input to a numeric value
    mov [restock_quantity], al  ; Store the user's input in restock_quantity
    jmp restock_quantity_prompt_check

restock_quantity_prompt_check:
    cmp restock_quantity,1
    je restock_operation
    cmp restock_quantity,2
    je restock_operation
    cmp restock_quantity,3
    je restock_operation
    cmp restock_quantity,4
    je restock_operation
    cmp restock_quantity,5
    je restock_operation
    cmp restock_quantity,6
    je restock_operation
    cmp restock_quantity,7
    je restock_operation
    cmp restock_quantity,8
    je restock_operation
    cmp restock_quantity,9
    je restock_operation
    call clear_screen
    lea bp, restockquantityinvalid_Msg            ; ES:BP = Far pointer to string
    mov cx, restockquantityinvalid_Msg_len        ; CX = Length of string
    mov bl, 8Eh             ; blinking yellow (Bit7 set, works at least in DOSBox)
    call print
    jmp display_restock
    ret


restock_operation:
    cmp restock_ID_selected,0
    je restock_operation0
    cmp restock_ID_selected,1
    je restock_operation1
    cmp restock_ID_selected,2
    je restock_operation2
    cmp restock_ID_selected,3
    je restock_operation3
    cmp restock_ID_selected,4
    je restock_operation4


restock_updated_msg:
    lea bp, restock_success_Msg            ; ES:BP = Far pointer to string
    mov cx, restock_success_Msg_len        ; CX = Length of string
    mov bl, 9Eh             ; blinking yellow (Bit7 set, works at least in DOSBox)
    call print
    ret

morethan126:
    call clear_screen
    lea bp, restock_max_Msg            ; ES:BP = Far pointer to string
    mov cx, restock_max_Msg_len        ; CX = Length of string
    mov bl, 8Eh             ; blinking yellow (Bit7 set, works at least in DOSBox)
    call print
    jmp display_restock

restock_operation0:
    mov bl, viewAll_Quantity[0]
    add bl,al
    cmp bl, 127
    ja morethan126
    mov viewAll_Quantity[0],bl
    call clear_screen
    call restock_updated_msg
    call display_restock

restock_operation1:
    mov bl, viewAll_Quantity[1]
    add bl,al
    cmp bl, 127
    ja morethan126
    mov viewAll_Quantity[1],bl
    call clear_screen
    call restock_updated_msg
    call display_restock
    

restock_operation2:
    mov bl, viewAll_Quantity[2]
    add bl,al
    cmp bl, 127
    ja morethan126
    mov viewAll_Quantity[2],bl
    call clear_screen
    call restock_updated_msg
    call display_restock
    

restock_operation3:
    mov bl, viewAll_Quantity[3]
    add bl,al
    cmp bl, 127
    ja morethan126
    mov viewAll_Quantity[3],bl
    call clear_screen
    call restock_updated_msg
    call display_restock
    

restock_operation4:
    mov bl, viewAll_Quantity[4]
    add bl,al
    cmp bl, 127
    ja morethan126
    mov viewAll_Quantity[4],bl
    call clear_screen
    call restock_updated_msg
    call display_restock

display_sale:
    call display_main_header
    mov ah, 09h   
    mov dx, offset sale_header  
    int 21h       
    call ViewAll
    ;display select id prompt
    mov ah, 09h  
    mov dx, offset sale_stock_Msg  
    int 21h        
    mov ah, 01h   
    int 21h        
    sub al, '0'   
    mov [restock_ID_selected], al  ; Store the user's input in restock_ID_selected
    jmp sale_ID_check
    call exitProgram

going_home1:
    call clear_screen
    call displayHome


sale_ID_check:
    cmp restock_ID_selected, 0
    je sale_quantity_prompt
    cmp restock_ID_selected, 1
    je sale_quantity_prompt
    cmp restock_ID_selected, 2
    je sale_quantity_prompt
    cmp restock_ID_selected, 3
    je sale_quantity_prompt
    cmp restock_ID_selected, 4
    je sale_quantity_prompt
    cmp restock_ID_selected, 9
    je going_home1

    call clear_screen

    lea bp, restockiteminvalid_Msg            ; ES:BP = Far pointer to string
    mov cx, restockiteminvalid_Msg_len        ; CX = Length of string
    mov bl, 8Eh             ; blinking yellow (Bit7 set, works at least in DOSBox)
    call print
    jmp display_sale
    ret

sale_quantity_prompt:
    mov ah, 09h   ; Function to display a string
    mov dx, offset saleQuantity_Msg  ; Load the offset address of the input prompt
    int 21h        
    mov ah, 01h   
    int 21h        
    sub al, '0'   ; Convert the ASCII character input to a numeric value
    mov [restock_quantity], al  
    jmp sale_quantity_prompt_check

sale_quantity_prompt_check:
    cmp restock_quantity,1
    je sale_operation
    cmp restock_quantity,2
    je sale_operation
    cmp restock_quantity,3
    je sale_operation
    cmp restock_quantity,4
    je sale_operation
    cmp restock_quantity,5
    je sale_operation
    cmp restock_quantity,6
    je sale_operation
    cmp restock_quantity,7
    je sale_operation
    cmp restock_quantity,8
    je sale_operation
    cmp restock_quantity,9
    je sale_operation
    call clear_screen
    lea bp, restockquantityinvalid_Msg            ; ES:BP = Far pointer to string
    mov cx, restockquantityinvalid_Msg_len        ; CX = Length of string
    mov bl, 8Eh             ; blinking yellow (Bit7 set, works at least in DOSBox)
    call print
    jmp display_restock
    ret


sale_operation:
    cmp restock_ID_selected,0
    je sale_operation0
    cmp restock_ID_selected,1
    je sale_operation1
    cmp restock_ID_selected,2
    je sale_operation2
    cmp restock_ID_selected,3
    je sale_operation3
    cmp restock_ID_selected,4
    je sale_operation4


lessthan0:
    call clear_screen
    lea bp, sale_min_Msg            ; ES:BP = Far pointer to string
    mov cx, sale_min_Msg_len        ; CX = Length of string
    mov bl, 8Eh             ; blinking yellow (Bit7 set, works at least in DOSBox)
    call print
    jmp display_sale



sale_operation0:
    mov bl, viewAll_Quantity[0]
    sub bl,al
    cmp bl, 0
    jl lessthan0
    mov viewAll_Quantity[0],bl
    call clear_screen
    call restock_updated_msg
    call display_sale

sale_operation1:
    mov bl, viewAll_Quantity[1]
    sub bl,al
    cmp bl, 0
    jl lessthan0
    mov viewAll_Quantity[1],bl
    call clear_screen
    call restock_updated_msg
    call display_sale
    

sale_operation2:
    mov bl, viewAll_Quantity[2]
    sub bl,al
    cmp bl, 0
    jl lessthan0
    mov viewAll_Quantity[2],bl
    call clear_screen
    call restock_updated_msg
    call display_sale
    

sale_operation3:
    mov bl, viewAll_Quantity[3]
    sub bl,al
    cmp bl, 0
    jl lessthan0
    mov viewAll_Quantity[3],bl
    call clear_screen
    call restock_updated_msg
    call display_sale
    

sale_operation4:
    mov bl, viewAll_Quantity[4]
    sub bl,al
    cmp bl, 0
    jl lessthan0
    mov viewAll_Quantity[4],bl
    call clear_screen
    call restock_updated_msg
    call display_sale

match1:
    call clear_screen

    mov ah, 09h   ; Function to display a string
    mov dx, offset home_MsgCorrect  ; Load the offset address of the input prompt
    int 21h        ; Call DOS interrupt 21h to display the input prompt
    call displayHome




print_tab:
    mov ah, 09h   ; Function to display a string
    mov dx, offset tab  ; Load the offset address of the inventory table
    int 21h        ; Call DOS interrupt 21h to display the inventory table
    ret

ViewAll:
    mov item_Pointer, 0  ; Initialize the current item to 0 (first item)
    mov qua_Pointer, 0    ; Initialize the quantity pointer to 0

    viewAllLoop:
        call display_viewAll_ID
        call print_tab
        call printItem  ; Print the current item
        call print_tab
        call print_tab
        call comparelessthan5
        call print_tab
        call print_tab
        call print_tab
        call display_viewAll_Price
        mov ah, 09h   ; Function to display a string
        mov dx, offset next_line  ; Load the offset address of the inventory table
        int 21h
        add item_Pointer, 10  ; Move to the next item
        add qua_Pointer, 1     ; Move to the next quantity

        cmp qua_Pointer, 5     ; Check if we've processed all items (assuming there are 5 items)
        jl viewAllLoop         ; If not, continue the loop

        ret
    ret

comparelessthan5:
    ; Calculate the offset for accessing 'viewAll_Quantity' using 'qua_Pointer' as an index
    mov si, offset viewAll_Quantity    
    mov ax, qua_Pointer               
    add si, ax                        ; Add 'qua_Pointer' to the base address to access the selected element
    ; Load the quantity from 'viewAll_Quantity' using the calculated offset
    mov al, [si]                      ; Load the quantity from 'viewAll_Quantity' into AL
    cmp al, 5
    jg print_digits_loop
    ; Set text color to red (color code 0x0C)
    mov ah, 09h
    mov al, 0Ch
    int 10h
    ; Print the digit in blue
    mov dl, [si] ; Load the character from the memory location pointed by SI
    add dl, 48     ; Convert the number to ASCII by adding 48 (ASCII code for '0')
    mov bh, 0         
    mov bl, 09h       
    or bl, 80h        ; Set text to have blink feature
    mov cx, 1         ; Set CX=1 (number of characters to display)
    int 10h           
    mov ah, 02h       ; print the char
    int 21h 
    ; Reset = color to the original default
    mov ah, 09h
    mov al, 07h  
    int 10h
    ret


printitem:
    lea si, viewAll_Item
    mov ax, item_Pointer  ; Load the current item index 
    add si, ax          ; Adjust SI to point to the current item

    itemStringLoop:
        mov al, [si]      ; Load the byte at the address in SI into AL
        cmp al, ' '       ; Check if we've reached the end of the current element
        je done

        mov ah, 0Eh       ; Set AH to 0Eh (teletype output)
        int 10h           ; Call BIOS interrupt to print the character

        inc si            ; Move to the next character in the element
        jmp itemStringLoop

    done:
        ret



display_viewAll_ID:
    mov si, offset viewAll_ID  ; Initialize SI with the offset of the 'number' array.
    mov ax, qua_Pointer
    add si, ax
    jmp print_digits_loop
    ret

display_viewAll_Price:
    mov si, offset viewAll_Price  ; Initialize SI with the offset of the 'number' array.
    mov ax, qua_Pointer
    add si, ax
    jmp print_digits_loop
    ret

print_digits_loop:
    mov al, [si]  
    xor ah, ah  
    xor cx, cx  
    mov bx, 10  ; Set BX to 10,  as  divisor.
    jmp pushem
    ret
    
pushem:
    xor dx, dx  ; Clear DX. T
    div bx      ; Divide AX by BX. 
    add dl, '0'  ; Convert the remainder to its ASCII character 
    push dx  ; Push the ASCII character onto the stack to reverse the order.
    inc cx  ; Increment the digit counter.
    test ax, ax  ; Check if AX is zero
    jnz pushem  ; If AX is not zero, repeat the conversion process.
    jmp popem
    ret

popem:
    pop ax  ; Pop a digit from the stack into AX.
    mov dl, al  ; 
    mov ah, 2  ;
    int 21h  ; Call DOS interrupt 21h to display the character in DL.
    loop popem  
    ret



compare_viewLow:
    mov si, offset viewAll_Quantity
    mov ax, qua_Pointer
    add si, ax
    mov al, [si]
    cmp al, 5
    jle display_viewLow_Data
    ret

display_viewLow_Data:
        call display_viewAll_ID
        call print_tab
        call printItem  ; Print the current item
        call print_tab
        call print_tab
        call comparelessthan5
        call print_tab
        call print_tab
        call print_tab
        call display_viewAll_Price
        mov ah, 09h  
        mov dx, offset next_line  
        int 21h
        ret



viewall_input_prompt_read:

    mov ah, 09h   
    mov dx, offset viewAll_low_stock_Msg  
    int 21h        
    mov ah, 00h   
    int 16h        
    call clear_screen
    call displayHome
    ret
print PROC                  
    push cx                 
    mov ah, 03h             ; VIDEO - GET CURSOR POSITION AND SIZE
    xor bh, bh              
    int 10h                 ; Call Video-BIOS => DX is current cursor position
    pop cx                  

    mov ah, 13h             ; VIDEO - WRITE STRING (AT and later,EGA)
    mov al, 1               
    xor bh, bh              
    int 10h                 ; Call Video-BIOS

    ret
print ENDP

exitProgram:
    call clear_screen
    lea bp, byebye            
    mov cx, byebye_len        
    mov bl, 9Eh            
    call print


    mov ah, 4Ch   ; DOS function to exit the program
    int 21h        ; Call DOS interrupt 21h to exit
    ret






main endp
end main
