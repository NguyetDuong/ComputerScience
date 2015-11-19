#CS61C 
## Thursday, 12 February 2015

Usually we **interpret** a high-level language; therefore these are very inefficient because there's a need to translate in order to be used. 

* **Interpreter:** directly executes a program in the source language
* **Translator:** converts a program from source language to an equivalent program in another language

The reason we would use an interpret machine language in software is because you may want to change/convert to different architecture.

Translated/compiled code is almost always more efficient and therefore high performance. 

###Assembler
Some of the information is not complete because they only see part of the program. We also include a little bit of information/chart on the side to tell us a little bit more information.

These things are usually in the sense of .name_of_type

* You can add pieces into each other. Such as *.word* inside of *.text*

There is also a pseudo instruction, which is essentially an easier way to write MISP -- or rather not easier but more like faster because it's shorter.

###Integer Multiplication
Need to realize we multiply *register* in MIPS, therefore it will be like:

* 32-bit value x 32-bit value = 640bit
* We will end up storing the product into a special result register, where half of the bits goes in **hi** and the other half goes in **low**. 
* These register are different from the general registers

###Integer Division
Very similar to the multiplication in MIPS, however the **hi** now holds the remainders, and the **low** will hold the quotient. Therefore such modulo & division come as a package -- sometimes there may not have remainders(??)

###Object File Format
Make sure we know that the tex_segment is actually something we're trying to get the machines to use/read. Everything else is mainly for the writer to understand/know more about when writing the program.

###Linker
The advantage is that we do not have to recompile everything -- just whatever we changed to save some time.

It puts two things together, arranging information correctly (text -> data)

---

## Tuesday, 17 February 2015

###Hardware Design
Why study hardware design?

- understand capabilities and limitations of hw in general and processors in particular
- what processors can do fast and what they can't do fast (avoid slow things if you want your code to run fast)
- hard to know what you'll need for the next 30 years
- there is only so much you can do with standard processors: you may need to design own custom HW for extra performance 

Essentially to build new things, mostly since now, in our generation, DeMorgan's law is no longer "true" and things may be needed to change. As a result, we may need to know more about it

###Synchronous Digital System
Example is MIPS, hardware of a processor. 

**Synchronous:** All operations coordinated by a central clock ("heartbeat" of a system)
*
**Digital:** Represent all values by discrete values by two binary digits (1 & 0). Using electric signal. 

Switches is an example of physical implementation. 
Open is **0** and closed is **1**. Switches uses Boolean Operators (and/or) to make functions/switches to work in a complex way. 

###Transistors
- High Voltage (1) or true
- Low Voltage (0) or False
- Pick a midpoint voltage to decide if 0 or 1; if greater than midpoint, then 1, else 0.

Make sure to never create a transistor such that somehow we will send both 1 & 0 voltage to the output because then it will create a shortage and RIP Transistor. Key point to remember. Never will it be able to send both 1 and 0. 

###CMOS Transistor Network
This is the modern digital transistor. These act as a voltage-controlled switches. Some benefits is that the circuit does not take a lot of energy to maintain and only uses it when you turn the switch on/off. 

There are three terminals: source, gate, and drain. N-type and P-types are opposite of each other. Remember one and switch it depending when it is connected or not. 

----
##Thursdays, 19 February 2015
###Types of Circuits

- Combinational Logic circuits
- Sequential Logic

Accumulator reads a string of value and adds them up. Combination circuits may not necessarily work in order to do this because we're going to get a feedback -- cannot actually start at 0. 
- Therefore we will add a register in the middle of the loop 
- The clock allows us to know when we should move onto the next value/step
- A dash in a line tells us there is more than one bit (more than one wire)

###Register Internals
- Flip-Flop is when you change between 0 and 1. 
- There's a D and Q. **D** is input, **Q** is output
- Edges trigger the d-type flip-flops 
- So initially, there is a shift going up, we noticed that D gets shifted but our Q does not. This is because we haven't "ran" the system yet -- when we do, we'll notice a change. As a result, later on it changes but there's still a late delay
- THIS IS IMPORTANT!!

Flip flops will only work right if during the "setup time" and  "hold time" the wave length are stable. 

Input data must be stable -- either a 1 or 0, does not change. Therefore during this window, you have to stay the same value or else the machine will not be sure whether or not it is 0 or 1. 

How to stop it from moving in the window: constant on how fast you clock it; make sure the time in between clock edges is long enough for the combination logic has settled down.

Constrains how fast we can clock a system. 

The time how long it takes to settle down is proportional to the amount of logic gates (so put less stuff in between and will be able to allow the system to move faster).

Input data is coming from another register, and the output will be placed into another register. 

###Accumulator Timing 
After every rising clock edge, we will get the new sum edge at the bottom (so what number it is). 

So follow the path of the circuits so we can see when things get changed?

Notice the time delay -- this will show us how good we designed our "adder". Remember it needs to match up with the clock edge

###Maximum Clock Frequency
So essentially how fast we can clock our program/have our program function. Which is just 1/period (1 over period). This includes how long it takes the logic, set the register and the register producing the value for the next cycle. 

3 components:

1. clock-to-q delay
2. CL delay
3. Set up time

###Critical Paths
Will force us to wait so programers need to make do with the time they are given. So a cheat we can do is add a register in the middle. This is called **pipelining**. However a downside is that it might take it longer to get it from end to end since there is a set up time for each register we have. 

Will be good when we need to do multiple addition at the a time -- allows parallelism. 

###Clicker
Start at a clock edge, so we have ins for the clock edge -- then we find the longest path. Then we see that it has to go through 3 AND gates because this will be the longest path. Therefore this is an additional 3ns. We need to do the set up time (ins) in order to continue/raise the clock edge. And then we need to set up before this entire thing. 

As a result we have 5ns and therefore it is 200MHz. 

The reason we don't run through the shortest one/critical path is because we run in parallel. As a result it does not affect our time mostly since it is the shortest path to go. 

###Finite State Machine Intro

Should have seen this in other classes, so something with finite number of states and uses a function. 

In order to specify this, we can use a truth table.

###Data Multiplexer (Mux)
You have two inputs, may have n-bits of inputs. Then we will have a signal that will let us choose one to send it out to the output. So can choose either the "A" input or "B" input to come out. 

There are three inputs with one output. So we need 8 rows for our truth table (TT). 2^3. Select ("S") is an input table too. 

Now from this, we can optimize and make it into a logic expression that we can do. 

If there are more inputs, you would need more select inputs so we'd choose the correct amount. 

---
## Tuesday, 24 February 2015

Combination circuits can always be described through a truth table. But realize that the more input we have, the more "rows" we'll have. So the trick is to break them into parts and then cascade upward.

Therefore we look at one bit at a time, usually the least significant bit. Slow map it all the way back up after you get whether or not it is true/false from one or two bits.

Full adder: breaks it into parts 