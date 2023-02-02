<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="kintex7" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="clk" />
        <signal name="Qa" />
        <signal name="Qb" />
        <signal name="Qc" />
        <signal name="Qd" />
        <signal name="XLXN_12" />
        <signal name="XLXN_14" />
        <signal name="XLXN_13" />
        <signal name="XLXN_35" />
        <signal name="XLXN_36" />
        <signal name="nQd" />
        <signal name="nQb" />
        <signal name="nQa" />
        <signal name="Rc" />
        <signal name="nQc" />
        <port polarity="Input" name="clk" />
        <port polarity="Output" name="Qa" />
        <port polarity="Output" name="Qb" />
        <port polarity="Output" name="Qc" />
        <port polarity="Output" name="Qd" />
        <port polarity="Output" name="Rc" />
        <blockdef name="fd">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <rect width="256" x="64" y="-320" height="256" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="64" y1="-256" y2="-256" x1="0" />
            <line x2="320" y1="-256" y2="-256" x1="384" />
            <line x2="64" y1="-128" y2="-144" x1="80" />
            <line x2="80" y1="-112" y2="-128" x1="64" />
        </blockdef>
        <blockdef name="xnor2">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-64" x1="0" />
            <line x2="60" y1="-128" y2="-128" x1="0" />
            <arc ex="44" ey="-144" sx="48" sy="-48" r="56" cx="16" cy="-96" />
            <arc ex="64" ey="-144" sx="64" sy="-48" r="56" cx="32" cy="-96" />
            <line x2="64" y1="-144" y2="-144" x1="128" />
            <line x2="64" y1="-48" y2="-48" x1="128" />
            <arc ex="128" ey="-144" sx="208" sy="-96" r="88" cx="132" cy="-56" />
            <arc ex="208" ey="-96" sx="128" sy="-48" r="88" cx="132" cy="-136" />
            <circle r="8" cx="220" cy="-96" />
            <line x2="256" y1="-96" y2="-96" x1="228" />
            <line x2="60" y1="-28" y2="-28" x1="60" />
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
        <blockdef name="nor4">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="48" y1="-64" y2="-64" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="64" y1="-192" y2="-192" x1="0" />
            <line x2="48" y1="-256" y2="-256" x1="0" />
            <line x2="216" y1="-160" y2="-160" x1="256" />
            <circle r="12" cx="204" cy="-160" />
            <line x2="48" y1="-208" y2="-208" x1="112" />
            <arc ex="112" ey="-208" sx="192" sy="-160" r="88" cx="116" cy="-120" />
            <line x2="48" y1="-112" y2="-112" x1="112" />
            <line x2="48" y1="-256" y2="-208" x1="48" />
            <line x2="48" y1="-64" y2="-112" x1="48" />
            <arc ex="48" ey="-208" sx="48" sy="-112" r="56" cx="16" cy="-160" />
            <arc ex="192" ey="-160" sx="112" sy="-112" r="88" cx="116" cy="-200" />
        </blockdef>
        <blockdef name="nor2">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-64" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="216" y1="-96" y2="-96" x1="256" />
            <circle r="12" cx="204" cy="-96" />
            <arc ex="192" ey="-96" sx="112" sy="-48" r="88" cx="116" cy="-136" />
            <arc ex="112" ey="-144" sx="192" sy="-96" r="88" cx="116" cy="-56" />
            <arc ex="48" ey="-144" sx="48" sy="-48" r="56" cx="16" cy="-96" />
            <line x2="48" y1="-48" y2="-48" x1="112" />
            <line x2="48" y1="-144" y2="-144" x1="112" />
        </blockdef>
        <block symbolname="fd" name="XLXI_1">
            <blockpin signalname="clk" name="C" />
            <blockpin signalname="nQa" name="D" />
            <blockpin signalname="Qa" name="Q" />
        </block>
        <block symbolname="fd" name="XLXI_4">
            <blockpin signalname="clk" name="C" />
            <blockpin signalname="XLXN_12" name="D" />
            <blockpin signalname="Qd" name="Q" />
        </block>
        <block symbolname="xnor2" name="XLXI_13">
            <blockpin signalname="nQb" name="I0" />
            <blockpin signalname="Qa" name="I1" />
            <blockpin signalname="XLXN_14" name="O" />
        </block>
        <block symbolname="xnor2" name="XLXI_14">
            <blockpin signalname="nQc" name="I0" />
            <blockpin signalname="XLXN_35" name="I1" />
            <blockpin signalname="XLXN_13" name="O" />
        </block>
        <block symbolname="xnor2" name="XLXI_15">
            <blockpin signalname="nQd" name="I0" />
            <blockpin signalname="XLXN_36" name="I1" />
            <blockpin signalname="XLXN_12" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_16">
            <blockpin signalname="Qb" name="I" />
            <blockpin signalname="nQb" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_19">
            <blockpin signalname="Qd" name="I" />
            <blockpin signalname="nQd" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_26">
            <blockpin signalname="Qa" name="I" />
            <blockpin signalname="nQa" name="O" />
        </block>
        <block symbolname="fd" name="XLXI_2">
            <blockpin signalname="clk" name="C" />
            <blockpin signalname="XLXN_14" name="D" />
            <blockpin signalname="Qb" name="Q" />
        </block>
        <block symbolname="fd" name="XLXI_3">
            <blockpin signalname="clk" name="C" />
            <blockpin signalname="XLXN_13" name="D" />
            <blockpin signalname="Qc" name="Q" />
        </block>
        <block symbolname="nor2" name="XLXI_29">
            <blockpin signalname="nQb" name="I0" />
            <blockpin signalname="nQa" name="I1" />
            <blockpin signalname="XLXN_35" name="O" />
        </block>
        <block symbolname="nor3" name="XLXI_27">
            <blockpin signalname="nQc" name="I0" />
            <blockpin signalname="nQb" name="I1" />
            <blockpin signalname="nQa" name="I2" />
            <blockpin signalname="XLXN_36" name="O" />
        </block>
        <block symbolname="nor4" name="XLXI_28">
            <blockpin signalname="nQd" name="I0" />
            <blockpin signalname="nQc" name="I1" />
            <blockpin signalname="nQb" name="I2" />
            <blockpin signalname="nQa" name="I3" />
            <blockpin signalname="Rc" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_30">
            <blockpin signalname="Qc" name="I" />
            <blockpin signalname="nQc" name="O" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1440" y="432" name="XLXI_1" orien="R0" />
        <instance x="1440" y="1632" name="XLXI_4" orien="R0" />
        <branch name="clk">
            <wire x2="1392" y1="1504" y2="1504" x1="240" />
            <wire x2="1440" y1="1504" y2="1504" x1="1392" />
            <wire x2="1440" y1="304" y2="304" x1="1392" />
            <wire x2="1392" y1="304" y2="704" x1="1392" />
            <wire x2="1392" y1="704" y2="1104" x1="1392" />
            <wire x2="1392" y1="1104" y2="1504" x1="1392" />
            <wire x2="1440" y1="1104" y2="1104" x1="1392" />
            <wire x2="1440" y1="704" y2="704" x1="1392" />
        </branch>
        <branch name="Qa">
            <wire x2="336" y1="32" y2="176" x1="336" />
            <wire x2="416" y1="176" y2="176" x1="336" />
            <wire x2="1040" y1="32" y2="32" x1="336" />
            <wire x2="1840" y1="32" y2="32" x1="1040" />
            <wire x2="1840" y1="32" y2="176" x1="1840" />
            <wire x2="2144" y1="176" y2="176" x1="1840" />
            <wire x2="1040" y1="32" y2="544" x1="1040" />
            <wire x2="1104" y1="544" y2="544" x1="1040" />
            <wire x2="1840" y1="176" y2="176" x1="1824" />
        </branch>
        <branch name="Qb">
            <wire x2="1840" y1="432" y2="432" x1="336" />
            <wire x2="1840" y1="432" y2="576" x1="1840" />
            <wire x2="2144" y1="576" y2="576" x1="1840" />
            <wire x2="336" y1="432" y2="608" x1="336" />
            <wire x2="416" y1="608" y2="608" x1="336" />
            <wire x2="1840" y1="576" y2="576" x1="1824" />
        </branch>
        <branch name="Qd">
            <wire x2="336" y1="1232" y2="1408" x1="336" />
            <wire x2="416" y1="1408" y2="1408" x1="336" />
            <wire x2="1840" y1="1232" y2="1232" x1="336" />
            <wire x2="1840" y1="1232" y2="1376" x1="1840" />
            <wire x2="2144" y1="1376" y2="1376" x1="1840" />
            <wire x2="1840" y1="1376" y2="1376" x1="1824" />
        </branch>
        <instance x="1104" y="672" name="XLXI_13" orien="R0" />
        <instance x="1104" y="1072" name="XLXI_14" orien="R0" />
        <instance x="1104" y="1472" name="XLXI_15" orien="R0" />
        <instance x="416" y="640" name="XLXI_16" orien="R0" />
        <instance x="416" y="1440" name="XLXI_19" orien="R0" />
        <instance x="416" y="208" name="XLXI_26" orien="R0" />
        <branch name="XLXN_12">
            <wire x2="1440" y1="1376" y2="1376" x1="1360" />
        </branch>
        <branch name="XLXN_14">
            <wire x2="1440" y1="576" y2="576" x1="1360" />
        </branch>
        <instance x="1440" y="832" name="XLXI_2" orien="R0" />
        <branch name="XLXN_13">
            <wire x2="1440" y1="976" y2="976" x1="1360" />
        </branch>
        <instance x="1440" y="1232" name="XLXI_3" orien="R0" />
        <instance x="784" y="816" name="XLXI_29" orien="R0" />
        <instance x="784" y="1248" name="XLXI_27" orien="R0" />
        <instance x="784" y="1808" name="XLXI_28" orien="R0" />
        <branch name="XLXN_35">
            <wire x2="1072" y1="720" y2="720" x1="1040" />
            <wire x2="1072" y1="720" y2="944" x1="1072" />
            <wire x2="1104" y1="944" y2="944" x1="1072" />
        </branch>
        <branch name="XLXN_36">
            <wire x2="1072" y1="1120" y2="1120" x1="1040" />
            <wire x2="1072" y1="1120" y2="1344" x1="1072" />
            <wire x2="1104" y1="1344" y2="1344" x1="1072" />
        </branch>
        <branch name="nQd">
            <wire x2="656" y1="1408" y2="1408" x1="640" />
            <wire x2="1104" y1="1408" y2="1408" x1="656" />
            <wire x2="656" y1="1408" y2="1744" x1="656" />
            <wire x2="784" y1="1744" y2="1744" x1="656" />
        </branch>
        <branch name="Qc">
            <wire x2="336" y1="832" y2="1008" x1="336" />
            <wire x2="416" y1="1008" y2="1008" x1="336" />
            <wire x2="1840" y1="832" y2="832" x1="336" />
            <wire x2="1840" y1="832" y2="976" x1="1840" />
            <wire x2="2144" y1="976" y2="976" x1="1840" />
            <wire x2="1840" y1="976" y2="976" x1="1824" />
        </branch>
        <branch name="nQb">
            <wire x2="720" y1="608" y2="608" x1="640" />
            <wire x2="1104" y1="608" y2="608" x1="720" />
            <wire x2="720" y1="608" y2="752" x1="720" />
            <wire x2="784" y1="752" y2="752" x1="720" />
            <wire x2="720" y1="752" y2="1120" x1="720" />
            <wire x2="720" y1="1120" y2="1616" x1="720" />
            <wire x2="784" y1="1616" y2="1616" x1="720" />
            <wire x2="784" y1="1120" y2="1120" x1="720" />
        </branch>
        <branch name="nQa">
            <wire x2="752" y1="176" y2="176" x1="640" />
            <wire x2="752" y1="176" y2="688" x1="752" />
            <wire x2="784" y1="688" y2="688" x1="752" />
            <wire x2="752" y1="688" y2="1056" x1="752" />
            <wire x2="752" y1="1056" y2="1552" x1="752" />
            <wire x2="784" y1="1552" y2="1552" x1="752" />
            <wire x2="784" y1="1056" y2="1056" x1="752" />
            <wire x2="1440" y1="176" y2="176" x1="752" />
        </branch>
        <branch name="Rc">
            <wire x2="1056" y1="1648" y2="1648" x1="1040" />
            <wire x2="2144" y1="1648" y2="1648" x1="1056" />
        </branch>
        <iomarker fontsize="28" x="240" y="1504" name="clk" orien="R180" />
        <instance x="416" y="1040" name="XLXI_30" orien="R0" />
        <branch name="nQc">
            <wire x2="688" y1="1008" y2="1008" x1="640" />
            <wire x2="1104" y1="1008" y2="1008" x1="688" />
            <wire x2="688" y1="1008" y2="1184" x1="688" />
            <wire x2="688" y1="1184" y2="1680" x1="688" />
            <wire x2="784" y1="1680" y2="1680" x1="688" />
            <wire x2="784" y1="1184" y2="1184" x1="688" />
        </branch>
        <iomarker fontsize="28" x="2144" y="1376" name="Qd" orien="R0" />
        <iomarker fontsize="28" x="2144" y="1648" name="Rc" orien="R0" />
        <iomarker fontsize="28" x="2144" y="976" name="Qc" orien="R0" />
        <iomarker fontsize="28" x="2144" y="576" name="Qb" orien="R0" />
        <iomarker fontsize="28" x="2144" y="176" name="Qa" orien="R0" />
    </sheet>
</drawing>