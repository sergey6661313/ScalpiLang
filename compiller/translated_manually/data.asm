;31.10.2020

;val NULL real_NULL
  label _NULL 
    dq _real_NULL

;val real_NULL 0
  label _real_NULL
    dq 0
  
;val change_background_to_black 27 "[40m" 0
  label _change_background_to_black
  namespace .

  ;27 "[40m" 0
    db 27, "[40m", 0

  end namespace

;val change_background_to_red   27 "[41m" 0
  label _change_background_to_red 
  namespace .
  ;27 "[41m" 0
    db 27, "[41m", 0
  end namespace

;val move_cursor                27 "[%U;%UH" 0
  label _move_cursor 
  db 27, "[%u;%uH", 0

;val screen
  label _screen
  namespace .
  ;text
    db "- - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - - - - - - - - - - - - -", 10, 13
    db "- - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - - - - - - - - - - - - -", 10, 13
    db "- - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - - - - - - - - - - - - -", 10, 13
    db "- - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - - - - - - - - - - - - -", 10, 13
    db "------------------------------------------------+--------------------------------------------------", 10, 13
    db "- - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - - - - - - - - - - - - -", 10, 13
    db "- - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - - - - - - - - - - - - -", 10, 13
    db "- - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - - - - - - - - - - - - -", 10, 13
    db "- - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - - - - - - - - - - - - -", 10, 13
    db "- - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - - - - - - - - - - - - -", 10, 13
  db 0
  end namespace

;[u8] val text_new_line 10 13 0
  label _text_new_line
    db 10, 13, 0 