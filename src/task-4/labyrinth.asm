%include "../include/io.mac"

extern printf
extern position
global solve_labyrinth

; you can declare any helper variables in .data or .bss

section .data
	i dd 0
	j dd 0
	row dd 0
	col dd 0
	out_line dd 0
	out_col dd 0

section .text

; void solve_labyrinth(int *out_line, int *out_col, int m, int n, char **labyrinth);
solve_labyrinth:
	;; DO NOT MODIFY
	push    ebp
	mov     ebp, esp
	pusha

	mov     eax, [ebp + 8]  ; unsigned int *out_line, pointer to structure containing exit position
	mov     ebx, [ebp + 12] ; unsigned int *out_col, pointer to structure containing exit position
	mov     ecx, [ebp + 16] ; unsigned int m, number of lines in the labyrinth
	mov     edx, [ebp + 20] ; unsigned int n, number of colons in the labyrinth
	mov     esi, [ebp + 24] ; char **a, matrix represantation of the labyrinth
	;; DO NOT MODIFY

	;; Freestyle starts here

	mov [row], ecx
	mov [col], edx
	mov dword [i], 0
	mov dword [j], 0

start_explore:
	mov ecx, [i]
	mov edx, [j]
	cmp ecx, [row]
	jge update_pos
	cmp edx, [col]
	jge update_pos

	; caz in care se afla la marginea de jos
verify_down_edge:
	mov eax, [row]
	dec eax
	cmp ecx, eax
	je  check_bottom_exit

	; caz in care se afla la marginea dreapta
verify_right_edge:
	mov eax, [col]
	dec eax
	cmp edx, eax
	je  check_right_exit

	; marchez pozitia vizitata
mark_position:
	mov eax, esi
	mov eax, [eax + ecx * 4]
	; accesez adresa de inceput a liniei curente
	mov byte [eax + edx], '1'
	; accesez pozitia de pe linia curenta 
	; mut un sg byte la adresa pentru a marca daca a fost vizitat
	
try_right:
	; incercam sa ne miscam la dreapta
	inc edx						; ma deplasez pe coloana si verific daca ma aflu in interior
	cmp edx, [col]				
	jge try_down				; daca e mai mare sau egal, incerc alta miscare
	
	mov ebx, esi
	mov ebx, [ebx + ecx * 4]	; accesez adresa de inceput a liniei curente
	mov al, [ebx + edx] 		; accesez elementul de pe pozitia de pe linia curenta
	cmp al, '0'					; daca elementul este 0, am gasit o pozitie goala si ma deplasez acolo
	je  move_right				

try_down:
	; incercam sa ne miscam in jos
	mov edx, [j]				; analog verific daca ma aflu in limite
	inc ecx						; si incerc sa navighez in alta pozitie
	cmp ecx, [row]
	jge try_left
	
	mov ebx, esi				; analog accesez adresa elemntului
	mov ebx, [ebx + ecx * 4]
	mov al, [ebx + edx]
	cmp al, '0'					; analog verific daca gasesc o pozitie goala
	je  move_down				

try_left:
	; incercam sa ne miscam la stanga
	mov ecx, [i]				
	dec edx						
	cmp edx, -1					
	jl  try_up					
	
	mov ebx, esi				
	mov ebx, [ebx + ecx * 4]	
	mov al, [ebx + edx]
	cmp al, '0'					
	je  move_left				

try_up:
	; incercam sa ne miscam in sus
	mov edx, [j]				
	dec ecx						
	cmp ecx, -1					
	jl  update_pos				
	
	mov ebx, esi				
	mov ebx, [ebx + ecx * 4]	
	mov al, [ebx + edx]			
	cmp al, '0'					
	je  move_up					

	jmp update_pos				; am incercat toate miscarile , actualizez pozitia

move_right:
	mov [j], edx				; actualizez idx coloanei la noua pozitie
	jmp start_explore			; reincep procesul de explorare

move_down:
	mov [i], ecx				; actualizez idx liniei la noua pozitie
	jmp start_explore			; reincep procesul de explorare

move_left:
	mov [j], edx				
	jmp start_explore			

move_up:
	mov [i], ecx			
	jmp start_explore			

check_right_exit:
	inc edx						; trec la coloana urmatoare
	cmp edx, [col]				; ii compar indexul cu nr de coloane
	jge update_pos				; daca depaseste limita (n-1) , inseamna ca a gasit iesirea
								; actualizez coordonatele pentru end						

check_bottom_exit:
	inc ecx						; trec la linia urmatoare
	cmp ecx, [row]				; ii compar indexul cu nr de linii
	jge update_pos				; daca depaseste limita (m-1), am gasit iesirea
								; actualizez coordonatele pentru end

update_pos:
	mov ecx, [i]				; incarc indexul liniei curente
	mov edx, [j]				; incarc indexul coloanei curente
	mov [out_line], ecx			; actualizez pozitia de iesire a liniei si a coloanei
	mov [out_col], edx

	mov eax, [ebp + 8]			; incarc adresa in argumentele functiei
	mov ebx, [out_line]			; ii scriu valoarea idx liniei in locatia specifica
	mov [eax], ebx

	mov eax, [ebp + 12]
	mov ebx, [out_col]
	mov [eax], ebx				; scriu valoarea idx coloanei in locatia sa specifica

	jmp end						; am incheiat cautarea si returnarea valorilor
	;; Freestyle ends here
end:
	;; DO NOT MODIFY

	popa
	leave
	ret
	
	;; DO NOT MODIFY

