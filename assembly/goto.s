add		$zero, $zero, $zero				!0
	
goto hello 								!1

add		$zero, $zero, $zero				!2
add		$zero, $zero, $zero				!3
add		$zero, $zero, $zero				!4
add		$zero, $zero, $zero				!5
add		$zero, $zero, $zero				!6

hello:
addi	$a0, $zero, 1					!7

goto bye
addi	$a1, $zero, 9					!8

bye:
addi	$a2, $zero, 2
halt

! the final result should have 1 in a0 and 2 in a2, but not 9 in a1
