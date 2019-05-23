include console.inc

.data
   B1 db 10
   B2 db 20
   B3 db 10
   W1 dw 100
   W2 dw 200
   W3 dw 300
   D1 dd 1000
   D2 dd 2000
   D3 dd 3000
   Q1 dq 4300000000;
   Q2 dq 3500000000;
   Q3 dq 2500000000;

.code

MOVREG MACRO REG, A;        перемещение в регистр REG значения A (для упрощения программы)
    IF (TYPE(A) EQ TYPE(REG)) OR (TYPE(A) EQ 0)
        mov REG, A;
    ELSE
        movzx REG, A;
    ENDIF
ENDM

RETURN MACRO REG;     удаление вершины стека;
mov [ESP], REG;
pop REG;
ENDM

SUM MACRO A, B, C;    кладём в A сумму A, B и C
    
        push EAX;        сохраняем значения регистров
        push EBX;
        MOVREG EBX, B;   с помощью регистра EBX сохраняем значения B и C в стеке
        push EBX
        mov EBX, [ESP+4];
        MOVREG EBX, C;
        push EBX
        MOVREG EAX, A;
        ADD EAX, [ESP];     в EAX храним значение переменной A;
        ADD EAX, [ESP + 4]; 
        REPEAT 3
        pop EBX; возвращаем значение EBX в регистр;
        ENDM
        
        
        ; Перемещение значения суммы по адресу A
        IF (TYPE(A) EQ BYTE)
            mov A, AL;
        ELSEIF (TYPE(A) EQ WORD)
            mov A, AX;
        ELSEIF (TYPE(A) EQ DWORD)
            mov A, EAX;
        ENDIF
    
        ; удаление из стека "лишнего" элемента - значения EAX: либо возвращаем обратно в EAX, либо удаляем;
        IFDIFI <A>, <EAX>
            IFDIFI <A>, <AX>
                IFDIFI <A>, <AH>
                    IFDIFI <A>, <AL>
                        pop EAX;
                    ElSE
                        RETURN EAX
                    ENDIF
                ELSE
                    RETURN EAX;
                ENDIF
            ELSE
                RETURN EAX;
            ENDIF
        ELSE
        RETURN EAX;
        ENDIF
ENDM;

ADDQ MACRO A, B;        сложение операнда размера DQ с другим
    push EAX;
    IF (TYPE(B) NE QWORD);       если размер второго операнда меньше DQ, фактически работаем лишь с младшими битами
       MOVREG EAX, B;
       ADD dword ptr A, EAX; 
       ADC dword ptr A+4, 0;     для получения верного значения используем ADC
    ELSE
        MOVREG EAX, dword ptr B;        иначе работаем с двумя половинами;
        ADD dword ptr A, EAX;
        MOVREG EAX, dword ptr B+4;
        ADC dword ptr A+4, EAX;
    ENDIF
    pop EAX;
ENDM;

ADDTHREE MACRO A, B, C;
   
   K = 0;  константа, отвечающая за вывод результата один раз;
   ;I - константа, необходимая, чтобы значения поданных параметров выводились лишь единожды
    IF I EQ 0
    outstrln 'На вход поданы параметры со следующими значениями';
        FOR p, <A, B, C>
            outstr '&p&: ';
            outword p;
            newline;
        ENDM;
    I = 1;
    ENDIF;
   
   ; если A - не константа, не DQ, и при этом тип A не меньше остальных, осуществляем сложение;
    IF (TYPE(A) NE 0) AND (TYPE(A) NE QWORD) AND (TYPE(A) GE (TYPE(B))) AND (TYPE(A) GE (TYPE(C)))
      
        SUM A, B, C;
        outstrln 'Первый операнд не меньше других; введённые данные корректны';
        
        IF (TYPE(A) EQ TYPE(B)) AND (TYPE(B) EQ TYPE(C));       дополнительный информационный вывод;
            outstrln 'Обработка операндов одинакового типа'
        ELSE  
            outstrln 'Обработка операндов разного типа'
        ENDIF
        
    ELSEIF (TYPE(A) NE 0) AND (TYPE(A) NE QWORD); если значение операнда A меньше остальных, обрабатываем случай
            
        outstrln 'Ошибка: введённые данные некорректны; идёт повторная обработка данных'; выводим сообщение об ошибке;
            
        IF (TYPE(B) GT TYPE(A)) AND (TYPE(B) GE TYPE(C));  вызываем макрос повторно так, чтобы первым был операнд, не меньший, чем остальные
            ADDTHREE B, A, C;
            K = 1;
        ELSE
            ADDTHREE C, A, B;
            K = 1;
        ENDIF;
    
    ELSEIF (TYPE(A) EQ 0);     если A - константа, ищем первое неконстантное выражение
        
        outstrln 'Идёт обработка параметров, среди которых есть константы';
        
        IF (TYPE(A) EQ 0) AND (TYPE(B) EQ 0) AND (TYPE(C) EQ 0);
            outstrln 'Ошибка: введены три константы';
            K = 1;    
        ELSE
            outstrln 'Так как первый операнд - константа, идёт поиск неконстантного выражения'
            ADDTHREE B, C, A;
            K = 1;
        ENDIF;
        
   ELSEIF (TYPE(A) EQ QWORD);
      outstrln 'Идёт обработка типа QWORD'
      ADDQ A, B;       складываем A с числами B и C;
      ADDQ A, C;
   ENDIF;

   IF K EQ 0
     outstrln 'Результат выполнения программы следующий:';
     outword A;
     newline;
   ENDIF;  
    
ENDM
Start:
    FOR p, <<B1, B2, B3>, <B2, B3, B1>, <W1, W2, W3>, <W3, W2, W1>, <D1, D2, D3>, <W1, B1, W3>>
        I = 0;
        ADDTHREE p;
        newline;
    ENDM;
    
    FOR p, <<D2, W2, B2>, <B3, B1, W2>, <B1, B2, 7>, <W1, 5, 20>, <5, B1, 4>, <D2, 5, 6>, <5, 2, W3>>
        I = 0;
        ADDTHREE p;
        newline;
    ENDM;
    
    FOR p, <<AX, BX, DX>, <AX, W1, W2>, <W1, W2, SI>, <Q1, Q2, Q3>, <Q1, W1, B1>, <AX, B3, CL>>;
        I = 0;
        ADDTHREE p;
      newline;
    ENDM;
    
    I = 0;
    ADDTHREE Q1, Q2, Q3;
 exit;
end Start