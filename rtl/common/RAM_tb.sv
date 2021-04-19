// RAM testbench
// Repo: https://github.com/openx86/w8086
// Author: cw1997 [changwei1006@gmail.com] & [https://changwei.me]
// Datetime: 2021-04-19 21:24:03


module RAM_tb #(
    WIDTH_DATA = 8,
    DEPTH = 8
) (    
    // interface_RAM port
);
localparam clock_period = 1_000_000_000 / 50_000_000;

logic clock = 0, reset = 1;

interface_RAM interface_RAM_inst(clock, reset);

RAM #(
    .WIDTH_DATA ( WIDTH_DATA ),
    .DEPTH ( DEPTH )
) RAM_inst ( 
    .port ( interface_RAM_inst ) 
);

assign interface_RAM_inst.clock = clock;
assign interface_RAM_inst.reset = reset;

initial begin
    #(clock_period)
    reset = 0;

    interface_RAM_inst.read_enable = 1;
    interface_RAM_inst.read_address = 20'h0_0001;
    // read_data = 16'h0001;
    #(clock_period)
    interface_RAM_inst.read_enable = 0;
    #(clock_period)
    interface_RAM_inst.read_enable = 1;
    interface_RAM_inst.read_address = 20'h0_0010;
    #(clock_period)
    interface_RAM_inst.read_enable = 0;
    
    #(clock_period)
    
    interface_RAM_inst.write_enable = 1;
    interface_RAM_inst.write_address = 20'h0_0001;
    interface_RAM_inst.write_data = 20'h0_0001;
    // read_data = 16'h0001;
    #(clock_period)
    interface_RAM_inst.write_enable = 0;
    #(clock_period)
    interface_RAM_inst.write_enable = 1;
    interface_RAM_inst.write_address = 20'h0_0010;
    interface_RAM_inst.write_data = 20'h0_0010;
    #(clock_period)
    interface_RAM_inst.write_enable = 0;
    
    #(clock_period)

    interface_RAM_inst.read_enable = 1;
    interface_RAM_inst.read_address = 20'h0_0001;
    // read_data = 16'h0001;
    #(clock_period)
    interface_RAM_inst.read_enable = 0;
    #(clock_period)
    interface_RAM_inst.read_enable = 1;
    interface_RAM_inst.read_address = 20'h0_0010;
    #(clock_period)
    interface_RAM_inst.read_enable = 0;
    
    #(clock_period)

    $stop();
end

always #(clock_period / 2) clock = ~clock; 


endmodule
