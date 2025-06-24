# constantes que serão usadas
.data
    msg1: .asciiz "Quantos números deseja ordenar? "
    msg2: .asciiz "Digite um número: "
    msg3: .asciiz "Array ordenado:\n"
    msg4: .asciiz "Quer inserir os valores manualmente (input 0) ou gerar um vetor aleatório? (input numérico qualquer): "
    msg5: .asciiz "Array original: \n"
    space: .asciiz " "

    # REQUISITO: Variáveis simples
    # As palavras abaixo (seed, multiplicador, etc.) são exemplos de variáveis simples
    # armazenadas na memória. Os registradores ($s0, $t0, etc.) também atuam como
    # variáveis simples ao longo do código.
    seed:       .word 0       # Semente inicial (pode ser qualquer valor)
    multiplicador: .word 1103515245  # Multiplicador (a)
    incremento:  .word 1       # Incremento (c)
    modulo:    .word 2147483648  # Módulo (m) - geralmente uma potência de 2

    prompt:     .asciiz "Quantos números aleatórios deseja gerar? "
    resultado:     .asciiz "Número gerado: "
    teto:	    .asciiz "Qual o valor máximo desejado? "
    newline:    .asciiz "\n"



.globl init


.text
init:
    # REQUISITO: Numeros inteiros recebidos por input do usuario
    # A syscall com $v0 = 5 lê um inteiro do usuário. O resultado é armazenado em $v0.
    li $v0, 4
    la $a0, msg1
    syscall

    li $v0, 5
    syscall
    move $s0, $v0	# s0 = tamanho do array

    mul $t0, $s0, 4

    # REQUISITO: Variável tipo array
    # A syscall 9 (sbrk) aloca memória dinamicamente para o array.
    # O endereço base do array é salvo em $s1.
    li $v0, 9		# aloca memória pro array
    move $a0, $t0
    syscall

    move $s1, $v0	# s1 = v[0]
    
    li $v0, 4
    la $a0, msg4
    syscall
    
    # REQUISITO: Numeros inteiros recebidos por input do usuario
    li $v0, 5
    syscall
    move $s2, $v0	#s2 = 0 ou 1 
    
    li $t0, 0		# contador para percorrer o vetor

    # REQUISITO: Estrutura condicional composta (if, else if e else)
    # beqz $s2, scan_array funciona como um "if ($s2 == 0)".
    # Se a condição for verdadeira, ele pula para 'scan_array'.
    # Caso contrário, ele continua para o código seguinte ('rng'), funcionando como um "else".
    beqz $s2, scan_array

rng:
    li $v0, 30
    syscall
    sw $a0, seed
   
    li $v0, 4
    la $a0, teto
    syscall		
    
    # REQUISITO: Numeros inteiros recebidos por input do usuario
    li $v0, 5
    syscall
    move $t7, $v0        # $t7 = teto dos números gerados (máximo possível) *obs: minimo é sempre 0
    
    lw $s3, seed        
    lw $s4, multiplicador  
    lw $s5, incremento   
    lw $s6, modulo 
 
# REQUISITO: Estrutura de repetição
# O loop 'gerador' preenche o array com números aleatórios.
# Ele continua executando (j gerador) até que o contador $t0 atinja o tamanho do array $s0.
gerador:
    # constantes que serão usadas
.data
    msg1: .asciiz "Quantos números deseja ordenar? "
    msg2: .asciiz "Digite um número: "
    msg3: .asciiz "Array ordenado:\n"
    msg4: .asciiz "Quer inserir os valores manualmente (input 0) ou gerar um vetor aleatório? (input numérico qualquer): "
    msg5: .asciiz "Array original: \n"
    space: .asciiz " "
    
    seed:       .word 0       # Semente inicial (pode ser qualquer valor)
    multiplicador: .word 1103515245  # Multiplicador (a)
    incremento:  .word 1       # Incremento (c)
    modulo:    .word 2147483648  # Módulo (m) - geralmente uma potência de 2

    prompt:     .asciiz "Quantos números aleatórios deseja gerar? "
    resultado:     .asciiz "Número gerado: "
    teto:	    .asciiz "Qual o valor máximo desejado? "
    newline:    .asciiz "\n"



.globl init


.text
init:
    li $v0, 4
    la $a0, msg1
    syscall

    li $v0, 5
    syscall
    move $s0, $v0	# s0 = tamanho do array

    mul $t0, $s0, 4

    li $v0, 9		# aloca memória pro array
    move $a0, $t0
    syscall

    move $s1, $v0	# s1 = v[0]
    
    li $v0, 4
    la $a0, msg4
    syscall
    
    li $v0, 5
    syscall
    move $s2, $v0	#s2 = 0 ou 1 
    
    li $t0, 0		# contador para percorrer o vetor
    beqz $s2, scan_array

rng:
    li $v0, 30
    syscall
    sw $a0, seed
   
    li $v0, 4
    la $a0, teto
    syscall		
    
    li $v0, 5
    syscall
    move $t7, $v0        # $t7 = teto dos números gerados (máximo possível) *obs: minimo é sempre 0
    
    lw $s3, seed        
    lw $s4, multiplicador  
    lw $s5, incremento   
    lw $s6, modulo 
 
gerador:
    beq $t0, $s0, end_array
    
    			# aplicando LCG (Linear congruential generator) para calcular o numero aleatorio
    mul $t1, $s3, $s4
    add $t1, $t1, $s5
    div $t1, $s6        
    mfhi $s3		# essa conta é basicamente (ax + b)       
    
   			# garantindo um valor positivo (pode dar negativo por causa de overflow) com um AND em uma máscara de 31 bits (01111111...1)
    li $t6, 0x7FFFFFFF
    and $s3, $t1, $t6
    
    			# reduzindo o valor para o teto dado pelo input
    div $s3, $t7
    mfhi $s3

    mul $t1, $t0, 4
    add $t1, $s1, $t1	# calcula posicao atual (t1) baseado no contador (t0) e no v[0] (s1)
    
    sw $s3, 0($t1)
    
    addi $t0, $t0, 1
    j gerador
    
# REQUISITO: Estrutura de repetição
# O loop 'scan_array' preenche o array com números digitados pelo usuário.
# Ele continua executando (j scan_array) até que o contador $t0 atinja o tamanho do array $s0.
scan_array:
    beq $t0, $s0, end_array

    li $v0, 4
    la $a0, msg2
    syscall

    mul $t1, $t0, 4
    add $t1, $s1, $t1
    
    # REQUISITO: Numeros inteiros recebidos por input do usuario
    li $v0, 5
    syscall

    sw $v0, 0($t1)

    addi $t0, $t0, 1

    j scan_array
    
end_array:

    li $v0, 4
    la $a0, msg5
    syscall

    li $t0, 0
    # REQUISITO: Chamada de funções com parametro de retorno
    # 'jal print_array' chama a função para imprimir o array.
    # Embora não tenha retorno explícito para 'init', a função 'print_array'
    # usa o registrador de retorno $ra para voltar ao ponto da chamada.
    jal print_array
    
    move $a0, $s1
    move $a1, $s0
    # REQUISITO: Ordenação de valores em array
    # A chamada 'jal merge_sort' inicia o processo de ordenação do array.
    jal merge_sort

    li $v0, 4
    la $a0, msg3
    syscall

    li $t0, 0
    jal print_array
    
    li $v0, 10
    syscall

print_array:
    beq $t0, $s0, end_print_array

    mul $t1, $t0, 4
    add $t1, $s1, $t1

    li $v0, 1
    lw $a0, 0($t1)
    syscall

    addi $t0, $t0, 1

    # REQUISITO: Saída de valores inteiros para o usuario
    # A syscall com $v0 = 1 imprime o inteiro que está em $a0.
    li $v0, 4
    la $a0, space
    syscall

    j print_array
end_print_array:
    li $v0, 4
    la $a0, newline
    syscall
    
    jr $ra

merge_sort:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    move $a2, $a1
    addi $a2, $a2, -1
    li $a1, 0
    # REQUISITO: Recursao
    # 'merge_sort' chama '__merge_sort', que é a função recursiva principal.
    jal __merge_sort

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra

__merge_sort:
    ble $a2, $a1, end__merge_sort

    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    move $s0, $a0
    move $s1, $a1
    move $s2, $a2

    sub $s3, $s2, $s1
    div $s3, $s3, 2
    add $s3, $s3, $s1

    move $a0, $s0
    move $a1, $s1
    move $a2, $s3
    # REQUISITO: Recursao
    # Primeira chamada recursiva para a metade esquerda do array.
    jal __merge_sort

    addi $t0, $s3, 1
    move $a0, $s0
    move $a1, $t0
    move $a2, $s2
    # REQUISITO: Recursao
    # Segunda chamada recursiva para a metade direita do array.
    jal __merge_sort

    move $a0, $s0
    move $a1, $s1
    move $a2, $s3
    move $a3, $s2
    # REQUISITO: Chamada de funções
    # Chama a função 'merge' para combinar as duas metades ordenadas.
    jal merge

    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
end__merge_sort:
    jr $ra

merge:
    li $t0, 0            # inicia os indices i, j, k como 0
    li $t1, 0
    li $t2, 0

    addi $sp, $sp, -32   # reserva espaço na pilha para 8 registradores
    sw $s0, 28($sp)      # guarda os registradores $s, para depois serem
    sw $s1, 24($sp)      # retirados, garantindo que não serão alterados
    sw $s2, 20($sp)
    sw $s3, 16($sp)
    sw $s4, 12($sp)
    sw $s5, 8($sp)
    sw $s6, 4($sp)
    sw $s7, 0($sp)

    move $s0, $a0        # recebe os valores que foram passados como
    move $s1, $a1        # argumentos para a função merge
    move $s2, $a2
    move $s3, $a3

    sub $s4, $s2, $s1    # calcula o tamanho da parte esquerda
    addi $s4, $s4, 1     # ajuste para o tamanho real

    sub $s5, $s3, $s2    # calcula o tamanho da parte direita

    mul $t3, $s4, 4     # ajuste de tamanho para a parte esquerda

    li $v0, 9           # cria uma array temporaria para a parte esquerda
    move $a0, $t3
    syscall

    move $s6, $v0       # armazena ela em $s6

    mul $t3, $s5, 4     # ajuste de tamanho para a parte direita

    li $v0, 9           # cria uma array temporaria para a parte direita
    move $a0, $t3
    syscall

    move $s7, $v0       # armazena ela em $s7
# REQUISITO: Estrutura de repetição
# Loop para preencher o array temporário da esquerda
preenche_esquerdo:
    beq $t0, $s4, end_preenche_esquerdo # sai quando alcancar o fim

    mul $t3, $t0, 4     # ajuste de indice
    add $t3, $t3, $s6   # calculo da posição

    add $t4, $s1, $t0   
    mul $t4, $t4, 4     # ajuste de indice
    add $t4, $t4, $s0   # calculo da posicao

    lw $t5, 0($t4)      # copia o elemento para a array temporaria
    sw $t5, 0($t3)

    addi $t0, $t0, 1

    j preenche_esquerdo
end_preenche_esquerdo:
# REQUISITO: Estrutura de repetição
# Loop para preencher o array temporário da direita
preenche_direito:     # mesmo procedimento para o da esquerda
    beq $t1, $s5, end_preenche_direito  

    mul $t3, $t1, 4
    add $t3, $t3, $s7

    add $t4, $s2, $t1
    addi $t4, $t4, 1
    mul $t4, $t4, 4
    add $t4, $t4, $s0

    lw $t5, 0($t4)
    sw $t5, 0($t3)

    addi $t1, $t1, 1
    
    j preenche_direito
end_preenche_direito:
    li $t0, 0      
    li $t1, 0
    move $t2, $s1

# REQUISITO: Estrutura de repetição com Condicional
# Loop principal do merge, compara os elementos das duas metades
duas_condicoes:        # laco de repetição principal do merge
    beq $t0, $s4, end_duas_condicoes   # se um dos indices tiver chegado no final
    beq $t1, $s5, end_duas_condicoes

    mul $t3, $t0, 4   # correção de indice
    add $t3, $t3, $s6

    mul $t4, $t1, 4   # correção de indice
    add $t4, $t4, $s7

    lw $t3, 0($t3)    # carrega os valores para comparação
    lw $t4, 0($t4)

    mul $t5, $t2, 4  # ajuste de indice de onde vai ser armazenado
    add $t5, $t5, $s0 

    addi $t2, $t2, 1

    # REQUISITO: Estrutura condicional (if-else)
    # blt funciona como if(esquerda < direita), pulando para 'adiciona_esquerdo'
    # 'j adiciona_direito' funciona como o 'else'
    blt $t3, $t4, adiciona_esquerdo  # se a esquerda for menor, chama adiciona na esquerda
    j adiciona_direito
adiciona_esquerdo:
    sw $t3, 0($t5)  # armazena o valor na esquerda

    addi $t0, $t0, 1

    j duas_condicoes
adiciona_direito:
    sw $t4, 0($t5)  # armazena o valor na direita

    addi $t1, $t1, 1

    j duas_condicoes
end_duas_condicoes:  # armazena os valores que restaram
    bne $t0, $s4, termina_esquerdo 
    bne $t1, $s5, termina_direito
    
# REQUISITO: Estrutura de repetição
# Loops para adicionar os elementos restantes de uma das metades, caso existam
termina_esquerdo:  # como se fosse o duas condições, porém somente para esquerda
    beq $t0, $s4, end_merge  

    mul $t3, $t2, 4
    add $t3, $t3, $s0

    mul $t4, $t0, 4
    add $t4, $t4, $s6

    lw $t5, 0($t4)
    sw $t5, 0($t3)

    addi $t0, $t0, 1
    addi $t2, $t2, 1

    j termina_esquerdo
termina_direito:  # como se fosse o duas condições, porém somente para direita
    beq $t1, $s5, end_merge

    mul $t3, $t2, 4
    add $t3, $t3, $s0

    mul $t4, $t1, 4
    add $t4, $t4, $s7

    lw $t5, 0($t4)
    sw $t5, 0($t3)

    addi $t1, $t1, 1
    addi $t2, $t2, 1

    j termina_direito

end_merge:
    lw $s0, 28($sp)        # resgata os valores que foram adicionados na pilha
    lw $s1, 24($sp)        # no inicio do merge, garantindo que não são 
    lw $s2, 20($sp)        # valores modificados
    lw $s3, 16($sp)
    lw $s4, 12($sp)
    lw $s5, 8($sp)
    lw $s6, 4($sp)
    lw $s7, 0($sp)
    addi $sp, $sp, 32      # restaura a pilha

    jr $rabeq $t0, $s0, end_array
    
    			# aplicando LCG (Linear congruential generator) para calcular o numero aleatorio
    mul $t1, $s3, $s4
    add $t1, $t1, $s5
    div $t1, $s6        
    mfhi $s3		# essa conta é basicamente (ax + b)       
    
   			# garantindo um valor positivo (pode dar negativo por causa de overflow) com um AND em uma máscara de 31 bits (01111111...1)
    li $t6, 0x7FFFFFFF
    and $t2, $s3, $t6
    
    			# reduzindo o valor para o teto dado pelo input
    div $t2, $t7
    mfhi $t3

    mul $t1, $t0, 4
    add $t1, $s1, $t1	# calcula posicao atual (t1) baseado no contador (t0) e no v[0] (s1)
    
    sw $t3, 0($t1)
    
    addi $t0, $t0, 1
    j gerador
    
    
scan_array:
    beq $t0, $s0, end_array

    li $v0, 4
    la $a0, msg2
    syscall

    mul $t1, $t0, 4
    add $t1, $s1, $t1
    
    li $v0, 5
    syscall

    sw $v0, 0($t1)

    addi $t0, $t0, 1

    j scan_array
    
end_array:

    li $v0, 4
    la $a0, msg5
    syscall

    li $t0, 0
    jal print_array
    
    move $a0, $s1
    move $a1, $s0
    jal merge_sort

    li $v0, 4
    la $a0, msg3
    syscall

    li $t0, 0
    jal print_array
    
    li $v0, 10
    syscall

print_array:
    beq $t0, $s0, end_print_array

    mul $t1, $t0, 4
    add $t1, $s1, $t1

    li $v0, 1
    lw $a0, 0($t1)
    syscall

    addi $t0, $t0, 1

    li $v0, 4
    la $a0, space
    syscall

    j print_array
end_print_array:
    li $v0, 4
    la $a0, newline
    syscall
    
    jr $ra

merge_sort:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    move $a2, $a1
    addi $a2, $a2, -1
    li $a1, 0
    jal __merge_sort

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra

__merge_sort:
    ble $a2, $a1, end__merge_sort

    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    move $s0, $a0
    move $s1, $a1
    move $s2, $a2

    sub $s3, $s2, $s1
    div $s3, $s3, 2
    add $s3, $s3, $s1

    move $a0, $s0
    move $a1, $s1
    move $a2, $s3
    jal __merge_sort

    addi $t0, $s3, 1
    move $a0, $s0
    move $a1, $t0
    move $a2, $s2
    jal __merge_sort

    move $a0, $s0
    move $a1, $s1
    move $a2, $s3
    move $a3, $s2
    jal merge

    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
end__merge_sort:
    jr $ra

merge:
    li $t0, 0            # inicia os indices i, j, k como 0
    li $t1, 0
    li $t2, 0

    addi $sp, $sp, -32   # reserva espaço na pilha para 8 registradores
    sw $s0, 28($sp)      # guarda os registradores $s, para depois serem
    sw $s1, 24($sp)      # retirados, garantindo que não serão alterados
    sw $s2, 20($sp)
    sw $s3, 16($sp)
    sw $s4, 12($sp)
    sw $s5, 8($sp)
    sw $s6, 4($sp)
    sw $s7, 0($sp)

    move $s0, $a0        # recebe os valores que foram passados como
    move $s1, $a1        # argumentos para a função merge
    move $s2, $a2
    move $s3, $a3

    sub $s4, $s2, $s1    # calcula o tamanho da parte esquerda
    addi $s4, $s4, 1     # ajuste para o tamanho real

    sub $s5, $s3, $s2    # calcula o tamanho da parte direita

    mul $t3, $s4, 4     # ajuste de tamanho para a parte esquerda

    li $v0, 9           # cria uma array temporaria para a parte esquerda
    move $a0, $t3
    syscall

    move $s6, $v0       # armazena ela em $s6

    mul $t3, $s5, 4     # ajuste de tamanho para a parte direita

    li $v0, 9           # cria uma array temporaria para a parte direita
    move $a0, $t3
    syscall

    move $s7, $v0       # armazena ela em $s7
preenche_esquerdo:
    beq $t0, $s4, end_preenche_esquerdo # sai quando alcancar o fim

    mul $t3, $t0, 4     # ajuste de indice
    add $t3, $t3, $s6   # calculo da posição

    add $t4, $s1, $t0   
    mul $t4, $t4, 4     # ajuste de indice
    add $t4, $t4, $s0   # calculo da posicao

    lw $t5, 0($t4)      # copia o elemento para a array temporaria
    sw $t5, 0($t3)

    addi $t0, $t0, 1

    j preenche_esquerdo
end_preenche_esquerdo:
preenche_direito:     # mesmo procedimento para o da esquerda
    beq $t1, $s5, end_preenche_direito  

    mul $t3, $t1, 4
    add $t3, $t3, $s7

    add $t4, $s2, $t1
    addi $t4, $t4, 1
    mul $t4, $t4, 4
    add $t4, $t4, $s0

    lw $t5, 0($t4)
    sw $t5, 0($t3)

    addi $t1, $t1, 1
    
    j preenche_direito
end_preenche_direito:
    li $t0, 0      
    li $t1, 0
    move $t2, $s1
duas_condicoes:        # laco de repetição principal do merge
    beq $t0, $s4, end_duas_condicoes   # se um dos indices tiver chegado no final
    beq $t1, $s5, end_duas_condicoes

    mul $t3, $t0, 4   # correção de indice
    add $t3, $t3, $s6

    mul $t4, $t1, 4   # correção de indice
    add $t4, $t4, $s7

    lw $t3, 0($t3)    # carrega os valores para comparação
    lw $t4, 0($t4)

    mul $t5, $t2, 4  # ajuste de indice de onde vai ser armazenado
    add $t5, $t5, $s0 

    addi $t2, $t2, 1

    blt $t3, $t4, adiciona_esquerdo  # se a esquerda for menor, chama adiciona na esquerda
    j adiciona_direito
adiciona_esquerdo:
    sw $t3, 0($t5)  # armazena o valor na esquerda

    addi $t0, $t0, 1

    j duas_condicoes
adiciona_direito:
    sw $t4, 0($t5)  # armazena o valor na direita

    addi $t1, $t1, 1

    j duas_condicoes
end_duas_condicoes:  # armazena os valores que restaram
    bne $t0, $s4, termina_esquerdo 
    bne $t1, $s5, termina_direito
termina_esquerdo:  # como se fosse o duas condições, porém somente para esquerda
    beq $t0, $s4, end_merge  

    mul $t3, $t2, 4
    add $t3, $t3, $s0

    mul $t4, $t0, 4
    add $t4, $t4, $s6

    lw $t5, 0($t4)
    sw $t5, 0($t3)

    addi $t0, $t0, 1
    addi $t2, $t2, 1

    j termina_esquerdo
termina_direito:  # como se fosse o duas condições, porém somente para direita
    beq $t1, $s5, end_merge

    mul $t3, $t2, 4
    add $t3, $t3, $s0

    mul $t4, $t1, 4
    add $t4, $t4, $s7

    lw $t5, 0($t4)
    sw $t5, 0($t3)

    addi $t1, $t1, 1
    addi $t2, $t2, 1

    j termina_direito

end_merge:
    lw $s0, 28($sp)        # resgata os valores que foram adicionados na pilha
    lw $s1, 24($sp)        # no inicio do merge, garantindo que não são 
    lw $s2, 20($sp)        # valores modificados
    lw $s3, 16($sp)
    lw $s4, 12($sp)
    lw $s5, 8($sp)
    lw $s6, 4($sp)
    lw $s7, 0($sp)
    addi $sp, $sp, 32      # restaura a pilha

    jr $ra
