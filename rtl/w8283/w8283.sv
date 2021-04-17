// w8283 Octal Latch (like Intel 8283)
// Repo: https://github.com/openx86/w8086
// Author: cw1997 [changwei1006@gmail.com] & [https://changwei.me]
// Datetime: 2021-04-17 16:12:32

interface interface_8283 #(
    WIDTH = 8
);
    logic             STB;  // Strobe
    logic             OE_n; // Output enable
    logic [WIDTH-1:0] A;    // Data input
    logic [WIDTH-1:0] B;    // Data output
    modport master (
        input  STB, OE_n, A,
        output B
    );
    modport slave (
        output STB, OE_n, A,
        input  B
    );
endinterface: interface_8283


module w8283 #(
    WIDTH = 8
) (
    interface_8283.master port
);

reg [WIDTH-1:0] register;

always_ff @( posedge port.STB ) begin : latch_address
    register <=port.A;
end

assign port.B = ~port.OE_n ? register : {WIDTH{1'bz}};

endmodule