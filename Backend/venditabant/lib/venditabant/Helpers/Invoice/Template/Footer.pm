package venditabant::Helpers::Invoice::Template::Footer;
use strict;
use warnings FATAL => 'all';

sub footer ($self) {
    return qq {
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
	<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=windows-1252">
	<TITLE></TITLE>
	<META NAME="GENERATOR" CONTENT="OpenOffice 4.1.11  (Win32)">
	<META NAME="AUTHOR" CONTENT="Jan Eskilsson">
	<META NAME="CREATED" CONTENT="20211029;13482309">
	<META NAME="CHANGEDBY" CONTENT="Jan Eskilsson">
	<META NAME="CHANGED" CONTENT="20211029;14060646">
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
<TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=0>
	<COL WIDTH=64*>
	<COL WIDTH=64*>
	<COL WIDTH=64*>
	<COL WIDTH=64*>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>Tel: @@COMPANYPHONE@@</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>Bankgiro: @@GIRO@@</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>@@COMPANYMAIL@@</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>VAT-nr: @@REGISTRATIONNUMBER@@</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>@@COMPANYHOMPAGE@@</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>Godk&auml;nnd f&ouml;r F-Skatt</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
	</TR>
</TABLE>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<P STYLE="margin-bottom: 0in"><BR>
</P>
</BODY>
</HTML>
    }
}
1;