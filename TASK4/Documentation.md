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

### Step 3: Implementation
Steps to Transmit the Code


### Step 4: Testing and Verification
Steps of Testing and Verification

### Step 5: Documentation

Block and Circuit Diagrams (respectively)

Video Demonstrating System Transmitting Data

note: here you cannot see the LED blinking as the time intervals between each 0 and 1 are extremely tiny
