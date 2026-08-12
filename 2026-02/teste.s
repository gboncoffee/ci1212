	; Teste de instruções do REDUX-V.
	; ~ Gabriel de Brito ggb23@inf.ufpr.br
	; 2026/2

	; addi, preparando o salto.
	addi 5

	; Copia o endereço para r1.
	add r1, r0
	; Zera r0 para saltar.
	sub r0, r0

	; O primeiro addi não deve ser executado.
	brzr r0, r1
	addi 0xf
	addi 1
	; E esse salto não deve ocorrer.
	brzr r0, r1

	; O addi não deve ser executado.
	ji ji_test
	addi 0xf

	; Instruções aritméticas.
ji_test:
	sub r0, r0 		; r0 = 0
	not r0, r0		; r0 = 1
	add r0, r0		; r0 = 2
	; Preparar para testar instruções lógicas.
	sub r1, r1		; r1 = 0
	not r1, r1		; r1 = 1
	or r0, r1		; r0 = 3
	and r0, r1		; r0 = 1
	slr r0, r1		; r0 = 2
	xor r0, r1		; r0 = 3
	srr r0, r1		; r0 = 1

	; Load/store.
	sub r0, r0		; r0 = 0
	sub r1, r1		; r1 = 0
	addi 0x0f		; r0 = 0xff
	add r1, r0		; r1 = 0xff
	sub r0, r0		; r0 = 0
	addi 0x0e		; r0 = 0xfe
	st r0, r1		; *(0xff) = 0xfe
	sub r0, r0		; r0 = 0
	ld r0, r1		; r0 = 0xfe
