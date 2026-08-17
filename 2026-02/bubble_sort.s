	; Bubble Sort para o REDUX-V.
	; ~ Gabriel de Brito ggb23@inf.ufpr.br
	; 2026/2

	sub r0, r0
	sub r1, r1
	sub r2, r2
	sub r3, r3

	; M[-1] -> índice do loop externo
	; M[-2] -> índice do loop interno
	; M[-3] -> endereço do vetor.

	; Guarda o endereço do vetor em M[-3].
	addi -3
	add r2, r0
	addi 7 			; -> v.
	add r1, r0		; -> v.
	addi 1 			; -> v.
	slr r0, r1		; -> v.
	addi -7			; -> v.
	st r0, r2

	; Guarda 0 (índice do loop externo) em M[-1].
	sub r0, r0
	sub r1, r1
	addi -1
	st r1, r0
loop_e:
	; O índice do loop externo estará em r1 aqui. Carregamos o alvo do salto
	; em r2.
	sub r2, r2
	sub r0, r0
	addi -1			; -> fim_loop_e.
	add r2, r0 		; -> fim_loop_e.
	addi 2			; -> fim_loop_e.
	srr r2, r0		; -> fim_loop_e.
	addi 1  		; -> fim_loop_e.
	sub r2, r0		; -> fim_loop_e.
	; Calculamos !(i - 7) para verificar se devemos encerrar o loop.
	sub r0, r0
	add r0, r1
	addi -7
	not r0, r0
	brzr r0, r2
	; Guarda 0 (índice do loop interno) em M[-2].
	sub r1, r1
	sub r0, r0
	addi -2
	st r1, r0
loop_i:
	; O índice do loop interno estará em r1 aqui. Carregamos o alvo do salto
	; em r2.
	sub r2, r2
	sub r0, r0

	addi -1 		; -> fim_loop_i.
	add r2, r0 		; -> fim_loop_i.
	addi 2 			; -> fim_loop_i.
	srr r2, r0 		; -> fim_loop_i.
	addi 7 			; -> fim_loop_i.
	addi 7 			; -> fim_loop_i.
	addi 3 			; -> fim_loop_i.

	; Calculamos !(j - 6) para verificar se devemos encerrar o loop.
	sub r0, r0
	add r0, r1
	addi -6
	not r0, r0
	brzr r0, r2

	; Carrega o endereço do vetor em r3.
	sub r0, r0
	sub r3, r3
	addi -3
	add r3, r0
	ld r3, r3

	; Carrega v[j] em r1 e v[j + 1] em r2.
	sub r0, r0
	sub r1, r1
	sub r2, r2
	addi 1
	add r2, r0
	add r1, r3
	add r2, r3
	ld r1, r1
	ld r2, r2

	; r3 = a < b
	sub r3, r3
	add r3, r1
	sub r0, r0
	addi 7
	sub r3, r2
	slr r3, r0

	; Carrega o alvo do salto em r0. Esse é feio porque não pode sujar
	; outros registradores.
	sub r0, r0
	addi 4 			; -> maior_igual.
	slr r0, r0		; -> maior_igual.
	addi 7 			; -> maior_igual.
	addi 7 			; -> maior_igual.
	addi 7 			; -> maior_igual.
	addi 4 			; -> maior_igual.
	; Salta se a >= b, portanto não inverte os valores.
	brzr r3, r0

	; Carrega novamente o índice em r3.
	sub r0, r0
	sub r3, r3
	addi -2
	add r3, r3
	ld r3, r3

	; Carrega o endereço do vetor em r0.
	sub r0, r0
	addi -3
	ld r0, r0
	; Soma com r3 para indexar.
	add r0, r3

	; Salva r1 em v[j + 1] e r2 em v[j], portanto inverte os valores.
	st r2, r0
	addi 1
	st r1, r0

maior_igual:
	; Carrega o índice do loop interno, decrementa, salva e coloca em r1.
	sub r0, r0
	sub r1, r1
	addi -2
	add r1, r0
	ld r0, r1
	addi -1
	st r0, r1
	sub r1, r1
	add r1, r0
	; Carrega o alvo do salto em r2.
	sub r2, r2
	sub r0, r0
	addi 3 			; -> loop_i.
	add r2, r0 		; -> loop_i.
	addi 1  		; -> loop_i.
	slr r0, r2 		; -> loop_i.
	addi 2  		; -> loop_i.
	sub r2, r2
	add r2, r0
	; Zeramos r0 para sempre fazer o salto.
	sub r0, r0
	brzr r0, r2

fim_loop_i:
	; Carrega o índice do loop externo, decrementa, salva e coloca em r1.
	sub r1, r1
	sub r0, r0
	addi -1
	add r1, r0
	ld r0, r1
	addi -1
	st r0, r1
	sub r1, r1
	add r1, r0
	; Carrega o alvo do salto em r2.
	sub r2, r2
	sub r0, r0
	addi 2 			; -> loop_e.
	slr r0, r0		; -> loop_e.
	add r0, r0		; -> loop_e.
	add r2, r0
	; Zeramos r0 para sempre fazer o salto.
	sub r0, r0
	brzr r0, r2
fim_loop_e:
	ebreak

v:
.bits8 7
.bits8 6
.bits8 5
.bits8 4
.bits8 3
.bits8 2
.bits8 1
