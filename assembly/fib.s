!============================================================
! CS 2200 Homework 2 Part 2: fib
!
! Apart from initializing the stack,
! please do not edit main's functionality.
!============================================================

main:
    lea     $sp, stack          ! load ADDRESS of stack label into $sp

    ! python assembler.py -i rama2200 --sym fib.s
    ! python rama2200-sim.py fib.bin
    
    ! ====================== initialize the stack using the label below by loading its VALUE into $sp
    lw      $sp, 0($sp)         
    ! ======================

    lea     $at, fib            ! load address of fib label into $at
    addi    $a0, $zero, 5       ! $a0 = 5, the number a to compute fib(n)
    jalr    $ra, $at            ! jump to fib, set $ra to return addr
    halt                        ! when we return, just halt

fib:

    ! ====================== perform post-call portion of the calling convention (as a callee)
    addi    $sp, $sp, -1        ! save prev frame pointer
    sw      $fp, 0($sp)

    lw      $fp, 0($sp)         ! copy contents of $sp into $fp

    addi    $sp, $sp, -3        ! save s1 to s3 on stack
    sw      $s0, 0($sp)         
    sw      $s1, 1($sp)
    sw      $s2, 2($sp)
    ! ======================

    ! ====================== if a0 <= 1: goto BASE; else: goto ELSE
    addi    $t0, $zero, 1       ! t0 <= 1
    skplt   $t0, $a0            ! if 1 < a0 <=> if a0 > 1
    goto    base                ! False, goto base
    goto    else                ! True, goto else
    ! ======================

base:

    ! ====================== if a0 is less than 0, set a0 to 0
    skplt   $a0, $zero          ! if a0 < 0
    skpe    $zero, $zero            ! False (dummy)
    addi    $a0, $zero, 0       ! True, a0 <= 0
    ! ======================

    addi    $v0, $a0, 0         ! return a
    goto    teardown            ! teardown the stack

else:

    ! ====================== save the value of a0 into a saved register
    addi    $s0, $a0, 0         ! s0 <= a0
    ! ======================

    addi    $a0, $a0, -1        ! $a0 = $a0 - 1 (n - 1)

    ! ====================== the recursive call to fib
    addi    $sp, $sp, -1        ! save previous return address
    sw      $ra, 0($sp)

    lea     $at, fib
    jalr    $ra, $at

    lw      $ra, 0($sp)
    addi    $sp, $sp, 1         ! load previous return address
    ! ======================

    ! ====================== Save the return value of the fib call into a register
    addi    $s1, $v0, 0         ! s1 <= fib(n - 1)
    ! ======================

    ! ====================== Restore the old value of $a0 that we saved earlier
    addi    $a0, $s0, 0         ! a0 <= s0
    ! ======================


    addi    $a0, $a0, -2        ! $a0 = $a0 - 2 (n - 2)

    ! ====================== the recursive call to fib
    addi    $sp, $sp, -1        ! save previous return address
    sw      $ra, 0($sp)
    
    lea     $at, fib
    jalr    $ra, $at

    lw      $ra, 0($sp)
    addi    $sp, $sp, 1         ! load previous return address
    ! ======================

    ! ====================== Compute fib(n - 1) + fib(n - 2) and place the sum to v0
    add     $v0, $s1, $v0       ! v0 <= fib(n - 1) + fib(n - 2)
    ! ======================

    goto    teardown            ! return
    
teardown:

    ! ====================== perform pre-return portion of the calling convention (callee)
    lw      $s0, 0($sp)         
    lw      $s1, 1($sp)
    lw      $s2, 2($sp)
    addi    $sp, $sp, 3

    lw      $fp, 0($sp)
    addi    $sp, $sp, 1

    ! ======================

    jalr    $zero, $ra          ! return to caller

stack: .word 0xFFFF             ! the stack begins here
