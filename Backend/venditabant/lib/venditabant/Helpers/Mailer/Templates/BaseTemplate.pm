package venditabant::Helpers::Mailer::Templates::BaseTemplate;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;


async sub getbasetemplate($self) {
    return qq {
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
		\@page { margin: 0.79in }
		P { margin-bottom: 0.08in }
		TD P { margin-bottom: 0in }
		A:link { so-language: zxx }
	-->
	</STYLE>
</HEAD>
<BODY>
---HEADER---
---BODY---
---FOOTER---
</BODY>
</HTML>

    }
}
1;