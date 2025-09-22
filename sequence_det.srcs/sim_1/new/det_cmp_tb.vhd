----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2025 01:51:35 PM
-- Design Name: 
-- Module Name: det_cmp_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity det_cmp_tb is
end det_cmp_tb;

architecture Behavioral of det_cmp_tb is

component det_cmp is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           din : in STD_LOGIC;
           seq_det : out STD_LOGIC);
end component det_cmp;

signal clk, reset, start, din, seq_det : std_logic := '0';
signal clk_period : time := 20 ns;

-- Configuration constants (adjust based on your requirements)
constant min_clk_period : time := 20 ns;  -- 50 MHz max frequency
constant min_reset_pulse : time := 10 ns;
constant setup_time : time := 2 ns;
constant hold_time : time := 1 ns;

begin

clk_p : process
begin
clk <= '1';
wait for clk_period / 2;
clk <= '0';
wait for clk_period / 2;
end process clk_p;

uut : det_cmp
    port map(
        clk => clk,
        reset => reset,
        start => start,
        din => din,
        seq_det => seq_det
        );
    
stim_p : process
begin
 reset <= '1';
 wait for 30ns;
 reset <= '0';
 start <= '1';
 wait for 30ns;
 din <= '1';
 wait for 30ns;
 din <= '0';
 wait for 30ns;
 din <= '1';
 wait for 30ns;
 din <= '1';
 wait for 30ns;
 din <= '0';
 wait for 30ns;
 din <= '1';
 wait for 30ns;
 din <= '0';
 wait for 30ns;
 din <= '1';
 wait for 30ns;
 din <= '0';
 wait for 30ns;
 din <= '0';
 wait for 30ns;
 din <= '1';
 wait for 30ns;
 din <= '0';
 wait for 30ns;
 din <= '0';
 wait for 30ns;
wait;
end process stim_p;

-- ======================================================================================
-- ASSERTIONS
-- ======================================================================================

assertion_block : BLOCK
--signal sequence_buffer : std_logic_vector(3 downto 0) := "0000";
begin
-- Clock period and Stability checks
clk_period_check : process
    variable last_clk_time : time := 0 ns;
    variable period : time;
begin
    loop
    wait until rising_edge(clk);
    if last_clk_time > 0ns then
        period := now - last_clk_time;
        assert period >= min_clk_period
        report "Clock period violation: " & time'image(period) & 
               " < minimum required " & time'image(min_clk_period)
        severity failure;
    end if;
    last_clk_time := now;
    end loop;
end process clk_period_check;

reset_check : process
    variable reset_start_time : time := 0 ns;
begin
    loop
        wait until reset = '1';
        reset_start_time := now;
        wait until reset = '0';
        assert (now - reset_start_time) >= min_reset_pulse
            report "Reset pulse too short: " & time'image(now - reset_start_time)
            severity failure;
    end loop;
end process reset_check;

din_timing_check : process
    variable last_din_change : time := 0 ns;
begin
    loop
        wait on din;  -- wait for din to change
        last_din_change := now;

        -- check setup time before next rising edge
        wait until rising_edge(clk);
        assert (now - last_din_change) >= setup_time
        report "Setup time violation on din"
        severity failure;

        -- check hold time after clock edge
        wait for hold_time;
        assert din'stable(hold_time)
        report "Hold time violation on din"
        severity failure;
    end loop;
end process din_timing_check;
end BLOCK assertion_block;

end Behavioral;
