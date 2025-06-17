module seq_detector_0011 (clk,
    data_in,
    detected,
    reset);
 input clk;
 input data_in;
 output detected;
 input reset;

 wire _00_;
 wire _01_;
 wire _02_;
 wire _03_;
 wire _04_;
 wire _05_;
 wire _06_;
 wire \current_state[0] ;
 wire \current_state[1] ;
 wire \current_state[2] ;
 wire net3;
 wire \next_state[0] ;
 wire \next_state[1] ;
 wire \next_state[2] ;
 wire net1;
 wire net2;
 wire clknet_0_clk;
 wire clknet_1_0__leaf_clk;
 wire clknet_1_1__leaf_clk;
 wire net4;
 wire net5;

 sky130_fd_sc_hd__or3b_1 _07_ (.A(net2),
    .B(\current_state[1] ),
    .C_N(\current_state[0] ),
    .X(_02_));
 sky130_fd_sc_hd__nand2b_1 _08_ (.A_N(\current_state[0] ),
    .B(\current_state[1] ),
    .Y(_03_));
 sky130_fd_sc_hd__a21oi_2 _09_ (.A1(_02_),
    .A2(_03_),
    .B1(\current_state[2] ),
    .Y(\next_state[1] ));
 sky130_fd_sc_hd__inv_1 _10_ (.A(\current_state[2] ),
    .Y(_04_));
 sky130_fd_sc_hd__xor2_1 _11_ (.A(\current_state[0] ),
    .B(net2),
    .X(_05_));
 sky130_fd_sc_hd__nor3_1 _12_ (.A(net4),
    .B(\current_state[0] ),
    .C(net2),
    .Y(_06_));
 sky130_fd_sc_hd__a31o_1 _13_ (.A1(net4),
    .A2(_04_),
    .A3(_05_),
    .B1(_06_),
    .X(\next_state[0] ));
 sky130_fd_sc_hd__and4_1 _14_ (.A(net4),
    .B(\current_state[0] ),
    .C(_04_),
    .D(net2),
    .X(\next_state[2] ));
 sky130_fd_sc_hd__and4_1 _15_ (.A(net4),
    .B(\current_state[0] ),
    .C(_04_),
    .D(net2),
    .X(_00_));
 sky130_fd_sc_hd__inv_2 _16_ (.A(net1),
    .Y(_01_));
 sky130_fd_sc_hd__dfrtp_4 \current_state[0]$_DFF_PP0_  (.D(\next_state[0] ),
    .Q(\current_state[0] ),
    .RESET_B(_01_),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfrtp_4 \current_state[1]$_DFF_PP0_  (.D(\next_state[1] ),
    .Q(\current_state[1] ),
    .RESET_B(_01_),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \current_state[2]$_DFF_PP0_  (.D(\next_state[2] ),
    .Q(\current_state[2] ),
    .RESET_B(_01_),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \detected$_DFF_PP0_  (.D(_00_),
    .Q(net3),
    .RESET_B(_01_),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__buf_1 hold1 (.A(net5),
    .X(net1));
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_12 ();
 sky130_fd_sc_hd__buf_1 input1 (.A(data_in),
    .X(net2));
 sky130_fd_sc_hd__buf_1 output2 (.A(net3),
    .X(detected));
 sky130_fd_sc_hd__clkbuf_4 clkbuf_0_clk (.A(clk),
    .X(clknet_0_clk));
 sky130_fd_sc_hd__clkbuf_4 clkbuf_1_0__f_clk (.A(clknet_0_clk),
    .X(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__clkbuf_4 clkbuf_1_1__f_clk (.A(clknet_0_clk),
    .X(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__buf_2 rebuffer1 (.A(\current_state[1] ),
    .X(net4));
 sky130_fd_sc_hd__dlygate4sd3_1 hold2 (.A(reset),
    .X(net5));
 sky130_fd_sc_hd__fill_8 FILLER_0_0 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_8 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_16 ();
 sky130_fd_sc_hd__fill_4 FILLER_0_24 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_28 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_31 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_39 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_47 ();
 sky130_fd_sc_hd__fill_4 FILLER_0_55 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_59 ();
 sky130_fd_sc_hd__fill_8 FILLER_0_61 ();
 sky130_fd_sc_hd__fill_4 FILLER_0_69 ();
 sky130_fd_sc_hd__fill_8 FILLER_1_0 ();
 sky130_fd_sc_hd__fill_8 FILLER_1_15 ();
 sky130_fd_sc_hd__fill_4 FILLER_1_23 ();
 sky130_fd_sc_hd__fill_8 FILLER_1_39 ();
 sky130_fd_sc_hd__fill_8 FILLER_1_47 ();
 sky130_fd_sc_hd__fill_4 FILLER_1_55 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_59 ();
 sky130_fd_sc_hd__fill_8 FILLER_1_61 ();
 sky130_fd_sc_hd__fill_4 FILLER_1_69 ();
 sky130_fd_sc_hd__fill_4 FILLER_2_0 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_4 ();
 sky130_fd_sc_hd__fill_4 FILLER_2_36 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_40 ();
 sky130_fd_sc_hd__fill_8 FILLER_2_62 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_70 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_72 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_6 ();
 sky130_fd_sc_hd__fill_8 FILLER_3_61 ();
 sky130_fd_sc_hd__fill_4 FILLER_3_69 ();
 sky130_fd_sc_hd__fill_8 FILLER_4_41 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_49 ();
 sky130_fd_sc_hd__fill_8 FILLER_4_56 ();
 sky130_fd_sc_hd__fill_8 FILLER_4_64 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_72 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_3 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_11 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_19 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_30 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_38 ();
 sky130_fd_sc_hd__fill_8 FILLER_5_46 ();
 sky130_fd_sc_hd__fill_4 FILLER_5_54 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_58 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_61 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_63 ();
 sky130_fd_sc_hd__fill_4 FILLER_5_67 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_71 ();
 sky130_fd_sc_hd__fill_8 FILLER_6_0 ();
 sky130_fd_sc_hd__fill_8 FILLER_6_8 ();
 sky130_fd_sc_hd__fill_8 FILLER_6_16 ();
 sky130_fd_sc_hd__fill_4 FILLER_6_24 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_28 ();
 sky130_fd_sc_hd__fill_8 FILLER_6_31 ();
 sky130_fd_sc_hd__fill_8 FILLER_6_39 ();
 sky130_fd_sc_hd__fill_8 FILLER_6_47 ();
 sky130_fd_sc_hd__fill_8 FILLER_6_55 ();
 sky130_fd_sc_hd__fill_8 FILLER_6_63 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_71 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_0 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_8 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_16 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_24 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_32 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_40 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_48 ();
 sky130_fd_sc_hd__fill_4 FILLER_7_56 ();
 sky130_fd_sc_hd__fill_8 FILLER_7_61 ();
 sky130_fd_sc_hd__fill_4 FILLER_7_69 ();
 sky130_fd_sc_hd__fill_8 FILLER_8_0 ();
 sky130_fd_sc_hd__fill_8 FILLER_8_8 ();
 sky130_fd_sc_hd__fill_8 FILLER_8_16 ();
 sky130_fd_sc_hd__fill_4 FILLER_8_24 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_28 ();
 sky130_fd_sc_hd__fill_8 FILLER_8_31 ();
 sky130_fd_sc_hd__fill_8 FILLER_8_39 ();
 sky130_fd_sc_hd__fill_8 FILLER_8_47 ();
 sky130_fd_sc_hd__fill_8 FILLER_8_55 ();
 sky130_fd_sc_hd__fill_8 FILLER_8_63 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_71 ();
 sky130_fd_sc_hd__fill_8 FILLER_9_0 ();
 sky130_fd_sc_hd__fill_8 FILLER_9_8 ();
 sky130_fd_sc_hd__fill_8 FILLER_9_16 ();
 sky130_fd_sc_hd__fill_8 FILLER_9_24 ();
 sky130_fd_sc_hd__fill_8 FILLER_9_32 ();
 sky130_fd_sc_hd__fill_8 FILLER_9_40 ();
 sky130_fd_sc_hd__fill_8 FILLER_9_48 ();
 sky130_fd_sc_hd__fill_4 FILLER_9_56 ();
 sky130_fd_sc_hd__fill_8 FILLER_9_61 ();
 sky130_fd_sc_hd__fill_4 FILLER_9_69 ();
 sky130_fd_sc_hd__fill_8 FILLER_10_0 ();
 sky130_fd_sc_hd__fill_8 FILLER_10_8 ();
 sky130_fd_sc_hd__fill_8 FILLER_10_16 ();
 sky130_fd_sc_hd__fill_4 FILLER_10_24 ();
 sky130_fd_sc_hd__fill_2 FILLER_10_28 ();
 sky130_fd_sc_hd__fill_8 FILLER_10_31 ();
 sky130_fd_sc_hd__fill_8 FILLER_10_39 ();
 sky130_fd_sc_hd__fill_8 FILLER_10_47 ();
 sky130_fd_sc_hd__fill_4 FILLER_10_55 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_59 ();
 sky130_fd_sc_hd__fill_8 FILLER_10_61 ();
 sky130_fd_sc_hd__fill_4 FILLER_10_69 ();
endmodule
