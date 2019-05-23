include console.inc
.data
ten dd 10
sgn dd '+'
sm dd ' '
sum dd 0

.code
Start:
        mov eax,0
        outstrln '¬ведите ваше выражение, признак конца ввода ='
again:  
        cmp sgn,'='
        jz finish
        mov ebx,0
        inchar bl
        mov sm,ebx
        sub ebx, '0'
        cmp ebx, 0
        jl sign
        cmp ebx, 9
        jg sign
        mul ten
        add eax,ebx
        jmp again

        
sign:
        cmp sm,'('
        jz open      
  
        cmp sgn,'+'
        jz plus
    
        cmp sgn,'-'
        jz minus
    
        cmp sgn,'*'
        jz mult
    
        cmp sgn,'/'
        jz divn  

        jmp finish
plus:
        add sum,eax
        mov eax,0  
        mov ebx,sm
        mov sgn,ebx
        cmp sm,')'
        jz close
        jmp again   
minus:  
        sub sum,eax
        mov eax,0
        mov ebx,sm
        mov sgn,ebx
        cmp sm,')'
        jz close
        jmp again 
    	 
mult:
        xchg sum,eax
        imul sum
        xchg sum,eax
        mov eax,0
        mov ebx,sm
        mov sgn,ebx
        cmp sm,')'
        jz close
        jmp again 
divn:  
        xchg sum,eax
        cdq
        idiv sum
        xchg sum,eax
        mov eax,0

        mov ebx,sm
        mov sgn,ebx
        cmp sm,')'
        jz close
        jmp again
open:
        push sum
        mov sum,0
        push sgn
        mov sgn,'+'
        jmp again
close:  
        pop sgn
        pop eax
        xchg sum,eax
        mov sm,'+'
        jmp sign
finish:        
        outint sum
        exit
        end Start