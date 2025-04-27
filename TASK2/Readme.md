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

Detailed Circuit Diagram showing Connections between the FPGA and any Peripheral Devices used.

# Step 3: Implementation
### Steps to upload the code to FPGA board:
1. Create a project folder inside VSDSquadron_FM folder and upload the give verilog codesa and make file in it.

2. Open in terminal. Connect your board and give the following commands:
   cd

   cd VSDSquadron_FM

   cd UART_loopback

   lsusb

   make clean

    make build

   sudo make flash

That is it. You have successfully finished transmitting the code.


# Step 4: Testing and Verification

Downlaod Docklight software, which can be downloaded from its website.

Open Docklight and verify that your system (not the VM) is connected to the right communication port - in my case it is COM6 and the default was COM1 - and if not, change it through tools > project settings. Also verify that speed is set to 9600.

Now, double click on the small blue box in the send sequence below the name and enter a name, select a format and then type your message. Click "Apply" and then verify that this has entered in send sequences. Then, click run option in the top and click the arrow beside the name and verify the result:

# Step 5: Documentation

Block and Circuit Diagram (respectively)

Testing Results

Video demonstrating Loopback Functionality



  
