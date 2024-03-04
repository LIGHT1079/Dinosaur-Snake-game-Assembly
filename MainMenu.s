	include dwarfgame.s
	EXPORT __main
			
	AREA MainMenu, CODE, READONLY
	ENTRY
	
DRAW_SNAKE_NAME
	push{r0-r12,lr}
	ldr r0, =20
	ldr r3, =90
	ldr r1, =115
	ldr r4, =135
	ldr r10,=BLACK
	bl DRAW_RECTANGLE_FILLED
	ldr r5, =MENU_BACKGROUND
	LDR r6, =BLACK
	str r6, [r5]
	ldr r5, =MENU_LETTER_COLOR
	LDR r6, =RED
	str r6, [r5]
	LDR R0, =27
	LDR R1, =120
	BL DRAW_S
	ADD R0,R0,#11
	BL DRAW_N
	ADD R0,R0,#13
	BL DRAW_A
	ADD R0,R0,#11
	BL DRAW_K
	ADD R0,R0,#11
	BL DRAW_E
	pop{r0-r12,pc}
	
DRAW_DINO_NAME
	push{r0-r12,lr}
	ldr r0, =20
	ldr r3, = 80
	ldr r1, =175
	ldr r4, = 195
	ldr r10, =BLACK
	bl DRAW_RECTANGLE_FILLED
	ldr r5, =MENU_BACKGROUND
	LDR r6, =BLACK
	str r6, [r5]
	ldr r5, =MENU_LETTER_COLOR
	LDR r6, =RED
	str r6, [r5]
	LDR R0, =27
	LDR R1, =180
	BL DRAW_D
	ADD R0,R0,#11
	BL DRAW_I
	ADD R0,R0,#11
	BL DRAW_N
	ADD R0,R0,#13
	BL DRAW_O
	pop{r0-r12,pc}
	
SELECT_DINO_NAME
	push{r0-r12,lr}
	ldr r0, =20
	ldr r3, = 80
	ldr r1, =175
	ldr r4, = 195
	ldr r10, =RED
	bl DRAW_RECTANGLE_FILLED
	ldr r5, =MENU_BACKGROUND
	ldr r6, [r5]
	mov r6, #RED
	str r6, [r5]
	ldr r5, =MENU_LETTER_COLOR
	ldr r6, [r5]
	mov r6, #BLACK
	str r6, [r5]
	LDR R0, =27
	LDR R1, =180
	BL DRAW_D
	ADD R0,R0,#11
	BL DRAW_I
	ADD R0,R0,#11
	BL DRAW_N
	ADD R0,R0,#13
	BL DRAW_O
	pop{r0-r12,pc}
	
SELECT_SNAKE_NAME
	push{r0-r12,lr}
	ldr r0, =20
	ldr r3, =90
	ldr r1, =115
	ldr r4, =135
	ldr r10,=RED
	bl DRAW_RECTANGLE_FILLED
	ldr r5, =MENU_BACKGROUND
	ldr r6, [r5]
	mov r6, #RED
	str r6, [r5]
	ldr r5, =MENU_LETTER_COLOR
	ldr r6, [r5]
	mov r6, #BLACK
	str r6, [r5]
	LDR R0, =27
	LDR R1, =120
	BL DRAW_S
	ADD R0,R0,#11
	BL DRAW_N
	ADD R0,R0,#13
	BL DRAW_A
	ADD R0,R0,#11
	BL DRAW_K
	ADD R0,R0,#11
	BL DRAW_E
	pop{r0-r12,pc}
	
	B SKIP_THIS_LINEPLS
	LTORG
SKIP_THIS_LINEPLS


DRAW_MAIN_MENU
	push{r0-r12,lr}
	ldr r10, =BLACK
	ldr r0, =0
	ldr r1, =000000
	ldr r3, =320
	ldr r4, =240
	bl DRAW_RECTANGLE_FILLED
	ldr r10,=RED
	add r4,r1,#3
	bl DRAW_RECTANGLE_FILLED
	ldr r4,=240
	add r3,r0,#3
	bl DRAW_RECTANGLE_FILLED
	ldr r1,=237
	ldr r3, =320
	bl DRAW_RECTANGLE_FILLED
	ldr r0, =317
	ldr r1, =0
	bl DRAW_RECTANGLE_FILLED
	
	bl DRAW_TITLE_CARD
	bl DRAW_SNAKE_NAME
	bl DRAW_DINO_NAME
	ldr r0, =110
	ldr r1, =210
	bl DRAW_SNAKE_SPEEDUP
	ADD R0,R0,#20
	BL DRAW_SNAKE_INVERT
	ADD R0,R0,#20
	BL DRAW_SNAKE_SPEEDDOWN
	ADD R0,R0,#20
	BL DRAW_SNAKE_SHIELD
	ADD R0,R0,#20
	BL DRAW_SNAKE_LIFE
	ADD R0,R0,#20
	BL DRAW_SNAKE_POWERUP
	pop{r0-r12,pc}
	
DRAW_N
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	ldr r10,[r5]
	add r3, r0,#10
	add r4, r1,#10
	bl DRAW_RECTANGLE_FILLED
	ldr r5, =MENU_BACKGROUND
	ldr r10,[r5]
	add r0,r0,#2
	add r3,r0,#2
	add r1,r1,#2
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#5
	add r3,r0,#1
	sub r1,r1,#2
	add r4,r1,#8
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}

DRAW_C
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	ldr r10,[r5]
	add r3, r0,#8
	add r4, r1,#2
	bl DRAW_RECTANGLE_FILLED
	sub r3,r3,#6
	add r4,r4,#6
	bl DRAW_RECTANGLE_FILLED
	add r1,r1,#8
	add r3,r3,#6
	add r4,r4,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
DRAW_O
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	ldr r10,[r5]
	add r3, r0,#8
	add r4, r1,#2
	bl DRAW_RECTANGLE_FILLED
	sub r3,r3,#6
	add r4,r4,#8
	bl DRAW_RECTANGLE_FILLED
	add r3,r3,#6
	add r1,r1,#8
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#6
	add r3,r0,#2
	sub r1,r1,#8
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
DRAW_M
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	ldr r10,[r5]
	add r3, r0,#12
	add r4, r1,#2
	bl DRAW_RECTANGLE_FILLED
	sub r3,r3,#10
	add r4,r4,#8
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#5
	add r3,r0,#2
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#5
	add r3,r0,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
DRAW_E
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	ldr r10,[r5]
	add r3, r0,#8
	add r4, r1,#2
	bl DRAW_RECTANGLE_FILLED
	sub r3,r3,#6
	add r4,r4,#8
	bl DRAW_RECTANGLE_FILLED
	add r3,r3,#6
	add r1,r1,#4
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	add r1,r1,#4
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
DRAW_W
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	ldr r10,[r5]
	add r3,r0,#12
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	ldr r5, =MENU_BACKGROUND
	ldr r10, [r5]
	add r0,r0,#3
	add r3,r0,#2
	add r4,r1,#8
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#5
	add r3,r0,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}

DRAW_L
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	ldr r10,[r5]
	add r3,r0,#2
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	add r1,r1,#8
	add r3,r0,#8
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
DRAW_H
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	ldr r10,[r5]
	add r3,r0,#8
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	ldr r5, =MENU_BACKGROUND
	ldrh r10, [r5]
	add r0,r0,#2
	add r3,r0,#4
	add r4,r1,#4
	bl DRAW_RECTANGLE_FILLED
	add r1,r1,#6
	add r4,r1,#4
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
DRAW_S
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	ldr r10,[r5]
	add r3,r0,#8
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	ldr r5, =MENU_BACKGROUND
	ldrh r10, [r5]
	add r0,r0,#2
	add r3,r0,#6
	add r1,r1,#2
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	sub r0,r0,#2
	add r3,r0,#6
	add r1,r1,#5
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}

DRAW_T
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	ldr r10,[r5]
	add r3,r0,#8
	add r4,r1,#3
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#3
	add r3,r0,#2
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
DRAW_A
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	ldr r10,[r5]
	add r3,r0,#8
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	add r1,r1,#4
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	add r3,r0,#2
	sub r1,r1,#4
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#6
	add r3,r0,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
	
DRAW_G
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	ldr r10,[r5]
	add r3,r0,#8
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	ldr r5, =MENU_BACKGROUND
	ldrh r10, [r5]
	add r0,r0,#2
	add r3,r0,#6
	add r1,r1,#2
	add r4,r1,#3
	bl DRAW_RECTANGLE_FILLED
	sub r3,r3,#4
	add r4,r1,#6
	bl DRAW_RECTANGLE_FILLED
	add r1,r1,#5
	add r3,r0,#4
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}

DRAW_K
	PUSH{R0-R12,LR}
	ldr r5, =MENU_LETTER_COLOR
	LDR R10,[R5]
	add r3,r0,#2
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#2
	add r3,r0,#2
	add r1,r1,#4
	add r4,r1,#4
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#2
	add r3,r0,#2
	add r1,r1,#2
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	sub r1,r1,#4
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#2
	add r3,r0,#2
	sub r1,r1,#2
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	add r1,r1,#8
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	POP{R0-R12,PC}

DRAW_D
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	ldr r10,[r5]
	add r3, r0,#8
	add r4, r1,#1
	bl DRAW_RECTANGLE_FILLED
	sub r3,r3,#6
	add r4,r4,#9
	bl DRAW_RECTANGLE_FILLED
	add r3,r3,#6
	add r1,r1,#9
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#7
	add r3,r0,#1
	sub r1,r1,#9
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
	b skip_this_line4
	LTORG
skip_this_line4

DRAW_I
	push{r0-r12,lr}
	LDR r5, =MENU_LETTER_COLOR
	LDR R10, [R5]
	add r3, r0,#8
	add r4, r1,#10
	bl DRAW_RECTANGLE_FILLED
	ldr r5, =MENU_BACKGROUND
	ldr r8, [r5]
	mov r10,r8
	add r1,r1,#2
	add r4,r1,#6
	add r3,r0,#2
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#6
	add r3,r0,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	

	
DRAW_TITLE_CARD
	push{r0-r12,lr}
	ldr r5, =MENU_BACKGROUND
	LDR R6, =BLACK
	STR R6,[R5]
	ldr r5, =MENU_LETTER_COLOR
	LDR R6, =RED
	STR R6,[R5]
	ldr r0, =30
	ldr r1, =40
	bl DRAW_W
	add r0,r0,#15
	bl DRAW_E
	add r0,r0,#11
	bl DRAW_L
	add r0,r0,#11
	bl DRAW_C
	add r0,r0,#11
	bl DRAW_O
	add r0,r0,#11
	bl DRAW_M
	add r0,r0,#15
	bl DRAW_E
	ldr r0, =30
	ldr r1, =60
	bl DRAW_S
	add r0,r0,#11
	bl DRAW_E
	add r0,r0,#11
	bl DRAW_L
	add r0,r0,#11
	bl DRAW_E
	add r0,r0,#11
	bl DRAW_C
	add r0,r0,#11
	bl DRAW_T
	add r0,r0,#15
	bl DRAW_A
	add r0,r0,#15
	bl DRAW_G
	add r0,r0,#11
	bl DRAW_A
	add r0,r0,#11
	bl DRAW_M
	add r0,r0,#15
	bl DRAW_E
	pop{r0-r12,pc}

WAIT_FOR_ACTION
	push{r0-r12,lr}
WAIT1
	LDR R0, =GPIOC_IDR
	LDR R1, [R0]
	LSR R1,#0X0D
	AND R1, #0X01
	LDR R2, =0X00
	CMP R1,R2
	BNE SKIP1
	BL SELECT_SNAKE_NAME
	BL delay_1_second
	B WAIT2
SKIP1
	LDR R0, =GPIOC_IDR
	LDR R1, [R0]
	LSR R1,#0X0E
	AND R1, #0X01
	LDR R2, =0X00
	CMP R1,R2
	BNE SKIP2
	BL SELECT_DINO_NAME
	BL delay_1_second
	b WAIT3
SKIP2
	B WAIT1
	
WAIT2
	LDR R0, =GPIOC_IDR
	LDR R1, [R0]
	LSR R1,#0X0D
	AND R1, #0X01
	LDR R2, =0X00
	CMP R1,R2
	BNE SKIP3
	BL MAIN_SNAKE
	B lol
SKIP3
	LDR R0, =GPIOC_IDR
	LDR R1, [R0]
	LSR R1,#0X0E
	AND R1, #0X01
	LDR R2, =0X00
	CMP R1,R2
	BNE SKIP4
	BL DRAW_SNAKE_NAME
	BL SELECT_DINO_NAME
	BL delay_1_second
	B WAIT3
SKIP4
	B WAIT2
	
WAIT3
	LDR R0, =GPIOC_IDR
	LDR R1, [R0]
	LSR R1,#0X0D
	AND R1, #0X01
	LDR R2, =0X00
	CMP R1,R2
	BNE SKIP5
	BL DRAW_DINO_NAME
	BL SELECT_SNAKE_NAME
	BL delay_1_second
	B WAIT2
SKIP5
	LDR R0, =GPIOC_IDR
	LDR R1, [R0]
	LSR R1,#0X0E
	AND R1, #0X01
	LDR R2, =0X00
	CMP R1,R2
	BNE SKIP6
	BL MAIN_DWARF
	B lol
	B WAIT3
SKIP6
	B WAIT3
	pop{r0-r12,pc}
	
INITIALIZE_VARIABLES
	PUSH{R0-R12,LR}
	LDR r6, =MENU_BACKGROUND
	LDRH r0,[r6]
	mov r0,#0x00
	STRH r0, [r6]
	
	LDR r6, =MENU_LETTER_COLOR
	LDRH r0,[r6]
	mov r0,#0xf801
	STRH r0, [r6]

	LDR r6, =SNAKE_HEALTH
	LDRH r0,[r6]
	mov r0,#0x03
	STRH r0, [r6]
	
	
	;SNAKE_HEAD_X  DCW 0
;SNAKE_HEAD_Y  DCW 0
;SNAKE_TAIL_X  DCW 0
;SNAKE_TAIL_Y  DCW 0
;SNAKE_DIRECTIONS DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;    SNAKE_HP  DCD 0
;SNAKE_TP DCD 0
    ldr r0,=SNAKE_DIRECTIONS
	
	ldr r1,=SNAKE_TP
	
	LDR R12,=SNAKE_ENDPTR
	
	ADD R5 , R0,#98
	
	STR R5,[R12]
	
	str r0,[r1] 
	
	ADD r0,r0,#5
	ldr r1,=SNAKE_HP
	
	str r0,[r1] 
	

	ldr r0,=SNAKE_TP 
	ldr r1,[r0]
	
	;directions  1 2 3 4
	;            L R U D
	MOV R2, #1
	STRB R2,[R1]
	MOV R2, #1 
	STRB R2, [R1,#1]
	MOV R2, #3
	STRB R2, [R1,#2]
	MOV R2, #3
	STRB R2, [R1,#3]
	MOV R2, #1
	STRB R2, [R1,#4]
	MOV R2, #1 
	STRB R2, [R1,#5]
	
	MOV R0,#84
	MOV R1,#84
	LDR R8,=SNAKE_HEAD_X
	LDR R9,=SNAKE_HEAD_Y
	
	
	STR R0,[R8]
	STR R1,[R9]
	
	ldr r8,=SNAKE_TAIL_X
	ldr r9,=SNAKE_TAIL_Y

	
	MOV R0,#108
	MOV R1,#100
	
	STR R0,[R8]
	STR R1,[R9]
	
	LDR R0,=HEAD_DIRECTION
	MOV R1,#1
	STR R1,[R0]
	
	LDR R0,=SNAKE_LENGTH
	MOV R1,#5
	STR R1,[R0]
	
	LDR R0,=APPLE_X 
	MOV R1,#100
	STR R1,[R0]
	
	LDR R0,=APPLE_Y 
	MOV R1,#100
	STR R1,[R0]
	
	LDR R0,=OBSTACLE_DIRECTION
	MOV R1,#20
	STR R1,[R0]
		
	ADD R0,R0,#2 
	MOV R1,#100
	STR R1,[R0]
	
	ADD R0,R0,#2 
	MOV R1,#210
	STR R1,[R0]
	
	ADD R0,R0,#2 
	MOV R1,#310
	STR R1,[R0]
	
	LDR R0,=OBSTACLE_HEIGHT
	LDR R1,=0
	STR R1,[R0]
	
	LDR R0,=OBSTACLE_HEIGHT
	LDR R1,=15
	STR R1,[R0]
	
	LDR R0,=OBSTACLE_HEIGHT
	LDR R1,=30
	STR R1,[R0]
	
	LDR R0,=OBSTACLE_HEIGHT
	LDR R1,=20
	STR R1,[R0]
	
	POP{R0-R12,PC}

;----------------------------------------------------------------------------------	
;----------------------------------------------------------------------------------	
;----------------------------------------------------------------------------------		

;-------------------------------------------------------------------------	
;----------------------------------------------------------------------------------	
;----------------------------------------------------------------------------------	
;----------------------------------------------------------------------------------	
;----------------------------------------------------------------------------------	
__main FUNCTION

	BL SETUP
RESET_MENU
	bl INITIALIZE_VARIABLES
	BL DRAW_MAIN_MENU
	BL WAIT_FOR_ACTION
	
lol
	LDR R0, =GPIOC_IDR
	LDR R1, [R0]
	LSR R1,#0X0D
	AND R1, #0X01
	LDR R2, =0X00
	CMP R1,R2
	bne skip7
	b RESET_MENU
skip7
	LDR R0, =GPIOC_IDR
	LDR R1, [R0]
	LSR R1,#0X0E
	AND R1, #0X01
	LDR R2, =0X00
	CMP R1,R2
	bne skip8
	b RESET_MENU
skip8
	LDR R0, =GPIOC_IDR
	LDR R1, [R0]
	LSR R1,#0X0F
	AND R1, #0X01
	LDR R2, =0X00
	CMP R1,R2
	bne skip9
	b RESET_MENU
skip9
	b lol
	ENDFUNC

	END