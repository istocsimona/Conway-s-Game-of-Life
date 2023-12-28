.data
//pentru mesaj
    stringScan: .asciz "%s"
    stringPrint: .asciz "%s"
    task: .space 4
    cod: .space 100


    index: .space 4
    indexLinie: .space 4
    indexColoana: .space 4
    LinCol: .space 4
    x: .space 4
    y: .space 4
    valcurenta: .space 4

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
    NrVecini: .space 4

    Matrice: .space 1600
    MatriceSchimbare: .space 1600

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


//in linverif si colverif salvam valoarea pe care o folosim la verificari si afisari
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

//adaugam si citirea taskurului si codului
    pushl $task
    pushl $sfs
    call scanf
    popl %ebx
    popl %ebx

    pushl $cod
    pushl $stringScan
    call scanf
    popl %ebx
    popl %ebx




//loop in care executam cele k evolutii
movl $0, index
et_evolutie:
    movl index, %ecx
    cmp %ecx, NrEvolutii
    je et_cod
//cand se executa cele k evolutii afisam solutia finala

    incl index

//resetam index matrice ca sa o reparcurgem
    movl $1, indexLinie
    et_linie_evolutie:
        movl indexLinie, %ecx
        cmp %ecx, linverif
        je et_schimbare  
//atunci cand o parcurgem pe toata are loc interschimbarea 

        movl $1, indexColoana
        et_coloana_evolutie:
            movl indexColoana, %ecx
            cmp %ecx, colverif
            je et_linie_next

            movl indexLinie, %eax
            movl $0, %edx
            mull Coloana 
            addl indexColoana, %eax

            lea Matrice, %edi
            movl (%edi, %eax, 4), %ebx
            movl %ebx, valcurenta
            // in ebx si valcurenta avem celula analizata curent

            //in edx retinem cei 8 vecini
            movl $0, NrVecini

            //1. [i-1][j-1]
            movl indexLinie, %eax
            movl $0, %edx
            decl %eax
            mull Coloana
            addl indexColoana, %eax
            decl %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, NrVecini

            //2. [i-1][j]
            movl indexLinie, %eax
            movl $0, %edx
            decl %eax
            mull Coloana
            addl indexColoana, %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, NrVecini

            //3. [i-1][j+1]
            movl indexLinie, %eax
            movl $0, %edx
            decl %eax
            mull Coloana
            addl indexColoana, %eax
            incl %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, NrVecini

            //4. [i][j-1]
            movl indexLinie, %eax
            movl $0, %edx
            mull Coloana
            addl indexColoana, %eax
            decl %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, NrVecini

            //5. [i][j+1]
            movl indexLinie, %eax
            movl $0, %edx
            mull Coloana
            addl indexColoana, %eax
            incl %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, NrVecini

            //6.[i+1][j-1]
            movl indexLinie, %eax
            movl $0, %edx
            incl %eax
            mull Coloana
            addl indexColoana, %eax
            decl %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, NrVecini

            //7. [i+1][j]
            movl indexLinie, %eax
            movl $0, %edx
            incl %eax
            mull Coloana
            addl indexColoana, %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, NrVecini

            //8. [i+1][j+1]
            movl indexLinie, %eax
            movl $0, %edx
            incl %eax
            mull Coloana
            addl indexColoana, %eax
            incl %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, NrVecini

            //jmp in functie de conditie
            cmp $0, %ebx
            je et_celula_moarta

            jmp et_celula_vie

            et_coloana_next:
                incl indexColoana
                jmp et_coloana_evolutie
        
        et_linie_next:
            incl indexLinie
            jmp et_linie_evolutie
    
    et_celula_moarta: 
    //verificam daca celula are 3 vecinii vii 
        movl NrVecini, %eax
        cmp $3, %eax
        je et_creare_cel

    //altfel punem 0 in MatriceSchimbare
        movl indexLinie, %eax
        movl $0, %edx
        mull Coloana
        addl indexColoana, %eax

        lea MatriceSchimbare, %edi
        movl $0, (%edi, %eax, 4)

        jmp et_coloana_next

    et_celula_vie:
    //verificam daca celula are 2 sau 3 vecini in viata
    movl NrVecini, %eax
    cmp $2, %eax
    je et_creare_cel

    movl NrVecini, %eax
    cmp $3, %eax
    je et_creare_cel

    //altfel punem 0 in MatriceSchimbare
    movl indexLinie, %eax
    movl $0, %edx
    mull Coloana
    addl indexColoana, %eax

    lea MatriceSchimbare, %edi
    movl $0, (%edi, %eax, 4)

    jmp et_coloana_next

et_creare_cel: //punem 1 in MatriceSchimbare
    movl indexLinie, %eax
    movl $0, %edx
    mull Coloana
    addl indexColoana, %eax

    lea MatriceSchimbare, %edi
    movl $1, (%edi, %eax, 4)

    jmp et_coloana_next


et_schimbare: //vom pune MatriceSchimbare in Matrice pt urmatorul pas 
    movl $1, indexLinie
        et_linie_switch:
            movl indexLinie, %ecx
            cmp %ecx, linverif
            je et_evolutie

            movl $1, indexColoana
            et_coloana_switch:
                movl indexColoana, %ecx
                cmp %ecx, colverif
                je et_next_switch

                movl indexLinie, %eax
                movl $0, %edx
                mull Coloana
                addl indexColoana, %eax

                lea MatriceSchimbare, %edi
                movl (%edi, %eax, 4), %ebx 

                lea Matrice, %edi
                movl %ebx, (%edi, %eax, 4)

                incl indexColoana
                jmp et_coloana_switch

        et_next_switch:
            incl indexLinie
            jmp et_linie_switch

        jmp et_evolutie


/*et_afisare:
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
*/

et_exit:
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $2, %edx
    int $0x80
    
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80

