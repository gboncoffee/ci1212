	; Teste de instruções load/store do REDUX-V.
	; ~ Gabriel de Brito ggb23@inf.ufpr.br
	; 2026/2

	sub r0, r0		; r0 = 0
	sub r1, r1		; r1 = 0
	addi 0x0f		; r0 = 0xff
	add r1, r0		; r1 = 0xff
	sub r0, r0		; r0 = 0
	addi 0x0e		; r0 = 0xfe
	st r0, r1		; *(0xff) = 0xfe
	sub r0, r0		; r0 = 0
	ld r0, r1		; r0 = 0xfe

	ebreak
