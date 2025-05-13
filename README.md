# VSDSquadron_FPGA_Mini

# ABOUT ME🚀
Name: NAMAN M
-
College: Sahyadri College of Engineering and Management, Adyar, Mangaluru.
-
Email ID: naman.ec22@sahyadri.edu.in or namanm152003@gmail.com
-
LinkedIn: [Naman M](https://www.linkedin.com/in/naman-m-28214526a)

<details>
<summary>TASK1:Understanding and Implementing the Verilog Code on the VSDSquadron FPGA Mini Board</summary>

## Observations from the given verilog code and PCF file
## Purpose of the Module
The top module is a simple hardware design that uses an internal high-frequency oscillator to drive a counter.

Controls an RGB LED using a dedicated RGB driver primitive.

Demonstrates internal oscillator usage and visual output on hardware LEDs for verification or debugging purposes.

## Description of Internal Logic and Oscillator
frequency_counter_i:

A 28-bit counter (reg [27:0] frequency_counter_i) is incremented on every rising edge of the internal oscillator clock (int_osc).

This counter is used as a simple activity indicator and can be tapped to drive various outputs.

int_osc: Internal Oscillator

Configured via CLKHF_DIV = "0b10", which sets the oscillator division factor (typically gives 12 MHz from a 48 MHz base).

Always enabled with CLKHFPU = 1'b1 and CLKHFEN = 1'b1.

## Functionality of the RGB LED Driver
SB_RGBA_DRV: RGB Driver Primitive

This Lattice-specific primitive controls three color channels: Red, Green, Blue.

The driver is always enabled via RGBLEDEN = 1'b1.

Color intensities are defined via:

RGB0PWM, RGB1PWM, RGB2PWM: PWM inputs for red, green, and blue respectively.

In the top.v code:

RGB0PWM = 1'b0 → Red OFF

RGB1PWM = 1'b0 → Green OFF

RGB2PWM = 1'b1 → Blue ON (constant)

Output signals RGB0, RGB1, and RGB2 are mapped to led_red, led_green, and led_blue.

## Current Drive Configuration
RGBx_CURRENT parameters are set to "0b000001" for each channel.

This specifies a minimal current drive for safe low-brightness operation.

test Wire Output:

testwire is driven by bit 5 of the frequency counter.

It toggles periodically based on oscillator frequency — useful for debugging or scope probing.


## From the given PCF file Pin Mapping and Functional Overview

|Signal |Assigned Pin  | Function in Verilog| Hardware Role | 
|----------|-------|-------|--------|
| led_red  | 	Pin 39 | Connected to RGB0 of SB_RGBA_DRV | Controls the red channel of the onboard RGB LED  |
| led_green  | 	Pin 41 | Connected to RGB1 of SB_RGBA_DRV | Controls the green channel of the onboard RGB LED  |
| led_blue  | 	Pin 40 | Connected to RGB2 of SB_RGBA_DRV | Controls the blue channel of the onboard RGB LED  |
| hw_clk | 	Pin 20 | Declared but unused in current Verilog code |Reserved for an external hardware clock input; currently inactive  |
| testwire | Pin 17 | Assigned to frequency_counter_i[5] |Outputs a toggling signal derived from the internal oscillator for testing purposes  |

# Integrating with the VSDSquadron FPGA Mini Board:
cd

cd VSDSquadron_FM

cd RGB

lsusb

make clean

make build

sudo make flash

Now i observed that i can see only blue colour led is ON because in the given code only blue pin was enabled to 1b'1 and  if i enable other pins also the colour doesn't change frequently. 

This was my output in initially:


https://github.com/user-attachments/assets/d142d73c-bf77-4a6c-8d5a-2f08299026ec


So i made the necessary changes in the code to get the RGB output, I changed the following part of the code:
 
 SB_RGBA_DRV RGB_DRIVER (
    
    .RGBLEDEN(1'b1                                            ),
    
    .RGB0PWM (frequency_counter_i[24]&frequency_counter_i[23] ),
    
    .RGB1PWM (frequency_counter_i[24]&~frequency_counter_i[23]),
    
    .RGB2PWM (~frequency_counter_i[24]&frequency_counter_i[23]),
    
    .CURREN  (1'b1                                            ),
    
    .RGB0    (led_red                                       ), //Actual Hardware connection
    
    .RGB1    (led_green                                       ),
    
    .RGB2    (led_blue                                        )
  
  );

  
And the my final output is as shown below:

https://github.com/user-attachments/assets/c21a4ea7-ec6e-43a4-947b-a79613b57c69


## My Final working code:

//----------------------------------------------------------------------------

//                                                                          --

//                         Module Declaration                               --

//                                                                          --

//----------------------------------------------------------------------------

module top (
// outputs
  
  output wire led_red  , // Red
 
  output wire led_blue , // Blue
 
  output wire led_green , // Green
  input wire hw_clk,  // Hardware Oscillator, not the internal oscillator
  
  output wire testwire
);

  wire        int_osc            ;
  
  reg  [27:0] frequency_counter_i;

  assign testwire = frequency_counter_i[5];
 
  always @(posedge int_osc) begin
   
    frequency_counter_i <= frequency_counter_i + 1'b1;
  
  end


//----------------------------------------------------------------------------

//                                                                          --

//                       Counter                                            --

//                                                                          --

//----------------------------------------------------------------------------

//----------------------------------------------------------------------------

//                                                                          --

//                       Internal Oscillator                                --

//                                                                          --

//----------------------------------------------------------------------------

  SB_HFOSC #(.CLKHF_DIV ("0b10")) u_SB_HFOSC ( .CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));


//----------------------------------------------------------------------------

//                                                                          --

//                       Instantiate RGB primitive                          --

//                                                                          --

//----------------------------------------------------------------------------

  SB_RGBA_DRV RGB_DRIVER (
  
    .RGBLEDEN(1'b1                                            ),
    
    .RGB0PWM (frequency_counter_i[24]&frequency_counter_i[23] ),
    
    .RGB1PWM (frequency_counter_i[24]&~frequency_counter_i[23]),
    
    .RGB2PWM (~frequency_counter_i[24]&frequency_counter_i[23]),
    
    .CURREN  (1'b1                                            ),
    
    .RGB0    (led_red                                       ), //Actual Hardware connection
    
    .RGB1    (led_green                                       ),
    
    .RGB2    (led_blue                                        )
  
  );
  
  defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
  
  defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
  
  defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";

endmodule


## Final PCF file:
set_io  led_red	39

set_io  led_blue 40

set_io  led_green 41

set_io  hw_clk 20

set_io  testwire 17

</details>

<details>
<summary>TASK2: Implement a UART loopback mechanism where transmitted data is immediately received back, facilitating testing of UART functionality.</summary>

 # Step 1: Study the Existing Code
UART (Universal Asynchronous Receiver-Transmitter) is a hardware communication protocol used for serial communication between devices. It consists of two main data lines: the TX (Transmit) pin and the RX (Receive) pin. Specifically, a UART loopback mechanism is a test or diagnostic mode where data, which is transmitted to the TX (transmit) pin is directly routed back to the RX (receive) pin of the same module. This allows the system to verify that the TX and RX lines function correctly without the need of an external device.

## Analysis of Existing Code:

### Port Analysis:
The module explains six ports:
- Three RGB LED outputs (led_red, led_blue, led_green)
- UART transmit/receive pins (uarttx, uartrx)
- System clock input (hw_clk)

### Internal Component Analysis:

1.Internal Oscilliator (SB_HFOSC)
- Implements a high-frequency oscillator
- Uses CLKHF_DIV = "0b10" for frequency division
- Generates internal clock signal (int_osc)

2.Frequency Counter
- 28-bit counter (frequency_counter_i)
- Increments on every positive edge of internal oscillator
-Used for timing generation

3.UART Loopback
- Direct connection between transmit and receive pins
- Echoes back any received UART data immediately
  
4.RGB LED Driver (SB_RGBA_DRV)
- Controls three RGB channels
- Uses PWM (Pulse Width Modulation) for brightness control
- Current settings configured for each channel
- Maps UART input directly to LED intensity

##### UART Input Processing:
- Received UART data appears on uartrx pin
- Data is immediately looped back out through uarttx
- Same data drives all RGB channels simultaneously

#### LED Control
- RGB driver converts UART signal to PWM output
- All LEDs respond identically to input signal
- Current limiting set to minimum (0b000001) for each channel

# Step 2: Design Documentation
Block Diagram Illustrating the UART Loopback Architecture.

![Block Diagram](https://github.com/user-attachments/assets/09026b00-ce71-49df-90c6-1276910f4edd)

Detailed Circuit Diagram showing Connections between the FPGA and any Peripheral Devices used.

![Circuit diagram](https://github.com/user-attachments/assets/f89f81a1-daa2-4b23-97ef-26cff4bdeae2)

# Step 3: Implementation
### Steps to upload the code to FPGA board:
1. Create your project folder inside VSDSquadron_FM folder and upload the give verilog codes and Makefile in it.

![Screenshot 2025-04-27 212403](https://github.com/user-attachments/assets/1f07b6e6-0555-4996-856f-fc32ade0c408)

2. Open in terminal. Connect your board and give the following commands:
   cd

   cd VSDSquadron_FM

   cd UART_loopback

   lsusb

   make clean

    make build

   sudo make flash

   ![Screenshot 2025-04-27 205811](https://github.com/user-attachments/assets/70f009b6-f67f-41e1-897b-19edc7bc6057)


That is it. You have successfully finished transmitting the code.


# Step 4: Testing and Verification

- Downlaod Docklight software, which can be downloaded from its website.

- Open Docklight and verify that your system (not the VM) is connected to the right communication port - in my case it is COM14 and the default was COM3 - and if not, change it through tools > project settings. Also verify that speed is set to 9600.

![Screenshot 2025-04-27 191600](https://github.com/user-attachments/assets/297f512e-8fa4-45f1-b28f-1dade494ab01)

- Now, double click on the small blue box in the send sequence below the name and enter a name, select a format and then type your message. Click "Apply" and then verify that this has entered in send sequences. Then, click run option in the top and click the arrow beside the name and verify the result:

![Screenshot 2025-04-27 205051](https://github.com/user-attachments/assets/e59d4230-d59a-44ea-b9cc-b24fdc717b4f)

![Screenshot 2025-04-27 192816](https://github.com/user-attachments/assets/c985d80a-329c-4ae5-a5a0-52807c47a0b4)


# Step 5: Documentation

### Block Diagram:

![Block Diagram](https://github.com/user-attachments/assets/09026b00-ce71-49df-90c6-1276910f4edd)

### Circuit Diagram:

![Circuit diagram](https://github.com/user-attachments/assets/f89f81a1-daa2-4b23-97ef-26cff4bdeae2)

### Testing Results:

![Screenshot 2025-04-27 192816](https://github.com/user-attachments/assets/52cff499-c2ab-42c3-81e3-89088950deac)


### Video demonstrating Loopback Functionality

https://github.com/user-attachments/assets/824a6215-af8d-4d90-97e3-41508c52d6ff

</details>

 </details>

<details>
<summary>TASK3:  Develop a UART transmitter module capable of sending serial data from the FPGA to an external device.</summary>

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

    
</details>

<details>

 <summary>TASK4: Implement a UART transmitter that sends data based on sensor inputs, enabling the FPGA to communicate real-time sensor data to an external device.</summary>

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

![Screenshot 2025-05-02 131537](https://github.com/user-attachments/assets/6f47e69b-1b08-4c60-a6a3-9fba262800a9)



### Step 5: Documentation

Block and Circuit Diagrams (respectively)

![BLOCKDIAGRAM3](https://github.com/user-attachments/assets/10b26e0d-1cc9-4daa-8713-7a45678d4a63)


![CIRCUITDIAGRAM3](https://github.com/user-attachments/assets/ba727fc1-704e-48ca-a01e-0c68040d2e2f)

Video Demonstrating System Transmitting Data

https://github.com/user-attachments/assets/caf9e59d-c485-423f-852d-966870ba93b0

</details>

<details>
 <summary>TASK5: Project Themes. </summary>
</details><
<details>
  <summary>TASK6: Final Project Implementation. </summary>
 
 ## FPGA-Based UART-Controlled Actuator System
Overview:

Develop a system where the FPGA receives control commands via UART to operates LEDs. This project focuses on decoding serial commands and translating them into physical actions.

Working:

- Three different leds are driven by uart commands.
- Commands are sent from DOCKLIGHT software
- When the data is transmitted to fpga through UART, different leds get turned ON in a order. when each command is given each led will ON.

Codes:
These are the top.v and uart_trx.v codes used:

`include "uart_trx.v"

module top (

    input clk,
    input uartrx,
    output [2:0] rgb
    
);

    wire [7:0] rxbyte;
    
    wire received;

    reg [2:0] rgb_reg = 3'b001; // Start with RED
    assign rgb = rgb_reg;

    uart_rx_8n1 uart_inst (
        .clk(clk),
        .rx(uartrx),
        .rxbyte(rxbyte),
        .received(received)
    );

    always @(posedge clk) begin
        if (received) begin
            // Cycle through RED → GREEN → BLUE → RED...
            case (rgb_reg)
                3'b001: rgb_reg <= 3'b010; // RED → GREEN
                3'b010: rgb_reg <= 3'b100; // GREEN → BLUE
                3'b100: rgb_reg <= 3'b001; // BLUE → RED
                default: rgb_reg <= 3'b001; // fallback to RED
            endcase
            end
            end
            endmodule



module uart_rx_8n1 (
    
    input clk,
    input rx,
    output reg [7:0] rxbyte = 0,
    output reg received = 0
    
);
   
    reg [3:0] bitindex = 0;
    reg [7:0] data = 0;
    reg [12:0] clkcount = 0;
    reg busy = 0;
    reg rx_sync = 1;

    parameter BAUD_TICKS = 5208;  // 50 MHz / 9600

    always @(posedge clk) begin
        rx_sync <= rx;

        if (!busy) begin
            received <= 0;
            if (rx_sync == 0) begin  // start bit
                busy <= 1;
                clkcount <= BAUD_TICKS / 2;
                bitindex <= 0;
            end
        end else begin
            if (clkcount == 0) begin
                clkcount <= BAUD_TICKS;
                if (bitindex < 8) begin
                    data[bitindex] <= rx_sync;
                    bitindex <= bitindex + 1;
                end else if (bitindex == 8) begin
                    rxbyte <= data;
                    received <= 1;
                    busy <= 0;
                end
            end else begin
                clkcount <= clkcount - 1;
            end
        end
    end
    endmodule
Circuit:

![Data Out (2)](https://github.com/user-attachments/assets/9f2334ca-fffa-4e4a-bd76-b06a40756329)

Working Video:

https://github.com/user-attachments/assets/765878e1-adbd-4526-91e3-368cbc57a2f8


## FPGA-Based UART-Controlled Display System
Overview:

Design a system where the FPGA receives data via UART and displays it on an output device, such as a 7-segment display or an LCD. This project emphasizes real-time data reception and visualization.

Working:
- A segment display is connected to the FPGA board.
- Commands are sent from DOCKLIGHT software to the FPGA.
- When the data is transmitted to fpga through UART, the numbers increment in the seven segment display for each command.

CODE:
These are the top.v and uart_trx.v codes used:

`include "uart_trx.v"

module top (
   
    input clk,
    input uartrx,
   
    output [2:0] rgb
);
    
    wire [7:0] rxbyte;
    wire received;

    reg [2:0] rgb_reg = 3'b001; // Start with RED
    assign rgb = rgb_reg;

    uart_rx_8n1 uart_inst (
        .clk(clk),
        .rx(uartrx),
        .rxbyte(rxbyte),
        .received(received)
    );

    always @(posedge clk) begin
        if (received) begin
            // Cycle through RED → GREEN → BLUE → RED...
            case (rgb_reg)
                3'b001: rgb_reg <= 3'b010; // RED → GREEN
                3'b010: rgb_reg <= 3'b100; // GREEN → BLUE
                3'b100: rgb_reg <= 3'b001; // BLUE → RED
                default: rgb_reg <= 3'b001; // fallback to RED
            endcase
        end
    end
    endmodule


---------------------------------------------------------------------------------
    module uart_rx_8n1 (
    
    input clk,
    input rx,
    output reg [7:0] rxbyte = 0,
    output reg received = 0

);
    
    reg [3:0] bitindex = 0;
    reg [7:0] data = 0;
    reg [12:0] clkcount = 0;
    reg busy = 0;
    reg rx_sync = 1;

    parameter BAUD_TICKS = 5208;  // 50 MHz / 9600

    always @(posedge clk) begin
        rx_sync <= rx;

        if (!busy) begin
            received <= 0;
            if (rx_sync == 0) begin  // start bit
                busy <= 1;
                clkcount <= BAUD_TICKS / 2;
                bitindex <= 0;
            end
        end else begin
            if (clkcount == 0) begin
                clkcount <= BAUD_TICKS;
                if (bitindex < 8) begin
                    data[bitindex] <= rx_sync;
                    bitindex <= bitindex + 1;
                end else if (bitindex == 8) begin
                    rxbyte <= data;
                    received <= 1;
                    busy <= 0;
                end
            end else begin
                clkcount <= clkcount - 1;
            end
        end
    end
    endmodule


Circuit:

![Data Out (3)](https://github.com/user-attachments/assets/10dbaba1-864a-4b50-9745-d4ad6d34b44d)

Working Video:

https://github.com/user-attachments/assets/bce30ff7-64fd-4e4a-8977-a2be4b28ede3

</details>
