library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Conv32 is
 Port (
            clk : in std_logic;
            reset : in std_logic;
            end_process : out std_logic
  );
end Conv32;

architecture Behavioral of Conv32 is
    signal conv_reset : std_logic;
    signal file_read_reset : std_logic;
    signal filter_read_reset : std_logic;
    signal WriteData_reset : std_logic;
    signal Image_data : std_logic_vector(7 downto 0);
    signal Filter_data : std_logic_vector(20 downto 0);
    signal conv_out : std_logic_vector(24 downto 0);
    signal process_over : std_logic;
    signal processing : std_logic;
    signal filter_recieved : std_logic;
    signal file_send_data : std_Logic;
    signal filter_send_data : std_logic;
    signal end_file : std_logic;
    signal image_data_over : std_logic;
    signal end_process_signal : std_logic;
    signal bias_data : std_logic_vector (20 downto 0);
    signal next_bias : std_logic;
    signal write_address_signal : integer :=0;
begin
filter_send_data <= not Filter_recieved;
end_process <=end_process_signal;
components : block
    component conv32bias_read is
      Port (
                clk : in std_logic;
                reset : in std_logic;
                data_out : out std_logic_vector(20 downto 0)
                 );
    end component;
    component Convolution32 is 
             Port (              
                         clk                     : in std_logic ;
                         reset                 : in std_logic; 
                         image_data     : in std_logic_vector(7 downto 0); 
                         Filter_data       : in std_logic_vector(20 downto 0); 
                         bias_data       : in std_logic_vector(20 downto 0); 
                         send_data          : out std_logic;
                         process_over     : out std_logic;
                         processing         : out std_logic;
                         Filter_recieved  : out std_logic;
                         next_bias : in std_logic;
                         output_data       : out std_logic_vector(24 downto 0));
    end component;
    
    component Conv32File_read is
        port( 
                clk : in std_logic;
                reset : in std_logic;
                send_data : in std_logic;
                data_over : out std_logic;
                Dataout : out std_logic_vector(7 downto 0)
            );
    end component;
    
    component Conv32FilterReader is
     port( 
                clk : in std_logic;
                reset : in std_logic;
                send_data : in std_logic;
                end_filter : out std_logic;
                Dataout : out std_logic_vector(20 downto 0)
            );
    end component;
    
    component Conv32Writeout is
Port ( 
           clk : in STD_LOGIC;
           reset : in std_logic;
           end_file : in std_logic;
           write_address : in integer;
           data_out : in STD_LOGIC_VECTOR(24 downto 0)
           );
    end component;
begin
bias_r : conv32bias_read port map(
                clk => clk,
                reset => reset,
                data_out => bias_data
);
Conv : Convolution32 port map (
                         clk  => clk,
                         reset  => conv_reset,
                         image_data     => Image_data,
                         Filter_data      => Filter_data,
                         bias_data => bias_data,
                         send_data =>   file_send_data,  
                         process_over  => process_over,
                         processing  => processing,
                         Filter_recieved => Filter_recieved,
                         next_bias => next_bias,
                         output_data  => conv_out
);
file_r : Conv32File_read port map (
                clk => clk,
                reset => file_read_reset,
                send_data => file_send_data,
                data_over => image_data_over,
                Dataout => Image_data
);

filter_r : Conv32FilterReader port map (
                clk => clk,
                reset => filter_read_reset,
                send_data => filter_send_data,
                end_filter => end_process_signal,
                Dataout => Filter_data
);

File_wr : Conv32Writeout port map (
           clk => clk,
           reset => WriteData_reset,
           end_file => end_file,
           write_address => write_address_signal,
           data_out => conv_out
           );

end block components;

controller : block
signal process_over_last_val : std_logic;
begin

 resetprocess:  process (reset, clk,process_over,image_data_over,end_process_signal)
 begin
        if reset ='1' then
                conv_reset <= '1';
                file_read_reset <= '1';
                filter_read_reset <= '1';
                WriteData_reset <= '1';
                next_bias <= '0';
                write_address_signal <= 0;
       elsif (end_process_signal ='1') then
            if (image_data_over ='1' ) then
                if (process_over='0' and process_over'event )then
                next_bias <= '0';
                conv_reset <= '1';
                file_read_reset <= '1';
                filter_read_reset <= '0';
                WriteData_reset <= '1';
                write_address_signal <= 0;
             end if;
            end if;          
       elsif (image_data_over ='1' ) then
                if (process_over='0' and process_over'event )then
                next_bias <= '1';
                write_address_signal <= write_address_signal+1;
                 conv_reset <= '1';
                 file_read_reset <= '1';
                 end if;
       else 
                 conv_reset <= '0';
                 next_bias <= '0';
                 file_read_reset <= '0';
                 filter_read_reset <= '0';
                 WriteData_reset <= '0';
      end if;
 end process;


end block controller;

end behavioral;
