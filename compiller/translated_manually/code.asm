;# ScalpiLang (31.10.2020)

;fn start
  label start
    namespace .
    SUB RSP, to_link_ret

  ;var resault
    resault equ local_1

  ;TODO -> Чтение аргументов командной строки => resault
  ;TODO -> чтение исходника  => resault
  ;TODO -> компиляция  => resault
  ;TODO -> сохранение скомпилированных фаилов  => resault

  ;my_debug_text, 'resault -> 'msvcrt\printf
    lea rcx, [my_debug_text]
    mov rdx, rax
    call [msvcrt.printf]

  ;return -> PrintLastError 
    call PrintLastError
    jmp _ret

  ;val my_debug_text "programm finish with %u" 10 13 0
    label my_debug_text
      db "programm finish with %u", 10, 13, 0
  
  label _ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn PrintLastError
  label PrintLastError
    namespace .
    SUB RSP, to_link_ret

  ;var last_error
    last_error equ local_1    

  ;~> 'Kernel32\GetLastError => last_error
    ;~> 'Kernel32\GetLastError 
      call [Kernel32.GetLastError]
      
    ;=> last_error
      mov [last_error], rax

  ;text_get_last_error, last_error, ~> printf
    ;text_get_last_error, 
      lea rax, [text_get_last_error] 
      mov [argument_1], rax

    ;last_error, 
      mov rax, [last_error] 
      mov [argument_2], rax
    
    ;~> 'msvcrt\printf
        mov rcx, [argument_1]
        mov rdx, [argument_2]
        call [msvcrt.printf]

  ;return 1
    mov rax, [last_error]

  label _ret
    add RSP, to_link_ret
    ret

  ;var text_get_last_error 10 13 "last error: %u" 10 13 0
      label text_get_last_error
        db 10, 13, "last error: %u", 10, 13, 0    

  end namespace
