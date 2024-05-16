library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.All;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY drapeau is
 PORT(
 CLK,RST: in std_logic;
 HS : out std_logic;
 VS : out std_logic;
 RED : out std_logic_vector (3 downto 0);
 GREEN : out std_logic_vector (3 downto 0);
 BLUE : out std_logic_vector (3 downto 0)
 );
end drapeau;

architecture Behavioral of drapeau is
signal cnt : std_logic_vector(1 downto 0); --compteur
signal pixel_clk :  std_logic; --horloge pour afficher les pixels
signal hcount :  std_logic_vector(10 downto 0); --compteur de pixels horizontaux
signal vcount :  std_logic_vector(10 downto 0); --compteur de pixels verticaux
signal hcounter : std_logic_vector(10 downto 0) := (others => '0');
signal vcounter : std_logic_vector(10 downto 0) := (others => '0');
signal blankg : std_logic; --représente la partie en dehors de l'écran
signal blankm : std_logic;
signal blankd : std_logic;
constant SPP : std_logic := '0';
signal video_enableg: std_logic; --représente la partie visible à l'écran
signal video_enablem: std_logic;
signal video_enabled: std_logic;

constant HMAX  : std_logic_vector(10 downto 0) := "01100100000"; -- 800 résolution MAXIMALE en horizontal
constant VMAX  : std_logic_vector(10 downto 0) := "01000001101"; -- 525 résolution MAXIMALE en vertical
constant HLINES: std_logic_vector(10 downto 0) := "01010000000"; -- 640 resolution horizontal de la carte
constant HFP   : std_logic_vector(10 downto 0) := "01010001000"; -- 648
constant HSP   : std_logic_vector(10 downto 0) := "01011101000"; -- 744
constant VLINES: std_logic_vector(10 downto 0) := "00111100000"; -- 480 resolution verticale de la carte
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


   pixel_clk <= cnt(1); --horloge à 25MHz
   hcount <= hcounter;
   vcount <= vcounter;
   blankg <= not video_enableg when rising_edge(pixel_clk); --blank est l'inverse de video_enable 
   blankm <= not video_enablem when rising_edge(pixel_clk);
   blankd <= not video_enabled when rising_edge(pixel_clk);

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
   --droite de l'écran : 0
   --gauche de l'écran : 640
   --On veut faire le drapeau français -> on divise l'écran en 3 parties.
   video_enableg <= '1' when (hcounter < HLINES-426 and vcounter < VLINES) else '0';  --la partie gauche, on affiche à l'écran tout ce qui est inférieur à 2/3 de la résolution H, et tt ce qui est en dessous de la résolution V
   video_enablem <= '1' when (hcounter < HLINES-213 and hcounter > HLINES-426 and vcounter < VLINES) else '0'; --partie du milieu : on affiche à l'écran ce qui est entre 2/3 et 1/3 de la résolution H, et tt ce qui est en dessous de la résolution V
   video_enabled <= '1' when (hcounter < HLINES and hcounter > HLINES-213  and vcounter < VLINES) else '0'; --partie de droite : on affiche à l'écran ce qui après le dernier tier de l'écran, et tt ce qui est en dessous de la résolution V

image : process(blankg,blankm,blankd)
begin
  
            if(blankd = '0' and blankm ='1' and blankg = '1') then --si
                RED <= "1111";
                BLUE <= "0000";
                GREEN <= "0000";
    end if;
    if(blankg = '0' and blankm = '1' and blankd ='1') then
                RED <= "0000";
                BLUE <= "1111";
                GREEN <= "0000";
    end if;
    if(blankg = '1' and blankm = '0' and blankd ='1') then
                RED <= "1111";
                BLUE <= "1111";
                GREEN <= "1111";               
     end if;
     if(blankg='1' and blankm ='1' and blankd='1') then
                RED <= "0000";
                BLUE <= "0000";
                GREEN <= "0000";
     end if;
end process image;

END Behavioral;