;# ScalpiLang (31.10.2020)
;TODO slice_copy_symbols_to_text


;fn start
  label start
    namespace .
    SUB RSP, to_link_ret

  ;var resault
    resault equ local_1

  ;-> get_input_file_name           => resault
    call get_input_file_name
    mov [resault], rax
  
  ;TODO -> чтение исходника         => resault
  
  
  ;TODO -> компиляция               => resault
  
  
  ;TODO -> сохранить                => resault

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



;fn get_input_file_name
  label get_input_file_name
    namespace .
    SUB RSP, to_link_ret

  ;var p_command_line
    p_command_line equ  local_1
  
  ;var resault
    resault equ local_2

  ;-> 'Kernel32\GetCommandLineA => p_command_line
    call [Kernel32.GetCommandLineA]
    mov [p_command_line], rax
  
  ;'p_command_line, text_command_line, -> copy_symbols
    mov rcx, [p_command_line]
    lea rdx, [text_command_line]
    call copy_symbols
  
  ;debug_text2, text_command_line, -> 'msvcrt\printf
    lea rcx, [debug_text2]
    mov rdx, [p_command_line] 
    call [msvcrt.printf]

  ;text_command_line -> parse_find_input_name => resault
    lea rcx, [text_command_line] 
    call parse_find_input_name 
    mov [resault], rax
  
  ;if 'resault != 1 #copy default symbols
    label _if_1
    namespace .
    mov rax, [resault]
    cmp rax, 1
    jne _body
    jmp _end_if
    label _body  
  
    ;default_input_file_name, input_file_name, -> copy_symbols
      lea rcx, [default_input_file_name]
      lea rdx, [text_input_file_name]
      call copy_symbols

    label _end_if
      end namespace

  ;debug_text, input_file_name, -> 'msvcrt\printf
    lea rcx, [debug_text]
    lea rdx, [text_input_file_name]
    call [msvcrt.printf]

  ;return 1
    mov rax, 1
    jmp _ret

  ;val debug_text "get_input_file_name: input_file_name = %s" 10 13 0
    label debug_text
      db "get_input_file_name: input_file_name = %s", 10, 13, 0

  ;val debug_text2 "get_input_file_name: command_line = %s" 10 13 0
    label debug_text2 
      db "get_input_file_name: command_line = %s", 10, 13, 0
  
  ;val default_input_file_name "examples\12_message_box.txt" 0
    label default_input_file_name 
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
        mov rax,      [from]
        add rax,      [pos]
        mov al,       [rax]
        mov [symbol], al

    ;[u8]'symbol => 'dest + 'pos
      mov al,    [symbol]
      mov rcx,   [dest]
      add rcx,   [pos]
      mov [rcx], al

    ;#debug_text, 'symbol -> 'msvcrt\printf
      lea rcx, [debug_text]
      mov rdx, [symbol]
      xor r8,  r8
      mov r8l, dl
      ;call [msvcrt.printf]

    ;if [u8]'symbol = 0
      label _if_1
        namespace .
        mov al,   [symbol]
        cmp al,   0
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

  ;val debug_text "copy_symbols: symbol = %c, %u" 10 13 0
    label debug_text
      db "copy_symbols: symbol = %c, %u", 10, 13, 0

  label _ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn parse_find_input_name
  label parse_find_input_name
    namespace .
    SUB RSP, to_link_ret
    
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;param p_command_line
    p_command_line equ param_1

  ;# вычесляем положение первого аргумента

  ;var slice 
    slice equ local_1
    
    ;var start 'p_command_line
      slice.start equ local_1
      mov rax, [p_command_line]
      mov [slice.start], rax
    
    ;var end
      slice.end equ local_2

  ;# пропускаем слева имя exe
      ;# то и заканчивается кавычками.
      ;# тогда first_argument будет сразу после пробела за ними
    ;# иначе 
      ;# тогда first_argument будет сразу после первого встречного пробела

  ;# проверяем "имя exe начинаетя на кавычки" ?

  ;var symbol
    symbol equ local_3
  
  ;[u8]''slice\start => symbol
    mov rax,      [slice.start]
    mov al,       [rax]
    mov [symbol], al

  ;if [u8]'symbol = 34 
    label _if_1
      namespace .
      mov al,   [symbol]
      cmp al,   34
      je _body
      jmp _else
      label _body

    ;'slice\start + 1 => slice\start
      mov rax, [slice.start]
      add rax, 1
      mov [slice.start], rax
    
    ;loop
      label loop_1
      namespace .
      label _continue
      
      ;[u8]''slice.start => symbol
        mov rax,      [slice.start]
        mov al,       [rax]
        mov [symbol], al
      
      ;if [u8]'symbol = 34 # двойные кавычки
        label _if_2
          namespace .
          mov al,   [symbol]
          cmp al,   34
          je _body
          jmp _end_if
          label _body
        
        ;break
          jmp _break
        
        label _end_if
          end namespace

      ;'slice.start + 1 => slice.start
        mov rax, [slice.start]
        add rax, 1 
        mov [slice.start], rax
      
      jmp _continue
      label _break
        end namespace
    
    ;'slice.start + 1 => slice.start
      mov rax, [slice.start]
      add rax, 1
      mov [slice.start], rax
    
    jmp _end_if
  
  ;else # значит начало аргумента после двух пробелов
    label _else

    ;loop # ищим начало
      label loop_2
        namespace .
        label _continue

      ;[u8]''slice.start => symbol
        mov rax,      [slice.start]
        mov al,       [rax]
        mov [symbol], al

      ;if [u8]'symbol = " "
        label _if_2
          namespace .
          mov al,   [symbol]
          cmp al,   " "
          je _body
          jmp _end_if
          label _body
        
        ;'slice.start + 2 => slice.start
          mov rax, [slice.start]
          add rax, 2
          mov [slice.start], rax
      
        ;break
          jmp _break

        label _end_if
          end namespace

      ;'slice.start + 1 => slice.start
        mov rax, [slice.start]
        add rax, 1
        mov [slice.start], rax
      
      jmp _continue
        label _break
        end namespace

    label _end_if
      end namespace

  ;# ищим конец первого аргумента
  ;'slice\start + 1 => slice\end
    mov rax, [slice.start]
    add rax, 1
    mov [slice.end], rax

  ;loop # увеличиваем slice\end пока не встретим конец аргумента
    label loop_3
      namespace .
      label _continue

    ;match ''slice\end
      label _match_1
        namespace .
        mov rax, [slice.end]
        mov rax, [rax]
        cmp rax, " "
          je _body_1
        cmp rax, 0
          je _body_2
        jmp _end_match
        
      ;" "  
        label _body_1
        
        ;break
          jmp _break
      
      ;0
        label _body_2
        
        ;break
          jmp _break

      label _end_match
        end namespace
  
    ;'slice\end + 1 => slice\end
      mov rax, [slice.end] 
      add rax, 1
      mov [slice.end], rax
    
    jmp _continue
      label _break
      end namespace

  ;#TODO slice, text_input_file_name, -> slice_copy_symbols_to_text
    mov rcx, debug_1
    call [msvcrt.printf]
    jmp _end_debug
    label debug_1
    db "parse_find_input_name: TODO slice_copy_symbols_to_text", 10, 13, 0
    label _end_debug
    mov rax, 3
    jmp _ret

  ;var slice_size 'slice\start - 'slice\end
    slice_size equ local_4
    mov rax, [slice.start]
    sub rax, [slice.end]
    mov [slice_size], rax

  ;0 => text_input_file_name + 'slice_size
    mov rax,    0
    lea rcx,    [text_input_file_name]
    add rcx,    [slice_size]
    mov [rcx],  rax

  ;return 1
    mov rax, 1
    jmp _ret

  label _ret
    ADD RSP, to_link_ret
    ret
    end namespace