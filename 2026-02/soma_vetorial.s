	; Soma vetorial para o REDUX-V.
	; ~ Gabriel de Brito ggb23@inf.ufpr.br
	; 2026/2

	; Soma A[i] + B[i], de trás para frente:
	; A = {0, 1, 2, 3, 4, 5, 6, 7}
	; B = {8, 9, 10, 11, 12, 13, 14}

	sub r0, r0
	sub r1, r1
	sub r2, r2
	sub r3, r3

	; r3 terá o endereço corrente nos vetores (começando pelo fim).
	addi 5
	slr r0, r0
	add r3, r0

	; r2 terá o valor (e índice) corrente.
	sub r0, r0
	addi 7
	addi 7
	add r2, r0

	; r1 terá o alvo do salto.
	sub r0, r0
	addi 7
	addi 7
	addi 7
	addi 3
	add r1, r0

	; O loop é feito de trás para frente.
loop1:
	brzr r2, r1
 	st r2, r3
	sub r0, r0
	addi -1
	add r2, r0
	add r3, r0
	ji loop1
loop1_out:

	; A soma é complicada. r3 terá o indíce.
	sub r0, r0
	sub r3, r3
	addi 7
	add r3, r0
	sub r0, r0
	sub r2, r2
	; r2 terá o endereço no primeiro vetor.
	addi 5
	slr r0, r0
	add r2, r0
loop2:
	; Carrega o alvo do salto em r0.
	sub r0, r0
	addi 4
	slr r0, r0
	addi 2
	brzr r3, r0

	; Carrega o valor do segundo vetor em r1.
	sub r1, r1
	sub r0, r0
	addi -7
	add r1, r2
	add r1, r0
	ld r1, r1
	; Carrega o valor do primeiro vetor em r0.
	sub r0, r0
	add r0, r2
	ld r0, r0
	; Soma em r1.
	add r1, r0
	; Carrega o endereço em R em r0 e salva o novo valor.
	sub r0, r0
	add r0, r2
	addi 7
	addi 7
	st r1, r0

	; Atualiza os indíces.
	sub r0, r0
	addi 1
	sub r3, r0
	sub r2, r0

	; r1 terá o alvo do salto.
	sub r1, r1
	sub r0, r0
	addi 3
	slr r0, r0
	addi 7
	addi 2
	add r1, r0
	; r0 será zerado para o salto ocorrer sempre.
	sub r0, r0
	brzr r0, r1
loop2_out:
	ebreak
