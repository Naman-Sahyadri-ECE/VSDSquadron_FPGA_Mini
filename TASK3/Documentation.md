
## Objective: 
Develop a UART transmitter module capable of sending serial data from the FPGA to an external device.
### Step 1: Study the Existing Code

A UART transmitter module is a hardware component that enables serial communication from an FPGA to external devices by converting parallel data into sequential bits . This module serves as a fundamental interface for sending data between the FPGA and external devices such as computers, microcontrollers, or other electronic equipment.It is sourced from this [repository](https://github.com/thesourcerer8/VSDSquadron_FM/tree/main/uart_tx).

### Module Overview
This is a VHDL implementation of an 8N1 UART transmitter module designed for Field-Programmable Gate Arrays (FPGAs). The module handles asynchronous serial data transmission with specific parameters:
- 8 data bits
- No parity bit
- 1 stop bit

### State Machine Operation
1. **IDLE State (*STATE_IDLE*)**
   - Maintains TX line high (idle condition)
   - Waits for senddata trigger
   - Resets txdone flag
2. **STARTTX State (*STATE_STARTTX*)**
   - Transmits start bit (logic low)
   - Loads transmission buffer with txbyte
   - Immediately transitions to *TXING* state
3. **TXING State (*STATE_TXING*)**
   - Sends data bits sequentially
   - Shifts buffer right for next bit
   - Counts transmitted bits (0-7)
   - Continues until all 8 bits sent
4. **TXDONE State (*STATE_TXDONE*)**
   - Sends stop bit (logic high)
   - Sets *txdone* flag
   - Returns to IDLE state

### Step 2: Design Documentation

Block Diagram

![Block diagram1](https://github.com/user-attachments/assets/c9a8edc1-e49c-4957-9da8-01299da9f4ca)

Circuit Diagram

![Circuit diagram1](https://github.com/user-attachments/assets/71b79414-f6e2-44d9-8d35-78e3a5109d8d)


### Step 3: Implementation
Steps to Transmit the Code

1. Create a new folder UART_transmission under VSDSquadron_FM folder and upload the codes and Makefile in it.
2. Then, open terminal and through the commands
   - cd
   - cd VSDSquadron_FM
   - cd uart_transmission
   - lsusb
   - make clean
   - make build
   - sudo make flash

That is all. The code is transmitted.


### Step 4: Testing and Verification

Steps of Testing and Verification

1. Install picocom in the terminal using command sudo apt install picocom

2. ls/dev/tty*

3. You can see dev/ttyUSB0

4. sudo picocom -b 9600 /dev/ttyUSB0

5. Then, check that a series of "D"s are generated and the RGB LED is blinking (switching between red, green and blue) .

   ![image](https://github.com/user-attachments/assets/99f4b1b5-5ff1-4322-a496-f948859d66c3)


If so, you have successfully completed the task.

### Step 5: Documentation
UART Transmission in Operation


https://github.com/user-attachments/assets/0a63547a-93af-45d1-97dc-7f8e5750cf55




Block and Circuit Diagram (respectively)

![Block diagram1](https://github.com/user-attachments/assets/c9a8edc1-e49c-4957-9da8-01299da9f4ca)

![Circuit diagram1](https://github.com/user-attachments/assets/71b79414-f6e2-44d9-8d35-78e3a5109d8d)

    
