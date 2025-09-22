----------------------------------------------------------------------------------
-- Company:        [Your Company Name]
-- Engineer:       Haizon
-- 
-- Create Date:    09/22/2025
-- Design Name:    Sequence Detector
-- Module Name:    det_cmp - Behavioral
-- Description:    Mealy FSM to detect sequence "1011" with overlap support
-- 
-- Revision:       1.0
-- Additional Comments: Uses asynchronous start and reset
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity det_cmp is
    Port ( clk : in STD_LOGIC;          -- SYSTEM CLOCK
           reset : in STD_LOGIC;        -- ASYNCHRONOUS RESET 
           start : in STD_LOGIC;        -- ASYNCHRONOUS START
           din : in STD_LOGIC;          -- SERIAL INPUT
           seq_det : out STD_LOGIC);    -- SEQUENCE DETECTION BIT
end det_cmp;

architecture Behavioral of det_cmp is

type states is (st_0, st_1, st_2, st_3);
signal current_state, next_state : states := st_0;

begin
stim_p : process(clk, reset)
begin
if reset = '1' then
    current_state <= st_0;
elsif rising_edge(clk) then 
    if start = '1' then
        current_state <= next_state;  
    end if;  
end if;
end process stim_p;

logic_p : process(current_state, din, start)
begin
next_state <= current_state;                        -- stay in current state by default
seq_det <= '0';                                     -- detection is 0 by default
if start = '1' then
    case current_state is
        when st_0 =>                                -- already 0
        if din = '1' then
            next_state <= st_1;
            seq_det <= '0';
        else
            next_state <= st_0;
        end if;
        when st_1 =>                                -- already 1
        if din = '0' then
            next_state <= st_2;
            seq_det <= '0';
        else
            next_state <= st_1;
        end if;
        when st_2 =>                                -- already 0
        if din = '1' then
            next_state <= st_3;
            seq_det <= '0';
        else
            next_state <= st_0;
        end if;
        when st_3 =>                                -- already 1
        if din = '1' then                           -- check if next input is 1
            next_state <= st_1;
            seq_det <= '1';
        else 
            next_state <= st_0;
        end if;
    end case;
end if;
end process logic_p;
end Behavioral;
