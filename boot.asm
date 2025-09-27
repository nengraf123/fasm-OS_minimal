; boot.asm  -- BIOS boot sector (512 bytes)
org 0x7C00
use16

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; ОЧИСТКА ЭКРАНА
    mov ax, 0x0003
    int 0x10

    ; Спрятать курсор
    mov ah, 0x01
    mov ch, 0x20
    mov cl, 0x00
    int 0x10

    ; Сохранить загрузочное устройство (DL)
    mov [boot_drive], dl

    ; Загрузить kernel в 0x0000:0x8000
    mov ax, 0x0000
    mov es, ax
    mov bx, 0x8000

    ; Параметры для чтения диска
    mov ah, 0x02
    mov al, 4
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    int 0x13
    jc disk_error

    ; Переход к ядру
    jmp 0x0000:0x8000

disk_error:
    ; При ошибке тоже очищаем экран
    mov ax, 0x0003
    int 0x10

    mov si, disk_err_msg
    mov ah, 0x0E
    mov bh, 0
.print_loop:
    lodsb
    test al, al
    jz .hang
    int 0x10
    jmp .print_loop

.hang:
    hlt
    jmp .hang

; Данные
boot_drive db 0
disk_err_msg db "Disk error!", 0

times 510 - ($ - $$) db 0
dw 0xAA55
