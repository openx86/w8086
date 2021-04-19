// RAM (Random Access Memory)
// Repo: https://github.com/openx86/w8086
// Author: cw1997 [changwei1006@gmail.com] & [https://changwei.me]
// Datetime: 2021-04-17 20:23:24

interface interface_RAM #(
    WIDTH_DATA = 8,
    DEPTH = 8
) (input clock, reset);
    localparam WIDTH_ADDR = $clog2(DEPTH);

    // logic                  clock;
    // logic                  reset;
    logic                  read_enable;
    logic [WIDTH_ADDR-1:0] read_address;
    logic [WIDTH_DATA-1:0] read_data;
    logic                  write_enable;
    logic [WIDTH_ADDR-1:0] write_address;
    logic [WIDTH_DATA-1:0] write_data;

    modport master (
        input clock, reset, read_enable, read_address, write_enable, write_address, write_data,
        output read_data
    );
    modport slave (
        output read_enable, read_address, write_enable, write_address, write_data,
        input  clock, reset, read_data
    );
endinterface: interface_RAM

module RAM #(
    WIDTH_DATA = 8,
    DEPTH = 8
) (    
    interface_RAM port
);

reg [WIDTH_DATA-1:0] ram [0:DEPTH-1];

always_ff @(posedge port.clock or posedge port.reset) begin
    if (port.reset) begin
        port.read_data <= 0;
    end else begin
        if (port.read_enable) begin
            port.read_data <= ram[port.read_address];
        end else begin
            port.read_data <= {WIDTH_DATA{1'bz}};
        end
    end
end

always_ff @(posedge port.clock or posedge port.reset) begin
    if (port.reset) begin
        // ram <= 0;
    end else begin
        if (port.write_enable) begin
            ram[port.write_address] <= port.write_data;
        end else begin
            ram[port.write_address] <= ram[port.write_address];
        end
    end
end

endmodule
