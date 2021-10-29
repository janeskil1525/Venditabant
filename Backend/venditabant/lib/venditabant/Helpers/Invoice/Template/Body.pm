package venditabant::Helpers::Invoice::Template::Body;
use strict;
use warnings FATAL => 'all';


sub body ($self) {
    return qq{
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
	<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=windows-1252">
	<TITLE></TITLE>
	<META NAME="GENERATOR" CONTENT="OpenOffice 4.1.11  (Win32)">
	<META NAME="AUTHOR" CONTENT="Jan Eskilsson">
	<META NAME="CREATED" CONTENT="20211029;14111284">
	<META NAME="CHANGEDBY" CONTENT="Jan Eskilsson">
	<META NAME="CHANGED" CONTENT="20211029;14363615">
	<STYLE TYPE="text/css">
	<!--
		@page { margin: 0.79in }
		P { margin-bottom: 0.08in }
		TD P { margin-bottom: 0in }
		A:link { so-language: zxx }
	-->
	</STYLE>
</HEAD>
<BODY LANG="sv-SE" DIR="LTR">
<P STYLE="margin-bottom: 0in"><BR>
</P>
<TABLE WIDTH=100% BORDER=1 BORDERCOLOR="#000000" CELLPADDING=4 CELLSPACING=0>
	<COL WIDTH=43*>
	<COL WIDTH=43*>
	<COL WIDTH=43*>
	<COL WIDTH=43*>
	<COL WIDTH=43*>
	<COL WIDTH=43*>
	<TR VALIGN=TOP>
		<TD WIDTH=17%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=17%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=17%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=17%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=17%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=17%>
			<P><BR>
			</P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=17%>
			<P><FONT SIZE=2>@@STOCKITEM@@</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><FONT SIZE=2>@@DESCRIPTION@@</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><FONT SIZE=2>@@QUANTITY@@</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><FONT SIZE=2>@@UNIT@@</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><FONT SIZE=2>@@PRICE@@</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><FONT SIZE=2>@@TOTAL@@</FONT></P>
		</TD>
	</TR>
</TABLE>
<P STYLE="margin-bottom: 0in"><BR>
</P>
</BODY>
</HTML>
    }
}
1;