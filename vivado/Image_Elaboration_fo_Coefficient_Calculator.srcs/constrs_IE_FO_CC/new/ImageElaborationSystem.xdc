create_clock -period 8.000 -name IE_FO_CC_clk -waveform {0.000 4.000} -add [get_ports -filter { NAME =~  "*clk*" && DIRECTION == "IN" }]
