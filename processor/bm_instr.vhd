----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:40:07 04/15/2021 
-- Design Name: 
-- Module Name:    bm_instr - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity bm_instr is
    Port ( IN_addr : in  STD_LOGIC_VECTOR (7 downto 0);
           OUT_data : out  STD_LOGIC_VECTOR (31 downto 0);
           CLK : in  STD_LOGIC);
end bm_instr;

architecture Behavioral of bm_instr is

type mem is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
-- instruction "00000110 00000001 00000110 00000000"
--test afc
--signal instr_memory: mem := (1 => "00000110000000010000001000000000", others =>"00000000000000000000000000000000");

--test afc cop
--signal instr_memory: mem := (1 => "00000110000000010000011000000000", 6 =>"00000101000000100000000100000000", others =>"00000000000000000000000000000000");

--test afc cop alea
--signal instr_memory: mem := (1 => "00000110000000010000011000000000", 2 =>"00000101000000100000000100000000", others =>"00000000000000000000000000000000");

--test add
--signal instr_memory: mem := (1 => "00000110000000010000011000000000", 2 => "00000110000000100000000100000000", 10 =>"00000001000000110000000100000010", others =>"00000000000000000000000000000000");

--test add alea
--signal instr_memory: mem := (1 => "00000110000000010000011000000000", 2 => "00000110000000100000000100000000", 3 =>"00000001000000110000000100000010", others =>"00000000000000000000000000000000");

--test sub
--signal instr_memory: mem := (1 => "00000110000000010000011000000000", 2 => "00000110000000100000000100000000", 10 =>"00000011000000110000000100000010", others =>"00000000000000000000000000000000");

--test mul
--signal instr_memory: mem := (1 => "00000110000000010000011000000000", 2 => "00000110000000100000000100000000", 10 =>"00000010000000110000000100000010", others =>"00000000000000000000000000000000");

--test store
--signal instr_memory: mem := (1 => "00000110000000010000011000000000", 10 => "00001000000000000000000100000000", others =>"00000000000000000000000000000000");

--test store alea
--signal instr_memory: mem := (1 => "00000110000000010000011000000000", 2 => "00001000000000000000000100000000", others =>"00000000000000000000000000000000");

--test load
--signal instr_memory: mem := (1 => "00000110000000010000011000000000", 6 => "00001000000000000000000100000000", 15 => "00000111000000110000000000000000", others =>"00000000000000000000000000000000");

-- test demo
--   AFC	0	6	0
--   COP	1	0	0
--   ADD 2	0	1
-- STORE 0	2	0
-- LOAD  3	0	0
signal instr_memory: mem := (1 => "00000110000000000000011000000000", 2 =>"00000101000000010000000000000000", 3 => "00000001000000100000000000000001",
			4 => "00001000000000000000001000000000", 5 => "00000111000000110000000000000000", others =>"00000000000000000000000000000000");

begin

		OUT_data <= instr_memory(to_integer(unsigned(IN_addr)));



end Behavioral;

