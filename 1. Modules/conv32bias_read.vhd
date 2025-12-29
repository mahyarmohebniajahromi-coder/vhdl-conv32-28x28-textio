library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library STD;
use STD.TEXTIO.ALL;
use work.String_to_Vector.all;

entity conv32bias_read is
  Port (
                clk : in std_logic;
                reset : in std_logic;
                data_out : out std_logic_vector(20 downto 0)
                 );
end conv32bias_read;

architecture Behavioral of conv32bias_read is
file fptr : text;
begin
             file_open(fptr, "C:\\Users\\Mahyar\\Desktop\\project\\new106\\conv32_bias-106binary.txt", read_mode);        

process (clk,reset)
        variable line_buffer: LINE;
        variable pixel_data: string(21 downto 1);
    begin
    if rising_edge(clk) then
                        if (not endfile(fptr)) then
                        readline(fptr, line_buffer);
                        read(line_buffer, pixel_data); 
                        data_out<= Convert_String_to_Vector(pixel_data);
                        else 
                        data_out <= (others =>'U');
                        end if; -- end file
                end if; --clk
    end process;

end behavioral;