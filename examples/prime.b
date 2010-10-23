#!/usr/bin/env ookie
===================================================================
======================== OUTPUT STRING ============================
===================================================================
>++++++++[<++++++++>-]<++++++++++++++++.[-]
>++++++++++[<++++++++++>-]<++++++++++++++.[-]
>++++++++++[<++++++++++>-]<+++++.[-]
>++++++++++[<++++++++++>-]<+++++++++.[-]
>++++++++++[<++++++++++>-]<+.[-]
>++++++++++[<++++++++++>-]<+++++++++++++++.[-]
>+++++[<+++++>-]<+++++++.[-]
>++++++++++[<++++++++++>-]<+++++++++++++++++.[-]
>++++++++++[<++++++++++>-]<++++++++++++.[-]
>+++++[<+++++>-]<+++++++.[-]
>++++++++++[<++++++++++>-]<++++++++++++++++.[-]
>++++++++++[<++++++++++>-]<+++++++++++.[-]
>+++++++[<+++++++>-]<+++++++++.[-]
>+++++[<+++++>-]<+++++++.[-]

===================================================================
======================== INPUT NUMBER  ============================
===================================================================
+                          cont=1
[
 -                         cont=0
 >,
 ======SUB10======
 ----------
 
 [                         not 10
  <+>                      cont=1
  =====SUB38======
  ----------
  ----------
  ----------
  --------

  >
  =====MUL10=======
  [>+>+<<-]>>[<<+>>-]<     dup

  >>>+++++++++
  [
   <<<
   [>+>+<<-]>>[<<+>>-]<    dup
   [<<+>>-]
   >>-
  ]
  <<<[-]<
  ======RMOVE1======
  <
  [>+<-]
 ]
 <
]
>>[<<+>>-]<<

===================================================================
======================= PROCESS NUMBER  ===========================
===================================================================

==== ==== ==== ====
numd numu teid teiu
==== ==== ==== ====

>+<-
[
 >+
 ======DUP======
 [>+>+<<-]>>[<<+>>-]<

 >+<--

 >>>>>>>>+<<<<<<<<   isprime=1

 [
  >+

  <-

  =====DUP3=====
  <[>>>+>+<<<<-]>>>>[<<<<+>>>>-]<<<

  =====DUP2=====
  >[>>+>+<<<-]>>>[<<<+>>>-]<<< <


  >>>


  ====DIVIDES=======
  [>+>+<<-]>>[<<+>>-]<   DUP i=div
  
  <<
  [
    >>>>>+               bool=1
    <<<
    [>+>+<<-]>>[<<+>>-]< DUP
    [>>[-]<<-]           IF i THEN bool=0
    >>
    [                    IF i=0
      <<<<
      [>+>+<<-]>>[<<+>>-]< i=div
      >>>
      -                  bool=0
    ]
    <<<
    -                    DEC i
    <<
    -
  ]
  
  +>>[<<[-]>>-]<<          
  >[-]<                  CLR div
  =====END DIVIDES====


  [>>>>>>[-]<<<<<<-]     if divides then isprime=0


  <<

  >>[-]>[-]<<<
 ]

 >>>>>>>>
 [
  -
  <<<<<<<[-]<<

  [>>+>+<<<-]>>>[<<<+>>>-]<<<

  >>




  ===================================================================
  ======================== OUTPUT NUMBER  ===========================
  ===================================================================
  [>+<-]>
 
  [
   ======DUP======
   [>+>+<<-]>>[<<+>>-]<
  
  
   ======MOD10====
   >+++++++++<
   [
    >>>+<<              bool= 1
    [>+>[-]<<-]         bool= ten==0
    >[<+>-]             ten = tmp
    >[<<++++++++++>>-]  if ten=0 ten=10
    <<-                 dec ten     
    <-                  dec num
   ]
   +++++++++            num=9
   >[<->-]<             dec num by ten
  
   =======RROT======
      [>+<-]
   <  [>+<-]
   <  [>+<-]
   >>>[<<<+>>>-]
   <
  
   =======DIV10========
   >+++++++++<
   [
    >>>+<<                bool= 1
    [>+>[-]<<-]           bool= ten==0
    >[<+>-]               ten = tmp
    >[<<++++++++++>>>+<-] if ten=0 ten=10  inc div
    <<-                   dec ten     
    <-                    dec num
   ]
   >>>>[<<<<+>>>>-]<<<<   copy div to num
   >[-]<                  clear ten
  
   =======INC1=========
   <+>
  ]
  
  <
  [
   =======MOVER=========
   [>+<-]
  
   =======ADD48========
   +++++++[<+++++++>-]<->
  
   =======PUTC=======
   <.[-]>
  
   ======MOVEL2========
   >[<<+>>-]<
  
   <-
  ]
 
  >++++[<++++++++>-]<.[-]
 
  ===================================================================
  =========================== END FOR ===============================
  ===================================================================


  >>>>>>>
 ]
 <<<<<<<<



 >[-]<
  [-]
 <<-
]
 
======LF========
 
++++++++++.[-]

