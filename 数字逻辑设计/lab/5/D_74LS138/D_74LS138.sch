<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="kintex7" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_4" />
        <signal name="XLXN_5" />
        <signal name="XLXN_6" />
        <signal name="XLXN_12" />
        <signal name="XLXN_14" />
        <signal name="XLXN_17" />
        <signal name="XLXN_18" />
        <signal name="XLXN_22" />
        <signal name="A" />
        <signal name="B" />
        <signal name="C" />
        <signal name="G" />
        <signal name="G2A" />
        <signal name="G2B" />
        <signal name="XLXN_50" />
        <signal name="Y(7:0)" />
        <signal name="Y(7)" />
        <signal name="Y(6)" />
        <signal name="Y(5)" />
        <signal name="Y(4)" />
        <signal name="Y(3)" />
        <signal name="Y(2)" />
        <signal name="Y(1)" />
        <signal name="Y(0)" />
        <port polarity="Input" name="A" />
        <port polarity="Input" name="B" />
        <port polarity="Input" name="C" />
        <port polarity="Input" name="G" />
        <port polarity="Input" name="G2A" />
        <port polarity="Input" name="G2B" />
        <port polarity="Output" name="Y(7:0)" />
        <blockdef name="and2">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-64" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="192" y1="-96" y2="-96" x1="256" />
            <arc ex="144" ey="-144" sx="144" sy="-48" r="48" cx="144" cy="-96" />
            <line x2="64" y1="-48" y2="-48" x1="144" />
            <line x2="144" y1="-144" y2="-144" x1="64" />
            <line x2="64" y1="-48" y2="-144" x1="64" />
        </blockdef>
        <blockdef name="inv">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <line x2="160" y1="-32" y2="-32" x1="224" />
            <line x2="128" y1="-64" y2="-32" x1="64" />
            <line x2="64" y1="-32" y2="0" x1="128" />
            <line x2="64" y1="0" y2="-64" x1="64" />
            <circle r="16" cx="144" cy="-32" />
        </blockdef>
        <blockdef name="nand3">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-64" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="64" y1="-192" y2="-192" x1="0" />
            <line x2="216" y1="-128" y2="-128" x1="256" />
            <circle r="12" cx="204" cy="-128" />
            <line x2="144" y1="-176" y2="-176" x1="64" />
            <line x2="64" y1="-80" y2="-80" x1="144" />
            <arc ex="144" ey="-176" sx="144" sy="-80" r="48" cx="144" cy="-128" />
            <line x2="64" y1="-64" y2="-192" x1="64" />
        </blockdef>
        <blockdef name="nor3">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="48" y1="-64" y2="-64" x1="0" />
            <line x2="72" y1="-128" y2="-128" x1="0" />
            <line x2="48" y1="-192" y2="-192" x1="0" />
            <line x2="216" y1="-128" y2="-128" x1="256" />
            <circle r="12" cx="204" cy="-128" />
            <line x2="48" y1="-64" y2="-80" x1="48" />
            <line x2="48" y1="-192" y2="-176" x1="48" />
            <line x2="48" y1="-80" y2="-80" x1="112" />
            <line x2="48" y1="-176" y2="-176" x1="112" />
            <arc ex="48" ey="-176" sx="48" sy="-80" r="56" cx="16" cy="-128" />
            <arc ex="192" ey="-128" sx="112" sy="-80" r="88" cx="116" cy="-168" />
            <arc ex="112" ey="-176" sx="192" sy="-128" r="88" cx="116" cy="-88" />
        </blockdef>
        <block symbolname="and2" name="XLXI_1">
            <blockpin signalname="XLXN_5" name="I0" />
            <blockpin signalname="XLXN_4" name="I1" />
            <blockpin signalname="XLXN_6" name="O" />
        </block>
        <block symbolname="and2" name="XLXI_2">
            <blockpin signalname="XLXN_5" name="I0" />
            <blockpin signalname="A" name="I1" />
            <blockpin signalname="XLXN_12" name="O" />
        </block>
        <block symbolname="and2" name="XLXI_3">
            <blockpin signalname="B" name="I0" />
            <blockpin signalname="XLXN_4" name="I1" />
            <blockpin signalname="XLXN_14" name="O" />
        </block>
        <block symbolname="and2" name="XLXI_4">
            <blockpin signalname="B" name="I0" />
            <blockpin signalname="A" name="I1" />
            <blockpin signalname="XLXN_17" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_5">
            <blockpin signalname="A" name="I" />
            <blockpin signalname="XLXN_4" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_6">
            <blockpin signalname="B" name="I" />
            <blockpin signalname="XLXN_5" name="O" />
        </block>
        <block symbolname="nand3" name="XLXI_7">
            <blockpin signalname="XLXN_22" name="I0" />
            <blockpin signalname="XLXN_50" name="I1" />
            <blockpin signalname="XLXN_6" name="I2" />
            <blockpin signalname="Y(7)" name="O" />
        </block>
        <block symbolname="nand3" name="XLXI_8">
            <blockpin signalname="XLXN_22" name="I0" />
            <blockpin signalname="XLXN_50" name="I1" />
            <blockpin signalname="XLXN_12" name="I2" />
            <blockpin signalname="Y(6)" name="O" />
        </block>
        <block symbolname="nand3" name="XLXI_9">
            <blockpin signalname="XLXN_22" name="I0" />
            <blockpin signalname="XLXN_50" name="I1" />
            <blockpin signalname="XLXN_14" name="I2" />
            <blockpin signalname="Y(5)" name="O" />
        </block>
        <block symbolname="nand3" name="XLXI_10">
            <blockpin signalname="XLXN_22" name="I0" />
            <blockpin signalname="XLXN_50" name="I1" />
            <blockpin signalname="XLXN_17" name="I2" />
            <blockpin signalname="Y(4)" name="O" />
        </block>
        <block symbolname="nand3" name="XLXI_11">
            <blockpin signalname="C" name="I0" />
            <blockpin signalname="XLXN_50" name="I1" />
            <blockpin signalname="XLXN_6" name="I2" />
            <blockpin signalname="Y(3)" name="O" />
        </block>
        <block symbolname="nand3" name="XLXI_12">
            <blockpin signalname="C" name="I0" />
            <blockpin signalname="XLXN_50" name="I1" />
            <blockpin signalname="XLXN_12" name="I2" />
            <blockpin signalname="Y(2)" name="O" />
        </block>
        <block symbolname="nand3" name="XLXI_13">
            <blockpin signalname="C" name="I0" />
            <blockpin signalname="XLXN_50" name="I1" />
            <blockpin signalname="XLXN_14" name="I2" />
            <blockpin signalname="Y(1)" name="O" />
        </block>
        <block symbolname="nand3" name="XLXI_14">
            <blockpin signalname="C" name="I0" />
            <blockpin signalname="XLXN_50" name="I1" />
            <blockpin signalname="XLXN_17" name="I2" />
            <blockpin signalname="Y(0)" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_15">
            <blockpin signalname="G" name="I" />
            <blockpin signalname="XLXN_18" name="O" />
        </block>
        <block symbolname="nor3" name="XLXI_16">
            <blockpin signalname="G2B" name="I0" />
            <blockpin signalname="G2A" name="I1" />
            <blockpin signalname="XLXN_18" name="I2" />
            <blockpin signalname="XLXN_50" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_17">
            <blockpin signalname="C" name="I" />
            <blockpin signalname="XLXN_22" name="O" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1024" y="320" name="XLXI_1" orien="R0" />
        <instance x="1040" y="560" name="XLXI_2" orien="R0" />
        <instance x="1040" y="768" name="XLXI_3" orien="R0" />
        <instance x="1040" y="976" name="XLXI_4" orien="R0" />
        <instance x="576" y="272" name="XLXI_5" orien="R0" />
        <instance x="592" y="608" name="XLXI_6" orien="R0" />
        <branch name="XLXN_4">
            <wire x2="912" y1="240" y2="240" x1="800" />
            <wire x2="912" y1="240" y2="640" x1="912" />
            <wire x2="1040" y1="640" y2="640" x1="912" />
            <wire x2="1024" y1="192" y2="192" x1="912" />
            <wire x2="912" y1="192" y2="240" x1="912" />
        </branch>
        <branch name="XLXN_5">
            <wire x2="896" y1="576" y2="576" x1="816" />
            <wire x2="1024" y1="256" y2="256" x1="896" />
            <wire x2="896" y1="256" y2="496" x1="896" />
            <wire x2="896" y1="496" y2="576" x1="896" />
            <wire x2="1040" y1="496" y2="496" x1="896" />
        </branch>
        <instance x="1648" y="336" name="XLXI_7" orien="R0" />
        <instance x="1648" y="592" name="XLXI_8" orien="R0" />
        <instance x="1648" y="816" name="XLXI_9" orien="R0" />
        <instance x="1648" y="1072" name="XLXI_10" orien="R0" />
        <instance x="1664" y="1344" name="XLXI_11" orien="R0" />
        <instance x="1664" y="1600" name="XLXI_12" orien="R0" />
        <instance x="1664" y="1904" name="XLXI_13" orien="R0" />
        <instance x="1664" y="2192" name="XLXI_14" orien="R0" />
        <branch name="XLXN_6">
            <wire x2="1456" y1="224" y2="224" x1="1280" />
            <wire x2="1456" y1="224" y2="1152" x1="1456" />
            <wire x2="1664" y1="1152" y2="1152" x1="1456" />
            <wire x2="1456" y1="144" y2="224" x1="1456" />
            <wire x2="1648" y1="144" y2="144" x1="1456" />
        </branch>
        <branch name="XLXN_12">
            <wire x2="1472" y1="464" y2="464" x1="1296" />
            <wire x2="1472" y1="464" y2="1408" x1="1472" />
            <wire x2="1664" y1="1408" y2="1408" x1="1472" />
            <wire x2="1472" y1="400" y2="464" x1="1472" />
            <wire x2="1648" y1="400" y2="400" x1="1472" />
        </branch>
        <branch name="XLXN_14">
            <wire x2="1440" y1="672" y2="672" x1="1296" />
            <wire x2="1440" y1="672" y2="1712" x1="1440" />
            <wire x2="1664" y1="1712" y2="1712" x1="1440" />
            <wire x2="1440" y1="624" y2="672" x1="1440" />
            <wire x2="1648" y1="624" y2="624" x1="1440" />
        </branch>
        <branch name="XLXN_17">
            <wire x2="1376" y1="880" y2="880" x1="1296" />
            <wire x2="1648" y1="880" y2="880" x1="1376" />
            <wire x2="1376" y1="880" y2="2000" x1="1376" />
            <wire x2="1664" y1="2000" y2="2000" x1="1376" />
        </branch>
        <instance x="576" y="2048" name="XLXI_15" orien="R0" />
        <branch name="XLXN_18">
            <wire x2="832" y1="2016" y2="2016" x1="800" />
        </branch>
        <instance x="832" y="2208" name="XLXI_16" orien="R0" />
        <instance x="848" y="1200" name="XLXI_17" orien="R0" />
        <branch name="XLXN_22">
            <wire x2="1088" y1="1168" y2="1168" x1="1072" />
            <wire x2="1104" y1="1168" y2="1168" x1="1088" />
            <wire x2="1648" y1="1168" y2="1168" x1="1104" />
            <wire x2="1104" y1="1168" y2="1232" x1="1104" />
            <wire x2="1312" y1="1232" y2="1232" x1="1104" />
            <wire x2="1088" y1="1168" y2="1216" x1="1088" />
            <wire x2="1344" y1="1216" y2="1216" x1="1088" />
            <wire x2="1104" y1="1152" y2="1168" x1="1104" />
            <wire x2="1360" y1="1152" y2="1152" x1="1104" />
            <wire x2="1312" y1="528" y2="1232" x1="1312" />
            <wire x2="1648" y1="528" y2="528" x1="1312" />
            <wire x2="1344" y1="272" y2="1216" x1="1344" />
            <wire x2="1648" y1="272" y2="272" x1="1344" />
            <wire x2="1360" y1="752" y2="1152" x1="1360" />
            <wire x2="1648" y1="752" y2="752" x1="1360" />
            <wire x2="1648" y1="1008" y2="1168" x1="1648" />
        </branch>
        <branch name="A">
            <wire x2="560" y1="336" y2="336" x1="448" />
            <wire x2="560" y1="336" y2="432" x1="560" />
            <wire x2="768" y1="432" y2="432" x1="560" />
            <wire x2="1040" y1="432" y2="432" x1="768" />
            <wire x2="576" y1="240" y2="240" x1="560" />
            <wire x2="560" y1="240" y2="336" x1="560" />
            <wire x2="768" y1="416" y2="432" x1="768" />
            <wire x2="880" y1="416" y2="416" x1="768" />
            <wire x2="880" y1="416" y2="848" x1="880" />
            <wire x2="1040" y1="848" y2="848" x1="880" />
        </branch>
        <branch name="B">
            <wire x2="576" y1="672" y2="672" x1="464" />
            <wire x2="576" y1="672" y2="704" x1="576" />
            <wire x2="1040" y1="704" y2="704" x1="576" />
            <wire x2="800" y1="672" y2="672" x1="576" />
            <wire x2="800" y1="672" y2="912" x1="800" />
            <wire x2="1040" y1="912" y2="912" x1="800" />
            <wire x2="592" y1="576" y2="576" x1="576" />
            <wire x2="576" y1="576" y2="672" x1="576" />
        </branch>
        <iomarker fontsize="28" x="448" y="336" name="A" orien="R180" />
        <iomarker fontsize="28" x="464" y="672" name="B" orien="R180" />
        <branch name="C">
            <wire x2="848" y1="1280" y2="1280" x1="480" />
            <wire x2="976" y1="1280" y2="1280" x1="848" />
            <wire x2="1648" y1="1280" y2="1280" x1="976" />
            <wire x2="1664" y1="1280" y2="1280" x1="1648" />
            <wire x2="976" y1="1280" y2="1520" x1="976" />
            <wire x2="976" y1="1520" y2="1536" x1="976" />
            <wire x2="1072" y1="1536" y2="1536" x1="976" />
            <wire x2="1664" y1="1536" y2="1536" x1="1072" />
            <wire x2="1072" y1="1536" y2="1840" x1="1072" />
            <wire x2="1440" y1="1840" y2="1840" x1="1072" />
            <wire x2="1664" y1="1840" y2="1840" x1="1440" />
            <wire x2="1440" y1="1840" y2="2128" x1="1440" />
            <wire x2="1664" y1="2128" y2="2128" x1="1440" />
            <wire x2="848" y1="1168" y2="1168" x1="768" />
            <wire x2="768" y1="1168" y2="1264" x1="768" />
            <wire x2="848" y1="1264" y2="1264" x1="768" />
            <wire x2="848" y1="1264" y2="1280" x1="848" />
        </branch>
        <iomarker fontsize="28" x="480" y="1280" name="C" orien="R180" />
        <branch name="G">
            <wire x2="576" y1="2016" y2="2016" x1="544" />
        </branch>
        <iomarker fontsize="28" x="544" y="2016" name="G" orien="R180" />
        <branch name="G2A">
            <wire x2="832" y1="2080" y2="2080" x1="800" />
        </branch>
        <iomarker fontsize="28" x="800" y="2080" name="G2A" orien="R180" />
        <branch name="G2B">
            <wire x2="832" y1="2144" y2="2144" x1="800" />
        </branch>
        <iomarker fontsize="28" x="800" y="2144" name="G2B" orien="R180" />
        <branch name="XLXN_50">
            <wire x2="1376" y1="2080" y2="2080" x1="1088" />
            <wire x2="1376" y1="2064" y2="2080" x1="1376" />
            <wire x2="1648" y1="2064" y2="2064" x1="1376" />
            <wire x2="1664" y1="2064" y2="2064" x1="1648" />
            <wire x2="1648" y1="208" y2="208" x1="1632" />
            <wire x2="1632" y1="208" y2="464" x1="1632" />
            <wire x2="1648" y1="464" y2="464" x1="1632" />
            <wire x2="1632" y1="464" y2="688" x1="1632" />
            <wire x2="1648" y1="688" y2="688" x1="1632" />
            <wire x2="1632" y1="688" y2="944" x1="1632" />
            <wire x2="1648" y1="944" y2="944" x1="1632" />
            <wire x2="1632" y1="944" y2="1216" x1="1632" />
            <wire x2="1632" y1="1216" y2="1472" x1="1632" />
            <wire x2="1648" y1="1472" y2="1472" x1="1632" />
            <wire x2="1664" y1="1472" y2="1472" x1="1648" />
            <wire x2="1648" y1="1472" y2="1776" x1="1648" />
            <wire x2="1664" y1="1776" y2="1776" x1="1648" />
            <wire x2="1648" y1="1776" y2="2064" x1="1648" />
            <wire x2="1664" y1="1216" y2="1216" x1="1632" />
        </branch>
        <branch name="Y(7:0)">
            <wire x2="2656" y1="736" y2="736" x1="2640" />
            <wire x2="2656" y1="736" y2="848" x1="2656" />
            <wire x2="2656" y1="848" y2="976" x1="2656" />
            <wire x2="2656" y1="976" y2="1120" x1="2656" />
            <wire x2="2656" y1="1120" y2="1280" x1="2656" />
            <wire x2="2656" y1="1280" y2="1408" x1="2656" />
            <wire x2="2800" y1="1408" y2="1408" x1="2656" />
            <wire x2="2656" y1="1408" y2="1536" x1="2656" />
            <wire x2="2656" y1="1536" y2="1680" x1="2656" />
            <wire x2="2656" y1="1680" y2="1824" x1="2656" />
            <wire x2="2656" y1="1824" y2="1952" x1="2656" />
            <wire x2="2656" y1="1952" y2="2064" x1="2656" />
        </branch>
        <iomarker fontsize="28" x="2800" y="1408" name="Y(7:0)" orien="R0" />
        <bustap x2="2560" y1="848" y2="848" x1="2656" />
        <branch name="Y(7)">
            <attrtext style="alignment:SOFT-LEFT;fontsize:28;fontname:Arial" attrname="Name" x="2504" y="848" type="branch" />
            <wire x2="2448" y1="208" y2="208" x1="1904" />
            <wire x2="2448" y1="208" y2="848" x1="2448" />
            <wire x2="2512" y1="848" y2="848" x1="2448" />
            <wire x2="2560" y1="848" y2="848" x1="2512" />
        </branch>
        <bustap x2="2560" y1="976" y2="976" x1="2656" />
        <branch name="Y(6)">
            <attrtext style="alignment:SOFT-LEFT;fontsize:28;fontname:Arial" attrname="Name" x="2488" y="976" type="branch" />
            <wire x2="2416" y1="464" y2="464" x1="1904" />
            <wire x2="2416" y1="464" y2="976" x1="2416" />
            <wire x2="2496" y1="976" y2="976" x1="2416" />
            <wire x2="2560" y1="976" y2="976" x1="2496" />
        </branch>
        <bustap x2="2560" y1="1120" y2="1120" x1="2656" />
        <branch name="Y(5)">
            <attrtext style="alignment:SOFT-LEFT;fontsize:28;fontname:Arial" attrname="Name" x="2488" y="1120" type="branch" />
            <wire x2="2160" y1="688" y2="688" x1="1904" />
            <wire x2="2160" y1="688" y2="1120" x1="2160" />
            <wire x2="2416" y1="1120" y2="1120" x1="2160" />
            <wire x2="2496" y1="1120" y2="1120" x1="2416" />
            <wire x2="2560" y1="1120" y2="1120" x1="2496" />
        </branch>
        <bustap x2="2560" y1="1280" y2="1280" x1="2656" />
        <branch name="Y(4)">
            <attrtext style="alignment:SOFT-LEFT;fontsize:28;fontname:Arial" attrname="Name" x="2504" y="1280" type="branch" />
            <wire x2="2448" y1="944" y2="944" x1="1904" />
            <wire x2="2448" y1="944" y2="1280" x1="2448" />
            <wire x2="2512" y1="1280" y2="1280" x1="2448" />
            <wire x2="2560" y1="1280" y2="1280" x1="2512" />
        </branch>
        <bustap x2="2560" y1="1536" y2="1536" x1="2656" />
        <branch name="Y(3)">
            <attrtext style="alignment:SOFT-LEFT;fontsize:28;fontname:Arial" attrname="Name" x="2520" y="1536" type="branch" />
            <wire x2="2480" y1="1216" y2="1216" x1="1920" />
            <wire x2="2480" y1="1216" y2="1536" x1="2480" />
            <wire x2="2528" y1="1536" y2="1536" x1="2480" />
            <wire x2="2560" y1="1536" y2="1536" x1="2528" />
        </branch>
        <bustap x2="2560" y1="1680" y2="1680" x1="2656" />
        <branch name="Y(2)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:28;fontname:Arial" attrname="Name" x="2528" y="1680" type="branch" />
            <wire x2="2512" y1="1472" y2="1472" x1="1920" />
            <wire x2="2512" y1="1472" y2="1680" x1="2512" />
            <wire x2="2528" y1="1680" y2="1680" x1="2512" />
            <wire x2="2560" y1="1680" y2="1680" x1="2528" />
        </branch>
        <bustap x2="2560" y1="1824" y2="1824" x1="2656" />
        <branch name="Y(1)">
            <attrtext style="alignment:SOFT-LEFT;fontsize:28;fontname:Arial" attrname="Name" x="2520" y="1824" type="branch" />
            <wire x2="2480" y1="1776" y2="1776" x1="1920" />
            <wire x2="2480" y1="1776" y2="1824" x1="2480" />
            <wire x2="2528" y1="1824" y2="1824" x1="2480" />
            <wire x2="2560" y1="1824" y2="1824" x1="2528" />
        </branch>
        <bustap x2="2560" y1="1952" y2="1952" x1="2656" />
        <branch name="Y(0)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:28;fontname:Arial" attrname="Name" x="2528" y="1952" type="branch" />
            <wire x2="2496" y1="2064" y2="2064" x1="1920" />
            <wire x2="2528" y1="1952" y2="1952" x1="2496" />
            <wire x2="2560" y1="1952" y2="1952" x1="2528" />
            <wire x2="2496" y1="1952" y2="2064" x1="2496" />
        </branch>
    </sheet>
</drawing>