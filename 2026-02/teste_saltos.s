	; Teste de saltos do REDUX-V.
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
	ji ji_fim
	addi 0xf

ji_fim:
	ebreak
