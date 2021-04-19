// RAM (Random Access Memory)
// Repo: https://github.com/openx86/w8086
// Author: cw1997 [changwei1006@gmail.com] & [https://changwei.me]
// Datetime: 2021-04-17 20:23:24
`timescale 1ns/1ns

module memory_controller_tb (
);
localparam clock_period = 1_000_000_000 / 50_000_000;

logic clock = 0, reset = 1;

interface_memory_controller interface_memory_controller_inst();

memory_controller memory_controller_inst (
    .port ( interface_memory_controller_inst.master )
);

assign interface_memory_controller_inst.clock = clock;
assign interface_memory_controller_inst.reset = reset;

initial begin
    #(clock_period)
    reset = 0;

    interface_memory_controller_inst.read_enable = 1;
    interface_memory_controller_inst.read_address = 20'h0_0001;
    // read_data = 16'h0001;
    #(clock_period)
    interface_memory_controller_inst.read_enable = 0;
    #(clock_period)
    interface_memory_controller_inst.read_enable = 1;
    interface_memory_controller_inst.read_address = 20'h0_0010;
    #(clock_period)
    interface_memory_controller_inst.read_enable = 0;
    
    #(clock_period)
    
    interface_memory_controller_inst.write_enable = 1;
    interface_memory_controller_inst.write_address = 20'h0_0001;
    interface_memory_controller_inst.write_data = 20'h0_0001;
    // read_data = 16'h0001;
    #(clock_period)
    interface_memory_controller_inst.write_enable = 0;
    #(clock_period)
    interface_memory_controller_inst.write_enable = 1;
    interface_memory_controller_inst.write_address = 20'h0_0010;
    interface_memory_controller_inst.write_data = 20'h0_0010;
    #(clock_period)
    interface_memory_controller_inst.write_enable = 0;
    
    #(clock_period)

    interface_memory_controller_inst.read_enable = 1;
    interface_memory_controller_inst.read_address = 20'h0_0001;
    // read_data = 16'h0001;
    #(clock_period)
    interface_memory_controller_inst.read_enable = 0;
    #(clock_period)
    interface_memory_controller_inst.read_enable = 1;
    interface_memory_controller_inst.read_address = 20'h0_0010;
    #(clock_period)
    interface_memory_controller_inst.read_enable = 0;
    
    #(clock_period)

    $stop();
end

always #(clock_period / 2) clock = ~clock; 

endmodule