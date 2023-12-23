.data

    index: .space 4
    indexLinie: .space 4
    indexColoana: .space 4
    LinCol: .space 4
    x: .space 4
    y: .space 4

    pfs: .asciz "%ld "
    sfs: .asciz "%ld"
    pairsfs: .asciz "%ld %ld"
    newline: .asciz "\n"

    Linie: .space 4
    linverif: .space 4
    Coloana: .space 4
    colverif: .space 4

    NrCelule: .space 4
    NrEvolutii: .space 4
    Matrice: .space 1600

.text
.global main
main:

    //citire numarul de linii si coloane
    pushl $Linie
    pushl $sfs
    call scanf
    pushl $Coloana
    pushl $sfs
    call scanf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    //crestem linia si coloana cu 2 bc bordare
    addl $2, Linie
    addl $2, Coloana

    movl Linie, %ecx
    decl %ecx
    movl %ecx, linverif

    movl Coloana, %ecx
    decl %ecx
    movl %ecx, colverif


    //citire numarul de celule
    pushl $NrCelule
    pushl $sfs
    call scanf
    popl %ebx
    popl %ebx

//index e un fel de i din for, bc et_citire_celule e forul de citire a perechilor
    movl $0, index

et_citire_celule:
    movl index, %ecx
    cmp %ecx, NrCelule
    je et_citire_NrEvolutii

//in matrice ar fi m[x][y]
    pushl $y 
    pushl $x
    pushl $pairsfs
    call scanf
    popl %ebx
    popl %ebx
    popl %ebx

//bc noi avem vector v[x*col +y]
//bc matrice bordata x si y cresc cu 1 --> v[(x+1)*col +y+1]

    movl x, %eax
    incl %eax
    movl $0, %edx
    mull Coloana
    addl y, %eax
    incl %eax

//in matrice, la valoarea (x+1)*col+y+1 punem 1
    lea Matrice, %edi
    movl $1, (%edi, %eax, 4)

    incl index
    jmp et_citire_celule

  
et_citire_NrEvolutii:
    pushl $NrEvolutii
    pushl $sfs
    call scanf
    popl %ebx
    popl %ebx


    /*movl $0, %edx
    movl Linie, %ebx
    movl Coloana, %eax
    mull %ebx
    movl %eax, LinCol*/

et_afisare:
    movl $1, indexLinie

    et_linie:
        movl indexLinie, %ecx
        cmp %ecx, linverif
        je et_exit

        movl $1, indexColoana
        et_coloana:
            movl indexColoana, %ecx
            cmp %ecx, colverif
            je et_next

            movl indexLinie, %eax
            movl $0, %edx
            mull Coloana
            addl indexColoana, %eax

            lea Matrice , %edi
            movl (%edi, %eax, 4), %ebx

            pushl %ebx
            pushl $pfs
            call printf
            popl %ebx
            popl %ebx

            pushl $0
            call fflush
            popl %edx

            incl indexColoana
            jmp et_coloana

        et_next:
            movl $4, %eax
            movl $1, %ebx
            movl $newline, %ecx
            movl $2, %edx
            int $0x80

            incl indexLinie
            jmp et_linie



    




et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80

