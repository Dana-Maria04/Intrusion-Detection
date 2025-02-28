section .rodata
	global sbox
	global num_rounds
	sbox db 126, 3, 45, 32, 174, 104, 173, 250, 46, 141, 209, 96, 230, 155, 197, 56, 19, 88, 50, 137, 229, 38, 16, 76, 37, 89, 55, 51, 165, 213, 66, 225, 118, 58, 142, 184, 148, 102, 217, 119, 249, 133, 105, 99, 161, 160, 190, 208, 172, 131, 219, 181, 248, 242, 93, 18, 112, 150, 186, 90, 81, 82, 215, 83, 21, 162, 144, 24, 117, 17, 14, 10, 156, 63, 238, 54, 188, 77, 169, 49, 147, 218, 177, 239, 143, 92, 101, 187, 221, 247, 140, 108, 94, 211, 252, 36, 75, 103, 5, 65, 251, 115, 246, 200, 125, 13, 48, 62, 107, 171, 205, 124, 199, 214, 224, 22, 27, 210, 179, 132, 201, 28, 236, 41, 243, 233, 60, 39, 183, 127, 203, 153, 255, 222, 85, 35, 30, 151, 130, 78, 109, 253, 64, 34, 220, 240, 159, 170, 86, 91, 212, 52, 1, 180, 11, 228, 15, 157, 226, 84, 114, 2, 231, 106, 8, 43, 23, 68, 164, 12, 232, 204, 6, 198, 33, 152, 227, 136, 29, 4, 121, 139, 59, 31, 25, 53, 73, 175, 178, 110, 193, 216, 95, 245, 61, 97, 71, 158, 9, 72, 194, 196, 189, 195, 44, 129, 154, 168, 116, 135, 7, 69, 120, 166, 20, 244, 192, 235, 223, 128, 98, 146, 47, 134, 234, 100, 237, 74, 138, 206, 149, 26, 40, 113, 111, 79, 145, 42, 191, 87, 254, 163, 167, 207, 185, 67, 57, 202, 123, 182, 176, 70, 241, 80, 122, 0
	num_rounds dd 10

section .data
	i dd 0
	j dd 0
	rev_i dd 0
	rev_j dd 0

section .text
	global treyfer_crypt
	global treyfer_dcrypt

; void treyfer_crypt(char text[8], char key[8]);
treyfer_crypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha

	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key	
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	
	;; TODO implement treyfer_crypt
	mov dword [i], 0 		; resetez i ul la 0

crypt_for_i:
	mov eax, [i]
	cmp eax, [num_rounds]
	jge end_crypt_for_i

	mov dword [j], 0 		; resetez j ul la 0

crypt_for_j:
	mov ebx, [j]
	cmp ebx, 8
	jge end_crypt_for_j

	
	mov al, [esi + ebx]		; incarc byte-ul din plaintext
	add al, [edi + ebx]		; incarc byte-ul din cheie

	
	xor ah, ah				; aplic sbox-ul si adaug urmatorul byte in block
	movzx eax, al
	mov al, [sbox + eax]

	
	mov edx, ebx			; calculez (ebx + 1) % 8
	add edx, 1
	and edx, 7

	add al, [esi + edx]

	rol al, 1 				; rotesc catre stanga

	
	mov [esi + edx], al  	; stochez plaintextul folosind indexul precalculat

	inc dword [j]
	jmp crypt_for_j

end_crypt_for_j:
	inc dword [i]
	jmp crypt_for_i

end_crypt_for_i:
	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

; void treyfer_dcrypt(char text[8], char key[8]);
treyfer_dcrypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_dcrypt

	mov esi, [ebp + 8]
	mov edi, [ebp + 12]
	mov dword [rev_i], 10

reverse_for_i:

	mov dword [rev_j], 8 	; initializez rev_j cu numarul de bytes din block

reverse_for_j:

	dec dword [rev_j]		; decrementez rev_j pentru ordinea inversa

	mov eax, [rev_j]		; mut valoarea lui rev_j in eax pentru operatii

	mov dl, [esi + eax]		; incarc byte-ul din plaintext si adaug byte-ul corespondent din cheie
	add dl, [edi + eax]


	xor dh, dh
	movzx edx, dl       	; aplic sbox-ul
	mov dl, [sbox + edx]


	mov eax, [rev_j]		; calculez indexul urmatorului byte
	add eax , 1
	and eax, 7

	mov dh, [esi + eax]		; incarc urmatorul byte si rotesc catre dreapta cu 1
	ror dh, 1


	sub dh, dl
	mov [esi + eax], dh 	; stochez rezultatul


	cmp dword [rev_j], 0	; verific daca toti bytesii din rev_j au fost parcursi
	jnz reverse_for_j

	dec dword [rev_i]		; verific daca toate rundele au fost procesate
	cmp dword [rev_i], 0
	jnz reverse_for_i

	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret
