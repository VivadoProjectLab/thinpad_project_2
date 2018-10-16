----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2018/10/15 14:08:29
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ComputePart is
	port(
	input_data: in std_logic_vector(15 downto 0);
	output_data: out std_logic_vector(15 downto 0);
	operation_data: in std_logic_vector(3 downto 0);
	current_state: in std_logic_vector(3 downto 0)
	);
end ComputePart;

architecture Behavioral of ComputePart is
signal input_A: std_logic_vector(15 downto 0);
signal input_B: std_logic_vector(15 downto 0);
signal add_result: signed(15 downto 0);
signal sub_result: signed(15 downto 0);
signal and_result: std_logic_vector(15 downto 0);
signal or_result: std_logic_vector(15 downto 0);
signal xor_result: std_logic_vector(15 downto 0);
signal not_result: std_logic_vector(15 downto 0);
signal sll_result: unsigned(15 downto 0);
signal srl_result: unsigned(15 downto 0);
signal sra_result: signed(15 downto 0);
signal rol_result: std_logic_vector(15 downto 0);
signal flag_result: std_logic_vector(3 downto 0);
signal temp_result: std_logic_vector(15 downto 0);
signal cflag: std_logic:= '0';
signal zflag: std_logic:= '0';
signal sflag: std_logic:= '0';
signal oflag: std_logic:= '0';

begin
	get_input: process(input_data, operation_data)
	begin
		case current_state is
			when "0001"=>input_A<=input_data;input_B<=input_B;
			when "0010"=>input_B<=input_data;input_A<=input_A;
			when others=>input_A<=input_A;input_B<=input_B;
		end case;
	end process get_input;
	
	get_cflag: process(temp_result, current_state, operation_data, add_result, sub_result, and_result, or_result, xor_result, not_result, sll_result, srl_result, sra_result, rol_result)
	begin
		case current_state is
			when "0001"=>cflag<=cflag;
			when "0010"=>cflag<=cflag;
			when "0100"=>
				if (input_A(15)='1' and input_B(15)='1') or ((input_A(15)='1' or input_B(15)='1') and temp_result(15)='0') then
					cflag<='1';
				else
					cflag<='0';
				end if;
			when "1000"=>cflag<=cflag;
			when others=>cflag<=cflag;
		end case;
	end process get_cflag;
	
	get_zflag: process(temp_result, current_state, operation_data, add_result, sub_result, and_result, or_result, xor_result, not_result, sll_result, srl_result, sra_result, rol_result)
	begin
		case current_state is
			when "0001"=>zflag<=zflag;
			when "0010"=>zflag<=zflag;
			when "0100"=>
				if temp_result="0000000000000000" then
					zflag<='1';
				else
					zflag<='0';
				end if;
			when "1000"=>zflag<=zflag;
			when others=>zflag<=zflag;
		end case;
	end process get_zflag;
	
	get_sflag: process(temp_result, current_state, operation_data, add_result, sub_result, and_result, or_result, xor_result, not_result, sll_result, srl_result, sra_result, rol_result)
	begin
		case current_state is
			when "0001"=>sflag<=sflag;
			when "0010"=>sflag<=sflag;
			when "0100"=>
				if (temp_result(15) and '1') = '1' then
					sflag<='1';
				else
					sflag<='0';
				end if;
			when "1000"=>sflag<=sflag;
			when others=>sflag<=sflag;
		end case;
	end process get_sflag;
	
	get_oflag: process(temp_result, current_state, operation_data, add_result, sub_result, and_result, or_result, xor_result, not_result, sll_result, srl_result, sra_result, rol_result)
	begin
		case current_state is
			when "0001"=>oflag<=oflag;
			when "0010"=>oflag<=oflag;
			when "0100"=>
				if (input_A(15) = '0' and input_B(15) = '0' and temp_result(15) = '1') or (input_A(15)='1' and input_B(15)='1' and temp_result(15)='0') then
					oflag<='1';
				else
					oflag<='0';
				end if;
			when "1000"=>oflag<=oflag;
			when others=>oflag<=oflag;
		end case;
	end process get_oflag;
	
	get_output: process(current_state, operation_data, add_result, sub_result, and_result, or_result, xor_result, not_result, sll_result, srl_result, sra_result, rol_result)
	begin
		case current_state is
			when "0001"=>temp_result<=input_A;
			when "0010"=>temp_result<=input_B;
			when "0100"=>
				case operation_data is
					when "0000"=>temp_result<=std_logic_vector(add_result);
					when "0001"=>temp_result<=std_logic_vector(sub_result);
					when "0010"=>temp_result<=and_result;
					when "0011"=>temp_result<=or_result;
					when "0100"=>temp_result<=xor_result;
					when "0101"=>temp_result<=not_result;
					when "0110"=>temp_result<=std_logic_vector(sll_result);
					when "0111"=>temp_result<=std_logic_vector(srl_result);
					when "1000"=>temp_result<=std_logic_vector(sra_result);
					when "1001"=>temp_result<=rol_result;
					when others=>temp_result<="0000000000000000";
				end case;
			when "1000"=>temp_result<="000000000000" & flag_result;
			when others=>temp_result<="0000000000000000";
		end case;
	end process get_output;
	
	add_result<=signed(input_A)+signed(input_B);
	sub_result<=signed(input_A)-signed(input_B);
	and_result<=input_A and input_B;
	or_result<=input_A or input_B;
	xor_result<=input_A xor input_B;
	not_result<=not input_A;
	sll_result<=shift_left(unsigned(input_A), to_integer(signed(input_B)));
	srl_result<=shift_right(unsigned(input_A), to_integer(signed(input_B)));
	sra_result<=shift_right(signed(input_A), to_integer(signed(input_B)));
	rol_result<=to_stdlogicvector(to_bitvector(input_A) rol to_integer(signed(input_B)));
	flag_result<=cflag & zflag & sflag & oflag;
	output_data<=temp_result;
	
end Behavioral;
