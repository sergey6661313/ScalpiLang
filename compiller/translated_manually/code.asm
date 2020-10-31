;# ScalpiLang (31.10.2020)



;fn start
  label start
    namespace .
    SUB RSP, to_link_ret

  ;var resault
    resault equ local_1

  ;-> получить_имя_исходника   => resault
    call получить_имя_исходника
    mov [resault], rax
  
  ;TODO -> чтение исходника         => resault
  
  
  ;TODO -> компиляция               => resault
  
  
  ;TODO -> сохраненить              => resault

  ;debug_text, 'resault -> 'msvcrt\printf
    lea rcx, [debug_text]
    mov rdx, rax
    call [msvcrt.printf]

  ;return -> PrintLastError 
    call PrintLastError
    jmp _ret

  ;val debug_text "programm finish with %u" 10 13 0
    label debug_text
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



;fn получить_имя_исходника
  label получить_имя_исходника
    namespace .
    SUB RSP, to_link_ret

  ;имя_исходника_из_аргументов_командной_строки, input_file_name, -> copy_symbols
    lea rcx, [имя_исходника_из_аргументов_командной_строки]
    lea rdx, [input_file_name]
    call copy_symbols
  
  ;debug_text, input_file_name, -> 'msvcrt\printf
    lea rcx, [debug_text]
    lea rdx, [input_file_name]
    call [msvcrt.printf]

  ;return 1
    mov rax, 1
    jmp _ret

  ;val debug_text "получить_имя_исходника: input_file_name = %s" 10 13 0
    label debug_text
      db "получить_имя_исходника: input_file_name = %s", 10, 13, 0

  ;val имя_исходника_из_аргументов_командной_строки "examples\12_message_box.txt" 0
    label имя_исходника_из_аргументов_командной_строки 
      db "examples\12_message_box.txt", 0

  label _ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn copy_symbols
  label copy_symbols
    namespace .
    SUB RSP, to_link_ret
    mov [param_1], RCX
    mov [param_2], RDX
    
  ;param from
   from equ param_1

  ;param dest
    dest equ param_2

  ;[u8] var symbol
    symbol equ local_1

  ;var pos 0
    pos equ local_2
    mov rax, 0
    mov [pos], rax
  
  ;loop       # for symbol in from: [u8]'symbol => 'dest + 'i
    label loop_1
      namespace .
      label _continue
    
    ;[u8] '('from + 'pos) => symbol
        mov rax,  [from]
        add rax,  [pos]
        mov ah,   [rax]
        mov [symbol], ah

    ;[u8]'symbol => 'dest + 'pos
      mov ah, [symbol]
      mov rcx,   [dest]
      add rcx,   [pos]
      mov [rcx], ah

    ;debug_text, 'symbol -> 'msvcrt\printf
      lea rcx, [debug_text]
      mov rdx, [symbol] 
      call [msvcrt.printf]

    ;if 'symbol = 0
      label _if_1
        namespace .
        mov ah, [symbol]
        cmp ah, 0
        je _body
        jmp end_if
        label _body

      ;break
        jmp _break

      label end_if
        end namespace

    ;'pos + 1 => pos
        mov rax, [pos]
        add rax, 1
        mov [pos], rax
    
    jmp _continue
      label _break
      end namespace

  ;return 1
    mov rax, 1
    jmp _ret

  jmp _ret

  ;val debug_text "copy_symbols: symbol = %c" 10 13 0
    label debug_text
      db "copy_symbols: symbol = %c", 10, 13, 0

  label _ret
    ADD RSP, to_link_ret
    ret
    end namespace  