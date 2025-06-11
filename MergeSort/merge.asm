
.data
	array: .space 400
	l_array: .space 200
	r_array: .space 200
	msg1: .asciiz "Quantos números deseja ordenar?\n"
	msg2: .asciiz "Digite um número: "
	msg3: .asciiz "Array ordenado:\n"
	.align 2
	array: .space 400
	space: .asciiz " "
.text
.globl main
scan_array:
	beq $t1, $s1, merge     # se índice == tamanho, encerra loop
	
	# Mostrar mensagem
	la $a0,msg2
	li $v0, 4
	syscall
	
	# Ler número do usuário
	li $v0, 5
	syscall
	move $t3, $v0         # salva número em $t3
	
	# Calcular endereço array[indice]
	mul $t4, $t1, 4   # distancia percorrida = índice * 4 (com alinhamento garantido)
	add $t5, $s0, $t4     # endereço = base + distancia percorrida
	
	sw $t3, 0($t5)    # Armazenar número no endereço
	addi $t1, $t1, 1   # Incrementar índice
	j scan_array   #jump para o inicio de scan_array
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

imprimir:
	li $t1,0
	la $a0,msg3
	li $v0,4
	syscall
print_array:
	beq $t1, $s1, end     # se índice == tamanho, encerra loop
	    
	# Carregar o número do array
	mul $t4, $t1, 4
	add $t5, $s0, $t4
	lw $a0, 0($t5)
	
	# Imprimir o número
	li $v0, 1
	syscall
	
	# Imprimir um espaço
	li $v0, 4
	la $a0, space
	syscall
	
	# Próximo índice
	addi $t1, $t1, 1
	j print_array
	
end:
	li $v0, 10
	syscall
	
main:
	la $s0,array    # $s0 = endereço inicial do array
	li $t1,0	    # indice = 0
    	
   	# Mostrar mensagem para pedir tamanho do array
   	li $v0, 4
    	la $a0, msg1
    	syscall
	
   	# Ler tamanho do array
    	li $v0, 5
    	syscall
   	move $s1, $v0       # $s1 = tamanho do array (n)
	
