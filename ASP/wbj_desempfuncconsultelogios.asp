<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--#include file="verificalogintripulante.asp"-->

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Page-Exit" content="blendTrans(Duration=1)">
<title>SIGLA - Untitled Document</title>

<script language="javascript">

function enviar(){
	document.sigla.submit();
//	alert("teste");
}
</script>
</head>

<body onload="enviar();">
	<form name='sigla'  id = 'sigla' action='http://biblioteca.webjet.ws/desfunc/latop_resultelogios.php' method='post'>
		<div>
			<!-- <li style='font-size: 17 px'> -->
			<!-- <a href='javascript: document.sigla.submit ();' class='CORPO' style='font-size: 17 px'>Desempenho Funcional – Consultar Elogios</a></li> -->
			<input type='hidden' name='acesso' value='SIGLA'>
			<input type='hidden' name='nomeguerra' value='<%=Session("login") %>'>
			<input type='hidden' name='crg' value='<%=Session("codcargo") %>'>
		</div>
	</form>
</body>
</html>
