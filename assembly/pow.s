! This program executes pow as a test program using the LC 2200 calling convention
! Check your registers ($v0) and memory to see if it is consistent with this program

main:	lea $sp, initsp                         ! initialize the stack pointer            !0
        lw $sp, 0($sp)                          ! finish initialization                   !1    

        lea $a0, BASE                           ! load base for power                     !2
        lw $a0, 0($a0)                                                                    !3
        lea $a1, EXP                            ! load power for pow                      !4
        lw $a1, 0($a1)                                                                    !5
        lea $at, POW                            ! load address of pow
        jalr $ra, $at                           ! run pow
        lea $a0, ANS                            ! load base for pow
        sw $v0, 0($a0)

        halt                                    ! stop the program here                   !10
        addi $v0, $zero, -1                     ! load a bad value on failure to halt

BASE:   .fill 2
EXP:    .fill 8
ANS:	.fill 0                                 ! should come out to 256 (BASE^EXP)

POW:    addi $sp, $sp, -1                       ! allocate space for old frame pointer     !15
        sw $fp, 0($sp)

        addi $fp, $sp, 0                        ! set new frame pinter
        
        skplt $zero, $a1                        ! check if $a1 is zero (if not, skip the goto)
        goto RET1                               ! if the power is 0 return 1
        skplt $zero, $a0                                                                   !20
        goto RET0                               ! if the base is 0 return 0 (otherwise, the goto was skipped)

        addi $a1, $a1, -1                       ! decrement the power                   !22

        lea $at, POW                            ! load the address of POW               !23
        addi $sp, $sp, -2                       ! push 2 slots onto the stack           !24       
        sw $ra, -1($fp)                         ! save RA to stack                      !25
        sw $a0, -2($fp)                         ! save arg 0 to stack                   !26
        jalr $ra, $at                           ! recursively call pow                  !27
        add $a1, $v0, $zero                     ! store return value in arg 1
        lw $a0, -2($fp)                         ! load the base into arg 0
        lea $at, MULT                           ! load the address of MULT
        jalr $ra, $at                           ! multiply arg 0 (base) and arg 1 (running product)
        lw $ra, -1($fp)                         ! load RA from the stack
        addi $sp, $sp, 2

        goto FIN                                ! return

RET1:   addi $v0, $zero, 1                      ! return a value of 1
        skplt $zero, $v0                        ! convenient use of skplt to get to FIN (0 < 1)

RET0:   add $v0, $zero, $zero                   ! return a value of 0

FIN:	lw $fp, 0($fp)                          ! restore old frame pointer
        addi $sp, $sp, 1                        ! pop off the stack
        jalr $zero, $ra

MULT:   add $v0, $zero, $zero                   ! return value = 0
        addi $t0, $zero, 1                      ! sentinel = 0
AGAIN:  add $v0, $v0, $a0                       ! return value += argument0
        addi $t0, $t0, 1                        ! increment sentinel
        skplt $a1, $t0                          ! if $t0 <= $a1, keep looping
        goto AGAIN                              ! loop again

        jalr $zero, $ra                         ! return from mult

initsp: .fill 0xA000
