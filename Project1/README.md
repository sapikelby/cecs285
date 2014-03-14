CECS 285
Project 1: Examining 8051 I/O Ports
Purpose:
The purpose of this lab is to examine the basic operations on the 8051 I/O ports. 
Description:
Design a system with your 8051 board using assembly to perform the following 4 different LED display modes:
1.	Mode 1: Bouncing mode. (A filled circle represent an LED that is on.)
•???????, ?•??????, ??•?????, ???•????, ????•???, ?????•??, ??????•?,???????•, ??????•?, ?????•??, ????•???, ???•????, ??•?????, ?•??????, and then repeat.
2.	Mode 2: Counting up mode. Count up from 0 to 255 and then repeat.
3.	Mode 3: Double bouncing mode. •??????•,?•????•?, ??•??•??, ???••???, ??•??•??, ?•????•?,  and then repeat.
4.	Mode 4: Cyclic mode. ????????, •???????, ••??????, •••?????, ••••????, •••••???, ••••••??, •••••••?, ••••••••, and then repeat.
5.	When all 4 mode pins are off, flash the LEDs.

Mode Control: Use on-board dip switches number 5-8 to select the mode: P0.0 (numbered 8 on board) selects Mode 1, P0.1 (numbered 7 on board) selects Mode 2, P0.2 (numbered 6 on board) selects Mode 3, P0.3 (numbered 5 on board) selects Mode 4. Lower index pins have higher priority. For example, if both P0.0 and P0.3 is on, display Mode 1 instead of Mode 4. When all 4 pins are off, flash all LEDs: turn on and off all of them every 0.5 second. When you start running your system, your system should enter a display mode according to the initial mode setting on your board. If no mode is set when you start your system, flash all LEDs.

Speed Control: Use on-board dip switches number 1 - 4 to select delay length. P0.4 (numbered 4 on board) sets delay to be 0.5 second, P0.5 (numbered 3 on board) sets delay to be 1 second; P0.6 (numbered 2 on board) sets delay to be 1.5 second, P0.7 (numbered 1 on board) sets delay to be 2 second. When all 4 pins are off, use half second delay between two patterns. When multiple pins are on, lowest number pin determines the speed setting.

Changing Modes: the mode can be changed at any time when the mode control switches change.

Changing Speed: Speed can be changed after each delay period.
Components you may need: You only need your Lab Pro-51 board for this project. 
