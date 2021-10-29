package venditabant::Helpers::Invoice::Template::Header;
use strict;
use warnings FATAL => 'all';


sub header ($self) {

    return qq{
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
	<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=windows-1252">
	<TITLE></TITLE>
	<META NAME="GENERATOR" CONTENT="OpenOffice 4.1.11  (Win32)">
	<META NAME="AUTHOR" CONTENT="Jan Eskilsson">
	<META NAME="CREATED" CONTENT="20211029;10011975">
	<META NAME="CHANGEDBY" CONTENT="Jan Eskilsson">
	<META NAME="CHANGED" CONTENT="20211029;14352916">
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
<TABLE WIDTH=100% BORDER=0 CELLPADDING=4 CELLSPACING=0 STYLE="page-break-before: always">
	<COL WIDTH=128*>
	<COL WIDTH=128*>
	<TR VALIGN=TOP>
		<TD WIDTH=50%>
			<P>@@COMPANYNAME@@</P>
		</TD>
		<TD WIDTH=50%>
			<P><BR>
			</P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=50%>
			<P>@@COMPANYADDRESS@@</P>
		</TD>
		<TD WIDTH=50%>
			<P ALIGN=RIGHT><FONT SIZE=4 STYLE="font-size: 16pt"><B>Faktura</B></FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=50%>
			<P>@@ZIPCODE@@ @@CITY@@@</P>
		</TD>
		<TD WIDTH=50%>
			<P><BR>
			</P>
		</TD>
	</TR>
</TABLE>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<TABLE WIDTH=100% BORDER=1 BORDERCOLOR="#000000" CELLPADDING=4 CELLSPACING=0 FRAME=LHS RULES=GROUPS>
	<COLGROUP>
		<COL WIDTH=64*>
		<COL WIDTH=64*>
	</COLGROUP>
	<COLGROUP>
		<COL WIDTH=49*>
		<COL WIDTH=79*>
	</COLGROUP>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P>Fakturadatum</P>
		</TD>
		<TD WIDTH=25%>
			<P ALIGN=RIGHT>@@INVOICEDATE@@</P>
		</TD>
		<TD WIDTH=19%>
			<P ALIGN=CENTER><FONT SIZE=2><B>Faktura address</B></FONT></P>
		</TD>
		<TD WIDTH=31%>
			<P><FONT SIZE=2>@@CUSTOMERNAME@@</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P>Fakturanummer</P>
		</TD>
		<TD WIDTH=25%>
			<P ALIGN=RIGHT>@@INVOICENO@@</P>
		</TD>
		<TD WIDTH=19%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=31%>
			<P><FONT SIZE=2>@@ADDRESS1@@</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P>Kundnummer</P>
		</TD>
		<TD WIDTH=25%>
			<P ALIGN=RIGHT>@@CUSTOMER@@</P>
		</TD>
		<TD WIDTH=19%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=31%>
			<P><FONT SIZE=2>@@ADDRESS2@@</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=25%>
			<P ALIGN=RIGHT><BR>
			</P>
		</TD>
		<TD WIDTH=19%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=31%>
			<P><FONT SIZE=2>@@ADDRESS3@@</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=25%>
			<P ALIGN=RIGHT><BR>
			</P>
		</TD>
		<TD WIDTH=19%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=31%>
			<P><FONT SIZE=2>@@CUSTZIPCODE@@ @@CUSTCITY@@</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P>F&ouml;rfallodatum</P>
		</TD>
		<TD WIDTH=25%>
			<P ALIGN=RIGHT>@@PAYDATE@@</P>
		</TD>
		<TD WIDTH=19%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=31%>
			<P><BR>
			</P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P>Bankgiro</P>
		</TD>
		<TD WIDTH=25%>
			<P ALIGN=RIGHT>@@GIRO@@</P>
		</TD>
		<TD WIDTH=19%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=31%>
			<P><BR>
			</P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=25% HEIGHT=24>
			<P><FONT SIZE=4><B>Att betala SEK</B></FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P ALIGN=RIGHT><FONT SIZE=4><B>@@SUM@@</B></FONT></P>
		</TD>
		<TD WIDTH=19%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=31%>
			<P><BR>
			</P>
		</TD>
	</TR>
</TABLE>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<P STYLE="margin-bottom: 0in"><BR>
</P>
<TABLE WIDTH=100% BORDER=1 BORDERCOLOR="#000000" CELLPADDING=4 CELLSPACING=0>
	<COL WIDTH=64*>
	<COL WIDTH=64*>
	<COL WIDTH=64*>
	<COL WIDTH=64*>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>Er referens</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>@@CUSTREFERENCE@@</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>V&aring;r referens</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>@@COMPANYREFERENCE@@</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=25% HEIGHT=16>
			<P><FONT SIZE=2>Ert ordernr</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>@@YOURORDERNO@@</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>Dr&ouml;jsm&aring;lsr&auml;nta</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>Leveransvillkor</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>@@DELIVERYWAY@@</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>Leveransdatum</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><BR>
			</P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>Leveranss&auml;tt</FONT></P>
		</TD>
		<TD WIDTH=25%>
			<P><FONT SIZE=2>@@DELIVERYWAY@@</FONT></P>
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
</BODY>
</HTML>
    }
}
1;