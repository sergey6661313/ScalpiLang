;# ScalpiLang (02.11.2020)

;[u8 512] val text_command_line 
  label _text_command_line
  
  _text_command_line•__size = 512
  
  rb _text_command_line•__size

;[u8 512] val text_input_file_name 
  label _text_input_file_name
  
  _text_input_file_name•__size = 512
  
  rb _text_input_file_name•__size

;[u8 1000] val text_from_file
  label _text_from_file
  
  _text_from_file•__size = 1000
  
  rb _text_from_file•__size

