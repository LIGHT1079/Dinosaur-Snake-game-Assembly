	AREA MYDATA, DATA, READWRITE


RCC_AHB1ENR EQU 0x40021018 ;this register is responsible for enabling certain ports, by making the clock affect the target port.

AFIO_MAPR EQU 0x40010004
GPIOA_BASE EQU 0x40010800	;Base of port E
;this is where you write your data as an output into the port
GPIOA_ODR EQU 0x4001080C    ;output register of port E, PE0 - PE15
	;as output
GPIOB_BASE EQU 0x40010C04	;Base of port E
	
GPIOC_BASE EQU 0x40011000
;this is where you write your data as an output into the port
GPIOB_ODR EQU 0x40010C0C
GPIOB_IDR EQU GPIOB_BASE + 0x08
GPIOC_IDR EQU GPIOC_BASE + 0x08
GPIOC_ODR EQU 0x4001100C
;odr = base+0x0C
GPIOC_CRH EQU 0x40011004

INTERVAL EQU 0x186004		;just a number to perform the delay. this number takes roughly 1 second to decrement until it reaches 0
BASE EQU 0x140
HEIGHT EQU 0x0F0	

MENU_BACKGROUND DCW 0xffff
MENU_LETTER_COLOR DCW 0xf800
;the following are pins connected from the TFT to our EasyMX board
;RD = PE10		Read pin	--> to read from touch screen input 
;WR = PE11		Write pin	--> to write data/command to display
;RS = PE12		Command pin	--> to choose command or data to write
;CS = PE15		Chip Select	--> to enable the TFT, lol	(active low)
;RST= PE8		Reset		--> to reset the TFT (active low)
;D0-7 = PE0-7	Data BUS	--> Put your command or data on this bus

;just some color codes, 16-bit colors coded in RGB 565
BLACK	EQU   	0x0000
BLUE 	EQU  	0x001F
RED  	EQU  	0xF800
RED2   	EQU 	0xf000
GREEN 	EQU  	0x07E0
CYAN  	EQU     0x07FF
MAGENTA EQU 	0xF81F
YELLOW	EQU  	0xFFE0
WHITE 	EQU  	0xFFFF
GREEN2 	EQU 	0x3d67
CYAN2 	EQU  	0xFF70
BLUE2   EQU     0x0014
BROWN   EQU     0xd1a6
ORANGE  EQU     0xfdA0
BEIGE   EQU     0xfffe
GREY    EQU     0xE71b
SKIN    EQU     0xffc8

START_SNAKE_X DCD 0x064
START_SNAKE_Y DCD 0x078
SNAKE_DIRECTIONS  DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
SNAKE_DIRECTIONS1 DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
SNAKE_DIRECTIONS2 DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
SNAKE_DIRECTIONS3 DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
SNAKE_DIRECTIONS4 DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
SNAKE_HEAD_X  DCD 0
SNAKE_HEAD_Y  DCD 0
SNAKE_TAIL_X  DCD 0
SNAKE_TAIL_Y  DCD 0
SNAKE_LENGTH DCD 0
SNAKE_HP  DCD 0
SNAKE_TP DCD 0
SNAKE_HEALTH DCW 0X00
APPLE_X DCD 0
APPLE_Y DCD 0
IS_EATEN DCD 0
SNAKE_ENDPTR DCD 0
HEAD_DIRECTION DCD 0 
BUTTON_PRESSED DCD 0  ;0 FOR NO CHANGE ,1 FOR LEFT , 2 FOR RIGHT
RANDOM_X DCB 4
RANDOM_Y DCB 4
INVISIBLE_X DCW 40
INVISIBLE_Y_UP DCW 40
INVISIBLE_Y_DOWN DCW 80
BULLET_LOCATIONS DCW 0,0,0,0,0
BULLET_Y_LOCATIONS DCW 0,0,0,0,0
DWARF_LOCATION DCW 0,0,0
OBSTACLE_DIRECTION DCW 0,0,0,0
OBSTACLE_HEIGHT DCW 0,0,0,0
TOGGLEB DCW 0
	AREA defs, CODE, READONLY
;#####################################################################################################################################################################
LCD_WRITE
	;this function takes what is inside r2 and writes it to the tft
	;this function writes 8 bits only
	;later we will choose whether those 8 bits are considered a command, or just pure data
	;your job is to just write 8-bits (regardless if data or command) to PE0-7 and set WR appropriately
	;arguments: R2 = data to be written to the D0-7 bus

	;TODO: PUSH THE NEEDED REGISTERS TO SAVE THEIR CONTENTS. HINT: Push any register you will modify inside the function
	PUSH {r0-r3, LR}


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING WR to 0 ;;;;;;;;;;;;;;;;;;;;;
	;TODO: RESET WR TO 0
	LDR r1,=GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	LSL R3, #11
	MVN R3, R3
	AND r0, r0, R3
	STRH r0, [r1]

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;;;;;;;;;;;;; HERE YOU PUT YOUR DATA which is in R2 TO PE0-7 ;;;;;;;;;;;;;;;;;
	;TODO: SET PE0-7 WITH THE LOWER 8-bits of R2
	LDR r1,=GPIOA_ODR
	STRB r2, [r1]			;only write the lower byte to PE0-7
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING WR to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET WR TO 1 AGAIN (ie make a rising edge)
	LDR r1,=GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #11
	STRH r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;TODO: POP THE REGISTERS YOU JUST PUSHED.
	POP {R0-r3, PC}
;#####################################################################################################################################################################











;#####################################################################################################################################################################
LCD_COMMAND_WRITE
	;this function writes a command to the TFT, the command is read from R2
	;it writes LOW to RS first to specify that we are writing a command not data.
	;then it normally calls the function LCD_WRITE we just defined above
	;arguments: R2 = data to be written on D0-7 bus

	;TODO: PUSH ANY NEEDED REGISTERS
	PUSH {R0-R3, LR}
	


	;TODO: SET RD HIGH (we won't need reading anyways, but we must keep read pin to high, which means we will not read anything)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #10
	STRH r0, [r1]

	;;;;;;;;;;;;;;;;;;;;;;;;; SETTING RS to 0 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RS TO 0 (to specify that we are writing commands not data on the D0-7 bus)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	LSL R3, #12
	MVN R3, R3
	AND r0, r0, R3
	STRH r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;TODO: CALL FUNCTION LCD_WRITE
	BL LCD_WRITE


	;TODO: POP ALL REGISTERS YOU PUSHED
	POP {R0-R3, PC}
;#####################################################################################################################################################################






;#####################################################################################################################################################################
LCD_DATA_WRITE
	;this function writes Data to the TFT, the data is read from R2
	;it writes HIGH to RS first to specify that we are writing actual data not a command.
	;arguments: R2 = data

	;TODO: PUSH ANY NEEDED REGISTERS
	PUSH {R0-R3, LR}

	;TODO: SET RD TO HIGH (we don't need to read anything)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #10
	STRH r0, [r1]

	;;;;;;;;;;;;;;;;;;;; SETTING RS to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RS TO 1 (to specify that we are sending actual data not a command on the D0-7 bus)
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #12
	STRH r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;TODO: CALL FUNCTION LCD_WRITE
	BL LCD_WRITE

	;TODO: POP ANY REGISTER YOU PUSHED
	POP {R0-R3, PC}
;#####################################################################################################################################################################




; REVISE WITH YOUR TA THE LAST 3 FUNCTIONS (LCD_WRITE, LCD_COMMAND_WRITE AND LCD_DATA_WRITE BEFORE PROCEEDING)




;#####################################################################################################################################################################
LCD_INIT
	;This function executes the minimum needed LCD initialization measures
	;Only the necessary Commands are covered
	;Eventho there are so many more in the DataSheet

	;TODO: PUSH ANY NEEDED REGISTERS
  	PUSH {R0-R3, LR}

	;;;;;;;;;;;;;;;;; HARDWARE RESET (putting RST to high then low then high again) ;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RESET PIN TO HIGH
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #8
	STRH r0, [r1]
	
	
	;TODO: DELAY FOR SOME TIME
	BL delay_1_second

	;TODO: RESET RESET PIN TO LOW
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	LSL R3, #8
	MVN R3, R3
	AND r0, r0, R3
	STRH r0, [r1]

	;TODO: DELAY FOR SOME TIME
	BL delay_10_milli_second

	;TODO: SET RESET PIN TO HIGH AGAIN
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #8
	STRH r0, [r1]

	;TODO: DELAY FOR SOME TIME
	BL delay_1_second
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






	;;;;;;;;;;;;;;;;; PREPARATION FOR WRITE CYCLE SEQUENCE (setting CS to high, then configuring WR and RD, then resetting CS to low) ;;;;;;;;;;;;;;;;;;
	;TODO: SET CS PIN HIGH
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #15
	STR r0, [r1]

	;TODO: SET WR PIN HIGH
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #11
	STRH r0, [r1]

	;TODO: SET RD PIN HIGH
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	ORR r0, r0, R3, LSL #10
	STRH r0, [r1]

	;TODO: SET CS PIN LOW
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	MOV R3, #1
	LSL R3, #15
	MVN R3, R3
	AND r0, r0, R3
	STR r0, [r1]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SOFTWARE INITIALIZATION SEQUENCE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: ISSUE THE "SET CONTRAST" COMMAND, ITS HEX CODE IS 0xC5
	MOV R2, #0xC5
	BL LCD_COMMAND_WRITE

	;THIS COMMAND REQUIRES 2 PARAMETERS TO BE SENT AS DATA, THE VCOM H, AND THE VCOM L
	;WE WANT TO SET VCOM H TO A SPECIFIC VOLTAGE WITH CORRESPONDS TO A BINARY CODE OF 1111111 OR 0x7F HEXA
	;TODO: SEND THE FIRST PARAMETER (THE VCOM H) NEEDED BY THE COMMAND, WITH HEX 0x7F, PARAMETERS ARE SENT AS DATA BUT COMMANDS ARE SENT AS COMMANDS
	MOV R2, #0x7F
	BL LCD_DATA_WRITE

	;WE WANT TO SET VCOM L TO A SPECIFIC VOLTAGE WITH CORRESPONDS TO A BINARY CODE OF 00000000 OR 0x00 HEXA
	;TODO: SEND THE SECOND PARAMETER (THE VCOM L) NEEDED BY THE CONTRAST COMMAND, WITH HEX 0x00, PARAMETERS ARE SENT AS DATA BUT COMMANDS ARE SENT AS COMMANDS
	MOV R2, #0x00
	BL LCD_DATA_WRITE


	;MEMORY ACCESS CONTROL AKA MADCLT | DATASHEET PAGE 127
	;WE WANT TO SET MX (to draw from left to right) AND SET MV (to configure the TFT to be in horizontal landscape mode, not a vertical screen)
	;TODO: ISSUE THE COMMAND MEMORY ACCESS CONTROL, HEXCODE 0x36
	MOV R2, #0x36
	BL LCD_COMMAND_WRITE

	;TODO: SEND ONE NEEDED PARAMETER ONLY WITH MX AND MV SET TO 1. HOW WILL WE SEND PARAMETERS? AS DATA OR AS COMMAND?
	MOV R2, #0x28
	BL LCD_DATA_WRITE



	;COLMOD: PIXEL FORMAT SET | DATASHEET PAGE 134
	;THIS COMMAND LETS US CHOOSE WHETHER WE WANT TO USE 16-BIT COLORS OR 18-BIT COLORS.
	;WE WILL ALWAYS USE 16-BIT COLORS
	;TODO: ISSUE THE COMMAND COLMOD
	MOV R2, #0x3A
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE NEEDED PARAMETER WHICH CORRESPONDS TO 16-BIT RGB AND 16-BIT MCU INTERFACE FORMAT
	MOV R2, #0x55
	BL LCD_DATA_WRITE
	


	;SLEEP OUT | DATASHEET PAGE 101
	;TODO: ISSUE THE SLEEP OUT COMMAND TO EXIT SLEEP MODE (THIS COMMAND TAKES NO PARAMETERS, JUST SEND THE COMMAND)
	MOV R2, #0x11
	BL LCD_COMMAND_WRITE

	;NECESSARY TO WAIT 5ms BEFORE SENDING NEXT COMMAND
	;I WILL WAIT FOR 10MSEC TO BE SURE
	;TODO: DELAY FOR AT LEAST 10ms
	BL delay_1_second


	;DISPLAY ON | DATASHEET PAGE 109
	;TODO: ISSUE THE COMMAND, IT TAKES NO PARAMETERS
	MOV R2, #0x29
	BL LCD_COMMAND_WRITE


	;COLOR INVERSION OFF | DATASHEET PAGE 105
	;NOTE: SOME TFTs HAS COLOR INVERTED BY DEFAULT, SO YOU WOULD HAVE TO INVERT THE COLOR MANUALLY SO COLORS APPEAR NATURAL
	;MEANING THAT IF THE COLORS ARE INVERTED WHILE YOU ALREADY TURNED OFF INVERSION, YOU HAVE TO TURN ON INVERSION NOT TURN IT OFF.
	;TODO: ISSUE THE COMMAND, IT TAKES NO PARAMETERS
	;MOV R2, #0x21
	;BL LCD_COMMAND_WRITE



	;MEMORY WRITE | DATASHEET PAGE 245
	;WE NEED TO PREPARE OUR TFT TO SEND PIXEL DATA, MEMORY WRITE SHOULD ALWAYS BE ISSUED BEFORE ANY PIXEL DATA SENT
	;TODO: ISSUE MEMORY WRITE COMMAND
	MOV R2, #0x2C
	BL LCD_COMMAND_WRITE	


	;TODO: POP ALL PUSHED REGISTERS
	POP {R0-R3, PC}

;#####################################################################################################################################################################
  

	B SKIP_THIS_LINE2
	LTORG
SKIP_THIS_LINE2

; REVISE THE FUNCTION LCD_INIT WITH YOUR TA BEFORE PROCEEDING



;#####################################################################################################################################################################
ADDRESS_SET
	;THIS FUNCTION TAKES X1, X2, Y1, Y2
	;IT ISSUES COLUMN ADDRESS SET TO SPECIFY THE START AND END COLUMNS (X1 AND X2)
	;IT ISSUES PAGE ADDRESS SET TO SPECIFY THE START AND END PAGE (Y1 AND Y2)
	;THIS FUNCTION JUST MARKS THE PLAYGROUND WHERE WE WILL ACTUALLY DRAW OUR PIXELS, MAYBE TARGETTING EACH PIXEL AS IT IS.
	;R0 = X1
	;R1 = X2
	;R3 = Y1
	;R4 = Y2

	;PUSHING ANY NEEDED REGISTERS
	PUSH {R0-R4, LR}
	

	;COLUMN ADDRESS SET | DATASHEET PAGE 110
	MOV R2, #0x2A
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE FIRST PARAMETER (HIGHER 8-BITS OF THE STARTING COLUMN, AKA HIGHER 8-BITS OF X1)
	MOV R2, R0
	LSR R2, #8
	BL LCD_DATA_WRITE

	;TODO: SEND THE SECOND PARAMETER (LOWER 8-BITS OF THE STARTING COLUMN, AKA LOWER 8-BITS OF X1)
	MOV R2, R0
	BL LCD_DATA_WRITE


	;TODO: SEND THE THIRD PARAMETER (HIGHER 8-BITS OF THE ENDING COLUMN, AKA HIGHER 8-BITS OF X2)
	MOV R2, R1
	LSR R2, #8
	BL LCD_DATA_WRITE

	;TODO: SEND THE FOURTH PARAMETER (LOWER 8-BITS OF THE ENDING COLUMN, AKA LOWER 8-BITS OF X2)
	MOV R2, R1
	BL LCD_DATA_WRITE



	;PAGE ADDRESS SET | DATASHEET PAGE 110
	MOV R2, #0x2B
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE FIRST PARAMETER (HIGHER 8-BITS OF THE STARTING PAGE, AKA HIGHER 8-BITS OF Y1)
	MOV R2, R3
	LSR R2, #8
	BL LCD_DATA_WRITE

	;TODO: SEND THE SECOND PARAMETER (LOWER 8-BITS OF THE STARTING PAGE, AKA LOWER 8-BITS OF Y1)
	MOV R2, R3
	BL LCD_DATA_WRITE


	;TODO: SEND THE THIRD PARAMETER (HIGHER 8-BITS OF THE ENDING PAGE, AKA HIGHER 8-BITS OF Y2)
	MOV R2, R4
	LSR R2, #8
	BL LCD_DATA_WRITE

	;TODO: SEND THE FOURTH PARAMETER (LOWER 8-BITS OF THE ENDING PAGE, AKA LOWER 8-BITS OF Y2)
	MOV R2, R4
	BL LCD_DATA_WRITE

	;MEMORY WRITE
	MOV R2, #0x2C
	BL LCD_COMMAND_WRITE


	;POPPING ALL REGISTERS I PUSHED
	POP {R0-R4, PC}

;#####################################################################################################################################################################	
SETUP
	;THIS FUNCTION ENABLES PORT E, MARKS IT AS OUTPUT, CONFIGURES SOME GPIO
	;THEN FINALLY IT CALLS LCD_INIT (HINT, USE THIS SETUP FUNCTION DIRECTLY IN THE MAIN)
	PUSH {R0-R12, LR}


	LDR r0, = RCC_AHB1ENR
	ldr r1, [r0]
	mov r2, #1
	orr r1,r1,r2
	str r1,[r0]
	
	LDR r0, =AFIO_MAPR
	mov r2, #1
	lsl r2, #25
	str r2, [r0]
	
	
	;Make the clock affect port E by enabling the corresponding bit (the third bit) in RCC_AHB1ENR register
	LDR r1, =RCC_AHB1ENR
	LDR r0,=0x1C
	
	STR r0, [r1]
	
	
	;Make the GPIO E mode as output (01 for each pin)
	LDR r0, =GPIOA_BASE
	mov32 r1, #0x33333333
	STR r1, [r0]
	
	LDR r0, =GPIOB_BASE
	mov32 r1, #0x33333333
	STR r1, [r0]
	;Make the Output type as Push-Pull not Open-drain, by clearing all the bits in the lower 2 bytes of OTYPE register, the higher 2 bytes are reserved.
	
	LDR r0, =GPIOC_CRH
	mov32 r1, #0x88800000
	STR r1, [r0]
	
	LDR r0, =GPIOC_ODR
	mov32 r1, #0x0000E000
	str r1,[r0]
	;Make the Output speed as super fast by clearing all the bits in the OSPEED register
	;00 means slow
	;01 means medium
	;10 means fast
	;11 means super fast
	;2 bits for each pin and we will choose slow
	;this register just scales the time of flipping from low to high or from high to low.
	;Clear the Pullup-pulldown bits for each port, we don't need the internal resistors
    ;clearing port a bits
	
	LDR r0, =GPIOB_ODR
	LDR r1, [r0]
	mov32 r4, #0x00007F00
	ORR r1, r4
	STR r1, [r0]
	

	BL LCD_INIT

	POP {R0-R12, PC}
	
;##########################################################################################################################################
DRAW_RECTANGLE_FILLED
	;TODO: IMPLEMENT THIS FUNCTION ENTIRELY, AND SPECIFY THE ARGUMENTS IN COMMENTS, WE DRAW A RECTANGLE BY SPECIFYING ITS TOP-LEFT AND LOWER-RIGHT POINTS, THEN FILL IT WITH THE SAME COLOR
	;X1 = [] r0
	;Y1 = [] r1
	;X2 = [] r3
	;Y2 = [] r4
	;COLOR = [] r10
	
	
	PUSH {R0-R12, LR}
	
	push{r0-r4}


	PUSH {R1}
	PUSH {R3}
	
	pop {r1}
	pop {r3}
	
	;THE NEXT FUNCTION TAKES x1, x2, y1, y2
	;R0 = x1
	;R1 = y1
	;R3 = x2
	;R4 = y2
	bl ADDRESS_SET
	
	pop{r0-r4}
	

	SUBS R3, R3, R0
	add r3, r3, #1
	SUBS R4, R4, R1
	add r4, r4, #1
	MUL R3, R3, R4


;MEMORY WRITE
	MOV R2, #0x2C
	BL LCD_COMMAND_WRITE


RECT_FILL_LOOP
	MOV R2, R10
	LSR R2, #8
	BL LCD_DATA_WRITE
	MOV R2, R10
	BL LCD_DATA_WRITE

	SUBS R3, R3, #1
	CMP R3, #0
	BGT RECT_FILL_LOOP


END_RECT_FILL
	POP {R0-R12, PC}
;##########################################################################################################################################






   b SKIP_THIS_LINE3
   LTORG
SKIP_THIS_LINE3




;#####################################################################################################################################################################
;#####################################################################################################################################################################
DRAWPIXEL
	PUSH {R0-R5, r10, LR}
	;THIS FUNCTION TAKES X AND Y AND A COLOR AND DRAWS THIS EXACT PIXEL
	;NOTE YOU HAVE TO CALL ADDRESS SET ON A SPECIFIC PIXEL WITH LENGTH 1 AND WIDTH 1 FROM THE STARTING COORDINATES OF THE PIXEL, THOSE STARTING COORDINATES ARE GIVEN AS PARAMETERS
	;THEN YOU SIMPLY ISSUE MEMORY WRITE COMMAND AND SEND THE COLOR
	;R0 = X
	;R1 = Y
	;R10 = COLOR

	;CHIP SELECT ACTIVE, WRITE LOW TO CS
	LDR r3, =GPIOB_ODR
	LDR r4, [r3]
	MOV R5, #1
	LSL R5, #15
	MVN R5, R5
	AND r4, r4, R5
	STR r4, [r3]

	;TODO: SETTING PARAMETERS FOR FUNC 'ADDRESS_SET' CALL, THEN CALL FUNCTION ADDRESS SET
	;NOTE YOU MIGHT WANT TO PERFORM PARAMETER REORDERING, AS ADDRESS SET FUNCTION TAKES X1, X2, Y1, Y2 IN R0, R1, R3, R4 BUT THIS FUNCTION TAKES X,Y IN R0 AND R1
	MOV R3, R1 ;Y1
	ADD R1, R0, #1 ;X2
	ADD R4, R3, #1 ;Y2
	BL ADDRESS_SET


	
	;MEMORY WRITE
	MOV R2, #0x2C
	BL LCD_COMMAND_WRITE


	;SEND THE COLOR DATA | DATASHEET PAGE 114
	;HINT: WE SEND THE HIGHER 8-BITS OF THE COLOR FIRST, THEN THE LOWER 8-BITS
	;HINT: WE SEND THE COLOR OF ONLY 1 PIXEL BY 2 DATA WRITES, THE FIRST TO SEND THE HIGHER 8-BITS OF THE COLOR, THE SECOND TO SEND THE LOWER 8-BITS OF THE COLOR
	;REMINDER: WE USE 16-BIT PER PIXEL COLOR
	;TODO: SEND THE SINGLE COLOR, PASSED IN R10
	MOV R2, R10
	LSR R2, #8
	BL LCD_DATA_WRITE
	MOV R2, R10
	BL LCD_DATA_WRITE


	
	POP {R0-R5, r10, PC}
;#####################################################################################################################################################################
get_action_button_1
	push{r1-r12,lr}
	LDR r5, =GPIOC_IDR
	LDR r0, [r5]
	LSR r0,#0x0D
	AND r0,#0x01
	pop{r1-r12,pc}

;##########################################################################################################################################
delay_1_second
	;this function just delays for 1 second
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop
	SUBS r8, #1
	CMP r8, #0
	BGE delay_loop
	POP {R8, PC}
;##########################################################################################################################################




;##########################################################################################################################################
delay_half_second
	;this function just delays for half a second
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop1
	SUBS r8, #2
	CMP r8, #0
	BGE delay_loop1

	POP {R8, PC}
;##########################################################################################################################################


;##########################################################################################################################################
delay_milli_second
	;this function just delays for a millisecond
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop2
	SUBS r8, #1000
	CMP r8, #0
	BGE delay_loop2

	POP {R8, PC}
;##########################################################################################################################################
delay_100_milli_second
	;this function just delays for a millisecond
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop4
	SUBS r8, #10
	CMP r8, #0
	BGE delay_loop4

	POP {R8, PC}

;##########################################################################################################################################

delay_50_milli_second
	push {lr}
	BL delay_10_milli_second
	BL delay_10_milli_second
	BL delay_10_milli_second
	BL delay_10_milli_second
	BL delay_10_milli_second
	pop{pc}
	
;##########################################################################################################################################
delay_10_milli_second
	;this function just delays for 10 millisecondS
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop3
	SUBS r8, #100
	CMP r8, #0
	BGE delay_loop3

	POP {R8, PC}
;##########################################################################################################################################


	END