; kernel.asm - минимальное ядро с черным экраном после загрузки
org 0x8000
use16

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    ; Очистка экрана
    mov ax, 0x0003
    int 0x10
    
    ; Спрятать курсор
    mov ah, 0x01
    mov ch, 0x20
    mov cl, 0x00
    int 0x10
    
    ; Бесконечный цикл (черный экран)
.halt:
    hlt
    jmp .halt

times 2048 - ($ - $$) db 0
