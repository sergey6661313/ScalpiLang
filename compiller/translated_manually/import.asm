
  dd 0,0,0, RVA msvcrt.name,    RVA msvcrt
  dd 0,0,0, RVA Kernel32.name,      RVA Kernel32
  dd 0,0,0,0,0

  ;import msvcrt
    label msvcrt
    namespace .
    printf          dq RVA printf_name
    sprintf         dq RVA sprintf_name
    dq 0
    name            db 'msvcrt.dll',0
    
    ;fn printf
      printf_name      db 0, 0, 'printf', 0
    ;fn sprintf
      sprintf_name     db 0, 0, 'sprintf', 0   
    end namespace

  ;import Kernel32
    label Kernel32
    namespace .
    CreateFileA     dq RVA CreateFileA_name
    GetLastError    dq RVA GetLastError_name
    ReadFileEx      dq RVA ReadFileEx_name
    dq 0
    name            db 'Kernel32.dll',0

    ;fn CreateFileA 
      CreateFileA_name     db 0, 0, 'CreateFileA', 0
    ;GetLastError
      GetLastError_name     db 0, 0, 'GetLastError', 0
    ;fn ReadFileEx
      ReadFileEx_name         db 0, 0, "ReadFileEx", 0
    end namespace

