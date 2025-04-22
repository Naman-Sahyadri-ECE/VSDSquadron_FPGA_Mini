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
