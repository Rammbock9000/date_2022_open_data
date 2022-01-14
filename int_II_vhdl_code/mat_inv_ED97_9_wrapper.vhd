--------------------------------------------------------------------------------
--                         ModuloCounter_11_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Patrick Sittel
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity ModuloCounter_11_component is
   port ( clk, rst : in std_logic;
          Counter_out : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of ModuloCounter_11_component is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk,rst)
	 variable count : std_logic_vector(3 downto 0) := (others => '0');
begin
	 if rst = '1' then
	 	 count := (others => '0');
	 elsif clk'event and clk = '1' then
	 	 if count = 10 then
	 	 	 count := (others => '0');
	 	 else
	 	 	 count := count+1;
	 	 end if;
	 end if;
	 Counter_out <= count;
end process;
end architecture;

--------------------------------------------------------------------------------
--                          InputIEEE_8_23_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin (2008)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity InputIEEE_8_23_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(31 downto 0);
          R : out std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of InputIEEE_8_23_component is
signal expX : std_logic_vector(7 downto 0) := (others => '0');
signal fracX : std_logic_vector(22 downto 0) := (others => '0');
signal sX : std_logic := '0';
signal expZero : std_logic := '0';
signal expInfty : std_logic := '0';
signal fracZero : std_logic := '0';
signal reprSubNormal : std_logic := '0';
signal sfracX : std_logic_vector(22 downto 0) := (others => '0');
signal fracR : std_logic_vector(22 downto 0) := (others => '0');
signal expR : std_logic_vector(7 downto 0) := (others => '0');
signal infinity : std_logic := '0';
signal zero : std_logic := '0';
signal NaN : std_logic := '0';
signal exnR : std_logic_vector(1 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   expX  <= X(30 downto 23);
   fracX  <= X(22 downto 0);
   sX  <= X(31);
   expZero  <= '1' when expX = (7 downto 0 => '0') else '0';
   expInfty  <= '1' when expX = (7 downto 0 => '1') else '0';
   fracZero <= '1' when fracX = (22 downto 0 => '0') else '0';
   reprSubNormal <= fracX(22);
   -- since we have one more exponent value than IEEE (field 0...0, value emin-1),
   -- we can represent subnormal numbers whose mantissa field begins with a 1
   sfracX <= fracX(21 downto 0) & '0' when (expZero='1' and reprSubNormal='1')    else fracX;
   fracR <= sfracX;
   -- copy exponent. This will be OK even for subnormals, zero and infty since in such cases the exn bits will prevail
   expR <= expX;
   infinity <= expInfty and fracZero;
   zero <= expZero and not reprSubNormal;
   NaN <= expInfty and not fracZero;
   exnR <= 
           "00" when zero='1' 
      else "10" when infinity='1' 
      else "11" when NaN='1' 
      else "01" ;  -- normal number
   R <= exnR & sX & expR & fracR; 
end architecture;

--------------------------------------------------------------------------------
--           IntMultiplier_UsingDSP_24_24_48_unsigned_F500_uid72900
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Kinga Illyes, Bogdan Popa, Bogdan Pasca, 2012
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity IntMultiplier_UsingDSP_24_24_48_unsigned_F500_uid72900 is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(23 downto 0);
          Y : in std_logic_vector(23 downto 0);
          R : out std_logic_vector(47 downto 0)   );
end entity;

architecture arch of IntMultiplier_UsingDSP_24_24_48_unsigned_F500_uid72900 is
signal XX_m72901 : std_logic_vector(23 downto 0) := (others => '0');
signal YY_m72901 : std_logic_vector(23 downto 0) := (others => '0');
signal XX : unsigned(-1+24 downto 0) := (others => '0');
signal YY : unsigned(-1+24 downto 0) := (others => '0');
signal RR : unsigned(-1+48 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   XX_m72901 <= X ;
   YY_m72901 <= Y ;
   XX <= unsigned(X);
   YY <= unsigned(Y);
   RR <= XX*YY;
   R <= std_logic_vector(RR(47 downto 0));
end architecture;

--------------------------------------------------------------------------------
--                         IntAdder_33_f500_uid72904
--                    (IntAdderClassical_33_f500_uid72906)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_33_f500_uid72904 is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(32 downto 0);
          Y : in std_logic_vector(32 downto 0);
          Cin : in std_logic;
          R : out std_logic_vector(32 downto 0)   );
end entity;

architecture arch of IntAdder_33_f500_uid72904 is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   --Classical
    R <= X + Y + Cin;
end architecture;

--------------------------------------------------------------------------------
--         FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin 2008-2011
--------------------------------------------------------------------------------
-- Pipeline depth: 2 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(8+23+2 downto 0);
          Y : in std_logic_vector(8+23+2 downto 0);
          R : out std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component is
   component IntMultiplier_UsingDSP_24_24_48_unsigned_F500_uid72900 is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(23 downto 0);
             Y : in std_logic_vector(23 downto 0);
             R : out std_logic_vector(47 downto 0)   );
   end component;

   component IntAdder_33_f500_uid72904 is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(32 downto 0);
             Y : in std_logic_vector(32 downto 0);
             Cin : in std_logic;
             R : out std_logic_vector(32 downto 0)   );
   end component;

signal sign, sign_d1, sign_d2 : std_logic := '0';
signal expX : std_logic_vector(7 downto 0) := (others => '0');
signal expY : std_logic_vector(7 downto 0) := (others => '0');
signal expSumPreSub, expSumPreSub_d1 : std_logic_vector(9 downto 0) := (others => '0');
signal bias, bias_d1 : std_logic_vector(9 downto 0) := (others => '0');
signal expSum : std_logic_vector(9 downto 0) := (others => '0');
signal sigX : std_logic_vector(23 downto 0) := (others => '0');
signal sigY : std_logic_vector(23 downto 0) := (others => '0');
signal sigProd, sigProd_d1 : std_logic_vector(47 downto 0) := (others => '0');
signal excSel : std_logic_vector(3 downto 0) := (others => '0');
signal exc, exc_d1, exc_d2 : std_logic_vector(1 downto 0) := (others => '0');
signal norm : std_logic := '0';
signal expPostNorm : std_logic_vector(9 downto 0) := (others => '0');
signal sigProdExt, sigProdExt_d1 : std_logic_vector(47 downto 0) := (others => '0');
signal expSig, expSig_d1 : std_logic_vector(32 downto 0) := (others => '0');
signal sticky, sticky_d1 : std_logic := '0';
signal guard, guard_d1 : std_logic := '0';
signal round : std_logic := '0';
signal expSigPostRound : std_logic_vector(32 downto 0) := (others => '0');
signal excPostNorm : std_logic_vector(1 downto 0) := (others => '0');
signal finalExc : std_logic_vector(1 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            sign_d1 <=  sign;
            sign_d2 <=  sign_d1;
            expSumPreSub_d1 <=  expSumPreSub;
            bias_d1 <=  bias;
            sigProd_d1 <=  sigProd;
            exc_d1 <=  exc;
            exc_d2 <=  exc_d1;
            sigProdExt_d1 <=  sigProdExt;
            expSig_d1 <=  expSig;
            sticky_d1 <=  sticky;
            guard_d1 <=  guard;
         end if;
      end process;
   sign <= X(31) xor Y(31);
   expX <= X(30 downto 23);
   expY <= Y(30 downto 23);
   expSumPreSub <= ("00" & expX) + ("00" & expY);
   bias <= CONV_STD_LOGIC_VECTOR(127,10);
   ----------------Synchro barrier, entering cycle 1----------------
   expSum <= expSumPreSub_d1 - bias_d1;
   ----------------Synchro barrier, entering cycle 0----------------
   sigX <= "1" & X(22 downto 0);
   sigY <= "1" & Y(22 downto 0);
   SignificandMultiplication: IntMultiplier_UsingDSP_24_24_48_unsigned_F500_uid72900  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => sigProd,
                 X => sigX,
                 Y => sigY);
   ----------------Synchro barrier, entering cycle 0----------------
   excSel <= X(33 downto 32) & Y(33 downto 32);
   with excSel select 
   exc <= "00" when  "0000" | "0001" | "0100", 
          "01" when "0101",
          "10" when "0110" | "1001" | "1010" ,
          "11" when others;
   norm <= sigProd_d1(47);
   -- exponent update
   expPostNorm <= expSum + ("000000000" & norm);
   -- significand normalization shift
   sigProdExt <= sigProd_d1(46 downto 0) & "0" when norm='1' else
                         sigProd_d1(45 downto 0) & "00";
   expSig <= expPostNorm & sigProdExt(47 downto 25);
   sticky <= sigProdExt(24);
   guard <= '0' when sigProdExt(23 downto 0)="000000000000000000000000" else '1';
   ----------------Synchro barrier, entering cycle 2----------------
   round <= sticky_d1 and ( (guard_d1 and not(sigProdExt_d1(25))) or (sigProdExt_d1(25) ))  ;
   RoundingAdder: IntAdder_33_f500_uid72904  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => round,
                 R => expSigPostRound   ,
                 X => expSig_d1,
                 Y => "000000000000000000000000000000000");
   with expSigPostRound(32 downto 31) select
   excPostNorm <=  "01"  when  "00",
                               "10"             when "01", 
                               "00"             when "11"|"10",
                               "11"             when others;
   with exc_d2 select 
   finalExc <= exc_d2 when  "11"|"10"|"00",
                       excPostNorm when others; 
   R <= finalExc & sign_d2 & expSigPostRound(30 downto 0);
end architecture;

--------------------------------------------------------------------------------
--             Mux_sign_1_wordsize_34_numberOfInputs_11_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Mux_sign_1_wordsize_34_numberOfInputs_11_component is
   port ( clk, rst : in std_logic;
          iS_0 : in std_logic_vector(33 downto 0);
          iS_1 : in std_logic_vector(33 downto 0);
          iS_2 : in std_logic_vector(33 downto 0);
          iS_3 : in std_logic_vector(33 downto 0);
          iS_4 : in std_logic_vector(33 downto 0);
          iS_5 : in std_logic_vector(33 downto 0);
          iS_6 : in std_logic_vector(33 downto 0);
          iS_7 : in std_logic_vector(33 downto 0);
          iS_8 : in std_logic_vector(33 downto 0);
          iS_9 : in std_logic_vector(33 downto 0);
          iS_10 : in std_logic_vector(33 downto 0);
          iSel : in std_logic_vector(3 downto 0);
          oMux : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Mux_sign_1_wordsize_34_numberOfInputs_11_component is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   with iSel select
      oMux <= 
         iS_0 when "0000",
         iS_1 when "0001",
         iS_2 when "0010",
         iS_3 when "0011",
         iS_4 when "0100",
         iS_5 when "0101",
         iS_6 when "0110",
         iS_7 when "0111",
         iS_8 when "1000",
         iS_9 when "1001",
         iS_10 when "1010",
(others=>'X') when others;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      Y <= s0;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--             Mux_sign_1_wordsize_34_numberOfInputs_10_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Mux_sign_1_wordsize_34_numberOfInputs_10_component is
   port ( clk, rst : in std_logic;
          iS_0 : in std_logic_vector(33 downto 0);
          iS_1 : in std_logic_vector(33 downto 0);
          iS_2 : in std_logic_vector(33 downto 0);
          iS_3 : in std_logic_vector(33 downto 0);
          iS_4 : in std_logic_vector(33 downto 0);
          iS_5 : in std_logic_vector(33 downto 0);
          iS_6 : in std_logic_vector(33 downto 0);
          iS_7 : in std_logic_vector(33 downto 0);
          iS_8 : in std_logic_vector(33 downto 0);
          iS_9 : in std_logic_vector(33 downto 0);
          iSel : in std_logic_vector(3 downto 0);
          oMux : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Mux_sign_1_wordsize_34_numberOfInputs_10_component is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   with iSel select
      oMux <= 
         iS_0 when "0000",
         iS_1 when "0001",
         iS_2 when "0010",
         iS_3 when "0011",
         iS_4 when "0100",
         iS_5 when "0101",
         iS_6 when "0110",
         iS_7 when "0111",
         iS_8 when "1000",
         iS_9 when "1001",
(others=>'X') when others;
end architecture;

--------------------------------------------------------------------------------
--                         OutputIEEE_8_23_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: F. Ferrandi  (2009-2012)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity OutputIEEE_8_23_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(8+23+2 downto 0);
          R : out std_logic_vector(31 downto 0)   );
end entity;

architecture arch of OutputIEEE_8_23_component is
signal expX : std_logic_vector(7 downto 0) := (others => '0');
signal fracX : std_logic_vector(22 downto 0) := (others => '0');
signal exnX : std_logic_vector(1 downto 0) := (others => '0');
signal sX : std_logic := '0';
signal expZero : std_logic := '0';
signal sfracX : std_logic_vector(22 downto 0) := (others => '0');
signal fracR : std_logic_vector(22 downto 0) := (others => '0');
signal expR : std_logic_vector(7 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   expX  <= X(30 downto 23);
   fracX  <= X(22 downto 0);
   exnX  <= X(33 downto 32);
   sX  <= X(31) when (exnX = "01" or exnX = "10" or exnX = "00") else '0';
   expZero  <= '1' when expX = (7 downto 0 => '0') else '0';
   -- since we have one more exponent value than IEEE (field 0...0, value emin-1),
   -- we can represent subnormal numbers whose mantissa field begins with a 1
   sfracX <= 
      (22 downto 0 => '0') when (exnX = "00") else
      '1' & fracX(22 downto 1) when (expZero = '1' and exnX = "01") else
      fracX when (exnX = "01") else 
      (22 downto 1 => '0') & exnX(0);
   fracR <= sfracX;
   expR <=  
      (7 downto 0 => '0') when (exnX = "00") else
      expX when (exnX = "01") else 
      (7 downto 0 => '1');
   R <= sX & expR & fracR; 
end architecture;

--------------------------------------------------------------------------------
--                      FPAdd_8_23_uid73211_RightShifter
--                 (RightShifter_24_by_max_26_F250_uid73213)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2011)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPAdd_8_23_uid73211_RightShifter is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(23 downto 0);
          S : in std_logic_vector(4 downto 0);
          R : out std_logic_vector(49 downto 0)   );
end entity;

architecture arch of FPAdd_8_23_uid73211_RightShifter is
signal level0 : std_logic_vector(23 downto 0) := (others => '0');
signal ps : std_logic_vector(4 downto 0) := (others => '0');
signal level1 : std_logic_vector(24 downto 0) := (others => '0');
signal level2 : std_logic_vector(26 downto 0) := (others => '0');
signal level3 : std_logic_vector(30 downto 0) := (others => '0');
signal level4 : std_logic_vector(38 downto 0) := (others => '0');
signal level5 : std_logic_vector(54 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   level0<= X;
   ps<= S;
   level1<=  (0 downto 0 => '0') & level0 when ps(0) = '1' else    level0 & (0 downto 0 => '0');
   level2<=  (1 downto 0 => '0') & level1 when ps(1) = '1' else    level1 & (1 downto 0 => '0');
   level3<=  (3 downto 0 => '0') & level2 when ps(2) = '1' else    level2 & (3 downto 0 => '0');
   level4<=  (7 downto 0 => '0') & level3 when ps(3) = '1' else    level3 & (7 downto 0 => '0');
   level5<=  (15 downto 0 => '0') & level4 when ps(4) = '1' else    level4 & (15 downto 0 => '0');
   R <= level5(54 downto 5);
end architecture;

--------------------------------------------------------------------------------
--                         IntAdder_27_f250_uid73216
--                   (IntAdderAlternative_27_f250_uid73220)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_27_f250_uid73216 is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(26 downto 0);
          Y : in std_logic_vector(26 downto 0);
          Cin : in std_logic;
          R : out std_logic_vector(26 downto 0)   );
end entity;

architecture arch of IntAdder_27_f250_uid73216 is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   --Alternative
    R <= X + Y + Cin;
end architecture;

--------------------------------------------------------------------------------
--               LZCShifter_28_to_28_counting_32_F250_uid73223
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Bogdan Pasca (2007)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity LZCShifter_28_to_28_counting_32_F250_uid73223 is
   port ( clk, rst : in std_logic;
          I : in std_logic_vector(27 downto 0);
          Count : out std_logic_vector(4 downto 0);
          O : out std_logic_vector(27 downto 0)   );
end entity;

architecture arch of LZCShifter_28_to_28_counting_32_F250_uid73223 is
signal level5 : std_logic_vector(27 downto 0) := (others => '0');
signal count4, count4_d1 : std_logic := '0';
signal level4, level4_d1 : std_logic_vector(27 downto 0) := (others => '0');
signal count3, count3_d1 : std_logic := '0';
signal level3 : std_logic_vector(27 downto 0) := (others => '0');
signal count2 : std_logic := '0';
signal level2 : std_logic_vector(27 downto 0) := (others => '0');
signal count1 : std_logic := '0';
signal level1 : std_logic_vector(27 downto 0) := (others => '0');
signal count0 : std_logic := '0';
signal level0 : std_logic_vector(27 downto 0) := (others => '0');
signal sCount : std_logic_vector(4 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            count4_d1 <=  count4;
            level4_d1 <=  level4;
            count3_d1 <=  count3;
         end if;
      end process;
   level5 <= I ;
   count4<= '1' when level5(27 downto 12) = (27 downto 12=>'0') else '0';
   level4<= level5(27 downto 0) when count4='0' else level5(11 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(27 downto 20) = (27 downto 20=>'0') else '0';
   ----------------Synchro barrier, entering cycle 1----------------
   level3<= level4_d1(27 downto 0) when count3_d1='0' else level4_d1(19 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(27 downto 24) = (27 downto 24=>'0') else '0';
   level2<= level3(27 downto 0) when count2='0' else level3(23 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(27 downto 26) = (27 downto 26=>'0') else '0';
   level1<= level2(27 downto 0) when count1='0' else level2(25 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(27 downto 27) = (27 downto 27=>'0') else '0';
   level0<= level1(27 downto 0) when count0='0' else level1(26 downto 0) & (0 downto 0 => '0');

   O <= level0;
   sCount <= count4_d1 & count3_d1 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                         IntAdder_34_f250_uid73226
--                    (IntAdderClassical_34_f250_uid73228)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_34_f250_uid73226 is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : in std_logic_vector(33 downto 0);
          Cin : in std_logic;
          R : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of IntAdder_34_f250_uid73226 is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   --Classical
    R <= X + Y + Cin;
end architecture;

--------------------------------------------------------------------------------
--                            FPAdd_8_23_uid73211
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 3 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPAdd_8_23_uid73211 is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(8+23+2 downto 0);
          Y : in std_logic_vector(8+23+2 downto 0);
          R : out std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of FPAdd_8_23_uid73211 is
   component FPAdd_8_23_uid73211_RightShifter is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(23 downto 0);
             S : in std_logic_vector(4 downto 0);
             R : out std_logic_vector(49 downto 0)   );
   end component;

   component IntAdder_27_f250_uid73216 is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(26 downto 0);
             Y : in std_logic_vector(26 downto 0);
             Cin : in std_logic;
             R : out std_logic_vector(26 downto 0)   );
   end component;

   component LZCShifter_28_to_28_counting_32_F250_uid73223 is
      port ( clk, rst : in std_logic;
             I : in std_logic_vector(27 downto 0);
             Count : out std_logic_vector(4 downto 0);
             O : out std_logic_vector(27 downto 0)   );
   end component;

   component IntAdder_34_f250_uid73226 is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : in std_logic_vector(33 downto 0);
             Cin : in std_logic;
             R : out std_logic_vector(33 downto 0)   );
   end component;

signal excExpFracX : std_logic_vector(32 downto 0) := (others => '0');
signal excExpFracY : std_logic_vector(32 downto 0) := (others => '0');
signal eXmeY : std_logic_vector(8 downto 0) := (others => '0');
signal eYmeX : std_logic_vector(8 downto 0) := (others => '0');
signal swap : std_logic := '0';
signal newX, newX_d1 : std_logic_vector(33 downto 0) := (others => '0');
signal newY : std_logic_vector(33 downto 0) := (others => '0');
signal expX, expX_d1 : std_logic_vector(7 downto 0) := (others => '0');
signal excX : std_logic_vector(1 downto 0) := (others => '0');
signal excY : std_logic_vector(1 downto 0) := (others => '0');
signal signX : std_logic := '0';
signal signY : std_logic := '0';
signal EffSub, EffSub_d1, EffSub_d2, EffSub_d3 : std_logic := '0';
signal sXsYExnXY : std_logic_vector(5 downto 0) := (others => '0');
signal sdExnXY : std_logic_vector(3 downto 0) := (others => '0');
signal fracY : std_logic_vector(23 downto 0) := (others => '0');
signal excRt, excRt_d1, excRt_d2, excRt_d3 : std_logic_vector(1 downto 0) := (others => '0');
signal signR, signR_d1, signR_d2, signR_d3 : std_logic := '0';
signal expDiff : std_logic_vector(8 downto 0) := (others => '0');
signal shiftedOut : std_logic := '0';
signal shiftVal : std_logic_vector(4 downto 0) := (others => '0');
signal shiftedFracY, shiftedFracY_d1 : std_logic_vector(49 downto 0) := (others => '0');
signal sticky : std_logic := '0';
signal fracYfar : std_logic_vector(26 downto 0) := (others => '0');
signal EffSubVector : std_logic_vector(26 downto 0) := (others => '0');
signal fracYfarXorOp : std_logic_vector(26 downto 0) := (others => '0');
signal fracXfar : std_logic_vector(26 downto 0) := (others => '0');
signal cInAddFar : std_logic := '0';
signal fracAddResult : std_logic_vector(26 downto 0) := (others => '0');
signal fracGRS : std_logic_vector(27 downto 0) := (others => '0');
signal extendedExpInc, extendedExpInc_d1, extendedExpInc_d2 : std_logic_vector(9 downto 0) := (others => '0');
signal nZerosNew, nZerosNew_d1 : std_logic_vector(4 downto 0) := (others => '0');
signal shiftedFrac, shiftedFrac_d1 : std_logic_vector(27 downto 0) := (others => '0');
signal updatedExp : std_logic_vector(9 downto 0) := (others => '0');
signal eqdiffsign : std_logic := '0';
signal expFrac : std_logic_vector(33 downto 0) := (others => '0');
signal stk : std_logic := '0';
signal rnd : std_logic := '0';
signal grd : std_logic := '0';
signal lsb : std_logic := '0';
signal addToRoundBit, addToRoundBit_d1 : std_logic := '0';
signal RoundedExpFrac : std_logic_vector(33 downto 0) := (others => '0');
signal upExc : std_logic_vector(1 downto 0) := (others => '0');
signal fracR : std_logic_vector(22 downto 0) := (others => '0');
signal expR : std_logic_vector(7 downto 0) := (others => '0');
signal exExpExc : std_logic_vector(3 downto 0) := (others => '0');
signal excRt2 : std_logic_vector(1 downto 0) := (others => '0');
signal excR : std_logic_vector(1 downto 0) := (others => '0');
signal signR2 : std_logic := '0';
signal computedR : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            newX_d1 <=  newX;
            expX_d1 <=  expX;
            EffSub_d1 <=  EffSub;
            EffSub_d2 <=  EffSub_d1;
            EffSub_d3 <=  EffSub_d2;
            excRt_d1 <=  excRt;
            excRt_d2 <=  excRt_d1;
            excRt_d3 <=  excRt_d2;
            signR_d1 <=  signR;
            signR_d2 <=  signR_d1;
            signR_d3 <=  signR_d2;
            shiftedFracY_d1 <=  shiftedFracY;
            extendedExpInc_d1 <=  extendedExpInc;
            extendedExpInc_d2 <=  extendedExpInc_d1;
            nZerosNew_d1 <=  nZerosNew;
            shiftedFrac_d1 <=  shiftedFrac;
            addToRoundBit_d1 <=  addToRoundBit;
         end if;
      end process;
-- Exponent difference and swap  --
   excExpFracX <= X(33 downto 32) & X(30 downto 0);
   excExpFracY <= Y(33 downto 32) & Y(30 downto 0);
   eXmeY <= ("0" & X(30 downto 23)) - ("0" & Y(30 downto 23));
   eYmeX <= ("0" & Y(30 downto 23)) - ("0" & X(30 downto 23));
   swap <= '0' when excExpFracX >= excExpFracY else '1';
   newX <= X when swap = '0' else Y;
   newY <= Y when swap = '0' else X;
   expX<= newX(30 downto 23);
   excX<= newX(33 downto 32);
   excY<= newY(33 downto 32);
   signX<= newX(31);
   signY<= newY(31);
   EffSub <= signX xor signY;
   sXsYExnXY <= signX & signY & excX & excY;
   sdExnXY <= excX & excY;
   fracY <= "000000000000000000000000" when excY="00" else ('1' & newY(22 downto 0));
   with sXsYExnXY select 
   excRt <= "00" when "000000"|"010000"|"100000"|"110000",
      "01" when "000101"|"010101"|"100101"|"110101"|"000100"|"010100"|"100100"|"110100"|"000001"|"010001"|"100001"|"110001",
      "10" when "111010"|"001010"|"001000"|"011000"|"101000"|"111000"|"000010"|"010010"|"100010"|"110010"|"001001"|"011001"|"101001"|"111001"|"000110"|"010110"|"100110"|"110110", 
      "11" when others;
   signR<= '0' when (sXsYExnXY="100000" or sXsYExnXY="010000") else signX;
   ---------------- cycle 0----------------
   expDiff <= eXmeY when swap = '0' else eYmeX;
   shiftedOut <= '1' when (expDiff >= 25) else '0';
   shiftVal <= expDiff(4 downto 0) when shiftedOut='0' else CONV_STD_LOGIC_VECTOR(26,5) ;
   RightShifterComponent: FPAdd_8_23_uid73211_RightShifter  -- pipelineDepth=0 maxInDelay=2.25704e-09
      port map ( clk  => clk,
                 rst  => rst,
                 R => shiftedFracY,
                 S => shiftVal,
                 X => fracY);
   ----------------Synchro barrier, entering cycle 1----------------
   sticky <= '0' when (shiftedFracY_d1(23 downto 0)=CONV_STD_LOGIC_VECTOR(0,23)) else '1';
   ---------------- cycle 0----------------
   ----------------Synchro barrier, entering cycle 1----------------
   fracYfar <= "0" & shiftedFracY_d1(49 downto 24);
   EffSubVector <= (26 downto 0 => EffSub_d1);
   fracYfarXorOp <= fracYfar xor EffSubVector;
   fracXfar <= "01" & (newX_d1(22 downto 0)) & "00";
   cInAddFar <= EffSub_d1 and not sticky;
   fracAdder: IntAdder_27_f250_uid73216  -- pipelineDepth=0 maxInDelay=1.02352e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => cInAddFar,
                 R => fracAddResult,
                 X => fracXfar,
                 Y => fracYfarXorOp);
   fracGRS<= fracAddResult & sticky; 
   extendedExpInc<= ("00" & expX_d1) + '1';
   LZC_component: LZCShifter_28_to_28_counting_32_F250_uid73223  -- pipelineDepth=1 maxInDelay=1.86552e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Count => nZerosNew,
                 I => fracGRS,
                 O => shiftedFrac);
   ----------------Synchro barrier, entering cycle 2----------------
   ----------------Synchro barrier, entering cycle 3----------------
   updatedExp <= extendedExpInc_d2 - ("00000" & nZerosNew_d1);
   eqdiffsign <= '1' when nZerosNew_d1="11111" else '0';
   expFrac<= updatedExp & shiftedFrac_d1(26 downto 3);
   ---------------- cycle 2----------------
   stk<= shiftedFrac(1) or shiftedFrac(0);
   rnd<= shiftedFrac(2);
   grd<= shiftedFrac(3);
   lsb<= shiftedFrac(4);
   addToRoundBit<= '0' when (lsb='0' and grd='1' and rnd='0' and stk='0')  else '1';
   ----------------Synchro barrier, entering cycle 3----------------
   roundingAdder: IntAdder_34_f250_uid73226  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => addToRoundBit_d1,
                 R => RoundedExpFrac,
                 X => expFrac,
                 Y => "0000000000000000000000000000000000");
   ---------------- cycle 3----------------
   upExc <= RoundedExpFrac(33 downto 32);
   fracR <= RoundedExpFrac(23 downto 1);
   expR <= RoundedExpFrac(31 downto 24);
   exExpExc <= upExc & excRt_d3;
   with (exExpExc) select 
   excRt2<= "00" when "0000"|"0100"|"1000"|"1100"|"1001"|"1101",
      "01" when "0001",
      "10" when "0010"|"0110"|"1010"|"1110"|"0101",
      "11" when others;
   excR <= "00" when (eqdiffsign='1' and EffSub_d3='1') else excRt2;
   signR2 <= '0' when (eqdiffsign='1' and EffSub_d3='1') else signR_d3;
   computedR <= excR & signR2 & expR & fracR;
   R <= computedR;
end architecture;

--------------------------------------------------------------------------------
--         FPGenericAddSub_wE_8_wF_23_subX_false_subY_false_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 3 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity FPGenericAddSub_wE_8_wF_23_subX_false_subY_false_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(8+23+2 downto 0);
          Y : in std_logic_vector(8+23+2 downto 0);
          R : out std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of FPGenericAddSub_wE_8_wF_23_subX_false_subY_false_component is
   component FPAdd_8_23_uid73211 is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(8+23+2 downto 0);
             Y : in std_logic_vector(8+23+2 downto 0);
             R : out std_logic_vector(8+23+2 downto 0)   );
   end component;

signal X_out : std_logic_vector(33 downto 0) := (others => '0');
signal Y_out : std_logic_vector(33 downto 0) := (others => '0');
signal R_temp : std_logic_vector(8+23+2 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
X_out <= X;
Y_out <= Y;
   FPAddSubOp_instance: FPAdd_8_23_uid73211  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => R_temp,
                 X => X_out,
                 Y => Y_out);
   ----------------Synchro barrier, entering cycle 3----------------
R <= R_temp;
end architecture;

--------------------------------------------------------------------------------
--             Mux_sign_1_wordsize_34_numberOfInputs_9_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Mux_sign_1_wordsize_34_numberOfInputs_9_component is
   port ( clk, rst : in std_logic;
          iS_0 : in std_logic_vector(33 downto 0);
          iS_1 : in std_logic_vector(33 downto 0);
          iS_2 : in std_logic_vector(33 downto 0);
          iS_3 : in std_logic_vector(33 downto 0);
          iS_4 : in std_logic_vector(33 downto 0);
          iS_5 : in std_logic_vector(33 downto 0);
          iS_6 : in std_logic_vector(33 downto 0);
          iS_7 : in std_logic_vector(33 downto 0);
          iS_8 : in std_logic_vector(33 downto 0);
          iSel : in std_logic_vector(3 downto 0);
          oMux : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Mux_sign_1_wordsize_34_numberOfInputs_9_component is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   with iSel select
      oMux <= 
         iS_0 when "0000",
         iS_1 when "0001",
         iS_2 when "0010",
         iS_3 when "0011",
         iS_4 when "0100",
         iS_5 when "0101",
         iS_6 when "0110",
         iS_7 when "0111",
         iS_8 when "1000",
(others=>'X') when others;
end architecture;

--------------------------------------------------------------------------------
--             Mux_sign_1_wordsize_34_numberOfInputs_8_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Mux_sign_1_wordsize_34_numberOfInputs_8_component is
   port ( clk, rst : in std_logic;
          iS_0 : in std_logic_vector(33 downto 0);
          iS_1 : in std_logic_vector(33 downto 0);
          iS_2 : in std_logic_vector(33 downto 0);
          iS_3 : in std_logic_vector(33 downto 0);
          iS_4 : in std_logic_vector(33 downto 0);
          iS_5 : in std_logic_vector(33 downto 0);
          iS_6 : in std_logic_vector(33 downto 0);
          iS_7 : in std_logic_vector(33 downto 0);
          iSel : in std_logic_vector(2 downto 0);
          oMux : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Mux_sign_1_wordsize_34_numberOfInputs_8_component is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   with iSel select
      oMux <= 
         iS_0 when "000",
         iS_1 when "001",
         iS_2 when "010",
         iS_3 when "011",
         iS_4 when "100",
         iS_5 when "101",
         iS_6 when "110",
         iS_7 when "111",
(others=>'X') when others;
end architecture;

--------------------------------------------------------------------------------
--                      FPAdd_8_23_uid73453_RightShifter
--                 (RightShifter_24_by_max_26_F250_uid73455)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2011)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPAdd_8_23_uid73453_RightShifter is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(23 downto 0);
          S : in std_logic_vector(4 downto 0);
          R : out std_logic_vector(49 downto 0)   );
end entity;

architecture arch of FPAdd_8_23_uid73453_RightShifter is
signal level0 : std_logic_vector(23 downto 0) := (others => '0');
signal ps : std_logic_vector(4 downto 0) := (others => '0');
signal level1 : std_logic_vector(24 downto 0) := (others => '0');
signal level2 : std_logic_vector(26 downto 0) := (others => '0');
signal level3 : std_logic_vector(30 downto 0) := (others => '0');
signal level4 : std_logic_vector(38 downto 0) := (others => '0');
signal level5 : std_logic_vector(54 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   level0<= X;
   ps<= S;
   level1<=  (0 downto 0 => '0') & level0 when ps(0) = '1' else    level0 & (0 downto 0 => '0');
   level2<=  (1 downto 0 => '0') & level1 when ps(1) = '1' else    level1 & (1 downto 0 => '0');
   level3<=  (3 downto 0 => '0') & level2 when ps(2) = '1' else    level2 & (3 downto 0 => '0');
   level4<=  (7 downto 0 => '0') & level3 when ps(3) = '1' else    level3 & (7 downto 0 => '0');
   level5<=  (15 downto 0 => '0') & level4 when ps(4) = '1' else    level4 & (15 downto 0 => '0');
   R <= level5(54 downto 5);
end architecture;

--------------------------------------------------------------------------------
--                         IntAdder_27_f250_uid73458
--                   (IntAdderAlternative_27_f250_uid73462)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_27_f250_uid73458 is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(26 downto 0);
          Y : in std_logic_vector(26 downto 0);
          Cin : in std_logic;
          R : out std_logic_vector(26 downto 0)   );
end entity;

architecture arch of IntAdder_27_f250_uid73458 is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   --Alternative
    R <= X + Y + Cin;
end architecture;

--------------------------------------------------------------------------------
--               LZCShifter_28_to_28_counting_32_F250_uid73465
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Bogdan Pasca (2007)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity LZCShifter_28_to_28_counting_32_F250_uid73465 is
   port ( clk, rst : in std_logic;
          I : in std_logic_vector(27 downto 0);
          Count : out std_logic_vector(4 downto 0);
          O : out std_logic_vector(27 downto 0)   );
end entity;

architecture arch of LZCShifter_28_to_28_counting_32_F250_uid73465 is
signal level5 : std_logic_vector(27 downto 0) := (others => '0');
signal count4, count4_d1 : std_logic := '0';
signal level4, level4_d1 : std_logic_vector(27 downto 0) := (others => '0');
signal count3, count3_d1 : std_logic := '0';
signal level3 : std_logic_vector(27 downto 0) := (others => '0');
signal count2 : std_logic := '0';
signal level2 : std_logic_vector(27 downto 0) := (others => '0');
signal count1 : std_logic := '0';
signal level1 : std_logic_vector(27 downto 0) := (others => '0');
signal count0 : std_logic := '0';
signal level0 : std_logic_vector(27 downto 0) := (others => '0');
signal sCount : std_logic_vector(4 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            count4_d1 <=  count4;
            level4_d1 <=  level4;
            count3_d1 <=  count3;
         end if;
      end process;
   level5 <= I ;
   count4<= '1' when level5(27 downto 12) = (27 downto 12=>'0') else '0';
   level4<= level5(27 downto 0) when count4='0' else level5(11 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(27 downto 20) = (27 downto 20=>'0') else '0';
   ----------------Synchro barrier, entering cycle 1----------------
   level3<= level4_d1(27 downto 0) when count3_d1='0' else level4_d1(19 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(27 downto 24) = (27 downto 24=>'0') else '0';
   level2<= level3(27 downto 0) when count2='0' else level3(23 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(27 downto 26) = (27 downto 26=>'0') else '0';
   level1<= level2(27 downto 0) when count1='0' else level2(25 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(27 downto 27) = (27 downto 27=>'0') else '0';
   level0<= level1(27 downto 0) when count0='0' else level1(26 downto 0) & (0 downto 0 => '0');

   O <= level0;
   sCount <= count4_d1 & count3_d1 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                         IntAdder_34_f250_uid73468
--                    (IntAdderClassical_34_f250_uid73470)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_34_f250_uid73468 is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : in std_logic_vector(33 downto 0);
          Cin : in std_logic;
          R : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of IntAdder_34_f250_uid73468 is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   --Classical
    R <= X + Y + Cin;
end architecture;

--------------------------------------------------------------------------------
--                            FPAdd_8_23_uid73453
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 3 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPAdd_8_23_uid73453 is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(8+23+2 downto 0);
          Y : in std_logic_vector(8+23+2 downto 0);
          R : out std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of FPAdd_8_23_uid73453 is
   component FPAdd_8_23_uid73453_RightShifter is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(23 downto 0);
             S : in std_logic_vector(4 downto 0);
             R : out std_logic_vector(49 downto 0)   );
   end component;

   component IntAdder_27_f250_uid73458 is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(26 downto 0);
             Y : in std_logic_vector(26 downto 0);
             Cin : in std_logic;
             R : out std_logic_vector(26 downto 0)   );
   end component;

   component LZCShifter_28_to_28_counting_32_F250_uid73465 is
      port ( clk, rst : in std_logic;
             I : in std_logic_vector(27 downto 0);
             Count : out std_logic_vector(4 downto 0);
             O : out std_logic_vector(27 downto 0)   );
   end component;

   component IntAdder_34_f250_uid73468 is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : in std_logic_vector(33 downto 0);
             Cin : in std_logic;
             R : out std_logic_vector(33 downto 0)   );
   end component;

signal excExpFracX : std_logic_vector(32 downto 0) := (others => '0');
signal excExpFracY : std_logic_vector(32 downto 0) := (others => '0');
signal eXmeY : std_logic_vector(8 downto 0) := (others => '0');
signal eYmeX : std_logic_vector(8 downto 0) := (others => '0');
signal swap : std_logic := '0';
signal newX, newX_d1 : std_logic_vector(33 downto 0) := (others => '0');
signal newY : std_logic_vector(33 downto 0) := (others => '0');
signal expX, expX_d1 : std_logic_vector(7 downto 0) := (others => '0');
signal excX : std_logic_vector(1 downto 0) := (others => '0');
signal excY : std_logic_vector(1 downto 0) := (others => '0');
signal signX : std_logic := '0';
signal signY : std_logic := '0';
signal EffSub, EffSub_d1, EffSub_d2, EffSub_d3 : std_logic := '0';
signal sXsYExnXY : std_logic_vector(5 downto 0) := (others => '0');
signal sdExnXY : std_logic_vector(3 downto 0) := (others => '0');
signal fracY : std_logic_vector(23 downto 0) := (others => '0');
signal excRt, excRt_d1, excRt_d2, excRt_d3 : std_logic_vector(1 downto 0) := (others => '0');
signal signR, signR_d1, signR_d2, signR_d3 : std_logic := '0';
signal expDiff : std_logic_vector(8 downto 0) := (others => '0');
signal shiftedOut : std_logic := '0';
signal shiftVal : std_logic_vector(4 downto 0) := (others => '0');
signal shiftedFracY, shiftedFracY_d1 : std_logic_vector(49 downto 0) := (others => '0');
signal sticky : std_logic := '0';
signal fracYfar : std_logic_vector(26 downto 0) := (others => '0');
signal EffSubVector : std_logic_vector(26 downto 0) := (others => '0');
signal fracYfarXorOp : std_logic_vector(26 downto 0) := (others => '0');
signal fracXfar : std_logic_vector(26 downto 0) := (others => '0');
signal cInAddFar : std_logic := '0';
signal fracAddResult : std_logic_vector(26 downto 0) := (others => '0');
signal fracGRS : std_logic_vector(27 downto 0) := (others => '0');
signal extendedExpInc, extendedExpInc_d1, extendedExpInc_d2 : std_logic_vector(9 downto 0) := (others => '0');
signal nZerosNew, nZerosNew_d1 : std_logic_vector(4 downto 0) := (others => '0');
signal shiftedFrac, shiftedFrac_d1 : std_logic_vector(27 downto 0) := (others => '0');
signal updatedExp : std_logic_vector(9 downto 0) := (others => '0');
signal eqdiffsign : std_logic := '0';
signal expFrac : std_logic_vector(33 downto 0) := (others => '0');
signal stk : std_logic := '0';
signal rnd : std_logic := '0';
signal grd : std_logic := '0';
signal lsb : std_logic := '0';
signal addToRoundBit, addToRoundBit_d1 : std_logic := '0';
signal RoundedExpFrac : std_logic_vector(33 downto 0) := (others => '0');
signal upExc : std_logic_vector(1 downto 0) := (others => '0');
signal fracR : std_logic_vector(22 downto 0) := (others => '0');
signal expR : std_logic_vector(7 downto 0) := (others => '0');
signal exExpExc : std_logic_vector(3 downto 0) := (others => '0');
signal excRt2 : std_logic_vector(1 downto 0) := (others => '0');
signal excR : std_logic_vector(1 downto 0) := (others => '0');
signal signR2 : std_logic := '0';
signal computedR : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            newX_d1 <=  newX;
            expX_d1 <=  expX;
            EffSub_d1 <=  EffSub;
            EffSub_d2 <=  EffSub_d1;
            EffSub_d3 <=  EffSub_d2;
            excRt_d1 <=  excRt;
            excRt_d2 <=  excRt_d1;
            excRt_d3 <=  excRt_d2;
            signR_d1 <=  signR;
            signR_d2 <=  signR_d1;
            signR_d3 <=  signR_d2;
            shiftedFracY_d1 <=  shiftedFracY;
            extendedExpInc_d1 <=  extendedExpInc;
            extendedExpInc_d2 <=  extendedExpInc_d1;
            nZerosNew_d1 <=  nZerosNew;
            shiftedFrac_d1 <=  shiftedFrac;
            addToRoundBit_d1 <=  addToRoundBit;
         end if;
      end process;
-- Exponent difference and swap  --
   excExpFracX <= X(33 downto 32) & X(30 downto 0);
   excExpFracY <= Y(33 downto 32) & Y(30 downto 0);
   eXmeY <= ("0" & X(30 downto 23)) - ("0" & Y(30 downto 23));
   eYmeX <= ("0" & Y(30 downto 23)) - ("0" & X(30 downto 23));
   swap <= '0' when excExpFracX >= excExpFracY else '1';
   newX <= X when swap = '0' else Y;
   newY <= Y when swap = '0' else X;
   expX<= newX(30 downto 23);
   excX<= newX(33 downto 32);
   excY<= newY(33 downto 32);
   signX<= newX(31);
   signY<= newY(31);
   EffSub <= signX xor signY;
   sXsYExnXY <= signX & signY & excX & excY;
   sdExnXY <= excX & excY;
   fracY <= "000000000000000000000000" when excY="00" else ('1' & newY(22 downto 0));
   with sXsYExnXY select 
   excRt <= "00" when "000000"|"010000"|"100000"|"110000",
      "01" when "000101"|"010101"|"100101"|"110101"|"000100"|"010100"|"100100"|"110100"|"000001"|"010001"|"100001"|"110001",
      "10" when "111010"|"001010"|"001000"|"011000"|"101000"|"111000"|"000010"|"010010"|"100010"|"110010"|"001001"|"011001"|"101001"|"111001"|"000110"|"010110"|"100110"|"110110", 
      "11" when others;
   signR<= '0' when (sXsYExnXY="100000" or sXsYExnXY="010000") else signX;
   ---------------- cycle 0----------------
   expDiff <= eXmeY when swap = '0' else eYmeX;
   shiftedOut <= '1' when (expDiff >= 25) else '0';
   shiftVal <= expDiff(4 downto 0) when shiftedOut='0' else CONV_STD_LOGIC_VECTOR(26,5) ;
   RightShifterComponent: FPAdd_8_23_uid73453_RightShifter  -- pipelineDepth=0 maxInDelay=2.25704e-09
      port map ( clk  => clk,
                 rst  => rst,
                 R => shiftedFracY,
                 S => shiftVal,
                 X => fracY);
   ----------------Synchro barrier, entering cycle 1----------------
   sticky <= '0' when (shiftedFracY_d1(23 downto 0)=CONV_STD_LOGIC_VECTOR(0,23)) else '1';
   ---------------- cycle 0----------------
   ----------------Synchro barrier, entering cycle 1----------------
   fracYfar <= "0" & shiftedFracY_d1(49 downto 24);
   EffSubVector <= (26 downto 0 => EffSub_d1);
   fracYfarXorOp <= fracYfar xor EffSubVector;
   fracXfar <= "01" & (newX_d1(22 downto 0)) & "00";
   cInAddFar <= EffSub_d1 and not sticky;
   fracAdder: IntAdder_27_f250_uid73458  -- pipelineDepth=0 maxInDelay=1.02352e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => cInAddFar,
                 R => fracAddResult,
                 X => fracXfar,
                 Y => fracYfarXorOp);
   fracGRS<= fracAddResult & sticky; 
   extendedExpInc<= ("00" & expX_d1) + '1';
   LZC_component: LZCShifter_28_to_28_counting_32_F250_uid73465  -- pipelineDepth=1 maxInDelay=1.86552e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Count => nZerosNew,
                 I => fracGRS,
                 O => shiftedFrac);
   ----------------Synchro barrier, entering cycle 2----------------
   ----------------Synchro barrier, entering cycle 3----------------
   updatedExp <= extendedExpInc_d2 - ("00000" & nZerosNew_d1);
   eqdiffsign <= '1' when nZerosNew_d1="11111" else '0';
   expFrac<= updatedExp & shiftedFrac_d1(26 downto 3);
   ---------------- cycle 2----------------
   stk<= shiftedFrac(1) or shiftedFrac(0);
   rnd<= shiftedFrac(2);
   grd<= shiftedFrac(3);
   lsb<= shiftedFrac(4);
   addToRoundBit<= '0' when (lsb='0' and grd='1' and rnd='0' and stk='0')  else '1';
   ----------------Synchro barrier, entering cycle 3----------------
   roundingAdder: IntAdder_34_f250_uid73468  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => addToRoundBit_d1,
                 R => RoundedExpFrac,
                 X => expFrac,
                 Y => "0000000000000000000000000000000000");
   ---------------- cycle 3----------------
   upExc <= RoundedExpFrac(33 downto 32);
   fracR <= RoundedExpFrac(23 downto 1);
   expR <= RoundedExpFrac(31 downto 24);
   exExpExc <= upExc & excRt_d3;
   with (exExpExc) select 
   excRt2<= "00" when "0000"|"0100"|"1000"|"1100"|"1001"|"1101",
      "01" when "0001",
      "10" when "0010"|"0110"|"1010"|"1110"|"0101",
      "11" when others;
   excR <= "00" when (eqdiffsign='1' and EffSub_d3='1') else excRt2;
   signR2 <= '0' when (eqdiffsign='1' and EffSub_d3='1') else signR_d3;
   computedR <= excR & signR2 & expR & fracR;
   R <= computedR;
end architecture;

--------------------------------------------------------------------------------
--         FPGenericAddSub_wE_8_wF_23_subX_false_subY_true_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 3 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity FPGenericAddSub_wE_8_wF_23_subX_false_subY_true_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(8+23+2 downto 0);
          Y : in std_logic_vector(8+23+2 downto 0);
          R : out std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of FPGenericAddSub_wE_8_wF_23_subX_false_subY_true_component is
   component FPAdd_8_23_uid73453 is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(8+23+2 downto 0);
             Y : in std_logic_vector(8+23+2 downto 0);
             R : out std_logic_vector(8+23+2 downto 0)   );
   end component;

signal X_out : std_logic_vector(33 downto 0) := (others => '0');
signal Y_out : std_logic_vector(33 downto 0) := (others => '0');
signal R_temp : std_logic_vector(8+23+2 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
X_out <= X;
Y_out <= (Y(Y'length-1 downto Y'length-2)) & (not Y(Y'length-3)) & Y(Y'length-4 downto 0);
   FPAddSubOp_instance: FPAdd_8_23_uid73453  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => R_temp,
                 X => X_out,
                 Y => Y_out);
   ----------------Synchro barrier, entering cycle 3----------------
R <= R_temp;
end architecture;

--------------------------------------------------------------------------------
--             Mux_sign_1_wordsize_34_numberOfInputs_4_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Mux_sign_1_wordsize_34_numberOfInputs_4_component is
   port ( clk, rst : in std_logic;
          iS_0 : in std_logic_vector(33 downto 0);
          iS_1 : in std_logic_vector(33 downto 0);
          iS_2 : in std_logic_vector(33 downto 0);
          iS_3 : in std_logic_vector(33 downto 0);
          iSel : in std_logic_vector(1 downto 0);
          oMux : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Mux_sign_1_wordsize_34_numberOfInputs_4_component is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   with iSel select
      oMux <= 
         iS_0 when "00",
         iS_1 when "01",
         iS_2 when "10",
         iS_3 when "11",
(others=>'X') when others;
end architecture;

--------------------------------------------------------------------------------
--             Mux_sign_1_wordsize_34_numberOfInputs_7_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Mux_sign_1_wordsize_34_numberOfInputs_7_component is
   port ( clk, rst : in std_logic;
          iS_0 : in std_logic_vector(33 downto 0);
          iS_1 : in std_logic_vector(33 downto 0);
          iS_2 : in std_logic_vector(33 downto 0);
          iS_3 : in std_logic_vector(33 downto 0);
          iS_4 : in std_logic_vector(33 downto 0);
          iS_5 : in std_logic_vector(33 downto 0);
          iS_6 : in std_logic_vector(33 downto 0);
          iSel : in std_logic_vector(2 downto 0);
          oMux : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Mux_sign_1_wordsize_34_numberOfInputs_7_component is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   with iSel select
      oMux <= 
         iS_0 when "000",
         iS_1 when "001",
         iS_2 when "010",
         iS_3 when "011",
         iS_4 when "100",
         iS_5 when "101",
         iS_6 when "110",
(others=>'X') when others;
end architecture;

--------------------------------------------------------------------------------
--                      Constant_float_8_23_1_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Patrick Sittel
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Constant_float_8_23_1_component is
   port ( clk, rst : in std_logic;
          Y : out std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of Constant_float_8_23_1_component is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
---------------------  addFullComment for a large comment  ---------------------
   -- addComment for small left-aligned comment
    Y <= "0100111111100000000000000000000000";
end architecture;

--------------------------------------------------------------------------------
--                            SelFunctionTable_r8
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Maxime Christ, Florent de Dinechin (2015)
--------------------------------------------------------------------------------
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
entity SelFunctionTable_r8 is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(6 downto 0);
          Y : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of SelFunctionTable_r8 is
begin
  with X select  Y <= 
   "0000" when "0000000",
   "0000" when "0000001",
   "0000" when "0000010",
   "0000" when "0000011",
   "0001" when "0000100",
   "0001" when "0000101",
   "0001" when "0000110",
   "0001" when "0000111",
   "0001" when "0001000",
   "0001" when "0001001",
   "0001" when "0001010",
   "0001" when "0001011",
   "0010" when "0001100",
   "0010" when "0001101",
   "0010" when "0001110",
   "0010" when "0001111",
   "0011" when "0010000",
   "0011" when "0010001",
   "0010" when "0010010",
   "0010" when "0010011",
   "0011" when "0010100",
   "0011" when "0010101",
   "0011" when "0010110",
   "0011" when "0010111",
   "0100" when "0011000",
   "0100" when "0011001",
   "0011" when "0011010",
   "0011" when "0011011",
   "0101" when "0011100",
   "0100" when "0011101",
   "0100" when "0011110",
   "0100" when "0011111",
   "0101" when "0100000",
   "0101" when "0100001",
   "0101" when "0100010",
   "0100" when "0100011",
   "0110" when "0100100",
   "0110" when "0100101",
   "0101" when "0100110",
   "0101" when "0100111",
   "0111" when "0101000",
   "0110" when "0101001",
   "0110" when "0101010",
   "0101" when "0101011",
   "0111" when "0101100",
   "0111" when "0101101",
   "0110" when "0101110",
   "0110" when "0101111",
   "0111" when "0110000",
   "0111" when "0110001",
   "0111" when "0110010",
   "0110" when "0110011",
   "0111" when "0110100",
   "0111" when "0110101",
   "0111" when "0110110",
   "0111" when "0110111",
   "0111" when "0111000",
   "0111" when "0111001",
   "0111" when "0111010",
   "0111" when "0111011",
   "0111" when "0111100",
   "0111" when "0111101",
   "0111" when "0111110",
   "0111" when "0111111",
   "1001" when "1000000",
   "1001" when "1000001",
   "1001" when "1000010",
   "1001" when "1000011",
   "1001" when "1000100",
   "1001" when "1000101",
   "1001" when "1000110",
   "1001" when "1000111",
   "1001" when "1001000",
   "1001" when "1001001",
   "1001" when "1001010",
   "1001" when "1001011",
   "1001" when "1001100",
   "1001" when "1001101",
   "1001" when "1001110",
   "1001" when "1001111",
   "1001" when "1010000",
   "1001" when "1010001",
   "1010" when "1010010",
   "1010" when "1010011",
   "1001" when "1010100",
   "1010" when "1010101",
   "1010" when "1010110",
   "1010" when "1010111",
   "1010" when "1011000",
   "1010" when "1011001",
   "1011" when "1011010",
   "1011" when "1011011",
   "1011" when "1011100",
   "1011" when "1011101",
   "1011" when "1011110",
   "1011" when "1011111",
   "1011" when "1100000",
   "1011" when "1100001",
   "1100" when "1100010",
   "1100" when "1100011",
   "1100" when "1100100",
   "1100" when "1100101",
   "1100" when "1100110",
   "1100" when "1100111",
   "1100" when "1101000",
   "1101" when "1101001",
   "1101" when "1101010",
   "1101" when "1101011",
   "1101" when "1101100",
   "1101" when "1101101",
   "1101" when "1101110",
   "1101" when "1101111",
   "1110" when "1110000",
   "1110" when "1110001",
   "1110" when "1110010",
   "1110" when "1110011",
   "1110" when "1110100",
   "1110" when "1110101",
   "1110" when "1110110",
   "1110" when "1110111",
   "1111" when "1111000",
   "1111" when "1111001",
   "1111" when "1111010",
   "1111" when "1111011",
   "1111" when "1111100",
   "1111" when "1111101",
   "1111" when "1111110",
   "1111" when "1111111",
   "----" when others;
end architecture;

--------------------------------------------------------------------------------
--         FPMultiplier_in_8_23_8_23_out_8_23_mult_X_div_Y_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Maxime Christ, Florent de Dinechin (2015)
--------------------------------------------------------------------------------
-- Pipeline depth: 12 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPMultiplier_in_8_23_8_23_out_8_23_mult_X_div_Y_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(8+23+2 downto 0);
          Y : in std_logic_vector(8+23+2 downto 0);
          R : out std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of FPMultiplier_in_8_23_8_23_out_8_23_mult_X_div_Y_component is
   component SelFunctionTable_r8 is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(6 downto 0);
             Y : out std_logic_vector(3 downto 0)   );
   end component;

signal partialFX : std_logic_vector(23 downto 0) := (others => '0');
signal partialFY : std_logic_vector(23 downto 0) := (others => '0');
signal expR0, expR0_d1, expR0_d2, expR0_d3, expR0_d4, expR0_d5, expR0_d6, expR0_d7, expR0_d8, expR0_d9, expR0_d10, expR0_d11 : std_logic_vector(9 downto 0) := (others => '0');
signal sR, sR_d1, sR_d2, sR_d3, sR_d4, sR_d5, sR_d6, sR_d7, sR_d8, sR_d9, sR_d10, sR_d11, sR_d12 : std_logic := '0';
signal exnXY : std_logic_vector(3 downto 0) := (others => '0');
signal exnR0, exnR0_d1, exnR0_d2, exnR0_d3, exnR0_d4, exnR0_d5, exnR0_d6, exnR0_d7, exnR0_d8, exnR0_d9, exnR0_d10, exnR0_d11, exnR0_d12 : std_logic_vector(1 downto 0) := (others => '0');
signal fY, fY_d1, fY_d2, fY_d3, fY_d4, fY_d5, fY_d6, fY_d7, fY_d8, fY_d9 : std_logic_vector(25 downto 0) := (others => '0');
signal fX : std_logic_vector(26 downto 0) := (others => '0');
signal w9, w9_d1 : std_logic_vector(28 downto 0) := (others => '0');
signal sel9 : std_logic_vector(6 downto 0) := (others => '0');
signal q9, q9_d1, q9_d2, q9_d3, q9_d4, q9_d5, q9_d6, q9_d7, q9_d8, q9_d9 : std_logic_vector(3 downto 0) := (others => '0');
signal w9pad : std_logic_vector(29 downto 0) := (others => '0');
signal w8fulla : std_logic_vector(29 downto 0) := (others => '0');
signal fYdec8 : std_logic_vector(29 downto 0) := (others => '0');
signal w8full : std_logic_vector(29 downto 0) := (others => '0');
signal w8, w8_d1 : std_logic_vector(28 downto 0) := (others => '0');
signal sel8 : std_logic_vector(6 downto 0) := (others => '0');
signal q8, q8_d1, q8_d2, q8_d3, q8_d4, q8_d5, q8_d6, q8_d7, q8_d8 : std_logic_vector(3 downto 0) := (others => '0');
signal w8pad : std_logic_vector(29 downto 0) := (others => '0');
signal w7fulla : std_logic_vector(29 downto 0) := (others => '0');
signal fYdec7 : std_logic_vector(29 downto 0) := (others => '0');
signal w7full : std_logic_vector(29 downto 0) := (others => '0');
signal w7, w7_d1 : std_logic_vector(28 downto 0) := (others => '0');
signal sel7 : std_logic_vector(6 downto 0) := (others => '0');
signal q7, q7_d1, q7_d2, q7_d3, q7_d4, q7_d5, q7_d6, q7_d7 : std_logic_vector(3 downto 0) := (others => '0');
signal w7pad : std_logic_vector(29 downto 0) := (others => '0');
signal w6fulla : std_logic_vector(29 downto 0) := (others => '0');
signal fYdec6 : std_logic_vector(29 downto 0) := (others => '0');
signal w6full : std_logic_vector(29 downto 0) := (others => '0');
signal w6, w6_d1 : std_logic_vector(28 downto 0) := (others => '0');
signal sel6 : std_logic_vector(6 downto 0) := (others => '0');
signal q6, q6_d1, q6_d2, q6_d3, q6_d4, q6_d5, q6_d6 : std_logic_vector(3 downto 0) := (others => '0');
signal w6pad : std_logic_vector(29 downto 0) := (others => '0');
signal w5fulla : std_logic_vector(29 downto 0) := (others => '0');
signal fYdec5 : std_logic_vector(29 downto 0) := (others => '0');
signal w5full : std_logic_vector(29 downto 0) := (others => '0');
signal w5, w5_d1 : std_logic_vector(28 downto 0) := (others => '0');
signal sel5 : std_logic_vector(6 downto 0) := (others => '0');
signal q5, q5_d1, q5_d2, q5_d3, q5_d4, q5_d5 : std_logic_vector(3 downto 0) := (others => '0');
signal w5pad : std_logic_vector(29 downto 0) := (others => '0');
signal w4fulla : std_logic_vector(29 downto 0) := (others => '0');
signal fYdec4 : std_logic_vector(29 downto 0) := (others => '0');
signal w4full : std_logic_vector(29 downto 0) := (others => '0');
signal w4, w4_d1 : std_logic_vector(28 downto 0) := (others => '0');
signal sel4 : std_logic_vector(6 downto 0) := (others => '0');
signal q4, q4_d1, q4_d2, q4_d3, q4_d4 : std_logic_vector(3 downto 0) := (others => '0');
signal w4pad : std_logic_vector(29 downto 0) := (others => '0');
signal w3fulla : std_logic_vector(29 downto 0) := (others => '0');
signal fYdec3 : std_logic_vector(29 downto 0) := (others => '0');
signal w3full : std_logic_vector(29 downto 0) := (others => '0');
signal w3, w3_d1 : std_logic_vector(28 downto 0) := (others => '0');
signal sel3 : std_logic_vector(6 downto 0) := (others => '0');
signal q3, q3_d1, q3_d2, q3_d3 : std_logic_vector(3 downto 0) := (others => '0');
signal w3pad : std_logic_vector(29 downto 0) := (others => '0');
signal w2fulla : std_logic_vector(29 downto 0) := (others => '0');
signal fYdec2 : std_logic_vector(29 downto 0) := (others => '0');
signal w2full : std_logic_vector(29 downto 0) := (others => '0');
signal w2, w2_d1 : std_logic_vector(28 downto 0) := (others => '0');
signal sel2 : std_logic_vector(6 downto 0) := (others => '0');
signal q2, q2_d1, q2_d2 : std_logic_vector(3 downto 0) := (others => '0');
signal w2pad : std_logic_vector(29 downto 0) := (others => '0');
signal w1fulla : std_logic_vector(29 downto 0) := (others => '0');
signal fYdec1 : std_logic_vector(29 downto 0) := (others => '0');
signal w1full : std_logic_vector(29 downto 0) := (others => '0');
signal w1, w1_d1 : std_logic_vector(28 downto 0) := (others => '0');
signal sel1 : std_logic_vector(6 downto 0) := (others => '0');
signal q1, q1_d1 : std_logic_vector(3 downto 0) := (others => '0');
signal w1pad : std_logic_vector(29 downto 0) := (others => '0');
signal w0fulla : std_logic_vector(29 downto 0) := (others => '0');
signal fYdec0 : std_logic_vector(29 downto 0) := (others => '0');
signal w0full : std_logic_vector(29 downto 0) := (others => '0');
signal w0, w0_d1 : std_logic_vector(28 downto 0) := (others => '0');
signal q0 : std_logic_vector(3 downto 0) := (others => '0');
signal qP9 : std_logic_vector(2 downto 0) := (others => '0');
signal qM9 : std_logic_vector(2 downto 0) := (others => '0');
signal qP8 : std_logic_vector(2 downto 0) := (others => '0');
signal qM8 : std_logic_vector(2 downto 0) := (others => '0');
signal qP7 : std_logic_vector(2 downto 0) := (others => '0');
signal qM7 : std_logic_vector(2 downto 0) := (others => '0');
signal qP6 : std_logic_vector(2 downto 0) := (others => '0');
signal qM6 : std_logic_vector(2 downto 0) := (others => '0');
signal qP5 : std_logic_vector(2 downto 0) := (others => '0');
signal qM5 : std_logic_vector(2 downto 0) := (others => '0');
signal qP4 : std_logic_vector(2 downto 0) := (others => '0');
signal qM4 : std_logic_vector(2 downto 0) := (others => '0');
signal qP3 : std_logic_vector(2 downto 0) := (others => '0');
signal qM3 : std_logic_vector(2 downto 0) := (others => '0');
signal qP2 : std_logic_vector(2 downto 0) := (others => '0');
signal qM2 : std_logic_vector(2 downto 0) := (others => '0');
signal qP1 : std_logic_vector(2 downto 0) := (others => '0');
signal qM1 : std_logic_vector(2 downto 0) := (others => '0');
signal qP0 : std_logic_vector(2 downto 0) := (others => '0');
signal qM0 : std_logic_vector(2 downto 0) := (others => '0');
signal qP : std_logic_vector(29 downto 0) := (others => '0');
signal qM : std_logic_vector(29 downto 0) := (others => '0');
signal fR0, fR0_d1 : std_logic_vector(29 downto 0) := (others => '0');
signal fR : std_logic_vector(28 downto 0) := (others => '0');
signal fRn1, fRn1_d1 : std_logic_vector(26 downto 0) := (others => '0');
signal expR1, expR1_d1 : std_logic_vector(9 downto 0) := (others => '0');
signal round, round_d1 : std_logic := '0';
signal expfrac : std_logic_vector(32 downto 0) := (others => '0');
signal expfracR : std_logic_vector(32 downto 0) := (others => '0');
signal exnR : std_logic_vector(1 downto 0) := (others => '0');
signal exnRfinal : std_logic_vector(1 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            expR0_d1 <=  expR0;
            expR0_d2 <=  expR0_d1;
            expR0_d3 <=  expR0_d2;
            expR0_d4 <=  expR0_d3;
            expR0_d5 <=  expR0_d4;
            expR0_d6 <=  expR0_d5;
            expR0_d7 <=  expR0_d6;
            expR0_d8 <=  expR0_d7;
            expR0_d9 <=  expR0_d8;
            expR0_d10 <=  expR0_d9;
            expR0_d11 <=  expR0_d10;
            sR_d1 <=  sR;
            sR_d2 <=  sR_d1;
            sR_d3 <=  sR_d2;
            sR_d4 <=  sR_d3;
            sR_d5 <=  sR_d4;
            sR_d6 <=  sR_d5;
            sR_d7 <=  sR_d6;
            sR_d8 <=  sR_d7;
            sR_d9 <=  sR_d8;
            sR_d10 <=  sR_d9;
            sR_d11 <=  sR_d10;
            sR_d12 <=  sR_d11;
            exnR0_d1 <=  exnR0;
            exnR0_d2 <=  exnR0_d1;
            exnR0_d3 <=  exnR0_d2;
            exnR0_d4 <=  exnR0_d3;
            exnR0_d5 <=  exnR0_d4;
            exnR0_d6 <=  exnR0_d5;
            exnR0_d7 <=  exnR0_d6;
            exnR0_d8 <=  exnR0_d7;
            exnR0_d9 <=  exnR0_d8;
            exnR0_d10 <=  exnR0_d9;
            exnR0_d11 <=  exnR0_d10;
            exnR0_d12 <=  exnR0_d11;
            fY_d1 <=  fY;
            fY_d2 <=  fY_d1;
            fY_d3 <=  fY_d2;
            fY_d4 <=  fY_d3;
            fY_d5 <=  fY_d4;
            fY_d6 <=  fY_d5;
            fY_d7 <=  fY_d6;
            fY_d8 <=  fY_d7;
            fY_d9 <=  fY_d8;
            w9_d1 <=  w9;
            q9_d1 <=  q9;
            q9_d2 <=  q9_d1;
            q9_d3 <=  q9_d2;
            q9_d4 <=  q9_d3;
            q9_d5 <=  q9_d4;
            q9_d6 <=  q9_d5;
            q9_d7 <=  q9_d6;
            q9_d8 <=  q9_d7;
            q9_d9 <=  q9_d8;
            w8_d1 <=  w8;
            q8_d1 <=  q8;
            q8_d2 <=  q8_d1;
            q8_d3 <=  q8_d2;
            q8_d4 <=  q8_d3;
            q8_d5 <=  q8_d4;
            q8_d6 <=  q8_d5;
            q8_d7 <=  q8_d6;
            q8_d8 <=  q8_d7;
            w7_d1 <=  w7;
            q7_d1 <=  q7;
            q7_d2 <=  q7_d1;
            q7_d3 <=  q7_d2;
            q7_d4 <=  q7_d3;
            q7_d5 <=  q7_d4;
            q7_d6 <=  q7_d5;
            q7_d7 <=  q7_d6;
            w6_d1 <=  w6;
            q6_d1 <=  q6;
            q6_d2 <=  q6_d1;
            q6_d3 <=  q6_d2;
            q6_d4 <=  q6_d3;
            q6_d5 <=  q6_d4;
            q6_d6 <=  q6_d5;
            w5_d1 <=  w5;
            q5_d1 <=  q5;
            q5_d2 <=  q5_d1;
            q5_d3 <=  q5_d2;
            q5_d4 <=  q5_d3;
            q5_d5 <=  q5_d4;
            w4_d1 <=  w4;
            q4_d1 <=  q4;
            q4_d2 <=  q4_d1;
            q4_d3 <=  q4_d2;
            q4_d4 <=  q4_d3;
            w3_d1 <=  w3;
            q3_d1 <=  q3;
            q3_d2 <=  q3_d1;
            q3_d3 <=  q3_d2;
            w2_d1 <=  w2;
            q2_d1 <=  q2;
            q2_d2 <=  q2_d1;
            w1_d1 <=  w1;
            q1_d1 <=  q1;
            w0_d1 <=  w0;
            fR0_d1 <=  fR0;
            fRn1_d1 <=  fRn1;
            expR1_d1 <=  expR1;
            round_d1 <=  round;
         end if;
      end process;
   partialFX <= "1" & X(22 downto 0);
   partialFY <= "1" & Y(22 downto 0);
   -- exponent difference, sign and exception combination computed early, to have less bits to pipeline
   expR0 <= ("00" & X(30 downto 23)) - ("00" & Y(30 downto 23));
   sR <= X(31) xor Y(31);
   -- early exception handling 
   exnXY <= X(33 downto 32) & Y(33 downto 32);
   with exnXY select
      exnR0 <= 
         "01"  when "0101",                   -- normal
         "00"  when "0001" | "0010" | "0110", -- zero
         "10"  when "0100" | "1000" | "1001", -- overflow
         "11"  when others;                   -- NaN
    -- Prescaling
   with partialFY (22 downto 21) select
      fY <= 
         ("0" & partialFY & "0") + (partialFY & "00") when "00",
         ("00" & partialFY) + (partialFY & "00") when "01",
         partialFY &"00" when others;
   with partialFY (22 downto 21) select
      fX <= 
         ("00" & partialFX & "0") + ("0" & partialFX & "00") when "00",
         ("000" & partialFX) + ("0" & partialFX & "00") when "01",
         "0" & partialFX &"00" when others;
   w9 <=  "00" & fX;
   ----------------Synchro barrier, entering cycle 1----------------
   sel9 <= w9_d1(28 downto 24) & fY_d1(23 downto 22);
   SelFunctionTable9: SelFunctionTable_r8  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => sel9,
                 Y => q9);
   w9pad <= w9_d1 & '0';
   with q9(1 downto 0) select 
   w8fulla <= 
      w9pad - ("0000" & fY_d1)			when "01",
      w9pad + ("0000" & fY_d1)			when "11",
      w9pad + ("000" & fY_d1 & "0")	  when "10",
      w9pad 			   		  when others;
   with q9(3 downto 1) select 
   fYdec8 <= 
      ("00" & fY_d1 & "00")			when "001" | "010" | "110"| "101",
      ("0" & fY_d1 & "000")			when "011"| "100",
      (29 downto 0 => '0')when others;
   with q9(3) select
   w8full <= 
      w8fulla - fYdec8			when '0',
      w8fulla + fYdec8			when others;
   w8 <= w8full(26 downto 0) & "00";
   ----------------Synchro barrier, entering cycle 2----------------
   sel8 <= w8_d1(28 downto 24) & fY_d2(23 downto 22);
   SelFunctionTable8: SelFunctionTable_r8  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => sel8,
                 Y => q8);
   w8pad <= w8_d1 & '0';
   with q8(1 downto 0) select 
   w7fulla <= 
      w8pad - ("0000" & fY_d2)			when "01",
      w8pad + ("0000" & fY_d2)			when "11",
      w8pad + ("000" & fY_d2 & "0")	  when "10",
      w8pad 			   		  when others;
   with q8(3 downto 1) select 
   fYdec7 <= 
      ("00" & fY_d2 & "00")			when "001" | "010" | "110"| "101",
      ("0" & fY_d2 & "000")			when "011"| "100",
      (29 downto 0 => '0')when others;
   with q8(3) select
   w7full <= 
      w7fulla - fYdec7			when '0',
      w7fulla + fYdec7			when others;
   w7 <= w7full(26 downto 0) & "00";
   ----------------Synchro barrier, entering cycle 3----------------
   sel7 <= w7_d1(28 downto 24) & fY_d3(23 downto 22);
   SelFunctionTable7: SelFunctionTable_r8  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => sel7,
                 Y => q7);
   w7pad <= w7_d1 & '0';
   with q7(1 downto 0) select 
   w6fulla <= 
      w7pad - ("0000" & fY_d3)			when "01",
      w7pad + ("0000" & fY_d3)			when "11",
      w7pad + ("000" & fY_d3 & "0")	  when "10",
      w7pad 			   		  when others;
   with q7(3 downto 1) select 
   fYdec6 <= 
      ("00" & fY_d3 & "00")			when "001" | "010" | "110"| "101",
      ("0" & fY_d3 & "000")			when "011"| "100",
      (29 downto 0 => '0')when others;
   with q7(3) select
   w6full <= 
      w6fulla - fYdec6			when '0',
      w6fulla + fYdec6			when others;
   w6 <= w6full(26 downto 0) & "00";
   ----------------Synchro barrier, entering cycle 4----------------
   sel6 <= w6_d1(28 downto 24) & fY_d4(23 downto 22);
   SelFunctionTable6: SelFunctionTable_r8  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => sel6,
                 Y => q6);
   w6pad <= w6_d1 & '0';
   with q6(1 downto 0) select 
   w5fulla <= 
      w6pad - ("0000" & fY_d4)			when "01",
      w6pad + ("0000" & fY_d4)			when "11",
      w6pad + ("000" & fY_d4 & "0")	  when "10",
      w6pad 			   		  when others;
   with q6(3 downto 1) select 
   fYdec5 <= 
      ("00" & fY_d4 & "00")			when "001" | "010" | "110"| "101",
      ("0" & fY_d4 & "000")			when "011"| "100",
      (29 downto 0 => '0')when others;
   with q6(3) select
   w5full <= 
      w5fulla - fYdec5			when '0',
      w5fulla + fYdec5			when others;
   w5 <= w5full(26 downto 0) & "00";
   ----------------Synchro barrier, entering cycle 5----------------
   sel5 <= w5_d1(28 downto 24) & fY_d5(23 downto 22);
   SelFunctionTable5: SelFunctionTable_r8  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => sel5,
                 Y => q5);
   w5pad <= w5_d1 & '0';
   with q5(1 downto 0) select 
   w4fulla <= 
      w5pad - ("0000" & fY_d5)			when "01",
      w5pad + ("0000" & fY_d5)			when "11",
      w5pad + ("000" & fY_d5 & "0")	  when "10",
      w5pad 			   		  when others;
   with q5(3 downto 1) select 
   fYdec4 <= 
      ("00" & fY_d5 & "00")			when "001" | "010" | "110"| "101",
      ("0" & fY_d5 & "000")			when "011"| "100",
      (29 downto 0 => '0')when others;
   with q5(3) select
   w4full <= 
      w4fulla - fYdec4			when '0',
      w4fulla + fYdec4			when others;
   w4 <= w4full(26 downto 0) & "00";
   ----------------Synchro barrier, entering cycle 6----------------
   sel4 <= w4_d1(28 downto 24) & fY_d6(23 downto 22);
   SelFunctionTable4: SelFunctionTable_r8  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => sel4,
                 Y => q4);
   w4pad <= w4_d1 & '0';
   with q4(1 downto 0) select 
   w3fulla <= 
      w4pad - ("0000" & fY_d6)			when "01",
      w4pad + ("0000" & fY_d6)			when "11",
      w4pad + ("000" & fY_d6 & "0")	  when "10",
      w4pad 			   		  when others;
   with q4(3 downto 1) select 
   fYdec3 <= 
      ("00" & fY_d6 & "00")			when "001" | "010" | "110"| "101",
      ("0" & fY_d6 & "000")			when "011"| "100",
      (29 downto 0 => '0')when others;
   with q4(3) select
   w3full <= 
      w3fulla - fYdec3			when '0',
      w3fulla + fYdec3			when others;
   w3 <= w3full(26 downto 0) & "00";
   ----------------Synchro barrier, entering cycle 7----------------
   sel3 <= w3_d1(28 downto 24) & fY_d7(23 downto 22);
   SelFunctionTable3: SelFunctionTable_r8  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => sel3,
                 Y => q3);
   w3pad <= w3_d1 & '0';
   with q3(1 downto 0) select 
   w2fulla <= 
      w3pad - ("0000" & fY_d7)			when "01",
      w3pad + ("0000" & fY_d7)			when "11",
      w3pad + ("000" & fY_d7 & "0")	  when "10",
      w3pad 			   		  when others;
   with q3(3 downto 1) select 
   fYdec2 <= 
      ("00" & fY_d7 & "00")			when "001" | "010" | "110"| "101",
      ("0" & fY_d7 & "000")			when "011"| "100",
      (29 downto 0 => '0')when others;
   with q3(3) select
   w2full <= 
      w2fulla - fYdec2			when '0',
      w2fulla + fYdec2			when others;
   w2 <= w2full(26 downto 0) & "00";
   ----------------Synchro barrier, entering cycle 8----------------
   sel2 <= w2_d1(28 downto 24) & fY_d8(23 downto 22);
   SelFunctionTable2: SelFunctionTable_r8  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => sel2,
                 Y => q2);
   w2pad <= w2_d1 & '0';
   with q2(1 downto 0) select 
   w1fulla <= 
      w2pad - ("0000" & fY_d8)			when "01",
      w2pad + ("0000" & fY_d8)			when "11",
      w2pad + ("000" & fY_d8 & "0")	  when "10",
      w2pad 			   		  when others;
   with q2(3 downto 1) select 
   fYdec1 <= 
      ("00" & fY_d8 & "00")			when "001" | "010" | "110"| "101",
      ("0" & fY_d8 & "000")			when "011"| "100",
      (29 downto 0 => '0')when others;
   with q2(3) select
   w1full <= 
      w1fulla - fYdec1			when '0',
      w1fulla + fYdec1			when others;
   w1 <= w1full(26 downto 0) & "00";
   ----------------Synchro barrier, entering cycle 9----------------
   sel1 <= w1_d1(28 downto 24) & fY_d9(23 downto 22);
   SelFunctionTable1: SelFunctionTable_r8  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => sel1,
                 Y => q1);
   w1pad <= w1_d1 & '0';
   with q1(1 downto 0) select 
   w0fulla <= 
      w1pad - ("0000" & fY_d9)			when "01",
      w1pad + ("0000" & fY_d9)			when "11",
      w1pad + ("000" & fY_d9 & "0")	  when "10",
      w1pad 			   		  when others;
   with q1(3 downto 1) select 
   fYdec0 <= 
      ("00" & fY_d9 & "00")			when "001" | "010" | "110"| "101",
      ("0" & fY_d9 & "000")			when "011"| "100",
      (29 downto 0 => '0')when others;
   with q1(3) select
   w0full <= 
      w0fulla - fYdec0			when '0',
      w0fulla + fYdec0			when others;
   w0 <= w0full(26 downto 0) & "00";
   ----------------Synchro barrier, entering cycle 10----------------
   q0(3 downto 0) <= "0000" when  w0_d1 = (28 downto 0 => '0')
                else w0_d1(28) & "010";
   qP9 <=      q9_d9(2 downto 0);
   qM9 <=      q9_d9(3) & "00";
   qP8 <=      q8_d8(2 downto 0);
   qM8 <=      q8_d8(3) & "00";
   qP7 <=      q7_d7(2 downto 0);
   qM7 <=      q7_d7(3) & "00";
   qP6 <=      q6_d6(2 downto 0);
   qM6 <=      q6_d6(3) & "00";
   qP5 <=      q5_d5(2 downto 0);
   qM5 <=      q5_d5(3) & "00";
   qP4 <=      q4_d4(2 downto 0);
   qM4 <=      q4_d4(3) & "00";
   qP3 <=      q3_d3(2 downto 0);
   qM3 <=      q3_d3(3) & "00";
   qP2 <=      q2_d2(2 downto 0);
   qM2 <=      q2_d2(3) & "00";
   qP1 <=      q1_d1(2 downto 0);
   qM1 <=      q1_d1(3) & "00";
   qP0 <= q0(2 downto 0);
   qM0 <= q0(3)  & "00";
   qP <= qP9 & qP8 & qP7 & qP6 & qP5 & qP4 & qP3 & qP2 & qP1 & qP0;
   qM <= qM9(1 downto 0) & qM8 & qM7 & qM6 & qM5 & qM4 & qM3 & qM2 & qM1 & qM0 & "0";
   fR0 <= qP - qM;
   ----------------Synchro barrier, entering cycle 11----------------
   fR <= fR0_d1(29 downto 2) & (fR0_d1(0) or fR0_d1(1)); 
   -- normalisation
   with fR(27) select
      fRn1 <= fR(27 downto 2) & (fR(0) or fR(1)) when '1',
              fR(26 downto 0)          when others;
   expR1 <= expR0_d11 + ("000" & (6 downto 1 => '1') & fR(27)); -- add back bias
   round <= fRn1(2) and (fRn1(0) or fRn1(1) or fRn1(3)); -- fRn1(0) is the sticky bit
   ----------------Synchro barrier, entering cycle 12----------------
   -- final rounding
   expfrac <= expR1_d1 & fRn1_d1(25 downto 3) ;
   expfracR <= expfrac + ((32 downto 1 => '0') & round_d1);
   exnR <=      "00"  when expfracR(32) = '1'   -- underflow
           else "10"  when  expfracR(32 downto 31) =  "01" -- overflow
           else "01";      -- 00, normal case
   with exnR0_d12 select
      exnRfinal <= 
         exnR   when "01", -- normal
         exnR0_d12  when others;
   R <= exnRfinal & sR_d12 & expfracR(30 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                Constant_float_8_23_348_mult_8en9_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Patrick Sittel
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Constant_float_8_23_348_mult_8en9_component is
   port ( clk, rst : in std_logic;
          Y : out std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of Constant_float_8_23_348_mult_8en9_component is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
---------------------  addFullComment for a large comment  ---------------------
   -- addComment for small left-aligned comment
    Y <= "0100110110001110101101010011000001";
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 5 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      Y <= s4;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_4_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 4 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_4_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_4_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      Y <= s3;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 2 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      Y <= s1;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 3 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      Y <= s2;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_14_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 14 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_14_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_14_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      Y <= s13;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_83_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 83 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_83_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_83_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
signal s14 : std_logic_vector(33 downto 0) := (others => '0');
signal s15 : std_logic_vector(33 downto 0) := (others => '0');
signal s16 : std_logic_vector(33 downto 0) := (others => '0');
signal s17 : std_logic_vector(33 downto 0) := (others => '0');
signal s18 : std_logic_vector(33 downto 0) := (others => '0');
signal s19 : std_logic_vector(33 downto 0) := (others => '0');
signal s20 : std_logic_vector(33 downto 0) := (others => '0');
signal s21 : std_logic_vector(33 downto 0) := (others => '0');
signal s22 : std_logic_vector(33 downto 0) := (others => '0');
signal s23 : std_logic_vector(33 downto 0) := (others => '0');
signal s24 : std_logic_vector(33 downto 0) := (others => '0');
signal s25 : std_logic_vector(33 downto 0) := (others => '0');
signal s26 : std_logic_vector(33 downto 0) := (others => '0');
signal s27 : std_logic_vector(33 downto 0) := (others => '0');
signal s28 : std_logic_vector(33 downto 0) := (others => '0');
signal s29 : std_logic_vector(33 downto 0) := (others => '0');
signal s30 : std_logic_vector(33 downto 0) := (others => '0');
signal s31 : std_logic_vector(33 downto 0) := (others => '0');
signal s32 : std_logic_vector(33 downto 0) := (others => '0');
signal s33 : std_logic_vector(33 downto 0) := (others => '0');
signal s34 : std_logic_vector(33 downto 0) := (others => '0');
signal s35 : std_logic_vector(33 downto 0) := (others => '0');
signal s36 : std_logic_vector(33 downto 0) := (others => '0');
signal s37 : std_logic_vector(33 downto 0) := (others => '0');
signal s38 : std_logic_vector(33 downto 0) := (others => '0');
signal s39 : std_logic_vector(33 downto 0) := (others => '0');
signal s40 : std_logic_vector(33 downto 0) := (others => '0');
signal s41 : std_logic_vector(33 downto 0) := (others => '0');
signal s42 : std_logic_vector(33 downto 0) := (others => '0');
signal s43 : std_logic_vector(33 downto 0) := (others => '0');
signal s44 : std_logic_vector(33 downto 0) := (others => '0');
signal s45 : std_logic_vector(33 downto 0) := (others => '0');
signal s46 : std_logic_vector(33 downto 0) := (others => '0');
signal s47 : std_logic_vector(33 downto 0) := (others => '0');
signal s48 : std_logic_vector(33 downto 0) := (others => '0');
signal s49 : std_logic_vector(33 downto 0) := (others => '0');
signal s50 : std_logic_vector(33 downto 0) := (others => '0');
signal s51 : std_logic_vector(33 downto 0) := (others => '0');
signal s52 : std_logic_vector(33 downto 0) := (others => '0');
signal s53 : std_logic_vector(33 downto 0) := (others => '0');
signal s54 : std_logic_vector(33 downto 0) := (others => '0');
signal s55 : std_logic_vector(33 downto 0) := (others => '0');
signal s56 : std_logic_vector(33 downto 0) := (others => '0');
signal s57 : std_logic_vector(33 downto 0) := (others => '0');
signal s58 : std_logic_vector(33 downto 0) := (others => '0');
signal s59 : std_logic_vector(33 downto 0) := (others => '0');
signal s60 : std_logic_vector(33 downto 0) := (others => '0');
signal s61 : std_logic_vector(33 downto 0) := (others => '0');
signal s62 : std_logic_vector(33 downto 0) := (others => '0');
signal s63 : std_logic_vector(33 downto 0) := (others => '0');
signal s64 : std_logic_vector(33 downto 0) := (others => '0');
signal s65 : std_logic_vector(33 downto 0) := (others => '0');
signal s66 : std_logic_vector(33 downto 0) := (others => '0');
signal s67 : std_logic_vector(33 downto 0) := (others => '0');
signal s68 : std_logic_vector(33 downto 0) := (others => '0');
signal s69 : std_logic_vector(33 downto 0) := (others => '0');
signal s70 : std_logic_vector(33 downto 0) := (others => '0');
signal s71 : std_logic_vector(33 downto 0) := (others => '0');
signal s72 : std_logic_vector(33 downto 0) := (others => '0');
signal s73 : std_logic_vector(33 downto 0) := (others => '0');
signal s74 : std_logic_vector(33 downto 0) := (others => '0');
signal s75 : std_logic_vector(33 downto 0) := (others => '0');
signal s76 : std_logic_vector(33 downto 0) := (others => '0');
signal s77 : std_logic_vector(33 downto 0) := (others => '0');
signal s78 : std_logic_vector(33 downto 0) := (others => '0');
signal s79 : std_logic_vector(33 downto 0) := (others => '0');
signal s80 : std_logic_vector(33 downto 0) := (others => '0');
signal s81 : std_logic_vector(33 downto 0) := (others => '0');
signal s82 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
      s14 <= "0000000000000000000000000000000000";
      s15 <= "0000000000000000000000000000000000";
      s16 <= "0000000000000000000000000000000000";
      s17 <= "0000000000000000000000000000000000";
      s18 <= "0000000000000000000000000000000000";
      s19 <= "0000000000000000000000000000000000";
      s20 <= "0000000000000000000000000000000000";
      s21 <= "0000000000000000000000000000000000";
      s22 <= "0000000000000000000000000000000000";
      s23 <= "0000000000000000000000000000000000";
      s24 <= "0000000000000000000000000000000000";
      s25 <= "0000000000000000000000000000000000";
      s26 <= "0000000000000000000000000000000000";
      s27 <= "0000000000000000000000000000000000";
      s28 <= "0000000000000000000000000000000000";
      s29 <= "0000000000000000000000000000000000";
      s30 <= "0000000000000000000000000000000000";
      s31 <= "0000000000000000000000000000000000";
      s32 <= "0000000000000000000000000000000000";
      s33 <= "0000000000000000000000000000000000";
      s34 <= "0000000000000000000000000000000000";
      s35 <= "0000000000000000000000000000000000";
      s36 <= "0000000000000000000000000000000000";
      s37 <= "0000000000000000000000000000000000";
      s38 <= "0000000000000000000000000000000000";
      s39 <= "0000000000000000000000000000000000";
      s40 <= "0000000000000000000000000000000000";
      s41 <= "0000000000000000000000000000000000";
      s42 <= "0000000000000000000000000000000000";
      s43 <= "0000000000000000000000000000000000";
      s44 <= "0000000000000000000000000000000000";
      s45 <= "0000000000000000000000000000000000";
      s46 <= "0000000000000000000000000000000000";
      s47 <= "0000000000000000000000000000000000";
      s48 <= "0000000000000000000000000000000000";
      s49 <= "0000000000000000000000000000000000";
      s50 <= "0000000000000000000000000000000000";
      s51 <= "0000000000000000000000000000000000";
      s52 <= "0000000000000000000000000000000000";
      s53 <= "0000000000000000000000000000000000";
      s54 <= "0000000000000000000000000000000000";
      s55 <= "0000000000000000000000000000000000";
      s56 <= "0000000000000000000000000000000000";
      s57 <= "0000000000000000000000000000000000";
      s58 <= "0000000000000000000000000000000000";
      s59 <= "0000000000000000000000000000000000";
      s60 <= "0000000000000000000000000000000000";
      s61 <= "0000000000000000000000000000000000";
      s62 <= "0000000000000000000000000000000000";
      s63 <= "0000000000000000000000000000000000";
      s64 <= "0000000000000000000000000000000000";
      s65 <= "0000000000000000000000000000000000";
      s66 <= "0000000000000000000000000000000000";
      s67 <= "0000000000000000000000000000000000";
      s68 <= "0000000000000000000000000000000000";
      s69 <= "0000000000000000000000000000000000";
      s70 <= "0000000000000000000000000000000000";
      s71 <= "0000000000000000000000000000000000";
      s72 <= "0000000000000000000000000000000000";
      s73 <= "0000000000000000000000000000000000";
      s74 <= "0000000000000000000000000000000000";
      s75 <= "0000000000000000000000000000000000";
      s76 <= "0000000000000000000000000000000000";
      s77 <= "0000000000000000000000000000000000";
      s78 <= "0000000000000000000000000000000000";
      s79 <= "0000000000000000000000000000000000";
      s80 <= "0000000000000000000000000000000000";
      s81 <= "0000000000000000000000000000000000";
      s82 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      s14 <= s13;
      s15 <= s14;
      s16 <= s15;
      s17 <= s16;
      s18 <= s17;
      s19 <= s18;
      s20 <= s19;
      s21 <= s20;
      s22 <= s21;
      s23 <= s22;
      s24 <= s23;
      s25 <= s24;
      s26 <= s25;
      s27 <= s26;
      s28 <= s27;
      s29 <= s28;
      s30 <= s29;
      s31 <= s30;
      s32 <= s31;
      s33 <= s32;
      s34 <= s33;
      s35 <= s34;
      s36 <= s35;
      s37 <= s36;
      s38 <= s37;
      s39 <= s38;
      s40 <= s39;
      s41 <= s40;
      s42 <= s41;
      s43 <= s42;
      s44 <= s43;
      s45 <= s44;
      s46 <= s45;
      s47 <= s46;
      s48 <= s47;
      s49 <= s48;
      s50 <= s49;
      s51 <= s50;
      s52 <= s51;
      s53 <= s52;
      s54 <= s53;
      s55 <= s54;
      s56 <= s55;
      s57 <= s56;
      s58 <= s57;
      s59 <= s58;
      s60 <= s59;
      s61 <= s60;
      s62 <= s61;
      s63 <= s62;
      s64 <= s63;
      s65 <= s64;
      s66 <= s65;
      s67 <= s66;
      s68 <= s67;
      s69 <= s68;
      s70 <= s69;
      s71 <= s70;
      s72 <= s71;
      s73 <= s72;
      s74 <= s73;
      s75 <= s74;
      s76 <= s75;
      s77 <= s76;
      s78 <= s77;
      s79 <= s78;
      s80 <= s79;
      s81 <= s80;
      s82 <= s81;
      Y <= s82;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_11_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 11 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_11_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_11_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      Y <= s10;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_13_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 13 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_13_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_13_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      Y <= s12;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_19_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 19 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_19_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_19_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
signal s14 : std_logic_vector(33 downto 0) := (others => '0');
signal s15 : std_logic_vector(33 downto 0) := (others => '0');
signal s16 : std_logic_vector(33 downto 0) := (others => '0');
signal s17 : std_logic_vector(33 downto 0) := (others => '0');
signal s18 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
      s14 <= "0000000000000000000000000000000000";
      s15 <= "0000000000000000000000000000000000";
      s16 <= "0000000000000000000000000000000000";
      s17 <= "0000000000000000000000000000000000";
      s18 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      s14 <= s13;
      s15 <= s14;
      s16 <= s15;
      s17 <= s16;
      s18 <= s17;
      Y <= s18;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_8_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 8 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_8_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_8_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      Y <= s7;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_107_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 107 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_107_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_107_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
signal s14 : std_logic_vector(33 downto 0) := (others => '0');
signal s15 : std_logic_vector(33 downto 0) := (others => '0');
signal s16 : std_logic_vector(33 downto 0) := (others => '0');
signal s17 : std_logic_vector(33 downto 0) := (others => '0');
signal s18 : std_logic_vector(33 downto 0) := (others => '0');
signal s19 : std_logic_vector(33 downto 0) := (others => '0');
signal s20 : std_logic_vector(33 downto 0) := (others => '0');
signal s21 : std_logic_vector(33 downto 0) := (others => '0');
signal s22 : std_logic_vector(33 downto 0) := (others => '0');
signal s23 : std_logic_vector(33 downto 0) := (others => '0');
signal s24 : std_logic_vector(33 downto 0) := (others => '0');
signal s25 : std_logic_vector(33 downto 0) := (others => '0');
signal s26 : std_logic_vector(33 downto 0) := (others => '0');
signal s27 : std_logic_vector(33 downto 0) := (others => '0');
signal s28 : std_logic_vector(33 downto 0) := (others => '0');
signal s29 : std_logic_vector(33 downto 0) := (others => '0');
signal s30 : std_logic_vector(33 downto 0) := (others => '0');
signal s31 : std_logic_vector(33 downto 0) := (others => '0');
signal s32 : std_logic_vector(33 downto 0) := (others => '0');
signal s33 : std_logic_vector(33 downto 0) := (others => '0');
signal s34 : std_logic_vector(33 downto 0) := (others => '0');
signal s35 : std_logic_vector(33 downto 0) := (others => '0');
signal s36 : std_logic_vector(33 downto 0) := (others => '0');
signal s37 : std_logic_vector(33 downto 0) := (others => '0');
signal s38 : std_logic_vector(33 downto 0) := (others => '0');
signal s39 : std_logic_vector(33 downto 0) := (others => '0');
signal s40 : std_logic_vector(33 downto 0) := (others => '0');
signal s41 : std_logic_vector(33 downto 0) := (others => '0');
signal s42 : std_logic_vector(33 downto 0) := (others => '0');
signal s43 : std_logic_vector(33 downto 0) := (others => '0');
signal s44 : std_logic_vector(33 downto 0) := (others => '0');
signal s45 : std_logic_vector(33 downto 0) := (others => '0');
signal s46 : std_logic_vector(33 downto 0) := (others => '0');
signal s47 : std_logic_vector(33 downto 0) := (others => '0');
signal s48 : std_logic_vector(33 downto 0) := (others => '0');
signal s49 : std_logic_vector(33 downto 0) := (others => '0');
signal s50 : std_logic_vector(33 downto 0) := (others => '0');
signal s51 : std_logic_vector(33 downto 0) := (others => '0');
signal s52 : std_logic_vector(33 downto 0) := (others => '0');
signal s53 : std_logic_vector(33 downto 0) := (others => '0');
signal s54 : std_logic_vector(33 downto 0) := (others => '0');
signal s55 : std_logic_vector(33 downto 0) := (others => '0');
signal s56 : std_logic_vector(33 downto 0) := (others => '0');
signal s57 : std_logic_vector(33 downto 0) := (others => '0');
signal s58 : std_logic_vector(33 downto 0) := (others => '0');
signal s59 : std_logic_vector(33 downto 0) := (others => '0');
signal s60 : std_logic_vector(33 downto 0) := (others => '0');
signal s61 : std_logic_vector(33 downto 0) := (others => '0');
signal s62 : std_logic_vector(33 downto 0) := (others => '0');
signal s63 : std_logic_vector(33 downto 0) := (others => '0');
signal s64 : std_logic_vector(33 downto 0) := (others => '0');
signal s65 : std_logic_vector(33 downto 0) := (others => '0');
signal s66 : std_logic_vector(33 downto 0) := (others => '0');
signal s67 : std_logic_vector(33 downto 0) := (others => '0');
signal s68 : std_logic_vector(33 downto 0) := (others => '0');
signal s69 : std_logic_vector(33 downto 0) := (others => '0');
signal s70 : std_logic_vector(33 downto 0) := (others => '0');
signal s71 : std_logic_vector(33 downto 0) := (others => '0');
signal s72 : std_logic_vector(33 downto 0) := (others => '0');
signal s73 : std_logic_vector(33 downto 0) := (others => '0');
signal s74 : std_logic_vector(33 downto 0) := (others => '0');
signal s75 : std_logic_vector(33 downto 0) := (others => '0');
signal s76 : std_logic_vector(33 downto 0) := (others => '0');
signal s77 : std_logic_vector(33 downto 0) := (others => '0');
signal s78 : std_logic_vector(33 downto 0) := (others => '0');
signal s79 : std_logic_vector(33 downto 0) := (others => '0');
signal s80 : std_logic_vector(33 downto 0) := (others => '0');
signal s81 : std_logic_vector(33 downto 0) := (others => '0');
signal s82 : std_logic_vector(33 downto 0) := (others => '0');
signal s83 : std_logic_vector(33 downto 0) := (others => '0');
signal s84 : std_logic_vector(33 downto 0) := (others => '0');
signal s85 : std_logic_vector(33 downto 0) := (others => '0');
signal s86 : std_logic_vector(33 downto 0) := (others => '0');
signal s87 : std_logic_vector(33 downto 0) := (others => '0');
signal s88 : std_logic_vector(33 downto 0) := (others => '0');
signal s89 : std_logic_vector(33 downto 0) := (others => '0');
signal s90 : std_logic_vector(33 downto 0) := (others => '0');
signal s91 : std_logic_vector(33 downto 0) := (others => '0');
signal s92 : std_logic_vector(33 downto 0) := (others => '0');
signal s93 : std_logic_vector(33 downto 0) := (others => '0');
signal s94 : std_logic_vector(33 downto 0) := (others => '0');
signal s95 : std_logic_vector(33 downto 0) := (others => '0');
signal s96 : std_logic_vector(33 downto 0) := (others => '0');
signal s97 : std_logic_vector(33 downto 0) := (others => '0');
signal s98 : std_logic_vector(33 downto 0) := (others => '0');
signal s99 : std_logic_vector(33 downto 0) := (others => '0');
signal s100 : std_logic_vector(33 downto 0) := (others => '0');
signal s101 : std_logic_vector(33 downto 0) := (others => '0');
signal s102 : std_logic_vector(33 downto 0) := (others => '0');
signal s103 : std_logic_vector(33 downto 0) := (others => '0');
signal s104 : std_logic_vector(33 downto 0) := (others => '0');
signal s105 : std_logic_vector(33 downto 0) := (others => '0');
signal s106 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
      s14 <= "0000000000000000000000000000000000";
      s15 <= "0000000000000000000000000000000000";
      s16 <= "0000000000000000000000000000000000";
      s17 <= "0000000000000000000000000000000000";
      s18 <= "0000000000000000000000000000000000";
      s19 <= "0000000000000000000000000000000000";
      s20 <= "0000000000000000000000000000000000";
      s21 <= "0000000000000000000000000000000000";
      s22 <= "0000000000000000000000000000000000";
      s23 <= "0000000000000000000000000000000000";
      s24 <= "0000000000000000000000000000000000";
      s25 <= "0000000000000000000000000000000000";
      s26 <= "0000000000000000000000000000000000";
      s27 <= "0000000000000000000000000000000000";
      s28 <= "0000000000000000000000000000000000";
      s29 <= "0000000000000000000000000000000000";
      s30 <= "0000000000000000000000000000000000";
      s31 <= "0000000000000000000000000000000000";
      s32 <= "0000000000000000000000000000000000";
      s33 <= "0000000000000000000000000000000000";
      s34 <= "0000000000000000000000000000000000";
      s35 <= "0000000000000000000000000000000000";
      s36 <= "0000000000000000000000000000000000";
      s37 <= "0000000000000000000000000000000000";
      s38 <= "0000000000000000000000000000000000";
      s39 <= "0000000000000000000000000000000000";
      s40 <= "0000000000000000000000000000000000";
      s41 <= "0000000000000000000000000000000000";
      s42 <= "0000000000000000000000000000000000";
      s43 <= "0000000000000000000000000000000000";
      s44 <= "0000000000000000000000000000000000";
      s45 <= "0000000000000000000000000000000000";
      s46 <= "0000000000000000000000000000000000";
      s47 <= "0000000000000000000000000000000000";
      s48 <= "0000000000000000000000000000000000";
      s49 <= "0000000000000000000000000000000000";
      s50 <= "0000000000000000000000000000000000";
      s51 <= "0000000000000000000000000000000000";
      s52 <= "0000000000000000000000000000000000";
      s53 <= "0000000000000000000000000000000000";
      s54 <= "0000000000000000000000000000000000";
      s55 <= "0000000000000000000000000000000000";
      s56 <= "0000000000000000000000000000000000";
      s57 <= "0000000000000000000000000000000000";
      s58 <= "0000000000000000000000000000000000";
      s59 <= "0000000000000000000000000000000000";
      s60 <= "0000000000000000000000000000000000";
      s61 <= "0000000000000000000000000000000000";
      s62 <= "0000000000000000000000000000000000";
      s63 <= "0000000000000000000000000000000000";
      s64 <= "0000000000000000000000000000000000";
      s65 <= "0000000000000000000000000000000000";
      s66 <= "0000000000000000000000000000000000";
      s67 <= "0000000000000000000000000000000000";
      s68 <= "0000000000000000000000000000000000";
      s69 <= "0000000000000000000000000000000000";
      s70 <= "0000000000000000000000000000000000";
      s71 <= "0000000000000000000000000000000000";
      s72 <= "0000000000000000000000000000000000";
      s73 <= "0000000000000000000000000000000000";
      s74 <= "0000000000000000000000000000000000";
      s75 <= "0000000000000000000000000000000000";
      s76 <= "0000000000000000000000000000000000";
      s77 <= "0000000000000000000000000000000000";
      s78 <= "0000000000000000000000000000000000";
      s79 <= "0000000000000000000000000000000000";
      s80 <= "0000000000000000000000000000000000";
      s81 <= "0000000000000000000000000000000000";
      s82 <= "0000000000000000000000000000000000";
      s83 <= "0000000000000000000000000000000000";
      s84 <= "0000000000000000000000000000000000";
      s85 <= "0000000000000000000000000000000000";
      s86 <= "0000000000000000000000000000000000";
      s87 <= "0000000000000000000000000000000000";
      s88 <= "0000000000000000000000000000000000";
      s89 <= "0000000000000000000000000000000000";
      s90 <= "0000000000000000000000000000000000";
      s91 <= "0000000000000000000000000000000000";
      s92 <= "0000000000000000000000000000000000";
      s93 <= "0000000000000000000000000000000000";
      s94 <= "0000000000000000000000000000000000";
      s95 <= "0000000000000000000000000000000000";
      s96 <= "0000000000000000000000000000000000";
      s97 <= "0000000000000000000000000000000000";
      s98 <= "0000000000000000000000000000000000";
      s99 <= "0000000000000000000000000000000000";
      s100 <= "0000000000000000000000000000000000";
      s101 <= "0000000000000000000000000000000000";
      s102 <= "0000000000000000000000000000000000";
      s103 <= "0000000000000000000000000000000000";
      s104 <= "0000000000000000000000000000000000";
      s105 <= "0000000000000000000000000000000000";
      s106 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      s14 <= s13;
      s15 <= s14;
      s16 <= s15;
      s17 <= s16;
      s18 <= s17;
      s19 <= s18;
      s20 <= s19;
      s21 <= s20;
      s22 <= s21;
      s23 <= s22;
      s24 <= s23;
      s25 <= s24;
      s26 <= s25;
      s27 <= s26;
      s28 <= s27;
      s29 <= s28;
      s30 <= s29;
      s31 <= s30;
      s32 <= s31;
      s33 <= s32;
      s34 <= s33;
      s35 <= s34;
      s36 <= s35;
      s37 <= s36;
      s38 <= s37;
      s39 <= s38;
      s40 <= s39;
      s41 <= s40;
      s42 <= s41;
      s43 <= s42;
      s44 <= s43;
      s45 <= s44;
      s46 <= s45;
      s47 <= s46;
      s48 <= s47;
      s49 <= s48;
      s50 <= s49;
      s51 <= s50;
      s52 <= s51;
      s53 <= s52;
      s54 <= s53;
      s55 <= s54;
      s56 <= s55;
      s57 <= s56;
      s58 <= s57;
      s59 <= s58;
      s60 <= s59;
      s61 <= s60;
      s62 <= s61;
      s63 <= s62;
      s64 <= s63;
      s65 <= s64;
      s66 <= s65;
      s67 <= s66;
      s68 <= s67;
      s69 <= s68;
      s70 <= s69;
      s71 <= s70;
      s72 <= s71;
      s73 <= s72;
      s74 <= s73;
      s75 <= s74;
      s76 <= s75;
      s77 <= s76;
      s78 <= s77;
      s79 <= s78;
      s80 <= s79;
      s81 <= s80;
      s82 <= s81;
      s83 <= s82;
      s84 <= s83;
      s85 <= s84;
      s86 <= s85;
      s87 <= s86;
      s88 <= s87;
      s89 <= s88;
      s90 <= s89;
      s91 <= s90;
      s92 <= s91;
      s93 <= s92;
      s94 <= s93;
      s95 <= s94;
      s96 <= s95;
      s97 <= s96;
      s98 <= s97;
      s99 <= s98;
      s100 <= s99;
      s101 <= s100;
      s102 <= s101;
      s103 <= s102;
      s104 <= s103;
      s105 <= s104;
      s106 <= s105;
      Y <= s106;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_32_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 32 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_32_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_32_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
signal s14 : std_logic_vector(33 downto 0) := (others => '0');
signal s15 : std_logic_vector(33 downto 0) := (others => '0');
signal s16 : std_logic_vector(33 downto 0) := (others => '0');
signal s17 : std_logic_vector(33 downto 0) := (others => '0');
signal s18 : std_logic_vector(33 downto 0) := (others => '0');
signal s19 : std_logic_vector(33 downto 0) := (others => '0');
signal s20 : std_logic_vector(33 downto 0) := (others => '0');
signal s21 : std_logic_vector(33 downto 0) := (others => '0');
signal s22 : std_logic_vector(33 downto 0) := (others => '0');
signal s23 : std_logic_vector(33 downto 0) := (others => '0');
signal s24 : std_logic_vector(33 downto 0) := (others => '0');
signal s25 : std_logic_vector(33 downto 0) := (others => '0');
signal s26 : std_logic_vector(33 downto 0) := (others => '0');
signal s27 : std_logic_vector(33 downto 0) := (others => '0');
signal s28 : std_logic_vector(33 downto 0) := (others => '0');
signal s29 : std_logic_vector(33 downto 0) := (others => '0');
signal s30 : std_logic_vector(33 downto 0) := (others => '0');
signal s31 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
      s14 <= "0000000000000000000000000000000000";
      s15 <= "0000000000000000000000000000000000";
      s16 <= "0000000000000000000000000000000000";
      s17 <= "0000000000000000000000000000000000";
      s18 <= "0000000000000000000000000000000000";
      s19 <= "0000000000000000000000000000000000";
      s20 <= "0000000000000000000000000000000000";
      s21 <= "0000000000000000000000000000000000";
      s22 <= "0000000000000000000000000000000000";
      s23 <= "0000000000000000000000000000000000";
      s24 <= "0000000000000000000000000000000000";
      s25 <= "0000000000000000000000000000000000";
      s26 <= "0000000000000000000000000000000000";
      s27 <= "0000000000000000000000000000000000";
      s28 <= "0000000000000000000000000000000000";
      s29 <= "0000000000000000000000000000000000";
      s30 <= "0000000000000000000000000000000000";
      s31 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      s14 <= s13;
      s15 <= s14;
      s16 <= s15;
      s17 <= s16;
      s18 <= s17;
      s19 <= s18;
      s20 <= s19;
      s21 <= s20;
      s22 <= s21;
      s23 <= s22;
      s24 <= s23;
      s25 <= s24;
      s26 <= s25;
      s27 <= s26;
      s28 <= s27;
      s29 <= s28;
      s30 <= s29;
      s31 <= s30;
      Y <= s31;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_21_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 21 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_21_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_21_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
signal s14 : std_logic_vector(33 downto 0) := (others => '0');
signal s15 : std_logic_vector(33 downto 0) := (others => '0');
signal s16 : std_logic_vector(33 downto 0) := (others => '0');
signal s17 : std_logic_vector(33 downto 0) := (others => '0');
signal s18 : std_logic_vector(33 downto 0) := (others => '0');
signal s19 : std_logic_vector(33 downto 0) := (others => '0');
signal s20 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
      s14 <= "0000000000000000000000000000000000";
      s15 <= "0000000000000000000000000000000000";
      s16 <= "0000000000000000000000000000000000";
      s17 <= "0000000000000000000000000000000000";
      s18 <= "0000000000000000000000000000000000";
      s19 <= "0000000000000000000000000000000000";
      s20 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      s14 <= s13;
      s15 <= s14;
      s16 <= s15;
      s17 <= s16;
      s18 <= s17;
      s19 <= s18;
      s20 <= s19;
      Y <= s20;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_7_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 7 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_7_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_7_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      Y <= s6;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_52_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 52 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_52_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_52_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
signal s14 : std_logic_vector(33 downto 0) := (others => '0');
signal s15 : std_logic_vector(33 downto 0) := (others => '0');
signal s16 : std_logic_vector(33 downto 0) := (others => '0');
signal s17 : std_logic_vector(33 downto 0) := (others => '0');
signal s18 : std_logic_vector(33 downto 0) := (others => '0');
signal s19 : std_logic_vector(33 downto 0) := (others => '0');
signal s20 : std_logic_vector(33 downto 0) := (others => '0');
signal s21 : std_logic_vector(33 downto 0) := (others => '0');
signal s22 : std_logic_vector(33 downto 0) := (others => '0');
signal s23 : std_logic_vector(33 downto 0) := (others => '0');
signal s24 : std_logic_vector(33 downto 0) := (others => '0');
signal s25 : std_logic_vector(33 downto 0) := (others => '0');
signal s26 : std_logic_vector(33 downto 0) := (others => '0');
signal s27 : std_logic_vector(33 downto 0) := (others => '0');
signal s28 : std_logic_vector(33 downto 0) := (others => '0');
signal s29 : std_logic_vector(33 downto 0) := (others => '0');
signal s30 : std_logic_vector(33 downto 0) := (others => '0');
signal s31 : std_logic_vector(33 downto 0) := (others => '0');
signal s32 : std_logic_vector(33 downto 0) := (others => '0');
signal s33 : std_logic_vector(33 downto 0) := (others => '0');
signal s34 : std_logic_vector(33 downto 0) := (others => '0');
signal s35 : std_logic_vector(33 downto 0) := (others => '0');
signal s36 : std_logic_vector(33 downto 0) := (others => '0');
signal s37 : std_logic_vector(33 downto 0) := (others => '0');
signal s38 : std_logic_vector(33 downto 0) := (others => '0');
signal s39 : std_logic_vector(33 downto 0) := (others => '0');
signal s40 : std_logic_vector(33 downto 0) := (others => '0');
signal s41 : std_logic_vector(33 downto 0) := (others => '0');
signal s42 : std_logic_vector(33 downto 0) := (others => '0');
signal s43 : std_logic_vector(33 downto 0) := (others => '0');
signal s44 : std_logic_vector(33 downto 0) := (others => '0');
signal s45 : std_logic_vector(33 downto 0) := (others => '0');
signal s46 : std_logic_vector(33 downto 0) := (others => '0');
signal s47 : std_logic_vector(33 downto 0) := (others => '0');
signal s48 : std_logic_vector(33 downto 0) := (others => '0');
signal s49 : std_logic_vector(33 downto 0) := (others => '0');
signal s50 : std_logic_vector(33 downto 0) := (others => '0');
signal s51 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
      s14 <= "0000000000000000000000000000000000";
      s15 <= "0000000000000000000000000000000000";
      s16 <= "0000000000000000000000000000000000";
      s17 <= "0000000000000000000000000000000000";
      s18 <= "0000000000000000000000000000000000";
      s19 <= "0000000000000000000000000000000000";
      s20 <= "0000000000000000000000000000000000";
      s21 <= "0000000000000000000000000000000000";
      s22 <= "0000000000000000000000000000000000";
      s23 <= "0000000000000000000000000000000000";
      s24 <= "0000000000000000000000000000000000";
      s25 <= "0000000000000000000000000000000000";
      s26 <= "0000000000000000000000000000000000";
      s27 <= "0000000000000000000000000000000000";
      s28 <= "0000000000000000000000000000000000";
      s29 <= "0000000000000000000000000000000000";
      s30 <= "0000000000000000000000000000000000";
      s31 <= "0000000000000000000000000000000000";
      s32 <= "0000000000000000000000000000000000";
      s33 <= "0000000000000000000000000000000000";
      s34 <= "0000000000000000000000000000000000";
      s35 <= "0000000000000000000000000000000000";
      s36 <= "0000000000000000000000000000000000";
      s37 <= "0000000000000000000000000000000000";
      s38 <= "0000000000000000000000000000000000";
      s39 <= "0000000000000000000000000000000000";
      s40 <= "0000000000000000000000000000000000";
      s41 <= "0000000000000000000000000000000000";
      s42 <= "0000000000000000000000000000000000";
      s43 <= "0000000000000000000000000000000000";
      s44 <= "0000000000000000000000000000000000";
      s45 <= "0000000000000000000000000000000000";
      s46 <= "0000000000000000000000000000000000";
      s47 <= "0000000000000000000000000000000000";
      s48 <= "0000000000000000000000000000000000";
      s49 <= "0000000000000000000000000000000000";
      s50 <= "0000000000000000000000000000000000";
      s51 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      s14 <= s13;
      s15 <= s14;
      s16 <= s15;
      s17 <= s16;
      s18 <= s17;
      s19 <= s18;
      s20 <= s19;
      s21 <= s20;
      s22 <= s21;
      s23 <= s22;
      s24 <= s23;
      s25 <= s24;
      s26 <= s25;
      s27 <= s26;
      s28 <= s27;
      s29 <= s28;
      s30 <= s29;
      s31 <= s30;
      s32 <= s31;
      s33 <= s32;
      s34 <= s33;
      s35 <= s34;
      s36 <= s35;
      s37 <= s36;
      s38 <= s37;
      s39 <= s38;
      s40 <= s39;
      s41 <= s40;
      s42 <= s41;
      s43 <= s42;
      s44 <= s43;
      s45 <= s44;
      s46 <= s45;
      s47 <= s46;
      s48 <= s47;
      s49 <= s48;
      s50 <= s49;
      s51 <= s50;
      Y <= s51;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_66_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 66 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_66_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_66_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
signal s14 : std_logic_vector(33 downto 0) := (others => '0');
signal s15 : std_logic_vector(33 downto 0) := (others => '0');
signal s16 : std_logic_vector(33 downto 0) := (others => '0');
signal s17 : std_logic_vector(33 downto 0) := (others => '0');
signal s18 : std_logic_vector(33 downto 0) := (others => '0');
signal s19 : std_logic_vector(33 downto 0) := (others => '0');
signal s20 : std_logic_vector(33 downto 0) := (others => '0');
signal s21 : std_logic_vector(33 downto 0) := (others => '0');
signal s22 : std_logic_vector(33 downto 0) := (others => '0');
signal s23 : std_logic_vector(33 downto 0) := (others => '0');
signal s24 : std_logic_vector(33 downto 0) := (others => '0');
signal s25 : std_logic_vector(33 downto 0) := (others => '0');
signal s26 : std_logic_vector(33 downto 0) := (others => '0');
signal s27 : std_logic_vector(33 downto 0) := (others => '0');
signal s28 : std_logic_vector(33 downto 0) := (others => '0');
signal s29 : std_logic_vector(33 downto 0) := (others => '0');
signal s30 : std_logic_vector(33 downto 0) := (others => '0');
signal s31 : std_logic_vector(33 downto 0) := (others => '0');
signal s32 : std_logic_vector(33 downto 0) := (others => '0');
signal s33 : std_logic_vector(33 downto 0) := (others => '0');
signal s34 : std_logic_vector(33 downto 0) := (others => '0');
signal s35 : std_logic_vector(33 downto 0) := (others => '0');
signal s36 : std_logic_vector(33 downto 0) := (others => '0');
signal s37 : std_logic_vector(33 downto 0) := (others => '0');
signal s38 : std_logic_vector(33 downto 0) := (others => '0');
signal s39 : std_logic_vector(33 downto 0) := (others => '0');
signal s40 : std_logic_vector(33 downto 0) := (others => '0');
signal s41 : std_logic_vector(33 downto 0) := (others => '0');
signal s42 : std_logic_vector(33 downto 0) := (others => '0');
signal s43 : std_logic_vector(33 downto 0) := (others => '0');
signal s44 : std_logic_vector(33 downto 0) := (others => '0');
signal s45 : std_logic_vector(33 downto 0) := (others => '0');
signal s46 : std_logic_vector(33 downto 0) := (others => '0');
signal s47 : std_logic_vector(33 downto 0) := (others => '0');
signal s48 : std_logic_vector(33 downto 0) := (others => '0');
signal s49 : std_logic_vector(33 downto 0) := (others => '0');
signal s50 : std_logic_vector(33 downto 0) := (others => '0');
signal s51 : std_logic_vector(33 downto 0) := (others => '0');
signal s52 : std_logic_vector(33 downto 0) := (others => '0');
signal s53 : std_logic_vector(33 downto 0) := (others => '0');
signal s54 : std_logic_vector(33 downto 0) := (others => '0');
signal s55 : std_logic_vector(33 downto 0) := (others => '0');
signal s56 : std_logic_vector(33 downto 0) := (others => '0');
signal s57 : std_logic_vector(33 downto 0) := (others => '0');
signal s58 : std_logic_vector(33 downto 0) := (others => '0');
signal s59 : std_logic_vector(33 downto 0) := (others => '0');
signal s60 : std_logic_vector(33 downto 0) := (others => '0');
signal s61 : std_logic_vector(33 downto 0) := (others => '0');
signal s62 : std_logic_vector(33 downto 0) := (others => '0');
signal s63 : std_logic_vector(33 downto 0) := (others => '0');
signal s64 : std_logic_vector(33 downto 0) := (others => '0');
signal s65 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
      s14 <= "0000000000000000000000000000000000";
      s15 <= "0000000000000000000000000000000000";
      s16 <= "0000000000000000000000000000000000";
      s17 <= "0000000000000000000000000000000000";
      s18 <= "0000000000000000000000000000000000";
      s19 <= "0000000000000000000000000000000000";
      s20 <= "0000000000000000000000000000000000";
      s21 <= "0000000000000000000000000000000000";
      s22 <= "0000000000000000000000000000000000";
      s23 <= "0000000000000000000000000000000000";
      s24 <= "0000000000000000000000000000000000";
      s25 <= "0000000000000000000000000000000000";
      s26 <= "0000000000000000000000000000000000";
      s27 <= "0000000000000000000000000000000000";
      s28 <= "0000000000000000000000000000000000";
      s29 <= "0000000000000000000000000000000000";
      s30 <= "0000000000000000000000000000000000";
      s31 <= "0000000000000000000000000000000000";
      s32 <= "0000000000000000000000000000000000";
      s33 <= "0000000000000000000000000000000000";
      s34 <= "0000000000000000000000000000000000";
      s35 <= "0000000000000000000000000000000000";
      s36 <= "0000000000000000000000000000000000";
      s37 <= "0000000000000000000000000000000000";
      s38 <= "0000000000000000000000000000000000";
      s39 <= "0000000000000000000000000000000000";
      s40 <= "0000000000000000000000000000000000";
      s41 <= "0000000000000000000000000000000000";
      s42 <= "0000000000000000000000000000000000";
      s43 <= "0000000000000000000000000000000000";
      s44 <= "0000000000000000000000000000000000";
      s45 <= "0000000000000000000000000000000000";
      s46 <= "0000000000000000000000000000000000";
      s47 <= "0000000000000000000000000000000000";
      s48 <= "0000000000000000000000000000000000";
      s49 <= "0000000000000000000000000000000000";
      s50 <= "0000000000000000000000000000000000";
      s51 <= "0000000000000000000000000000000000";
      s52 <= "0000000000000000000000000000000000";
      s53 <= "0000000000000000000000000000000000";
      s54 <= "0000000000000000000000000000000000";
      s55 <= "0000000000000000000000000000000000";
      s56 <= "0000000000000000000000000000000000";
      s57 <= "0000000000000000000000000000000000";
      s58 <= "0000000000000000000000000000000000";
      s59 <= "0000000000000000000000000000000000";
      s60 <= "0000000000000000000000000000000000";
      s61 <= "0000000000000000000000000000000000";
      s62 <= "0000000000000000000000000000000000";
      s63 <= "0000000000000000000000000000000000";
      s64 <= "0000000000000000000000000000000000";
      s65 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      s14 <= s13;
      s15 <= s14;
      s16 <= s15;
      s17 <= s16;
      s18 <= s17;
      s19 <= s18;
      s20 <= s19;
      s21 <= s20;
      s22 <= s21;
      s23 <= s22;
      s24 <= s23;
      s25 <= s24;
      s26 <= s25;
      s27 <= s26;
      s28 <= s27;
      s29 <= s28;
      s30 <= s29;
      s31 <= s30;
      s32 <= s31;
      s33 <= s32;
      s34 <= s33;
      s35 <= s34;
      s36 <= s35;
      s37 <= s36;
      s38 <= s37;
      s39 <= s38;
      s40 <= s39;
      s41 <= s40;
      s42 <= s41;
      s43 <= s42;
      s44 <= s43;
      s45 <= s44;
      s46 <= s45;
      s47 <= s46;
      s48 <= s47;
      s49 <= s48;
      s50 <= s49;
      s51 <= s50;
      s52 <= s51;
      s53 <= s52;
      s54 <= s53;
      s55 <= s54;
      s56 <= s55;
      s57 <= s56;
      s58 <= s57;
      s59 <= s58;
      s60 <= s59;
      s61 <= s60;
      s62 <= s61;
      s63 <= s62;
      s64 <= s63;
      s65 <= s64;
      Y <= s65;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--         GenericLut_LUTData_MUX_Product810_impl_0_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product810_impl_0_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product810_impl_0_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0101" when "0000",
      "0001" when "0001",
      "1001" when "0010",
      "0000" when "0011",
      "0111" when "0100",
      "1000" when "0101",
      "0011" when "0110",
      "0100" when "0111",
      "0000" when "1000",
      "0110" when "1001",
      "0010" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
--GenericLut_LUTData_MUX_Product810_impl_0_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product810_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product810_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Product810_impl_0_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product810_impl_0_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--         GenericLut_LUTData_MUX_Product810_impl_1_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product810_impl_1_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product810_impl_1_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0001" when "0000",
      "0000" when "0001",
      "0100" when "0010",
      "0011" when "0011",
      "1001" when "0100",
      "1000" when "0101",
      "0101" when "0110",
      "0110" when "0111",
      "0000" when "1000",
      "0111" when "1001",
      "0010" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
--GenericLut_LUTData_MUX_Product810_impl_1_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product810_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product810_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Product810_impl_1_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product810_impl_1_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--         GenericLut_LUTData_MUX_Product910_impl_0_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product910_impl_0_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product910_impl_0_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0011" when "0000",
      "0001" when "0001",
      "0000" when "0010",
      "1001" when "0011",
      "0110" when "0100",
      "0101" when "0101",
      "0010" when "0110",
      "0100" when "0111",
      "0000" when "1000",
      "0111" when "1001",
      "1000" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
--GenericLut_LUTData_MUX_Product910_impl_0_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product910_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product910_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Product910_impl_0_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product910_impl_0_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--         GenericLut_LUTData_MUX_Product910_impl_1_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product910_impl_1_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product910_impl_1_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0100" when "0000",
      "0010" when "0001",
      "0011" when "0010",
      "0001" when "0011",
      "1000" when "0100",
      "0111" when "0101",
      "0000" when "0110",
      "0110" when "0111",
      "0000" when "1000",
      "1001" when "1001",
      "0101" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
--GenericLut_LUTData_MUX_Product910_impl_1_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product910_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product910_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Product910_impl_1_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product910_impl_1_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--           GenericLut_LUTData_MUX_Add111_impl_0_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Add111_impl_0_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Add111_impl_0_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0010" when "0000",
      "0000" when "0001",
      "0110" when "0010",
      "1000" when "0011",
      "1001" when "0100",
      "0000" when "0101",
      "0100" when "0110",
      "0101" when "0111",
      "0001" when "1000",
      "0111" when "1001",
      "0011" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
--  GenericLut_LUTData_MUX_Add111_impl_0_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Add111_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Add111_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Add111_impl_0_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Add111_impl_0_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--           GenericLut_LUTData_MUX_Add111_impl_1_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Add111_impl_1_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Add111_impl_1_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0001" when "0000",
      "0000" when "0001",
      "0111" when "0010",
      "0011" when "0011",
      "1000" when "0100",
      "1001" when "0101",
      "0110" when "0110",
      "0010" when "0111",
      "0000" when "1000",
      "0100" when "1001",
      "0101" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
--  GenericLut_LUTData_MUX_Add111_impl_1_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Add111_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Add111_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Add111_impl_1_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Add111_impl_1_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--           GenericLut_LUTData_MUX_Add210_impl_0_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Add210_impl_0_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Add210_impl_0_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0101" when "0000",
      "0000" when "0001",
      "0010" when "0010",
      "0110" when "0011",
      "1001" when "0100",
      "0000" when "0101",
      "0111" when "0110",
      "0011" when "0111",
      "0001" when "1000",
      "1000" when "1001",
      "0100" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
--  GenericLut_LUTData_MUX_Add210_impl_0_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Add210_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Add210_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Add210_impl_0_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Add210_impl_0_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--           GenericLut_LUTData_MUX_Add210_impl_1_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Add210_impl_1_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Add210_impl_1_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "1000" when "0000",
      "0000" when "0001",
      "0000" when "0010",
      "0100" when "0011",
      "0101" when "0100",
      "1001" when "0101",
      "0111" when "0110",
      "0010" when "0111",
      "0001" when "1000",
      "0110" when "1001",
      "0011" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
--  GenericLut_LUTData_MUX_Add210_impl_1_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Add210_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Add210_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Add210_impl_1_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Add210_impl_1_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--         GenericLut_LUTData_MUX_Product312_impl_0_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product312_impl_0_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product312_impl_0_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0011" when "0000",
      "0010" when "0001",
      "0000" when "0010",
      "0001" when "0011",
      "0110" when "0100",
      "1000" when "0101",
      "0100" when "0110",
      "0101" when "0111",
      "0000" when "1000",
      "0111" when "1001",
      "1001" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
--GenericLut_LUTData_MUX_Product312_impl_0_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product312_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product312_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Product312_impl_0_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product312_impl_0_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--         GenericLut_LUTData_MUX_Product312_impl_1_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product312_impl_1_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product312_impl_1_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0001" when "0000",
      "0000" when "0001",
      "0010" when "0010",
      "0011" when "0011",
      "0111" when "0100",
      "1001" when "0101",
      "0101" when "0110",
      "0110" when "0111",
      "0000" when "1000",
      "1000" when "1001",
      "0100" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
--GenericLut_LUTData_MUX_Product312_impl_1_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product312_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product312_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Product312_impl_1_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product312_impl_1_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--          GenericLut_LUTData_MUX_Product73_impl_0_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product73_impl_0_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product73_impl_0_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "1001" when "0000",
      "0000" when "0001",
      "0110" when "0010",
      "0010" when "0011",
      "1000" when "0100",
      "0111" when "0101",
      "0100" when "0110",
      "0011" when "0111",
      "0000" when "1000",
      "0101" when "1001",
      "0001" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
-- GenericLut_LUTData_MUX_Product73_impl_0_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product73_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product73_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Product73_impl_0_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product73_impl_0_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--          GenericLut_LUTData_MUX_Product73_impl_1_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product73_impl_1_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product73_impl_1_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0010" when "0000",
      "0001" when "0001",
      "0111" when "0010",
      "0000" when "0011",
      "0011" when "0100",
      "1001" when "0101",
      "0110" when "0110",
      "0101" when "0111",
      "0000" when "1000",
      "1000" when "1001",
      "0100" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
-- GenericLut_LUTData_MUX_Product73_impl_1_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product73_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product73_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Product73_impl_1_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product73_impl_1_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--          GenericLut_LUTData_MUX_Product84_impl_0_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product84_impl_0_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product84_impl_0_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "1000" when "0000",
      "0001" when "0001",
      "0000" when "0010",
      "0111" when "0011",
      "0100" when "0100",
      "0101" when "0101",
      "0011" when "0110",
      "0010" when "0111",
      "0000" when "1000",
      "0110" when "1001",
      "1001" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
-- GenericLut_LUTData_MUX_Product84_impl_0_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product84_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product84_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Product84_impl_0_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product84_impl_0_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--          GenericLut_LUTData_MUX_Product84_impl_1_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product84_impl_1_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product84_impl_1_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0001" when "0000",
      "1001" when "0001",
      "0000" when "0010",
      "0110" when "0011",
      "0111" when "0100",
      "0101" when "0101",
      "0100" when "0110",
      "0011" when "0111",
      "0000" when "1000",
      "1000" when "1001",
      "0010" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
-- GenericLut_LUTData_MUX_Product84_impl_1_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product84_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product84_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Product84_impl_1_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product84_impl_1_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--          GenericLut_LUTData_MUX_Product85_impl_0_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product85_impl_0_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product85_impl_0_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0000" when "0000",
      "0011" when "0001",
      "0010" when "0010",
      "0000" when "0011",
      "0001" when "0100",
      "0110" when "0101",
      "0100" when "0110",
      "0101" when "0111",
      "0000" when "1000",
      "0111" when "1001",
      "1000" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
-- GenericLut_LUTData_MUX_Product85_impl_0_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product85_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product85_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Product85_impl_0_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product85_impl_0_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--          GenericLut_LUTData_MUX_Product85_impl_1_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product85_impl_1_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product85_impl_1_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0011" when "0000",
      "1000" when "0001",
      "0001" when "0010",
      "0000" when "0011",
      "0000" when "0100",
      "0100" when "0101",
      "0101" when "0110",
      "0110" when "0111",
      "0000" when "1000",
      "0111" when "1001",
      "0010" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
-- GenericLut_LUTData_MUX_Product85_impl_1_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product85_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product85_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Product85_impl_1_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product85_impl_1_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--          GenericLut_LUTData_MUX_Product99_impl_0_LUT_wIn_4_wOut_3
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product99_impl_0_LUT_wIn_4_wOut_3 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product99_impl_0_LUT_wIn_4_wOut_3 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(2 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "110" when "0000",
      "001" when "0001",
      "111" when "0010",
      "000" when "0011",
      "010" when "0100",
      "100" when "0101",
      "000" when "0110",
      "011" when "0111",
      "000" when "1000",
      "101" when "1001",
      "000" when "1010",
      "000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
end architecture;

--------------------------------------------------------------------------------
-- GenericLut_LUTData_MUX_Product99_impl_0_LUT_wIn_4_wOut_3_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product99_impl_0_LUT_wIn_4_wOut_3_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(2 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product99_impl_0_LUT_wIn_4_wOut_3_wrapper_component is
   component GenericLut_LUTData_MUX_Product99_impl_0_LUT_wIn_4_wOut_3 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product99_impl_0_LUT_wIn_4_wOut_3
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;

end architecture;

--------------------------------------------------------------------------------
--          GenericLut_LUTData_MUX_Product99_impl_1_LUT_wIn_4_wOut_3
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product99_impl_1_LUT_wIn_4_wOut_3 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product99_impl_1_LUT_wIn_4_wOut_3 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(2 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "000" when "0000",
      "111" when "0001",
      "001" when "0010",
      "000" when "0011",
      "011" when "0100",
      "101" when "0101",
      "000" when "0110",
      "100" when "0111",
      "000" when "1000",
      "110" when "1001",
      "010" when "1010",
      "000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
end architecture;

--------------------------------------------------------------------------------
-- GenericLut_LUTData_MUX_Product99_impl_1_LUT_wIn_4_wOut_3_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Product99_impl_1_LUT_wIn_4_wOut_3_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(2 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Product99_impl_1_LUT_wIn_4_wOut_3_wrapper_component is
   component GenericLut_LUTData_MUX_Product99_impl_1_LUT_wIn_4_wOut_3 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Product99_impl_1_LUT_wIn_4_wOut_3
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;

end architecture;

--------------------------------------------------------------------------------
--         GenericLut_LUTData_MUX_Subtract12_impl_0_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Subtract12_impl_0_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Subtract12_impl_0_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0000" when "0000",
      "0101" when "0001",
      "1000" when "0010",
      "0000" when "0011",
      "0111" when "0100",
      "0010" when "0101",
      "0000" when "0110",
      "0100" when "0111",
      "0110" when "1000",
      "0011" when "1001",
      "0001" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
--GenericLut_LUTData_MUX_Subtract12_impl_0_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Subtract12_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Subtract12_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Subtract12_impl_0_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Subtract12_impl_0_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--         GenericLut_LUTData_MUX_Subtract12_impl_1_LUT_wIn_4_wOut_4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Subtract12_impl_1_LUT_wIn_4_wOut_4 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic;
          o3 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Subtract12_impl_1_LUT_wIn_4_wOut_4 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(3 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "0000" when "0000",
      "1000" when "0001",
      "0100" when "0010",
      "0101" when "0011",
      "0010" when "0100",
      "0110" when "0101",
      "0000" when "0110",
      "0000" when "0111",
      "0001" when "1000",
      "0111" when "1001",
      "0011" when "1010",
      "0000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
   o3 <= t_out(3);
end architecture;

--------------------------------------------------------------------------------
--GenericLut_LUTData_MUX_Subtract12_impl_1_LUT_wIn_4_wOut_4_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Subtract12_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(3 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Subtract12_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
   component GenericLut_LUTData_MUX_Subtract12_impl_1_LUT_wIn_4_wOut_4 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic;
             o3 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
signal Output3_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Subtract12_impl_1_LUT_wIn_4_wOut_4
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp,
                 o3 => Output3_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;
Output(3) <= Output3_temp;

end architecture;

--------------------------------------------------------------------------------
--          GenericLut_LUTData_MUX_Subtract7_impl_0_LUT_wIn_4_wOut_2
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Subtract7_impl_0_LUT_wIn_4_wOut_2 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Subtract7_impl_0_LUT_wIn_4_wOut_2 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(1 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "00" when "0000",
      "00" when "0001",
      "00" when "0010",
      "00" when "0011",
      "00" when "0100",
      "10" when "0101",
      "00" when "0110",
      "11" when "0111",
      "00" when "1000",
      "01" when "1001",
      "00" when "1010",
      "00" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
end architecture;

--------------------------------------------------------------------------------
-- GenericLut_LUTData_MUX_Subtract7_impl_0_LUT_wIn_4_wOut_2_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Subtract7_impl_0_LUT_wIn_4_wOut_2_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(1 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Subtract7_impl_0_LUT_wIn_4_wOut_2_wrapper_component is
   component GenericLut_LUTData_MUX_Subtract7_impl_0_LUT_wIn_4_wOut_2 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Subtract7_impl_0_LUT_wIn_4_wOut_2
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;

end architecture;

--------------------------------------------------------------------------------
--          GenericLut_LUTData_MUX_Subtract7_impl_1_LUT_wIn_4_wOut_2
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Subtract7_impl_1_LUT_wIn_4_wOut_2 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Subtract7_impl_1_LUT_wIn_4_wOut_2 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(1 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "00" when "0000",
      "00" when "0001",
      "00" when "0010",
      "00" when "0011",
      "00" when "0100",
      "10" when "0101",
      "00" when "0110",
      "11" when "0111",
      "00" when "1000",
      "01" when "1001",
      "00" when "1010",
      "00" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
end architecture;

--------------------------------------------------------------------------------
-- GenericLut_LUTData_MUX_Subtract7_impl_1_LUT_wIn_4_wOut_2_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Subtract7_impl_1_LUT_wIn_4_wOut_2_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(1 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Subtract7_impl_1_LUT_wIn_4_wOut_2_wrapper_component is
   component GenericLut_LUTData_MUX_Subtract7_impl_1_LUT_wIn_4_wOut_2 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Subtract7_impl_1_LUT_wIn_4_wOut_2
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;

end architecture;

--------------------------------------------------------------------------------
--            GenericLut_LUTData_MUX_Add32_impl_0_LUT_wIn_4_wOut_3
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Add32_impl_0_LUT_wIn_4_wOut_3 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Add32_impl_0_LUT_wIn_4_wOut_3 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(2 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "110" when "0000",
      "000" when "0001",
      "001" when "0010",
      "011" when "0011",
      "000" when "0100",
      "000" when "0101",
      "000" when "0110",
      "000" when "0111",
      "010" when "1000",
      "101" when "1001",
      "100" when "1010",
      "000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
end architecture;

--------------------------------------------------------------------------------
--   GenericLut_LUTData_MUX_Add32_impl_0_LUT_wIn_4_wOut_3_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Add32_impl_0_LUT_wIn_4_wOut_3_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(2 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Add32_impl_0_LUT_wIn_4_wOut_3_wrapper_component is
   component GenericLut_LUTData_MUX_Add32_impl_0_LUT_wIn_4_wOut_3 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Add32_impl_0_LUT_wIn_4_wOut_3
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;

end architecture;

--------------------------------------------------------------------------------
--            GenericLut_LUTData_MUX_Add32_impl_1_LUT_wIn_4_wOut_3
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
-- >> University of Kassel, Germany
-- >> Digital Technology Group
-- >> Author(s):
-- >> Marco Kleinlein <kleinlein@uni-kassel.de>
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Add32_impl_1_LUT_wIn_4_wOut_3 is
   port ( i0 : in std_logic;
          i1 : in std_logic;
          i2 : in std_logic;
          i3 : in std_logic;
          o0 : out std_logic;
          o1 : out std_logic;
          o2 : out std_logic   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Add32_impl_1_LUT_wIn_4_wOut_3 is
signal t_in : std_logic_vector(3 downto 0) := (others => '0');
signal t_out : std_logic_vector(2 downto 0) := (others => '0');
begin
   t_in(0) <= i0;
   t_in(1) <= i1;
   t_in(2) <= i2;
   t_in(3) <= i3;
   with t_in select t_out <= 
      "101" when "0000",
      "000" when "0001",
      "100" when "0010",
      "000" when "0011",
      "000" when "0100",
      "110" when "0101",
      "000" when "0110",
      "000" when "0111",
      "011" when "1000",
      "010" when "1001",
      "001" when "1010",
      "000" when others;

   o0 <= t_out(0);
   o1 <= t_out(1);
   o2 <= t_out(2);
end architecture;

--------------------------------------------------------------------------------
--   GenericLut_LUTData_MUX_Add32_impl_1_LUT_wIn_4_wOut_3_wrapper_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity GenericLut_LUTData_MUX_Add32_impl_1_LUT_wIn_4_wOut_3_wrapper_component is
   port ( clk, rst : in std_logic;
          Input : in std_logic_vector(3 downto 0);
          Output : out std_logic_vector(2 downto 0)   );
end entity;

architecture arch of GenericLut_LUTData_MUX_Add32_impl_1_LUT_wIn_4_wOut_3_wrapper_component is
   component GenericLut_LUTData_MUX_Add32_impl_1_LUT_wIn_4_wOut_3 is
      port ( i0 : in std_logic;
             i1 : in std_logic;
             i2 : in std_logic;
             i3 : in std_logic;
             o0 : out std_logic;
             o1 : out std_logic;
             o2 : out std_logic   );
   end component;

signal Input0_out : std_logic := '0';
signal Input1_out : std_logic := '0';
signal Input2_out : std_logic := '0';
signal Input3_out : std_logic := '0';
signal Output0_temp : std_logic := '0';
signal Output1_temp : std_logic := '0';
signal Output2_temp : std_logic := '0';
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
Input0_out <= Input(0);
Input1_out <= Input(1);
Input2_out <= Input(2);
Input3_out <= Input(3);
   instLUT: GenericLut_LUTData_MUX_Add32_impl_1_LUT_wIn_4_wOut_3
      port map ( i0 => Input0_out,
                 i1 => Input1_out,
                 i2 => Input2_out,
                 i3 => Input3_out,
                 o0 => Output0_temp,
                 o1 => Output1_temp,
                 o2 => Output2_temp);
   ----------------Synchro barrier, entering cycle 0----------------
Output(0) <= Output0_temp;
Output(1) <= Output1_temp;
Output(2) <= Output2_temp;

end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_6_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 6 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_6_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_6_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      Y <= s5;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_10_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 10 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_10_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_10_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      Y <= s9;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_12_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 12 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_12_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_12_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      Y <= s11;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_18_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 18 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_18_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_18_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
signal s14 : std_logic_vector(33 downto 0) := (others => '0');
signal s15 : std_logic_vector(33 downto 0) := (others => '0');
signal s16 : std_logic_vector(33 downto 0) := (others => '0');
signal s17 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
      s14 <= "0000000000000000000000000000000000";
      s15 <= "0000000000000000000000000000000000";
      s16 <= "0000000000000000000000000000000000";
      s17 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      s14 <= s13;
      s15 <= s14;
      s16 <= s15;
      s17 <= s16;
      Y <= s17;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_15_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 15 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_15_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_15_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
signal s14 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
      s14 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      s14 <= s13;
      Y <= s14;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_74_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 74 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_74_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_74_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
signal s14 : std_logic_vector(33 downto 0) := (others => '0');
signal s15 : std_logic_vector(33 downto 0) := (others => '0');
signal s16 : std_logic_vector(33 downto 0) := (others => '0');
signal s17 : std_logic_vector(33 downto 0) := (others => '0');
signal s18 : std_logic_vector(33 downto 0) := (others => '0');
signal s19 : std_logic_vector(33 downto 0) := (others => '0');
signal s20 : std_logic_vector(33 downto 0) := (others => '0');
signal s21 : std_logic_vector(33 downto 0) := (others => '0');
signal s22 : std_logic_vector(33 downto 0) := (others => '0');
signal s23 : std_logic_vector(33 downto 0) := (others => '0');
signal s24 : std_logic_vector(33 downto 0) := (others => '0');
signal s25 : std_logic_vector(33 downto 0) := (others => '0');
signal s26 : std_logic_vector(33 downto 0) := (others => '0');
signal s27 : std_logic_vector(33 downto 0) := (others => '0');
signal s28 : std_logic_vector(33 downto 0) := (others => '0');
signal s29 : std_logic_vector(33 downto 0) := (others => '0');
signal s30 : std_logic_vector(33 downto 0) := (others => '0');
signal s31 : std_logic_vector(33 downto 0) := (others => '0');
signal s32 : std_logic_vector(33 downto 0) := (others => '0');
signal s33 : std_logic_vector(33 downto 0) := (others => '0');
signal s34 : std_logic_vector(33 downto 0) := (others => '0');
signal s35 : std_logic_vector(33 downto 0) := (others => '0');
signal s36 : std_logic_vector(33 downto 0) := (others => '0');
signal s37 : std_logic_vector(33 downto 0) := (others => '0');
signal s38 : std_logic_vector(33 downto 0) := (others => '0');
signal s39 : std_logic_vector(33 downto 0) := (others => '0');
signal s40 : std_logic_vector(33 downto 0) := (others => '0');
signal s41 : std_logic_vector(33 downto 0) := (others => '0');
signal s42 : std_logic_vector(33 downto 0) := (others => '0');
signal s43 : std_logic_vector(33 downto 0) := (others => '0');
signal s44 : std_logic_vector(33 downto 0) := (others => '0');
signal s45 : std_logic_vector(33 downto 0) := (others => '0');
signal s46 : std_logic_vector(33 downto 0) := (others => '0');
signal s47 : std_logic_vector(33 downto 0) := (others => '0');
signal s48 : std_logic_vector(33 downto 0) := (others => '0');
signal s49 : std_logic_vector(33 downto 0) := (others => '0');
signal s50 : std_logic_vector(33 downto 0) := (others => '0');
signal s51 : std_logic_vector(33 downto 0) := (others => '0');
signal s52 : std_logic_vector(33 downto 0) := (others => '0');
signal s53 : std_logic_vector(33 downto 0) := (others => '0');
signal s54 : std_logic_vector(33 downto 0) := (others => '0');
signal s55 : std_logic_vector(33 downto 0) := (others => '0');
signal s56 : std_logic_vector(33 downto 0) := (others => '0');
signal s57 : std_logic_vector(33 downto 0) := (others => '0');
signal s58 : std_logic_vector(33 downto 0) := (others => '0');
signal s59 : std_logic_vector(33 downto 0) := (others => '0');
signal s60 : std_logic_vector(33 downto 0) := (others => '0');
signal s61 : std_logic_vector(33 downto 0) := (others => '0');
signal s62 : std_logic_vector(33 downto 0) := (others => '0');
signal s63 : std_logic_vector(33 downto 0) := (others => '0');
signal s64 : std_logic_vector(33 downto 0) := (others => '0');
signal s65 : std_logic_vector(33 downto 0) := (others => '0');
signal s66 : std_logic_vector(33 downto 0) := (others => '0');
signal s67 : std_logic_vector(33 downto 0) := (others => '0');
signal s68 : std_logic_vector(33 downto 0) := (others => '0');
signal s69 : std_logic_vector(33 downto 0) := (others => '0');
signal s70 : std_logic_vector(33 downto 0) := (others => '0');
signal s71 : std_logic_vector(33 downto 0) := (others => '0');
signal s72 : std_logic_vector(33 downto 0) := (others => '0');
signal s73 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
      s14 <= "0000000000000000000000000000000000";
      s15 <= "0000000000000000000000000000000000";
      s16 <= "0000000000000000000000000000000000";
      s17 <= "0000000000000000000000000000000000";
      s18 <= "0000000000000000000000000000000000";
      s19 <= "0000000000000000000000000000000000";
      s20 <= "0000000000000000000000000000000000";
      s21 <= "0000000000000000000000000000000000";
      s22 <= "0000000000000000000000000000000000";
      s23 <= "0000000000000000000000000000000000";
      s24 <= "0000000000000000000000000000000000";
      s25 <= "0000000000000000000000000000000000";
      s26 <= "0000000000000000000000000000000000";
      s27 <= "0000000000000000000000000000000000";
      s28 <= "0000000000000000000000000000000000";
      s29 <= "0000000000000000000000000000000000";
      s30 <= "0000000000000000000000000000000000";
      s31 <= "0000000000000000000000000000000000";
      s32 <= "0000000000000000000000000000000000";
      s33 <= "0000000000000000000000000000000000";
      s34 <= "0000000000000000000000000000000000";
      s35 <= "0000000000000000000000000000000000";
      s36 <= "0000000000000000000000000000000000";
      s37 <= "0000000000000000000000000000000000";
      s38 <= "0000000000000000000000000000000000";
      s39 <= "0000000000000000000000000000000000";
      s40 <= "0000000000000000000000000000000000";
      s41 <= "0000000000000000000000000000000000";
      s42 <= "0000000000000000000000000000000000";
      s43 <= "0000000000000000000000000000000000";
      s44 <= "0000000000000000000000000000000000";
      s45 <= "0000000000000000000000000000000000";
      s46 <= "0000000000000000000000000000000000";
      s47 <= "0000000000000000000000000000000000";
      s48 <= "0000000000000000000000000000000000";
      s49 <= "0000000000000000000000000000000000";
      s50 <= "0000000000000000000000000000000000";
      s51 <= "0000000000000000000000000000000000";
      s52 <= "0000000000000000000000000000000000";
      s53 <= "0000000000000000000000000000000000";
      s54 <= "0000000000000000000000000000000000";
      s55 <= "0000000000000000000000000000000000";
      s56 <= "0000000000000000000000000000000000";
      s57 <= "0000000000000000000000000000000000";
      s58 <= "0000000000000000000000000000000000";
      s59 <= "0000000000000000000000000000000000";
      s60 <= "0000000000000000000000000000000000";
      s61 <= "0000000000000000000000000000000000";
      s62 <= "0000000000000000000000000000000000";
      s63 <= "0000000000000000000000000000000000";
      s64 <= "0000000000000000000000000000000000";
      s65 <= "0000000000000000000000000000000000";
      s66 <= "0000000000000000000000000000000000";
      s67 <= "0000000000000000000000000000000000";
      s68 <= "0000000000000000000000000000000000";
      s69 <= "0000000000000000000000000000000000";
      s70 <= "0000000000000000000000000000000000";
      s71 <= "0000000000000000000000000000000000";
      s72 <= "0000000000000000000000000000000000";
      s73 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      s14 <= s13;
      s15 <= s14;
      s16 <= s15;
      s17 <= s16;
      s18 <= s17;
      s19 <= s18;
      s20 <= s19;
      s21 <= s20;
      s22 <= s21;
      s23 <= s22;
      s24 <= s23;
      s25 <= s24;
      s26 <= s25;
      s27 <= s26;
      s28 <= s27;
      s29 <= s28;
      s30 <= s29;
      s31 <= s30;
      s32 <= s31;
      s33 <= s32;
      s34 <= s33;
      s35 <= s34;
      s36 <= s35;
      s37 <= s36;
      s38 <= s37;
      s39 <= s38;
      s40 <= s39;
      s41 <= s40;
      s42 <= s41;
      s43 <= s42;
      s44 <= s43;
      s45 <= s44;
      s46 <= s45;
      s47 <= s46;
      s48 <= s47;
      s49 <= s48;
      s50 <= s49;
      s51 <= s50;
      s52 <= s51;
      s53 <= s52;
      s54 <= s53;
      s55 <= s54;
      s56 <= s55;
      s57 <= s56;
      s58 <= s57;
      s59 <= s58;
      s60 <= s59;
      s61 <= s60;
      s62 <= s61;
      s63 <= s62;
      s64 <= s63;
      s65 <= s64;
      s66 <= s65;
      s67 <= s66;
      s68 <= s67;
      s69 <= s68;
      s70 <= s69;
      s71 <= s70;
      s72 <= s71;
      s73 <= s72;
      Y <= s73;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_57_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 57 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_57_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_57_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
signal s14 : std_logic_vector(33 downto 0) := (others => '0');
signal s15 : std_logic_vector(33 downto 0) := (others => '0');
signal s16 : std_logic_vector(33 downto 0) := (others => '0');
signal s17 : std_logic_vector(33 downto 0) := (others => '0');
signal s18 : std_logic_vector(33 downto 0) := (others => '0');
signal s19 : std_logic_vector(33 downto 0) := (others => '0');
signal s20 : std_logic_vector(33 downto 0) := (others => '0');
signal s21 : std_logic_vector(33 downto 0) := (others => '0');
signal s22 : std_logic_vector(33 downto 0) := (others => '0');
signal s23 : std_logic_vector(33 downto 0) := (others => '0');
signal s24 : std_logic_vector(33 downto 0) := (others => '0');
signal s25 : std_logic_vector(33 downto 0) := (others => '0');
signal s26 : std_logic_vector(33 downto 0) := (others => '0');
signal s27 : std_logic_vector(33 downto 0) := (others => '0');
signal s28 : std_logic_vector(33 downto 0) := (others => '0');
signal s29 : std_logic_vector(33 downto 0) := (others => '0');
signal s30 : std_logic_vector(33 downto 0) := (others => '0');
signal s31 : std_logic_vector(33 downto 0) := (others => '0');
signal s32 : std_logic_vector(33 downto 0) := (others => '0');
signal s33 : std_logic_vector(33 downto 0) := (others => '0');
signal s34 : std_logic_vector(33 downto 0) := (others => '0');
signal s35 : std_logic_vector(33 downto 0) := (others => '0');
signal s36 : std_logic_vector(33 downto 0) := (others => '0');
signal s37 : std_logic_vector(33 downto 0) := (others => '0');
signal s38 : std_logic_vector(33 downto 0) := (others => '0');
signal s39 : std_logic_vector(33 downto 0) := (others => '0');
signal s40 : std_logic_vector(33 downto 0) := (others => '0');
signal s41 : std_logic_vector(33 downto 0) := (others => '0');
signal s42 : std_logic_vector(33 downto 0) := (others => '0');
signal s43 : std_logic_vector(33 downto 0) := (others => '0');
signal s44 : std_logic_vector(33 downto 0) := (others => '0');
signal s45 : std_logic_vector(33 downto 0) := (others => '0');
signal s46 : std_logic_vector(33 downto 0) := (others => '0');
signal s47 : std_logic_vector(33 downto 0) := (others => '0');
signal s48 : std_logic_vector(33 downto 0) := (others => '0');
signal s49 : std_logic_vector(33 downto 0) := (others => '0');
signal s50 : std_logic_vector(33 downto 0) := (others => '0');
signal s51 : std_logic_vector(33 downto 0) := (others => '0');
signal s52 : std_logic_vector(33 downto 0) := (others => '0');
signal s53 : std_logic_vector(33 downto 0) := (others => '0');
signal s54 : std_logic_vector(33 downto 0) := (others => '0');
signal s55 : std_logic_vector(33 downto 0) := (others => '0');
signal s56 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
      s14 <= "0000000000000000000000000000000000";
      s15 <= "0000000000000000000000000000000000";
      s16 <= "0000000000000000000000000000000000";
      s17 <= "0000000000000000000000000000000000";
      s18 <= "0000000000000000000000000000000000";
      s19 <= "0000000000000000000000000000000000";
      s20 <= "0000000000000000000000000000000000";
      s21 <= "0000000000000000000000000000000000";
      s22 <= "0000000000000000000000000000000000";
      s23 <= "0000000000000000000000000000000000";
      s24 <= "0000000000000000000000000000000000";
      s25 <= "0000000000000000000000000000000000";
      s26 <= "0000000000000000000000000000000000";
      s27 <= "0000000000000000000000000000000000";
      s28 <= "0000000000000000000000000000000000";
      s29 <= "0000000000000000000000000000000000";
      s30 <= "0000000000000000000000000000000000";
      s31 <= "0000000000000000000000000000000000";
      s32 <= "0000000000000000000000000000000000";
      s33 <= "0000000000000000000000000000000000";
      s34 <= "0000000000000000000000000000000000";
      s35 <= "0000000000000000000000000000000000";
      s36 <= "0000000000000000000000000000000000";
      s37 <= "0000000000000000000000000000000000";
      s38 <= "0000000000000000000000000000000000";
      s39 <= "0000000000000000000000000000000000";
      s40 <= "0000000000000000000000000000000000";
      s41 <= "0000000000000000000000000000000000";
      s42 <= "0000000000000000000000000000000000";
      s43 <= "0000000000000000000000000000000000";
      s44 <= "0000000000000000000000000000000000";
      s45 <= "0000000000000000000000000000000000";
      s46 <= "0000000000000000000000000000000000";
      s47 <= "0000000000000000000000000000000000";
      s48 <= "0000000000000000000000000000000000";
      s49 <= "0000000000000000000000000000000000";
      s50 <= "0000000000000000000000000000000000";
      s51 <= "0000000000000000000000000000000000";
      s52 <= "0000000000000000000000000000000000";
      s53 <= "0000000000000000000000000000000000";
      s54 <= "0000000000000000000000000000000000";
      s55 <= "0000000000000000000000000000000000";
      s56 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      s14 <= s13;
      s15 <= s14;
      s16 <= s15;
      s17 <= s16;
      s18 <= s17;
      s19 <= s18;
      s20 <= s19;
      s21 <= s20;
      s22 <= s21;
      s23 <= s22;
      s24 <= s23;
      s25 <= s24;
      s26 <= s25;
      s27 <= s26;
      s28 <= s27;
      s29 <= s28;
      s30 <= s29;
      s31 <= s30;
      s32 <= s31;
      s33 <= s32;
      s34 <= s33;
      s35 <= s34;
      s36 <= s35;
      s37 <= s36;
      s38 <= s37;
      s39 <= s38;
      s40 <= s39;
      s41 <= s40;
      s42 <= s41;
      s43 <= s42;
      s44 <= s43;
      s45 <= s44;
      s46 <= s45;
      s47 <= s46;
      s48 <= s47;
      s49 <= s48;
      s50 <= s49;
      s51 <= s50;
      s52 <= s51;
      s53 <= s52;
      s54 <= s53;
      s55 <= s54;
      s56 <= s55;
      Y <= s56;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_78_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 78 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_78_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_78_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
signal s14 : std_logic_vector(33 downto 0) := (others => '0');
signal s15 : std_logic_vector(33 downto 0) := (others => '0');
signal s16 : std_logic_vector(33 downto 0) := (others => '0');
signal s17 : std_logic_vector(33 downto 0) := (others => '0');
signal s18 : std_logic_vector(33 downto 0) := (others => '0');
signal s19 : std_logic_vector(33 downto 0) := (others => '0');
signal s20 : std_logic_vector(33 downto 0) := (others => '0');
signal s21 : std_logic_vector(33 downto 0) := (others => '0');
signal s22 : std_logic_vector(33 downto 0) := (others => '0');
signal s23 : std_logic_vector(33 downto 0) := (others => '0');
signal s24 : std_logic_vector(33 downto 0) := (others => '0');
signal s25 : std_logic_vector(33 downto 0) := (others => '0');
signal s26 : std_logic_vector(33 downto 0) := (others => '0');
signal s27 : std_logic_vector(33 downto 0) := (others => '0');
signal s28 : std_logic_vector(33 downto 0) := (others => '0');
signal s29 : std_logic_vector(33 downto 0) := (others => '0');
signal s30 : std_logic_vector(33 downto 0) := (others => '0');
signal s31 : std_logic_vector(33 downto 0) := (others => '0');
signal s32 : std_logic_vector(33 downto 0) := (others => '0');
signal s33 : std_logic_vector(33 downto 0) := (others => '0');
signal s34 : std_logic_vector(33 downto 0) := (others => '0');
signal s35 : std_logic_vector(33 downto 0) := (others => '0');
signal s36 : std_logic_vector(33 downto 0) := (others => '0');
signal s37 : std_logic_vector(33 downto 0) := (others => '0');
signal s38 : std_logic_vector(33 downto 0) := (others => '0');
signal s39 : std_logic_vector(33 downto 0) := (others => '0');
signal s40 : std_logic_vector(33 downto 0) := (others => '0');
signal s41 : std_logic_vector(33 downto 0) := (others => '0');
signal s42 : std_logic_vector(33 downto 0) := (others => '0');
signal s43 : std_logic_vector(33 downto 0) := (others => '0');
signal s44 : std_logic_vector(33 downto 0) := (others => '0');
signal s45 : std_logic_vector(33 downto 0) := (others => '0');
signal s46 : std_logic_vector(33 downto 0) := (others => '0');
signal s47 : std_logic_vector(33 downto 0) := (others => '0');
signal s48 : std_logic_vector(33 downto 0) := (others => '0');
signal s49 : std_logic_vector(33 downto 0) := (others => '0');
signal s50 : std_logic_vector(33 downto 0) := (others => '0');
signal s51 : std_logic_vector(33 downto 0) := (others => '0');
signal s52 : std_logic_vector(33 downto 0) := (others => '0');
signal s53 : std_logic_vector(33 downto 0) := (others => '0');
signal s54 : std_logic_vector(33 downto 0) := (others => '0');
signal s55 : std_logic_vector(33 downto 0) := (others => '0');
signal s56 : std_logic_vector(33 downto 0) := (others => '0');
signal s57 : std_logic_vector(33 downto 0) := (others => '0');
signal s58 : std_logic_vector(33 downto 0) := (others => '0');
signal s59 : std_logic_vector(33 downto 0) := (others => '0');
signal s60 : std_logic_vector(33 downto 0) := (others => '0');
signal s61 : std_logic_vector(33 downto 0) := (others => '0');
signal s62 : std_logic_vector(33 downto 0) := (others => '0');
signal s63 : std_logic_vector(33 downto 0) := (others => '0');
signal s64 : std_logic_vector(33 downto 0) := (others => '0');
signal s65 : std_logic_vector(33 downto 0) := (others => '0');
signal s66 : std_logic_vector(33 downto 0) := (others => '0');
signal s67 : std_logic_vector(33 downto 0) := (others => '0');
signal s68 : std_logic_vector(33 downto 0) := (others => '0');
signal s69 : std_logic_vector(33 downto 0) := (others => '0');
signal s70 : std_logic_vector(33 downto 0) := (others => '0');
signal s71 : std_logic_vector(33 downto 0) := (others => '0');
signal s72 : std_logic_vector(33 downto 0) := (others => '0');
signal s73 : std_logic_vector(33 downto 0) := (others => '0');
signal s74 : std_logic_vector(33 downto 0) := (others => '0');
signal s75 : std_logic_vector(33 downto 0) := (others => '0');
signal s76 : std_logic_vector(33 downto 0) := (others => '0');
signal s77 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
      s14 <= "0000000000000000000000000000000000";
      s15 <= "0000000000000000000000000000000000";
      s16 <= "0000000000000000000000000000000000";
      s17 <= "0000000000000000000000000000000000";
      s18 <= "0000000000000000000000000000000000";
      s19 <= "0000000000000000000000000000000000";
      s20 <= "0000000000000000000000000000000000";
      s21 <= "0000000000000000000000000000000000";
      s22 <= "0000000000000000000000000000000000";
      s23 <= "0000000000000000000000000000000000";
      s24 <= "0000000000000000000000000000000000";
      s25 <= "0000000000000000000000000000000000";
      s26 <= "0000000000000000000000000000000000";
      s27 <= "0000000000000000000000000000000000";
      s28 <= "0000000000000000000000000000000000";
      s29 <= "0000000000000000000000000000000000";
      s30 <= "0000000000000000000000000000000000";
      s31 <= "0000000000000000000000000000000000";
      s32 <= "0000000000000000000000000000000000";
      s33 <= "0000000000000000000000000000000000";
      s34 <= "0000000000000000000000000000000000";
      s35 <= "0000000000000000000000000000000000";
      s36 <= "0000000000000000000000000000000000";
      s37 <= "0000000000000000000000000000000000";
      s38 <= "0000000000000000000000000000000000";
      s39 <= "0000000000000000000000000000000000";
      s40 <= "0000000000000000000000000000000000";
      s41 <= "0000000000000000000000000000000000";
      s42 <= "0000000000000000000000000000000000";
      s43 <= "0000000000000000000000000000000000";
      s44 <= "0000000000000000000000000000000000";
      s45 <= "0000000000000000000000000000000000";
      s46 <= "0000000000000000000000000000000000";
      s47 <= "0000000000000000000000000000000000";
      s48 <= "0000000000000000000000000000000000";
      s49 <= "0000000000000000000000000000000000";
      s50 <= "0000000000000000000000000000000000";
      s51 <= "0000000000000000000000000000000000";
      s52 <= "0000000000000000000000000000000000";
      s53 <= "0000000000000000000000000000000000";
      s54 <= "0000000000000000000000000000000000";
      s55 <= "0000000000000000000000000000000000";
      s56 <= "0000000000000000000000000000000000";
      s57 <= "0000000000000000000000000000000000";
      s58 <= "0000000000000000000000000000000000";
      s59 <= "0000000000000000000000000000000000";
      s60 <= "0000000000000000000000000000000000";
      s61 <= "0000000000000000000000000000000000";
      s62 <= "0000000000000000000000000000000000";
      s63 <= "0000000000000000000000000000000000";
      s64 <= "0000000000000000000000000000000000";
      s65 <= "0000000000000000000000000000000000";
      s66 <= "0000000000000000000000000000000000";
      s67 <= "0000000000000000000000000000000000";
      s68 <= "0000000000000000000000000000000000";
      s69 <= "0000000000000000000000000000000000";
      s70 <= "0000000000000000000000000000000000";
      s71 <= "0000000000000000000000000000000000";
      s72 <= "0000000000000000000000000000000000";
      s73 <= "0000000000000000000000000000000000";
      s74 <= "0000000000000000000000000000000000";
      s75 <= "0000000000000000000000000000000000";
      s76 <= "0000000000000000000000000000000000";
      s77 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      s14 <= s13;
      s15 <= s14;
      s16 <= s15;
      s17 <= s16;
      s18 <= s17;
      s19 <= s18;
      s20 <= s19;
      s21 <= s20;
      s22 <= s21;
      s23 <= s22;
      s24 <= s23;
      s25 <= s24;
      s26 <= s25;
      s27 <= s26;
      s28 <= s27;
      s29 <= s28;
      s30 <= s29;
      s31 <= s30;
      s32 <= s31;
      s33 <= s32;
      s34 <= s33;
      s35 <= s34;
      s36 <= s35;
      s37 <= s36;
      s38 <= s37;
      s39 <= s38;
      s40 <= s39;
      s41 <= s40;
      s42 <= s41;
      s43 <= s42;
      s44 <= s43;
      s45 <= s44;
      s46 <= s45;
      s47 <= s46;
      s48 <= s47;
      s49 <= s48;
      s50 <= s49;
      s51 <= s50;
      s52 <= s51;
      s53 <= s52;
      s54 <= s53;
      s55 <= s54;
      s56 <= s55;
      s57 <= s56;
      s58 <= s57;
      s59 <= s58;
      s60 <= s59;
      s61 <= s60;
      s62 <= s61;
      s63 <= s62;
      s64 <= s63;
      s65 <= s64;
      s66 <= s65;
      s67 <= s66;
      s68 <= s67;
      s69 <= s68;
      s70 <= s69;
      s71 <= s70;
      s72 <= s71;
      s73 <= s72;
      s74 <= s73;
      s75 <= s74;
      s76 <= s75;
      s77 <= s76;
      Y <= s77;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--Delay_34_DelayLength_24_initialCondition_0000000000000000000000000000000000_component
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Nigel Kretschmer
--------------------------------------------------------------------------------
-- Pipeline depth: 24 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity Delay_34_DelayLength_24_initialCondition_0000000000000000000000000000000000_component is
   port ( clk, rst : in std_logic;
          X : in std_logic_vector(33 downto 0);
          Y : out std_logic_vector(33 downto 0)   );
end entity;

architecture arch of Delay_34_DelayLength_24_initialCondition_0000000000000000000000000000000000_component is
signal s0 : std_logic_vector(33 downto 0) := (others => '0');
signal s1 : std_logic_vector(33 downto 0) := (others => '0');
signal s2 : std_logic_vector(33 downto 0) := (others => '0');
signal s3 : std_logic_vector(33 downto 0) := (others => '0');
signal s4 : std_logic_vector(33 downto 0) := (others => '0');
signal s5 : std_logic_vector(33 downto 0) := (others => '0');
signal s6 : std_logic_vector(33 downto 0) := (others => '0');
signal s7 : std_logic_vector(33 downto 0) := (others => '0');
signal s8 : std_logic_vector(33 downto 0) := (others => '0');
signal s9 : std_logic_vector(33 downto 0) := (others => '0');
signal s10 : std_logic_vector(33 downto 0) := (others => '0');
signal s11 : std_logic_vector(33 downto 0) := (others => '0');
signal s12 : std_logic_vector(33 downto 0) := (others => '0');
signal s13 : std_logic_vector(33 downto 0) := (others => '0');
signal s14 : std_logic_vector(33 downto 0) := (others => '0');
signal s15 : std_logic_vector(33 downto 0) := (others => '0');
signal s16 : std_logic_vector(33 downto 0) := (others => '0');
signal s17 : std_logic_vector(33 downto 0) := (others => '0');
signal s18 : std_logic_vector(33 downto 0) := (others => '0');
signal s19 : std_logic_vector(33 downto 0) := (others => '0');
signal s20 : std_logic_vector(33 downto 0) := (others => '0');
signal s21 : std_logic_vector(33 downto 0) := (others => '0');
signal s22 : std_logic_vector(33 downto 0) := (others => '0');
signal s23 : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
process(clk, rst, X)
begin
   if rst = '1' then
      Y <= "0000000000000000000000000000000000";
      s1 <= "0000000000000000000000000000000000";
      s2 <= "0000000000000000000000000000000000";
      s3 <= "0000000000000000000000000000000000";
      s4 <= "0000000000000000000000000000000000";
      s5 <= "0000000000000000000000000000000000";
      s6 <= "0000000000000000000000000000000000";
      s7 <= "0000000000000000000000000000000000";
      s8 <= "0000000000000000000000000000000000";
      s9 <= "0000000000000000000000000000000000";
      s10 <= "0000000000000000000000000000000000";
      s11 <= "0000000000000000000000000000000000";
      s12 <= "0000000000000000000000000000000000";
      s13 <= "0000000000000000000000000000000000";
      s14 <= "0000000000000000000000000000000000";
      s15 <= "0000000000000000000000000000000000";
      s16 <= "0000000000000000000000000000000000";
      s17 <= "0000000000000000000000000000000000";
      s18 <= "0000000000000000000000000000000000";
      s19 <= "0000000000000000000000000000000000";
      s20 <= "0000000000000000000000000000000000";
      s21 <= "0000000000000000000000000000000000";
      s22 <= "0000000000000000000000000000000000";
      s23 <= "0000000000000000000000000000000000";
   elsif rising_edge(clk) then
      s1 <= s0;
      s2 <= s1;
      s3 <= s2;
      s4 <= s3;
      s5 <= s4;
      s6 <= s5;
      s7 <= s6;
      s8 <= s7;
      s9 <= s8;
      s10 <= s9;
      s11 <= s10;
      s12 <= s11;
      s13 <= s12;
      s14 <= s13;
      s15 <= s14;
      s16 <= s15;
      s17 <= s16;
      s18 <= s17;
      s19 <= s18;
      s20 <= s19;
      s21 <= s20;
      s22 <= s21;
      s23 <= s22;
      Y <= s23;
   end if;
   s0 <= X;
end process;
end architecture;

--------------------------------------------------------------------------------
--                         implementedSystem_toplevel
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity implementedSystem_toplevel is
   port ( clk, rst : in std_logic;
          Ldiff_UU_del_1 : in std_logic_vector(31 downto 0);
          Ldiff_UV_del_1 : in std_logic_vector(31 downto 0);
          Ldiff_UW_del_1 : in std_logic_vector(31 downto 0);
          Ldiff_VU_del_1 : in std_logic_vector(31 downto 0);
          Ldiff_VV_del_1 : in std_logic_vector(31 downto 0);
          Ldiff_VW_del_1 : in std_logic_vector(31 downto 0);
          Ldiff_WU_del_1 : in std_logic_vector(31 downto 0);
          Ldiff_WV_del_1 : in std_logic_vector(31 downto 0);
          Ldiff_WW_del_1 : in std_logic_vector(31 downto 0);
          R_U : in std_logic_vector(31 downto 0);
          R_V : in std_logic_vector(31 downto 0);
          R_W : in std_logic_vector(31 downto 0);
          Inv_11 : out std_logic_vector(31 downto 0);
          Inv_12 : out std_logic_vector(31 downto 0);
          Inv_13 : out std_logic_vector(31 downto 0);
          Inv_21 : out std_logic_vector(31 downto 0);
          Inv_22 : out std_logic_vector(31 downto 0);
          Inv_23 : out std_logic_vector(31 downto 0);
          Inv_31 : out std_logic_vector(31 downto 0);
          Inv_32 : out std_logic_vector(31 downto 0);
          Inv_33 : out std_logic_vector(31 downto 0);
          Inv_41 : out std_logic_vector(31 downto 0);
          Inv_42 : out std_logic_vector(31 downto 0);
          Inv_43 : out std_logic_vector(31 downto 0)   );
end entity;

architecture arch of implementedSystem_toplevel is
   component ModuloCounter_11_component is
      port ( clk, rst : in std_logic;
             Counter_out : out std_logic_vector(3 downto 0)   );
   end component;

   component InputIEEE_8_23_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(31 downto 0);
             R : out std_logic_vector(8+23+2 downto 0)   );
   end component;

   component FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(8+23+2 downto 0);
             Y : in std_logic_vector(8+23+2 downto 0);
             R : out std_logic_vector(8+23+2 downto 0)   );
   end component;

   component Mux_sign_1_wordsize_34_numberOfInputs_11_component is
      port ( clk, rst : in std_logic;
             iS_0 : in std_logic_vector(33 downto 0);
             iS_1 : in std_logic_vector(33 downto 0);
             iS_2 : in std_logic_vector(33 downto 0);
             iS_3 : in std_logic_vector(33 downto 0);
             iS_4 : in std_logic_vector(33 downto 0);
             iS_5 : in std_logic_vector(33 downto 0);
             iS_6 : in std_logic_vector(33 downto 0);
             iS_7 : in std_logic_vector(33 downto 0);
             iS_8 : in std_logic_vector(33 downto 0);
             iS_9 : in std_logic_vector(33 downto 0);
             iS_10 : in std_logic_vector(33 downto 0);
             iSel : in std_logic_vector(3 downto 0);
             oMux : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Mux_sign_1_wordsize_34_numberOfInputs_10_component is
      port ( clk, rst : in std_logic;
             iS_0 : in std_logic_vector(33 downto 0);
             iS_1 : in std_logic_vector(33 downto 0);
             iS_2 : in std_logic_vector(33 downto 0);
             iS_3 : in std_logic_vector(33 downto 0);
             iS_4 : in std_logic_vector(33 downto 0);
             iS_5 : in std_logic_vector(33 downto 0);
             iS_6 : in std_logic_vector(33 downto 0);
             iS_7 : in std_logic_vector(33 downto 0);
             iS_8 : in std_logic_vector(33 downto 0);
             iS_9 : in std_logic_vector(33 downto 0);
             iSel : in std_logic_vector(3 downto 0);
             oMux : out std_logic_vector(33 downto 0)   );
   end component;

   component OutputIEEE_8_23_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(8+23+2 downto 0);
             R : out std_logic_vector(31 downto 0)   );
   end component;

   component FPGenericAddSub_wE_8_wF_23_subX_false_subY_false_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(8+23+2 downto 0);
             Y : in std_logic_vector(8+23+2 downto 0);
             R : out std_logic_vector(8+23+2 downto 0)   );
   end component;

   component Mux_sign_1_wordsize_34_numberOfInputs_9_component is
      port ( clk, rst : in std_logic;
             iS_0 : in std_logic_vector(33 downto 0);
             iS_1 : in std_logic_vector(33 downto 0);
             iS_2 : in std_logic_vector(33 downto 0);
             iS_3 : in std_logic_vector(33 downto 0);
             iS_4 : in std_logic_vector(33 downto 0);
             iS_5 : in std_logic_vector(33 downto 0);
             iS_6 : in std_logic_vector(33 downto 0);
             iS_7 : in std_logic_vector(33 downto 0);
             iS_8 : in std_logic_vector(33 downto 0);
             iSel : in std_logic_vector(3 downto 0);
             oMux : out std_logic_vector(33 downto 0)   );
   end component;

   component Mux_sign_1_wordsize_34_numberOfInputs_8_component is
      port ( clk, rst : in std_logic;
             iS_0 : in std_logic_vector(33 downto 0);
             iS_1 : in std_logic_vector(33 downto 0);
             iS_2 : in std_logic_vector(33 downto 0);
             iS_3 : in std_logic_vector(33 downto 0);
             iS_4 : in std_logic_vector(33 downto 0);
             iS_5 : in std_logic_vector(33 downto 0);
             iS_6 : in std_logic_vector(33 downto 0);
             iS_7 : in std_logic_vector(33 downto 0);
             iSel : in std_logic_vector(2 downto 0);
             oMux : out std_logic_vector(33 downto 0)   );
   end component;

   component FPGenericAddSub_wE_8_wF_23_subX_false_subY_true_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(8+23+2 downto 0);
             Y : in std_logic_vector(8+23+2 downto 0);
             R : out std_logic_vector(8+23+2 downto 0)   );
   end component;

   component Mux_sign_1_wordsize_34_numberOfInputs_4_component is
      port ( clk, rst : in std_logic;
             iS_0 : in std_logic_vector(33 downto 0);
             iS_1 : in std_logic_vector(33 downto 0);
             iS_2 : in std_logic_vector(33 downto 0);
             iS_3 : in std_logic_vector(33 downto 0);
             iSel : in std_logic_vector(1 downto 0);
             oMux : out std_logic_vector(33 downto 0)   );
   end component;

   component Mux_sign_1_wordsize_34_numberOfInputs_7_component is
      port ( clk, rst : in std_logic;
             iS_0 : in std_logic_vector(33 downto 0);
             iS_1 : in std_logic_vector(33 downto 0);
             iS_2 : in std_logic_vector(33 downto 0);
             iS_3 : in std_logic_vector(33 downto 0);
             iS_4 : in std_logic_vector(33 downto 0);
             iS_5 : in std_logic_vector(33 downto 0);
             iS_6 : in std_logic_vector(33 downto 0);
             iSel : in std_logic_vector(2 downto 0);
             oMux : out std_logic_vector(33 downto 0)   );
   end component;

   component Constant_float_8_23_1_component is
      port ( clk, rst : in std_logic;
             Y : out std_logic_vector(8+23+2 downto 0)   );
   end component;

   component FPMultiplier_in_8_23_8_23_out_8_23_mult_X_div_Y_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(8+23+2 downto 0);
             Y : in std_logic_vector(8+23+2 downto 0);
             R : out std_logic_vector(8+23+2 downto 0)   );
   end component;

   component Constant_float_8_23_348_mult_8en9_component is
      port ( clk, rst : in std_logic;
             Y : out std_logic_vector(8+23+2 downto 0)   );
   end component;

   component Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_4_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_14_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_83_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_11_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_13_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_19_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_8_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_107_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_32_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_21_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_7_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_52_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_66_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product810_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product810_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product910_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product910_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Add111_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Add111_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Add210_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Add210_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product312_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product312_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product73_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product73_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product84_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product84_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product85_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product85_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product99_impl_0_LUT_wIn_4_wOut_3_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(2 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Product99_impl_1_LUT_wIn_4_wOut_3_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(2 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Subtract12_impl_0_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Subtract12_impl_1_LUT_wIn_4_wOut_4_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(3 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Subtract7_impl_0_LUT_wIn_4_wOut_2_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(1 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Subtract7_impl_1_LUT_wIn_4_wOut_2_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(1 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Add32_impl_0_LUT_wIn_4_wOut_3_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(2 downto 0)   );
   end component;

   component GenericLut_LUTData_MUX_Add32_impl_1_LUT_wIn_4_wOut_3_wrapper_component is
      port ( clk, rst : in std_logic;
             Input : in std_logic_vector(3 downto 0);
             Output : out std_logic_vector(2 downto 0)   );
   end component;

   component Delay_34_DelayLength_6_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_10_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_12_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_18_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_15_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_74_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_57_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_78_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

   component Delay_34_DelayLength_24_initialCondition_0000000000000000000000000000000000_component is
      port ( clk, rst : in std_logic;
             X : in std_logic_vector(33 downto 0);
             Y : out std_logic_vector(33 downto 0)   );
   end component;

signal ModCount111_out : std_logic_vector(3 downto 0) := (others => '0');
signal Ldiff_UU_del_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Ldiff_UV_del_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Ldiff_UW_del_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Ldiff_VU_del_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Ldiff_VV_del_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Ldiff_VW_del_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Ldiff_WU_del_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Ldiff_WV_del_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Ldiff_WW_del_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal R_U_out : std_logic_vector(33 downto 0) := (others => '0');
signal R_V_out : std_logic_vector(33 downto 0) := (others => '0');
signal R_W_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product108_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product108_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product108_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product110_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product110_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No2_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product110_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No3_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product109_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product109_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No4_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product109_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No5_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product111_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product111_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No6_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product111_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No7_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product210_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product210_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No8_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product210_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No9_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product310_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product310_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No10_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product310_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No11_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product410_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product410_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No12_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product410_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No13_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product510_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product510_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No14_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product510_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No15_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product610_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product610_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No16_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product610_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No17_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product710_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product710_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No18_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product710_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No19_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product810_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product810_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No20_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product810_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No21_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product910_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product910_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No22_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product910_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No23_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No24_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No25_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No26_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No27_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No28_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No29_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No30_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No31_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No32_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No33_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No34_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No35_out : std_logic_vector(33 downto 0) := (others => '0');
signal Add30_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Add30_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No36_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Add30_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No37_out : std_logic_vector(33 downto 0) := (others => '0');
signal Add101_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Add101_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No38_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Add101_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No39_out : std_logic_vector(33 downto 0) := (others => '0');
signal Add111_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Add111_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No40_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Add111_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No41_out : std_logic_vector(33 downto 0) := (others => '0');
signal Add210_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Add210_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No42_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Add210_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No43_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product312_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product312_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No44_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product312_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No45_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product73_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product73_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No46_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product73_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No47_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product84_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product84_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No48_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product84_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No49_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product85_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product85_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No50_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product85_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No51_out : std_logic_vector(33 downto 0) := (others => '0');
signal Product99_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product99_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No52_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product99_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No53_out : std_logic_vector(33 downto 0) := (others => '0');
signal Subtract12_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Subtract12_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No54_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Subtract12_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No55_out : std_logic_vector(33 downto 0) := (others => '0');
signal Subtract7_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Subtract7_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No56_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Subtract7_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No57_out : std_logic_vector(33 downto 0) := (others => '0');
signal Add32_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Add32_impl_0_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No58_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Add32_impl_1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No59_out : std_logic_vector(33 downto 0) := (others => '0');
signal Constant1_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal Divide_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No60_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No61_out : std_logic_vector(33 downto 0) := (others => '0');
signal Constant_impl_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay5No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay11No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay14No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay16No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay5No6_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay20No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay14No2_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay15No1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay5No8_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No76_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No77_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No78_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay89No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay92No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay96No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay88No1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay23No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay18No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay17No1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay17No2_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay11No4_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay24No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay23No1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay10No3_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay3No21_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay107No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay66No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay73No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay36No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay44No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay24No1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay30No_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay15No3_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay64No1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay10No5_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay80No1_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay7No14_out : std_logic_vector(33 downto 0) := (others => '0');
signal Delay38No_out : std_logic_vector(33 downto 0) := (others => '0');
signal MUX_Product810_impl_0_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Product810_impl_1_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Product910_impl_0_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Product910_impl_1_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Add111_impl_0_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Add111_impl_1_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Add210_impl_0_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Add210_impl_1_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Product312_impl_0_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Product312_impl_1_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Product73_impl_0_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Product73_impl_1_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Product84_impl_0_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Product84_impl_1_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Product85_impl_0_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Product85_impl_1_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Product99_impl_0_LUT_out : std_logic_vector(2 downto 0) := (others => '0');
signal MUX_Product99_impl_1_LUT_out : std_logic_vector(2 downto 0) := (others => '0');
signal MUX_Subtract12_impl_0_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Subtract12_impl_1_LUT_out : std_logic_vector(3 downto 0) := (others => '0');
signal MUX_Subtract7_impl_0_LUT_out : std_logic_vector(1 downto 0) := (others => '0');
signal MUX_Subtract7_impl_1_LUT_out : std_logic_vector(1 downto 0) := (others => '0');
signal MUX_Add32_impl_0_LUT_out : std_logic_vector(2 downto 0) := (others => '0');
signal MUX_Add32_impl_1_LUT_out : std_logic_vector(2 downto 0) := (others => '0');
signal SharedReg_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg1_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg2_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg3_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg4_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg5_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg6_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg7_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg8_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg9_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg10_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg11_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg12_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg13_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg14_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg15_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg16_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg17_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg18_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg19_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg20_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg21_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg22_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg23_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg24_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg25_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg26_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg27_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg28_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg29_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg30_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg31_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg32_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg33_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg34_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg35_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg36_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg37_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg38_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg39_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg40_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg41_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg42_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg43_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg44_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg45_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg46_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg47_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg48_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg49_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg50_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg51_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg52_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg53_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg54_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg55_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg56_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg57_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg58_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg59_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg60_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg61_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg62_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg63_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg64_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg65_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg66_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg67_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg68_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg69_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg70_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg71_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg72_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg73_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg74_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg75_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg76_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg77_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg78_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg79_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg80_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg81_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg82_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg83_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg84_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg85_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg86_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg87_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg88_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg89_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg90_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg91_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg92_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg93_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg94_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg95_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg96_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg97_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg98_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg99_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg100_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg101_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg102_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg103_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg104_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg105_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg106_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg107_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg108_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg109_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg110_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg111_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg112_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg113_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg114_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg115_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg116_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg117_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg118_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg119_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg120_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg121_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg122_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg123_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg124_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg125_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg126_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg127_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg128_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg129_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg130_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg131_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg132_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg133_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg134_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg135_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg136_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg137_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg138_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg139_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg140_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg141_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg142_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg143_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg144_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg145_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg146_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg147_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg148_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg149_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg150_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg151_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg152_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg153_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg154_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg155_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg156_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg157_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg158_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg159_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg160_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg161_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg162_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg163_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg164_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg165_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg167_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg168_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg169_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg172_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg173_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg174_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg176_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg177_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg178_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg179_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg180_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg181_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg182_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg183_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg184_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg185_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg186_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg187_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg188_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg189_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg190_out : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg191_out : std_logic_vector(33 downto 0) := (others => '0');
signal Ldiff_UU_del_1_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Ldiff_UV_del_1_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Ldiff_UW_del_1_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Ldiff_VU_del_1_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Ldiff_VV_del_1_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Ldiff_VW_del_1_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Ldiff_WU_del_1_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Ldiff_WV_del_1_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Ldiff_WW_del_1_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal R_U_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal R_V_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal R_W_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Delay1No_out_to_Product108_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No1_out_to_Product108_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg169_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg9_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg156_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg174_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg55_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg89_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg49_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg45_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg52_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg112_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg22_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg16_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg181_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg174_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg11_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg190_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg12_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg26_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No2_out_to_Product110_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No3_out_to_Product110_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg169_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg172_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg173_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg64_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg143_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg66_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg84_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg43_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg113_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg172_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg173_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg10_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg184_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg20_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg178_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No4_out_to_Product109_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No5_out_to_Product109_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg169_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg172_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg173_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg60_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg44_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg71_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg63_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg51_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg121_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg172_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg173_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg18_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg176_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg33_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg40_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg129_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No6_out_to_Product111_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No7_out_to_Product111_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg169_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg172_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg173_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg174_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg42_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg60_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg62_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg49_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg111_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg172_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg173_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg174_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg176_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg20_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg13_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg27_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No8_out_to_Product210_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No9_out_to_Product210_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg169_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg172_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg79_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg69_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg50_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg74_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg178_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg60_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay96No_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg172_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg187_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg3_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg39_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg33_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg178_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No10_out_to_Product310_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No11_out_to_Product310_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg169_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg172_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg173_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg174_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg57_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg84_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg60_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg67_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg127_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg172_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg173_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg174_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg5_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg177_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg40_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg122_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No12_out_to_Product410_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No13_out_to_Product410_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg169_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg58_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg172_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg101_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg73_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg77_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg55_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg103_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg83_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg64_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay88No1_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg124_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg172_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg181_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg3_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg38_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg25_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg191_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg178_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg129_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No14_out_to_Product510_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No15_out_to_Product510_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg169_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg23_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg135_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay16No_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg83_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg69_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg146_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg102_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg69_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg128_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg31_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg181_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay7No14_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg32_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg25_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg185_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg178_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg129_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No16_out_to_Product610_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No17_out_to_Product610_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg169_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg22_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg9_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg2_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg18_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg142_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg155_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg136_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg71_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg114_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg35_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg36_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg17_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg37_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg184_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg185_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg178_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No18_out_to_Product710_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No19_out_to_Product710_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg169_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg35_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg64_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg156_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg125_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg96_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg78_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg77_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg144_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg126_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg83_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay89No_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg22_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg124_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg180_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg28_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg188_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg19_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg176_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg191_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay20No_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg122_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No20_out_to_Product810_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No21_out_to_Product810_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay14No_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg7_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg70_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg84_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg148_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg169_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg88_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg95_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg90_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg35_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay92No_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg129_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg133_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg171_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg184_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg186_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay38No_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg187_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No22_out_to_Product910_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No23_out_to_Product910_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg8_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg35_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg94_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg169_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg87_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg137_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg143_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg157_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg129_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg168_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg4_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg21_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg15_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg30_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg120_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg184_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg182_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg187_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg186_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Inv_11_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Inv_12_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Inv_13_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Inv_21_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Inv_22_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Inv_23_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Inv_31_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Inv_32_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Inv_33_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Inv_41_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Inv_42_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Inv_43_IEEE : std_logic_vector(31 downto 0) := (others => '0');
signal Delay1No36_out_to_Add30_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No37_out_to_Add30_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay23No1_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg104_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay23No_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg87_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg46_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay15No3_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg93_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg82_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg73_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg75_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg56_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg165_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg163_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg160_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg94_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg131_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay3No21_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay10No3_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg91_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg85_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg73_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No38_out_to_Add101_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No39_out_to_Add101_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg55_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay36No_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg52_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg76_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg61_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg99_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg97_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg76_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg77_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay24No_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg65_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg60_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg164_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg61_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg164_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg134_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg129_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg124_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg110_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg122_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg109_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg77_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_11_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No40_out_to_Add111_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No41_out_to_Add111_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay5No_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg42_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg69_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg48_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg54_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg74_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay11No4_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg138_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg84_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay80No1_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg117_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg73_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg68_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg71_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg161_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg159_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg162_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg159_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg129_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg146_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No42_out_to_Add210_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No43_out_to_Add210_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay5No6_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay18No_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg43_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay17No2_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay66No_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg106_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay73No_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg105_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg139_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg86_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg66_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg159_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg160_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg115_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg129_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg115_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg129_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg151_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No44_out_to_Product312_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No45_out_to_Product312_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg1_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay14No2_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg29_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg58_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg153_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg152_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg149_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg152_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg154_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg122_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg22_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg34_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg30_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg133_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg183_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg176_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg181_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg178_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg182_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No46_out_to_Product73_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No47_out_to_Product73_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg14_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg9_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg100_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg150_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg141_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg134_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg94_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg125_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg130_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg16_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg15_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg34_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay15No1_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg129_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg184_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg189_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg179_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg186_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg174_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No48_out_to_Product84_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No49_out_to_Product84_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg1_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No76_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg134_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg88_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg147_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg100_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg146_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg151_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg123_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg122_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg30_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg41_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg184_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg174_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg180_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg181_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg178_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_10_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No50_out_to_Product85_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No51_out_to_Product85_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay11No_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg2_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg8_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No77_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg146_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg140_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg134_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg151_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg24_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg30_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg129_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg167_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg174_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg175_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg176_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg178_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No52_out_to_Product99_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No53_out_to_Product99_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg6_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No78_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg144_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg146_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg140_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg156_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg123_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg124_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg130_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg132_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg181_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg184_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg174_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg178_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg170_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No54_out_to_Subtract12_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No55_out_to_Subtract12_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg51_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg47_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg57_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg53_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay17No1_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg59_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg80_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg67_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg81_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg109_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg116_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg107_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg132_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg115_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg123_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg122_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg115_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_8_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg122_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_9_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No56_out_to_Subtract7_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No57_out_to_Subtract7_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg72_out_to_MUX_Subtract7_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg92_out_to_MUX_Subtract7_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg98_out_to_MUX_Subtract7_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay44No_out_to_MUX_Subtract7_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg119_out_to_MUX_Subtract7_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg108_out_to_MUX_Subtract7_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg118_out_to_MUX_Subtract7_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Subtract7_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No58_out_to_Add32_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No59_out_to_Add32_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay5No8_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay24No1_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay30No_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg145_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg158_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay64No1_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg156_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg129_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg107_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_2_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg122_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_3_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_4_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg166_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_5_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay10No5_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_6_cast : std_logic_vector(33 downto 0) := (others => '0');
signal SharedReg156_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_7_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No60_out_to_Divide_impl_parent_implementedSystem_port_0_cast : std_logic_vector(33 downto 0) := (others => '0');
signal Delay1No61_out_to_Divide_impl_parent_implementedSystem_port_1_cast : std_logic_vector(33 downto 0) := (others => '0');
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   ModCount111_instance: ModuloCounter_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Counter_out => ModCount111_out);
Ldiff_UU_del_1_IEEE <= Ldiff_UU_del_1;
   Ldiff_UU_del_1_instance: InputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Ldiff_UU_del_1_out,
                 X => Ldiff_UU_del_1_IEEE);
Ldiff_UV_del_1_IEEE <= Ldiff_UV_del_1;
   Ldiff_UV_del_1_instance: InputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Ldiff_UV_del_1_out,
                 X => Ldiff_UV_del_1_IEEE);
Ldiff_UW_del_1_IEEE <= Ldiff_UW_del_1;
   Ldiff_UW_del_1_instance: InputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Ldiff_UW_del_1_out,
                 X => Ldiff_UW_del_1_IEEE);
Ldiff_VU_del_1_IEEE <= Ldiff_VU_del_1;
   Ldiff_VU_del_1_instance: InputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Ldiff_VU_del_1_out,
                 X => Ldiff_VU_del_1_IEEE);
Ldiff_VV_del_1_IEEE <= Ldiff_VV_del_1;
   Ldiff_VV_del_1_instance: InputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Ldiff_VV_del_1_out,
                 X => Ldiff_VV_del_1_IEEE);
Ldiff_VW_del_1_IEEE <= Ldiff_VW_del_1;
   Ldiff_VW_del_1_instance: InputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Ldiff_VW_del_1_out,
                 X => Ldiff_VW_del_1_IEEE);
Ldiff_WU_del_1_IEEE <= Ldiff_WU_del_1;
   Ldiff_WU_del_1_instance: InputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Ldiff_WU_del_1_out,
                 X => Ldiff_WU_del_1_IEEE);
Ldiff_WV_del_1_IEEE <= Ldiff_WV_del_1;
   Ldiff_WV_del_1_instance: InputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Ldiff_WV_del_1_out,
                 X => Ldiff_WV_del_1_IEEE);
Ldiff_WW_del_1_IEEE <= Ldiff_WW_del_1;
   Ldiff_WW_del_1_instance: InputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Ldiff_WW_del_1_out,
                 X => Ldiff_WW_del_1_IEEE);
R_U_IEEE <= R_U;
   R_U_instance: InputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => R_U_out,
                 X => R_U_IEEE);
R_V_IEEE <= R_V;
   R_V_instance: InputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => R_V_out,
                 X => R_V_IEEE);
R_W_IEEE <= R_W;
   R_W_instance: InputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => R_W_out,
                 X => R_W_IEEE);

Delay1No_out_to_Product108_impl_parent_implementedSystem_port_0_cast <= Delay1No_out;
Delay1No1_out_to_Product108_impl_parent_implementedSystem_port_1_cast <= Delay1No1_out;
   Product108_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product108_impl_out,
                 X => Delay1No_out_to_Product108_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No1_out_to_Product108_impl_parent_implementedSystem_port_1_cast);

SharedReg169_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_1_cast <= SharedReg169_out;
SharedReg_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_2_cast <= SharedReg_out;
SharedReg171_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg9_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_4_cast <= SharedReg9_out;
SharedReg156_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_5_cast <= SharedReg156_out;
SharedReg174_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_6_cast <= SharedReg174_out;
SharedReg55_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_7_cast <= SharedReg55_out;
SharedReg89_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_8_cast <= SharedReg89_out;
SharedReg49_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_9_cast <= SharedReg49_out;
SharedReg45_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_10_cast <= SharedReg45_out;
SharedReg52_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_11_cast <= SharedReg52_out;
   MUX_Product108_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg169_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg52_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg9_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg156_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg174_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg55_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg89_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg49_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg45_out_to_MUX_Product108_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product108_impl_0_out);

   Delay1No_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product108_impl_0_out,
                 Y => Delay1No_out);

SharedReg112_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_1_cast <= SharedReg112_out;
SharedReg22_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_2_cast <= SharedReg22_out;
SharedReg171_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg16_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_4_cast <= SharedReg16_out;
SharedReg181_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_5_cast <= SharedReg181_out;
SharedReg174_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_6_cast <= SharedReg174_out;
SharedReg11_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_7_cast <= SharedReg11_out;
SharedReg190_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_8_cast <= SharedReg190_out;
SharedReg12_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_9_cast <= SharedReg12_out;
SharedReg26_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_10_cast <= SharedReg26_out;
SharedReg166_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_11_cast <= SharedReg166_out;
   MUX_Product108_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg112_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg22_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg166_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg16_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg181_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg174_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg11_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg190_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg12_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg26_out_to_MUX_Product108_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product108_impl_1_out);

   Delay1No1_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product108_impl_1_out,
                 Y => Delay1No1_out);

Delay1No2_out_to_Product110_impl_parent_implementedSystem_port_0_cast <= Delay1No2_out;
Delay1No3_out_to_Product110_impl_parent_implementedSystem_port_1_cast <= Delay1No3_out;
   Product110_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product110_impl_out,
                 X => Delay1No2_out_to_Product110_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No3_out_to_Product110_impl_parent_implementedSystem_port_1_cast);

SharedReg169_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_1_cast <= SharedReg169_out;
SharedReg170_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg171_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg172_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_4_cast <= SharedReg172_out;
SharedReg173_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_5_cast <= SharedReg173_out;
SharedReg64_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_6_cast <= SharedReg64_out;
SharedReg175_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_7_cast <= SharedReg175_out;
SharedReg143_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_8_cast <= SharedReg143_out;
SharedReg66_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_9_cast <= SharedReg66_out;
SharedReg84_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_10_cast <= SharedReg84_out;
SharedReg43_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_11_cast <= SharedReg43_out;
   MUX_Product110_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg169_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg43_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg172_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg173_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg64_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg175_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg143_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg66_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg84_out_to_MUX_Product110_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product110_impl_0_out);

   Delay1No2_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product110_impl_0_out,
                 Y => Delay1No2_out);

SharedReg113_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_1_cast <= SharedReg113_out;
SharedReg170_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg171_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg172_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_4_cast <= SharedReg172_out;
SharedReg173_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_5_cast <= SharedReg173_out;
SharedReg10_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_6_cast <= SharedReg10_out;
SharedReg175_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_7_cast <= SharedReg175_out;
SharedReg184_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_8_cast <= SharedReg184_out;
SharedReg20_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_9_cast <= SharedReg20_out;
SharedReg178_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_10_cast <= SharedReg178_out;
SharedReg166_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_11_cast <= SharedReg166_out;
   MUX_Product110_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg113_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg166_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg172_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg173_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg10_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg175_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg184_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg20_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg178_out_to_MUX_Product110_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product110_impl_1_out);

   Delay1No3_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product110_impl_1_out,
                 Y => Delay1No3_out);

Delay1No4_out_to_Product109_impl_parent_implementedSystem_port_0_cast <= Delay1No4_out;
Delay1No5_out_to_Product109_impl_parent_implementedSystem_port_1_cast <= Delay1No5_out;
   Product109_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product109_impl_out,
                 X => Delay1No4_out_to_Product109_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No5_out_to_Product109_impl_parent_implementedSystem_port_1_cast);

SharedReg169_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_1_cast <= SharedReg169_out;
SharedReg170_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg171_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg172_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_4_cast <= SharedReg172_out;
SharedReg173_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_5_cast <= SharedReg173_out;
SharedReg60_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_6_cast <= SharedReg60_out;
SharedReg175_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_7_cast <= SharedReg175_out;
SharedReg44_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_8_cast <= SharedReg44_out;
SharedReg71_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_9_cast <= SharedReg71_out;
SharedReg63_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_10_cast <= SharedReg63_out;
SharedReg51_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_11_cast <= SharedReg51_out;
   MUX_Product109_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg169_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg51_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg172_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg173_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg60_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg175_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg44_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg71_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg63_out_to_MUX_Product109_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product109_impl_0_out);

   Delay1No4_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product109_impl_0_out,
                 Y => Delay1No4_out);

SharedReg121_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_1_cast <= SharedReg121_out;
SharedReg170_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg171_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg172_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_4_cast <= SharedReg172_out;
SharedReg173_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_5_cast <= SharedReg173_out;
SharedReg18_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_6_cast <= SharedReg18_out;
SharedReg175_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_7_cast <= SharedReg175_out;
SharedReg176_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_8_cast <= SharedReg176_out;
SharedReg33_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_9_cast <= SharedReg33_out;
SharedReg40_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_10_cast <= SharedReg40_out;
SharedReg129_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_11_cast <= SharedReg129_out;
   MUX_Product109_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg121_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg129_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg172_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg173_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg18_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg175_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg176_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg33_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg40_out_to_MUX_Product109_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product109_impl_1_out);

   Delay1No5_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product109_impl_1_out,
                 Y => Delay1No5_out);

Delay1No6_out_to_Product111_impl_parent_implementedSystem_port_0_cast <= Delay1No6_out;
Delay1No7_out_to_Product111_impl_parent_implementedSystem_port_1_cast <= Delay1No7_out;
   Product111_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product111_impl_out,
                 X => Delay1No6_out_to_Product111_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No7_out_to_Product111_impl_parent_implementedSystem_port_1_cast);

SharedReg169_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_1_cast <= SharedReg169_out;
SharedReg170_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg171_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg172_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_4_cast <= SharedReg172_out;
SharedReg173_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_5_cast <= SharedReg173_out;
SharedReg174_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_6_cast <= SharedReg174_out;
SharedReg175_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_7_cast <= SharedReg175_out;
SharedReg42_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_8_cast <= SharedReg42_out;
SharedReg60_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_9_cast <= SharedReg60_out;
SharedReg62_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_10_cast <= SharedReg62_out;
SharedReg49_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_11_cast <= SharedReg49_out;
   MUX_Product111_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg169_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg49_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg172_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg173_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg174_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg175_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg42_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg60_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg62_out_to_MUX_Product111_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product111_impl_0_out);

   Delay1No6_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product111_impl_0_out,
                 Y => Delay1No6_out);

SharedReg111_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_1_cast <= SharedReg111_out;
SharedReg170_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg171_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg172_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_4_cast <= SharedReg172_out;
SharedReg173_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_5_cast <= SharedReg173_out;
SharedReg174_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_6_cast <= SharedReg174_out;
SharedReg175_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_7_cast <= SharedReg175_out;
SharedReg176_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_8_cast <= SharedReg176_out;
SharedReg20_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_9_cast <= SharedReg20_out;
SharedReg13_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_10_cast <= SharedReg13_out;
SharedReg27_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_11_cast <= SharedReg27_out;
   MUX_Product111_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg111_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg27_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg172_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg173_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg174_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg175_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg176_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg20_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg13_out_to_MUX_Product111_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product111_impl_1_out);

   Delay1No7_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product111_impl_1_out,
                 Y => Delay1No7_out);

Delay1No8_out_to_Product210_impl_parent_implementedSystem_port_0_cast <= Delay1No8_out;
Delay1No9_out_to_Product210_impl_parent_implementedSystem_port_1_cast <= Delay1No9_out;
   Product210_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product210_impl_out,
                 X => Delay1No8_out_to_Product210_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No9_out_to_Product210_impl_parent_implementedSystem_port_1_cast);

SharedReg169_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_1_cast <= SharedReg169_out;
SharedReg170_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg171_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg172_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_4_cast <= SharedReg172_out;
SharedReg79_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_5_cast <= SharedReg79_out;
SharedReg69_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_6_cast <= SharedReg69_out;
SharedReg175_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_7_cast <= SharedReg175_out;
SharedReg50_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_8_cast <= SharedReg50_out;
SharedReg74_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_9_cast <= SharedReg74_out;
SharedReg178_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_10_cast <= SharedReg178_out;
SharedReg60_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_11_cast <= SharedReg60_out;
   MUX_Product210_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg169_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg60_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg172_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg79_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg69_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg175_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg50_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg74_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg178_out_to_MUX_Product210_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product210_impl_0_out);

   Delay1No8_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product210_impl_0_out,
                 Y => Delay1No8_out);

Delay96No_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_1_cast <= Delay96No_out;
SharedReg170_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg171_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg172_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_4_cast <= SharedReg172_out;
SharedReg187_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_5_cast <= SharedReg187_out;
SharedReg3_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_6_cast <= SharedReg3_out;
SharedReg175_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_7_cast <= SharedReg175_out;
SharedReg39_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_8_cast <= SharedReg39_out;
SharedReg33_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_9_cast <= SharedReg33_out;
SharedReg178_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_10_cast <= SharedReg178_out;
SharedReg166_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_11_cast <= SharedReg166_out;
   MUX_Product210_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => Delay96No_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg166_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg172_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg187_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg3_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg175_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg39_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg33_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg178_out_to_MUX_Product210_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product210_impl_1_out);

   Delay1No9_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product210_impl_1_out,
                 Y => Delay1No9_out);

Delay1No10_out_to_Product310_impl_parent_implementedSystem_port_0_cast <= Delay1No10_out;
Delay1No11_out_to_Product310_impl_parent_implementedSystem_port_1_cast <= Delay1No11_out;
   Product310_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product310_impl_out,
                 X => Delay1No10_out_to_Product310_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No11_out_to_Product310_impl_parent_implementedSystem_port_1_cast);

SharedReg169_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_1_cast <= SharedReg169_out;
SharedReg170_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg171_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg172_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_4_cast <= SharedReg172_out;
SharedReg173_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_5_cast <= SharedReg173_out;
SharedReg174_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_6_cast <= SharedReg174_out;
SharedReg175_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_7_cast <= SharedReg175_out;
SharedReg57_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_8_cast <= SharedReg57_out;
SharedReg84_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_9_cast <= SharedReg84_out;
SharedReg60_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_10_cast <= SharedReg60_out;
SharedReg67_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_11_cast <= SharedReg67_out;
   MUX_Product310_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg169_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg67_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg172_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg173_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg174_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg175_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg57_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg84_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg60_out_to_MUX_Product310_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product310_impl_0_out);

   Delay1No10_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product310_impl_0_out,
                 Y => Delay1No10_out);

SharedReg127_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_1_cast <= SharedReg127_out;
SharedReg170_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg171_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg172_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_4_cast <= SharedReg172_out;
SharedReg173_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_5_cast <= SharedReg173_out;
SharedReg174_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_6_cast <= SharedReg174_out;
SharedReg175_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_7_cast <= SharedReg175_out;
SharedReg5_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_8_cast <= SharedReg5_out;
SharedReg177_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_9_cast <= SharedReg177_out;
SharedReg40_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_10_cast <= SharedReg40_out;
SharedReg122_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_11_cast <= SharedReg122_out;
   MUX_Product310_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg127_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg122_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg172_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg173_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg174_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg175_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg5_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg177_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg40_out_to_MUX_Product310_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product310_impl_1_out);

   Delay1No11_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product310_impl_1_out,
                 Y => Delay1No11_out);

Delay1No12_out_to_Product410_impl_parent_implementedSystem_port_0_cast <= Delay1No12_out;
Delay1No13_out_to_Product410_impl_parent_implementedSystem_port_1_cast <= Delay1No13_out;
   Product410_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product410_impl_out,
                 X => Delay1No12_out_to_Product410_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No13_out_to_Product410_impl_parent_implementedSystem_port_1_cast);

SharedReg169_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_1_cast <= SharedReg169_out;
SharedReg170_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg58_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_3_cast <= SharedReg58_out;
SharedReg172_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_4_cast <= SharedReg172_out;
SharedReg101_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_5_cast <= SharedReg101_out;
SharedReg73_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_6_cast <= SharedReg73_out;
SharedReg77_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_7_cast <= SharedReg77_out;
SharedReg55_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_8_cast <= SharedReg55_out;
SharedReg103_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_9_cast <= SharedReg103_out;
SharedReg83_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_10_cast <= SharedReg83_out;
SharedReg64_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_11_cast <= SharedReg64_out;
   MUX_Product410_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg169_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg64_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg58_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg172_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg101_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg73_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg77_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg55_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg103_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg83_out_to_MUX_Product410_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product410_impl_0_out);

   Delay1No12_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product410_impl_0_out,
                 Y => Delay1No12_out);

Delay88No1_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_1_cast <= Delay88No1_out;
SharedReg170_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg124_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_3_cast <= SharedReg124_out;
SharedReg172_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_4_cast <= SharedReg172_out;
SharedReg181_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_5_cast <= SharedReg181_out;
SharedReg3_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_6_cast <= SharedReg3_out;
SharedReg38_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_7_cast <= SharedReg38_out;
SharedReg25_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_8_cast <= SharedReg25_out;
SharedReg191_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_9_cast <= SharedReg191_out;
SharedReg178_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_10_cast <= SharedReg178_out;
SharedReg129_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_11_cast <= SharedReg129_out;
   MUX_Product410_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => Delay88No1_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg129_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg124_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg172_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg181_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg3_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg38_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg25_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg191_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg178_out_to_MUX_Product410_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product410_impl_1_out);

   Delay1No13_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product410_impl_1_out,
                 Y => Delay1No13_out);

Delay1No14_out_to_Product510_impl_parent_implementedSystem_port_0_cast <= Delay1No14_out;
Delay1No15_out_to_Product510_impl_parent_implementedSystem_port_1_cast <= Delay1No15_out;
   Product510_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product510_impl_out,
                 X => Delay1No14_out_to_Product510_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No15_out_to_Product510_impl_parent_implementedSystem_port_1_cast);

SharedReg169_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_1_cast <= SharedReg169_out;
SharedReg170_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg171_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg23_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_4_cast <= SharedReg23_out;
SharedReg135_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_5_cast <= SharedReg135_out;
Delay16No_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_6_cast <= Delay16No_out;
SharedReg83_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_7_cast <= SharedReg83_out;
SharedReg69_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_8_cast <= SharedReg69_out;
SharedReg146_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_9_cast <= SharedReg146_out;
SharedReg102_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_10_cast <= SharedReg102_out;
SharedReg69_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_11_cast <= SharedReg69_out;
   MUX_Product510_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg169_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg69_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg23_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg135_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => Delay16No_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg83_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg69_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg146_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg102_out_to_MUX_Product510_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product510_impl_0_out);

   Delay1No14_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product510_impl_0_out,
                 Y => Delay1No14_out);

SharedReg128_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_1_cast <= SharedReg128_out;
SharedReg170_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_2_cast <= SharedReg170_out;
SharedReg171_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg31_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_4_cast <= SharedReg31_out;
SharedReg181_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_5_cast <= SharedReg181_out;
Delay7No14_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_6_cast <= Delay7No14_out;
SharedReg32_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_7_cast <= SharedReg32_out;
SharedReg25_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_8_cast <= SharedReg25_out;
SharedReg185_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_9_cast <= SharedReg185_out;
SharedReg178_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_10_cast <= SharedReg178_out;
SharedReg129_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_11_cast <= SharedReg129_out;
   MUX_Product510_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg128_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg170_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg129_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg31_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg181_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => Delay7No14_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg32_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg25_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg185_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg178_out_to_MUX_Product510_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product510_impl_1_out);

   Delay1No15_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product510_impl_1_out,
                 Y => Delay1No15_out);

Delay1No16_out_to_Product610_impl_parent_implementedSystem_port_0_cast <= Delay1No16_out;
Delay1No17_out_to_Product610_impl_parent_implementedSystem_port_1_cast <= Delay1No17_out;
   Product610_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product610_impl_out,
                 X => Delay1No16_out_to_Product610_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No17_out_to_Product610_impl_parent_implementedSystem_port_1_cast);

SharedReg169_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_1_cast <= SharedReg169_out;
SharedReg22_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_2_cast <= SharedReg22_out;
SharedReg171_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg9_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_4_cast <= SharedReg9_out;
SharedReg2_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_5_cast <= SharedReg2_out;
SharedReg18_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_6_cast <= SharedReg18_out;
SharedReg175_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_7_cast <= SharedReg175_out;
SharedReg142_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_8_cast <= SharedReg142_out;
SharedReg155_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_9_cast <= SharedReg155_out;
SharedReg136_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_10_cast <= SharedReg136_out;
SharedReg71_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_11_cast <= SharedReg71_out;
   MUX_Product610_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg169_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg22_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg71_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg9_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg2_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg18_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg175_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg142_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg155_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg136_out_to_MUX_Product610_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product610_impl_0_out);

   Delay1No16_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product610_impl_0_out,
                 Y => Delay1No16_out);

SharedReg114_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_1_cast <= SharedReg114_out;
SharedReg35_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_2_cast <= SharedReg35_out;
SharedReg171_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_3_cast <= SharedReg171_out;
SharedReg36_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_4_cast <= SharedReg36_out;
SharedReg17_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_5_cast <= SharedReg17_out;
SharedReg37_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_6_cast <= SharedReg37_out;
SharedReg175_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_7_cast <= SharedReg175_out;
SharedReg184_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_8_cast <= SharedReg184_out;
SharedReg185_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_9_cast <= SharedReg185_out;
SharedReg178_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_10_cast <= SharedReg178_out;
SharedReg166_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_11_cast <= SharedReg166_out;
   MUX_Product610_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg114_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg35_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg166_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg171_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg36_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg17_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg37_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg175_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg184_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg185_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg178_out_to_MUX_Product610_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product610_impl_1_out);

   Delay1No17_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product610_impl_1_out,
                 Y => Delay1No17_out);

Delay1No18_out_to_Product710_impl_parent_implementedSystem_port_0_cast <= Delay1No18_out;
Delay1No19_out_to_Product710_impl_parent_implementedSystem_port_1_cast <= Delay1No19_out;
   Product710_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product710_impl_out,
                 X => Delay1No18_out_to_Product710_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No19_out_to_Product710_impl_parent_implementedSystem_port_1_cast);

SharedReg169_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_1_cast <= SharedReg169_out;
SharedReg35_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_2_cast <= SharedReg35_out;
SharedReg64_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_3_cast <= SharedReg64_out;
SharedReg156_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_4_cast <= SharedReg156_out;
SharedReg125_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_5_cast <= SharedReg125_out;
SharedReg96_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_6_cast <= SharedReg96_out;
SharedReg78_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_7_cast <= SharedReg78_out;
SharedReg77_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_8_cast <= SharedReg77_out;
SharedReg144_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_9_cast <= SharedReg144_out;
SharedReg126_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_10_cast <= SharedReg126_out;
SharedReg83_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_11_cast <= SharedReg83_out;
   MUX_Product710_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg169_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg35_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg83_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg64_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg156_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg125_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg96_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg78_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg77_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg144_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg126_out_to_MUX_Product710_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product710_impl_0_out);

   Delay1No18_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product710_impl_0_out,
                 Y => Delay1No18_out);

Delay89No_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_1_cast <= Delay89No_out;
SharedReg22_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_2_cast <= SharedReg22_out;
SharedReg124_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_3_cast <= SharedReg124_out;
SharedReg180_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_4_cast <= SharedReg180_out;
SharedReg28_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_5_cast <= SharedReg28_out;
SharedReg188_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_6_cast <= SharedReg188_out;
SharedReg19_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_7_cast <= SharedReg19_out;
SharedReg176_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_8_cast <= SharedReg176_out;
SharedReg191_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_9_cast <= SharedReg191_out;
Delay20No_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_10_cast <= Delay20No_out;
SharedReg122_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_11_cast <= SharedReg122_out;
   MUX_Product710_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => Delay89No_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg22_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg122_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg124_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg180_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg28_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg188_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg19_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg176_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg191_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => Delay20No_out_to_MUX_Product710_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Product710_impl_1_out);

   Delay1No19_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product710_impl_1_out,
                 Y => Delay1No19_out);

Delay1No20_out_to_Product810_impl_parent_implementedSystem_port_0_cast <= Delay1No20_out;
Delay1No21_out_to_Product810_impl_parent_implementedSystem_port_1_cast <= Delay1No21_out;
   Product810_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product810_impl_out,
                 X => Delay1No20_out_to_Product810_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No21_out_to_Product810_impl_parent_implementedSystem_port_1_cast);

Delay14No_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_1_cast <= Delay14No_out;
SharedReg7_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_2_cast <= SharedReg7_out;
SharedReg70_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_3_cast <= SharedReg70_out;
SharedReg84_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_4_cast <= SharedReg84_out;
SharedReg148_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_5_cast <= SharedReg148_out;
SharedReg169_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_6_cast <= SharedReg169_out;
SharedReg88_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_7_cast <= SharedReg88_out;
SharedReg95_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_8_cast <= SharedReg95_out;
SharedReg90_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_9_cast <= SharedReg90_out;
SharedReg171_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_10_cast <= SharedReg171_out;
   MUX_Product810_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => Delay14No_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg7_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg70_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg84_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg148_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg169_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg88_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg95_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg90_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg171_out_to_MUX_Product810_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Product810_impl_0_LUT_out,
                 oMux => MUX_Product810_impl_0_out);

   Delay1No20_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product810_impl_0_out,
                 Y => Delay1No20_out);

SharedReg35_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_1_cast <= SharedReg35_out;
Delay92No_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_2_cast <= Delay92No_out;
SharedReg129_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_3_cast <= SharedReg129_out;
SharedReg133_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_4_cast <= SharedReg133_out;
SharedReg171_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_5_cast <= SharedReg171_out;
SharedReg175_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_6_cast <= SharedReg175_out;
SharedReg184_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_7_cast <= SharedReg184_out;
SharedReg186_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_8_cast <= SharedReg186_out;
Delay38No_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_9_cast <= Delay38No_out;
SharedReg187_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_10_cast <= SharedReg187_out;
   MUX_Product810_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg35_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => Delay92No_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg129_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg133_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg171_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg175_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg184_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg186_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => Delay38No_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg187_out_to_MUX_Product810_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Product810_impl_1_LUT_out,
                 oMux => MUX_Product810_impl_1_out);

   Delay1No21_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product810_impl_1_out,
                 Y => Delay1No21_out);

Delay1No22_out_to_Product910_impl_parent_implementedSystem_port_0_cast <= Delay1No22_out;
Delay1No23_out_to_Product910_impl_parent_implementedSystem_port_1_cast <= Delay1No23_out;
   Product910_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product910_impl_out,
                 X => Delay1No22_out_to_Product910_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No23_out_to_Product910_impl_parent_implementedSystem_port_1_cast);

SharedReg8_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_1_cast <= SharedReg8_out;
SharedReg35_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_2_cast <= SharedReg35_out;
SharedReg94_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_3_cast <= SharedReg94_out;
SharedReg169_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_4_cast <= SharedReg169_out;
SharedReg87_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_5_cast <= SharedReg87_out;
SharedReg137_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_6_cast <= SharedReg137_out;
SharedReg143_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_7_cast <= SharedReg143_out;
SharedReg157_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_8_cast <= SharedReg157_out;
SharedReg129_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_9_cast <= SharedReg129_out;
SharedReg168_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_10_cast <= SharedReg168_out;
   MUX_Product910_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg8_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg35_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg94_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg169_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg87_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg137_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg143_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg157_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg129_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg168_out_to_MUX_Product910_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Product910_impl_0_LUT_out,
                 oMux => MUX_Product910_impl_0_out);

   Delay1No22_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product910_impl_0_out,
                 Y => Delay1No22_out);

SharedReg4_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_1_cast <= SharedReg4_out;
SharedReg21_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_2_cast <= SharedReg21_out;
SharedReg15_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_3_cast <= SharedReg15_out;
SharedReg30_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_4_cast <= SharedReg30_out;
SharedReg120_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_5_cast <= SharedReg120_out;
SharedReg166_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_6_cast <= SharedReg166_out;
SharedReg184_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_7_cast <= SharedReg184_out;
SharedReg182_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_8_cast <= SharedReg182_out;
SharedReg187_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_9_cast <= SharedReg187_out;
SharedReg186_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_10_cast <= SharedReg186_out;
   MUX_Product910_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg4_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg21_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg15_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg30_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg120_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg166_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg184_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg182_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg187_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg186_out_to_MUX_Product910_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Product910_impl_1_LUT_out,
                 oMux => MUX_Product910_impl_1_out);

   Delay1No23_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product910_impl_1_out,
                 Y => Delay1No23_out);
   Inv_11_instance: OutputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Inv_11_IEEE,
                 X => Delay1No24_out);
Inv_11 <= Inv_11_IEEE;

   Delay1No24_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg42_out,
                 Y => Delay1No24_out);
   Inv_12_instance: OutputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Inv_12_IEEE,
                 X => Delay1No25_out);
Inv_12 <= Inv_12_IEEE;

   Delay1No25_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg49_out,
                 Y => Delay1No25_out);
   Inv_13_instance: OutputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Inv_13_IEEE,
                 X => Delay1No26_out);
Inv_13 <= Inv_13_IEEE;

   Delay1No26_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg64_out,
                 Y => Delay1No26_out);
   Inv_21_instance: OutputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Inv_21_IEEE,
                 X => Delay1No27_out);
Inv_21 <= Inv_21_IEEE;

   Delay1No27_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg69_out,
                 Y => Delay1No27_out);
   Inv_22_instance: OutputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Inv_22_IEEE,
                 X => Delay1No28_out);
Inv_22 <= Inv_22_IEEE;

   Delay1No28_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg73_out,
                 Y => Delay1No28_out);
   Inv_23_instance: OutputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Inv_23_IEEE,
                 X => Delay1No29_out);
Inv_23 <= Inv_23_IEEE;

   Delay1No29_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg77_out,
                 Y => Delay1No29_out);
   Inv_31_instance: OutputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Inv_31_IEEE,
                 X => Delay1No30_out);
Inv_31 <= Inv_31_IEEE;

   Delay1No30_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg83_out,
                 Y => Delay1No30_out);
   Inv_32_instance: OutputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Inv_32_IEEE,
                 X => Delay1No31_out);
Inv_32 <= Inv_32_IEEE;

   Delay1No31_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg87_out,
                 Y => Delay1No31_out);
   Inv_33_instance: OutputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Inv_33_IEEE,
                 X => Delay1No32_out);
Inv_33 <= Inv_33_IEEE;

   Delay1No32_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg94_out,
                 Y => Delay1No32_out);
   Inv_41_instance: OutputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Inv_41_IEEE,
                 X => Delay1No33_out);
Inv_41 <= Inv_41_IEEE;

   Delay1No33_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg100_out,
                 Y => Delay1No33_out);
   Inv_42_instance: OutputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Inv_42_IEEE,
                 X => Delay1No34_out);
Inv_42 <= Inv_42_IEEE;

   Delay1No34_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg55_out,
                 Y => Delay1No34_out);
   Inv_43_instance: OutputIEEE_8_23_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Inv_43_IEEE,
                 X => Delay1No35_out);
Inv_43 <= Inv_43_IEEE;

   Delay1No35_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg60_out,
                 Y => Delay1No35_out);

Delay1No36_out_to_Add30_impl_parent_implementedSystem_port_0_cast <= Delay1No36_out;
Delay1No37_out_to_Add30_impl_parent_implementedSystem_port_1_cast <= Delay1No37_out;
   Add30_impl_instance: FPGenericAddSub_wE_8_wF_23_subX_false_subY_false_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Add30_impl_out,
                 X => Delay1No36_out_to_Add30_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No37_out_to_Add30_impl_parent_implementedSystem_port_1_cast);

Delay23No1_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_1_cast <= Delay23No1_out;
SharedReg104_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_2_cast <= SharedReg104_out;
Delay23No_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_3_cast <= Delay23No_out;
SharedReg87_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_4_cast <= SharedReg87_out;
SharedReg46_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_5_cast <= SharedReg46_out;
Delay15No3_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_6_cast <= Delay15No3_out;
SharedReg93_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_7_cast <= SharedReg93_out;
SharedReg82_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_8_cast <= SharedReg82_out;
SharedReg73_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_9_cast <= SharedReg73_out;
SharedReg75_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_10_cast <= SharedReg75_out;
SharedReg56_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_11_cast <= SharedReg56_out;
   MUX_Add30_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => Delay23No1_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg104_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg56_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_11_cast,
                 iS_2 => Delay23No_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg87_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg46_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => Delay15No3_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg93_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg82_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg73_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg75_out_to_MUX_Add30_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Add30_impl_0_out);

   Delay1No36_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Add30_impl_0_out,
                 Y => Delay1No36_out);

SharedReg165_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_1_cast <= SharedReg165_out;
SharedReg163_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_2_cast <= SharedReg163_out;
SharedReg160_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_3_cast <= SharedReg160_out;
SharedReg94_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_4_cast <= SharedReg94_out;
SharedReg131_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_5_cast <= SharedReg131_out;
SharedReg166_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_6_cast <= SharedReg166_out;
Delay3No21_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_7_cast <= Delay3No21_out;
Delay10No3_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_8_cast <= Delay10No3_out;
SharedReg91_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_9_cast <= SharedReg91_out;
SharedReg85_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_10_cast <= SharedReg85_out;
SharedReg73_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_11_cast <= SharedReg73_out;
   MUX_Add30_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg165_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg163_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg73_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg160_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg94_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg131_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg166_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => Delay3No21_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => Delay10No3_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg91_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg85_out_to_MUX_Add30_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Add30_impl_1_out);

   Delay1No37_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Add30_impl_1_out,
                 Y => Delay1No37_out);

Delay1No38_out_to_Add101_impl_parent_implementedSystem_port_0_cast <= Delay1No38_out;
Delay1No39_out_to_Add101_impl_parent_implementedSystem_port_1_cast <= Delay1No39_out;
   Add101_impl_instance: FPGenericAddSub_wE_8_wF_23_subX_false_subY_false_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Add101_impl_out,
                 X => Delay1No38_out_to_Add101_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No39_out_to_Add101_impl_parent_implementedSystem_port_1_cast);

SharedReg55_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_1_cast <= SharedReg55_out;
Delay36No_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_2_cast <= Delay36No_out;
SharedReg52_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_3_cast <= SharedReg52_out;
SharedReg76_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_4_cast <= SharedReg76_out;
SharedReg61_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_5_cast <= SharedReg61_out;
SharedReg99_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_6_cast <= SharedReg99_out;
SharedReg97_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_7_cast <= SharedReg97_out;
SharedReg76_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_8_cast <= SharedReg76_out;
SharedReg77_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_9_cast <= SharedReg77_out;
Delay24No_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_10_cast <= Delay24No_out;
SharedReg65_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_11_cast <= SharedReg65_out;
   MUX_Add101_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg55_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => Delay36No_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg65_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg52_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg76_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg61_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg99_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg97_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg76_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg77_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => Delay24No_out_to_MUX_Add101_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Add101_impl_0_out);

   Delay1No38_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Add101_impl_0_out,
                 Y => Delay1No38_out);

SharedReg60_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_1_cast <= SharedReg60_out;
SharedReg164_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_2_cast <= SharedReg164_out;
SharedReg61_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_3_cast <= SharedReg61_out;
SharedReg164_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_4_cast <= SharedReg164_out;
SharedReg134_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_5_cast <= SharedReg134_out;
SharedReg129_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_6_cast <= SharedReg129_out;
SharedReg124_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_7_cast <= SharedReg124_out;
SharedReg110_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_8_cast <= SharedReg110_out;
SharedReg122_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_9_cast <= SharedReg122_out;
SharedReg109_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_10_cast <= SharedReg109_out;
SharedReg77_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_11_cast <= SharedReg77_out;
   MUX_Add101_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_11_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg60_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg164_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_2_cast,
                 iS_10 => SharedReg77_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_11_cast,
                 iS_2 => SharedReg61_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg164_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg134_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg129_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg124_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg110_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg122_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg109_out_to_MUX_Add101_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => ModCount111_out,
                 oMux => MUX_Add101_impl_1_out);

   Delay1No39_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Add101_impl_1_out,
                 Y => Delay1No39_out);

Delay1No40_out_to_Add111_impl_parent_implementedSystem_port_0_cast <= Delay1No40_out;
Delay1No41_out_to_Add111_impl_parent_implementedSystem_port_1_cast <= Delay1No41_out;
   Add111_impl_instance: FPGenericAddSub_wE_8_wF_23_subX_false_subY_false_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Add111_impl_out,
                 X => Delay1No40_out_to_Add111_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No41_out_to_Add111_impl_parent_implementedSystem_port_1_cast);

Delay5No_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_1_cast <= Delay5No_out;
SharedReg42_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_2_cast <= SharedReg42_out;
SharedReg69_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_3_cast <= SharedReg69_out;
SharedReg48_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_4_cast <= SharedReg48_out;
SharedReg54_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_5_cast <= SharedReg54_out;
SharedReg74_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_6_cast <= SharedReg74_out;
Delay11No4_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_7_cast <= Delay11No4_out;
SharedReg138_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_8_cast <= SharedReg138_out;
SharedReg84_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_9_cast <= SharedReg84_out;
Delay80No1_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_10_cast <= Delay80No1_out;
   MUX_Add111_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => Delay5No_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg42_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg69_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg48_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg54_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg74_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => Delay11No4_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg138_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg84_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => Delay80No1_out_to_MUX_Add111_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Add111_impl_0_LUT_out,
                 oMux => MUX_Add111_impl_0_out);

   Delay1No40_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Add111_impl_0_out,
                 Y => Delay1No40_out);

SharedReg117_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_1_cast <= SharedReg117_out;
SharedReg73_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_2_cast <= SharedReg73_out;
SharedReg68_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_3_cast <= SharedReg68_out;
SharedReg71_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_4_cast <= SharedReg71_out;
SharedReg161_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_5_cast <= SharedReg161_out;
SharedReg159_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_6_cast <= SharedReg159_out;
SharedReg162_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_7_cast <= SharedReg162_out;
SharedReg159_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_8_cast <= SharedReg159_out;
SharedReg129_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_9_cast <= SharedReg129_out;
SharedReg146_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_10_cast <= SharedReg146_out;
   MUX_Add111_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg117_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg73_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg68_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg71_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg161_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg159_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg162_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg159_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg129_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg146_out_to_MUX_Add111_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Add111_impl_1_LUT_out,
                 oMux => MUX_Add111_impl_1_out);

   Delay1No41_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Add111_impl_1_out,
                 Y => Delay1No41_out);

Delay1No42_out_to_Add210_impl_parent_implementedSystem_port_0_cast <= Delay1No42_out;
Delay1No43_out_to_Add210_impl_parent_implementedSystem_port_1_cast <= Delay1No43_out;
   Add210_impl_instance: FPGenericAddSub_wE_8_wF_23_subX_false_subY_false_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Add210_impl_out,
                 X => Delay1No42_out_to_Add210_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No43_out_to_Add210_impl_parent_implementedSystem_port_1_cast);

Delay5No6_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_1_cast <= Delay5No6_out;
Delay18No_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_2_cast <= Delay18No_out;
SharedReg43_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_3_cast <= SharedReg43_out;
Delay17No2_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_4_cast <= Delay17No2_out;
Delay66No_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_5_cast <= Delay66No_out;
SharedReg106_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_6_cast <= SharedReg106_out;
Delay73No_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_7_cast <= Delay73No_out;
SharedReg105_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_8_cast <= SharedReg105_out;
SharedReg139_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_9_cast <= SharedReg139_out;
SharedReg86_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_10_cast <= SharedReg86_out;
   MUX_Add210_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => Delay5No6_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => Delay18No_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg43_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => Delay17No2_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => Delay66No_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg106_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => Delay73No_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg105_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg139_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg86_out_to_MUX_Add210_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Add210_impl_0_LUT_out,
                 oMux => MUX_Add210_impl_0_out);

   Delay1No42_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Add210_impl_0_out,
                 Y => Delay1No42_out);

SharedReg66_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_1_cast <= SharedReg66_out;
SharedReg159_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_2_cast <= SharedReg159_out;
SharedReg160_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_3_cast <= SharedReg160_out;
SharedReg115_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_4_cast <= SharedReg115_out;
SharedReg166_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_5_cast <= SharedReg166_out;
SharedReg166_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_6_cast <= SharedReg166_out;
SharedReg129_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_7_cast <= SharedReg129_out;
SharedReg115_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_8_cast <= SharedReg115_out;
SharedReg129_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_9_cast <= SharedReg129_out;
SharedReg151_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_10_cast <= SharedReg151_out;
   MUX_Add210_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg66_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg159_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg160_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg115_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg166_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg166_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg129_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg115_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg129_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg151_out_to_MUX_Add210_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Add210_impl_1_LUT_out,
                 oMux => MUX_Add210_impl_1_out);

   Delay1No43_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Add210_impl_1_out,
                 Y => Delay1No43_out);

Delay1No44_out_to_Product312_impl_parent_implementedSystem_port_0_cast <= Delay1No44_out;
Delay1No45_out_to_Product312_impl_parent_implementedSystem_port_1_cast <= Delay1No45_out;
   Product312_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product312_impl_out,
                 X => Delay1No44_out_to_Product312_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No45_out_to_Product312_impl_parent_implementedSystem_port_1_cast);

SharedReg1_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_1_cast <= SharedReg1_out;
Delay14No2_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_2_cast <= Delay14No2_out;
SharedReg29_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_3_cast <= SharedReg29_out;
SharedReg58_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_4_cast <= SharedReg58_out;
SharedReg153_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_5_cast <= SharedReg153_out;
SharedReg152_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_6_cast <= SharedReg152_out;
SharedReg149_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_7_cast <= SharedReg149_out;
SharedReg152_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_8_cast <= SharedReg152_out;
SharedReg154_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_9_cast <= SharedReg154_out;
SharedReg122_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_10_cast <= SharedReg122_out;
   MUX_Product312_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg1_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => Delay14No2_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg29_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg58_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg153_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg152_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg149_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg152_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg154_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg122_out_to_MUX_Product312_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Product312_impl_0_LUT_out,
                 oMux => MUX_Product312_impl_0_out);

   Delay1No44_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product312_impl_0_out,
                 Y => Delay1No44_out);

SharedReg22_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_1_cast <= SharedReg22_out;
SharedReg34_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_2_cast <= SharedReg34_out;
SharedReg30_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_3_cast <= SharedReg30_out;
SharedReg133_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_4_cast <= SharedReg133_out;
SharedReg166_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_5_cast <= SharedReg166_out;
SharedReg183_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_6_cast <= SharedReg183_out;
SharedReg176_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_7_cast <= SharedReg176_out;
SharedReg181_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_8_cast <= SharedReg181_out;
SharedReg178_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_9_cast <= SharedReg178_out;
SharedReg182_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_10_cast <= SharedReg182_out;
   MUX_Product312_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg22_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg34_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg30_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg133_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg166_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg183_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg176_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg181_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg178_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg182_out_to_MUX_Product312_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Product312_impl_1_LUT_out,
                 oMux => MUX_Product312_impl_1_out);

   Delay1No45_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product312_impl_1_out,
                 Y => Delay1No45_out);

Delay1No46_out_to_Product73_impl_parent_implementedSystem_port_0_cast <= Delay1No46_out;
Delay1No47_out_to_Product73_impl_parent_implementedSystem_port_1_cast <= Delay1No47_out;
   Product73_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product73_impl_out,
                 X => Delay1No46_out_to_Product73_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No47_out_to_Product73_impl_parent_implementedSystem_port_1_cast);

SharedReg_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_1_cast <= SharedReg_out;
SharedReg14_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_2_cast <= SharedReg14_out;
SharedReg9_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_3_cast <= SharedReg9_out;
SharedReg100_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_4_cast <= SharedReg100_out;
SharedReg150_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_5_cast <= SharedReg150_out;
SharedReg141_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_6_cast <= SharedReg141_out;
SharedReg134_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_7_cast <= SharedReg134_out;
SharedReg94_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_8_cast <= SharedReg94_out;
SharedReg125_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_9_cast <= SharedReg125_out;
SharedReg130_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_10_cast <= SharedReg130_out;
   MUX_Product73_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg14_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg9_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg100_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg150_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg141_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg134_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg94_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg125_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg130_out_to_MUX_Product73_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Product73_impl_0_LUT_out,
                 oMux => MUX_Product73_impl_0_out);

   Delay1No46_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product73_impl_0_out,
                 Y => Delay1No46_out);

SharedReg16_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_1_cast <= SharedReg16_out;
SharedReg15_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_2_cast <= SharedReg15_out;
SharedReg34_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_3_cast <= SharedReg34_out;
Delay15No1_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_4_cast <= Delay15No1_out;
SharedReg129_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_5_cast <= SharedReg129_out;
SharedReg184_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_6_cast <= SharedReg184_out;
SharedReg189_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_7_cast <= SharedReg189_out;
SharedReg179_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_8_cast <= SharedReg179_out;
SharedReg186_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_9_cast <= SharedReg186_out;
SharedReg174_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_10_cast <= SharedReg174_out;
   MUX_Product73_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg16_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg15_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg34_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => Delay15No1_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg129_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg184_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg189_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg179_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg186_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg174_out_to_MUX_Product73_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Product73_impl_1_LUT_out,
                 oMux => MUX_Product73_impl_1_out);

   Delay1No47_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product73_impl_1_out,
                 Y => Delay1No47_out);

Delay1No48_out_to_Product84_impl_parent_implementedSystem_port_0_cast <= Delay1No48_out;
Delay1No49_out_to_Product84_impl_parent_implementedSystem_port_1_cast <= Delay1No49_out;
   Product84_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product84_impl_out,
                 X => Delay1No48_out_to_Product84_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No49_out_to_Product84_impl_parent_implementedSystem_port_1_cast);

SharedReg1_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_1_cast <= SharedReg1_out;
Delay1No76_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_2_cast <= Delay1No76_out;
SharedReg134_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_3_cast <= SharedReg134_out;
SharedReg88_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_4_cast <= SharedReg88_out;
SharedReg147_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_5_cast <= SharedReg147_out;
SharedReg100_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_6_cast <= SharedReg100_out;
SharedReg146_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_7_cast <= SharedReg146_out;
SharedReg151_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_8_cast <= SharedReg151_out;
SharedReg123_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_9_cast <= SharedReg123_out;
SharedReg122_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_10_cast <= SharedReg122_out;
   MUX_Product84_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg1_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => Delay1No76_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg134_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg88_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg147_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg100_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg146_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg151_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg123_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg122_out_to_MUX_Product84_impl_0_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Product84_impl_0_LUT_out,
                 oMux => MUX_Product84_impl_0_out);

   Delay1No48_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product84_impl_0_out,
                 Y => Delay1No48_out);

SharedReg30_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_1_cast <= SharedReg30_out;
SharedReg41_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_2_cast <= SharedReg41_out;
SharedReg166_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_3_cast <= SharedReg166_out;
SharedReg184_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_4_cast <= SharedReg184_out;
SharedReg175_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_5_cast <= SharedReg175_out;
SharedReg174_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_6_cast <= SharedReg174_out;
SharedReg180_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_7_cast <= SharedReg180_out;
SharedReg181_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_8_cast <= SharedReg181_out;
SharedReg178_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_9_cast <= SharedReg178_out;
SharedReg170_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_10_cast <= SharedReg170_out;
   MUX_Product84_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_10_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg30_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg41_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg166_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg184_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg175_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg174_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg180_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg181_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg178_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_9_cast,
                 iS_9 => SharedReg170_out_to_MUX_Product84_impl_1_parent_implementedSystem_port_10_cast,
                 iSel => MUX_Product84_impl_1_LUT_out,
                 oMux => MUX_Product84_impl_1_out);

   Delay1No49_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product84_impl_1_out,
                 Y => Delay1No49_out);

Delay1No50_out_to_Product85_impl_parent_implementedSystem_port_0_cast <= Delay1No50_out;
Delay1No51_out_to_Product85_impl_parent_implementedSystem_port_1_cast <= Delay1No51_out;
   Product85_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product85_impl_out,
                 X => Delay1No50_out_to_Product85_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No51_out_to_Product85_impl_parent_implementedSystem_port_1_cast);

Delay11No_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_1_cast <= Delay11No_out;
SharedReg2_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_2_cast <= SharedReg2_out;
SharedReg8_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_3_cast <= SharedReg8_out;
Delay1No77_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_4_cast <= Delay1No77_out;
SharedReg146_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_5_cast <= SharedReg146_out;
SharedReg140_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_6_cast <= SharedReg140_out;
SharedReg134_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_7_cast <= SharedReg134_out;
SharedReg151_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_8_cast <= SharedReg151_out;
SharedReg166_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_9_cast <= SharedReg166_out;
   MUX_Product85_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_9_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => Delay11No_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg2_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg8_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => Delay1No77_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg146_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg140_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg134_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg151_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg166_out_to_MUX_Product85_impl_0_parent_implementedSystem_port_9_cast,
                 iSel => MUX_Product85_impl_0_LUT_out,
                 oMux => MUX_Product85_impl_0_out);

   Delay1No50_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product85_impl_0_out,
                 Y => Delay1No50_out);

SharedReg24_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_1_cast <= SharedReg24_out;
SharedReg30_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_2_cast <= SharedReg30_out;
SharedReg129_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_3_cast <= SharedReg129_out;
SharedReg167_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_4_cast <= SharedReg167_out;
SharedReg174_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_5_cast <= SharedReg174_out;
SharedReg175_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_6_cast <= SharedReg175_out;
SharedReg176_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_7_cast <= SharedReg176_out;
SharedReg178_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_8_cast <= SharedReg178_out;
SharedReg170_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_9_cast <= SharedReg170_out;
   MUX_Product85_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_9_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg24_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg30_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg129_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg167_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg174_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg175_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg176_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg178_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg170_out_to_MUX_Product85_impl_1_parent_implementedSystem_port_9_cast,
                 iSel => MUX_Product85_impl_1_LUT_out,
                 oMux => MUX_Product85_impl_1_out);

   Delay1No51_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product85_impl_1_out,
                 Y => Delay1No51_out);

Delay1No52_out_to_Product99_impl_parent_implementedSystem_port_0_cast <= Delay1No52_out;
Delay1No53_out_to_Product99_impl_parent_implementedSystem_port_1_cast <= Delay1No53_out;
   Product99_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_mult_Y_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Product99_impl_out,
                 X => Delay1No52_out_to_Product99_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No53_out_to_Product99_impl_parent_implementedSystem_port_1_cast);

SharedReg6_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_1_cast <= SharedReg6_out;
Delay1No78_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_2_cast <= Delay1No78_out;
SharedReg144_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_3_cast <= SharedReg144_out;
SharedReg146_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_4_cast <= SharedReg146_out;
SharedReg140_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_5_cast <= SharedReg140_out;
SharedReg156_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_6_cast <= SharedReg156_out;
SharedReg123_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_7_cast <= SharedReg123_out;
SharedReg124_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_8_cast <= SharedReg124_out;
   MUX_Product99_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_8_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg6_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => Delay1No78_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg144_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg146_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg140_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg156_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg123_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg124_out_to_MUX_Product99_impl_0_parent_implementedSystem_port_8_cast,
                 iSel => MUX_Product99_impl_0_LUT_out,
                 oMux => MUX_Product99_impl_0_out);

   Delay1No52_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product99_impl_0_out,
                 Y => Delay1No52_out);

SharedReg130_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_1_cast <= SharedReg130_out;
SharedReg132_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_2_cast <= SharedReg132_out;
SharedReg166_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_3_cast <= SharedReg166_out;
SharedReg181_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_4_cast <= SharedReg181_out;
SharedReg184_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_5_cast <= SharedReg184_out;
SharedReg174_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_6_cast <= SharedReg174_out;
SharedReg178_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_7_cast <= SharedReg178_out;
SharedReg170_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_8_cast <= SharedReg170_out;
   MUX_Product99_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_8_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg130_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg132_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg166_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg181_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg184_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg174_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg178_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg170_out_to_MUX_Product99_impl_1_parent_implementedSystem_port_8_cast,
                 iSel => MUX_Product99_impl_1_LUT_out,
                 oMux => MUX_Product99_impl_1_out);

   Delay1No53_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Product99_impl_1_out,
                 Y => Delay1No53_out);

Delay1No54_out_to_Subtract12_impl_parent_implementedSystem_port_0_cast <= Delay1No54_out;
Delay1No55_out_to_Subtract12_impl_parent_implementedSystem_port_1_cast <= Delay1No55_out;
   Subtract12_impl_instance: FPGenericAddSub_wE_8_wF_23_subX_false_subY_true_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Subtract12_impl_out,
                 X => Delay1No54_out_to_Subtract12_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No55_out_to_Subtract12_impl_parent_implementedSystem_port_1_cast);

SharedReg51_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_1_cast <= SharedReg51_out;
SharedReg47_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_2_cast <= SharedReg47_out;
SharedReg57_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_3_cast <= SharedReg57_out;
SharedReg53_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_4_cast <= SharedReg53_out;
Delay17No1_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_5_cast <= Delay17No1_out;
SharedReg59_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_6_cast <= SharedReg59_out;
SharedReg80_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_7_cast <= SharedReg80_out;
SharedReg67_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_8_cast <= SharedReg67_out;
SharedReg81_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_9_cast <= SharedReg81_out;
   MUX_Subtract12_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_9_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg51_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg47_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg57_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg53_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => Delay17No1_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg59_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg80_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg67_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg81_out_to_MUX_Subtract12_impl_0_parent_implementedSystem_port_9_cast,
                 iSel => MUX_Subtract12_impl_0_LUT_out,
                 oMux => MUX_Subtract12_impl_0_out);

   Delay1No54_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Subtract12_impl_0_out,
                 Y => Delay1No54_out);

SharedReg109_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_1_cast <= SharedReg109_out;
SharedReg116_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_2_cast <= SharedReg116_out;
SharedReg107_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_3_cast <= SharedReg107_out;
SharedReg132_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_4_cast <= SharedReg132_out;
SharedReg115_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_5_cast <= SharedReg115_out;
SharedReg123_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_6_cast <= SharedReg123_out;
SharedReg122_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_7_cast <= SharedReg122_out;
SharedReg115_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_8_cast <= SharedReg115_out;
SharedReg122_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_9_cast <= SharedReg122_out;
   MUX_Subtract12_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_9_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg109_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg116_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg107_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg132_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg115_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => SharedReg123_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg122_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_7_cast,
                 iS_7 => SharedReg115_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_8_cast,
                 iS_8 => SharedReg122_out_to_MUX_Subtract12_impl_1_parent_implementedSystem_port_9_cast,
                 iSel => MUX_Subtract12_impl_1_LUT_out,
                 oMux => MUX_Subtract12_impl_1_out);

   Delay1No55_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Subtract12_impl_1_out,
                 Y => Delay1No55_out);

Delay1No56_out_to_Subtract7_impl_parent_implementedSystem_port_0_cast <= Delay1No56_out;
Delay1No57_out_to_Subtract7_impl_parent_implementedSystem_port_1_cast <= Delay1No57_out;
   Subtract7_impl_instance: FPGenericAddSub_wE_8_wF_23_subX_false_subY_true_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Subtract7_impl_out,
                 X => Delay1No56_out_to_Subtract7_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No57_out_to_Subtract7_impl_parent_implementedSystem_port_1_cast);

SharedReg72_out_to_MUX_Subtract7_impl_0_parent_implementedSystem_port_1_cast <= SharedReg72_out;
SharedReg92_out_to_MUX_Subtract7_impl_0_parent_implementedSystem_port_2_cast <= SharedReg92_out;
SharedReg98_out_to_MUX_Subtract7_impl_0_parent_implementedSystem_port_3_cast <= SharedReg98_out;
Delay44No_out_to_MUX_Subtract7_impl_0_parent_implementedSystem_port_4_cast <= Delay44No_out;
   MUX_Subtract7_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_4_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg72_out_to_MUX_Subtract7_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg92_out_to_MUX_Subtract7_impl_0_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg98_out_to_MUX_Subtract7_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => Delay44No_out_to_MUX_Subtract7_impl_0_parent_implementedSystem_port_4_cast,
                 iSel => MUX_Subtract7_impl_0_LUT_out,
                 oMux => MUX_Subtract7_impl_0_out);

   Delay1No56_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Subtract7_impl_0_out,
                 Y => Delay1No56_out);

SharedReg119_out_to_MUX_Subtract7_impl_1_parent_implementedSystem_port_1_cast <= SharedReg119_out;
SharedReg108_out_to_MUX_Subtract7_impl_1_parent_implementedSystem_port_2_cast <= SharedReg108_out;
SharedReg118_out_to_MUX_Subtract7_impl_1_parent_implementedSystem_port_3_cast <= SharedReg118_out;
SharedReg166_out_to_MUX_Subtract7_impl_1_parent_implementedSystem_port_4_cast <= SharedReg166_out;
   MUX_Subtract7_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_4_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg119_out_to_MUX_Subtract7_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg108_out_to_MUX_Subtract7_impl_1_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg118_out_to_MUX_Subtract7_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg166_out_to_MUX_Subtract7_impl_1_parent_implementedSystem_port_4_cast,
                 iSel => MUX_Subtract7_impl_1_LUT_out,
                 oMux => MUX_Subtract7_impl_1_out);

   Delay1No57_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Subtract7_impl_1_out,
                 Y => Delay1No57_out);

Delay1No58_out_to_Add32_impl_parent_implementedSystem_port_0_cast <= Delay1No58_out;
Delay1No59_out_to_Add32_impl_parent_implementedSystem_port_1_cast <= Delay1No59_out;
   Add32_impl_instance: FPGenericAddSub_wE_8_wF_23_subX_false_subY_false_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Add32_impl_out,
                 X => Delay1No58_out_to_Add32_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No59_out_to_Add32_impl_parent_implementedSystem_port_1_cast);

Delay5No8_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_1_cast <= Delay5No8_out;
Delay24No1_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_2_cast <= Delay24No1_out;
Delay30No_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_3_cast <= Delay30No_out;
SharedReg145_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_4_cast <= SharedReg145_out;
SharedReg158_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_5_cast <= SharedReg158_out;
Delay64No1_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_6_cast <= Delay64No1_out;
SharedReg156_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_7_cast <= SharedReg156_out;
   MUX_Add32_impl_0_instance: Mux_sign_1_wordsize_34_numberOfInputs_7_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => Delay5No8_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_1_cast,
                 iS_1 => Delay24No1_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_2_cast,
                 iS_2 => Delay30No_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg145_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg158_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_5_cast,
                 iS_5 => Delay64No1_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg156_out_to_MUX_Add32_impl_0_parent_implementedSystem_port_7_cast,
                 iSel => MUX_Add32_impl_0_LUT_out,
                 oMux => MUX_Add32_impl_0_out);

   Delay1No58_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Add32_impl_0_out,
                 Y => Delay1No58_out);

SharedReg129_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_1_cast <= SharedReg129_out;
SharedReg107_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_2_cast <= SharedReg107_out;
SharedReg122_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_3_cast <= SharedReg122_out;
SharedReg166_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_4_cast <= SharedReg166_out;
SharedReg166_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_5_cast <= SharedReg166_out;
Delay10No5_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_6_cast <= Delay10No5_out;
SharedReg156_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_7_cast <= SharedReg156_out;
   MUX_Add32_impl_1_instance: Mux_sign_1_wordsize_34_numberOfInputs_7_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 iS_0 => SharedReg129_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_1_cast,
                 iS_1 => SharedReg107_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_2_cast,
                 iS_2 => SharedReg122_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_3_cast,
                 iS_3 => SharedReg166_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_4_cast,
                 iS_4 => SharedReg166_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_5_cast,
                 iS_5 => Delay10No5_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_6_cast,
                 iS_6 => SharedReg156_out_to_MUX_Add32_impl_1_parent_implementedSystem_port_7_cast,
                 iSel => MUX_Add32_impl_1_LUT_out,
                 oMux => MUX_Add32_impl_1_out);

   Delay1No59_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => MUX_Add32_impl_1_out,
                 Y => Delay1No59_out);
   Constant1_impl_instance: Constant_float_8_23_1_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Y => Constant1_impl_out);

Delay1No60_out_to_Divide_impl_parent_implementedSystem_port_0_cast <= Delay1No60_out;
Delay1No61_out_to_Divide_impl_parent_implementedSystem_port_1_cast <= Delay1No61_out;
   Divide_impl_instance: FPMultiplier_in_8_23_8_23_out_8_23_mult_X_div_Y_component  -- pipelineDepth=12 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => Divide_impl_out,
                 X => Delay1No60_out_to_Divide_impl_parent_implementedSystem_port_0_cast,
                 Y => Delay1No61_out_to_Divide_impl_parent_implementedSystem_port_1_cast);

   Delay1No60_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Delay107No_out,
                 Y => Delay1No60_out);

   Delay1No61_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg129_out,
                 Y => Delay1No61_out);
   Constant_impl_instance: Constant_float_8_23_348_mult_8en9_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Y => Constant_impl_out);

   Delay5No_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Ldiff_UU_del_1_out,
                 Y => Delay5No_out);

   Delay11No_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg6_out,
                 Y => Delay11No_out);

   Delay14No_instance: Delay_34_DelayLength_4_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=4 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg14_out,
                 Y => Delay14No_out);

   Delay16No_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg21_out,
                 Y => Delay16No_out);

   Delay5No6_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Ldiff_VV_del_1_out,
                 Y => Delay5No6_out);

   Delay20No_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg28_out,
                 Y => Delay20No_out);

   Delay14No2_instance: Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg34_out,
                 Y => Delay14No2_out);

   Delay15No1_instance: Delay_34_DelayLength_4_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=4 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg41_out,
                 Y => Delay15No1_out);

   Delay5No8_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Ldiff_WW_del_1_out,
                 Y => Delay5No8_out);

   Delay1No76_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => R_U_out,
                 Y => Delay1No76_out);

   Delay1No77_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => R_V_out,
                 Y => Delay1No77_out);

   Delay1No78_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => R_W_out,
                 Y => Delay1No78_out);

   Delay89No_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg114_out,
                 Y => Delay89No_out);

   Delay92No_instance: Delay_34_DelayLength_14_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=14 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg121_out,
                 Y => Delay92No_out);

   Delay96No_instance: Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg128_out,
                 Y => Delay96No_out);

   Delay88No1_instance: Delay_34_DelayLength_83_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=83 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg133_out,
                 Y => Delay88No1_out);

   Delay23No_instance: Delay_34_DelayLength_11_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=11 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg48_out,
                 Y => Delay23No_out);

   Delay18No_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg54_out,
                 Y => Delay18No_out);

   Delay17No1_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg59_out,
                 Y => Delay17No1_out);

   Delay17No2_instance: Delay_34_DelayLength_13_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=13 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg63_out,
                 Y => Delay17No2_out);

   Delay11No4_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg72_out,
                 Y => Delay11No4_out);

   Delay24No_instance: Delay_34_DelayLength_19_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=19 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg68_out,
                 Y => Delay24No_out);

   Delay23No1_instance: Delay_34_DelayLength_8_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=8 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg86_out,
                 Y => Delay23No1_out);

   Delay10No3_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg163_out,
                 Y => Delay10No3_out);

   Delay3No21_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg165_out,
                 Y => Delay3No21_out);

   Delay107No_instance: Delay_34_DelayLength_107_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=107 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Constant1_impl_out,
                 Y => Delay107No_out);

   Delay66No_instance: Delay_34_DelayLength_8_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=8 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg106_out,
                 Y => Delay66No_out);

   Delay73No_instance: Delay_34_DelayLength_32_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=32 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg99_out,
                 Y => Delay73No_out);

   Delay36No_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg145_out,
                 Y => Delay36No_out);

   Delay44No_instance: Delay_34_DelayLength_21_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=21 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg139_out,
                 Y => Delay44No_out);

   Delay24No1_instance: Delay_34_DelayLength_7_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=7 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg76_out,
                 Y => Delay24No1_out);

   Delay30No_instance: Delay_34_DelayLength_14_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=14 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg82_out,
                 Y => Delay30No_out);

   Delay15No3_instance: Delay_34_DelayLength_8_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=8 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg150_out,
                 Y => Delay15No3_out);

   Delay64No1_instance: Delay_34_DelayLength_52_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=52 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg93_out,
                 Y => Delay64No1_out);

   Delay10No5_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg155_out,
                 Y => Delay10No5_out);

   Delay80No1_instance: Delay_34_DelayLength_66_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=66 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg158_out,
                 Y => Delay80No1_out);

   Delay7No14_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg168_out,
                 Y => Delay7No14_out);

   Delay38No_instance: Delay_34_DelayLength_8_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=8 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg191_out,
                 Y => Delay38No_out);

   MUX_Product810_impl_0_LUT_instance: GenericLut_LUTData_MUX_Product810_impl_0_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product810_impl_0_LUT_out);

   MUX_Product810_impl_1_LUT_instance: GenericLut_LUTData_MUX_Product810_impl_1_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product810_impl_1_LUT_out);

   MUX_Product910_impl_0_LUT_instance: GenericLut_LUTData_MUX_Product910_impl_0_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product910_impl_0_LUT_out);

   MUX_Product910_impl_1_LUT_instance: GenericLut_LUTData_MUX_Product910_impl_1_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product910_impl_1_LUT_out);

   MUX_Add111_impl_0_LUT_instance: GenericLut_LUTData_MUX_Add111_impl_0_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Add111_impl_0_LUT_out);

   MUX_Add111_impl_1_LUT_instance: GenericLut_LUTData_MUX_Add111_impl_1_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Add111_impl_1_LUT_out);

   MUX_Add210_impl_0_LUT_instance: GenericLut_LUTData_MUX_Add210_impl_0_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Add210_impl_0_LUT_out);

   MUX_Add210_impl_1_LUT_instance: GenericLut_LUTData_MUX_Add210_impl_1_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Add210_impl_1_LUT_out);

   MUX_Product312_impl_0_LUT_instance: GenericLut_LUTData_MUX_Product312_impl_0_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product312_impl_0_LUT_out);

   MUX_Product312_impl_1_LUT_instance: GenericLut_LUTData_MUX_Product312_impl_1_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product312_impl_1_LUT_out);

   MUX_Product73_impl_0_LUT_instance: GenericLut_LUTData_MUX_Product73_impl_0_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product73_impl_0_LUT_out);

   MUX_Product73_impl_1_LUT_instance: GenericLut_LUTData_MUX_Product73_impl_1_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product73_impl_1_LUT_out);

   MUX_Product84_impl_0_LUT_instance: GenericLut_LUTData_MUX_Product84_impl_0_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product84_impl_0_LUT_out);

   MUX_Product84_impl_1_LUT_instance: GenericLut_LUTData_MUX_Product84_impl_1_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product84_impl_1_LUT_out);

   MUX_Product85_impl_0_LUT_instance: GenericLut_LUTData_MUX_Product85_impl_0_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product85_impl_0_LUT_out);

   MUX_Product85_impl_1_LUT_instance: GenericLut_LUTData_MUX_Product85_impl_1_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product85_impl_1_LUT_out);

   MUX_Product99_impl_0_LUT_instance: GenericLut_LUTData_MUX_Product99_impl_0_LUT_wIn_4_wOut_3_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product99_impl_0_LUT_out);

   MUX_Product99_impl_1_LUT_instance: GenericLut_LUTData_MUX_Product99_impl_1_LUT_wIn_4_wOut_3_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Product99_impl_1_LUT_out);

   MUX_Subtract12_impl_0_LUT_instance: GenericLut_LUTData_MUX_Subtract12_impl_0_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Subtract12_impl_0_LUT_out);

   MUX_Subtract12_impl_1_LUT_instance: GenericLut_LUTData_MUX_Subtract12_impl_1_LUT_wIn_4_wOut_4_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Subtract12_impl_1_LUT_out);

   MUX_Subtract7_impl_0_LUT_instance: GenericLut_LUTData_MUX_Subtract7_impl_0_LUT_wIn_4_wOut_2_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Subtract7_impl_0_LUT_out);

   MUX_Subtract7_impl_1_LUT_instance: GenericLut_LUTData_MUX_Subtract7_impl_1_LUT_wIn_4_wOut_2_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Subtract7_impl_1_LUT_out);

   MUX_Add32_impl_0_LUT_instance: GenericLut_LUTData_MUX_Add32_impl_0_LUT_wIn_4_wOut_3_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Add32_impl_0_LUT_out);

   MUX_Add32_impl_1_LUT_instance: GenericLut_LUTData_MUX_Add32_impl_1_LUT_wIn_4_wOut_3_wrapper_component  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Input => ModCount111_out,
                 Output => MUX_Add32_impl_1_LUT_out);

   SharedReg_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Ldiff_UV_del_1_out,
                 Y => SharedReg_out);

   SharedReg1_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg_out,
                 Y => SharedReg1_out);

   SharedReg2_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg1_out,
                 Y => SharedReg2_out);

   SharedReg3_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg2_out,
                 Y => SharedReg3_out);

   SharedReg4_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg3_out,
                 Y => SharedReg4_out);

   SharedReg5_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg4_out,
                 Y => SharedReg5_out);

   SharedReg6_instance: Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg5_out,
                 Y => SharedReg6_out);

   SharedReg7_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Ldiff_UW_del_1_out,
                 Y => SharedReg7_out);

   SharedReg8_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg7_out,
                 Y => SharedReg8_out);

   SharedReg9_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg8_out,
                 Y => SharedReg9_out);

   SharedReg10_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg9_out,
                 Y => SharedReg10_out);

   SharedReg11_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg10_out,
                 Y => SharedReg11_out);

   SharedReg12_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg11_out,
                 Y => SharedReg12_out);

   SharedReg13_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg12_out,
                 Y => SharedReg13_out);

   SharedReg14_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg13_out,
                 Y => SharedReg14_out);

   SharedReg15_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Ldiff_VU_del_1_out,
                 Y => SharedReg15_out);

   SharedReg16_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg15_out,
                 Y => SharedReg16_out);

   SharedReg17_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg16_out,
                 Y => SharedReg17_out);

   SharedReg18_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg17_out,
                 Y => SharedReg18_out);

   SharedReg19_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg18_out,
                 Y => SharedReg19_out);

   SharedReg20_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg19_out,
                 Y => SharedReg20_out);

   SharedReg21_instance: Delay_34_DelayLength_6_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=6 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg20_out,
                 Y => SharedReg21_out);

   SharedReg22_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Ldiff_VW_del_1_out,
                 Y => SharedReg22_out);

   SharedReg23_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg22_out,
                 Y => SharedReg23_out);

   SharedReg24_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg23_out,
                 Y => SharedReg24_out);

   SharedReg25_instance: Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg24_out,
                 Y => SharedReg25_out);

   SharedReg26_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg25_out,
                 Y => SharedReg26_out);

   SharedReg27_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg26_out,
                 Y => SharedReg27_out);

   SharedReg28_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg27_out,
                 Y => SharedReg28_out);

   SharedReg29_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Ldiff_WU_del_1_out,
                 Y => SharedReg29_out);

   SharedReg30_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg29_out,
                 Y => SharedReg30_out);

   SharedReg31_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg30_out,
                 Y => SharedReg31_out);

   SharedReg32_instance: Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg31_out,
                 Y => SharedReg32_out);

   SharedReg33_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg32_out,
                 Y => SharedReg33_out);

   SharedReg34_instance: Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg33_out,
                 Y => SharedReg34_out);

   SharedReg35_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Ldiff_WV_del_1_out,
                 Y => SharedReg35_out);

   SharedReg36_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg35_out,
                 Y => SharedReg36_out);

   SharedReg37_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg36_out,
                 Y => SharedReg37_out);

   SharedReg38_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg37_out,
                 Y => SharedReg38_out);

   SharedReg39_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg38_out,
                 Y => SharedReg39_out);

   SharedReg40_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg39_out,
                 Y => SharedReg40_out);

   SharedReg41_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg40_out,
                 Y => SharedReg41_out);

   SharedReg42_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product108_impl_out,
                 Y => SharedReg42_out);

   SharedReg43_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg42_out,
                 Y => SharedReg43_out);

   SharedReg44_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg43_out,
                 Y => SharedReg44_out);

   SharedReg45_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg44_out,
                 Y => SharedReg45_out);

   SharedReg46_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg45_out,
                 Y => SharedReg46_out);

   SharedReg47_instance: Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg46_out,
                 Y => SharedReg47_out);

   SharedReg48_instance: Delay_34_DelayLength_4_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=4 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg47_out,
                 Y => SharedReg48_out);

   SharedReg49_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product110_impl_out,
                 Y => SharedReg49_out);

   SharedReg50_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg49_out,
                 Y => SharedReg50_out);

   SharedReg51_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg50_out,
                 Y => SharedReg51_out);

   SharedReg52_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg51_out,
                 Y => SharedReg52_out);

   SharedReg53_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg52_out,
                 Y => SharedReg53_out);

   SharedReg54_instance: Delay_34_DelayLength_10_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=10 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg53_out,
                 Y => SharedReg54_out);

   SharedReg55_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product109_impl_out,
                 Y => SharedReg55_out);

   SharedReg56_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg55_out,
                 Y => SharedReg56_out);

   SharedReg57_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg56_out,
                 Y => SharedReg57_out);

   SharedReg58_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg57_out,
                 Y => SharedReg58_out);

   SharedReg59_instance: Delay_34_DelayLength_8_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=8 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg58_out,
                 Y => SharedReg59_out);

   SharedReg60_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product111_impl_out,
                 Y => SharedReg60_out);

   SharedReg61_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg60_out,
                 Y => SharedReg61_out);

   SharedReg62_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg61_out,
                 Y => SharedReg62_out);

   SharedReg63_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg62_out,
                 Y => SharedReg63_out);

   SharedReg64_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product210_impl_out,
                 Y => SharedReg64_out);

   SharedReg65_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg64_out,
                 Y => SharedReg65_out);

   SharedReg66_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg65_out,
                 Y => SharedReg66_out);

   SharedReg67_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg66_out,
                 Y => SharedReg67_out);

   SharedReg68_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg67_out,
                 Y => SharedReg68_out);

   SharedReg69_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product310_impl_out,
                 Y => SharedReg69_out);

   SharedReg70_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg69_out,
                 Y => SharedReg70_out);

   SharedReg71_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg70_out,
                 Y => SharedReg71_out);

   SharedReg72_instance: Delay_34_DelayLength_6_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=6 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg71_out,
                 Y => SharedReg72_out);

   SharedReg73_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product410_impl_out,
                 Y => SharedReg73_out);

   SharedReg74_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg73_out,
                 Y => SharedReg74_out);

   SharedReg75_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg74_out,
                 Y => SharedReg75_out);

   SharedReg76_instance: Delay_34_DelayLength_10_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=10 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg75_out,
                 Y => SharedReg76_out);

   SharedReg77_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product510_impl_out,
                 Y => SharedReg77_out);

   SharedReg78_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg77_out,
                 Y => SharedReg78_out);

   SharedReg79_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg78_out,
                 Y => SharedReg79_out);

   SharedReg80_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg79_out,
                 Y => SharedReg80_out);

   SharedReg81_instance: Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg80_out,
                 Y => SharedReg81_out);

   SharedReg82_instance: Delay_34_DelayLength_4_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=4 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg81_out,
                 Y => SharedReg82_out);

   SharedReg83_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product610_impl_out,
                 Y => SharedReg83_out);

   SharedReg84_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg83_out,
                 Y => SharedReg84_out);

   SharedReg85_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg84_out,
                 Y => SharedReg85_out);

   SharedReg86_instance: Delay_34_DelayLength_8_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=8 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg85_out,
                 Y => SharedReg86_out);

   SharedReg87_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product710_impl_out,
                 Y => SharedReg87_out);

   SharedReg88_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg87_out,
                 Y => SharedReg88_out);

   SharedReg89_instance: Delay_34_DelayLength_4_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=4 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg88_out,
                 Y => SharedReg89_out);

   SharedReg90_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg89_out,
                 Y => SharedReg90_out);

   SharedReg91_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg90_out,
                 Y => SharedReg91_out);

   SharedReg92_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg91_out,
                 Y => SharedReg92_out);

   SharedReg93_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg92_out,
                 Y => SharedReg93_out);

   SharedReg94_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product810_impl_out,
                 Y => SharedReg94_out);

   SharedReg95_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg94_out,
                 Y => SharedReg95_out);

   SharedReg96_instance: Delay_34_DelayLength_7_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=7 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg95_out,
                 Y => SharedReg96_out);

   SharedReg97_instance: Delay_34_DelayLength_8_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=8 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg96_out,
                 Y => SharedReg97_out);

   SharedReg98_instance: Delay_34_DelayLength_11_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=11 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg97_out,
                 Y => SharedReg98_out);

   SharedReg99_instance: Delay_34_DelayLength_12_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=12 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg98_out,
                 Y => SharedReg99_out);

   SharedReg100_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product910_impl_out,
                 Y => SharedReg100_out);

   SharedReg101_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg100_out,
                 Y => SharedReg101_out);

   SharedReg102_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg101_out,
                 Y => SharedReg102_out);

   SharedReg103_instance: Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg102_out,
                 Y => SharedReg103_out);

   SharedReg104_instance: Delay_34_DelayLength_18_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=18 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg103_out,
                 Y => SharedReg104_out);

   SharedReg105_instance: Delay_34_DelayLength_18_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=18 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg104_out,
                 Y => SharedReg105_out);

   SharedReg106_instance: Delay_34_DelayLength_15_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=15 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg105_out,
                 Y => SharedReg106_out);

   SharedReg107_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Add30_impl_out,
                 Y => SharedReg107_out);

   SharedReg108_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg107_out,
                 Y => SharedReg108_out);

   SharedReg109_instance: Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg108_out,
                 Y => SharedReg109_out);

   SharedReg110_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg109_out,
                 Y => SharedReg110_out);

   SharedReg111_instance: Delay_34_DelayLength_74_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=74 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg110_out,
                 Y => SharedReg111_out);

   SharedReg112_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg111_out,
                 Y => SharedReg112_out);

   SharedReg113_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg112_out,
                 Y => SharedReg113_out);

   SharedReg114_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg113_out,
                 Y => SharedReg114_out);

   SharedReg115_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Add101_impl_out,
                 Y => SharedReg115_out);

   SharedReg116_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg115_out,
                 Y => SharedReg116_out);

   SharedReg117_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg116_out,
                 Y => SharedReg117_out);

   SharedReg118_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg117_out,
                 Y => SharedReg118_out);

   SharedReg119_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg118_out,
                 Y => SharedReg119_out);

   SharedReg120_instance: Delay_34_DelayLength_57_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=57 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg119_out,
                 Y => SharedReg120_out);

   SharedReg121_instance: Delay_34_DelayLength_14_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=14 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg120_out,
                 Y => SharedReg121_out);

   SharedReg122_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Add111_impl_out,
                 Y => SharedReg122_out);

   SharedReg123_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg122_out,
                 Y => SharedReg123_out);

   SharedReg124_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg123_out,
                 Y => SharedReg124_out);

   SharedReg125_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg124_out,
                 Y => SharedReg125_out);

   SharedReg126_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg125_out,
                 Y => SharedReg126_out);

   SharedReg127_instance: Delay_34_DelayLength_78_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=78 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg126_out,
                 Y => SharedReg127_out);

   SharedReg128_instance: Delay_34_DelayLength_4_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=4 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg127_out,
                 Y => SharedReg128_out);

   SharedReg129_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Add210_impl_out,
                 Y => SharedReg129_out);

   SharedReg130_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg129_out,
                 Y => SharedReg130_out);

   SharedReg131_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg130_out,
                 Y => SharedReg131_out);

   SharedReg132_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg131_out,
                 Y => SharedReg132_out);

   SharedReg133_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg132_out,
                 Y => SharedReg133_out);

   SharedReg134_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product312_impl_out,
                 Y => SharedReg134_out);

   SharedReg135_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg134_out,
                 Y => SharedReg135_out);

   SharedReg136_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg135_out,
                 Y => SharedReg136_out);

   SharedReg137_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg136_out,
                 Y => SharedReg137_out);

   SharedReg138_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg137_out,
                 Y => SharedReg138_out);

   SharedReg139_instance: Delay_34_DelayLength_12_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=12 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg138_out,
                 Y => SharedReg139_out);

   SharedReg140_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product73_impl_out,
                 Y => SharedReg140_out);

   SharedReg141_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg140_out,
                 Y => SharedReg141_out);

   SharedReg142_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg141_out,
                 Y => SharedReg142_out);

   SharedReg143_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg142_out,
                 Y => SharedReg143_out);

   SharedReg144_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg143_out,
                 Y => SharedReg144_out);

   SharedReg145_instance: Delay_34_DelayLength_24_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=24 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg144_out,
                 Y => SharedReg145_out);

   SharedReg146_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product84_impl_out,
                 Y => SharedReg146_out);

   SharedReg147_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg146_out,
                 Y => SharedReg147_out);

   SharedReg148_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg147_out,
                 Y => SharedReg148_out);

   SharedReg149_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg148_out,
                 Y => SharedReg149_out);

   SharedReg150_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg149_out,
                 Y => SharedReg150_out);

   SharedReg151_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product85_impl_out,
                 Y => SharedReg151_out);

   SharedReg152_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg151_out,
                 Y => SharedReg152_out);

   SharedReg153_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg152_out,
                 Y => SharedReg153_out);

   SharedReg154_instance: Delay_34_DelayLength_4_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=4 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg153_out,
                 Y => SharedReg154_out);

   SharedReg155_instance: Delay_34_DelayLength_2_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=2 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg154_out,
                 Y => SharedReg155_out);

   SharedReg156_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Product99_impl_out,
                 Y => SharedReg156_out);

   SharedReg157_instance: Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg156_out,
                 Y => SharedReg157_out);

   SharedReg158_instance: Delay_34_DelayLength_10_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=10 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg157_out,
                 Y => SharedReg158_out);

   SharedReg159_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Subtract12_impl_out,
                 Y => SharedReg159_out);

   SharedReg160_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg159_out,
                 Y => SharedReg160_out);

   SharedReg161_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg160_out,
                 Y => SharedReg161_out);

   SharedReg162_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg161_out,
                 Y => SharedReg162_out);

   SharedReg163_instance: Delay_34_DelayLength_5_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=5 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg162_out,
                 Y => SharedReg163_out);

   SharedReg164_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Subtract7_impl_out,
                 Y => SharedReg164_out);

   SharedReg165_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg164_out,
                 Y => SharedReg165_out);

   SharedReg166_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Add32_impl_out,
                 Y => SharedReg166_out);

   SharedReg167_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg166_out,
                 Y => SharedReg167_out);

   SharedReg168_instance: Delay_34_DelayLength_3_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=3 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg167_out,
                 Y => SharedReg168_out);

   SharedReg169_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Divide_impl_out,
                 Y => SharedReg169_out);

   SharedReg170_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Constant_impl_out,
                 Y => SharedReg170_out);

   SharedReg171_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg170_out,
                 Y => SharedReg171_out);

   SharedReg172_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg171_out,
                 Y => SharedReg172_out);

   SharedReg173_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg172_out,
                 Y => SharedReg173_out);

   SharedReg174_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg173_out,
                 Y => SharedReg174_out);

   SharedReg175_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg174_out,
                 Y => SharedReg175_out);

   SharedReg176_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg175_out,
                 Y => SharedReg176_out);

   SharedReg177_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg176_out,
                 Y => SharedReg177_out);

   SharedReg178_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg177_out,
                 Y => SharedReg178_out);

   SharedReg179_instance: Delay_34_DelayLength_4_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=4 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg178_out,
                 Y => SharedReg179_out);

   SharedReg180_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg179_out,
                 Y => SharedReg180_out);

   SharedReg181_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg180_out,
                 Y => SharedReg181_out);

   SharedReg182_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg181_out,
                 Y => SharedReg182_out);

   SharedReg183_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg182_out,
                 Y => SharedReg183_out);

   SharedReg184_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg183_out,
                 Y => SharedReg184_out);

   SharedReg185_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg184_out,
                 Y => SharedReg185_out);

   SharedReg186_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg185_out,
                 Y => SharedReg186_out);

   SharedReg187_instance: Delay_34_DelayLength_6_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=6 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg186_out,
                 Y => SharedReg187_out);

   SharedReg188_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg187_out,
                 Y => SharedReg188_out);

   SharedReg189_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg188_out,
                 Y => SharedReg189_out);

   SharedReg190_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg189_out,
                 Y => SharedReg190_out);

   SharedReg191_instance: Delay_34_DelayLength_1_initialCondition_0000000000000000000000000000000000_component  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => SharedReg190_out,
                 Y => SharedReg191_out);
end architecture;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity implementedSystem_toplevel_wrapper is
  port (
    clk, rst : in std_logic;
    shared_input : in std_logic_vector(31 downto 0);
    ldiff_uu_del_1_enable : in std_logic;
    ldiff_uv_del_1_enable : in std_logic;
    ldiff_uw_del_1_enable : in std_logic;
    ldiff_vu_del_1_enable : in std_logic;
    ldiff_vv_del_1_enable : in std_logic;
    ldiff_vw_del_1_enable : in std_logic;
    ldiff_wu_del_1_enable : in std_logic;
    ldiff_wv_del_1_enable : in std_logic;
    ldiff_ww_del_1_enable : in std_logic;
    r_u_enable : in std_logic;
    r_v_enable : in std_logic;
    r_w_enable : in std_logic;
    output_select : in std_logic_vector(3 downto 0);
    shared_output : out std_logic_vector(31 downto 0)
  );
end entity;

architecture implementedSystem_toplevel_wrapper of implementedSystem_toplevel_wrapper is
  signal ldiff_uu_del_1_DUT_in : std_logic_vector(31 downto 0);
  signal ldiff_uv_del_1_DUT_in : std_logic_vector(31 downto 0);
  signal ldiff_uw_del_1_DUT_in : std_logic_vector(31 downto 0);
  signal ldiff_vu_del_1_DUT_in : std_logic_vector(31 downto 0);
  signal ldiff_vv_del_1_DUT_in : std_logic_vector(31 downto 0);
  signal ldiff_vw_del_1_DUT_in : std_logic_vector(31 downto 0);
  signal ldiff_wu_del_1_DUT_in : std_logic_vector(31 downto 0);
  signal ldiff_wv_del_1_DUT_in : std_logic_vector(31 downto 0);
  signal ldiff_ww_del_1_DUT_in : std_logic_vector(31 downto 0);
  signal r_u_DUT_in : std_logic_vector(31 downto 0);
  signal r_v_DUT_in : std_logic_vector(31 downto 0);
  signal r_w_DUT_in : std_logic_vector(31 downto 0);
  signal inv_11_DUT_out : std_logic_vector(31 downto 0);
  signal inv_12_DUT_out : std_logic_vector(31 downto 0);
  signal inv_13_DUT_out : std_logic_vector(31 downto 0);
  signal inv_21_DUT_out : std_logic_vector(31 downto 0);
  signal inv_22_DUT_out : std_logic_vector(31 downto 0);
  signal inv_23_DUT_out : std_logic_vector(31 downto 0);
  signal inv_31_DUT_out : std_logic_vector(31 downto 0);
  signal inv_32_DUT_out : std_logic_vector(31 downto 0);
  signal inv_33_DUT_out : std_logic_vector(31 downto 0);
  signal inv_41_DUT_out : std_logic_vector(31 downto 0);
  signal inv_42_DUT_out : std_logic_vector(31 downto 0);
  signal inv_43_DUT_out : std_logic_vector(31 downto 0);
  type output_mux_input_t is array (0 to 11) of std_logic_vector(31 downto 0);
  signal output_mux_input : output_mux_input_t;

  begin
    DUT : entity work.implementedSystem_toplevel
      port map (
        clk => clk,
        rst => rst,
        ldiff_uu_del_1 => ldiff_uu_del_1_DUT_in,
        ldiff_uv_del_1 => ldiff_uv_del_1_DUT_in,
        ldiff_uw_del_1 => ldiff_uw_del_1_DUT_in,
        ldiff_vu_del_1 => ldiff_vu_del_1_DUT_in,
        ldiff_vv_del_1 => ldiff_vv_del_1_DUT_in,
        ldiff_vw_del_1 => ldiff_vw_del_1_DUT_in,
        ldiff_wu_del_1 => ldiff_wu_del_1_DUT_in,
        ldiff_wv_del_1 => ldiff_wv_del_1_DUT_in,
        ldiff_ww_del_1 => ldiff_ww_del_1_DUT_in,
        r_u => r_u_DUT_in,
        r_v => r_v_DUT_in,
        r_w => r_w_DUT_in,
        inv_11 => inv_11_DUT_out,
        inv_12 => inv_12_DUT_out,
        inv_13 => inv_13_DUT_out,
        inv_21 => inv_21_DUT_out,
        inv_22 => inv_22_DUT_out,
        inv_23 => inv_23_DUT_out,
        inv_31 => inv_31_DUT_out,
        inv_32 => inv_32_DUT_out,
        inv_33 => inv_33_DUT_out,
        inv_41 => inv_41_DUT_out,
        inv_42 => inv_42_DUT_out,
        inv_43 => inv_43_DUT_out
       );
    process(clk)
      begin
        if (rising_edge(clk)) then
          if (ldiff_uu_del_1_enable = '1') then
            ldiff_uu_del_1_DUT_in <= shared_input;
          end if; -- enable for input ldiff_uu_del_1
          if (ldiff_uv_del_1_enable = '1') then
            ldiff_uv_del_1_DUT_in <= shared_input;
          end if; -- enable for input ldiff_uv_del_1
          if (ldiff_uw_del_1_enable = '1') then
            ldiff_uw_del_1_DUT_in <= shared_input;
          end if; -- enable for input ldiff_uw_del_1
          if (ldiff_vu_del_1_enable = '1') then
            ldiff_vu_del_1_DUT_in <= shared_input;
          end if; -- enable for input ldiff_vu_del_1
          if (ldiff_vv_del_1_enable = '1') then
            ldiff_vv_del_1_DUT_in <= shared_input;
          end if; -- enable for input ldiff_vv_del_1
          if (ldiff_vw_del_1_enable = '1') then
            ldiff_vw_del_1_DUT_in <= shared_input;
          end if; -- enable for input ldiff_vw_del_1
          if (ldiff_wu_del_1_enable = '1') then
            ldiff_wu_del_1_DUT_in <= shared_input;
          end if; -- enable for input ldiff_wu_del_1
          if (ldiff_wv_del_1_enable = '1') then
            ldiff_wv_del_1_DUT_in <= shared_input;
          end if; -- enable for input ldiff_wv_del_1
          if (ldiff_ww_del_1_enable = '1') then
            ldiff_ww_del_1_DUT_in <= shared_input;
          end if; -- enable for input ldiff_ww_del_1
          if (r_u_enable = '1') then
            r_u_DUT_in <= shared_input;
          end if; -- enable for input r_u
          if (r_v_enable = '1') then
            r_v_DUT_in <= shared_input;
          end if; -- enable for input r_v
          if (r_w_enable = '1') then
            r_w_DUT_in <= shared_input;
          end if; -- enable for input r_w
        end if; -- clk
      end process;
    output_mux_input(0) <= inv_11_DUT_out;
    output_mux_input(1) <= inv_12_DUT_out;
    output_mux_input(2) <= inv_13_DUT_out;
    output_mux_input(3) <= inv_21_DUT_out;
    output_mux_input(4) <= inv_22_DUT_out;
    output_mux_input(5) <= inv_23_DUT_out;
    output_mux_input(6) <= inv_31_DUT_out;
    output_mux_input(7) <= inv_32_DUT_out;
    output_mux_input(8) <= inv_33_DUT_out;
    output_mux_input(9) <= inv_41_DUT_out;
    output_mux_input(10) <= inv_42_DUT_out;
    output_mux_input(11) <= inv_43_DUT_out;
    shared_output <= output_mux_input(to_integer(unsigned(output_select)));
    
end architecture;
