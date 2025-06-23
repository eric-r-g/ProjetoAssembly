.data
seed:       .word 0       # Semente inicial (pode ser qualquer valor)
multiplicador: .word 1103515245  # Multiplicador (a)
incremento:  .word 1       # Incremento (c)
modulo:    .word 2147483648  # Módulo (m) - geralmente uma potência de 2

prompt:     .asciiz "Quantos números aleatórios deseja gerar? "
resultado:     .asciiz "Número gerado: "
teto:	    .asciiz "Qual o valor máximo desejado? "
newline:    .asciiz "\n"

.text
.globl main

main:
    # pegando o tempo do sistema pra criar seed aleatoria
    li $v0, 30
    syscall
    sw $a0, seed
    
    li $v0, 4
    la $a0, prompt
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0        # $t0 = contador de números a gerar
    
    li $v0, 4
    la $a0, teto
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0        # $t2 = teto dos números gerados (máximo possível) *obs: minimo é sempre 0
    
    lw $s0, seed        
    lw $s1, multiplicador  
    lw $s2, incremento   
    lw $s3, modulo 
    
    
gerador:
    beqz $t0, end
    
    # aplicando LCG (Linear congruential generator) para calcular o numero aleatorio
    mul $t1, $s0, $s1
    add $t1, $t1, $s2
    div $t1, $s3         
    mfhi $s0		# essa conta é basicamente (ax + b)       
    
    # garantindo um valor positivo (pode dar negativo por causa de overflow) com um AND em uma máscara de 31 bits (01111111...1)
    li $t6, 0x7FFFFFFF   
    and $s0, $t1, $t6    
    
    # reduzindo o valor para o teto dado pelo input
    div $s0, $t2
    mfhi $s0
    
    # printar o numero gerado (pra teste)
    li $v0, 4
    la $a0, resultado
    syscall
    li $v0, 1
    move $a0, $s0
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    sub $t0, $t0, 1
    j gerador

end:
    li $v0, 10
    syscall