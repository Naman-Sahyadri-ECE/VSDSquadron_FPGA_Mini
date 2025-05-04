## Objective:
Implement a UART transmitter that sends data based on sensor inputs, enabling the FPGA to communicate real-time sensor data to an external device.
### Step 1: Study the Existing Code

Module Analysis

### Architecture Overview
The *uart_tx_sense* module implements a complete **UART transmitter** designed specifically for **sensor data transmission**. The architecture consists of three main components:
1. **Data Buffer Management**
2. **UART Protocol Controller**
3. **Transmission Control Logic**

### Operation Flow
1. **Data Acquisition**
- Sensor data arrives with valid signal assertion
- Module captures data during IDLE state
- 32-bit data buffer stores incoming sensor readings
2. **Transmission Protocol**
- *START*: Generates UART start bit (low)
- *DATA*: Transmits 8 bits sequentially
- *STOP*: Ensures proper termination with high bit
3. **Status Indication**
- *ready* signal indicates ability to accept new data
- *tx_out* provides continuous UART stream
- State transitions ensure reliable data transfer

### Port Analysis
1. **Clock and Reset**
- *clk*: Drives all sequential operations
- *reset_n*: Active-low asynchronous reset
2. **Data Interface**
- *data*: 32-bit wide input for sensor readings
- *valid*: Handshake signal indicating valid data
3. **UART Interface**
- *tx_out*: Serial output following UART protocol
4. **Status Interface**
- *ready*: Indicates module's ability to accept new data

### Internal Component Analysis
1. **State Machine Controller**
- Manages transmission protocol states
- Controls data flow through the module
- Ensures proper UART framing
2. **Data Buffer**
- Stores incoming sensor data
- Provides data stability during transmission
- Handles data synchronization
3. **Transmission Controller**
- Manages bit-by-bit transmission
- Controls UART protocol timing
- Handles start/stop bit generation

### Step 2: Design Documentation

Block and Circuit Diagram

![BLOCKDIAGRAM3](https://github.com/user-attachments/assets/10b26e0d-1cc9-4daa-8713-7a45678d4a63)


![CIRCUITDIAGRAM3](https://github.com/user-attachments/assets/ba727fc1-704e-48ca-a01e-0c68040d2e2f)


### Step 3: Implementation
Steps to Transmit the Code

1. Create a new folder UART_tx_sense under VSDSquadron_FM folder and upload the codes and Makefile in it.
2. Then, open terminal and through the commands
   - cd
   - cd VSDSquadron_FM
   - cd uart_tx_sense
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

5.  Then, check that a series of "D"s are generated and the RGB LED is red.

6.  Here you cannot see the LED blinking as the time intervals between each 0 and 1 are extremely small.


### Step 5: Documentation

Block and Circuit Diagrams (respectively)

![BLOCKDIAGRAM3](https://github.com/user-attachments/assets/10b26e0d-1cc9-4daa-8713-7a45678d4a63)


![CIRCUITDIAGRAM3](https://github.com/user-attachments/assets/ba727fc1-704e-48ca-a01e-0c68040d2e2f)

Video Demonstrating System Transmitting Data

https://github.com/user-attachments/assets/caf9e59d-c485-423f-852d-966870ba93b0



