```javascript
|ScalpiLang (19.11.2020) 
|Статус готовности: НЕ РАБОТАЕТ :)
 
Новый язык програмирования.

Разница по отношениею к языку Си:

  + однозначность действий:
    ()  - используется ТОЛЬКО для изменения приоритета.
          для вызова есть "->"
          тип указывается в квадратных скобках "[]", 
          для преобразования типа используется "~>"
    
    *   - ТОЛЬКО для действия умножение. (для взятия значения по указателю используется "'")
    
    val - только для глобальных переменных
    var - только для локальных переменных (значение будет храниться в стеке во время исполнения программы)
    
  + Все идентификаторы ВСЕГДА рассматриваются как обозначение смещения (относительно начала фаила, стека, адресса и пр.) в памяти. 
    my_variable'  - взятие значения переменной.
    my_variable'' - взятие значения от значения взятого по адрессу равнозначто взятию по указателю.
      
  + есть операция взятия остатка "%" которая не генерирует код деления.
    если во время деления процессор всё равно высчитыает остаток так зачем его высчитывать 2 раза??
    
  + многострочный текст без кавычек - определяется тупо отступом.
    text
      пример
      многострочного
      текста
      
  + возможность указания кодировки
    text [UTF_8] "однострочный текст"
  
    
  - Нет готового компилятора (пока что)
    Статус разработки компилятора:
      задача компилятора: переводить код с языка ScalpiLang в язык ассемблера fasmg.
     
примечания: 
  всем переменным добавляется "_" чтобы гарантировать что они не совпадут с директивами fasmg
 
```
