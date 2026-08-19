	; Teste de instruções aritméticas do REDUX-V.
	; ~ Gabriel de Brito ggb23@inf.ufpr.br
	; 2026/2

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

	ebreak
