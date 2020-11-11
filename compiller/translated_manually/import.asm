;# ScalpiLang (02.11.2020)
  label __import_table
    dd 0, 0, 0, RVA _msvcrt•__name,    RVA _msvcrt
    dd 0, 0, 0, RVA _Kernel32•__name,  RVA _Kernel32
    dd 0, 0, 0, RVA _Shell32•__name,   RVA _Shell32
    dd 0, 0, 0, 0, 0



  ;import msvcrt
    label _msvcrt

    ;fn printf
      _msvcrt•_printf          dq RVA _msvcrt•_printf•__name
    
    ;fn sprintf
      _msvcrt•_sprintf         dq RVA _msvcrt•_sprintf•__name
    
    ;fn malloc
      _msvcrt•_malloc          dq RVA _msvcrt•_malloc•__name
    
    dq 0
      _msvcrt•__name              db 'msvcrt.dll',0
      _msvcrt•_printf•__name      db 0, 0, 'printf', 0
      _msvcrt•_sprintf•__name     db 0, 0, 'sprintf', 0   
      _msvcrt•_malloc•__name      db 0, 0, 'malloc', 0



  ;import Kernel32
    label _Kernel32

    ;fn CreateFileA 
      _Kernel32•_CreateFileA     dq RVA _Kernel32•_CreateFileA•__name

    ;fn GetLastError
      _Kernel32•_GetLastError    dq RVA _Kernel32•_GetLastError•__name

    ;fn ReadFileEx
      _Kernel32•_ReadFileEx      dq RVA _Kernel32•_ReadFileEx•__name

    ;fn GetCommandLineA 
      _Kernel32•_GetCommandLineA dq RVA _Kernel32•_GetCommandLineA•__name

    dq 0
      _Kernel32•__name                   db 'Kernel32.dll',0
      _Kernel32•_CreateFileA•__name      db 0, 0, 'CreateFileA', 0
      _Kernel32•_GetLastError•__name     db 0, 0, 'GetLastError', 0
      _Kernel32•_ReadFileEx•__name       db 0, 0, "ReadFileEx", 0
      _Kernel32•_GetCommandLineA•__name  db 0, 0, "GetCommandLineA", 0



  ;import Shell32
    label _Shell32
    
    ;fn ShellExecuteA
      _Shell32•_ShellExecuteA dq RVA _Shell32•_ShellExecuteA•__name

    dq 0
      _Shell32•__name                     db 'Shell32.dll', 0
      _Shell32•_ShellExecuteA•__name      db 0, 0, 'ShellExecuteA', 0
  