# Theme 1: FPGA-Based UART-Controlled Display System
## Project Overview
This project aims to design and implement a real-time data reception and visualization system using an FPGA. The system receives serial data via UART from a host (PC/microcontroller), decodes the data, and displays it on an output device such as a 7-segment display or an LCD. The core emphasis is on achieving reliable UART communication, decoding data efficiently, and updating the display in real time.

## Objectives
Implement UART receiver logic in FPGA (Rx-only).

Decode incoming ASCII/hex data to displayable digits.

Drive 7-segment display or LCD module with received data.

Design a user interface on a PC terminal (optional).

Ensure reliable real-time communication and data update.

## System Requirements
VSDSquadron FPGA mini

7-segment display module or LCD 

System Requirements

Ubuntu

Docklight

## Design System Architecture:
![fpga_uart_display_block_diagram_tall](https://github.com/user-attachments/assets/881408a3-2be3-4b4f-9c5a-59a59ae1c45b)


## Functional Description
UART module receives serial data

Data is buffered and validated.

Characters are decoded (e.g., ASCII ‘0’–‘9’ → binary).

Converted value is sent to a display driver.

Output is updated in real-time on the 7-segment or LCD.

The project begins with the requirements analysis and system design phase, where the UART communication specifications such as baud rate, data format (8N1: 8 data bits, no parity, 1 stop bit), and target display output (7-segment or LCD) are clearly defined. During this phase, the hardware platform is selected, that is VSDSquadron FPGA mini. The design includes major components such as a UART receiver, data decoder, and display driver, connected in a pipeline.

Once the system design is established, the next phase focuses on implementing the UART receiver module in Verilog or VHDL. This module is responsible for receiving serial data from a host device (PC or microcontroller) and converting it into parallel form. Special attention is given to UART timing—particularly start bit detection and bit sampling, which must align accurately with the specified baud rate. A testbench is developed to simulate different incoming byte patterns (e.g., ASCII characters like '0' through '9') to ensure the UART receiver captures data correctly and stores it into a register for further processing.

After the UART receiver is verified, the project proceeds to implement the data decoder and display logic. The decoder takes the received UART byte (typically ASCII) and converts it into a usable format for the output display. For instance, ASCII character codes for digits are translated into 4-bit binary values or directly mapped to segment patterns. A display controller is then written to drive the 7-segment display. The controller uses either combinational logic or a state machine to update the display in real time. These components—the UART receiver, decoder, and display driver—are integrated into a top-level module, and appropriate FPGA I/O pins are assigned.

With all modules in place, the system is programmed onto the FPGA for real hardware testing. A USB-to-UART converter is connected to allow a PC to send data using a serial terminal application (Docklight). This stage includes verifying that every character sent over UART is correctly displayed in real time on the output device.



# Theme 2: UART-Controlled Actuator System using FPGA

## Overview
This project aims to develop a system where an FPGA receives control commands over a UART interface and uses these commands to operate actuators such as LEDs, motors, or relays. The design focuses on interpreting serial command strings and executing physical responses via output GPIO pins. This provides a foundation for industrial control, automation, or embedded prototyping applications.

## Objectives
Implement UART receiver on FPGA

Decode command strings like “LED ON” or “MOTOR OFF”

Design FSM to control GPIO based on decoded commands

Interface LEDs, relays, or motors and test system response

Enable real-time interaction through a serial terminal

## System Requirements
Hardware:

VSDSquadron FPGA mini

Actuators: LEDs, Relay Module, DC Motor with driver

UART Interface via FTDI USB-to-Serial module

Breadboard and wires

Software:

Ubuntu 

Docklight

## Design System Architecture:
![uart_actuator_block_diagram](https://github.com/user-attachments/assets/ff700af5-8f44-4460-9745-e41dabdb7ef3)


During this initial phase, a simple test like an LED blink will be implemented on the FPGA to confirm the board setup and pin mapping. This ensures the hardware is functioning correctly and lays the foundation for building and testing more complex modules.

Following setup, the next critical step is designing and implementing the UART Receiver module. This module will be responsible for detecting UART start bits, reading serial bits into a shift register, and generating complete 8-bit data words. Baud rate configuration and timing accuracy will be crucial here. The UART receiver will be tested first in simulation to validate data reception and then integrated with a terminal program to receive ASCII input from a PC. Once confirmed, this module will feed received characters to the next stage.

The third phase focuses on command decoding logic. In this stage, a simple parser or FSM is designed to recognize character sequences like "LED ON", "RELAY OFF", etc. A small buffer or FIFO may be added to accumulate characters. The decoder will check for known patterns and convert them into unique internal control signals or opcodes. This module bridges communication between the UART interface and the control logic. Each valid command will trigger a defined output signal used in the control logic phase.
