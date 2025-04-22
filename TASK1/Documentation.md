##Purpose of the Module
The top module is a simple hardware design that:

Uses an internal high-frequency oscillator to drive a counter.

Controls an RGB LED using a dedicated RGB driver primitive.

Demonstrates internal oscillator usage and visual output on hardware LEDs for verification or debugging purposes.

Description of Internal Logic and Oscillator
🔄 frequency_counter_i
A 28-bit counter (reg [27:0] frequency_counter_i) is incremented on every rising edge of the internal oscillator clock (int_osc).

This counter is used as a simple activity indicator and can be tapped to drive various outputs.

🕒 int_osc — Internal Oscillator
The internal oscillator is instantiated using the Lattice iCE40 primitive SB_HFOSC.

Configured via CLKHF_DIV = "0b10", which sets the oscillator division factor (typically gives 12 MHz from a 48 MHz base).

Always enabled with CLKHFPU = 1'b1 and CLKHFEN = 1'b1.


 Functionality of the RGB LED Driver
🔌 SB_RGBA_DRV — RGB Driver Primitive
This Lattice-specific primitive controls three color channels: Red, Green, Blue.

The driver is always enabled via RGBLEDEN = 1'b1.

Color intensities are defined via:

RGB0PWM, RGB1PWM, RGB2PWM: PWM inputs for red, green, and blue respectively.

In this code:

RGB0PWM = 1'b0 → Red OFF

RGB1PWM = 1'b0 → Green OFF

RGB2PWM = 1'b1 → Blue ON (constant)

Output signals RGB0, RGB1, and RGB2 are mapped to led_red, led_green, and led_blue.

🔌 Current Drive Configuration
RGBx_CURRENT parameters are set to "0b000001" for each channel.

This specifies a minimal current drive for safe low-brightness operation.

est Wire Output
testwire is driven by bit 5 of the frequency counter.

It toggles periodically based on oscillator frequency — useful for debugging or scope probing.

