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
  - *In Binary, as (~x + 1)*
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
> the dual of the expressions on both sides of the equals sign

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
      - Gate-input cost + NOTs (**count every literal only once**)
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

## Combinational Logic

- Delays
  - Transition Time (**Focus on output change**)
    - $t_{LH}=t_r$ : 10% Low to 90% High  (rise)
    - $t_{HL}=t_f$ : 90% High to 10% Low  (fall)
  - Propagation Delay (**Focus on output change by input change**)
    - Time from half of input change to half of output change
    - $t_{pd} = max(t_{pHL}, t_{pLH})$  (sometimes is average)
  - Model
    - Transport Delay
      - $t_{pd}=t_{固有}+k*SL$ (sum of fan-out standard loads)
    - Inertial Delay
      - Rejection Time : rejects narrow “pulses” on the outputs

- Technology Mapping
  - Use NAND/NOR to implement any logic
  - Optimize
    - Push down NOTs
    - Remove redundant gates (linked NOTs)
    - Keep doing 

- Decoder
  - $N - 2^N$ One-Hot Decoder
  - Hierarchical Design
    - $N-2^N = (\frac{N}{2} - 2^{\frac{N}{2}} )\times (\frac{N}{2} - 2^{\frac{N}{2}})$  
    - Sometimes we can use ENABLE as a select signal
- Encoder
  - $2^N-N$ One-Hot Encoder 
  - $2^K-N$ Priority Encoder
- Multiplexer
  - $2^N-1$ MUX
  - Input AND Decoder --OR--> Output
  - Expansion
    - Focus on how to cope with the multi-outputs of several MUXs
  - Implement Combinational Logic Function
    - Simple 
      - Input: Output in truth table
      - Select: Input
    - Efficient
      - Divide the input into two parts
      - Select : the first part as the select signal of the second part
      - Input : combination logic of the second part
  - *Use 3-state gate to optimize the cost*
- Demultiplexer
  - $1-2^N$ DeMUX

- Half Adder  (No last carry)
  - $S = A \oplus B$
  - $C = AB$
- Full Adder
  - $S = (A \oplus B)\oplus Z$
  - $C = AB + Z(A \oplus B)$
- Ripple-Carry Binary Adder (*with $\oplus$ gate)
  - Linked Full Adders
  - The first carry 1 means doing subtraction(2's complement) 
- **Carry Lookahead Adder*
  - $G_i = A_iB_i$
  - $P_i = A_i \oplus B_i$
  - $C_{i+1} = G_i + P_iC_i$
  - $S_i = P_i \oplus C_i$

- (P)ROM
  - Read-Only Memory 
  - Programmable only once
  - $2^K \times N$ ROM ($2^K$ addresses by $K - 2^K$ Decoder, N bits per address) 
  - For a given address line, the connected data column is 1, others are 0
- PAL
  - Programmable Array Logic
  - Programmable only once
  - K inputs into 2*K columns($X/\overline{X}$)
  - Fixed structure of N AO, but programmable AND terms
  - One output can be used as input of another output as compensation 
- PLA
  - Programmable Logic Array
  - Programmable only once
  - K inputs into 2*K columns($X/\overline{X}$)
  - N programmable AND terms
  - M programmable OR terms (select miniterms above) with M programmable XOR terms (get inverters)
  - Optimize by optimizing both $F/\overline{F}$
- FPGA
  - Field Programmable Gate Array 
  - LUT
    - Look-Up Table
    - Like $2^K - 1$ RAM
    - Expansion:
      - Shannon’s expansion theorem : $F = F(X_1, X_2, ..., X_n) = X_nF(X_1, X_2, ..., X_{n-1}, 1) + \overline{X_n}F(X_1, X_2, ..., X_{n-1},0)$
    - **CLB*
      - Configurable Logic Block
      - LUT + Flip-Flop 
    - **SM*
      - Switch Matrix
      - Interconnects between CLBs 
    - **IOB*
      - Input/Output Block
      - Connects to the outside world
 
## Hardware Implementation
- **CMOS*
  - NMOS - GND, PMOS - VCC
  - NMOS & PMOS in series(complesmentary & dual) 
