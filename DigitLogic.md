# Logic and Computer Design Fundamentals
~~*this review mainly focus on some special points and terminology*~~

## Some Special Codes

- **BCD**

> 4 Binary bit as a Decimal bit
> Simply flatten up in converting

- *Excess 3 code*

  - BCD + 3
  - easy to do adding(automatically add carry)
- **Gray**

> Flip only one bit each turn
> $Gray Code = (K)_2 \ \ xor \ \ ((K)_2 >> 1)$
> *Useful in K-map and optimization!*

- **Parity Bit**

  - odd parity & even parity
    - Final result of 1's
  - MSB & LSB
    - Most/Least Significant Bit
  
- **Radix Complement(补码)**
  - r’s complement for radix r
  - 2’s complement in binary
  - Defined as $r^N - x$

- **Diminished Radix Complement（反码）**
  - (r - 1)’s complement for radix r
  - 1’s complement for radix 2
  - Defined as $r^N - 1 - x$ , "flipping" every bit actually

## Arithmetic System

- In computer system, it's actually a **"$mod \ r^N$"** system for N bit calculation
- $X - Y \equiv X + r^N - Y \equiv X + \overline{Y}(mod \ r^N)$
  
- **Unsigned Subtraction**
  - Use 2's Complement, then the answer actually is $X - Y + r^N$
  - Thus check the final carry bit(actually Nth bit) 
    - 1 : $X \geq Y$, result is answer
    - 0 : $X < Y$, answer is negative, thus the answer is $-(r^N - result)$

- **Signed Subtraction**
  - Just use 2's Complement to convert subtraction into addition
  
- **Overflow**
  - Unsigned
    - Extra carry bit in addition 
  - Signed 
    - (+A) + (+B) = (-C)
    - (-A) + (-B) = (+C)

## Boolean Algebra
- Dual
  - Interchange only And/Or
- Complement
  - DeMorgan's Law
- Duality Rules
> A boolean equation remains valid if we take 
the dual of the expressions on both sides of the equals sign

- Important Formulars
  - $X + XY = X$
  - $X(X+Y) = X$
  - $XY + X \overline{Y} = X$
  - $(X+Y)(X+\overline{Y})=X$
  - **$X + \overline{X}Y = X + Y$**
  - **$X(\overline{X}+Y)=XY$**

- **Consensus Theorem**
> $XY+\overline{X}Z+YZ=XY+\overline{X}Z$            (YZ is redundant) 
> $(X+Y)(\overline{X}+Z)(Y+Z)=(X+Y)(\overline{X}+Z)$        (dual)

- **Canonical Form**
  - SOM (sum of miniterm)
    - Choose 1's 
  - POM (product of maxterm)
    - Choose 0's
  - **Cost**
    - Literal cost
      - Number of literals 
    - Gate-input cost
      - Input wires (literal cost + combinational structure)
    - Gate-input cost with NOTs  
      - Gate-input cost + NOTs
  - **K-map**
    - Implicant
      - A product term in SOP
    - Prime Implicant
      - A product term obtained by combining the maximum possible number of adjacent squares in the map with $2^N$ number of squares
    - Essential Prime Implicant
      - Prime Implicant that essentially covers some squares(must pick)
    - Don't cares
      - Self assume the value, mostly choose 1
    - *POS optimization*
      - Optimize the $\overline{F}$ which is SOP  