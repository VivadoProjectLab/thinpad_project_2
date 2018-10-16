----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2018/10/15 14:51:21
-- Design Name: 
-- Module Name: StateMachine_and_ALU - Behavioral
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

entity ALU is
	port(
		clk, rst:in std_logic;
		input_data:in std_logic_vector(15 downto 0);
		output_data:out std_logic_vector(15 downto 0);
		operation_data:in std_logic_vector(3 downto 0);
		state_number: out std_logic_vector(1 downto 0)
	);
end ALU;

architecture Behavioral of ALU is
component StateMachine
	port(
		clk, rst:in std_logic;
		output_state:out std_logic_vector(3 downto 0)
	);
end component;

component ComputePart
	port(
	input_data: in std_logic_vector(15 downto 0);
	output_data: out std_logic_vector(15 downto 0);
	operation_data: in std_logic_vector(3 downto 0);
	current_state: in std_logic_vector(3 downto 0)
	);
end component;

signal state_data: std_logic_vector(3 downto 0);

begin
	my_state_machine: StateMachine
		port map(
			clk=>clk,
			rst=>rst,
			output_state=>state_data
		);
	
	my_compute_part: ComputePart
		port map(
			input_data=>input_data,
			output_data=>output_data,
			operation_data=>operation_data,
			current_state=>state_data
		);
		
	state_number_output: process(state_data)
	begin
		case state_data is
			when "0001"=>state_number<="00";
			when "0010"=>state_number<="01";
			when "0100"=>state_number<="10";
			when "1000"=>state_number<="11";
			when others=>state_number<="00";
		end case;
	end process state_number_output;
	
end Behavioral;
