t e l l   U R L E n c o d e r D e c o d e r 
 	 
 	 s e t   s   t o   u r l e n c o d e ( " =��  H e l l o   W o r l d !   =��    \ " \ \ ' ;   h t t p : / / w w w . a p p l e . c o m     \ " a s d f \ "   \ \ ' \ \ \ \ ( ) " ) 
 	 l o g   s 
 	 
 	 l o g   u r l d e c o d e ( s ) 
 	 
 e n d   t e l l 
 
 s c r i p t   U R L E n c o d e r D e c o d e r 
 
 ��	 ( *   U s e s   P H P   t o   e n c o d e / d e c o d e   a   U R L .   * ) 
 	 
 	 p r o p e r t y   A S C I I _ N U M B E R S _ O F _ S P E C I A L _ C H A R A C T E R S   :   { 9 2 ,   3 9 }   - -   b a c k s l a s h ,   s i n g l e   q u o t e 
 	 p r o p e r t y   A S C I I _ N U M B E R S _ O F _ U N W A N T E D _ C H A R A C T E R S   :   { 0 ,   1 ,   2 ,   3 ,   4 ,   5 ,   6 ,   7 ,   8 ,   1 1 ,   1 2 ,   1 4 ,   1 5 ,   1 6 ,   1 7 ,   1 8 ,   1 9 ,   2 0 ,   2 1 ,   2 2 ,   2 3 ,   2 4 ,   2 5 ,   2 6 ,   2 7 ,   2 8 ,   2 9 ,   3 0 ,   3 1 ,   1 2 7 } 
 	 
 	 o n   u r l e n c o d e ( s ) 
 	 	 
 	 	 t r y 
 	 	 	 
 	 	 	 s e t   s   t o   r e m o v e U n w a n t e d A S C I I C h a r a c t e r s ( s ) 
 	 	 	 s e t   s   t o   p r o t e c t S p e c i a l C h a r a c t e r s ( s ) 
 	 	 	 s e t   p h p S c r i p t   t o   " e c h o   u r l e n c o d e ( "   &   q u o t e d   f o r m   o f   s   &   " ) ; " 
 	 	 	 s e t   s   t o   d o   s h e l l   s c r i p t   " / u s r / b i n / p h p   - r   "   &   q u o t e d   f o r m   o f   p h p S c r i p t 
 	 	 	 r e t u r n   s 
 	 	 	 
 	 	 o n   e r r o r   e M s g   n u m b e r   e N u m 
 	 	 	 e r r o r   " E r r o r   w h i l e   t r y i n g   t o   u r l e n c o d e :   \ " "   &   s   &   " \ " :   "   &   e M s g   n u m b e r   e N u m 
 	 	 e n d   t r y 
 	 	 
 	 e n d   u r l e n c o d e 
 	 
 	 o n   u r l d e c o d e ( s ) 
 	 	 
 	 	 t r y 
 	 	 	 
 	 	 	 s e t   p h p S c r i p t   t o   " e c h o   u r l d e c o d e ( "   &   q u o t e d   f o r m   o f   s   &   " ) ; " 
 	 	 	 s e t   s   t o   d o   s h e l l   s c r i p t   " / u s r / b i n / p h p   - r   "   &   q u o t e d   f o r m   o f   p h p S c r i p t 
 	 	 	 s e t   s   t o   r e s t o r e S p e c i a l C h a r a c t e r s ( s ) 
 	 	 	 r e t u r n   s 
 	 	 	 
 	 	 o n   e r r o r   e M s g   n u m b e r   e N u m 
 	 	 	 e r r o r   " E r r o r   w h i l e   t r y i n g   t o   u r l d e c o d e :   \ " "   &   s   &   " \ " :   "   &   e M s g   n u m b e r   e N u m 
 	 	 e n d   t r y 
 	 	 
 	 e n d   u r l d e c o d e 
 	 
 	 
 	 o n   p r o t e c t S p e c i a l C h a r a c t e r s ( s ) 
 	 	 
 	 	 r e p e a t   w i t h   i   f r o m   1   t o   c o u n t   o f   m y   A S C I I _ N U M B E R S _ O F _ S P E C I A L _ C H A R A C T E R S 
 	 	 	 s e t   s   t o   s n r ( s ,   A S C I I   c h a r a c t e r   ( i t e m   i   o f   m y   A S C I I _ N U M B E R S _ O F _ S P E C I A L _ C H A R A C T E R S ) ,   " \ \ a "   &   p a d ( i t e m   i   o f   m y   A S C I I _ N U M B E R S _ O F _ S P E C I A L _ C H A R A C T E R S   a s   t e x t ,   3 ,   " 0 " ) ) 
 	 	 e n d   r e p e a t 
 	 	 r e t u r n   s 
 	 	 
 	 e n d   p r o t e c t S p e c i a l C h a r a c t e r s 
 	 
 	 o n   r e s t o r e S p e c i a l C h a r a c t e r s ( s ) 
 	 	 
 	 	 r e p e a t   w i t h   i   f r o m   1   t o   c o u n t   o f   m y   A S C I I _ N U M B E R S _ O F _ S P E C I A L _ C H A R A C T E R S 
 	 	 	 s e t   s   t o   s n r ( s ,   " \ \ a "   &   p a d ( i t e m   i   o f   m y   A S C I I _ N U M B E R S _ O F _ S P E C I A L _ C H A R A C T E R S   a s   t e x t ,   3 ,   " 0 " ) ,   A S C I I   c h a r a c t e r   ( i t e m   i   o f   m y   A S C I I _ N U M B E R S _ O F _ S P E C I A L _ C H A R A C T E R S ) ) 
 	 	 e n d   r e p e a t 
 	 	 r e t u r n   s 
 	 	 
 	 e n d   r e s t o r e S p e c i a l C h a r a c t e r s 
 	 
 	 o n   r e m o v e U n w a n t e d A S C I I C h a r a c t e r s ( s ) 
 	 	 
 	 	 r e p e a t   w i t h   i   f r o m   1   t o   c o u n t   o f   m y   A S C I I _ N U M B E R S _ O F _ U N W A N T E D _ C H A R A C T E R S 
 	 	 	 i f   s   c o n t a i n s   ( A S C I I   c h a r a c t e r   ( i t e m   i   o f   m y   A S C I I _ N U M B E R S _ O F _ U N W A N T E D _ C H A R A C T E R S ) )   t h e n 
 	 	 	 	 s e t   s   t o   s n r ( s ,   A S C I I   c h a r a c t e r   ( i t e m   i   o f   m y   A S C I I _ N U M B E R S _ O F _ U N W A N T E D _ C H A R A C T E R S ) ,   " " ) 
 	 	 	 e n d   i f 
 	 	 	 
 	 	 e n d   r e p e a t 
 	 	 
 	 	 r e t u r n   s 
 	 	 
 	 e n d   r e m o v e U n w a n t e d A S C I I C h a r a c t e r s 
 	 
 	 o n   p a d ( a T e x t ,   n e w W i d t h ,   a P r e f i x ) 
 	 	 
 	 	 r e p e a t   n e w W i d t h   -   ( c o u n t   o f   a T e x t )   t i m e s 
 	 	 	 s e t   a T e x t   t o   a P r e f i x   &   a T e x t 
 	 	 e n d   r e p e a t 
 	 	 
 	 	 r e t u r n   a T e x t 
 	 	 
 	 e n d   p a d 
 	 
 	 o n   s n r ( a T e x t ,   p a t t e r n ,   r e p l a c e m e n t ) 
 	 	 
 	 	 s e t   r e p l a c e m e n t   t o   r e p l a c e m e n t   a s   t e x t 
 	 	 
 	 	 i f   c l a s s   o f   p a t t e r n   i s   l i s t   t h e n 
 	 	 	 r e p e a t   w i t h   i   f r o m   1   t o   c o u n t   o f   p a t t e r n 
 	 	 	 	 s e t   a T e x t   t o   s n r ( a T e x t ,   i t e m   i   o f   p a t t e r n ,   r e p l a c e m e n t ) 
 	 	 	 e n d   r e p e a t 
 	 	 	 
 	 	 	 r e t u r n   a T e x t 
 	 	 e n d   i f 
 	 	 
 	 	 i f   a T e x t   d o e s   n o t   c o n t a i n   p a t t e r n   t h e n   r e t u r n   a T e x t 
 	 	 
 	 	 s e t   p r v D l m t   t o   t e x t   i t e m   d e l i m i t e r s 
 	 	 t r y 
 	 	 	 s e t   t e x t   i t e m   d e l i m i t e r s   t o   p a t t e r n 
 	 	 	 s e t   a T e x t I t e m s   t o   t e x t   i t e m s   o f   a T e x t 
 	 	 	 s e t   t e x t   i t e m   d e l i m i t e r s   t o   r e p l a c e m e n t 
 	 	 	 s e t   a T e x t   t o   a T e x t I t e m s   a s   t e x t 
 	 	 e n d   t r y 
 	 	 s e t   t e x t   i t e m   d e l i m i t e r s   t o   p r v D l m t 
 	 	 
 	 	 r e t u r n   a T e x t 
 	 	 
 	 e n d   s n r 
 	 
 e n d   s c r i p t 