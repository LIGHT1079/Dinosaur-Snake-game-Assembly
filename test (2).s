	AREA MYDATA, DATA, READONLY


RCC_AHB1ENR EQU 0x40021018 ;this register is responsible for enabling certain ports, by making the clock affect the target port.

GPIOA_BASE EQU 0x40010800	;Base of port E
;this is where you write your data as an output into the port
GPIOA_ODR EQU 0x4001080C    ;output register of port E, PE0 - PE15
	;as output
GPIOB_BASE EQU 0x40010C04	;Base of port E
;this is where you write your data as an output into the port
GPIOB_ODR EQU 0x40010C0C


;odr = base+0x0C



INTERVAL EQU 0x186004		;just a number to perform the delay. this number takes roughly 1 second to decrement until it reaches 0
BASE EQU 0x140
HEIGHT EQU 0x0F0	

	

;the following are pins connected from the TFT to our EasyMX board
;RD = PE10		Read pin	--> to read from touch screen input 
;WR = PE11		Write pin	--> to write data/command to display
;RS = PE12		Command pin	--> to choose command or data to write
;CS = PE15		Chip Select	--> to enable the TFT, lol	(active low)
;RST= PE8		Reset		--> to reset the TFT (active low)
;D0-7 = PE0-7	Data BUS	--> Put your command or data on this bus



;just some color codes, 16-bit colors coded in RGB 565
BLACK	EQU   	0x0000
BLUE 	EQU  	0x001f
RED  	EQU  	0xf800
RED2   	EQU 	0x0002
GREEN 	EQU  	0x07e0
CYAN  	EQU     0x07ff
MAGENTA EQU 	0xf81f
YELLOW	EQU  	0xffe0
WHITE 	EQU  	0xFFFf
GREEN2 	EQU 	0x3d67
CYAN2 	EQU  	0xff70
BLUE2   EQU     0x0014
ORANGE  EQU     0xfda0
BROWN EQU       0xbbaa
SKIN    EQU     0xffc8

	EXPORT __main
	
	

	AREA	MYCODE, CODE, READONLY
	ENTRY
	
__main FUNCTION

	;This is the main funcion, you should only call two functions, one that sets up the TFT
	;And the other that draws a rectangle over the entire screen (ie from (0,0) to (320,240)) with a certain color of your choice


	;FINAL TODO: CALL FUNCTION SETUP
	BL SETUP


	
	BL DRAW_BACKGROUND_DWARF_GAME2
	LDR r0,=25
	LDR r1,=240
	BL DRAW_DWARF
	LDR r0,=100
	LDR r1,=30
	BL DRAW_OBSTACLES
	LDR r0,=170
	LDR r1,=15
	BL DRAW_OBSTACLES
	LDR r0,=260
	LDR r1,=30
	BL DRAW_OBSTACLES
	LDR r0,=110
	LDR r1,=100
	BL DRAW_BULLET
	LDR r0,=150
	LDR r1,=110
	BL DRAW_BULLET
	LDR r0,=200
	LDR r1,=80
	BL DRAW_BULLET
	LDR r0,=250
	LDR r1,=100
	BL DRAW_BULLET
	LDR r0,=300
	LDR r1,=90
	BL DRAW_BULLET
	BL DRAW_SCORE_DWARF
	;LDR r10, =RED
	;LDR r0,=200
	;LDR r1,=100
	;bl DRAW_APPLE
	;LDR r10, = BLUE
	;LDR r0,=50
	;LDR r1,=70
	;bl DRAW_CARROT
	;ldr r1, =50
	;bl DRAW_HEALTHBAR
	;bl DRAW_SNAKE
	;ldr r0, =120
	;ldr r1, =180
	;bl DRAW_POWERUP
	;bl DRAW_SCORE
	ENDFUNC











;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ FUNCTIONS' DEFINITIONS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@







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


;	REVISE THE PREVIOUS TWO FUNCTIONS (ADDRESS_SET AND DRAW_PIXEL) WITH YOUR TA BEFORE PROCEEDING








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













;#####################################################################################################################################################################
SETUP
	;THIS FUNCTION ENABLES PORT E, MARKS IT AS OUTPUT, CONFIGURES SOME GPIO
	;THEN FINALLY IT CALLS LCD_INIT (HINT, USE THIS SETUP FUNCTION DIRECTLY IN THE MAIN)
	PUSH {R0-R12, LR}

	;Make the clock affect port E by enabling the corresponding bit (the third bit) in RCC_AHB1ENR register
	LDR r1, =RCC_AHB1ENR
	LDR r0,=0x0C
	
	STR r0, [r1]
	
	
	;Make the GPIO E mode as output (01 for each pin)
	LDR r0, =GPIOA_BASE
	mov r1, #0x33333333
	STR r1, [r0]
	
	LDR r0, =GPIOB_BASE
	mov r1, #0x33333333
	STR r1, [r0]
	;Make the Output type as Push-Pull not Open-drain, by clearing all the bits in the lower 2 bytes of OTYPE register, the higher 2 bytes are reserved.
	
	
	;Make the Output speed as super fast by clearing all the bits in the OSPEED register
	;00 means slow
	;01 means medium
	;10 means fast
	;11 means super fast
	;2 bits for each pin and we will choose slow
	;this register just scales the time of flipping from low to high or from high to low.
	
	
	
	;Clear the Pullup-pulldown bits for each port, we don't need the internal resistors
	


    ;clearing port a bits
	LDR r1, =GPIOB_ODR
	LDR r0, [r1]
	ORR r0, #0x00007F00
	STRH r0, [r1]
	

	BL LCD_INIT

	POP {R0-R12, PC}
;#####################################################################################################################################################################

DRAW_BACKGROUND
    push{r0-r12,lr}
	LDR r10,=YELLOW
	LDR r0,=0x0
	LDR r3,=BASE
	LDR r1,=0x0
	LDR r4,=0x0D0
	BL DRAW_RECTANGLE_FILLED
	LDR r10,=GREEN2
	LDR r0,=0x0
	LDR r3,=BASE
	LDR r1,=0x0D0
	LDR r4,=HEIGHT
	BL DRAW_RECTANGLE_FILLED
	LDR r10, =BLUE2
	LDR r0, =0
	LDR r1, =0
	LDR r3, =320
	LDR r4, =2
	bl DRAW_RECTANGLE_FILLED
	LDR r1, =238
	LDR r4, =240
	bl DRAW_RECTANGLE_FILLED
	LDR r1,=0
	LDR r3, =2
	LDR r4, =240
	bl DRAW_RECTANGLE_FILLED
	LDR r0, =318
	LDR r3, =320
	LDR r1, =0
	LDR r4, =240
	bl DRAW_RECTANGLE_FILLED
	LDR r10, =BLACK
	LDR r0, =0
	LDR r3, =320
	LDR r1, =0x0D0
	mov r4,r1
	ADD r4,r4,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	LTORG

;##########################################################################################################################################
DRAW_BACKGROUND_DWARF_GAME2
    push{r0-r12,lr}
	
	ldr R0, =0 ;x1
	ldr R1, =0 ;y1
	ldr R3, =320 ;x2
	ldr R4, =120 ;y2
	LDR R10, =CYAN
	BL DRAW_RECTANGLE_FILLED
	
	
	
	ldr R0, =0 ;x1
	ldr R1, =121 ;y1
	ldr R3, =320 ;x2
	ldr R4, =240 ;y2
	LDR R10, =YELLOW
	BL DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}

;##########################################################################################################################################
DRAW_APPLE          ;this label draws the apples around the game
    push{r0-r12,lr}
	LDR r10, =RED  ;drawing the red parts fat then slim
	mov r3, r0
	ADD r3,r3,#8
	MOV r4, r1
	ADD r4,r4,#5
	bl DRAW_RECTANGLE_FILLED
	ADD r0,r0,#2
	ADD r3,r0,#4
	ADD r1,r1,#5
	ADD r4,r1,#3
	bl DRAW_RECTANGLE_FILLED
	LDR r10,=GREEN2   ;the green parts of the apple
	SUB r1,r1,#7
	SUB r4,r4,#8
	bl DRAW_RECTANGLE_FILLED
	ADD r0,r0,#2
	SUB r1,r1,#2
	SUB r4,r4,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}


; HELPER DELAYS IN THE SYSTEM, YOU CAN USE THEM DIRECTLY
DRAW_CARROT             ;this label draws the magic carrots in game
    push{r0-r12,lr}
	LDR r10, =ORANGE    ;the main part of the carrot
	mov r3, r0
	ADD r3,r3,#6
	MOV r4, r1
	ADD r4,r4,#8
	bl DRAW_RECTANGLE_FILLED
	SUB r3,r3,#3
	ADD r4,r4,#2
	bl DRAW_RECTANGLE_FILLED
	LDR r10, =GREEN2   ;the green aprt then
	ADD r0,r0,#3
	ADD r3,r3,#3
	SUB r1,r1,#2
	SUB r4,r4,#10
	bl DRAW_RECTANGLE_FILLED
	SUB r1,r1,#2
	ADD r0,r0,#1
	SUB r4,r4,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}

DRAW_POWERUP        ;this label draws the power ups around the game
   push{r0-r12,lr}
   LDR r10, =BLACK   ;draws the black part top left
   mov r3,r0 
   ADD r3,r3,#2
   mov r4,r1
   ADD r4,r4,#4
   bl DRAW_RECTANGLE_FILLED
   LDR r10, =WHITE    ;draws the white part to the right of black
   ADD r0,r0,#2
   ADD r3,r3,#2
   bl DRAW_RECTANGLE_FILLED
   LDR r10, =BLUE2    ;draws the main body of powerup
   SUB r0,r0,#2
   ADD r1,r1,#4
   ADD r4,r4,#10
   bl DRAW_RECTANGLE_FILLED
   LDR r10, =YELLOW     ;draws the yellow strip
   ADD r1,r1,#5
   sub r4,r4,#3
   bl DRAW_RECTANGLE_FILLED
   pop{r0-r12,pc}
   LTORG
	
DRAW_HEALTHBAR       ;draws the healthbar of the snake bottom right
   push{r0-r12,lr}
   LDR r10, =BLACK    ;draws outer rectangle
   LDR r0, =260
   LDR r1, =220
   LDR r3, =310
   LDR r4, =230
   bl DRAW_RECTANGLE_FILLED 
   LDR r10, =BLUE     ;draws the health bar
   ADD r0,r0,#2
   ADD r1,r1,#2
   SUB r3,r3,#18
   SUB r4,r4,#2
   bl DRAW_RECTANGLE_FILLED
   pop{r0-r12,pc}


DRAW_SCORE          ;draws the score word in game bottom left
   push{r0-r12,lr}
   LDR r10, =WHITE
   LDR r0, =8
   LDR r1, =218
   LDR r3, =14
   LDR r4, =220
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =8
   LDR r1, =218
   LDR r3, =10
   LDR r4, =222
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =10
   LDR r1, =222
   LDR r3, =14
   LDR r4, =224
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =12
   LDR r4, =228
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =8
   LDR r1, =226
   LDR r3, =14
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =16
   LDR r3, =22
   LDR r1, =218
   LDR r4, =220
   bl DRAW_RECTANGLE_FILLED
   LDR r3, =18
   LDR r4, =228
   bl DRAW_RECTANGLE_FILLED
   LDR r3, =22
   LDR r1, =226
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =24
   LDR r3, =31
   LDR r1, =218
   LDR r4, =220
   bl DRAW_RECTANGLE_FILLED
   LDR r3, =26
   LDR r4, =228
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =34
   LDR r3, =36
   LDR r1, =220
   LDR r4, =222
   bl DRAW_RECTANGLE_FILLED
   LDR r1, =226
   LDR r4, =228
   bl DRAW_RECTANGLE_FILLED
   pop{r0-r12,pc}



DRAW_SCORE_DWARF          ;draws the score word in game bottom left
   push{r0-r12,lr}
   LDR r10, =WHITE
   LDR r0, =8
   LDR r1, =12
   LDR r3, =14
   LDR r4, =14
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =8
   LDR r1, =12
   LDR r3, =10
   LDR r4, =16
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =10
   LDR r1, =16
   LDR r3, =14
   LDR r4, =18
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =12
   LDR r4, =22
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =8
   LDR r1, =20
   LDR r3, =14
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =16
   LDR r3, =22
   LDR r1, =12
   LDR r4, =14
   bl DRAW_RECTANGLE_FILLED
   LDR r3, =18
   LDR r4, =22
   bl DRAW_RECTANGLE_FILLED
   LDR r3, =22
   LDR r1, =20
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =24
   LDR r3, =31
   LDR r1, =12
   LDR r4, =14
   bl DRAW_RECTANGLE_FILLED
   LDR r3, =26
   LDR r4, =22
   bl DRAW_RECTANGLE_FILLED
   LDR r0, =34
   LDR r3, =36
   LDR r1, =14
   LDR r4, =16
   bl DRAW_RECTANGLE_FILLED
   LDR r1, =20
   LDR r4, =22
   bl DRAW_RECTANGLE_FILLED
   pop{r0-r12,pc}



SET_GREEN  ;sets color of snake pixel to green
  push {r12,lr}
  ldr r10, =GREEN
  pop {r12,pc}

SET_BLUE  ;sets color of snake pixel to blue
  push {r12,lr}
  ldr r10, =BLUE
  pop {r12,pc}
  
SWITCH_COLOR   ;toggles between blue and green pixels in snake body
   push{r12,lr}
   EOR r6,r6,#1
   cmp r6,#1
   beq SET_GREEN
   bne SET_BLUE
   pop{r12,pc}
   LTORG

   
SNAKE_BODY  ;draws snake body 
   PUSH{r12,lr}
SN   ;loop to draw the pattern of snakes body
   MOV r3,r0
   mov r4,r1
   ADD r4,r4,#2
   ADD r3,r3,#2
   bl DRAW_RECTANGLE_FILLED
   bl SWITCH_COLOR ;switches color between red and blue in body
   ADD r1,r1,#2
   ADD r4,r4,#2
   bl DRAW_RECTANGLE_FILLED
   SUB r1,r1,#2
   ADD r0,r0,#2
   cmp r0,#250
   blo SN
   pop{r12,pc}

SNAKE_HEAD  ;draw snake head
   push{r0-r12,lr}
   LDR r10, =GREEN2
   mov r3,r0
   SUB r0,r0,#12
   sub r3,r3,#2
   sub r1,r1,#4
   mov r4,r1
   ADD r4,r4,#12
   bl DRAW_RECTANGLE_FILLED  ;draws the outer green head
   sub r0,r0,#2
   ADD r1,r1,#2
   ADD r3,r3,#2
   mov r4,r1
   ADD r4,r4,#8
   bl DRAW_RECTANGLE_FILLED ;rest of outer green head
   LDR r10, =GREEN
   ADD r0,r0,#2
   sub r3,r3,#2
   bl DRAW_RECTANGLE_FILLED ;inner face of snake
   LDR r10, =BLACK
   ADD r0,r0,#2
   mov r3,r0
   mov r4,r1
   ADD r3,r3,#1
   ADD R4,R4,#1
   bl DRAW_RECTANGLE_FILLED  ;upper eye
   ADD r1,r1,#6
   ADD r4,r4,#6
   bl DRAW_RECTANGLE_FILLED  ;lower eye
   LDR r10, =RED
   ADD r0,r0,#4
   ADD r3,r3,#4
   bl DRAW_RECTANGLE_FILLED  ;mouth pixels
   ADD r0,r0,#2
   ADD r3,r3,#2
   sub r1,r1,#4
   sub r4,r4,#2
   bl DRAW_RECTANGLE_FILLED
   SUB r0,r0,#2
   sub r1,r1,#2
   sub r3,r3,#2
   sub r4,r4,#4
   bl DRAW_RECTANGLE_FILLED
   pop{r0-r12,pc}
   
DRAW_SNAKE        ;main draw snake label takes start point of top left of snake's body and draws it
   push{r0-r12,lr}
   ldr r10, =GREEN
   ldr r0, =100
   ldr r1, =50
   LDR R6, =1
   bl SNAKE_HEAD
   bl SNAKE_BODY
   pop{r0-r12,pc}


DRAW_DWARF  ; THIS FUNCTION TAKES THE BOTTOM LEFT POINT AT R0 AS START_X AND R1 AS START_Y AND DRAWS THE DWARF
            ; ASSUME R0 HAS THE BOTTOM LEFT POINT 'DWARF SHOES'
	PUSH {R0-R12 , LR}
  
	MOV R4,R1
	SUB R1,R4,#6  ;EXCHANGE TO MATCH WITH DRAW_RECT
	; DRAW FIRST SHOE
	ADD R3,R0,#9	
	LDR R10, =BLUE
	BL DRAW_RECTANGLE_FILLED
  
	;DRAW SECOND SHOE
	MOV R6,R0  ;KEEP THE INITIAL VALUE OF X
	ADD R0,R3,#3
	ADD R3,R0,#9
	BL DRAW_RECTANGLE_FILLED
	
	;DRAW LEFT LEG
	MOV R0,R6
	MOV R4,R1
	SUB R1,R4,#12
    ADD R3,R0,#6
	BL DRAW_RECTANGLE_FILLED
	
	;DRAW RIGHT LEG
	MOV R6,R0
	ADD R0,R3,#6
	ADD R3,R0,#6
	BL DRAW_RECTANGLE_FILLED
	
	ADD R0,R6,#6
	ADD R3,R0,#6
	ADD R4,R1,#6
	BL DRAW_RECTANGLE_FILLED
	
	;DRAW THE RED PART OF T-SHIRT
	ADD R3,R3,#3
	MOV r9,r3
	SUB R0,R0,#3
	mov r8,r0
	SUB R1,R1,#9
	SUB R4,R4,#6
	LDR R10, =RED
	BL DRAW_RECTANGLE_FILLED
	
	;DRAW LEFT BLUE PART
	MOV R3,R0
	SUB R0,R0,#3
	LDR R10, =BLUE
	BL DRAW_RECTANGLE_FILLED
	
	;DRAW RIGHT BLUE PART
	ADD R0,R0,#15
	ADD R3,R0,#3
	BL DRAW_RECTANGLE_FILLED
	
	;DRAW THE RIGHT HAND
	ADD R0,R3,#1
	ADD R3,R3,#4
	ADD R1,R1,#3
	LDR R10, =SKIN  ;CHANGE THE WHITE COLOR TO SKIN COLOR
	BL DRAW_RECTANGLE_FILLED
	
	;DRAW THE LEFT HAND
	SUB R0,R6,#4
	ADD R3,R0,#3
	BL DRAW_RECTANGLE_FILLED
	
	;DRAW NECK
	MOV R0,R8
	MOV R3,R9
	SUB R1,R1,#6
	ADD R4,R1,#3
	LDR R10, =BLUE
	BL DRAW_RECTANGLE_FILLED
	;DRAW HEAD
	;HEAD NECK
	MOV R0,R8
	MOV R3,R9
	SUB r4,r1,#1
	sub r1,r4,#3
	LDR R10, =SKIN
	BL DRAW_RECTANGLE_FILLED
	MOV R0,R6
	ADD R3,R6,#18
	SUB r4,r1,#1
	sub r1,r4,#15
	mov r11,r1
	LDR R10, =SKIN
	BL DRAW_RECTANGLE_FILLED
	;EYES
	ADD R0,R6,#6
	ADD R3,R6,#8
	add r1,r1,#4
	add r4,r1,#5
	LDR R10, =WHITE
	BL DRAW_RECTANGLE_FILLED
	ADD R0,R6,#15
	ADD R3,R6,#17
	LDR R10, =WHITE
	BL DRAW_RECTANGLE_FILLED
	;CAP
	SUB R0,R6,#6
	ADD R3,R6,#24
	mov r1,r11
	ADD r4,r1,#2
	LDR R10, =RED
	BL DRAW_RECTANGLE_FILLED
CAPLOOP	
	BL DRAW_RECTANGLE_FILLED
	mov r4,r1
	sub r1,r1,#2
	ADD r0,r0,#2
	SUB r3,r3,#2
	CMP r0,r3
	BLO CAPLOOP
	POP {R0-R12, PC}

DRAW_BACKGROUND_DWARF_GAME
    push{r0-r12,lr}
	
	; DRAW UPPER LEVEL 
	ldr R0, =0 ;x1
	ldr R1, =0 ;y1
	ldr R3, =320 ;x2
	ldr R4, =120 ;y2
	LDR R10, =CYAN
	BL DRAW_RECTANGLE_FILLED
	;DRAW SOME CLOUDS
	ldr r0, =80
	ldr r3, =130
	ldr r1, =40
	ldr r4, =65
	ldr r10, =WHITE
	BL DRAW_RECTANGLE_FILLED
	ldr r0, =110
	ldr r3, =140
	ldr r1, =25
	ldr r4, =40
	BL DRAW_RECTANGLE_FILLED
	ldr r0, =70
	ldr r3, =100
	ldr r1, =65
	ldr r4, =80
	BL DRAW_RECTANGLE_FILLED
	
	
	ldr r0, =180
	ldr r3, =220
	ldr r1, =40
	ldr r4, =65
	ldr r10, =WHITE
	BL DRAW_RECTANGLE_FILLED
	
	ldr r0, =200
	ldr r3, =220
	ldr r1, =20
	ldr r4, =40
	BL DRAW_RECTANGLE_FILLED
	ldr r0, =170
	ldr r3, =180
	ldr r1, =65
	ldr r4, =70
	BL DRAW_RECTANGLE_FILLED
	
	;DRAW LOWER LEVEL
	ldr R0, =0 ;x1
	ldr R1, =121 ;y1
	ldr R3, =320 ;x2
	ldr R4, =240 ;y2
	LDR R10, =YELLOW
	BL DRAW_RECTANGLE_FILLED
	
	ldr r3, =211
	LDR R10, =CYAN ;change to brown
	BL DRAW_RECTANGLE_FILLED
	
	ldr r3, =201
	ldr r4, =210
	LDR R10, =CYAN2 ;change to dark brown
	
	ldr r3, =196
	ldr r4, =209
	LDR R10, =GREEN 
	BL DRAW_RECTANGLE_FILLED
	
	pop{r0-r12,pc}
	   
DRAW_OBSTACLES
	;THIS FUNCTION TAKES THE X COORDINATE AND THE HEIGHT OF THE OBSTACLE
	; R0 --> X_START
	; R1 --> HEIGHT
	push {r0-r12, LR}
    ADD R3,R0,#10  ;R3 --> END X
	MOV R4 ,#240
	SUB R1,R4,R1  ; R1 --> START Y
	LDR R10, =BLACK
	BL DRAW_RECTANGLE_FILLED
	POP {R0-R12, PC}
	;BL DRAW_RECTANGLE_FILLED
	;ldr R0, =70 ;x1
	;ldr R1, =100 ;y1
	;ldr R3, =73 ;x2
	;ldr R4, =102 ;y2
	;LDR R10, =BLUE
	;BL DRAW_RECTANGLE_FILLED
	;ldr R0, =73 ;x1
	;ldr R1, =98 ;y1
	;ldr R3, =76 ;x2
	;ldr R4, =102 ;y2
	;LDR R10, =BLUE
DRAW_BULLET
	;THIS FUNCTION TAKE START POINT BUTTOM LEFT AND HRIGHT
	;R0 =X1,R1=Y1,R3=X2,R4=Y2
	; R0 =X1 , HEIGHT=R4
	PUSH {R0-R12 , LR}
	MOV r5,r4
	mov r4,r1
	mov r1,r5
	SUB R1,R4,#2
	ADD R3,R0,#3
	LDR R10, =YELLOW
	BL DRAW_RECTANGLE_FILLED
	MOV R0,R3
	ADD R3, R0,#3
	SUB R1,R4,#4
	LDR R10, =BLACK
	BL DRAW_RECTANGLE_FILLED
	POP {R0-R12, PC}
	
DRAW_SCORE_DWARF3
	PUSH {R0-R12 , LR}
	ldr R0, =34 ;x1
	ldr R1, =10 ;y1
	ldr R3, =49 ;x2
	ldr R4, =13 ;y2
	LDR R10, =WHITE
	BL DRAW_RECTANGLE_FILLED
	
	ldr R0, =34 ;x1
	ldr R1, =16 ;y1
	ldr R3, =49 ;x2
	ldr R4, =19 ;y2
	LDR R10, =WHITE
	BL DRAW_RECTANGLE_FILLED
	
	ldr R0, =34 ;x1
	ldr R1, =10 ;y1
	ldr R3, =37 ;x2
	ldr R4, =25 ;y2
	LDR R10, =WHITE
	BL DRAW_RECTANGLE_FILLED
	
	ldr R0, =46 ;x1
	ldr R1, =13 ;y1
	ldr R3, =49 ;x2
	ldr R4, =19 ;y2
	LDR R10, =WHITE
	BL DRAW_RECTANGLE_FILLED

    ldr R0, =43 ;x1
	ldr R1, =19 ;y1
	ldr R3, =46 ;x2
	ldr R4, =25 ;y2
	LDR R10, =WHITE
	BL DRAW_RECTANGLE_FILLED
	POP {R0-R12, PC}

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






