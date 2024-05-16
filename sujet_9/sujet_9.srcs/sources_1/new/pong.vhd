library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.All;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY pong is
 PORT(
 CLK,RST,btnLg,btnRg,btnRd,btnLd: in std_logic;
 LED : out STD_LOGIC_VECTOR (6 downto 0);
 an : out STD_LOGIC_VECTOR (3 downto 0);
 HS : out std_logic;
 VS : out std_logic;
 RED : out std_logic_vector (3 downto 0);
 GREEN : out std_logic_vector (3 downto 0);
 BLUE : out std_logic_vector (3 downto 0)
 );
end pong;

architecture Behavioral of pong is
signal cnt : std_logic_vector(1 downto 0);
signal compteur_led : std_logic_vector(3 downto  0) := "0000";
signal compt : std_logic_vector(27 downto 0);
signal v : integer :=0;
signal h : integer :=0;
signal xdirection : integer :=1;
signal ydirection : integer :=1;
signal posxb : integer :=20;
signal posyb : integer :=20;
signal posyrg : integer :=240;
signal posyrd : integer :=240;
signal speed : integer :=1;
signal width : integer :=10;
signal height : integer :=50;
SIGNAL led_total : std_logic_vector(15 downto 0):="0000000000000000";
signal pixel_clk :  std_logic;
signal pixel_clk2 :  std_logic;
signal button_clk : std_logic;
signal hcount :  std_logic_vector(10 downto 0);
signal vcount :  std_logic_vector(10 downto 0);
signal hcounter : std_logic_vector(10 downto 0) := (others => '0');
signal vcounter : std_logic_vector(10 downto 0) := (others => '0');
SIGNAL compt16 : std_logic_vector(27 downto 0);
signal blankb : std_logic;
signal blankrg : std_logic;
signal blankrd : std_logic;
constant SPP : std_logic := '0';
signal video_enableb: std_logic;
signal video_enablerg: std_logic;
signal video_enablerd: std_logic;


constant HMAX  : std_logic_vector(10 downto 0) := "01100100000"; -- 800
constant VMAX  : std_logic_vector(10 downto 0) := "01000001101"; -- 525
constant HLINES: std_logic_vector(10 downto 0) := "01010000000"; -- 640
constant HFP   : std_logic_vector(10 downto 0) := "01010001000"; -- 648
constant HSP   : std_logic_vector(10 downto 0) := "01011101000"; -- 744
constant VLINES: std_logic_vector(10 downto 0) := "00111100000"; -- 480
constant VFP   : std_logic_vector(10 downto 0) := "00111100010"; -- 482
constant VSP   : std_logic_vector(10 downto 0) := "00111100100"; -- 484
begin

horloge : process (CLK,RST)
begin
	if (RST = '1') then
		cnt <= "00";
	elsif (CLK'event and CLK = '1') then
		cnt <= cnt + 1;
	end if;
end process;

rafraichissement : process(CLK,RST)
begin
    if (RST = '1') then
        compt <= (others => '0');
        compt16 <= (others => '0');
    elsif (CLK'event and CLK = '1') then
		compt <= compt + 1;
		compt16 <= compt16+1;
	end if;
end process;

process(compt16(10))
begin
CASE compt16(19 downto 18) IS
when "00" =>
        an<="1110";
        -- activate LED1 and Deactivate LED2, LED3, LED4
        compteur_led <= led_total(7 downto 4);
    when "01" =>
        an<="1101";
        -- activate LED2 and Deactivate LED1, LED3, LED4
       compteur_led <= led_total(3 downto 0);
    when "10" =>
        an<="1011";
        -- activate LED3 and Deactivate LED2, LED1, LED4
       compteur_led <= led_total(15 downto 12);
    when "11" =>
       an<="0111";
        -- activate LED4 and Deactivate LED2, LED3, LED1  
        compteur_led <= led_total(11 downto 8);
    end case;
end process;

process(compteur_led)
begin
    case compteur_led is
    when "0000" => LED <= "0000001"; -- "0"     
    when "0001" => LED <= "1001111"; -- "1" 
    when "0010" => LED <= "0010010"; -- "2" 
    when "0011" => LED <= "0000110"; -- "3" 
    when "0100" => LED <= "1001100"; -- "4" 
    when "0101" => LED <= "0100100"; -- "5" 
    when "0110" => LED <= "0100000"; -- "6" 
    when "0111" => LED <= "0001111"; -- "7" 
    when "1000" => LED <= "0000000"; -- "8"     
    when "1001" => LED <= "0000100"; -- "9"
    when others => LED <= "0000001";
    end case;
end process;

   pixel_clk <= cnt(1);
   pixel_clk2 <= compt(18);
   button_clk <= compt(23);
   hcount <= hcounter;
   vcount <= vcounter;
   blankb <= not video_enableb when rising_edge(pixel_clk);
   blankrg <= not video_enablerg when rising_edge(pixel_clk);
   blankrd <= not video_enablerd when rising_edge(pixel_clk);

   h_count: process(pixel_clk)
   begin
      if(rising_edge(pixel_clk)) then
         if(rst = '1') then
           hcounter <= (others => '0');
         elsif(hcounter = HMAX) then
            hcounter <= (others => '0');   
         else
            hcounter <= hcounter + 1;
         end if;
      end if;
   end process h_count;

   v_count: process(pixel_clk)
   begin
      if(rising_edge(pixel_clk)) then
         if(rst = '1') then
            vcounter <= (others => '0');
         elsif(hcounter = HMAX) then
            if(vcounter = VMAX) then
               vcounter <= (others => '0');
            else
               vcounter <= vcounter + 1;
            end if;
         end if;
      end if;
   end process v_count;

   do_hs: process(pixel_clk)
   begin
      if(rising_edge(pixel_clk)) then
         if(hcounter >= HFP and hcounter < HSP) then
            HS <= SPP;
         else
            HS <= not SPP;
         end if;
      end if;
   end process do_hs;

   do_vs: process(pixel_clk)
   begin
      if(rising_edge(pixel_clk)) then
         if(vcounter >= VFP and vcounter < VSP) then
            VS <= SPP;
         else
            VS <= not SPP;
         end if;
      end if;
   end process do_vs;
   
 deplacement_balle : process(posxb,posyb,speed,pixel_clk2,RST)
   begin
    if(RST = '1') then
   elsif (pixel_clk2'event and pixel_clk2 = '1') then
       posxb<=posxb+speed*xdirection;
       posyb<=posyb+speed*ydirection;
        if(posxb>=640-width)then
            if led_total(3 downto 0) >= "1001" then
                led_total(3 downto 0) <= "0000"; 
                led_total(7 downto 4) <= led_total(7 downto 4) + 1;
            else
                led_total(3 downto 0) <= led_total(3 downto 0) + 1;
            end if;
            if led_total(7 downto 4) >= "1001" and led_total(3 downto 0) >= "1001" THEN
                led_total(7 downto 4) <= "0000";
           end if;
           xdirection<=-1;
           posxb<=300;
           posyb<=100;
           end if;
        if(posxb=600 and  posyb>=posyrg-height and posyrg>=posyb and xdirection = 1)then
            xdirection<=-1;
            if(posyb>240) then
                ydirection<=1;
            else
                ydirection<=-1;
            end if;
        end if;
        if(0+width>=posxb)then
            if led_total(11 downto 8) >= "1001" THEN
                led_total(11 downto 8) <= "0000"; 
                led_total(15 downto 12) <= led_total(15 downto 12) + 1;
            else
                led_total(11 downto 8) <= led_total(11 downto 8) + 1;
            end if;
            if led_total(15 downto 12) >= "1001" AND led_total(11 downto 8) >= "1001" THEN
                led_total(15 downto 12) <= "0000";
           end if;
            xdirection<=1;
            posxb<=340;
            posyb<=100;
        end if;
        if(posxb=50 and  posyb>=posyrd-height and posyrd>=posyb and xdirection = -1)then
            xdirection<=1;
            if(posyb>240) then
                ydirection<=1;
            else
                ydirection<=-1;
             end if;
        end if;
        if(posyb>=480-(width/2))then
            ydirection<=-1;
            end if;
        if(0+width>=posyb)then
            ydirection<=1;
        end if;
   end if;
   end process deplacement_balle;
   
 
   deplacement_raquettes : process(button_clk,btnLd,btnRd,btnLg,btnRg)
   begin
   if (button_clk'event and button_clk = '1') then
		if (btnLg = '1') then
		          if (posyrg+35>480) then
		              posyrg<=posyrg;
		          else
		          posyrg<=posyrg+35;
		          end if;
	     elsif(btnRg ='1') then  
	               if (posyrg-height-35<0) then
	                   posyrg<=posyrg;
	               else
	                   posyrg<=posyrg-35;
	               end if;
	      end if;
	   if (btnLd = '1') then
	              if (posyrd+35>480) then
		              posyrd<=posyrd;
		          else
		          posyrd<=posyrd+35;
		          end if;
	   elsif(btnRd = '1') then
	               if (posyrd-height-35<0) then
	                   posyrd<=posyrd;
	               else
	                   posyrd<=posyrd-35;
	               end if;
	   end if;  
	end if;
   end process deplacement_raquettes;

video_enableb <= '1' when (hcounter < HLINES-posxb+(width/2) and hcounter >HLINES-posxb-(width/2) and vcounter < VLINES-posyb+(width/2) and vcounter > VLINES-posyb-(width/2) ) else '0';
video_enablerg <= '1' when (hcounter < HLINES-600 and hcounter > HLINES-610 and vcounter < VLINES-posyrg+(height/2) and vcounter > VLINES-posyrg-(height/2)) else '0';
video_enablerd <= '1' when (hcounter < HLINES-40 and hcounter > HLINES-50  and vcounter < VLINES-posyrd+(height/2) and vcounter > VLINES-posyrd-(height/2)) else '0';

image : process(blankb,blankrg,blankrd)
begin
    if(blankb = '0' and blankrg='1' and blankrd='1') then
                RED <= "1111";
                BLUE <= "1111";
                GREEN <= "1111";
                end if;
    if(blankb = '1' and blankrg='0' and blankrd='1') then
                RED <= "1111";
                BLUE <= "1111";
                GREEN <= "1111";
                end if;
    if(blankb = '1' and blankrg='1' and blankrd='0') then
                RED <= "1111";
                BLUE <= "1111";
                GREEN <= "1111";
                end if;           
    if(blankb='1' and blankrg='1' and blankrd='1') then
        RED <= "0000";
        BLUE <= "0000";
        GREEN <= "0000";
    end if;
end process image;

END Behavioral;