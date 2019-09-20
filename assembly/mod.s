!============================================================
! CS 2200 Homework 2 Part 1: mod
!
! Edit any part of this file necessary to implement the
! mod operation. Store your result in $v0.
!============================================================

mod:
    addi    $a0, $zero, 28      ! $a0 = 28, the number a to compute mod(a,b)
    addi    $a1, $zero, 13      ! $a1 = 13, the number b to compute mod(a,b)
    add     $t0, $zero, $a0
    skplt   $t0, $a1
    goto    loop
    add     $v0, $zero, $t0
    halt

loop:
    add     $t2, $zero, $a1     ! store 13 into $t2
    nand    $t2, $t2, $t2       ! b = 13 -> b = -14
    addi    $t2, $t2, 1         ! b = -14 -> -13
    add     $t0, $t0, $t2       ! x = x - b
    skplt   $t0, $a1
    goto    loop
    add     $v0, $zero, $t0
    halt
                                     