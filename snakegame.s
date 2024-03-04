	INCLUDE Definitions.s
		
	AREA	snake, CODE, READONLY

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ FUNCTIONS' DEFINITIONS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
DRAW_COORDINATES
	PUSH {LR}
	mov r6, r0
   mov r0, r3
   mov r3, r6
   mov r6, r1
   mov r1, r4
   mov r4, r6
	POP {pc}
;#####################################################################################################################################################################
DRAW_SNAKE_BACKGROUND
    push{r0-r12,lr}
	LDR r10,=YELLOW
	LDR r0,=0x0
	LDR r3,=BASE
	LDR r1,=0x0
	LDR r4,=0x0D0
	BL DRAW_RECTANGLE_FILLED
	LDR r10,=GREEN
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
	LDR r0, =2
	LDR r3, =318
	LDR r1, =0x0D0
	mov r4,r1
	ADD r4,r4,#3
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}

;##########################################################################################################################################
DRAW_APPLE          ;this label draws the apples around the game
    push{r0-r12,lr}
	LDR r10, =GREEN
	add r0,r0, #4
	ADD r3,r0, #1
	ADD r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	sub r0,r0,#1
	ADD r1,r1,#1
	ADD r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	LDR r10,=RED
	SUB r0,r0,#2
	ADD r3,r3,#2
	add r1,r1,#1
	add r4,r1,#3
	bl DRAW_RECTANGLE_FILLED
	ADD r0,r0,#2
	SUB r3,r3,#2
	add r1,r1,#3
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}


;#############################################################################################################################################
; HELPER DELAYS IN THE SYSTEM, YOU CAN USE THEM DIRECTLY
DRAW_CARROT             ;this label draws the magic carrots in game
    push{r0-r12,lr}
	LDR r10, =GREEN
	add r0,r0, #4
	ADD r3,r0, #1
	ADD r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	sub r0,r0,#1
	ADD r1,r1,#1
	ADD r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	ldr r10, =ORANGE
	sub r0,r0,#2
	add r1,r1,#1
	add r4,r1,#4
	bl DRAW_RECTANGLE_FILLED
	sub r3,r3,#2
	add r1,r1,#4
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
	
;#########################################################################################################################################
DRAW_SNAKE_POWERUP        ;this label draws the power ups around the game
   push{r0-r12,lr}
   ldr r10, =WHITE
   add r3,r0,#2
   add r4,r1,#2
   bl DRAW_RECTANGLE_FILLED
   ldr r10, =BLUE
   add r1,r1,#2
   add r4,r1,#6
   bl DRAW_RECTANGLE_FILLED
	ldr r10, =BROWN
	add r0,r0,#2
	add r3,r0,#2
	sub r1,r1,#2
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	ldr r10, =BLACK
	add r1,r1,#2
	add r4,r1,#6
	bl DRAW_RECTANGLE_FILLED
   pop{r0-r12,pc}
  
;#########################################################################################################################################
DRAW_SNAKE_INVERT
	push{r0-r12,lr}
	ldr r10, =MAGENTA
	add r0,r0,#1
	add r3,r0,#1
	add r4,r1,#7
	bl DRAW_RECTANGLE_FILLED
	sub r0,r0,#1
	add r3,r3,#1
	add r1,r1,#5
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#6
	add r3,r0,#1
	sub r1,r1,#5
	add r4,r1,#7
	bl DRAW_RECTANGLE_FILLED
	sub r0,r0,#1
	add r3,r3,#1
	add r1,r1,#1
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}

;#########################################################################################################################################
DRAW_SNAKE_SPEEDDOWN
	push{r0-r12,lr}
	ldr r10, =BLUE
	add r3,r0,#3
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	add r3,r0,#1
	add r4,r1,#4
	bl DRAW_RECTANGLE_FILLED
	add r1,r1,#4
	add r4,r1,#1
	add r3,r0,#3
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#2
	add r4,r1,#4
	bl DRAW_RECTANGLE_FILLED
	sub r0,r0, #2
	add r1,r1,#3
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	ldr r10, =GREEN
	add r0,r0,#6
	add r3,r0,#1
	sub r1,r1,#7
	add r4,r1,#8
	bl DRAW_RECTANGLE_FILLED
	sub r0,r0,#1
	add r3,r3,#1
	add r1,r1,#6
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}

;#########################################################################################################################################
DRAW_SNAKE_SHIELD
	push{r0-r12,lr}
	ldr r10, =BLUE
	add r0,r0,#2
	add r3,r0,#4
	add r4,r1,#8
	bl DRAW_RECTANGLE_FILLED
	sub r0,r0,#2
	add r3,r3,#2
	add r1,r1,#2
	sub r4,r4,#2
	bl DRAW_RECTANGLE_FILLED
	ldr r10, =RED
	add r3,r0,#1
	add r4,r1,#4
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#2
	add r3,r0,#4
	sub r1,r1,#2
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#5
	add r3,r0,#1
	add r1,r1,#2
	add r4,r1,#4
	bl DRAW_RECTANGLE_FILLED
	sub r0,r0,#5
	add r3,r0,#4
	add r1,r1,#5
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	sub r0,r0,#1
	sub r1,r1,#1
	add r3,r0,#1
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	sub r1,r1,#5
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#5
	add r3,r0,#1
	bl DRAW_RECTANGLE_FILLED
	add r1,r1,#5
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
;#########################################################################################################################################
DRAW_SNAKE_SPEEDUP
	push{r0-r12,lr}
	ldr r10, =BLUE
	add r3,r0,#3
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	add r3,r0,#1
	add r4,r1,#4
	bl DRAW_RECTANGLE_FILLED
	add r1,r1,#4
	add r4,r1,#1
	add r3,r0,#3
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#2
	add r4,r1,#4
	bl DRAW_RECTANGLE_FILLED
	sub r0,r0, #2
	add r1,r1,#3
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	ldr r10, =RED
	add r0,r0,#6
	add r3,r0,#1
	sub r1,r1,#7
	add r4,r1,#8
	bl DRAW_RECTANGLE_FILLED
	sub r0,r0,#1
	add r3,r3,#1
	add r1,r1,#1
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}

;#########################################################################################################################################
DRAW_SNAKE_LIFE
	push{r0-r12,lr}
	ldr r10, =RED
	add r0,r0,#1
	add r3,r0,#2
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#4
	add r3,r0,#2
	bl DRAW_RECTANGLE_FILLED
	sub r0,r0,#5
	add r3,r3,#1
	add r1,r1,#1
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#1
	sub r3,r3,#1
	add r1,r1,#2
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#1
	sub r3,r3,#1
	add r1,r1,#1
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#1
	sub r3,r3,#1
	add r1,r1,#1
	add r4,r1,#1
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
 
;#########################################################################################################################################
DRAW_SNAKE_HEALTHBAR       ;draws the healthbar of the snake bottom right
   push{r0-r12,lr}
   LDR r10, =BLACK    ;draws outer rectangle
   LDR r0, =238
   LDR r1, =220
   LDR r3, =308
   LDR r4, =230
   bl DRAW_RECTANGLE_FILLED 
   LDR r10, =RED    ;draws the health bar
   ldr r5, =SNAKE_HEALTH
   ldrh r7, [r5]
   ldr r6, =20
   mul r3, r7, r6
   add r3,r3,r0
   ldr r0, =243
   LDR R1, =222
   SUB r4,r4,#3
   bl DRAW_RECTANGLE_FILLED
   pop{r0-r12,pc}


;#########################################################################################################################################
DRAW_SNAKE_SCORE          ;draws the score word in game bottom left
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
;##########################################################################################################################################

DRAW_L_S
	push{r0-r12,lr}
	LDR r10, =RED
	add r3,r0,#2
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	add r1,r1,#8
	add r3,r0,#8
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}

;#########################################################################################################################################
DRAW_G_S
	push{r0-r12,lr}
	LDR r10, =RED
	add r3,r0,#8
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	ldr r10, =BLACK
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

;#########################################################################################################################################
DRAW_A_S
	push{r0-r12,lr}
	LDR r10, =RED
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
	
	
;#########################################################################################################################################
DRAW_O_S
	push{r0-r12,lr}
	LDR r10, =RED
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
	
	bl skip_this_line6
	LTORG
skip_this_line6


;#########################################################################################################################################
DRAW_M_S
	push{r0-r12,lr}
	LDR r10, =RED
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
	
;#########################################################################################################################################
DRAW_V_S
	push{r0-r12,lr}
	ldr r10, =RED
	add r3, r0, #1
	add r4, r1, #2
	bl DRAW_RECTANGLE_FILLED
	add r0, r0, #1
	add r1, r1, #2
	add r3, r0, #1
	add r4, r1, #2
	bl DRAW_RECTANGLE_FILLED
	add r0, r0, #1
	add r1, r1, #2
	add r3, r0, #1
	add r4, r1, #2
	bl DRAW_RECTANGLE_FILLED
	add r0, r0, #1
	add r1, r1, #2
	add r3, r0, #1
	add r4, r1, #2
	bl DRAW_RECTANGLE_FILLED
	add r0, r0, #1
	add r1, r1, #2
	add r3, r0, #1
	add r4, r1, #2
	bl DRAW_RECTANGLE_FILLED
	add r0, r0, #1
	sub r1, r1, #2
	add r3, r0, #1
	add r4, r1, #2
	bl DRAW_RECTANGLE_FILLED
	add r0, r0, #1
	sub r1, r1, #2
	add r3, r0, #1
	add r4, r1, #2
	bl DRAW_RECTANGLE_FILLED
	add r0, r0, #1
	sub r1, r1, #2
	add r3, r0, #1
	add r4, r1, #2
	bl DRAW_RECTANGLE_FILLED
	add r0, r0, #1
	sub r1, r1, #2
	add r3, r0, #1
	add r4, r1, #2
	bl DRAW_RECTANGLE_FILLED
	add r0, r0, #1
	add r1, r1, #2
	pop{r0-r12,pc}


;#########################################################################################################################################
DRAW_R_S
	push{r0-r12,lr}
	ldr r10, =RED
	add r3, r0, #8
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	add r3, r0, #3
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
;#########################################################################################################################################
DRAW_E_S
	push{r0-r12,lr}
	LDR r10, =RED
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
	
;#############################################################################################################################################

DRAW_C_S
	push{r0-r12,lr}
	LDR r10, =RED
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

;#########################################################################################################################################

DRAW_K_S
	PUSH{R0-R12,LR}
	ldr r10, =RED
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

;#########################################################################################################################################
	
DRAW_I_S
	push{r0-r12,lr}
	ldr r10, =RED
	add r3,r0,#8
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	add r1,r1,#8
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	sub r1,r1,#8
	add r0,r0,#3
	add r3,r0,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}

;#########################################################################################################################################
	
DRAW_S_S
	push{r0-r12,lr}
	LDR r10, =RED
	add r3,r0,#8
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	ldr r10, =BLACK
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
	
;#########################################################################################################################################

DRAW_T_S
	push{r0-r12,lr}
	LDR r10, =RED
	add r3,r0,#8
	add r4,r1,#3
	bl DRAW_RECTANGLE_FILLED
	add r0,r0,#3
	add r3,r0,#2
	add r4,r1,#10
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
;GAME OVER
DRAW_SNAKE_GAME_OVER
	push{r0-r12,lr}
	ldr r0, = 80
	ldr r1, = 60
	add r3, r0, #160
	add r4, r1, #120
	ldr r10, =BLACK
	bl DRAW_RECTANGLE_FILLED
	ldr r10, =RED
	add r4, r1,#4
	bl DRAW_RECTANGLE_FILLED
	add r3, r0, #4
	ldr r4, = 180
	bl DRAW_RECTANGLE_FILLED
	ldr r0, =236
	add r3, r0, #4
	bl DRAW_RECTANGLE_FILLED
	ldr r0, =80
	ldr r1, =176
	add r4, r1, #4
	bl DRAW_RECTANGLE_FILLED
	ldr r0, =135
	ldr r1, =110
	bl DRAW_G_S
	add r0, r0, #11
	bl DRAW_A_S
	add r0, r0, #11
	bl DRAW_M_S
	add r0, r0, #15
	bl DRAW_E_S
	ldr r0, =135
	ldr r1, =125
	bl DRAW_O_S
	add r0, r0, #11
	bl DRAW_V_S
	add r0, r0, #11
	bl DRAW_E_S
	add r0, r0, #11
	bl DRAW_R_S
	pop{r0-r12,pc}

	
;#########################################################################################################################################
DRAW_TRIANGLE_DOWN
	push{r0-r12,lr}
	LDR R10,=GREEN2
	ADD r3,r0,#7
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	ADD r0,r0,#1
	sub r3,r3,#1
	add r1,r1,#2
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	ADD r0,r0,#1
	sub r3,r3,#1
	add r1,r1,#2
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	ADD r0,r0,#1
	sub r3,r3,#1
	add r1,r1,#2
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
;#########################################################################################################################################


DRAW_TRIANGLE_UP
	push{r0-r12,lr}
	LDR R10,=GREEN2
	ADD r3,r0,#7
	add r1,r1,#6
	add r4,r1,#2
	bl DRAW_RECTANGLE_FILLED
	ADD r0,r0,#1
	sub r3,r3,#1
	SUB r1,r1,#2
	SUB r4,r4,#2
	bl DRAW_RECTANGLE_FILLED
	ADD r0,r0,#1
	sub r3,r3,#1
	SUB r1,r1,#2
	SUB r4,r4,#2
	bl DRAW_RECTANGLE_FILLED
	ADD r0,r0,#1
	sub r3,r3,#1
	SUB r1,r1,#2
	SUB r4,r4,#2
	bl DRAW_RECTANGLE_FILLED
	pop{r0-r12,pc}
	
	
DRAW_INVISIBLE_WALL
;----------R0 X R1 Y  R8 DISTANCE
	push{r0-r12,lr}
	LDR R3 ,=INVISIBLE_X
	STR r0,[r3]
	LDR R3 ,=INVISIBLE_Y_UP
	STR r1,[r3]
	LDR R3 ,=INVISIBLE_Y_DOWN
	add r4,r1,r8
	add r4,r4,#8
	STR r4,[r3]

	bl DRAW_TRIANGLE_DOWN
	ADD r1,r1,r8
	BL DRAW_TRIANGLE_UP

	pop{r0-r12,pc}

;#########################################################################################################################################

SNAKE_DETECTION
	;------X=R5 Y=R6 return in r0 the result 1=true 0=false
	push{r1-r12,lr}
	LDR r3 ,=SNAKE_HEAD_X
	ldr r1,[r3]
	LDR r3,=SNAKE_HEAD_Y
	ldr r2,[r3]
	mov r0,#0
	cmp r1,r5
	beq detected
	cmp r2,r6
	beq detected
	
	B NOT_DETECTED
detected
	mov r0,#1
NOT_DETECTED
	pop{r1-r12,pc}
	
;#########################################################################################################################################
	
DRAW_WALL_VERTICAL
   push{r0-r12,lr}
   LDR r10, =BROWN
   ADD r3,r0,#8
   ADD r4,r1,#48
   bl DRAW_RECTANGLE_FILLED
   LDR r10, =BLACK
   ADD R3,R0,#2
   bl DRAW_RECTANGLE_FILLED
   pop{r0-r12,pc}
;#########################################################################################################################################
   

	B SKIP_THIS_LINE
	LTORG
SKIP_THIS_LINE
 
SNAKE_HEAD_LEFT  ;draw snake head
   push{r0-r12,lr}
   LDR r10, =GREEN2
   ADD R3,R0,#8
   ADD R4,R1,#8
   BL DRAW_RECTANGLE_FILLED
   LDR R10, =GREEN
   add r0,r0,#2
   sub r3,r3,#2
   add r1,r1,#2
   sub r4,r4,#2
   bl DRAW_RECTANGLE_FILLED
   ADD R1,R1,#1
   ADD R4,R1,#2
   ADD R3,R0,#2
   LDR R10, =RED
   BL DRAW_RECTANGLE_FILLED
   LDR R10, =BLACK
   SUB R1,R1,#1
   ADD R4,R1,#1
   ADD R0,R0,#2
   ADD R3,R0,#1
   BL DRAW_RECTANGLE_FILLED
   ADD R1,R1,#3
   ADD R4,R1,#1
   BL DRAW_RECTANGLE_FILLED
   pop{r0-r12,pc} 
  
;#########################################################################################################################################

SNAKE_HEAD_UP  ;draw snake head
   push{r0-r12,lr}
   LDR r10, =GREEN2
   ADD R3,R0,#8
   ADD R4,R1,#8
   BL DRAW_RECTANGLE_FILLED
   LDR R10, =GREEN
   add r0,r0,#2
   sub r3,r3,#2
   add r1,r1,#2
   sub r4,r4,#2
   bl DRAW_RECTANGLE_FILLED
   ADD r0,r0,#1
   ADD r3,r0,#2
   ADD R4,R1,#2
   LDR R10, =RED
   bl DRAW_RECTANGLE_FILLED
   LDR r10, =BLACK
   SUB r0,r0,#1
   ADD r3,r0,#1
   ADD R1,R1,#2
   ADD R4,R1,#1
   bl DRAW_RECTANGLE_FILLED
   ADD r0,r0,#3
   ADD r3,r0,#1
   bl DRAW_RECTANGLE_FILLED
   pop{r0-r12,pc}

;#########################################################################################################################################

SNAKE_HEAD_RIGHT  ;draw snake head
   push{r0-r12,lr}
   LDR r10, =GREEN2
   ADD R3,R0,#8
   ADD R4,R1,#8
   BL DRAW_RECTANGLE_FILLED
   LDR R10, =GREEN
   add r0,r0,#2
   sub r3,r3,#2
   add r1,r1,#2
   sub r4,r4,#2
   bl DRAW_RECTANGLE_FILLED
   LDR r10, =BLACK
   ADD r3,r0,#1
   ADD R4,R1,#1
   bl DRAW_RECTANGLE_FILLED
   ADD r1,r1,#3
   ADD r4,r1,#1
   bl DRAW_RECTANGLE_FILLED
   LDR R10, =RED
   ADD R0,R0,#2
   SUB R1,R1,#2
   ADD R3,R0,#2
   SUB r4,r4,#2
   bl DRAW_RECTANGLE_FILLED
   pop{r0-r12,pc}
   
   
;#########################################################################################################################################
  
SNAKE_HEAD_DOWN  ;draw snake head
   push{r0-r12,lr}
   LDR r10, =GREEN2
   ADD R3,R0,#8
   ADD R4,R1,#8
   BL DRAW_RECTANGLE_FILLED
   LDR R10, =GREEN
   add r0,r0,#2
   sub r3,r3,#2
   add r1,r1,#2
   sub r4,r4,#2
   bl DRAW_RECTANGLE_FILLED
   LDR r10, =BLACK
   ADD R3,R0,#1
   ADD r4,r1,#1
   bl DRAW_RECTANGLE_FILLED
   ADD r0,r0,#3
   ADD r3,r0,#1
   bl DRAW_RECTANGLE_FILLED
   LDR R10, =RED
   SUB R0,R0,#2
   ADD R3,R0,#2
   ADD R1,R1,#1
   ADD R4,R1,#2
   bl DRAW_RECTANGLE_FILLED
   pop{r0-r12,pc}
	
;----------------------------------------------------------------------------------------------------

TRACE_BODY FUNCTION
; RETURNS 1 OR 0 IN R6	
	PUSH{R0-R12,LR}

	LDR R3,=SNAKE_HEAD_X
	LDR R4,=SNAKE_HEAD_Y
	LDR R0,[R3]
	LDR R1,[R4]
	
	; R0 CONTAINS X1 
	;R1 CONTAINS Y1 AS AS ACTUAL VALUE
	LDR R3,=SNAKE_TAIL_X
	LDR R4,=SNAKE_TAIL_Y
	LDR R5,[R3]
	LDR R6,[R4]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

	
	pop{r0-r12,pc}
	B SKIP_THIS_LINE0X05555
	LTORG
SKIP_THIS_LINE0X05555
	ENDFUNC
UPDATE_HEAD FUNCTION
;get head direction in R3
;BUTTON_PRESSED
	PUSH{R0-R12,LR}
	
	LDR R6,=HEAD_DIRECTION
	LDR R3,[R6]
	
	LDR R0, = SNAKE_HP
	
	ldr r1,[r0]
	
	ADD R1,R1,#1
	;;;;
	LDR R12,=SNAKE_ENDPTR
	LDR R11,[R12]
	CMP R1,R11
	BHI WRAP_AROUND
	B SKIP_WRAP
	
WRAP_AROUND
	LDR R1,=SNAKE_DIRECTIONS
	
SKIP_WRAP	
	;;;
	STR R1,[R0]
	STRB R3,[R1]
	;;
	
	LDR R8,=SNAKE_HEAD_X
	LDR R9,=SNAKE_HEAD_Y

	LDR R4,[R8]
	LDR R5,[R9]
	
	mov r0,r4
	mov r1,r5
	
	BL DRAWBLOCK

	
	cmp r3,#1
	BEQ LEFT_HEAD
	cmp r3,#2
	BEQ RIGHT_HEAD
	cmp r3,#3
	BEQ UP_HEAD
	cmp r3,#4
	BEQ DOWN_HEAD
	bl END_HEAD_MOVEMENT
	
	
LEFT_HEAD
	sub r4,r4,#8
	cmp r4,#4
	blt kys
	STR R4, [R8]
	MOV R0,R4 
	MOV R1,R5 
	str r3,[r6]
	BL SNAKE_HEAD_LEFT
	bl END_HEAD_MOVEMENT
RIGHT_HEAD
	add r4,r4,#8
	cmp r4,#308
	bgt kys
	STR R4, [R8]
	MOV R0,R4 
	MOV R1,R5 
	str r3,[r6]
	
	BL SNAKE_HEAD_RIGHT
	bl END_HEAD_MOVEMENT

UP_HEAD
	sub r5,r5,#8
	cmp r5,#4
	blt kys
	STR R5, [R9]
	MOV R0,R4 
	MOV R1,R5 
	str r3,[r6]
	BL SNAKE_HEAD_UP
	bl END_HEAD_MOVEMENT
DOWN_HEAD
	add r5,r5,#8
	cmp r5,#200
	bgt kys
	STR R5, [R9]
	MOV R0,R4 
	MOV R1,R5 
	str r3,[r6]
	BL SNAKE_HEAD_DOWN
	bl END_HEAD_MOVEMENT
END_HEAD_MOVEMENT
	
	; CHECK FOR HIT R4=X1,R5=Y1
	LDR R8,=APPLE_X
	LDR R9,= APPLE_Y
	LDR R3,[R8]
	LDR R4,[R9]
	;BL TRACE_BODY
	CMP R0,R3
	BEQ X_MATCH_EAT
	B UNMATCHED_EAT
X_MATCH_EAT
	CMP R1,R4
	BEQ BOTH_MATCH_EAT
	B UNMATCHED_EAT
BOTH_MATCH_EAT
	LDR R7,=IS_EATEN
	MOV R10,#1
	STR R10,[R7]
	LDR R1,=SNAKE_TAIL_X
	LDR R2,=SNAKE_TAIL_Y
	LDR R11,[R1]
	LDR R12,[R2]
	STR R11,[R8]
	STR R12,[R9]
	BL UNMATCHED_EAT
kys
	LDR R12, =SNAKE_HEALTH
	MOV R6, #0
	STR R6,[R12]
UNMATCHED_EAT
	
	
	POP{R0-R12,PC}
	B SKIP_THIS_LINE0X05556
	LTORG
SKIP_THIS_LINE0X05556	
	
	ENDFUNC
	
;----------------------------------------------------------------------------------	
;----------------------------------------------------------------------------------	
;----------------------------------------------------------------------------------	
UPDATE_TAIL FUNCTION


	PUSH{R0-R12,LR}
	
	
	LDR R0, = SNAKE_TP
	;get coordinates somehow
	;draw this in background
	
	LDR r1,[r0]
	
	ADD R1,R1,#1
	;;;;;;;;;
	LDR R12,=SNAKE_ENDPTR
	LDR R11,[R12]
	CMP R1,R11
	BHI WRAP_AROUND1
	B SKIP_WRAP1
	
WRAP_AROUND1
	LDR R1,=SNAKE_DIRECTIONS
	
SKIP_WRAP1	
	;;;;;;;;;;
	str r1,[r0]
	
	ldrb r11,[r1]
	; r11 contains the directtion the tail should be drawed in
	
	;draw snake tail in the direction of r11
	
	ldr r8,=SNAKE_TAIL_X
	ldr r9,=SNAKE_TAIL_Y
	ldr r4,[r8]
	ldr r5, [r9]
	
	MOV R0,R4
	MOV R1,R5
	BL CLEAR_CELL
	
	cmp r11,#1
	BEQ LEFT_TAIL
	cmp r11,#2
	BEQ RIGHT_TAIL
	cmp r11,#3
	BEQ UP_TAIL
	cmp r11,#4
	BEQ DOWN_TAIL
	bl END_TAIL_MOVEMENT
	
	
LEFT_TAIL
	sub r4,r4,#8
	STR R4, [R8]
	
	bl END_TAIL_MOVEMENT
RIGHT_TAIL
	add r4,r4,#8
	STR R4, [R8]
	bl END_TAIL_MOVEMENT

UP_TAIL
	sub r5,r5,#8
	STR R5, [R9]
	bl END_TAIL_MOVEMENT
DOWN_TAIL
	add r5,r5,#8
	STR R5, [R9]
	bl END_TAIL_MOVEMENT

END_TAIL_MOVEMENT	
	MOV R0,R4 
	MOV R1,R5 
	
	BL DRAWTAIL

	POP{R0-R12,PC}	
	ENDFUNC	
;---------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------------
TRACE_MOVEMENT FUNCTION
	PUSH{R0-R12,LR}
	
	LDR R12, = SNAKE_TP
	;get coordinates somehow
	;draw this in background
	;MOV R7, #0
	LDR r0,[R12]
	ldr r12,=SNAKE_TAIL_X
	ldr r1,[r12]
	ldr r12,=SNAKE_TAIL_Y
	ldr r2, [r12]
	LDR R12,=SNAKE_HEAD_X
	LDR R3,[R12]
	LDR R12,=SNAKE_HEAD_Y
	LDR R4,[R12]					
	LDR R12,=SNAKE_ENDPTR
	LDR R5,[R12]
	;LDR R14,=SNAKE_LENGTH
	;LDR R10,[R14]
	;SUB R10,R10,#1
	; XHEAD IN R3 ,YHEAD IN 4 ,XTAIL IN R1,YTALIL IN R2 ,R0 HAVE THE ARRAY INDEX, SNAKE ENDPTR IN R5, R6 HAS THE SNAKE LENGTH
	
DEATH_LOOP
	CMP R3,R1
	BEQ X_MATCH
	B UNMATCHED
X_MATCH
	CMP R2,R4
	BEQ BOTH_MATCH
	B UNMATCHED
BOTH_MATCH
	LDR R12, =SNAKE_HEALTH
	MOV R6, #0
	STR R6,[R12]
	B IM_DEAD


UNMATCHED
	
	CMP R0,R5
	BHI WRAP_AROUND_DIE
	B SKIP_WRAP_DIE
	
WRAP_AROUND_DIE
	LDR R0,=SNAKE_DIRECTIONS
	
SKIP_WRAP_DIE	
	;;;;;;;;;;
	;str r1,[r0]
	
	ldrb r8,[r0]
	; r11 contains the directtion the tail should be drawed in
	
	;draw snake tail in the direction of r11
	;BL CLEAR_CELL
	cmp r8,#1
	BEQ LEFT_TAIL_DIE
	cmp r8,#2
	BEQ RIGHT_TAIL_DIE
	cmp r8,#3
	BEQ UP_TAIL_DIE
	cmp r8,#4
	BEQ DOWN_TAIL_DIE
	bl END_TAIL_MOVEMENT_DIE
	
	
LEFT_TAIL_DIE
	sub r1,r1,#8
	;STR R4, [R8]
	bl END_TAIL_MOVEMENT_DIE
RIGHT_TAIL_DIE
	add r1,r1,#8
	;STR R4, [R8]
	bl END_TAIL_MOVEMENT_DIE

UP_TAIL_DIE
	sub r2,r2,#8
	;STR R5, [R9]
	bl END_TAIL_MOVEMENT_DIE
DOWN_TAIL_DIE
	add r2,r2,#8
	;STR R5, [R9]
	bl END_TAIL_MOVEMENT_DIE

END_TAIL_MOVEMENT_DIE	
	;MOV R0,R4 
	;MOV R1,R5 
	ADD R0,R0,#1
	LDR R9, =SNAKE_HP
	LDR R10,[R9]
	CMP R0,R10
	;BL DRAWTAIL
	BGE IM_DEAD
	B DEATH_LOOP
IM_DEAD
	POP{R0-R12,PC}	
	ENDFUNC	
	
;----------------------------------------------------------------------------------------------------------
DRAWBLOCK  FUNCTION
  	PUSH {R0-R12, LR}
    ;x1 r0
	;y1 r1
	; size is always 4x4
	LDR R10,= GREEN
	mov r3,#0
	
	add r3,r0,#8
	add r4,r1,#8
    bl DRAW_RECTANGLE_FILLED

   	POP {R0-R12, PC}
	ENDFUNC

DRAWTAIL  FUNCTION
  	PUSH {R0-R12, LR}
    ;x1 r0
	;y1 r1
	; size is always 4x4
	ldr r10,=RED
	mov r3,#0
	
	add r3,r0,#8
	add r4,r1,#8
	
	
    bl DRAW_RECTANGLE_FILLED

   	POP {R0-R12, PC}
	
	ENDFUNC
	
DRAWHEAD_SIMPLE  FUNCTION
	PUSH {R0-R12, LR}
    ;x1 r0
	;y1 r1
	; size is always 4x4
	ldr r10,=CYAN
	mov r3,#0
	
	add r3,r0,#8
	add r4,r1,#8
	
	
    bl DRAW_RECTANGLE_FILLED

   	POP {R0-R12, PC}
	ENDFUNC
	
CLEAR_CELL   FUNCTION
	PUSH {R0-R12, LR}
    ;x1 r0
	;y1 r1
	; size is always 4x4
	ldr r10,=YELLOW
	mov r3,#0
	
	add r3,r0,#8
	add r4,r1,#8
	
	
    bl DRAW_RECTANGLE_FILLED

   	POP {R0-R12, PC}
	
	ENDFUNC


GET_BUTTON FUNCTION
	push{r0-r12,lr}
	LDR R2,=HEAD_DIRECTION
	LDR R7,=BUTTON_PRESSED
	LDR r5, =GPIOC_IDR
	LDR r0, [r5]
	LSR r0,#0x0F
	AND r0,r0,#0x01
	CMP R0,#0
	BEQ LEFT_PRESS
	LDR r5, =GPIOC_IDR
	LDR r0, [r5]
	LSR r0,#0x0E
	AND r0,r0,#0x01
	CMP R0,#0
	BEQ RIGHT_PRESS
	BL NO_PRESS
LEFT_PRESS
	MOV R8,#1
	STR R8,[R7]
	;;;;
	;MOV R1,#2
	;STR R1,[R2]
	;;;;
	BL SKIP_PRESS
RIGHT_PRESS
	MOV R8,#2
	STR R8,[R7]
	;;;;;;;;
	;MOV R1,#3
	;STR R1,[R2]
	;;;;;;;;
	BL SKIP_PRESS
NO_PRESS
	MOV R8,#0
	STR R8,[R7]
	BL SKIP_PRESS
SKIP_PRESS 

	BL UPDATE_DIRECTION
	
	pop{r0-r12,pc}
	ENDFUNC
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UPDATE_DIRECTION FUNCTION ; R1 HAS THE BUTTON PRESSED 0 FOR NONE ,1 FOR LEFT ,2 FOR RIGHT ; R6 HAS THE EXISTING HEAD DIRECTION
	push{r0-r12,lr}
	
	LDR R0,=BUTTON_PRESSED
	LDR R1,[R0]
	
	LDR R10,=HEAD_DIRECTION
	LDR R11,[R10]
	
	
	CMP R1,#0
	BEQ DONT_CHANGE
	
	CMP R11,#1
	BEQ INIT_LEFT
	CMP R11,#2
	BEQ INIT_RIGHT
	CMP R11,#3
	BEQ INIT_UP
	CMP R11,#4
	BEQ INIT_DOWN
	
	
	
	
INIT_UP
	CMP R1,#1
	BEQ MOV_LEFT
	CMP R1,#2
	BEQ MOV_RIGHT
	BL DONT_CHANGE
INIT_DOWN
	CMP R1,#1
	BEQ MOV_RIGHT
	CMP R1,#2
	BEQ MOV_LEFT
	BL DONT_CHANGE
INIT_LEFT 
	CMP R1,#1
	BEQ MOV_DOWN
	CMP R1,#2
	BEQ MOV_UP
	BL DONT_CHANGE
INIT_RIGHT
	CMP R1,#1
	BEQ MOV_UP
	CMP R1,#2
	BEQ MOV_DOWN
	BL DONT_CHANGE

MOV_UP
	MOV R12,#3
	STR R12,[R10]
	BL DONT_CHANGE
	

MOV_LEFT
	MOV R12,#1
	STR R12,[R10]
	BL DONT_CHANGE
MOV_RIGHT
	MOV R12,#2
	STR R12,[R10]
	BL DONT_CHANGE
MOV_DOWN
	MOV R12,#4
	STR R12,[R10]
	BL DONT_CHANGE

DONT_CHANGE
	pop{r0-r12,pc}
	ENDFUNC

MAIN_SNAKE FUNCTION
	push{r0-r12,lr}
	
	BL DRAW_SNAKE_BACKGROUND
	BL DRAW_SNAKE_SCORE
	
	LDR R0, =44
	LDR R1, =52
	BL DRAW_WALL_VERTICAL
	
	LDR R0, =244
	LDR R1, =92
	BL DRAW_WALL_VERTICAL
	
	MOV R0,#84
	MOV R1,#84
	
	BL DRAWHEAD_SIMPLE
	
	MOV R0,#92
	MOV R1,#84
	BL DRAWBLOCK
	MOV R0,#100
	MOV R1,#84
	BL DRAWBLOCK
	MOV R0,#100
	MOV R1,#92
	BL DRAWBLOCK
	MOV R0,#100
	MOV R1,#100
	BL DRAWBLOCK
	MOV R0,#108
	MOV R1,#100
	BL DRAWTAIL
	
	
	;ITERATOR

INFINITE_LOOPY
	LDR R10,=APPLE_X
	LDR R0,[R10]
	LDR R10,=APPLE_Y
	LDR R1,[R10]
	BL DRAW_APPLE
	BL GET_BUTTON
	BL delay_half_second
	BL UPDATE_HEAD
	BL TRACE_MOVEMENT
	LDR R0, =SNAKE_HEALTH
	LDR R1, [R0]
	CMP R1, #0
	BEQ SNAKE_GAME_ENDS
	
	LDR R10,=IS_EATEN
	LDR R0,[R10]
	CMP R0,#1
	BEQ SKIPPO
	BL UPDATE_TAIL
SKIPPO
	bl DRAW_SNAKE_HEALTHBAR
	bl delay_half_second
	MOV R0,#0
	STR R0,[R10]
	
	BL INFINITE_LOOPY
	;bl DRAW_MAIN_MENU
	;bl WAIT_FOR_ACTION
	;bl INITIALIZE_SNAKE_GAME

SNAKE_GAME_ENDS
	bl DRAW_SNAKE_HEALTHBAR
	ldr r0,=SNAKE_HEALTH
	MOV R1,#3
	STR R1,[R0]
	BL DRAW_SNAKE_GAME_OVER
	
	
	pop{r0-r12,pc}
    ENDFUNC	
	



;#########################################################################################################################################

	END





