;31.10.2020

;val testing_line
  label _testing_line
  dq _testing_text
  dq _end_testing_text

;val testing_text
  label _testing_text 
    db "TESTING"
  label _end_testing_text
    db "vvvvv",  0

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

;val[u8] text_new_line 10 13 0
  label _text_new_line
    db 10, 13, 0 