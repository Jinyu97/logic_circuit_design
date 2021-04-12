library verilog;
use verilog.vl_types.all;
entity t_ff is
    port(
        q               : out    vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end t_ff;
