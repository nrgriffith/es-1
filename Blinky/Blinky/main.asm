;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Assembly language file for Lab 1 in 55:036 (Embedded Systems)
; Spring 2014, The University of Iowa.
;
; LEDs are connected via a 470 Ohm resistor from PB1, PB2 to Vcc
;
; A. Kruger, R. Beichel
;
; Nichole Griffith, Nickolas Kruger
;
.include "tn45def.inc"
.cseg
.org 0

; Configure PB1 and PB2 as output pins.
      sbi   DDRB,1      ; PB1 is now output                        [2 cycles]
      sbi   DDRB,2      ; PB2 is now output                        [2 cycles]

; Main loop follows.  Toggle PB1 and PB2 .,out of phase.
; Assuming there are LEDs and current-limiting resistors
; on these pins, they will blink out of phase.
   loop:                ;                                          
      sbi   PORTB,1     ; LED at PB1 off                           [2 cycles]
      cbi   PORTB,2     ; LED at PB2 on                            [2 cycles]
      rcall delay_long  ; Wait                                     [3 cycles]
      cbi   PORTB,1     ; LED at PB1 on                            [2 cycle ]
      sbi   PORTB,2     ; LED at PB2 off                           [2 cycles]
      rcall delay_long  ; Wait                                     [3 cycles]
      rjmp   loop       ;                                          [2 cycle ]

; Generate a delay using three nested loops that does nothing.
; Original Note: With a 10 MHz clock, the values below produce ~261 ms delay.
; Original Values: 10,255,255
;
; My formula: cycles = 3 + [3 + [3 + 4 x {r25}] x {r24}] x {r25}
; I wrote a Python script to come up with the best values, which are:
; r25=44  r24=217  r23=65     or
; r25=242  r24=20  r23=130
   delay_long:          ;
      ldi   r23,65      ; r23 <-- Counter for outer loop            [1 cycle ]
  d1: ldi   r24,217     ; r24 <-- Counter for level 2 loop          [1 cycle ]
  d2: ldi   r25,44      ; r25 <-- Counter for inner loop            [1 cycle ]
  d3: dec   r25         ; decrement r25                             [1 cycle ]
      nop               ; no operation                              [1 cycle ]
	  brne  d3          ;                                           [1 cycle if 0, 2 cycles other]
      dec   r24         ;                                           [1 cycle ]
      brne  d2          ;                                           [1 cycle if 0, 2 cycles other]
      dec   r23         ;                                           [1 cycle ]
      brne  d1          ;                                           [1 cycle if 0, 2 cycles other]
      ret               ;                                           [4 cycles]
.exit