include 'format/format.inc'
format PE64 console

argument_1      equ rsp + 8*0
argument_2      equ rsp + 8*1
argument_3      equ rsp + 8*2
argument_4      equ rsp + 8*3
argument_5      equ rsp + 8*4
argument_6      equ rsp + 8*5
argument_7      equ rsp + 8*6
argument_8      equ rsp + 8*7
argument_9      equ rsp + 8*8
argument_10     equ rsp + 8*9
argument_11     equ rsp + 8*10
argument_12     equ rsp + 8*11
last_argument   = 8*11

first_local     = last_argument + 8
local_1  		equ rsp + first_local + 8*0
local_2  		equ rsp + first_local + 8*1
local_3  		equ rsp + first_local + 8*2
local_4  		equ rsp + first_local + 8*3
local_5  		equ rsp + first_local + 8*4
local_6  		equ rsp + first_local + 8*5
local_7  		equ rsp + first_local + 8*6
local_8  		equ rsp + first_local + 8*7
local_9  		equ rsp + first_local + 8*8
local_10 		equ rsp + first_local + 8*9
local_11 		equ rsp + first_local + 8*10
local_12 		equ rsp + first_local + 8*11
last_local          = first_local + 8*11

first_named_local   = last_local + 8
tmp_resault   	    equ rsp + first_named_local + 8*0
tmp_remainder 	    equ rsp + first_named_local + 8*1
last_named_local    = first_named_local + 8*1

local_space         = last_named_local + 8
to_link_ret         = local_space + 8
first_param         = to_link_ret + 8

param_1         equ rsp + first_param + 8*0
param_2         equ rsp + first_param + 8*1
param_3         equ rsp + first_param + 8*2
param_4         equ rsp + first_param + 8*3
param_5         equ rsp + first_param + 8*4
param_6         equ rsp + first_param + 8*5
param_7         equ rsp + first_param + 8*6
param_8         equ rsp + first_param + 8*7
param_9         equ rsp + first_param + 8*8
param_10        equ rsp + first_param + 8*9
param_11        equ rsp + first_param + 8*10
param_12        equ rsp + first_param + 8*11

section '.idata' import data readable writeable
    include 'import.asm'

section '.text' code readable writeable executable
    entry start
    include 'code.asm'
    
section '.data' data readable writeable
    dq 0, 0
    include 'data.asm'

section '.bss' data readable writeable
    dq 0, 0
    include 'bss.asm'






