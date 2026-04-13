//  A testbench for 8BitProcessor_tb
`timescale 1us/1ns

module 8BitProcessor_tb;
    reg clk;
    reg [7:0] InstrMem_input;
    reg [1:0] InstrMem_ctrl;
    wire [7:0] IR_output;
    wire Inst_Fetch;
    wire Inst_decode;
    wire Inst_exec;
    wire Write_Back;
    wire [2:0] Program_Counter;
    wire [1:0] IR_ctrl;
    wire [7:0] RegFile_ctrl;
    wire [7:0] ALU_output;

  \8BitProcessor  \8BitProcessor 0 (
    .clk(clk),
    .InstrMem_input(InstrMem_input),
    .InstrMem_ctrl(InstrMem_ctrl),
    .IR_output(IR_output),
    .Inst_Fetch(Inst_Fetch),
    .Inst_decode(Inst_decode),
    .Inst_exec(Inst_exec),
    .Write_Back(Write_Back),
    .Program_Counter(Program_Counter),
    .IR_ctrl(IR_ctrl),
    .RegFile_ctrl(RegFile_ctrl),
    .ALU_output(ALU_output)
  );

    reg [32:0] patterns[0:209];
    integer i;

    initial begin
      patterns[0] = 33'b0_10101000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[1] = 33'b1_10101000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[2] = 33'b0_10101000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[3] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[4] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[5] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[6] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[7] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[8] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[9] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[10] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[11] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[12] = 33'b0_10101000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[13] = 33'b1_10101000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[14] = 33'b0_10101000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[15] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[16] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[17] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[18] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[19] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[20] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[21] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[22] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[23] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[24] = 33'b0_10101000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[25] = 33'b1_10101000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[26] = 33'b0_10101000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[27] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[28] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[29] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[30] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[31] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[32] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[33] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[34] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[35] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[36] = 33'b0_10101000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[37] = 33'b1_10101000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[38] = 33'b0_10101000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[39] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[40] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[41] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[42] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[43] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[44] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[45] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[46] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[47] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[48] = 33'b0_10110000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[49] = 33'b1_10110000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[50] = 33'b0_10110000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[51] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[52] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[53] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[54] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[55] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[56] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[57] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[58] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[59] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[60] = 33'b0_10110000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[61] = 33'b1_10110000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[62] = 33'b0_10110000_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[63] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[64] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[65] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[66] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[67] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[68] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[69] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[70] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[71] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[72] = 33'b0_01101100_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[73] = 33'b1_01101100_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[74] = 33'b0_01101100_01_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[75] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[76] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[77] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[78] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[79] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[80] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[81] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[82] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[83] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[84] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[85] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[86] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[87] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[88] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[89] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[90] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[91] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[92] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[93] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[94] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[95] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[96] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[97] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[98] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[99] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[100] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[101] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[102] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[103] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[104] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[105] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[106] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[107] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[108] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[109] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[110] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[111] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[112] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[113] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[114] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[115] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[116] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[117] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[118] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[119] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[120] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[121] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[122] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[123] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[124] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[125] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[126] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[127] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[128] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[129] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[130] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[131] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[132] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[133] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[134] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[135] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[136] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[137] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[138] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[139] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[140] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[141] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[142] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[143] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[144] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[145] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[146] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[147] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[148] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[149] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[150] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[151] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[152] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[153] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[154] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[155] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[156] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[157] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[158] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[159] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[160] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[161] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[162] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[163] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[164] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[165] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[166] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[167] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[168] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[169] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[170] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[171] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[172] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[173] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[174] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[175] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[176] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[177] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[178] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[179] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[180] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[181] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[182] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[183] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[184] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[185] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[186] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[187] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[188] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[189] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[190] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[191] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[192] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[193] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[194] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[195] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[196] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[197] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[198] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[199] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[200] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[201] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[202] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[203] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[204] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[205] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[206] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[207] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[208] = 33'b1_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;
      patterns[209] = 33'b0_00000000_00_xxx_xxxxxxxx_xx_x_xxxxxxxx;

      for (i = 0; i < 210; i = i + 1)
      begin
        clk = patterns[i][32];
        InstrMem_input = patterns[i][31:24];
        InstrMem_ctrl = patterns[i][23:22];
        #10;
        if (patterns[i][21:19] !== 3'hx)
        begin
          if (Program_Counter !== patterns[i][21:19])
          begin
            $display("%d:Program_Counter: (assertion error). Expected %h, found %h", i, patterns[i][21:19], Program_Counter);
            $finish;
          end
        end
        if (patterns[i][18:11] !== 8'hx)
        begin
          if (IR_output !== patterns[i][18:11])
          begin
            $display("%d:IR_output: (assertion error). Expected %h, found %h", i, patterns[i][18:11], IR_output);
            $finish;
          end
        end
        if (patterns[i][10:9] !== 2'hx)
        begin
          if (IR_ctrl !== patterns[i][10:9])
          begin
            $display("%d:IR_ctrl: (assertion error). Expected %h, found %h", i, patterns[i][10:9], IR_ctrl);
            $finish;
          end
        end
        if (patterns[i][8] !== 1'hx)
        begin
          if (Write_Back !== patterns[i][8])
          begin
            $display("%d:Write_Back: (assertion error). Expected %h, found %h", i, patterns[i][8], Write_Back);
            $finish;
          end
        end
        if (patterns[i][7:0] !== 8'hx)
        begin
          if (ALU_output !== patterns[i][7:0])
          begin
            $display("%d:ALU_output: (assertion error). Expected %h, found %h", i, patterns[i][7:0], ALU_output);
            $finish;
          end
        end
      end

      $display("All tests passed.");
    end
    endmodule
