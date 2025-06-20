# constantes que serão usadas
.data
    msg1: .asciiz "Quantos números deseja ordenar? "
    msg2: .asciiz "Digite um número: "
    msg3: .asciiz "Array ordenado:\n"
    space: .asciiz " "


.globl init


.text
init:
    li $v0, 4
    la $a0, msg1
    syscall

    li $v0, 5
    syscall

    move $s0, $v0

    mul $t0, $s0, 4

    li $v0, 9
    move $a0, $t0
    syscall

    move $s1, $v0

    li $t0, 0

scan_array:
    beq $t0, $s0, end_scan_array

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
end_scan_array:

    move $a0, $s1
    move $a1, $s0
    jal merge_sort

    li $v0, 4
    la $a0, msg3
    syscall

    li $t0, 0

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

    li $v0, 10
    syscall

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
    li $t0, 0
    li $t1, 0
    li $t2, 0

    addi $sp, $sp, -32
    sw $s0, 28($sp)
    sw $s1, 24($sp)
    sw $s2, 20($sp)
    sw $s3, 16($sp)
    sw $s4, 12($sp)
    sw $s5, 8($sp)
    sw $s6, 4($sp)
    sw $s7, 0($sp)

    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    move $s3, $a3

    sub $s4, $s2, $s1
    addi $s4, $s4, 1

    sub $s5, $s3, $s2

    mul $t3, $s4, 4

    li $v0, 9
    move $a0, $t3
    syscall

    move $s6, $v0

    mul $t3, $s5, 4

    li $v0, 9
    move $a0, $t3
    syscall

    move $s7, $v0
preenche_esquerdo:
    beq $t0, $s4, end_preenche_esquerdo

    mul $t3, $t0, 4
    add $t3, $t3, $s6

    add $t4, $s1, $t0
    mul $t4, $t4, 4
    add $t4, $t4, $s0

    lw $t5, 0($t4)
    sw $t5, 0($t3)

    addi $t0, $t0, 1

    j preenche_esquerdo
end_preenche_esquerdo:
preenche_direito:
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
duas_condicoes:
    beq $t0, $s4, end_duas_condicoes
    beq $t1, $s5, end_duas_condicoes

    mul $t3, $t0, 4
    add $t3, $t3, $s6

    mul $t4, $t1, 4
    add $t4, $t4, $s7

    lw $t3, 0($t3)
    lw $t4, 0($t4)

    mul $t5, $t2, 4
    add $t5, $t5, $s0

    addi $t2, $t2, 1

    blt $t3, $t4, adiciona_esquerdo
    j adiciona_direito
adiciona_esquerdo:
    sw $t3, 0($t5)

    addi $t0, $t0, 1

    j duas_condicoes
adiciona_direito:
    sw $t4, 0($t5)

    addi $t1, $t1, 1

    j duas_condicoes
end_duas_condicoes:
    bne $t0, $s4, termina_esquerdo
    bne $t1, $s5, termina_direito
termina_esquerdo:
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
termina_direito:
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
    lw $s0, 28($sp)
    lw $s1, 24($sp)
    lw $s2, 20($sp)
    lw $s3, 16($sp)
    lw $s4, 12($sp)
    lw $s5, 8($sp)
    lw $s6, 4($sp)
    lw $s7, 0($sp)
    addi $sp, $sp, 32

    jr $ra
