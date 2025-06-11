
.data
	array: .space 400
	l_array: .space 200
	r_array: .space 200
	
.text
.globl main

merge:
	li $t0 0    # indice do array
	li $t1 0    # indice do l_array
	li $t2 0    # indice do r_array
	
	la $s0 array  # carrgando as arrays
	la $s1 l_array
	la $s2 r_array
	
	li $s3 20   # tamanho do l_array
	li $s4 20   # tamanho do r_array
	
LOOP_PRINCIPAL:
	beq $t1 $s3 EXIT_LP  # se um dos indice chegar no final
	beq $t2 $s4 EXIT_LP
		
	sll $t3 $t0 2     #  ajeitar os indices 
	sll $t4 $t1 2
	sll $t5 $t2 2	
	
	add $t3 $s0 $t3   #calcula a posição
	add $t4 $s1 $t4
	add $t5 $s2 $t5
			
	lw $t3, 0($t3)	 # carrega os valores dauqle
	lw $t4, 0($t4)	
	lw $t5, 0($t5)
	
	j LOOP_PRINCIPAL
	
EXIT_LP:

main:
	
	