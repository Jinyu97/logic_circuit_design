library verilog;
use verilog.vl_types.all;
entity cnt_up_down is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        up              : in     vl_logic;
        down            : in     vl_logic;
        count           : out    vl_logic_vector(3 downto 0)
    );
end cnt_up_down;
