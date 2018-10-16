----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2018/10/15 10:41:50
-- Design Name: 
-- Module Name: StateMachine - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity StateMachine is
	port(
		clk, rst:in std_logic;
		output_state:out std_logic_vector(3 downto 0)
	);
--  Port ( );
end StateMachine;

architecture Behavioral of StateMachine is
	type state is (input_A, input_B, input_OP, output_flag);
	signal next_state, rst_state, current_state: state;
	signal rst_n: std_logic;

begin
	rst_n <= not rst;
	rst_state <= input_A;
	
	current_state_transform: process(clk, rst_n)
	begin
		if(rst_n = '0') then
			current_state <= rst_state;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process current_state_transform;

	next_state_transform: process(current_state)
	begin
		case current_state is
			when input_A=>next_state<=input_B;
			when input_B=>next_state<=input_OP;
			when input_OP=>next_state<=output_flag;
			when output_flag=>next_state<=input_A;
			when others=>next_state<=next_state;
		end case;
	end process next_state_transform;
	
	output_transform: process(current_state)
	begin
		output_state<="0000";
		case current_state is
			when input_A=>output_state<="0001";
			when input_B=>output_state<="0010";
			when input_OP=>output_state<="0100";
			when output_flag=>output_state<="1000";
			when others=>output_state<="0000";
		end case;
	end process output_transform;

end Behavioral;
