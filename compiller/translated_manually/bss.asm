;01.11.2020

;[u8 512] val text_command_line 
  label text_command_line
  namespace .
  label _start
    rb 512
  label _end
  size_of = _end - _start
  end namespace

;[u8 512] val text_input_file_name 
  label text_input_file_name
  namespace .
  label _start
    rb 512
  label _end
  size_of = _end - _start
  end namespace

;[u8 1000] val text_from_file
  label text_from_file
    rb 1000

