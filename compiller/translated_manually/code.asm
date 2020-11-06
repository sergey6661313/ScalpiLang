;# ScalpiLang (06.11.2020)
;# TODO FIX ALL THIS!



;def t_slice
  ;def start
    _t_slice•_start = 0
  
  ;def end
    _t_slice•_end   = 8
  
  _t_slice•__size = 16



;fn start
  label start
    namespace .
    SUB RSP, to_link_ret
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;var resault
    _resault equ local_1

  ;-> getInputFileName            => resault ??
    call _getInputFileName
    mov [_resault], rax
    cmp rax, 1
    jne __ret

  ;-> readInputFile               => resault ??
    call _readInputFile
    mov [_resault], rax 
    cmp rax, 1
    jne __ret

  ;-> compile                     => resault ??
    call _compile
    cmp rax, 1
    jne __ret

  ;TODO -> сохранить              => resault
  
  label __pre_ret
  ;debug_text, 'resault -> 'msvcrt\printf
    lea rcx, [_debug_text]
    mov rdx, rax
    call [_msvcrt•_printf]

  ;return -> PrintLastError 
    call _PrintLastError
    jmp __ret

  ;[u8] val debug_text "programm finish with %u" 10 13 0
    label _debug_text
      db "programm finish with %u", 10, 13, 0
  
  label __ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn PrintLastError
  label _PrintLastError
    namespace .
    SUB RSP, to_link_ret
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;var last_error
    _last_error equ local_1    

  ;-> 'Kernel32\GetLastError => last_error
    ;-> 'Kernel32\GetLastError 
      call [_Kernel32•_GetLastError]
      
    ;=> last_error
      mov [_last_error], rax

  ;text_get_last_error, last_error, -> 'msvcrt\printf
    ;text_get_last_error, 
      lea rax, [_text_get_last_error] 
      mov [argument_1], rax

    ;last_error, 
      mov rax, [_last_error] 
      mov [argument_2], rax
    
    ;-> 'msvcrt\printf
        mov rcx, [argument_1]
        mov rdx, [argument_2]
        call [_msvcrt•_printf]

  ;return 1
    mov rax, [_last_error]
    jmp __ret

  ;val text_get_last_error 10 13 "last error: %u" 10 13 0
      label _text_get_last_error
        db 10, 13, "last error: %u", 10, 13, 0    

  label __ret
    add RSP, to_link_ret
    ret
    end namespace



;fn getInputFileName
  label _getInputFileName
    namespace .
    SUB RSP, to_link_ret
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;var p_command_line
    _p_command_line equ  local_1
  
  ;var resault
    _resault equ local_2

  ;# пробуем получить имя фаила из коммандной строки
  ;-> 'Kernel32\GetCommandLineA => p_command_line
    call [_Kernel32•_GetCommandLineA]
    mov [_p_command_line], rax
  
  ;'p_command_line, text_command_line, -> copySymbols
    mov rcx, [_p_command_line]
    lea rdx, [_text_command_line]
    call _copySymbols
  
  ;debug_text2, text_command_line, -> 'msvcrt\printf
    lea rcx, [_debug_text2]
    mov rdx, [_p_command_line] 
    call [_msvcrt•_printf]

  ;text_command_line -> parseFindInputName => resault
    lea rcx, [_text_command_line] 
    call _parseFindInputName 
    mov [_resault], rax
  
  ;# Если не получилось до берём им по умолчанию
  ;if 'resault != 1 #copy default symbols
    label __if_1
      namespace .
      mov rax, [_resault]
      cmp rax, 1
      jne __body
      jmp __end_if
      label __body  
  
    ;default_input_file_name, input_file_name, -> copySymbols
      lea rcx, [_default_input_file_name]
      lea rdx, [_text_input_file_name]
      call _copySymbols

    label __end_if
      end namespace

  ;debug_text, input_file_name, -> 'msvcrt\printf
    lea rcx, [_debug_text]
    lea rdx, [_text_input_file_name]
    call [_msvcrt•_printf]

  ;return 1
    mov rax, 1
    jmp __ret

  ;[u8] val debug_text "get_input_file_name: input_file_name = %s" 10 13 0
    label _debug_text
      db "get_input_file_name: input_file_name = %s", 10, 13, 0

  ;[u8] val debug_text2 "get_input_file_name: command_line = %s" 10 13 0
    label _debug_text2 
      db "get_input_file_name: command_line = %s", 10, 13, 0
  
  ;[u8] val default_input_file_name "examples\12_message_box.txt" 0
    label _default_input_file_name 
      db "examples\12_message_box.txt", 0

  label __ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn copySymbols
  label _copySymbols
    namespace .
    SUB RSP, to_link_ret
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9
    
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
  
  ;loop       # копируем символы
    label loop_1
      namespace .
      label __continue
    
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
      ;call [_msvcrt•_printf]

    ;if [u8]'symbol = 0
      label __if_1
        namespace .
        mov al,   [symbol]
        cmp al,   0
        je __body
        jmp __end_if
        label __body

      ;break
        jmp __break

      label __end_if
        end namespace

    ;'pos + 1 => pos
        mov rax, [pos]
        add rax, 1
        mov [pos], rax
    
    jmp __continue
      label __break
      end namespace

  ;return 1
    mov rax, 1
    jmp __ret

  jmp __ret

  ;[u8] val debug_text "copy_symbols: symbol = %c, %u" 10 13 0
    label debug_text
      db "copy_symbols: symbol = %c, %u", 10, 13, 0

  label __ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn parseFindInputName
  label _parseFindInputName
    namespace .
    SUB RSP, to_link_ret
    
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;param p_command_line
    p_command_line equ param_1

  ;# вычесляем положение первого аргумента
  ;[t_slice] var slice 
    _slice        equ local_1
    _slice•_start equ local_1
    _slice•_end   equ local_2

  ;'p_command_line => slice\start 
    mov rax, [p_command_line]
    mov [_slice•_start], rax

  ;# проверяем "имя exe начинаетя на кавычки" ?
  ;var symbol
    _symbol equ local_3
  
  ;[u8]''slice\start => symbol
    mov rax,      [_slice•_start]
    mov al,       [rax]
    mov [_symbol], al

  ;if [u8]'symbol = 34 
    label __if_1
      namespace .
      mov al,   [_symbol]
      cmp al,   34
      je __body
      jmp __else
      label __body

    ;'slice\start + 1 => slice\start
      mov rax, [_slice•_start]
      add rax, 1
      mov [_slice•_start], rax
    
    ;loop
      label loop_1
      namespace .
      label __continue
      
      ;[u8]''slice\start => symbol
        mov rax,      [_slice•_start]
        mov al,       [rax]
        mov [_symbol], al
      
      ;if [u8]'symbol = 34 # двойные кавычки
        label __if_2
          namespace .
          mov al,   [_symbol]
          cmp al,   34
          je __body
          jmp __end_if
          label __body
        
        ;break
          jmp __break
        
        label __end_if
          end namespace

      ;'slice.start + 1 => slice.start
        mov rax, [_slice•_start]
        add rax, 1 
        mov [_slice•_start], rax
      
      jmp __continue
      label __break
        end namespace
    
    ;'slice\start + 1 => slice\start
      mov rax, [_slice•_start]
      add rax, 1
      mov [_slice•_start], rax
    
    jmp __end_if
  
  ;else # значит начало аргумента после двух пробелов
    label __else

    ;loop # ищим начало
      label loop_2
        namespace .
        label __continue

      ;[u8]''slice.start => symbol
        mov rax,      [_slice•_start]
        mov al,       [rax]
        mov [_symbol], al

      ;if [u8]'symbol = 0
        label __if_3
          namespace .
          mov al,   [_symbol]
          cmp al,   0
          je __body
          jmp __end_if
          label __body
        
        ;return 3
          mov rax, 3
          jmp __ret

        label __end_if
          end namespace

      ;if [u8]'symbol = " "
        label __if_2
          namespace .
          mov al,   [_symbol]
          cmp al,   " "
          je __body
          jmp __end_if
          label __body
        
        ;'slice.start + 2 => slice.start
          mov rax, [_slice•_start]
          add rax, 2
          mov [_slice•_start], rax

      ;[u8]''slice.start => symbol
        mov rax,      [_slice•_start]
        mov al,       [rax]
        mov [_symbol], al

      ;if [u8]'symbol = 0 
        label __if_4
          namespace .
          mov al,   [_symbol]
          cmp al,   0
          je __body
          jmp __end_if
          label __body
        
        ;return 4
          mov rax, 4
          jmp __ret

        label __end_if
          end namespace

        ;break
          jmp __break

        label __end_if
          end namespace

      ;'slice\start + 1 => slice\start
        mov rax, [_slice•_start]
        add rax, 1
        mov [_slice•_start], rax
      
      jmp __continue
        label __break
        end namespace

    label __end_if
      end namespace

  ;# ищим конец первого аргумента
  ;'slice\start => slice\end
    mov rax, [_slice•_start]
    mov [_slice•_end], rax

  ;# увеличиваем slice\end пока не встретим конец аргумента
  ;loop 
    label loop_3
      namespace .
      label __continue

    ;var next_symbol
      _next_symbol equ local_4
    
    ;'('slice\end + 1) => next_symbol
      mov rax, [_slice•_end]
      add rax, 1
      mov rax, [rax]
      mov [_next_symbol], rax

    ;match 'next_symbol
      label __match_1
        namespace .
        mov rax, [_slice•_end]
        add rax, 1
        mov rax, [rax]
        cmp rax, " "
          je __body_1
        cmp rax, 0
          je __body_2
        jmp __end_match
        
      ;" "  
        label __body_1
        
        ;break
          jmp __break
      
      ;0
        label __body_2
        
        ;break
          jmp __break

      label __end_match
        end namespace
  
    ;'slice\end + 1 => slice\end
      mov rax, [_slice•_end] 
      add rax, 1
      mov [_slice•_end], rax

    jmp __continue
      label __break
      end namespace

  ;var resault
    _resault equ local_4

  ;slice, text_input_file_name, -> slice_copySymbolsToText => resault
    lea rcx, [_slice]
    lea rdx, [_text_input_file_name]
    call _slice_copySymbolsToText
    mov [_resault], rax
  
  ;if 'resault != 1 :break
    mov rax, [_resault]
    cmp rax, 1
    jne __ret

  ;var slice_size 'slice\start - 'slice\end
    _slice_size equ local_4
    mov rax, [_slice•_start]
    sub rax, [_slice•_end]
    mov [_slice_size], rax

  ;0 => text_input_file_name + 'slice_size
    mov rax,    0
    lea rcx,    [_text_input_file_name]
    add rcx,    [_slice_size]
    mov [rcx],  rax

  ;return 1
    mov rax, 1
    jmp __ret

  label __ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn slice_copySymbolsToText
  label _slice_copySymbolsToText
    namespace .
    SUB RSP, to_link_ret
    
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;param p_slice
    _p_slice equ param_1
  
  ;param p_buffer
    _p_buffer equ param_2
  
  ;var start '('p_slice + t_slice\start)
    _start equ local_1
    ;'('p_slice + t_slice\start) => start
      mov rax, [_p_slice]
      mov rax, [rax]
      mov [_start], rax
    
  ;var end   '('p_slice + t_slice\end)
    _end equ local_2
    ;'('p_slice + t_slice\end) => end
        mov rax, [_p_slice]
        add rax, _t_slice•_end
        mov rax, [rax]
        mov [_end], rax
  
  ;var address_in 'start
    _address_in equ local_3
    mov rax, [_start]
    mov [_address_in], rax
  
  ;var addres_out 'p_buffer
    _addres_out equ local_4 
    mov rax, [_p_buffer]
    mov [_addres_out], rax

  ;# последовательно копируем символ за символом
  ;loop
    label loop_1
      namespace .
      label __continue

    ;''address_in => 'addres_out
      mov rax, [_address_in]
      mov rax, [rax]
      mov rcx, [_addres_out]
      mov [rcx], rax
    
    ;'address_in + 1 => address_in
      mov rax, [_address_in]
      add rax, 1
      mov [_address_in], rax
    
    ;'addres_out + 1 => addres_out
      mov rax, [_addres_out]
      add rax, 1
      mov [_addres_out], rax

    ;if 'address_in = 'end
      label __if_1 
        namespace .
        mov rax, [_address_in]
        mov rcx, [_end]
        cmp rax, rcx
        je __body
        jmp __end_if
        label __body

      ;break
        jmp __break
      
      label __end_if
        end namespace
    
    jmp __continue
      label __break
      end namespace

  ;return 1
    mov rax, 1
    jmp __ret

  label __ret
    ADD RSP, to_link_ret
    ret
    end namespace



;val g_BytesTransferred 0
  label _g_BytesTransferred
  dq 0

;FN FileIOCompletionRoutine
  label _FileIOCompletionRoutine
    namespace .
    SUB RSP, to_link_ret
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;param dwErrorCode
    _dwErrorCode equ param_1
    
  ;param dwNumberOfBytesTransfered
    _dwNumberOfBytesTransfered equ param_2
    
  ;param lpOverlapped
    _lpOverlapped  equ param_3
    
  ;text_1, 'dwErrorCode, -> 'msvcrt\printf
    lea rcx, [_text_1]
    mov rdx, [_dwErrorCode]
    call [_msvcrt•_printf]
  
  ;text_2, 'dwNumberOfBytesTransfered, -> 'msvcrt\printf
    lea rcx, [_text_2]
    mov rdx, [_dwNumberOfBytesTransfered]
    call [_msvcrt•_printf]
  
  ;'dwNumberOfBytesTransfered => g_BytesTransferred
    mov rax, [_dwNumberOfBytesTransfered] 
    mov [_g_BytesTransferred], rax

  jmp _ret

  ;[u8] val text_1 "Error code: %x" 10 13 0
    label _text_1
    db "Error code: %x", 10, 13, 0
  
  ;[u8] val text_2 "Number of bytes:  %x" 10 13 0  
    label _text_2
    db "Number of bytes:  %x", 10, 13, 0

  label _ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn readInputFile
  label _readInputFile
    namespace .
    SUB RSP, to_link_ret
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;text_input_file_name, text_from_file, text_from_file\_size -> readFile
    lea rcx, [_text_input_file_name]
    lea rdx, [_text_from_file]
    lea r8,  [_text_from_file•__size]
    call _readFile
  
  label _ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn readFile
  label _readFile
    namespace .
    SUB RSP, to_link_ret
    
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;param text_file_name
    _text_file_name equ param_1

  ;param a_buffer
    _a_buffer equ param_1

  ;param buffer_size
    _buffer_size equ param_1

  ;var file_handle
    _file_handle equ local_1
  
  ;file_handle, 'text_file_name -> file_openFile ??
    lea rcx, [_file_handle]
    mov rdx, [_text_file_name]
    call _file_openFile
    cmp rax, 1
    jne __ret

  ;'file_handle, 'a_buffer, -> file_loadFull ??
    mov rcx, [_file_handle]
    mov rdx, [_a_buffer]
    call _file_loadFull
    cmp rax, 1
    jne __ret

  ;return 1
    mov rax, 1
    jmp __ret

  label __ret
    ADD RSP, to_link_ret
    ret
    end namespace




;fn file_openFile
  label _file_openFile
    namespace .
    SUB RSP, to_link_ret

    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;param a_file_handle
    _a_file_handle equ param_1
  
  ;param a_file_name
    _a_file_name equ param_2

  ;var tmp_file_handle
    _tmp_file_handle equ local_1

  ;call 'Kernel32\CreateFileA
    ;'a_file_name,
      mov rax, [_a_file_name]
      mov [argument_1], rax

    ;GENERIC_READ,
      mov rax, 0x80000000
      mov [argument_2], rax        

    ;FILE_SHARE_READ, 
      mov rax, 0x00000001
      mov [argument_3], rax

    ;NULL, 
      lea rax, [_NULL]
      mov [argument_4], rax

    ;OPEN_EXISTING, 
      mov rax, 3
      mov [argument_5], rax

    ;FILE_ATTRIBUTE_NORMAL, 
      mov rax, 0x00000080
      mov [argument_6], rax

    ;NULL, 
      lea rax, [_NULL]
      mov [argument_7], rax
  
    mov rcx,  [argument_1]
    mov rdx,  [argument_2]
    mov r8,   [argument_3]
    mov r9,   [argument_4]
    call [_Kernel32•_CreateFileA] 

  ;=> tmp_file_handle
    mov [_tmp_file_handle], rax

  ;if 'tmp_file_handle = INVALID_HANDLE_VALUE
    label _if_1
      namespace .
      mov rax, [_tmp_file_handle]
      cmp rax, -1
      je  body
      jmp end_if
      label body
      namespace .
    
    ;-> PrintLastError
      call _PrintLastError
    
    ;return 2
      mov rax, 2
      jmp _ret

    label end_body
      end namespace
      label end_if
      end namespace    

  ;'tmp_file_handle => 'a_file_handle
    mov rax, [_tmp_file_handle]
    mov rcx, [_a_file_handle]
    mov [rcx], rax

  ;return 1
    mov  rax, 1
    jmp _ret

  label _ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn text_debug
  label _text_debug
    namespace .
    SUB RSP, to_link_ret
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;param a_text
    _a_text equ param_1
  
  ;var pos 0
    _pos equ local_1
    mov rax, 0
    mov [_pos], rax

  ;[u8] var symbol
    _symbol equ local_2

  ;loop
    label loop_1
      namespace .
      label __continue
    
    ;[u8] ''a_text => symbol
      mov rax, [_a_text]
      mov al,  [rax]
      mov [_symbol], al

    ;text_1, 'pos, [u8] 'symbol, [u8] 'symbol -> 'printf
      lea rcx,  [_text_1]
      mov rdx,  [_pos]
      mov r8,   0
      mov r8l,  [_symbol]
      mov r9,   0
      mov r9l,  [_symbol]
      call [_msvcrt•_printf]

    ;if [u8]'symbol = 0 #break 
      label __if_1
        namespace .
        mov al, [_symbol] 
        cmp al, 0
        je __body
        jmp __end_if
        label __body

      ;break
        jmp __break

      label __end_if
        end namespace
    
    ;'a_text + 1 => a_text
      mov rax, [_a_text]
      add rax, 1
      mov [_a_text], rax
    
    ;'pos + 1 => pos
      mov rax, [_pos]
      add rax, 1
      mov [_pos], rax

    jmp __continue
      label __break
      end namespace

  ;return 1
    mov rax, 1
    jmp __ret

  ;[u8] val text_1 "text_debug: \\%u = %c %u" 10 13 0
    label _text_1 
      db "text_debug: \\%u = %c %u", 10, 13, 0

  label __ret
    ADD RSP, to_link_ret
    ret
    end namespace




;fn file_readChar
  label _file_readChar
    namespace .
    SUB RSP, to_link_ret
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;param file_handle
    _file_handle equ param_1

  ;param file_indent
    _file_indent equ param_2
  
  ;param p_resault_char
    _p_resault_char equ param_3

  ;'file_indent => ol\Pointer
    mov rax, [_file_indent]
    mov [_ol•_Pointer], rax

  ;# читаем кусочек
  ;var resault 0
    _resault equ local_3
    mov rax, 0
    mov [_resault], rax

  ;var resault_char
    _resault_char equ local_4

  ;!'Kernel32\ReadFileEx
    ;'file_handle,
      mov rax, [_file_handle]
      mov [argument_1], rax

    ;resault_char,
      lea rax, [_resault_char]
      mov [argument_2], rax

    ;1,
      lea rax, [1]
      mov [argument_3], rax

    ;ol,
      lea rax, [_ol]
      mov [argument_4], rax

    ;FileIOCompletionRoutine,
      lea rax, [_FileIOCompletionRoutine]
      mov [argument_5], rax

    mov rcx,  [argument_1]
    mov rdx,  [argument_2]
    mov r8,   [argument_3]
    mov r9,   [argument_4]
    call [_Kernel32•_ReadFileEx]
    
  ;=> resault
    mov [_resault], rax

  ;# выводим на экран посмотреть что там?
  ;debug_text, buffer, ~> 'msvcrt\printf
    lea rcx,  [_debug_text]
    mov rdx,  [_resault_char]
    mov r8,   [_resault_char]
    call [_msvcrt•_printf]

  ;if resault = 0
    label __if_3
      namespace .
      mov rax, [_resault]
      cmp rax, 0
      je __body
      jmp __end_if
      label __body
    
    call _PrintLastError

    ;return 3
      mov rax, 3
      jmp __ret
    
    label __end_if
      end namespace

  ;'resault_char => 'p_resault_char
    mov rax, [_resault_char]
    mov rcx, [_p_resault_char]
    mov [rcx], rax

  ;return 1
    mov rax, 1
    jmp __ret
  
  ;[OVERLAPPED] val ol
    label _ol

    ;[ULONG_PTR] val Internal
      dq 0
    
    ;[ULONG_PTR] val InternalHigh
      dq 0
    
    ;[PVOID]     val Pointer
      label _ol•_Pointer
        dq 0

    ;[HANDLE]    val hEvent
      dq 0

    dq 160 dup 0

  ;val debug_text "readed text: %c %u" 10 13 0
    label _debug_text
      db "readed text: %c %u", 10, 13, 0

  label __ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn file_loadFull
  label _file_loadFull
    namespace .
    SUB RSP, to_link_ret
    
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9
  
  ;param file_handle
    _file_handle equ param_1
  
  ;param a_buffer
    _a_buffer equ param_2

  ;loop # заполняем буфер
    label __loop_1
      namespace .

    ;var file_indent 0
      _file_indent equ local_2
      mov rax, 0
      mov [_file_indent], rax
    
    ;var resault_char 0
        _resault_char equ local_3
        mov rax, 0
        mov [_resault_char], rax

    ;var resault
      _resault equ local_4

    label __continue

    ;'file_handle, 'file_indent, resault_char -> file_readChar
      mov rcx,  [_file_handle]
      mov rdx,  [_file_indent]
      lea r8,   [_resault_char]
      call _file_readChar
   
    ;=> resault
      mov [_resault], rax
    
    ;if [u8]'resault != 1  #break
      ;break

      mov rax, [_resault]
      cmp rax, 1
      jne __break

    ;if [u8]'resault_char = 0 #break
      ;break
      
      mov al, [_resault_char]
      cmp al, 0
      je __break

    ;[u8]'resault_char => 'a_buffer + 'file_indent
      mov al, [_resault_char]
      mov rcx, [_a_buffer]
      add rcx, [_file_indent]
      mov [rcx], al
    
    ;'file_indent + 1 => file_indent
      mov rax, [_file_indent]
      add rax, 1
      mov [_file_indent], rax

    jmp __continue
      label __break
      end namespace
    
  ;return 1
    mov rax, 1
    jmp __ret

  label __ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn compile
  label _compile
    namespace .
    SUB RSP, to_link_ret
    
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;-> define_lines => resault ??
    call _define_lines
    cmp rax, 1
    jne __ret 

  ;lines -> slice_print_proticles
    lea rcx, [_lines]
    call _slice_print_proticles

  ;lines -> slice_print
    lea rcx, [_lines]
    call _slice_print

  ;TODO  для каждой строки
  ;    магия!

  ;return 1
    mov rax, 1
    jmp __ret
  
  label __ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn define_lines
  label _define_lines
    namespace .
    SUB RSP, to_link_ret
    
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;loop
    label __loop_1
      namespace .
    
    ;var symbol
      _symbol equ local_1
    
    ;var pos            text_from_file
      _pos equ local_2
      lea rax, [_text_from_file]
      mov [_pos], rax
    
    ;debug_text2, text_from_file, -> 'msvcrt\printf
      lea rcx, [_debug_text2]
      lea rdx, [_text_from_file]
      call [_msvcrt•_printf]

    ;var start_new_line 'pos
      _start_new_line equ local_3
      mov rax, [_pos]
      mov [_start_new_line], rax
    
    label __continue
    
    ;[u8]''pos => symbol
      mov rax, [_pos]
      mov al, [rax]
      mov [_symbol], al
    
    ;debug_text, [u8]'symbol -> msvcrt\printf
      lea rcx, [_debug_text]
      mov rdx, 0
      mov dl, [_symbol]
      mov r8, 0
      mov r8l, [_symbol]
      call [_msvcrt•_printf]

    ;if [u8]'symbol = 0 #break
      label __if_1
        namespace .
        mov al, [_symbol]
        cmp al, 0
        je __body
        jmp __end_if
        label __body
      
      ;break
        jmp __break
     
      label __end_if
        end namespace

    ;if [u8]'symbol != 10 and 'symbol != 13
      label __if_2 
        namespace .
        mov al, [_symbol] 
        cmp al, 10
        je __else
        mov al, [_symbol]
        cmp al, 13
        je __else
        label __body
      
      ;'pos => lines + 'lines_count * t_slice\_size + t_slice\end
        ;'lines_count * t_slice\_size => local_4
          mov rax, [_lines_count]
          mov rcx, _t_slice•__size
          mul rcx
          mov [local_4], rax

        ;'pos => lines + 'local_4 + t_slice\end
          mov rax, [_pos]
          lea rcx, [_lines]
          add rcx, [local_4]
          add rcx, _t_slice•_end
          mov [rcx], rax
      
      jmp __end_if

    ;else
      label __else

      ;'start_new_line => lines + 'lines_count * t_slice\_size + t_slice\start
        ;'lines_count * t_slice\_size => local_4
          mov rax, [_lines_count]
          mov rcx, _t_slice•__size
          mul rcx
          mov [local_4], rax
        
        ;'start_new_line => lines + 'local_4 + t_slice\start
          mov rax, [_start_new_line]
          lea rcx, [_lines]
          add rcx, [local_4]
          add rcx, _t_slice•_start
          mov [rcx], rax

      ;'lines_count + 1 => lines_count
        mov rax, [_lines_count]
        add rax, 1 
        mov [_lines_count], rax
      
      ;loop
        label __loop_2
          namespace .
          label __continue

        ;if 'symbol != 10 and 'symbol != 13
          label __if_1
            namespace .
            mov rax, [_symbol]
            cmp rax, 10
            je __else
            mov rax, [_symbol]
            cmp rax, 13
            je __else
            label __body

          ;'pos => start_new_line
            mov rax, [_pos]
            mov [_start_new_line], rax
          ;break
            jmp __break

          label __else
          label __end_if
            end namespace
        
        ;'pos + 1 => pos
          mov rax, [_pos]
          add rax, 1
          mov [_pos], rax
        
        jmp __continue
          label __break
          end namespace
      
      ;continue
        jmp __continue
      
      label __end_if
        end namespace
    
    ;'pos + 1 => pos
      mov rax, [_pos]
      add rax, 1
      mov [_pos], rax
    
    jmp __continue
      label __break
      end namespace

  ;return 1
    mov rax, 1
    jmp __ret

  ;[u8]val debug_text "define_lines: symbol: %c %u" 10 13 0
    label _debug_text
      db "define_lines: symbol: %c %u", 10, 13, 0

  ;[u8]val debug_text2 "define_lines: text_from_file: %s" 10 13 0
    label _debug_text2
      db "define_lines: text_from_file: %s", 10, 13, 0

  label __ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn slice_print_proticles
  label _slice_print_proticles
    namespace .
    SUB RSP, to_link_ret
    
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;param a_slice
    _a_slice equ param_1

  ;var start 'a_slice
    _start equ local_1
    mov rax, [_a_slice]
    mov [_start], rax
  
  ;var end   'a_slice + t_slice\end
    label _end
    mov rax, [_a_slice]
    add rax, 8
    mov [_end], rax

  ;text_1, 'start, 'end, -> 'msvcrt\printf
    lea rcx, [_text_1]
    mov rdx, [_start]
    mov r8, [_end]
    call [_msvcrt•_printf]
  
  ;return 1
    mov rax, 1
    jmp __ret
  
  ;[u8] val text_1 "define_lines: slice: %u, %u" 10 13 0
    label _text_1
      db "define_lines: slice: %u, %u", 10, 13, 0
  
  label __ret
    ADD RSP, to_link_ret
    ret
    end namespace



;fn slice_print
  label _slice_print
    namespace .
    SUB RSP, to_link_ret
    
    mov [param_1], RCX
    mov [param_2], RDX
    mov [param_3], R8
    mov [param_4], R9

  ;param a_slice
    _a_slice equ param_1

  ;var start '('a_slice)
    _start equ local_1
    mov rax, [_a_slice]
    mov rax, [rax]
    mov [_start], rax
  
  ;var end   '('a_slice + t_slice\end)
    label _end
    mov rax, [_a_slice]
    add rax, 8
    mov rax, [rax]
    mov [_end], rax

  ;loop
    label loop_1
    namespace .
    label __continue

    ;text_1, [u8]''start, -> 'msvcrt\printf
      lea rcx, [_text_1]
      mov rax, [_start]
      mov rdx, 0
      mov dl, [rax]
      call [_msvcrt•_printf]
    
    ;'start + 1 => start
      mov rax, [_start]
      add rax, 1
      mov [_start], rax
    
    ;if 'start = 'end
      label __if_1
        namespace .
        mov rax, [_start]
        cmp rax, [_end]
        jne __end_if
        label __body
      
      ;break
        jmp __break
      
      label __end_if
        end namespace

    jmp __continue
      label __break
      end namespace

  ;text_new_line -> 'msvcrt\printf
    lea rcx, [_text_new_line]
    call [_msvcrt•_printf]

  ;return 1
    mov rax, 1
    jmp __ret

  ;[u8] val text_1 "char: %c" 0
    label _text_1
    db "slice_print: char: %c",10, 13, 0

  label __ret
    ADD RSP, to_link_ret
    ret
    end namespace