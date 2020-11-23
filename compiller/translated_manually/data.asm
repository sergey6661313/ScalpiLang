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

;val[u8] text_new_line 13 10 0
  label _text_new_line
    db 13, 10, 0

;val[u8] text_line_1 "include 'format/format.inc'" 0
  label _text_line_1 
  db "include 'format/format.inc'", 0
  _text_line_1•__size = $ - _text_line_1

;val[u8] text_line_2 "format PE64 console" 0
  label _text_line_2 
  db "format PE64 console", 0
  _text_line_2•__size = $ - _text_line_2

;val[u8] text_section_import "section '.idata' import data readable writeable" 0
  label _text_section_import 
  ;[u8] 
    db "section '.idata' import data readable writeable" 
    db 0

;val a_import_table
  label _a_import_table
  dq 0

;[u8] val default_input_file_name "example\12_message_box.txt" 0
  label _default_input_file_name 
    db "example\12_message_box.txt", 0


