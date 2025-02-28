nume: Caruntu Dana-Maria
grupa: 311CA

## Tema2 - Intrusion Detection with Suricata
    
    Suricata Zoly a exagerat in ultimele saptamani cu pasiunea ei pentru 
programarea functionala.
    
    Ca urmare, a fost izolata de tribul ei si trebuie sa isi gaseasca o 
noua casa alaturi de alte animale din habitat.
    
    Pentru a nu fi considerata insa un intrus in noile vizuini, fiecare 
tovaras animal ii cere lui Zoly sa rezolve anumite task-uri in limbaj de
asamblare.
    
    Sarcina codului din cadrul acestei teme este sa o ajutati pe Zoly sa 
isi gaseasca o noua casa.

### Task 1 - Permissions

    Acest cod are scopul de a verifica permisiunile furnicilor de a rezerva 
sali intr-un musuroi, permisiunile fiind stocate intr-un vector global 
ant_permissions[].

    Functia check_permission primeste 2 argumente:

->  Primul argument (n) este un intreg pe 32 de biti.
    Primii 8 cei mai semnificativi biti din cadrul numarului reprezinta 
identificatorul i al furnicii.
    Restul de 24 de biti au urmatoarea semnificatie: bitul j ne spune daca 
furnica i doreste sa rezerve sala j.
    O furnica poate cere sa rezerve mai multe sali simultan.

->  Al doilea argument (res) reprezinta adresa de memorie la care functia 
trebuie sa scrie rezultatul verificarii. Daca furnica cu identificatorul 
i poate rezerva  toate salile dorite, valoarea 1 trebuie scrisa la adresa res. 
    Daca furnica nu poate rezerva una sau mai multe din salile dorite, 
valoarea 0 trebuie scrisa la adresa res.

    Pasii realizat in rezolvare sunt urmatorii:

>Extragerea id-ului si a permisiunilor:

   Operatiile 'mov ecx, eax' si 'shr ecx, 24'sunt folosite pentru a extrage 
ID-ul furnicii. Se copiaza valoarea n in ecx si apoi se elimina ultimii 
24 de biti, lasand doar cei 8 biti superiori.

   In plus, 'shl eax, 8' si 'shr eax, 8' elimina primii 8 biti din eax, 
lasand doar permisiunile solicitate de furnica.

>Calculul adresei si a vectorului de permisiuni:
 
    Se muta id-ul in esi , inmultindu-l cu 4 (adica deplasez cu 2 biti la stanga)
si obtin offsetul array-ului ant_permissions[].

>Verificarea Permisiunilor:

    In verificarea permisiunilor se folosesc instructiunile 'and edx, eax' si
'cmp edx, eax' care aplica operatia AND intre permisiunile existente si cele 
solicitate. 
    Astfel, daca rezultatul este egal cu permisiunile solicitate, inseamna 
ca toate salile solicitate pot fi rezervate.

>Finalizarea

    Instructiunile 'mov byte [ebx], 1' si 'jmp end_function' verifica daca 
permisiunile sunt OK, se scrie 1 la adresa res si realizeaza un jump final.

Bibliografie: https://en.wikibooks.org/wiki/X86_Assembly/Shift_and_Rotate

### Task 3 - Treyfer

  In cadrul acestui task se implementeaza functiile treyfer_crypt si 
treyfer_dcrypt folosind algoritmul Treyfer.

  Pentru lizibilitatea codului cat si pentru a itera prin runde si prin 
bytes-ii blocului de text am folosit variabilele globale i, j, rev_i, rev_j. 

    Contorul pentru runde este initializat prin operatia `mov dword [i], 0`.

#### Treyfer_crypt:
    In procesul de criptare se implica parcurgerea blocului de text si 
aplicarea unei serii de transformari pentru fiecare byte, repetand procesul 
pentru un numar definit de runde, mai exact cel definit anterior(10 runde). 

    Astfel pentru fiecare byte de bloc au loc urmatoarele operatii :

>Adunarea cu Byte-ul din Cheie: 

    'mov al, [esi + ebx]' si 'add al, [edi + ebx]': 
incarca byte-ul curent din text si adauga byte-ul corespunzator din cheie.
    
>Aplicarea Sbox:

    Sbox-ul este folosit pentru a asigura ca mici schimbari in textul clar sau
in cheie vor duce la schimbari mari in textul criptat, crescand astfel securitatea 
cifrului.
    
    'movzx eax, al si mov al, [sbox + eax]': Extinde byte-ul la un intreg 
la indexare si aplica transformarea Sbox.
    
>Adaugarea Urmatorului Byte si Rotatie:
    
    Rotatia de biti ajuta la dispersia caracteristicilor cheii si textului 
intr-un mod care impiedica deducerea lor usoara.

    'add edx, 1' si 'and edx, 7': Calculeaza indexul urmatorului byte in mod
circular (pentru blocuri de 8 bytes), operatia 'and edx, 7' fiind echivalenta
cu '%8".
    
    'add al, [esi + edx]': Adauga urmatorul byte la valoarea actuala.
    
    'rol al, 1': Aplica o rotatie la stanga pe byte pentru a amesteca bitii.
    
>Actualizarea Blocului: 

    Acest pas finalizeaza criptarea pentru byte-ul curent si pregateste
blocul pentru urmatoarele operatii

    'mov [esi + edx], al': Salveaza byte-ul modificat inapoi in blocul de text.

#### Treyfer_dcrypt:

    Fata de procesul de criptare, functia decripteaza textul criptat prin 
parcurgerea inversa a operatiilor de criptare pentru numarul de runde specificat
la inceput (10 runde).

    Astfel pentru fiecare byte de text criptat au loc urmatoarele operatii :

>Adaugarea Byte-ului din Cheie

    mov dl, [esi + eax]: Incarca in registrul dl byte-ul curent din textul criptat 
la pozitia indicata de eax (care este indexul curent al byte-ului in bloc).
    
    add dl, [edi + eax]: Adauga la acest byte valoarea corespondenta din cheie 
(byte-ul de la aceeasi pozitie din cheie). Aceasta este operatia inversa a celei
 de adaugare a cheii din procesul de criptare, reconstituind valoarea initiala
inainte de aplicarea Sbox.

>Aplicarea Sbox si Resetarea pentru Indexare

    'xor dh, dh': Reseteaza partea superioara a registrului dx pentru a se 
asigura ca extensia la movzx nu va introduce date nedorite.
    
    'movzx edx, dl': Extinde byte-ul modificat din dl la edx fara semn, 
inainte de accesarea Sbox-ului.
    
    'mov dl, [sbox + edx]': Aplica transformarea Sbox inversa accesand tabelul
Sbox cu indexul edx si inlocuieste byte-ul original.

>Rotatie si Substractie

    'mov eax, [rev_j]' si 'add eax, 1' si 'and eax, 7':Calculeaza indexul 
urmatorului byte in mod circular utilizand operatia and pentru a limita 
valoarea la intervalul 0-7, asigurand astfel circularitatea accesului la bloc.
    
    'mov dh, [esi + eax]' si 'ror dh, 1': Incarca byte-ul urmator din bloc 
si aplica o rotatie la dreapta cu un bit. Aceasta inverseaza rotatia la stanga 
facuta in criptare.

>Subtractia si Actualizarea Blocului

    'sub dh, dl': Scade valoarea Sbox aplicata din byte-ul rotit,
inversand efectul adaugarii din procesul de criptare.

    'mov [esi + eax], dh': Stocheaza byte-ul rezultat inapoi in blocul 
de text la pozitia calculata, completand astfel decriptarea pentru acel byte.

Bibliografie : https://en.wikipedia.org/wiki/Treyfer

### Task 4 - Labyrinth

    Acest task are scopul de a o ajuta pe suricata Zoly sa gaseasca
iesirea din labirint, realizand implementarea functiei 'solve_labyrinth'.

    Functia gaseste iesirea din labirint incepand de la pozitia (0,0).Deoarece
fiecare celula vizitata poate duce doar la o singura pozitie viitoare nevizitata,
am folosit o abordare simpla de explorare fara a fi nevoie de backtracking sau 
de alte structuri de date complexe.

    Astfel se verifica directiile posibile de miscare (dreapta, jos , stanga, sus),
ignorand celulele marcate si zidurile(celula este marcata cu '0' daca nu a fost 
vizitata si cu '1' daca a fost vizitata).

    'mov dword [i], 0' si 'mov dword [j], 0' initializeaza contorii i si j la zero,
indicand pozitia de start in labirint (coltul stanga-sus).

    La baza rezolvarii au loc urmatorii pasi:

> Explorarea labirintului

    Se incepe de la pozitia (0, 0) si se exploreaza celula.
    
    Pentru fiecare celula vizitata, se verifica daca este libera 
(elementul respectiv = 0) si se  marcheaza ca vizitata (elementul respectiv = 1)
('mov byte [eax + edx], '1' ').
    
    Prin intermediul labelurilor try_right , try_down, try_left, try_up se 
determina urmatoarea celula accesibila prin verificarea celulelor adiacente 
(dreapta, jos, stanga, sus), evitand revenirea la celula precedenta 
si blocurile de ziduri.

Folosind instructiunea 'mov', incarc indicele curent de linie sau coloana in
registrele lor (ecx respectiv edx). Comparand indicele cu numarul total de linii,
se realizeaza o serie de decizii in legatura cu ce directie sa merg sau incheierea
programului.

De exemplu, in cazul labelului try_right, cu instructiunea 'inc', cresc indicii
pentru deplasare, dupa aceea verificand daca pozitia noua este in afara labirintului
sau nu. Instructiunile: 'mov ebx, [ebx + ecx * 4]' , 'mov al, [ebx + edx]', obtin
elementul curent, urmand ca dupa sa faca o serie de verificari.

> Verificarea conditiilor de terminare

     In fiecare pas de explorare, se verifica daca pozitia curenta este pe una
din marginile labirintului (ultima linie sau ultima coloana). Compar indicii
i si j (pentru linia si coloana curenta), si daca acestia sunt mai mari sau egali
decat numarul de linii respectiv cel de coloane, inseamna ca am gasit iesirea.
    
     Odata ce o margine a labirintului este atinsa, se salveaza aceasta pozitie
ca locatia de iesire.

> Finalizare

    Coordonatele locatiei de iesire sunt scrise in locatiile specificate de 
pointerii *out_line si *out_col.