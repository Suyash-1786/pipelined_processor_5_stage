create_clock -name clk1 -period 10.000 -waveform {0.000 5.000} [get_ports {clk1}]

create_clock -name clk2 -period 10.000 -waveform {5.000 10.000} [get_ports {clk2}]