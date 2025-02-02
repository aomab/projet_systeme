--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:35:26 04/15/2021
-- Design Name:   
-- Module Name:   
-- Project Name:  ALU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: br
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY br_test IS
END br_test;
 
ARCHITECTURE behavior OF br_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT br
    PORT(
         A_addr : IN  std_logic_vector(3 downto 0);
         B_addr : IN  std_logic_vector(3 downto 0);
         W_addr : IN  std_logic_vector(3 downto 0);
         W : IN  std_logic;
         Data : IN  std_logic_vector(7 downto 0);
         RST : IN  std_logic;
         CLK : IN  std_logic;
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A_addr : std_logic_vector(3 downto 0) := (others => '0');
   signal B_addr : std_logic_vector(3 downto 0) := (others => '0');
   signal W_addr : std_logic_vector(3 downto 0) := (others => '0');
   signal W : std_logic := '0';
   signal Data : std_logic_vector(7 downto 0) := (others => '0');
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: br PORT MAP (
          A_addr => A_addr,
          B_addr => B_addr,
          W_addr => W_addr,
          W => W,
          Data => Data,
          RST => RST,
          CLK => CLK,
          QA => QA,
          QB => QB
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      RST <= '1';
		--Write only
		wait for 30 ns ;
		DATA <= "10000000";
		W_addr <= "0000";
		W <= '1';
		wait for 30 ns;
		W_addr <= "0001";
		DATA <= "10000100";
		wait for 30 ns ;
		-- Read only
		W <= '0';
		A_addr <= "0000" ;
		B_addr <= "0001" ;
		wait for 30 ns;
		--Bypass for B and writting and reading at different addr for A
		DATA <= "10000001";
		wait for 30 ns;
		W <= '1';
		wait for 30 ns;
		W <= '0';
		RST <= '0';
      wait;
   end process;

END;
