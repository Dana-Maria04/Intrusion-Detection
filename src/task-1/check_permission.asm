%include "../include/io.mac"

extern ant_permissions

extern printf
global check_permission

section .text

check_permission:
	;; DO NOT MODIFY
	push    ebp
	mov     ebp, esp
	pusha

	mov     eax, [ebp + 8]  ; id and permission
	mov     ebx, [ebp + 12] ; address to return the result
	;; DO NOT MODIFY

	;; Your code starts here
start_extraction:
	; extrag id-ul si permisiunea
	mov ecx, eax
	shr ecx, 24				; shiftez la dreapta 24 biti pentru a izola ID-ul
	
	shl eax, 8				; shiftez la stanga primii 8 cei mai semnificativi biti 
	shr eax, 8				


calculate_permission_address:
	mov esi, ecx			; incarc id-ul pentru a calcula adresa
	shl esi, 2 				; deplasez cu 2 biti la stanga (pentru a inmulti cu 4 ), obtinand offsetul
	add esi, ant_permissions; calculul adresei
	mov edx, [esi] 			

check_permissions:
	and edx, eax 			; verific daca permisiunile solicitate sunt egale cu cele existente
	cmp edx, eax 			; daca sunt, inseamna ca toate salile pot fii rezervate

set_result:
	mov byte [ebx], 0 		; daca permisiunile nu sunt ok, se pune 0 la adresa res
	je  permissions_ok		

jump_to_end:
	jmp end_function		

permissions_ok:
	mov byte [ebx], 1		; daca permisiunile sunt ok, se pune 1 la adresa res

end_function:

	;; Your code ends here
	
	;; DO NOT MODIFY

	popa
	leave
	ret
	
	;; DO NOT MODIFY