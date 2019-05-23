include console.inc 

.data 
N EQU 100
A DB N dup(?)
h DW ? 
.code  
read proc
    outstr 'Enter your Text (END OF ENTRY IS POINT) : '
    push EBP
    mov EBP,ESP
    push EBX
    mov EBX,[EBP+8]
@Again: 
    inchar byte ptr [EBX]
    mov AL,[EBX]
    CMP AL, byte ptr '.'
     JE @FIN
    add EBX,1
    JMP @Again
@FIN:
    pop EBX
    pop EBP
    ret 4
read endp

property proc
    push EBP
    mov EBP,ESP
    push EBX
    mov EBX,[EBP+8]
    push EDI
    mov EDI,0
@Again: 
    mov AL,[EBX]
    CMP AL, byte ptr '.'
     JE @END
    inc EBX
    JMP @Again
@END:
    sub EBX,1
    mov AL,[EBX]
     cmp AL, byte ptr 'A'
     JB @rno
    cmp AL , byte ptr 'Z'
     JA @rno
    mov EBX,[EBP+8]
@Again2: 
    mov AL,[EBX]
    CMP AL, byte ptr '.'
     JE @FIN
    CMP AL,AH
     JNE @skip
    inc EDI
@skip: 
    inc EBX
    JMP @Again2    
@FIN:
    CMP EDI,1
     JA @rno
    JMP @ryes
@ryes:
    mov EAX,1
    JMP @LaFIN
@rno:
    mov EAX,0
    JMP @LaFIN
@LaFIN:
    pop EDI
    pop EBX
    pop EBP
    ret 4 
property endp

rule_2 proc
push EBP
mov EBP,ESP
push EBX
mov EBX,[EBP+8]
push ECX
mov ECX,0
push EDI
push EDX
mov AH,0
mov DH,0
mov DL,0
@Again_1:
mov AL, byte ptr [EBX]
CMP AL, byte ptr '.'
JE @Again_1_end
CMP AL, byte ptr '0'
JB @skip
CMP AL, byte ptr '9'
JA @skip
push [EBX]
inc DH
@skip:
inc EBX
inc ECX
JMP @Again_1
@Again_1_end:
mov EDI,ECX
mov EBX,[EBP+8]
@Again_2:
mov AL, byte ptr [EBX]
CMP AL, byte ptr '.'
JE @Again_2_end
CMP AL, byte ptr '0'
JB @addd
CMP AL, byte ptr '9'
JA @addd
JMP @skip_2
@addd:
push [EBX]
inc AH
inc DL
@skip_2:
inc EBX
JMP @Again_2
@Again_2_end:
mov EBX,[EBP+8]
cmp Dl,byte ptr 0
JNE @ok
JMP @only_point

@ok:

@Again_3:
pop [EBX]
inc EBX
LOOP @Again_3
mov ECX,EDI
mov EBX,[EBP+8]
@Again_4:
push [EBX]
inc EBX
LOOP @Again_4
mov ECX,EDI
mov EBX,[EBP+8]
@Again_5:

pop [EBX]
inc EBX
LOOP @Again_5
@only_point:
mov [EBX], byte ptr '.'
outstrln
pop EDX
pop EDI
pop ECX
pop EBX
pop EBP
ret 4
rule_2 endp

write proc
    push EBP
    mov EBP,ESP
    push EBX
    mov EBX,[EBP+8]
@Again: 
    outchar byte ptr [EBX]
    mov AL,[EBX]
    CMP AL, byte ptr '.'
     JE @FIN
    add EBX,1
    JMP @Again
@FIN:
    pop EBX
    pop EBP
    ret 4
write endp

rule_1 proc
    push EBP
    mov EBP,ESP
    push EBX
    mov EBX,[EBP+8]
@Again: 
    mov AL,[EBX]
    CMP AL, byte ptr '.'
     JE @FIN
    CMP AL,byte ptr 'A';A
     JAE @nextb
    JMP @next
@next:
    add EBX,1
    JMP @Again
@nextb:
    CMP AL, byte ptr 'Z';Z
     JNE @next_11
    mov AL,byte ptr 'A'
    JMP end_00
@next_11:
    CMP AL, byte ptr 'Z';Z
     JA @next
    inc AL    
end_00:
    mov byte ptr [EBX],AL
    JMP @next
@FIN:
    pop EBX
    pop EBP
    ret 4 
rule_1 endp
    
START:
        clrscr
        push dword ptr offset A
        call read
        outstrln ' --YOUR  TEXT -- '
        push dword ptr offset A
        call write
        push dword ptr offset A
        call property
        CMP EAX,dword ptr 1 
         JE V_1
        JMP V_2
V_1:
        outstrln
        outstrln '     FIRST rule is executed ' 
        outstrln
        push dword ptr offset A
        call rule_1
        JMP FIN
V_2:    
        outstrln
        outstrln '     SECOND rule is executed '
        outstrln
        push dword ptr offset A
        call rule_2
        JMP FIN
FIN:
        outstrln ' --MODIFIED TEXT -- '
        push dword ptr offset A
        call write
	Exit
        END START
