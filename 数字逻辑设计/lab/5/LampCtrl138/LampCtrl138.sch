<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="kintex7" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="S1" />
        <signal name="S2" />
        <signal name="S3" />
        <signal name="F" />
        <signal name="Y(7:0)" />
        <signal name="Y(7)" />
        <signal name="Y(4)" />
        <signal name="Y(1)" />
        <signal name="Y(2)" />
        <signal name="XLXN_60" />
        <signal name="XLXN_62" />
        <signal name="XLXN_65" />
        <port polarity="Input" name="S1" />
        <port polarity="Input" name="S2" />
        <port polarity="Input" name="S3" />
        <port polarity="Output" name="F" />
        <blockdef name="D_74LS138">
            <timestamp>2022-11-1T6:28:42</timestamp>
            <rect width="256" x="64" y="-384" height="384" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-364" height="24" />
            <line x2="384" y1="-352" y2="-352" x1="320" />
        </blockdef>
        <blockdef name="nand4">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-64" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="64" y1="-192" y2="-192" x1="0" />
            <line x2="64" y1="-256" y2="-256" x1="0" />
            <line x2="216" y1="-160" y2="-160" x1="256" />
            <circle r="12" cx="204" cy="-160" />
            <line x2="64" y1="-64" y2="-256" x1="64" />
            <line x2="144" y1="-208" y2="-208" x1="64" />
            <arc ex="144" ey="-208" sx="144" sy="-112" r="48" cx="144" cy="-160" />
            <line x2="64" y1="-112" y2="-112" x1="144" />
        </blockdef>
        <blockdef name="gnd">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-96" x1="64" />
            <line x2="52" y1="-48" y2="-48" x1="76" />
            <line x2="60" y1="-32" y2="-32" x1="68" />
            <line x2="40" y1="-64" y2="-64" x1="88" />
            <line x2="64" y1="-64" y2="-80" x1="64" />
            <line x2="64" y1="-128" y2="-96" x1="64" />
        </blockdef>
        <blockdef name="vcc">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-32" y2="-64" x1="64" />
            <line x2="64" y1="0" y2="-32" x1="64" />
            <line x2="32" y1="-64" y2="-64" x1="96" />
        </blockdef>
        <block symbolname="D_74LS138" name="XLXI_4">
            <blockpin signalname="S1" name="A" />
            <blockpin signalname="S2" name="B" />
            <blockpin signalname="S3" name="C" />
            <blockpin signalname="XLXN_65" name="G" />
            <blockpin signalname="XLXN_60" name="G2A" />
            <blockpin signalname="XLXN_62" name="G2B" />
            <blockpin signalname="Y(7:0)" name="Y(7:0)" />
        </block>
        <block symbolname="nand4" name="XLXI_5">
            <blockpin signalname="Y(1)" name="I0" />
            <blockpin signalname="Y(2)" name="I1" />
            <blockpin signalname="Y(4)" name="I2" />
            <blockpin signalname="Y(7)" name="I3" />
            <blockpin signalname="F" name="O" />
        </block>
        <block symbolname="gnd" name="XLXI_8">
            <blockpin signalname="XLXN_60" name="G" />
        </block>
        <block symbolname="vcc" name="XLXI_9">
            <blockpin signalname="XLXN_65" name="P" />
        </block>
        <block symbolname="gnd" name="XLXI_7">
            <blockpin signalname="XLXN_62" name="G" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <branch name="S1">
            <wire x2="352" y1="288" y2="288" x1="320" />
        </branch>
        <iomarker fontsize="28" x="320" y="288" name="S1" orien="R180" />
        <branch name="S2">
            <wire x2="352" y1="352" y2="352" x1="320" />
        </branch>
        <iomarker fontsize="28" x="320" y="352" name="S2" orien="R180" />
        <branch name="S3">
            <wire x2="352" y1="416" y2="416" x1="320" />
        </branch>
        <iomarker fontsize="28" x="320" y="416" name="S3" orien="R180" />
        <instance x="352" y="640" name="XLXI_4" orien="R0">
        </instance>
        <instance x="992" y="608" name="XLXI_5" orien="R0" />
        <branch name="F">
            <wire x2="1280" y1="448" y2="448" x1="1248" />
        </branch>
        <iomarker fontsize="28" x="1280" y="448" name="F" orien="R0" />
        <branch name="Y(7:0)">
            <wire x2="816" y1="288" y2="288" x1="736" />
            <wire x2="816" y1="288" y2="368" x1="816" />
            <wire x2="816" y1="368" y2="416" x1="816" />
            <wire x2="816" y1="416" y2="464" x1="816" />
            <wire x2="816" y1="464" y2="528" x1="816" />
            <wire x2="816" y1="528" y2="560" x1="816" />
        </branch>
        <bustap x2="912" y1="368" y2="368" x1="816" />
        <branch name="Y(7)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:28;fontname:Arial" attrname="Name" x="928" y="368" type="branch" />
            <wire x2="928" y1="368" y2="368" x1="912" />
            <wire x2="944" y1="368" y2="368" x1="928" />
            <wire x2="992" y1="352" y2="352" x1="944" />
            <wire x2="944" y1="352" y2="368" x1="944" />
        </branch>
        <bustap x2="912" y1="416" y2="416" x1="816" />
        <branch name="Y(4)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:28;fontname:Arial" attrname="Name" x="928" y="416" type="branch" />
            <wire x2="928" y1="416" y2="416" x1="912" />
            <wire x2="992" y1="416" y2="416" x1="928" />
        </branch>
        <bustap x2="912" y1="464" y2="464" x1="816" />
        <bustap x2="912" y1="528" y2="528" x1="816" />
        <branch name="Y(1)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:28;fontname:Arial" attrname="Name" x="928" y="528" type="branch" />
            <wire x2="928" y1="528" y2="528" x1="912" />
            <wire x2="944" y1="528" y2="528" x1="928" />
            <wire x2="944" y1="528" y2="544" x1="944" />
            <wire x2="992" y1="544" y2="544" x1="944" />
        </branch>
        <branch name="Y(2)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:28;fontname:Arial" attrname="Name" x="928" y="464" type="branch" />
            <wire x2="928" y1="464" y2="464" x1="912" />
            <wire x2="944" y1="464" y2="464" x1="928" />
            <wire x2="944" y1="464" y2="480" x1="944" />
            <wire x2="992" y1="480" y2="480" x1="944" />
        </branch>
        <instance x="192" y="640" name="XLXI_8" orien="R0" />
        <branch name="XLXN_60">
            <wire x2="256" y1="496" y2="512" x1="256" />
            <wire x2="336" y1="496" y2="496" x1="256" />
            <wire x2="336" y1="496" y2="544" x1="336" />
            <wire x2="352" y1="544" y2="544" x1="336" />
        </branch>
        <branch name="XLXN_62">
            <wire x2="352" y1="608" y2="608" x1="320" />
            <wire x2="320" y1="608" y2="624" x1="320" />
        </branch>
        <instance x="256" y="752" name="XLXI_7" orien="R0" />
        <instance x="48" y="512" name="XLXI_9" orien="R0" />
        <branch name="XLXN_65">
            <wire x2="112" y1="512" y2="576" x1="112" />
            <wire x2="208" y1="576" y2="576" x1="112" />
            <wire x2="208" y1="480" y2="576" x1="208" />
            <wire x2="352" y1="480" y2="480" x1="208" />
        </branch>
    </sheet>
</drawing>