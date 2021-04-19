// memory controller
// Repo: https://github.com/openx86/w8086
// Author: cw1997 [changwei1006@gmail.com] & [https://changwei.me]
// Datetime: 2021-04-17 20:23:24

interface interface_memory_controller #(
    WIDTH_DATA = 16,
    WIDTH_ADDR = 20
) (input clock, reset);
    // logic                  clock;
    // logic                  reset;
    logic                  read_enable;
    logic [WIDTH_ADDR-1:0] read_address;
    logic [WIDTH_DATA-1:0] read_data;
    logic                  write_enable;
    logic [WIDTH_ADDR-1:0] write_address;
    logic [WIDTH_DATA-1:0] write_data;
    // logic                  ready;
    
    modport master (
        input  clock, reset, read_enable, read_address, write_enable, write_address, write_data,
        output read_data
    );
    modport slave (
        output read_enable, read_address, write_enable, write_address, write_data,
        input  clock, reset, read_data
    );
endinterface: interface_memory_controller

module memory_controller (
    // interface_w8086 port_w8086_base,
    // interface_w8086.slave_minimum_mode port_w8086_minimum_mode,
    interface_memory_controller port
);

localparam 
RAM_WIDTH = 16,
// RAM_DEPTH = 20'hA_0000;
RAM_DEPTH = 20'h0_000A;

interface_RAM #(
    .WIDTH_DATA ( RAM_WIDTH ),
    .DEPTH ( RAM_DEPTH )
) interface_RAM_inst(port.clock, port.reset);

RAM #(
    .WIDTH_DATA ( RAM_WIDTH ),
    .DEPTH ( RAM_DEPTH )
) RAM_inst (
    .port ( interface_RAM_inst.master )
);


localparam 
BIOS_WIDTH = 8,
// BIOS_DEPTH = 20'h1_0000;
BIOS_DEPTH = 20'h0_0010;

interface_RAM #(
    .WIDTH_DATA ( BIOS_WIDTH ),
    .DEPTH ( BIOS_DEPTH )
) interface_BIOS_inst(port.clock, port.reset);

RAM #(
    .WIDTH_DATA ( BIOS_WIDTH ),
    .DEPTH ( BIOS_DEPTH )
) BIOS_inst (
    .port ( interface_BIOS_inst.master )
);

// assign interface_RAM_inst.clock = port.clock
// assign interface_RAM_inst.reset = port.reset

// assign interface_BIOS_inst.clock = port.clock
// assign interface_BIOS_inst.reset = port.reset

localparam 
RAM_OFFSET = 20'h0_0000,
RAM_END    = 20'h9_FFFF,
VIDEO_BUFFER_OFFSET = 20'hA_0000,
VIDEO_BUFFER_END    = 20'hB_FFFF,
VGA_BIOS_OFFSET = 20'hC_0000,
VGA_BIOS_END    = 20'hC_7FFF,
PERIPHERAL_OFFSET = 20'hC_8000,
PERIPHERAL_END    = 20'hE_FFFF,
SYSTEM_BIOS_OFFSET = 20'hF_0000,
SYSTEM_BIOS_END    = 20'hF_FFFF
;

// TODO: write_address by device type
// logic read_address = ;
always_latch begin : select_address
    if (port.read_enable) begin
        if (port.read_address >= RAM_OFFSET && port.read_address <= RAM_END) begin
            interface_RAM_inst.read_enable <= port.read_enable;
            interface_BIOS_inst.read_enable <= ~port.read_enable;

            interface_RAM_inst.read_address <= port.read_address - RAM_OFFSET;
            port.read_data <= interface_RAM_inst.read_data;
        end else if (port.read_address >= SYSTEM_BIOS_OFFSET && port.read_address <= SYSTEM_BIOS_END) begin
            interface_BIOS_inst.read_enable <= port.read_enable;
            interface_RAM_inst.read_enable <= ~port.read_enable;

            interface_BIOS_inst.read_address <= port.read_address - SYSTEM_BIOS_OFFSET;
            port.read_data <= interface_BIOS_inst.read_data;
        end
    end else begin
        interface_RAM_inst.read_enable <= 0;
        interface_BIOS_inst.read_enable <= 0;

        interface_RAM_inst.read_address <= 0;
        interface_BIOS_inst.read_address <= 0;
    end

    if (port.write_enable) begin
        if (port.write_address >= RAM_OFFSET && port.write_address <= RAM_END) begin
            interface_RAM_inst.write_enable <= port.write_enable;
            interface_BIOS_inst.write_enable <= ~port.write_enable;

            interface_RAM_inst.write_address <= port.write_address - RAM_OFFSET;
            interface_RAM_inst.write_data <= port.write_data;
        end else if (port.write_address >= SYSTEM_BIOS_OFFSET && port.write_address <= SYSTEM_BIOS_END) begin
            interface_BIOS_inst.write_enable <= port.write_enable;
            interface_RAM_inst.write_enable <= ~port.write_enable;

            interface_BIOS_inst.write_address <= port.write_address - SYSTEM_BIOS_OFFSET;
            interface_BIOS_inst.write_data <= port.write_data;
        end
    end else begin
        interface_RAM_inst.write_enable <= 0;
        interface_BIOS_inst.write_enable <= 0;

        interface_RAM_inst.write_address <= 0;
        interface_BIOS_inst.write_address <= 0;
    end
end

// assign port.read_enable = 
// assign port.read_address = 
// assign port.read_data = 
// assign port.write_enable = 
// assign port.write_address = 
// assign port.write_data = 
// wire handshake_request = port.read_address | port.write_address;
// wire handshake_ready = handshake_request;
// assign port.ready = handshake_ready;
// assign port_w8086.READY = handshake_ready;

endmodule
