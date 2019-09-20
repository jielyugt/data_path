add 		$zero, $zero, $zero			!0
add 		$zero, $zero, $zero			!1
add 		$zero, $zero, $zero			!2
addi 		$at, $zero, 7				!3
jalr		$ra, $at 					!4

add 		$zero, $zero, $zero			!5
add 		$zero, $zero, $zero			!6

halt									!7


! $ra will be 5 and PC will be 7