<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="kintex7" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="LED(7:0)" />
        <signal name="SW(5:0)" />
        <signal name="SW(5)" />
        <signal name="SW(4)" />
        <signal name="SW(3)" />
        <signal name="SW(2)" />
        <signal name="SW(1)" />
        <signal name="SW(0)" />
        <signal name="XLXN_9" />
        <port polarity="Output" name="LED(7:0)" />
        <port polarity="Input" name="SW(5:0)" />
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
        <block symbolname="D_74LS138" name="XLXI_1">
            <blockpin signalname="SW(5)" name="A" />
            <blockpin signalname="SW(4)" name="B" />
            <blockpin signalname="SW(3)" name="C" />
            <blockpin signalname="SW(2)" name="G" />
            <blockpin signalname="SW(1)" name="G2A" />
            <blockpin signalname="SW(0)" name="G2B" />
            <blockpin signalname="LED(7:0)" name="Y(7:0)" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="624" y="1536" name="XLXI_1" orien="R0">
        </instance>
        <branch name="LED(7:0)">
            <wire x2="1040" y1="1184" y2="1184" x1="1008" />
        </branch>
        <iomarker fontsize="28" x="1040" y="1184" name="LED(7:0)" orien="R0" />
        <branch name="SW(5:0)">
            <attrtext style="alignment:SOFT-VRIGHT;fontsize:28;fontname:Arial" attrname="Name" x="352" y="1584" type="branch" />
            <wire x2="352" y1="1072" y2="1168" x1="352" />
            <wire x2="352" y1="1168" y2="1248" x1="352" />
            <wire x2="352" y1="1248" y2="1312" x1="352" />
            <wire x2="352" y1="1312" y2="1376" x1="352" />
            <wire x2="352" y1="1376" y2="1440" x1="352" />
            <wire x2="352" y1="1440" y2="1504" x1="352" />
            <wire x2="352" y1="1504" y2="1584" x1="352" />
        </branch>
        <iomarker fontsize="28" x="352" y="1072" name="SW(5:0)" orien="R270" />
        <bustap x2="448" y1="1168" y2="1168" x1="352" />
        <branch name="SW(5)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:28;fontname:Arial" attrname="Name" x="464" y="1168" type="branch" />
            <wire x2="464" y1="1168" y2="1168" x1="448" />
            <wire x2="480" y1="1168" y2="1168" x1="464" />
            <wire x2="480" y1="1168" y2="1184" x1="480" />
            <wire x2="624" y1="1184" y2="1184" x1="480" />
        </branch>
        <bustap x2="448" y1="1248" y2="1248" x1="352" />
        <branch name="SW(4)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:28;fontname:Arial" attrname="Name" x="456" y="1248" type="branch" />
            <wire x2="456" y1="1248" y2="1248" x1="448" />
            <wire x2="576" y1="1248" y2="1248" x1="456" />
            <wire x2="624" y1="1248" y2="1248" x1="576" />
        </branch>
        <bustap x2="448" y1="1312" y2="1312" x1="352" />
        <branch name="SW(3)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:28;fontname:Arial" attrname="Name" x="464" y="1312" type="branch" />
            <wire x2="464" y1="1312" y2="1312" x1="448" />
            <wire x2="480" y1="1312" y2="1312" x1="464" />
            <wire x2="624" y1="1312" y2="1312" x1="480" />
        </branch>
        <bustap x2="448" y1="1376" y2="1376" x1="352" />
        <branch name="SW(2)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:28;fontname:Arial" attrname="Name" x="464" y="1376" type="branch" />
            <wire x2="464" y1="1376" y2="1376" x1="448" />
            <wire x2="480" y1="1376" y2="1376" x1="464" />
            <wire x2="624" y1="1376" y2="1376" x1="480" />
        </branch>
        <bustap x2="448" y1="1440" y2="1440" x1="352" />
        <branch name="SW(1)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:28;fontname:Arial" attrname="Name" x="472" y="1440" type="branch" />
            <wire x2="472" y1="1440" y2="1440" x1="448" />
            <wire x2="496" y1="1440" y2="1440" x1="472" />
            <wire x2="624" y1="1440" y2="1440" x1="496" />
        </branch>
        <bustap x2="448" y1="1504" y2="1504" x1="352" />
        <branch name="SW(0)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:28;fontname:Arial" attrname="Name" x="472" y="1504" type="branch" />
            <wire x2="472" y1="1504" y2="1504" x1="448" />
            <wire x2="496" y1="1504" y2="1504" x1="472" />
            <wire x2="624" y1="1504" y2="1504" x1="496" />
        </branch>
    </sheet>
</drawing>