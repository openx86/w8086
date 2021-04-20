// FIFO (First In First Out) testbench
// Repo: https://github.com/openx86/w8086
// Author: cw1997 [changwei1006@gmail.com] & [https://changwei.me]
// Datetime: 2021-04-21 02:15:22
`timescale 1ns/1ns

module FIFO_tb #(
    WIDTH_DATA = 8,
    DEPTH = 8
) (
);
localparam clock_period = 1_000_000_000 / 50_000_000;

logic clock = 0, reset = 1;

interface_FIFO #(
) interface_FIFO_inst(clock, reset);

FIFO #(
) FIFO_inst(
    .port ( interface_FIFO_inst )
);

always #(clock_period / 2) clock = ~clock;

initial begin
    interface_FIFO_inst.read_enable = 0;
    interface_FIFO_inst.write_enable = 0;
    interface_FIFO_inst.write_data = 0;
    #(clock_period)
    reset = 0;
    #(clock_period)
    
    interface_FIFO_inst.write_enable = 1;
    interface_FIFO_inst.write_data = 1;
    #(clock_period)
    interface_FIFO_inst.write_data = 2;
    #(clock_period)
    interface_FIFO_inst.write_data = 3;
    #(clock_period)
    interface_FIFO_inst.write_data = 4;
    #(clock_period)
    interface_FIFO_inst.write_enable = 0;
    #(clock_period)

    interface_FIFO_inst.write_enable = 1;
    interface_FIFO_inst.write_data = 5;
    #(clock_period)
    interface_FIFO_inst.write_data = 6;
    #(clock_period)
    interface_FIFO_inst.write_data = 7;
    #(clock_period)
    interface_FIFO_inst.write_data = 0;
    #(clock_period)
    interface_FIFO_inst.write_enable = 0;
    #(clock_period)

    interface_FIFO_inst.read_enable = 1;
    #(clock_period)
    interface_FIFO_inst.read_enable = 0;
    #(clock_period)
    interface_FIFO_inst.read_enable = 1;
    #(clock_period)
    interface_FIFO_inst.read_enable = 0;
    #(clock_period)

    interface_FIFO_inst.write_enable = 1;
    interface_FIFO_inst.write_data = 6;
    #(clock_period)
    interface_FIFO_inst.write_data = 7;
    #(clock_period)
    interface_FIFO_inst.write_enable = 0;
    #(clock_period)

    interface_FIFO_inst.read_enable = 1;
    #(clock_period)
    interface_FIFO_inst.read_enable = 0;
    #(clock_period)
    
    $stop();
end
    
endmodule
