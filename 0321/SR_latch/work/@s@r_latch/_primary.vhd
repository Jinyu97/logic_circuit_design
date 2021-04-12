library verilog;
use verilog.vl_types.all;
entity sr_latch is
    port(
        q               : out    vl_logic;
        qbar            : out    vl_logic;
        sbar            : in     vl_logic;
        rbar            : in     vl_logic
    );
end sr_latch;
