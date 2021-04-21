// memory controller testbench
// Repo: https://github.com/openx86/w8086
// Author: cw1997 [changwei1006@gmail.com] & [https://changwei.me]
// Datetime: 2021-04-21 21:54:43

module decode #(
    // parameters
) (
    // ports
);

logic         instruction_d;
logic         instruction_w;
logic         instruction_v;
logic [ 1: 0] instruction_mod;
logic [ 2: 0] instruction_r_m;
logic [ 2: 0] instruction_reg;
logic         register_segment;
logic [15: 0] data;
logic [ 7: 0] data_h = data[15: 8];
logic [ 7: 0] data_l = data[ 7: 0];
logic [15: 0] addr;
logic [ 7: 0] addr_h = data[15: 8];
logic [ 7: 0] addr_l = data[ 7: 0];
logic [ 7: 0] port;

logic [7:0] cache [0:3];

always_ff @( posedge clock ) begin : update_cache
    
end

wire [63:0] opcode;
    
always_comb begin : decode
    unique case (cache[0])
        // MOV
        // Register/Memory to/from Register
        8'b1000_10xx : begin
            instruction_d   <= cache[0][1];
            instruction_w   <= cache[0][0];
            instruction_mod <= cache[1][7:6];
            instruction_reg <= cache[1][5:3];
            instruction_r_m <= cache[1][2:0];
        end
        // Immediate to Register/Memory
        8'b1100_011x : begin
            instruction_w   <= cache[0][0];
            case (cache[1])
                8'bxx00_0xxx : begin
                    instruction_mod <= cache[1][7:6];
                    instruction_r_m <= cache[1][2:0];
                    data <= cache[0][0] ? {cache[2], cache[3]} : cache[2];
                end
                default: ;
            endcase
        end
        // Immediate to Register
        8'b1011_xxxx : begin
            instruction_reg <= cache[0][2:0];
            data <= cache[0][3] ? {cache[1], cache[2]} : cache[1];
        end
        // Memory to Accumulator
        8'b1010_000x : begin
            instruction_w   <= cache[0][0];
            addr <= {cache[2], cache[1]};
        end
        // Accumulator to Memory
        8'b1010_001x : begin
            instruction_w   <= cache[0][0];
            addr <= {cache[2], cache[1]};
        end
        // Register/Memory to Segment Register
        8'b1000_1110 : begin
            case (cache[1])
                8'bxx0x_xxxx : begin
                    register_segment <= register_segment;
                    instruction_mod <= cache[1][7:6];
                    instruction_reg <= cache[1][4:3];
                    instruction_r_m <= cache[1][2:0];
                end
                default: ;
            endcase
        end
        // Segment Register to Register/Memory
        8'b1000_1100 : begin
            case (cache[1])
                8'bxx0x_xxxx : begin
                    register_segment <= register_segment;
                    instruction_mod <= cache[1][7:6];
                    instruction_reg <= cache[1][4:3];
                    instruction_r_m <= cache[1][2:0];
                end
                default: ;
            endcase
        end

        // PUSH
        // Register/Memory
        8'b1111_1111 : begin
            case (cache[1])
                8'bxx11_0xxx : begin
                    instruction_mod <= cache[1][7:6];
                    instruction_r_m <= cache[1][2:0];
                end
                default: ;
            endcase
        end
        // Register
        8'b0101_0xxx : begin
            instruction_reg <= cache[0][2:0];
        end
        // Segment Register
        8'b000x_x110 : begin
            register_segment <= register_segment;
            instruction_reg <= cache[0][4:3];
        end

        // POP
        // Register/Memory
        8'b1000_1111 : begin
            case (cache[1])
                8'bxx00_0xxx : begin
                    instruction_mod <= cache[1][7:6];
                    instruction_r_m <= cache[1][2:0];
                end
                default: ;
            endcase
        end
        // Register
        8'b0101_1xxx : begin
            instruction_reg <= cache[0][2:0];
        end
        // Segment Register
        8'b000x_x111 : begin
            register_segment <= register_segment;
            instruction_reg <= cache[0][4:3];
        end

        // XCHG = Exchange
        // Register/Memory with Register
        8'b1000_011x : begin
            instruction_w   <= cache[0][0];
            instruction_mod <= cache[1][7:6];
            instruction_reg <= cache[1][5:3];
            instruction_r_m <= cache[1][2:0];
        end
        // Register with Accumulator
        8'b1001_0xxx : begin
            instruction_reg <= cache[0][2:0];
        end

        // IN = Input from
        // Fixed Port
        8'b110_010x : begin
            instruction_w   <= cache[0][0];
            port <= cache[1];
        end
        // Variable Port
        8'b110_010x : begin
            instruction_w   <= cache[0][0];
        end

        // OUT = Output from
        // Fixed Port
        8'b1110_011x : begin
            instruction_w   <= cache[0][0];
            port <= cache[1];
        end
        // Variable Port
        8'b1110_111x : begin
            instruction_w   <= cache[0][0];
        end

        // XLAT = Translate Byte to AL
        8'b1101_0111 : begin
            // TODO: set operation
        end

        // LEA = Load EA to Register
        8'b1000_1101 : begin
            // TODO: set operation
            instruction_mod <= cache[1][7:6];
            instruction_reg <= cache[1][5:3];
            instruction_r_m <= cache[1][2:0];
        end

        // LDS = Load Pointer to DS
        8'b1100_0101 : begin
            // TODO: set operation
            instruction_mod <= cache[1][7:6];
            instruction_reg <= cache[1][5:3];
            instruction_r_m <= cache[1][2:0];
        end

        //LES = Load Pointer to ES
        8'b1100_0100 : begin
            // TODO: set operation
            instruction_mod <= cache[1][7:6];
            instruction_reg <= cache[1][5:3];
            instruction_r_m <= cache[1][2:0];
        end

        // LAHF = Load AH with Flags 
        8'b1001_1111 : begin
            // TODO: set operation
        end

        // SAHF = Store AH into Flags 
        8'b1001_1110 : begin
            // TODO: set operation
        end

        // PUSHF = Push Flags 
        8'b1001_1100 : begin
            // TODO: set operation
        end

        // POPF = Pop Flags 
        8'b1001_1101 : begin
            // TODO: set operation
        end



        default: ;
    endcase
end
    
endmodule