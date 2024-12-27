<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project is a priority-encoded state machine with 4 states. It has 3 enable signals - one corresponding to each of states 1, 2, and 3. In each clock cycle, the project checks whether each enable signal is on in order of priority(states 1 to 3). If an enable signal is found to be on, a counter is used to keep track of how long the signal remains on. If the signal is on for 100000 consecutive clock cycles, the corresponding state is enabled for 100000000 clock cycles. 

## How to test

To test the project, feed it enable signals from ui_in. ui_in[0] is the enable signal for state 1, ui_in[1] is the enable signal for state 2, and ui_in[2] is the enable signal for state 3. The output state enable signals are sent to the following ports: uo_out[0] is state 1 enabled, uo_out[1] is state 2 enabled, and uo_out[2] is state 3 enabled.

## External hardware

No external hardware is necessary for the core functionality of this project, however, the reason I created it is to create a proximity warning system. To create this, you need 3 LIDAR sensors attached to the input ports and 3 buzzers attached to the output ports
