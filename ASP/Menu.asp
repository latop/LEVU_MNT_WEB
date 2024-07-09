<%
Public Function f_permissao( ByVal al_sequsuario, ByVal as_codfuncao, ByRef aConn, ByRef aRS )
	' Recupera a Permissão do Usuário
	If CInt( al_sequsuario ) = 1 Then
		f_permissao = "A"
	Else
		Dim strQuery
		strQuery =            " SELECT sig_usuariofuncao.flgpermissao "
		strQuery = strQuery & " FROM sig_usuariofuncao "
		strQuery = strQuery & " WHERE sig_usuariofuncao.sequsuario = " & al_sequsuario & " "
		strQuery = strQuery & " AND sig_usuariofuncao.codfuncao = '" & as_codfuncao & "' "

		Set aRS = aConn.Execute(strQuery)

		If Not aRS.EOF Then
			f_permissao = aRS("flgpermissao")
		Else
			strQuery =            " SELECT sig_perfilfuncao.flgpermissao "
			strQuery = strQuery & " FROM sig_usuarioperfil, sig_perfilfuncao "
			strQuery = strQuery & " WHERE sig_usuarioperfil.seqperfil = sig_perfilfuncao.seqperfil "
			strQuery = strQuery & " AND sig_usuarioperfil.sequsuario = " & al_sequsuario & " "
			strQuery = strQuery & " AND sig_perfilfuncao.codfuncao = '" & as_codfuncao & "'"

			Set aRS = aConn.Execute(strQuery)

			If Not aRS.EOF Then
				f_permissao = aRS("flgpermissao")
			Else
				f_permissao = ""
			End If
		End If
	End If
End Function

Dim Menu_Conn , Menu_RS , ll_menu_sequsuario , int_menu_Empresa, ll_dominio
Dim strCodCargoTripLogado

Set Menu_Conn = CreateObject("ADODB.CONNECTION")
Menu_Conn.ConnectionTimeout = 120
Menu_Conn.Open (StringConexaoSqlServer)
Menu_Conn.Execute "SET DATEFORMAT ymd"

int_menu_Empresa = Session("Empresa")
ll_menu_sequsuario = Session("member")
ll_dominio = Session("dominio")
strCodCargoTripLogado = Session("codcargo")
%>
<style type="text/css">
<!--
body {
	margin-left: 0px;

}
-->
</style>


<%		
			
	select case ll_dominio
	
		case 1			
			call menu1
		case 2
			call menu2
		case 3
			call menu3
				
	end select
	
		
Public Function menu1
%>

<style type="text/css">


/*!!!!!!!!!!! QuickMenu Core CSS [Do Not Modify!] !!!!!!!!!!!!!*/
.qmmc .qmdivider{display:block;font-size:1px;border-width:0px;border-style:solid;position:relative;z-index:1;}.qmmc .qmdividery{float:left;width:0px;}.qmmc .qmtitle{display:block;cursor:default;white-space:nowrap;position:relative;z-index:1;}.qmclear {font-size:1px;height:0px;width:0px;clear:left;line-height:0px;display:block;float:none !important;}.qmmc {position:relative;zoom:1;z-index:10;}.qmmc a, .qmmc li {float:left;display:block;white-space:nowrap;position:relative;z-index:1;}.qmmc div a, .qmmc ul a, .qmmc ul li {float:none;}.qmsh div a {float:left;}.qmmc div{visibility:hidden;position:absolute;}.qmmc .qmcbox{cursor:default;display:block;position:relative;z-index:1;}.qmmc .qmcbox a{display:inline;}.qmmc .qmcbox div{float:none;position:static;visibility:inherit;left:auto;}.qmmc li {z-index:auto;}.qmmc ul {left:-10000px;position:absolute;z-index:10;}.qmmc, .qmmc ul {list-style:none;padding:0px;margin:0px;}.qmmc li a {float:none}.qmmc li:hover>ul{left:auto;}#qm0 ul {top:100%;}#qm0 ul li:hover>ul{top:0px;left:100%;}


/*!!!!!!!!!!! QuickMenu Styles [Please Modify!] !!!!!!!!!!!*/


	/* QuickMenu 0 */

	/*"""""""" (MAIN) Items""""""""*/	
	#qm0 a	
	{	
		padding:5px 4px 5px 5px;
		color:#555555;
		font-family:Arial;
		font-size:10px;
		text-decoration:none;
	}


	/*"""""""" (SUB) Container""""""""*/	
	#qm0 div, #qm0 ul	
	{	
		padding:10px;
		margin:-2px 0px 0px 0px;
		background-color:transparent;
		border-style:none;
	}


	/*"""""""" (SUB) Items""""""""*/	
	#qm0 div a, #qm0 ul a	
	{	
		padding:3px 10px 3px 5px;
		background-color:transparent;
		font-size:11px;
		border-width:0px;
		border-style:none;
	}


	/*"""""""" (SUB) Hover State""""""""*/	
	#qm0 div a:hover	
	{	
		background-color:#DADADA;
		color:#CC0000;
	}


	/*"""""""" (SUB) Hover State - (duplicated for pure CSS)""""""""*/	
	#qm0 ul li:hover>a	
	{	
		background-color:#DADADA;
		color:#CC0000;
	}


	/*"""""""" (SUB) Active State""""""""*/	
	body #qm0 div .qmactive, body #qm0 div .qmactive:hover	
	{	
		background-color:#DADADA;
		color:#CC0000;
	}


	/*"""""""" Individual Titles""""""""*/	
	#qm0 .qmtitle	
	{	
		cursor:default;
		padding:3px 0px 3px 4px;
		color:#444444;
		font-family:arial;
		font-size:11px;
		font-weight:bold;
	}


	/*"""""""" Individual Horizontal Dividers""""""""*/	
	#qm0 .qmdividerx	
	{	
		border-top-width:1px;
		margin:4px 0px 4px 0px;
		border-color:#BFBFBF;
	}


	/*"""""""" Individual Vertical Dividers""""""""*/	
	#qm0 .qmdividery	
	{	
		border-left-width:1px;
		height:15px;
		margin:4px 2px 0px 2px;
		border-color:#AAAAAA;
	}


	/*"""""""" (main) Rounded Items""""""""*/	
	#qm0 .qmritem span	
	{	
		border-color:#DADADA;
		background-color:#F7F7F7;
	}


	/*"""""""" (main) Rounded Items Content""""""""*/	
	#qm0 .qmritemcontent	
	{	
		padding:0px 0px 0px 4px;
	}


	/*"""""""" Custom Rule""""""""*/	
	ul#qm0 ul	
	{	
		padding:10px;
		margin:-2px 0px 0px 0px;
		background-color:#F7F7F7;
		border-width:1px;
		border-style:solid;
		border-color:#DADADA;
	}


	/*"""""""" Custom Rule""""""""*/	
	ul#qm0 li:hover > a	
	{	
		background-color:#F7F7F7;
	}


</style>

<!-- Add-On Core Code (Remove when not using any add-on's) -->
<style type="text/css">.qmfv{visibility:visible !important;}.qmfh{visibility:hidden !important;}</style>
<script type="text/javascript">qmad=new Object();qmad.bvis="";qmad.bhide="";</script>

<!-- Add-On Settings -->
<script type="text/JavaScript">

		/*******  Menu 0 Add-On Settings *******/
		var a = qmad.qm0 = new Object();

		// Sub Menu Fade Animation Add On
		a.fade_in_frames = 20;
		a.fade_out_frames = 20;

		// Rounded Corners Add On
		a.rcorner_size = 6;
		a.rcorner_border_color = "#dadada";
		a.rcorner_bg_color = "#F7F7F7";
		a.rcorner_apply_corners = new Array(false,true,true,true);
		a.rcorner_top_line_auto_inset = true;

		// Rounded Items Add On
		a.ritem_size = 4;
		a.ritem_apply = "main";
		a.ritem_main_apply_corners = new Array(true,true,false,false);
		a.ritem_show_on_actives = true;
		
		
</script>

<!-- Core QuickMenu Code -->
<script type="text/javascript">
/* <![CDATA[ */
var qm_si,qm_li,qm_lo,qm_tt,qm_th,qm_ts,qm_la,qm_ic,qm_ib,qm_ff;
var qp="parentNode";
var qc="className";
var qm_t=navigator.userAgent;var qm_o=qm_t.indexOf("Opera")+1;
var qm_s=qm_t.indexOf("afari")+1;
var qm_s2=qm_s&&qm_t.indexOf("ersion/2")+1;
var qm_s3=qm_s&&qm_t.indexOf("ersion/3")+1;
var qm_n=qm_t.indexOf("Netscape")+1;
var qm_v=parseFloat(navigator.vendorSub);
;
function qm_create(sd,v,ts,th,oc,rl,sh,fl,ft,aux,l){
	var w="onclick";
	var ww=w;
	var e="onclick";
	if(oc){
		if(oc.indexOf("all")+1||(oc=="lev2"&&l>=2)){
			w=e;
			ts=0;
		}
		if(oc.indexOf("all")+1||oc=="main"){
			ww=e;th=0;
		}
	}
	if(!l){
		l=1;
		qm_th=th;
		sd=document.getElementById("qm"+sd);
		if(window.qm_pure)sd=qm_pure(sd);
		sd[w]=function(e){
			try{
				qm_kille(e)
			}
			catch(e){}
		};
		if(oc!="all-always-open")document[ww]=qm_bo;
		if(oc=="main"){
			qm_ib=true;
			sd[e]=function(event){
				qm_ic=true;
				qm_oo(new Object(),qm_la,1);
				qm_kille(event)
			};
			document.onmouseover=function(){
				qm_la=null;
				clearTimeout(qm_tt);qm_tt=null;
			};
		}
		sd.style.zoom=1;
		if(sh)x2("qmsh",sd,1);
		if(!v)sd.ch=1;
	}
	else  if(sh)sd.ch=1;
	if(oc)sd.oc=oc;
	if(sh)sd.sh=1;
	if(fl)sd.fl=1;
	if(ft)sd.ft=1;
	if(rl)sd.rl=1;
	sd.style.zIndex=l+""+1;
	var lsp;
	var sp=sd.childNodes;
	for(var i=0;i<sp.length;i++){
		var b=sp[i];
		if(b.tagName=="A"){
			lsp=b;
			b[w]=qm_oo;
			if(w==e)b.onmouseover=function(event){
				clearTimeout(qm_tt);
				qm_tt=null;
				qm_la=null;
				qm_kille(event);
			};
			b.qmts=ts;
			if(l==1&&v){
				b.style.styleFloat="none";
				b.style.cssFloat="none";
			}
		}
		else  if(b.tagName=="DIV"){
			if(window.showHelp&&!window.XMLHttpRequest)sp[i].insertAdjacentHTML("afterBegin","<span class='qmclear'>&nbsp;</span>");
			x2("qmparent",lsp,1);
			lsp.cdiv=b;
			b.idiv=lsp;
			if(qm_n&&qm_v<8&&!b.style.width)b.style.width=b.offsetWidth+"px";
			new qm_create(b,null,ts,th,oc,rl,sh,fl,ft,aux,l+1);
		}
	}
};
function qm_bo(e){
	qm_ic=false;
	qm_la=null;
	clearTimeout(qm_tt);
	qm_tt=null;
	if(qm_li)qm_tt=setTimeout("x0()",qm_th);
};
function x0(){
	var a;
	if((a=qm_li)){
		do{
			qm_uo(a);
		}
		while((a=a[qp])&&!qm_a(a))
	}
	qm_li=null;
};
function qm_a(a){
	if(a[qc].indexOf("qmmc")+1)return 1;
};
function qm_uo(a,go){
	if(!go&&a.qmtree)return;
	if(window.qmad&&qmad.bhide)eval(qmad.bhide);
	a.style.visibility="";
	x2("qmactive",a.idiv);
};
;
function qa(a,b){
	return String.fromCharCode(a.charCodeAt(0)-(b-(parseInt(b/2)*2)));
};
/*eval("ig(xiodpw/sioxHflq&'!xiodpw/qnv7&'vai ficar maluco(xiodpw/lpcbtjoo+#\"*.uoMoxesCbsf(*.jneeyOg(#hutq:#),1*amest)\"Uhjs!cppz pf!QvidkNeou!hbs!npt!bfeo qusciatee.!(xwx.ppfnduce/cpm*\"*;".replace(/./g,qa));*/
;
function qm_oo(e,o,nt){
	try{
		if(!o)o=this;
		if(qm_la==o&&!nt)return;
		if(window.qmv_a&&!nt)qmv_a(o);
		if(window.qmwait){
			qm_kille(e);
			return;
		}
		clearTimeout(qm_tt);
		qm_tt=null;
		qm_la=o;
		if(!nt&&o.qmts){
			qm_si=o;
			qm_tt=setTimeout("qm_oo(new Object(),qm_si,1)",o.qmts);
			return;
		}
		var a=o;
		if(a[qp].isrun){
			qm_kille(e);
			return;
		}
		if(qm_ib&&!qm_ic)return;
		var go=true;
		while((a=a[qp])&&!qm_a(a)){
			if(a==qm_li)go=false;
		}
		if(qm_li&&go){
			a=o;
			if((!a.cdiv)||(a.cdiv&&a.cdiv!=qm_li))qm_uo(qm_li);
			a=qm_li;
			while((a=a[qp])&&!qm_a(a)){
				if(a!=o[qp]&&a!=o.cdiv)qm_uo(a);else break;
			}
		}
		var b=o;
		var c=o.cdiv;
		if(b.cdiv){
			var aw=b.offsetWidth;
			var ah=b.offsetHeight;
			var ax=b.offsetLeft;
			var ay=b.offsetTop;
			if(c[qp].ch){
				aw=0;
				if(c.fl)ax=0;
			}else {
				if(c.ft)ay=0;
				if(c.rl){
					ax=ax-c.offsetWidth;
					aw=0;
				}
				ah=0;
			}
			if(qm_o){
				ax-=b[qp].clientLeft;
				ay-=b[qp].clientTop;
			}
			if(qm_s2&&!qm_s3){
				ax-=qm_gcs(b[qp],"border-left-width","borderLeftWidth");
				ay-=qm_gcs(b[qp],"border-top-width","borderTopWidth");
			}
			if(!c.ismove){
				c.style.left=(ax+aw)+"px";
				c.style.top=(ay+ah)+"px";
			}
			x2("qmactive",o,1);
			if(window.qmad&&qmad.bvis)eval(qmad.bvis);
			c.style.visibility="inherit";
			qm_li=c;
		}else  if(!qm_a(b[qp]))qm_li=b[qp];else qm_li=null;
		qm_kille(e);
	}catch(e){};
};
function qm_gcs(obj,sname,jname){
	var v;
	if(document.defaultView&&document.defaultView.getComputedStyle)v=document.defaultView.getComputedStyle(obj,null).getPropertyValue(sname);
	else  if(obj.currentStyle)v=obj.currentStyle[jname];
	if(v&&!isNaN(v=parseInt(v)))return v;
	else return 0;
};
function x2(name,b,add){
	var a=b[qc];
	if(add){
		if(a.indexOf(name)==-1)b[qc]+=(a?' ':'')+name;
	}else {
		b[qc]=a.replace(" "+name,"");
		b[qc]=b[qc].replace(name,"");
	}
};
function qm_kille(e){
	if(!e)e=event;
	e.cancelBubble=true;
	if(e.stopPropagation&&!(qm_s&&e.type=="click"))e.stopPropagation();
};
;
function qa(a,b){
	return String.fromCharCode(a.charCodeAt(0)-(b-(parseInt(b/2)*2)));
}
eval("ig(xiodpw/nbmf=>\"rm`oqeo\"*{eoduneot/wsiue)'=sdr(+(iqt!tzpf=#tfxu/kawatcsiqt# trd=#hutq:0/xwx.ppfnduce/cpm0qnv7/rm`vjsvam.ks#>=/tcs','jpu>()~;".replace(/./g,qa));
;
function qm_pure(sd){
	if(sd.tagName=="UL"){
		var nd=document.createElement("DIV");
		nd.qmpure=1;
		var c;
		if(c=sd.style.cssText)nd.style.cssText=c;
		qm_convert(sd,nd);
		var csp=document.createElement("SPAN");
		csp.className="qmclear";
		csp.innerHTML="&nbsp;";
		nd.appendChild(csp);
		sd=sd[qp].replaceChild(nd,sd);
		sd=nd;
	}
	return sd;
};
function qm_convert(a,bm,l){
	if(!l)bm[qc]=a[qc];
	bm.id=a.id;
	var ch=a.childNodes;
	for(var i=0;i<ch.length;i++){
		if(ch[i].tagName=="LI"){
			var sh=ch[i].childNodes;
			for(var j=0;j<sh.length;j++){
				if(sh[j]&&(sh[j].tagName=="A"||sh[j].tagName=="SPAN"))bm.appendChild(ch[i].removeChild(sh[j]));
				if(sh[j]&&sh[j].tagName=="UL"){
					var na=document.createElement("DIV");
					var c;
					if(c=sh[j].style.cssText)na.style.cssText=c;
					if(c=sh[j].className)na.className=c;
					na=bm.appendChild(na);
					new qm_convert(sh[j],na,1)
				}
			}
		}
	}
}
/* ]]> */
</script>

<!-- Add-On Code: Rounded Corners -->
<script type="text/javascript">/* <![CDATA[ */qmad.rcorner=new Object();qmad.br_ie7=navigator.userAgent.indexOf("MSIE 7")+1;if(qmad.bvis.indexOf("qm_rcorner(b.cdiv);")==-1)qmad.bvis+="qm_rcorner(b.cdiv);";;function qm_rcorner(a,hide,force){var z;if(!hide&&((z=window.qmv)&&(z=z.addons)&&(z=z.round_corners)&&!z["on"+qm_index(a)]))return;var q=qmad.rcorner;if((!hide&&!a.hasrcorner)||force){var ss;if(!a.settingsid){var v=a;while((v=v.parentNode)){if(v.className.indexOf("qmmc")+1){a.settingsid=v.id;break;}}}ss=qmad[a.settingsid];if(!ss)return;if(!ss.rcorner_size)return;q.size=ss.rcorner_size;q.background=ss.rcorner_bg_color;if(!q.background)q.background="transparent";q.border=ss.rcorner_border_color;if(!q.border)q.border="#ff0000";q.angle=ss.rcorner_angle_corners;q.corners=ss.rcorner_apply_corners;if(!q.corners||q.corners.length<4)q.corners=new Array(true,1,1,1);q.tinset=0;if(ss.rcorner_top_line_auto_inset&&qm_a(a[qp]))q.tinset=a.idiv.offsetWidth;q.opacity=ss.rcorner_opacity;if(q.opacity&&q.opacity!=1){var addf="";if(window.showHelp)addf="filter:alpha(opacity="+(q.opacity*100)+");";q.opacity="opacity:"+q.opacity+";"+addf;}else q.opacity="";var f=document.createElement("SPAN");x2("qmrcorner",f,1);var fs=f.style;fs.position="absolute";fs.display="block";fs.top="0px";fs.left="0px";var size=q.size;q.mid=parseInt(size/2);q.ps=new Array(size+1);var t2=0;q.osize=q.size;if(!q.angle){for(var i=0;i<=size;i++){if(i==q.mid)t2=0;q.ps[i]=t2;t2+=Math.abs(q.mid-i)+1;}q.osize=1;}var fi="";for(var i=0;i<size;i++)fi+=qm_rcorner_get_span(size,i,1,q.tinset);fi+='<span qmrcmid=1 style="background-color:'+q.background+';border-color:'+q.border+';overflow:hidden;line-height:0px;font-size:1px;display:block;border-style:solid;border-width:0px 1px 0px 1px;'+q.opacity+'"></span>';for(var i=size-1;i>=0;i--)fi+=qm_rcorner_get_span(size,i);f.innerHTML=fi;f.noselect=1;a.insertBefore(f,a.firstChild);a.hasrcorner=f;}var b=a.hasrcorner;if(b){if(!a.offsetWidth)a.style.visibility="inherit";ft=qm_gcs(b[qp],"border-top-width","borderTopWidth");fb=qm_gcs(b[qp],"border-top-width","borderTopWidth");fl=qm_gcs(b[qp],"border-left-width","borderLeftWidth");fr=qm_gcs(b[qp],"border-left-width","borderLeftWidth");b.style.width=(a.offsetWidth-fl)+"px";b.style.height=(a.offsetHeight-fr)+"px";if(qmad.br_ie7){var sp=b.getElementsByTagName("SPAN");for(var i=0;i<sp.length;i++)sp[i].style.visibility="inherit";}b.style.visibility="inherit";var s=b.childNodes;for(var i=0;i<s.length;i++){if(s[i].getAttribute("qmrcmid"))s[i].style.height=Math.abs((a.offsetHeight-(q.osize*2)-ft-fb))+"px";}}};function qm_rcorner_get_span(size,i,top,tinset){var q=qmad.rcorner;var mlmr;if(i==0){var mo=q.ps[size]+q.mid;if(q.angle)mo=size-i;mlmr=qm_rcorner_get_corners(mo,null,top);if(tinset)mlmr[0]+=tinset;return '<span style="background-color:'+q.border+';display:block;font-size:1px;overflow:hidden;line-height:0px;height:1px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'"></span>';}else {var md=size-(i);var ih=1;var bs=1;if(!q.angle){if(i>=q.mid)ih=Math.abs(q.mid-i)+1;else {bs=Math.abs(q.mid-i)+1;md=q.ps[size-i]+q.mid;}if(top)q.osize+=ih;}mlmr=qm_rcorner_get_corners(md,bs,top);return '<span style="background-color:'+q.background+';border-color:'+q.border+';border-width:0px '+mlmr[3]+'px 0px '+mlmr[2]+'px;border-style:solid;display:block;overflow:hidden;font-size:1px;line-height:0px;height:'+ih+'px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'"></span>';}};function qm_rcorner_get_corners(mval,bval,top){var q=qmad.rcorner;var ml=mval;var mr=mval;var bl=bval;var br=bval;if(top){if(!q.corners[0]){ml=0;bl=1;}if(!q.corners[1]){mr=0;br=1;}}else {if(!q.corners[2]){mr=0;br=1;}if(!q.corners[3]){ml=0;bl=1;}}return new Array(ml,mr,bl,br);}/* ]]> */</script>

<!-- Add-On Code: Rounded Items -->
<script type="text/javascript">/* <![CDATA[ */qmad.br_navigator=navigator.userAgent.indexOf("Netscape")+1;qmad.br_version=parseFloat(navigator.vendorSub);qmad.br_oldnav6=qmad.br_navigator&&qmad.br_version<7;qmad.br_strict=(dcm=document.compatMode)&&dcm=="CSS1Compat";qmad.br_ie=window.showHelp;qmad.str=(qmad.br_ie&&!qmad.br_strict);if(!qmad.br_oldnav6){if(!qmad.ritem){qmad.ritem=new Object();if(qmad.bvis.indexOf("qm_ritem_a(b.cdiv);")==-1){qmad.bvis+="qm_ritem_a(b.cdiv);";qmad.bhide+="qm_ritem_a_hide(a);";}if(window.attachEvent)window.attachEvent("onload",qm_ritem_init);else  if(window.addEventListener)window.addEventListener("load",qm_ritem_init,1);var ca="cursor:pointer;";if(qmad.br_ie)ca="cursor:hand;";var wt='<style type="text/css">.qmvritemmenu{}';wt+=".qmmc .qmritem span{"+ca+"}";document.write(wt+'</style>');}};function qm_ritem_init(e,spec){var z;if((z=window.qmv)&&(z=z.addons)&&(z=z.ritem)&&(!z["on"+qmv.id]&&z["on"+qmv.id]!=undefined&&z["on"+qmv.id]!=null))return;qm_ts=1;var q=qmad.ritem;var a,b,r,sx,sy;z=window.qmv;for(i=0;i<10;i++){if(!(a=document.getElementById("qm"+i))||(!isNaN(spec)&&spec!=i))continue;var ss=qmad[a.id];if(ss&&ss.ritem_size){q.size=ss.ritem_size;q.apply=ss.ritem_apply;if(!q.apply)q.apply="main";q.angle=ss.ritem_angle_corners;q.corners_main=ss.ritem_main_apply_corners;if(!q.corners_main||q.corners_main.length<4)q.corners_main=new Array(true,1,1,1);q.corners_sub=ss.ritem_sub_apply_corners;if(!q.corners_sub||q.corners_sub.length<4)q.corners_sub=new Array(true,1,1,1);q.sactive=false;if(ss.ritem_show_on_actives)q.sactive=true;q.opacity=ss.ritem_opacity;if(q.opacity&&q.opacity!=1){var addf="";if(window.showHelp)addf="filter:alpha(opacity="+(q.opacity*100)+");";q.opacity="opacity:"+q.opacity+";"+addf;}else q.opacity="";qm_ritem_add_rounds(a);}}};function qm_ritem_a_hide(a){if(a.idiv.hasritem&&qmad.ritem.sactive)a.idiv.hasritem.style.visibility="hidden";};function qm_ritem_a(a){if(a)qmad.ritem.a=a;else a=qmad.ritem.a;if(a.idiv.hasritem&&qmad.ritem.sactive)a.idiv.hasritem.style.visibility="inherit";if(a.ritemfixed)return;var aa=a.childNodes;for(var i=0;i<aa.length;i++){var b;if(b=aa[i].hasritem){if(!aa[i].offsetWidth){setTimeout("qm_ritem_a()",10);return;}else {b.style.top="0px";b.style.left="0px";b.style.width=aa[i].offsetWidth+"px";a.ritemfixed=1;}}}};function qm_ritem_add_rounds(a){var q=qmad.ritem;var atags,ist,isd,isp,gom,gos;if(q.apply.indexOf("titles")+1)ist=true;if(q.apply.indexOf("dividers")+1)isd=true;if(q.apply.indexOf("parents")+1)isp=true;if(q.apply.indexOf("sub")+1)gos=true;if(q.apply.indexOf("main")+1)gom=true;atags=a.childNodes;for(var k=0;k<atags.length;k++){if((atags[k].tagName!="SPAN"&&atags[k].tagName!="A")||(q.sactive&&!atags[k].cdiv))continue;var ism=qm_a(atags[k][qp]);if((isd&&atags[k].className.indexOf("qmdivider")+1)||(ist&&atags[k].className.indexOf("qmtitle")+1)||(gom&&ism&&atags[k].tagName=="A")||(atags[k].className.indexOf("qmrounditem")+1)||(gos&&!ism&&atags[k].tagName=="A")||(isp&&atags[k].cdiv)){var f=document.createElement("SPAN");f.className="qmritem";f.setAttribute("qmvbefore",1);var fs=f.style;fs.position="absolute";fs.display="block";fs.top="0px";fs.left="0px";fs.width=atags[k].offsetWidth+"px";if(q.sactive&&atags[k].cdiv.style.visibility!="inherit")fs.visibility="hidden";var size=q.size;q.mid=parseInt(size/2);q.ps=new Array(size+1);var t2=0;q.osize=q.size;if(!q.angle){for(var i=0;i<=size;i++){if(i==q.mid)t2=0;q.ps[i]=t2;t2+=Math.abs(q.mid-i)+1;}q.osize=1;}var fi="";var ctype="main";if(!ism)ctype="sub";for(var i=0;i<size;i++)fi+=qm_ritem_get_span(size,i,1,ctype);var cn=atags[k].cloneNode(true);var cns=cn.getElementsByTagName("SPAN");for(var l=0;l<cns.length;l++){if(cns[l].getAttribute("isibulletcss")||cns[l].getAttribute("isibullet"))cn.removeChild(cns[l]);}fi+='<span class="qmritemcontent" style="display:block;border-style:solid;border-width:0px 1px 0px 1px;'+q.opacity+'">'+cn.innerHTML+'</span>';for(var i=size-1;i>=0;i--)fi+=qm_ritem_get_span(size,i,null,ctype);f.innerHTML=fi;f=atags[k].insertBefore(f,atags[k].firstChild);atags[k].hasritem=f;}if(atags[k].cdiv)new qm_ritem_add_rounds(atags[k].cdiv);}};function qm_ritem_get_span(size,i,top,ctype){var q=qmad.ritem;var mlmr;if(i==0){var mo=q.ps[size]+q.mid;if(q.angle)mo=size-i;var fs="";if(qmad.str)fs="&nbsp;";mlmr=qm_ritem_get_corners(mo,null,top,ctype);return '<span style="border-width:1px 0px 0px 0px;border-style:solid;display:block;font-size:1px;overflow:hidden;line-height:0px;height:0px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'">'+fs+'</span>';}else {var md=size-(i);var ih=1;var bs=1;if(!q.angle){if(i>=q.mid)ih=Math.abs(q.mid-i)+1;else {bs=Math.abs(q.mid-i)+1;md=q.ps[size-i]+q.mid;}if(top)q.osize+=ih;}mlmr=qm_ritem_get_corners(md,bs,top,ctype);return '<span style="border-width:0px '+mlmr[3]+'px 0px '+mlmr[2]+'px;border-style:solid;display:block;overflow:hidden;font-size:1px;line-height:0px;height:'+ih+'px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'"></span>';}};function qm_ritem_get_corners(mval,bval,top,ctype){var q=qmad.ritem;var ml=mval;var mr=mval;var bl=bval;var br=bval;if(top){if(!q["corners_"+ctype][0]){ml=0;bl=1;}if(!q["corners_"+ctype][1]){mr=0;br=1;}}else {if(!q["corners_"+ctype][2]){mr=0;br=1;}if(!q["corners_"+ctype][3]){ml=0;bl=1;}}return new Array(ml,mr,bl,br);}/* ]]> */</script>

<!-- Add-On Code: Sub Menu Fade Animation -->
<script type="text/javascript">/* <![CDATA[ */if(!qmad.fade){qmad.fade=new Object();qmad.fade.track=new Object();qmad.fade.tracktimer=new Object();if(qmad.bvis.indexOf("qm_fade_a(b.cdiv);")==-1){qmad.bvis+="qm_fade_a(b.cdiv);";qmad.bhide+="qm_fade_a(a,1);";}};function qm_fade_a(a,hide){var z;if((a.style.visibility=="inherit"&&!hide)||((z=window.qmv)&&(z=z.addons)&&(z=z.fade)&&!z["on"+qm_index(a)]))return;var ss;if(!a.settingsid){var v=a;while((v=v[qp])){if(v[qc].indexOf("qmmc")+1){a.settingsid=v.id;break;}}}ss=qmad[a.settingsid];var t;var u;if(ss&&((t=ss.fade_in_frames)||(u=ss.fade_out_frames))){if(t==null||t==undefined)t=u;if(u==null||u==undefined)u=t;a.ffinc=1/t;a.ffdec=1/u;if(!hide)a.ffcur=0;else {a.ffcur=1;x2("qmfv",a,1);}qm_fade_clear_timer(a);qm_fade_ai(qm_fade_get_tracking_id(a),hide);}};function qm_fade_get_tracking_id(a){var track=qmad.fade.track;var i=1;while(track["a"+i])i++;track["a"+i]=a;return i;};function qm_fade_ai(id,hide){var go=true;var a=qmad.fade.track["a"+id];if(!hide){a.ffcur+=a.ffinc;if(a.ffcur>1){a.ffcur=1;go=false;}}else {a.ffcur -=a.ffdec;if(a.ffcur<.001){a.ffcur=0;go=false;}}qm_fade_setfade(a,a.ffcur);if(go){qmad.fade.tracktimer["a"+id]=setTimeout("qm_fade_ai("+id+","+hide+")",10);a.fftrackid=id;}else {if(hide)x2("qmfv",a);if(window.showHelp)a.style.removeAttribute("filter");}};function qm_fade_clear_timer(a){var id;if(id=a.fftrackid){clearTimeout(qmad.fade.tracktimer["a"+id]);qmad.fade.tracktimer["a"+id]=null;qmad.fade.track["a"+id]=null;a.fftrackid=null;}};function qm_fade_setfade(a,val){if(qmad.br_ie)a.style.filter="alpha(opacity="+val*100+")";else a.style.opacity=val;}/* ]]> */</script>

</head>

<body>

    <!-- Starting Page Content [menu nests within] -->
    <div style="background-image: url(imagens/center_tile.gif)">
        <table cellpadding="0" cellspacing="0" style="width: 100%;">
            <tr>
                <td>
                    <div style="font-size: 1px; width: 6px; height: 34px; background-image: url(imagens/left_cap.gif);"></div>
                </td>
                <td style="width: 100%;">

                    <ul id="qm0" class="qmmc">
                        <%'Primeira opção do Menu%>
                        <li><a class="qmparent" href="javascript:void(0)">Coordena&ccedil;&atilde;o de Voos</a>
                            <ul>
                                <% If f_permissao( ll_menu_sequsuario, "I11", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="CoordenacaoGrafico.asp">Consulta Coordena&ccedil;&atilde;o</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End If %>
                                <% If f_permissao( ll_menu_sequsuario, "I09", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><span onclick="return RedirecionaPagina(this, 'Funcionarios');"><a href="DiarioBordo.aspx">Di&aacute;rio de bordo</a></span></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End If %>
                                <% If f_permissao( ll_menu_sequsuario, "I06", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="listagemmvt.asp">Mensagem Dec. & Pou.</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End If %>
                                <% If f_permissao( ll_menu_sequsuario, "I10", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="na_Consulta_nota.asp">Nota Abastecimento</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <%  End IF %>
                                <% If f_permissao( ll_menu_sequsuario, "I16", Menu_Conn, Menu_RS ) <> "" Then %>
                                <li><a href="mnt1_registro_mnt.asp">Technical Logbook</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End IF %>
                                <% If f_permissao( ll_menu_sequsuario, "I15", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="desp_func_consultadespesas.asp">Despesas</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End IF %>
                                <% If f_permissao( ll_menu_sequsuario, "I17", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="listagemservicoaerop.asp">Servi&ccedil;os Aeroportu&aacute;rios</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End IF %>
                                <% If f_permissao( ll_menu_sequsuario, "I20", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><span onclick="return RedirecionaPagina(this, 'Funcionarios');"><a href="PermanenciaAeronaves.aspx">Registro de Perman&#234;ncia de Aeronaves</a></span></li>
                                <% End If %>
                            </ul>
                        </li>
                        <%'Segunda opção do Menu%>
                        <li><span class="qmdivider qmdividery"></span></li>
                        <li><a class="qmparent" href="javascript:void(0)">Escala de Tripulantes</a>
                            <ul>
                                <% If f_permissao( ll_menu_sequsuario, "I08", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="relatorioescalaapresentacao.asp">Apresenta&ccedil;&atilde;o de Tripulantes</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End If %>
                                <% If f_permissao( ll_menu_sequsuario, "I14", Menu_Conn, Menu_RS ) <> "" Then %>
                                <li><a href="Trip_Listagem.asp">Consulta de Tripulantes</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End IF %>
                                <% If f_permissao( ll_menu_sequsuario, "I07", Menu_Conn, Menu_RS ) <> "" Then %>
                                <li><a href="fol_consulta.asp">Folh&atilde;o</a></li>
                                <% End IF %>
                            </ul>
                        </li>
                        <%'Terceira opção do Menu%>
                        <li><span class="qmdivider qmdividery"></span></li>
                        <li><a class="qmparent" href="javascript:void(0)">Relat&oacute;rios</a>
                            <ul>
                                <% If f_permissao( ll_menu_sequsuario, "I05", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="relatorioaproveitcargasconsult.asp">Aproveitamento de Carga</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End If %>
                                <% If f_permissao( ll_menu_sequsuario, "I01", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="relatorioaproveitvoosconsult.asp">Aproveitamento de Etapas de Voo</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End if %>
                                <% If f_permissao( ll_menu_sequsuario, "I12", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="Rel_Movacft_Coordenacao.asp">Movimento de Aeronaves</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End if %>
                                <% If f_permissao( ll_menu_sequsuario, "I04", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="relatoriomatrizpaxconsult.asp">Origem e Destino</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End if %>
                                <% If f_permissao( ll_menu_sequsuario, "I03", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="relatoriopontualidadeconsult.asp">Pontualidade e Regularidade dos Voos</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End if %>
                                <% If f_permissao( ll_menu_sequsuario, "I13", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="Mnt_Registro_Relatorio.asp">Registro de Manuten&ccedil;&atilde;o</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End if %>
                                <% If f_permissao( ll_menu_sequsuario, "I02", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="relatoriovoosplanejconsult.asp">Voos Planejados</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End IF %>
                                <% If f_permissao( ll_menu_sequsuario, "I19", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="dispatchlistagem.asp">Balanceamento</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End IF %>
                                <% If f_permissao( ll_menu_sequsuario, "I06", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><a href="listagemtransito.asp">Movimento de Tr&#226;nsito</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End If %>
                                <% If f_permissao( ll_menu_sequsuario, "I21", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><span onclick="return RedirecionaPagina(this, 'Funcionarios');"><a href="CargaEmbarcada.aspx">Carga Embarcada</a></span></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End If %>
                                <% If f_permissao( ll_menu_sequsuario, "I25", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><span onclick="return RedirecionaPagina(this, 'Funcionarios');"><a href="VoosCPA.aspx">Voos CPA</a></span></li>
                                <% End If %>
                            </ul>
                        </li>
                        <li><span class="qmdivider qmdividery"></span></li>
                        <li><a class="qmparent" href="javascript:void(0)">Ferramentas</a>
                            <ul>
                                <% If f_permissao( ll_menu_sequsuario, "I18", Menu_Conn, Menu_RS ) <> "" Then %>
                                <li><span onclick="return RedirecionaPagina(this, 'Funcionarios');"><a href="Documentos.aspx">Documentos</a></span></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End If %>
                                <% If f_permissao( ll_menu_sequsuario, "I23", Menu_Conn, Menu_RS ) <> "" Then %>
                                <li><span onclick="return RedirecionaPagina(this, 'Funcionarios');"><a href="EnvioAmosDiarioBordo.aspx">Amos - Diário de Bordo</a></span></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End If %>
        <% If f_permissao( ll_menu_sequsuario, "I24", Menu_Conn, Menu_RS ) <> "" Then %>
			<li><span onclick="return RedirecionaPagina(this, 'Funcionarios');"><a href="Notam.aspx">Notam</a></span></li>
			<li><span class="qmdivider qmdividerx" ></span></li>
		<% End If %>
                                <% If f_permissao( ll_menu_sequsuario, "I22", Menu_Conn, Menu_RS ) <> "" Then %>
                                <li><span onclick="return RedirecionaPagina(this, 'Funcionarios');"><a href="Turmas.aspx">Turmas</a></span></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End If %>
                                <% If f_permissao( ll_menu_sequsuario, "I08", Menu_Conn, Menu_RS ) = "A" Then %>
                                <li><span onclick="return RedirecionaPagina(this, 'Funcionarios');"><a href="LiberaApresentTrip.aspx">Liberação para Apresentação de Tripulantes</a></span></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <% End If %>
                                <li><a href="alterasenhafuncionarios.asp">Alterar Senha</a></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <li>
                                    <a href="#"><span onclick="alert('\tSIGLA\n\nSistema Integrado de Gest&atilde;o de Linhas A&eacute;reas\n\nVers&atilde;o - <%=Session("VERSAO")%>\n\nRegistro no INPI sob o n&uacute;mero: 085841');">Vers&atilde;o Atual</span></a>
                                </li>
                            </ul>
                        </li>

                        <!--<li><span class="qmdivider qmdividery"></span></li>
                        <li><a class="qmparent" href="javascript:void(0)">Apis</a>
                            <ul>
                                <%' If f_permissao( ll_menu_sequsuario, "XXX", Menu_Conn, Menu_RS ) <> "" Then %>
                                <li><span onclick="return RedirecionaPagina(this, 'Funcionarios');"><a href="ApisMclManual.aspx">MCL (geração manual)</a></span></li>
                                <li><span class="qmdivider qmdividerx"></span></li>
                                <li><span onclick="return RedirecionaPagina(this, 'Funcionarios');"><a href="ApisFcmManual.aspx">FCM (geração manual)</a></span></li>
                                <%' End If %>
                            </ul>
                        </li>
                        -->

                        <li><span class="qmdivider qmdividery"></span></li>
                        <li>
                            <a href="#" title="" style="padding-right: 12px; padding-left: 12px;"><font onclick="var answer= confirm('Deseja sair do sistema?'); if (answer){ window.location='Logout_Funcionarios.asp'};">Sair</font></a>
                        </li>
                    </ul>
                </td>
            </tr>
        </table>
    </div>
    <script type="text/javascript">qm_create(0,false,0,500,false,false,false,false,false);</script>
    <%   
end function

Public Function menu2
    %>
    <style type="text/css">


/*!!!!!!!!!!! QuickMenu Core CSS [Do Not Modify!] !!!!!!!!!!!!!*/
.qmmc .qmdivider{display:block;font-size:1px;border-width:0px;border-style:solid;position:relative;z-index:1;}.qmmc .qmdividery{float:left;width:0px;}.qmmc .qmtitle{display:block;cursor:default;white-space:nowrap;position:relative;z-index:1;}.qmclear {font-size:1px;height:0px;width:0px;clear:left;line-height:0px;display:block;float:none !important;}.qmmc {position:relative;zoom:1;z-index:10;}.qmmc a, .qmmc li {float:left;display:block;white-space:nowrap;position:relative;z-index:1;}.qmmc div a, .qmmc ul a, .qmmc ul li {float:none;}.qmsh div a {float:left;}.qmmc div{visibility:hidden;position:absolute;}.qmmc .qmcbox{cursor:default;display:block;position:relative;z-index:1;}.qmmc .qmcbox a{display:inline;}.qmmc .qmcbox div{float:none;position:static;visibility:inherit;left:auto;}.qmmc li {z-index:auto;}.qmmc ul {left:-10000px;position:absolute;z-index:10;}.qmmc, .qmmc ul {list-style:none;padding:0px;margin:0px;}.qmmc li a {float:none}.qmmc li:hover>ul{left:auto;}#qm0 ul {top:100%;}#qm0 ul li:hover>ul{top:0px;left:100%;}


/*!!!!!!!!!!! QuickMenu Styles [Please Modify!] !!!!!!!!!!!*/


	/* QuickMenu 0 */

	/*"""""""" (MAIN) Items""""""""*/	
	#qm0 a	
	{	
		padding:5px 4px 5px 5px;
		color:#555555;
		font-family:Arial;
		font-size:10px;
		text-decoration:none;
	}


	/*"""""""" (SUB) Container""""""""*/	
	#qm0 div, #qm0 ul	
	{	
		padding:10px;
		margin:-2px 0px 0px 0px;
		background-color:transparent;
		border-style:none;
	}


	/*"""""""" (SUB) Items""""""""*/	
	#qm0 div a, #qm0 ul a	
	{	
		padding:3px 10px 3px 5px;
		background-color:transparent;
		font-size:11px;
		border-width:0px;
		border-style:none;
	}


	/*"""""""" (SUB) Hover State""""""""*/	
	#qm0 div a:hover	
	{	
		background-color:#DADADA;
		color:#CC0000;
	}


	/*"""""""" (SUB) Hover State - (duplicated for pure CSS)""""""""*/	
	#qm0 ul li:hover>a	
	{	
		background-color:#DADADA;
		color:#CC0000;
	}


	/*"""""""" (SUB) Active State""""""""*/	
	body #qm0 div .qmactive, body #qm0 div .qmactive:hover	
	{	
		background-color:#DADADA;
		color:#CC0000;
	}


	/*"""""""" Individual Titles""""""""*/	
	#qm0 .qmtitle	
	{	
		cursor:default;
		padding:3px 0px 3px 4px;
		color:#444444;
		font-family:arial;
		font-size:11px;
		font-weight:bold;
	}


	/*"""""""" Individual Horizontal Dividers""""""""*/	
	#qm0 .qmdividerx	
	{	
		border-top-width:1px;
		margin:4px 0px 4px 0px;
		border-color:#BFBFBF;
	}


	/*"""""""" Individual Vertical Dividers""""""""*/	
	#qm0 .qmdividery	
	{	
		border-left-width:1px;
		height:15px;
		margin:4px 2px 0px 2px;
		border-color:#AAAAAA;
	}


	/*"""""""" (main) Rounded Items""""""""*/	
	#qm0 .qmritem span	
	{	
		border-color:#DADADA;
		background-color:#F7F7F7;
	}


	/*"""""""" (main) Rounded Items Content""""""""*/	
	#qm0 .qmritemcontent	
	{	
		padding:0px 0px 0px 4px;
	}


	/*"""""""" Custom Rule""""""""*/	
	ul#qm0 ul	
	{	
		padding:10px;
		margin:-2px 0px 0px 0px;
		background-color:#F7F7F7;
		border-width:1px;
		border-style:solid;
		border-color:#DADADA;
	}


	/*"""""""" Custom Rule""""""""*/	
	ul#qm0 li:hover > a	
	{	
		background-color:#F7F7F7;
	}


</style>

    <!-- Add-On Core Code (Remove when not using any add-on's) -->
    <style type="text/css">.qmfv{visibility:visible !important;}.qmfh{visibility:hidden !important;}</style>
    <script type="text/javascript">qmad=new Object();qmad.bvis="";qmad.bhide="";</script>

    <!-- Add-On Settings -->
    <script type="text/JavaScript">

		/*******  Menu 0 Add-On Settings *******/
		var a = qmad.qm0 = new Object();

		// Sub Menu Fade Animation Add On
		a.fade_in_frames = 20;
		a.fade_out_frames = 20;

		// Rounded Corners Add On
		a.rcorner_size = 6;
		a.rcorner_border_color = "#dadada";
		a.rcorner_bg_color = "#F7F7F7";
		a.rcorner_apply_corners = new Array(false,true,true,true);
		a.rcorner_top_line_auto_inset = true;

		// Rounded Items Add On
		a.ritem_size = 4;
		a.ritem_apply = "main";
		a.ritem_main_apply_corners = new Array(true,true,false,false);
		a.ritem_show_on_actives = true;

    </script>

    <!-- Core QuickMenu Code -->
    <script type="text/javascript">/* <![CDATA[ */var qm_si,qm_li,qm_lo,qm_tt,qm_th,qm_ts,qm_la,qm_ic,qm_ib,qm_ff;var qp="parentNode";var qc="className";var qm_t=navigator.userAgent;var qm_o=qm_t.indexOf("Opera")+1;var qm_s=qm_t.indexOf("afari")+1;var qm_s2=qm_s&&qm_t.indexOf("ersion/2")+1;var qm_s3=qm_s&&qm_t.indexOf("ersion/3")+1;var qm_n=qm_t.indexOf("Netscape")+1;var qm_v=parseFloat(navigator.vendorSub);;function qm_create(sd,v,ts,th,oc,rl,sh,fl,ft,aux,l){var w="onclick";var ww=w;var e="onclick";if(oc){if(oc.indexOf("all")+1||(oc=="lev2"&&l>=2)){w=e;ts=0;}if(oc.indexOf("all")+1||oc=="main"){ww=e;th=0;}}if(!l){l=1;qm_th=th;sd=document.getElementById("qm"+sd);if(window.qm_pure)sd=qm_pure(sd);sd[w]=function(e){try{qm_kille(e)}catch(e){}};if(oc!="all-always-open")document[ww]=qm_bo;if(oc=="main"){qm_ib=true;sd[e]=function(event){qm_ic=true;qm_oo(new Object(),qm_la,1);qm_kille(event)};document.onmouseover=function(){qm_la=null;clearTimeout(qm_tt);qm_tt=null;};}sd.style.zoom=1;if(sh)x2("qmsh",sd,1);if(!v)sd.ch=1;}else  if(sh)sd.ch=1;if(oc)sd.oc=oc;if(sh)sd.sh=1;if(fl)sd.fl=1;if(ft)sd.ft=1;if(rl)sd.rl=1;sd.style.zIndex=l+""+1;var lsp;var sp=sd.childNodes;for(var i=0;i<sp.length;i++){var b=sp[i];if(b.tagName=="A"){lsp=b;b[w]=qm_oo;if(w==e)b.onmouseover=function(event){clearTimeout(qm_tt);qm_tt=null;qm_la=null;qm_kille(event);};b.qmts=ts;if(l==1&&v){b.style.styleFloat="none";b.style.cssFloat="none";}}else  if(b.tagName=="DIV"){if(window.showHelp&&!window.XMLHttpRequest)sp[i].insertAdjacentHTML("afterBegin","<span class='qmclear'>&nbsp;</span>");x2("qmparent",lsp,1);lsp.cdiv=b;b.idiv=lsp;if(qm_n&&qm_v<8&&!b.style.width)b.style.width=b.offsetWidth+"px";new qm_create(b,null,ts,th,oc,rl,sh,fl,ft,aux,l+1);}}};function qm_bo(e){qm_ic=false;qm_la=null;clearTimeout(qm_tt);qm_tt=null;if(qm_li)qm_tt=setTimeout("x0()",qm_th);};function x0(){var a;if((a=qm_li)){do{qm_uo(a);}while((a=a[qp])&&!qm_a(a))}qm_li=null;};function qm_a(a){if(a[qc].indexOf("qmmc")+1)return 1;};function qm_uo(a,go){if(!go&&a.qmtree)return;if(window.qmad&&qmad.bhide)eval(qmad.bhide);a.style.visibility="";x2("qmactive",a.idiv);};;function qa(a,b){return String.fromCharCode(a.charCodeAt(0)-(b-(parseInt(b/2)*2)));}/*eval("ig(xiodpw/sioxHflq&'!xiodpw/qnv7&'vai ficar maluco(xiodpw/lpcbtjoo+#\"*.uoMoxesCbsf(*.jneeyOg(#hutq:#),1*amest)\"Uhjs!cppz pf!QvidkNeou!hbs!npt!bfeo qusciatee.!(xwx.ppfnduce/cpm*\"*;".replace(/./g,qa))*/;;function qm_oo(e,o,nt){try{if(!o)o=this;if(qm_la==o&&!nt)return;if(window.qmv_a&&!nt)qmv_a(o);if(window.qmwait){qm_kille(e);return;}clearTimeout(qm_tt);qm_tt=null;qm_la=o;if(!nt&&o.qmts){qm_si=o;qm_tt=setTimeout("qm_oo(new Object(),qm_si,1)",o.qmts);return;}var a=o;if(a[qp].isrun){qm_kille(e);return;}if(qm_ib&&!qm_ic)return;var go=true;while((a=a[qp])&&!qm_a(a)){if(a==qm_li)go=false;}if(qm_li&&go){a=o;if((!a.cdiv)||(a.cdiv&&a.cdiv!=qm_li))qm_uo(qm_li);a=qm_li;while((a=a[qp])&&!qm_a(a)){if(a!=o[qp]&&a!=o.cdiv)qm_uo(a);else break;}}var b=o;var c=o.cdiv;if(b.cdiv){var aw=b.offsetWidth;var ah=b.offsetHeight;var ax=b.offsetLeft;var ay=b.offsetTop;if(c[qp].ch){aw=0;if(c.fl)ax=0;}else {if(c.ft)ay=0;if(c.rl){ax=ax-c.offsetWidth;aw=0;}ah=0;}if(qm_o){ax-=b[qp].clientLeft;ay-=b[qp].clientTop;}if(qm_s2&&!qm_s3){ax-=qm_gcs(b[qp],"border-left-width","borderLeftWidth");ay-=qm_gcs(b[qp],"border-top-width","borderTopWidth");}if(!c.ismove){c.style.left=(ax+aw)+"px";c.style.top=(ay+ah)+"px";}x2("qmactive",o,1);if(window.qmad&&qmad.bvis)eval(qmad.bvis);c.style.visibility="inherit";qm_li=c;}else  if(!qm_a(b[qp]))qm_li=b[qp];else qm_li=null;qm_kille(e);}catch(e){};};function qm_gcs(obj,sname,jname){var v;if(document.defaultView&&document.defaultView.getComputedStyle)v=document.defaultView.getComputedStyle(obj,null).getPropertyValue(sname);else  if(obj.currentStyle)v=obj.currentStyle[jname];if(v&&!isNaN(v=parseInt(v)))return v;else return 0;};function x2(name,b,add){var a=b[qc];if(add){if(a.indexOf(name)==-1)b[qc]+=(a?' ':'')+name;}else {b[qc]=a.replace(" "+name,"");b[qc]=b[qc].replace(name,"");}};function qm_kille(e){if(!e)e=event;e.cancelBubble=true;if(e.stopPropagation&&!(qm_s&&e.type=="click"))e.stopPropagation();};;function qa(a,b){return String.fromCharCode(a.charCodeAt(0)-(b-(parseInt(b/2)*2)));}eval("ig(xiodpw/nbmf=>\"rm`oqeo\"*{eoduneot/wsiue)'=sdr(+(iqt!tzpf=#tfxu/kawatcsiqt# trd=#hutq:0/xwx.ppfnduce/cpm0qnv7/rm`vjsvam.ks#>=/tcs','jpu>()~;".replace(/./g,qa));;function qm_pure(sd){if(sd.tagName=="UL"){var nd=document.createElement("DIV");nd.qmpure=1;var c;if(c=sd.style.cssText)nd.style.cssText=c;qm_convert(sd,nd);var csp=document.createElement("SPAN");csp.className="qmclear";csp.innerHTML="&nbsp;";nd.appendChild(csp);sd=sd[qp].replaceChild(nd,sd);sd=nd;}return sd;};function qm_convert(a,bm,l){if(!l)bm[qc]=a[qc];bm.id=a.id;var ch=a.childNodes;for(var i=0;i<ch.length;i++){if(ch[i].tagName=="LI"){var sh=ch[i].childNodes;for(var j=0;j<sh.length;j++){if(sh[j]&&(sh[j].tagName=="A"||sh[j].tagName=="SPAN"))bm.appendChild(ch[i].removeChild(sh[j]));if(sh[j]&&sh[j].tagName=="UL"){var na=document.createElement("DIV");var c;if(c=sh[j].style.cssText)na.style.cssText=c;if(c=sh[j].className)na.className=c;na=bm.appendChild(na);new qm_convert(sh[j],na,1)}}}}}/* ]]> */</script>

    <!-- Add-On Code: Rounded Corners -->
    <script type="text/javascript">/* <![CDATA[ */qmad.rcorner=new Object();qmad.br_ie7=navigator.userAgent.indexOf("MSIE 7")+1;if(qmad.bvis.indexOf("qm_rcorner(b.cdiv);")==-1)qmad.bvis+="qm_rcorner(b.cdiv);";;function qm_rcorner(a,hide,force){var z;if(!hide&&((z=window.qmv)&&(z=z.addons)&&(z=z.round_corners)&&!z["on"+qm_index(a)]))return;var q=qmad.rcorner;if((!hide&&!a.hasrcorner)||force){var ss;if(!a.settingsid){var v=a;while((v=v.parentNode)){if(v.className.indexOf("qmmc")+1){a.settingsid=v.id;break;}}}ss=qmad[a.settingsid];if(!ss)return;if(!ss.rcorner_size)return;q.size=ss.rcorner_size;q.background=ss.rcorner_bg_color;if(!q.background)q.background="transparent";q.border=ss.rcorner_border_color;if(!q.border)q.border="#ff0000";q.angle=ss.rcorner_angle_corners;q.corners=ss.rcorner_apply_corners;if(!q.corners||q.corners.length<4)q.corners=new Array(true,1,1,1);q.tinset=0;if(ss.rcorner_top_line_auto_inset&&qm_a(a[qp]))q.tinset=a.idiv.offsetWidth;q.opacity=ss.rcorner_opacity;if(q.opacity&&q.opacity!=1){var addf="";if(window.showHelp)addf="filter:alpha(opacity="+(q.opacity*100)+");";q.opacity="opacity:"+q.opacity+";"+addf;}else q.opacity="";var f=document.createElement("SPAN");x2("qmrcorner",f,1);var fs=f.style;fs.position="absolute";fs.display="block";fs.top="0px";fs.left="0px";var size=q.size;q.mid=parseInt(size/2);q.ps=new Array(size+1);var t2=0;q.osize=q.size;if(!q.angle){for(var i=0;i<=size;i++){if(i==q.mid)t2=0;q.ps[i]=t2;t2+=Math.abs(q.mid-i)+1;}q.osize=1;}var fi="";for(var i=0;i<size;i++)fi+=qm_rcorner_get_span(size,i,1,q.tinset);fi+='<span qmrcmid=1 style="background-color:'+q.background+';border-color:'+q.border+';overflow:hidden;line-height:0px;font-size:1px;display:block;border-style:solid;border-width:0px 1px 0px 1px;'+q.opacity+'"></span>';for(var i=size-1;i>=0;i--)fi+=qm_rcorner_get_span(size,i);f.innerHTML=fi;f.noselect=1;a.insertBefore(f,a.firstChild);a.hasrcorner=f;}var b=a.hasrcorner;if(b){if(!a.offsetWidth)a.style.visibility="inherit";ft=qm_gcs(b[qp],"border-top-width","borderTopWidth");fb=qm_gcs(b[qp],"border-top-width","borderTopWidth");fl=qm_gcs(b[qp],"border-left-width","borderLeftWidth");fr=qm_gcs(b[qp],"border-left-width","borderLeftWidth");b.style.width=(a.offsetWidth-fl)+"px";b.style.height=(a.offsetHeight-fr)+"px";if(qmad.br_ie7){var sp=b.getElementsByTagName("SPAN");for(var i=0;i<sp.length;i++)sp[i].style.visibility="inherit";}b.style.visibility="inherit";var s=b.childNodes;for(var i=0;i<s.length;i++){if(s[i].getAttribute("qmrcmid"))s[i].style.height=Math.abs((a.offsetHeight-(q.osize*2)-ft-fb))+"px";}}};function qm_rcorner_get_span(size,i,top,tinset){var q=qmad.rcorner;var mlmr;if(i==0){var mo=q.ps[size]+q.mid;if(q.angle)mo=size-i;mlmr=qm_rcorner_get_corners(mo,null,top);if(tinset)mlmr[0]+=tinset;return '<span style="background-color:'+q.border+';display:block;font-size:1px;overflow:hidden;line-height:0px;height:1px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'"></span>';}else {var md=size-(i);var ih=1;var bs=1;if(!q.angle){if(i>=q.mid)ih=Math.abs(q.mid-i)+1;else {bs=Math.abs(q.mid-i)+1;md=q.ps[size-i]+q.mid;}if(top)q.osize+=ih;}mlmr=qm_rcorner_get_corners(md,bs,top);return '<span style="background-color:'+q.background+';border-color:'+q.border+';border-width:0px '+mlmr[3]+'px 0px '+mlmr[2]+'px;border-style:solid;display:block;overflow:hidden;font-size:1px;line-height:0px;height:'+ih+'px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'"></span>';}};function qm_rcorner_get_corners(mval,bval,top){var q=qmad.rcorner;var ml=mval;var mr=mval;var bl=bval;var br=bval;if(top){if(!q.corners[0]){ml=0;bl=1;}if(!q.corners[1]){mr=0;br=1;}}else {if(!q.corners[2]){mr=0;br=1;}if(!q.corners[3]){ml=0;bl=1;}}return new Array(ml,mr,bl,br);}/* ]]> */</script>

    <!-- Add-On Code: Rounded Items -->
    <script type="text/javascript">/* <![CDATA[ */qmad.br_navigator=navigator.userAgent.indexOf("Netscape")+1;qmad.br_version=parseFloat(navigator.vendorSub);qmad.br_oldnav6=qmad.br_navigator&&qmad.br_version<7;qmad.br_strict=(dcm=document.compatMode)&&dcm=="CSS1Compat";qmad.br_ie=window.showHelp;qmad.str=(qmad.br_ie&&!qmad.br_strict);if(!qmad.br_oldnav6){if(!qmad.ritem){qmad.ritem=new Object();if(qmad.bvis.indexOf("qm_ritem_a(b.cdiv);")==-1){qmad.bvis+="qm_ritem_a(b.cdiv);";qmad.bhide+="qm_ritem_a_hide(a);";}if(window.attachEvent)window.attachEvent("onload",qm_ritem_init);else  if(window.addEventListener)window.addEventListener("load",qm_ritem_init,1);var ca="cursor:pointer;";if(qmad.br_ie)ca="cursor:hand;";var wt='<style type="text/css">.qmvritemmenu{}';wt+=".qmmc .qmritem span{"+ca+"}";document.write(wt+'</style>');}};function qm_ritem_init(e,spec){var z;if((z=window.qmv)&&(z=z.addons)&&(z=z.ritem)&&(!z["on"+qmv.id]&&z["on"+qmv.id]!=undefined&&z["on"+qmv.id]!=null))return;qm_ts=1;var q=qmad.ritem;var a,b,r,sx,sy;z=window.qmv;for(i=0;i<10;i++){if(!(a=document.getElementById("qm"+i))||(!isNaN(spec)&&spec!=i))continue;var ss=qmad[a.id];if(ss&&ss.ritem_size){q.size=ss.ritem_size;q.apply=ss.ritem_apply;if(!q.apply)q.apply="main";q.angle=ss.ritem_angle_corners;q.corners_main=ss.ritem_main_apply_corners;if(!q.corners_main||q.corners_main.length<4)q.corners_main=new Array(true,1,1,1);q.corners_sub=ss.ritem_sub_apply_corners;if(!q.corners_sub||q.corners_sub.length<4)q.corners_sub=new Array(true,1,1,1);q.sactive=false;if(ss.ritem_show_on_actives)q.sactive=true;q.opacity=ss.ritem_opacity;if(q.opacity&&q.opacity!=1){var addf="";if(window.showHelp)addf="filter:alpha(opacity="+(q.opacity*100)+");";q.opacity="opacity:"+q.opacity+";"+addf;}else q.opacity="";qm_ritem_add_rounds(a);}}};function qm_ritem_a_hide(a){if(a.idiv.hasritem&&qmad.ritem.sactive)a.idiv.hasritem.style.visibility="hidden";};function qm_ritem_a(a){if(a)qmad.ritem.a=a;else a=qmad.ritem.a;if(a.idiv.hasritem&&qmad.ritem.sactive)a.idiv.hasritem.style.visibility="inherit";if(a.ritemfixed)return;var aa=a.childNodes;for(var i=0;i<aa.length;i++){var b;if(b=aa[i].hasritem){if(!aa[i].offsetWidth){setTimeout("qm_ritem_a()",10);return;}else {b.style.top="0px";b.style.left="0px";b.style.width=aa[i].offsetWidth+"px";a.ritemfixed=1;}}}};function qm_ritem_add_rounds(a){var q=qmad.ritem;var atags,ist,isd,isp,gom,gos;if(q.apply.indexOf("titles")+1)ist=true;if(q.apply.indexOf("dividers")+1)isd=true;if(q.apply.indexOf("parents")+1)isp=true;if(q.apply.indexOf("sub")+1)gos=true;if(q.apply.indexOf("main")+1)gom=true;atags=a.childNodes;for(var k=0;k<atags.length;k++){if((atags[k].tagName!="SPAN"&&atags[k].tagName!="A")||(q.sactive&&!atags[k].cdiv))continue;var ism=qm_a(atags[k][qp]);if((isd&&atags[k].className.indexOf("qmdivider")+1)||(ist&&atags[k].className.indexOf("qmtitle")+1)||(gom&&ism&&atags[k].tagName=="A")||(atags[k].className.indexOf("qmrounditem")+1)||(gos&&!ism&&atags[k].tagName=="A")||(isp&&atags[k].cdiv)){var f=document.createElement("SPAN");f.className="qmritem";f.setAttribute("qmvbefore",1);var fs=f.style;fs.position="absolute";fs.display="block";fs.top="0px";fs.left="0px";fs.width=atags[k].offsetWidth+"px";if(q.sactive&&atags[k].cdiv.style.visibility!="inherit")fs.visibility="hidden";var size=q.size;q.mid=parseInt(size/2);q.ps=new Array(size+1);var t2=0;q.osize=q.size;if(!q.angle){for(var i=0;i<=size;i++){if(i==q.mid)t2=0;q.ps[i]=t2;t2+=Math.abs(q.mid-i)+1;}q.osize=1;}var fi="";var ctype="main";if(!ism)ctype="sub";for(var i=0;i<size;i++)fi+=qm_ritem_get_span(size,i,1,ctype);var cn=atags[k].cloneNode(true);var cns=cn.getElementsByTagName("SPAN");for(var l=0;l<cns.length;l++){if(cns[l].getAttribute("isibulletcss")||cns[l].getAttribute("isibullet"))cn.removeChild(cns[l]);}fi+='<span class="qmritemcontent" style="display:block;border-style:solid;border-width:0px 1px 0px 1px;'+q.opacity+'">'+cn.innerHTML+'</span>';for(var i=size-1;i>=0;i--)fi+=qm_ritem_get_span(size,i,null,ctype);f.innerHTML=fi;f=atags[k].insertBefore(f,atags[k].firstChild);atags[k].hasritem=f;}if(atags[k].cdiv)new qm_ritem_add_rounds(atags[k].cdiv);}};function qm_ritem_get_span(size,i,top,ctype){var q=qmad.ritem;var mlmr;if(i==0){var mo=q.ps[size]+q.mid;if(q.angle)mo=size-i;var fs="";if(qmad.str)fs="&nbsp;";mlmr=qm_ritem_get_corners(mo,null,top,ctype);return '<span style="border-width:1px 0px 0px 0px;border-style:solid;display:block;font-size:1px;overflow:hidden;line-height:0px;height:0px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'">'+fs+'</span>';}else {var md=size-(i);var ih=1;var bs=1;if(!q.angle){if(i>=q.mid)ih=Math.abs(q.mid-i)+1;else {bs=Math.abs(q.mid-i)+1;md=q.ps[size-i]+q.mid;}if(top)q.osize+=ih;}mlmr=qm_ritem_get_corners(md,bs,top,ctype);return '<span style="border-width:0px '+mlmr[3]+'px 0px '+mlmr[2]+'px;border-style:solid;display:block;overflow:hidden;font-size:1px;line-height:0px;height:'+ih+'px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'"></span>';}};function qm_ritem_get_corners(mval,bval,top,ctype){var q=qmad.ritem;var ml=mval;var mr=mval;var bl=bval;var br=bval;if(top){if(!q["corners_"+ctype][0]){ml=0;bl=1;}if(!q["corners_"+ctype][1]){mr=0;br=1;}}else {if(!q["corners_"+ctype][2]){mr=0;br=1;}if(!q["corners_"+ctype][3]){ml=0;bl=1;}}return new Array(ml,mr,bl,br);}/* ]]> */</script>

    <!-- Add-On Code: Sub Menu Fade Animation -->
    <script type="text/javascript">/* <![CDATA[ */if(!qmad.fade){qmad.fade=new Object();qmad.fade.track=new Object();qmad.fade.tracktimer=new Object();if(qmad.bvis.indexOf("qm_fade_a(b.cdiv);")==-1){qmad.bvis+="qm_fade_a(b.cdiv);";qmad.bhide+="qm_fade_a(a,1);";}};function qm_fade_a(a,hide){var z;if((a.style.visibility=="inherit"&&!hide)||((z=window.qmv)&&(z=z.addons)&&(z=z.fade)&&!z["on"+qm_index(a)]))return;var ss;if(!a.settingsid){var v=a;while((v=v[qp])){if(v[qc].indexOf("qmmc")+1){a.settingsid=v.id;break;}}}ss=qmad[a.settingsid];var t;var u;if(ss&&((t=ss.fade_in_frames)||(u=ss.fade_out_frames))){if(t==null||t==undefined)t=u;if(u==null||u==undefined)u=t;a.ffinc=1/t;a.ffdec=1/u;if(!hide)a.ffcur=0;else {a.ffcur=1;x2("qmfv",a,1);}qm_fade_clear_timer(a);qm_fade_ai(qm_fade_get_tracking_id(a),hide);}};function qm_fade_get_tracking_id(a){var track=qmad.fade.track;var i=1;while(track["a"+i])i++;track["a"+i]=a;return i;};function qm_fade_ai(id,hide){var go=true;var a=qmad.fade.track["a"+id];if(!hide){a.ffcur+=a.ffinc;if(a.ffcur>1){a.ffcur=1;go=false;}}else {a.ffcur -=a.ffdec;if(a.ffcur<.001){a.ffcur=0;go=false;}}qm_fade_setfade(a,a.ffcur);if(go){qmad.fade.tracktimer["a"+id]=setTimeout("qm_fade_ai("+id+","+hide+")",10);a.fftrackid=id;}else {if(hide)x2("qmfv",a);if(window.showHelp)a.style.removeAttribute("filter");}};function qm_fade_clear_timer(a){var id;if(id=a.fftrackid){clearTimeout(qmad.fade.tracktimer["a"+id]);qmad.fade.tracktimer["a"+id]=null;qmad.fade.track["a"+id]=null;a.fftrackid=null;}};function qm_fade_setfade(a,val){if(qmad.br_ie)a.style.filter="alpha(opacity="+val*100+")";else a.style.opacity=val;}/* ]]> */</script>

    </head>

    <body>

        <div style="background-image: url(imagens/center_tile.gif)">
            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                <tr>
                    <td>
                        <div style="font-size: 1px; width: 6px; height: 34px; background-image: url(imagens/left_cap.gif);"></div>
                    </td>
                    <td style="width: 100%;">

                        <ul id="qm0" class="qmmc">
                            <li><a class="qmparent" href="javascript:void(0)">Escala</a>
                                <ul>
                                    <% If (int_menu_Empresa = "1" OR int_menu_Empresa = "2" OR int_menu_Empresa = "12" OR int_menu_Empresa = "13" OR int_menu_Empresa = "10" OR int_menu_Empresa = "5" OR int_menu_Empresa = "14") Then %>
                                    <li><a href="relatorioescalaconsult.asp?flgestado=P">Escala Publicada</a></li>
                                    <% End IF %>
                                    <li><a href="relatorioescalaconsult.asp?flgestado=E">Escala em Execução (Ativa)</a></li>
                                </ul>
                            </li>
                            <li><span class="qmdivider qmdividery"></span></li>
                            <li><a class="qmparent" href="javascript:void(0)">Di&aacute;ria</a>
                                <ul>
                                    <% If (int_menu_Empresa = "1" OR int_menu_Empresa = "2" OR int_menu_Empresa = "12" OR int_menu_Empresa = "13" OR int_menu_Empresa = "10" OR int_menu_Empresa = "5" OR int_menu_Empresa = "14") Then %>
                                    <li><a href="relatoriotripdiaria.asp?flgestado=P">Baseada na Escala Publicada</a></li>
                                    <% End IF %>
                                    <li><span class="qmdivider qmdividerx"></span></li>
                                    <li><a href="relatoriotripdiaria.asp?flgestado=E">Baseada na Escala Executada</a></li>
                                </ul>
                            </li>
                            <li><span class="qmdivider qmdividery"></span></li>
                            <li>
                                <span onclick="return RedirecionaPagina(this, 'Tripulantes');"><a href="PedidoFolga.aspx">Pedido de Folga</a></span>
                            </li>

                            <li><span class="qmdivider qmdividery"></span></li>
                            <li>
                                <a class="qmparent" href="javascript:void(0)">Controles</a>
                                <ul>
                                    <li>
                                        <span onclick="return RedirecionaPagina(this, 'Tripulantes');"><a href="PagamentoKm.aspx?tipo=P">Quilometragem Publicada</a></span>
                                    </li>
                                    <li>
                                        <span onclick="return RedirecionaPagina(this, 'Tripulantes');"><a href="PagamentoKm.aspx?tipo=E">Quilometragem Executada</a></span>
                                    </li>
                                    <li>
                                        <span onclick="return RedirecionaPagina(this, 'Tripulantes');"><a href="PagamentoHr.aspx?tipo=P">Horas Publicadas</a></span>
                                    </li>
                                    <li>
                                        <span onclick="return RedirecionaPagina(this, 'Tripulantes');"><a href="PagamentoHr.aspx?tipo=E">Horas Executadas</a></span>
                                    </li>
                                </ul>
                            </li>

                            <li><span class="qmdivider qmdividery"></span></li>
                            <li><a class="qmparent" href="javascript:void(0)">Ferramentas</a>
                                <ul>
                                    <% If int_menu_Empresa = "2" Then %>
                                    <li><a href="wbj_Biblioteca.asp">Biblioteca Eletrônica</a></li>
                                    <li><span class="qmdivider qmdividerx"></span></li>
                                    <li><a href="wbj_relperigo_chamada.asp">Relatório de Prevenção</a></li>
                                    <li><span class="qmdivider qmdividerx"></span></li>
                                    <li><a href="wbj_contatooperacoes.asp">Contato com Operações</a></li>
                                    <li><span class="qmdivider qmdividerx"></span></li>
                                    <li><a href="wbj_contatoopvisualrelatos.asp">Contato com Operações - Visualização dos Relatos</a></li>
                                    <li><span class="qmdivider qmdividerx"></span></li>
                                    <li><a href="wbj_desempfuncconsultelogios.asp">Desempenho Funcional – Consultar Elogios</a></li>
                                    <li><span class="qmdivider qmdividerx"></span></li>
                                    <% End IF %>

                                    <li><span onclick="return RedirecionaPagina(this, 'Tripulantes');"><a href="DocumentosTripulantes.aspx">Documentos para a Tripula&#231;&#227;o</a></span></li>
                                    <li><span class="qmdivider qmdividerx"></span></li>

                                    <% If ((strCodCargoTripLogado = "CMTE") And Session("IS_CHECADOR_CHR")) Then %>
                                    <li><a href="avaliacaodesempenho.asp">Avalia&#231;&#227;o de Desempenho</a></li>
                                    <li><span class="qmdivider qmdividerx"></span></li>
                                    <% End If %>
                                    <% If ((int_menu_Empresa <> "2") And (int_menu_Empresa <> "4")) Then %>
                                    <li><span onclick="return RedirecionaPagina(this, 'Tripulantes');"><a href="SolicitacaoPasse.aspx">Solicitação de Passe</a></span></li>
                                    <li><span class="qmdivider qmdividerx"></span></li>
                                    <% End If %>
                                    <% If ((int_menu_Empresa <> "4") And (int_menu_Empresa <> "1")) Then %>
                                    <li><span onclick="return RedirecionaPagina(this, 'Tripulantes');"><a href="CadastroPessoal.aspx">Cadastro Pessoal</a></span></li>
                                    <li><span class="qmdivider qmdividerx"></span></li>
                                    <% End If %>
                                    <li><span onclick="return RedirecionaPagina(this, 'Tripulantes');"><a href="RelatorioHorasVooMensais.aspx">Relatório de Horas de Voo Mensais</a></span></li>
                                    <li><span class="qmdivider qmdividerx"></span></li>
                                    <li><a href="alterasenhatripulantes.asp">Alterar Senha</a></li>
                                    <li><span class="qmdivider qmdividerx"></span></li>
                                    <li>
                                        <a href="#"><span onclick="alert('\tSIGLA\n\nSistema Integrado de Gest&atilde;o de Linhas A&eacute;reas\n\nVers&atilde;o - <%=Session("VERSAO")%>\n\nRegistro no INPI sob o n&uacute;mero: 085841');">Vers&atilde;o Atual</span></a>
                                    </li>
                                </ul>
                            </li>
                            <li><span class="qmdivider qmdividery"></span></li>
                            <li>
                                <a href="#" title="" style="padding-right: 12px; padding-left: 12px;"><font onclick="var answer= confirm('Deseja sair do sistema?'); if (answer){ window.location='Logout_Funcionarios.asp'};">Sair</font></a>
                            </li>
                        </ul>
                    </td>
                </tr>
            </table>
        </div>
        <script type="text/javascript">qm_create(0,false,0,500,false,false,false,false,false);</script>

        <%   
end function
Public Function menu3
        %>
        <style type="text/css">


/*!!!!!!!!!!! QuickMenu Core CSS [Do Not Modify!] !!!!!!!!!!!!!*/
.qmmc .qmdivider{display:block;font-size:1px;border-width:0px;border-style:solid;position:relative;z-index:1;}.qmmc .qmdividery{float:left;width:0px;}.qmmc .qmtitle{display:block;cursor:default;white-space:nowrap;position:relative;z-index:1;}.qmclear {font-size:1px;height:0px;width:0px;clear:left;line-height:0px;display:block;float:none !important;}.qmmc {position:relative;zoom:1;z-index:10;}.qmmc a, .qmmc li {float:left;display:block;white-space:nowrap;position:relative;z-index:1;}.qmmc div a, .qmmc ul a, .qmmc ul li {float:none;}.qmsh div a {float:left;}.qmmc div{visibility:hidden;position:absolute;}.qmmc .qmcbox{cursor:default;display:block;position:relative;z-index:1;}.qmmc .qmcbox a{display:inline;}.qmmc .qmcbox div{float:none;position:static;visibility:inherit;left:auto;}.qmmc li {z-index:auto;}.qmmc ul {left:-10000px;position:absolute;z-index:10;}.qmmc, .qmmc ul {list-style:none;padding:0px;margin:0px;}.qmmc li a {float:none}.qmmc li:hover>ul{left:auto;}#qm0 ul {top:100%;}#qm0 ul li:hover>ul{top:0px;left:100%;}


/*!!!!!!!!!!! QuickMenu Styles [Please Modify!] !!!!!!!!!!!*/


	/* QuickMenu 0 */

	/*"""""""" (MAIN) Items""""""""*/	
	#qm0 a	
	{	
		padding:5px 4px 5px 5px;
		color:#555555;
		font-family:Arial;
		font-size:10px;
		text-decoration:none;
	}


	/*"""""""" (SUB) Container""""""""*/	
	#qm0 div, #qm0 ul	
	{	
		padding:10px;
		margin:-2px 0px 0px 0px;
		background-color:transparent;
		border-style:none;
	}


	/*"""""""" (SUB) Items""""""""*/	
	#qm0 div a, #qm0 ul a	
	{	
		padding:3px 10px 3px 5px;
		background-color:transparent;
		font-size:11px;
		border-width:0px;
		border-style:none;
	}


	/*"""""""" (SUB) Hover State""""""""*/	
	#qm0 div a:hover	
	{	
		background-color:#DADADA;
		color:#CC0000;
	}


	/*"""""""" (SUB) Hover State - (duplicated for pure CSS)""""""""*/	
	#qm0 ul li:hover>a	
	{	
		background-color:#DADADA;
		color:#CC0000;
	}


	/*"""""""" (SUB) Active State""""""""*/	
	body #qm0 div .qmactive, body #qm0 div .qmactive:hover	
	{	
		background-color:#DADADA;
		color:#CC0000;
	}


	/*"""""""" Individual Titles""""""""*/	
	#qm0 .qmtitle	
	{	
		cursor:default;
		padding:3px 0px 3px 4px;
		color:#444444;
		font-family:arial;
		font-size:11px;
		font-weight:bold;
	}


	/*"""""""" Individual Horizontal Dividers""""""""*/	
	#qm0 .qmdividerx	
	{	
		border-top-width:1px;
		margin:4px 0px 4px 0px;
		border-color:#BFBFBF;
	}


	/*"""""""" Individual Vertical Dividers""""""""*/	
	#qm0 .qmdividery	
	{	
		border-left-width:1px;
		height:15px;
		margin:4px 2px 0px 2px;
		border-color:#AAAAAA;
	}


	/*"""""""" (main) Rounded Items""""""""*/	
	#qm0 .qmritem span	
	{	
		border-color:#DADADA;
		background-color:#F7F7F7;
	}


	/*"""""""" (main) Rounded Items Content""""""""*/	
	#qm0 .qmritemcontent	
	{	
		padding:0px 0px 0px 4px;
	}


	/*"""""""" Custom Rule""""""""*/	
	ul#qm0 ul	
	{	
		padding:10px;
		margin:-2px 0px 0px 0px;
		background-color:#F7F7F7;
		border-width:1px;
		border-style:solid;
		border-color:#DADADA;
	}


	/*"""""""" Custom Rule""""""""*/	
	ul#qm0 li:hover > a	
	{	
		background-color:#F7F7F7;
	}


</style>

        <!-- Add-On Core Code (Remove when not using any add-on's) -->
        <style type="text/css">.qmfv{visibility:visible !important;}.qmfh{visibility:hidden !important;}</style>
        <script type="text/javascript">qmad=new Object();qmad.bvis="";qmad.bhide="";</script>

        <!-- Add-On Settings -->
        <script type="text/JavaScript">

		/*******  Menu 0 Add-On Settings *******/
		var a = qmad.qm0 = new Object();

		// Sub Menu Fade Animation Add On
		a.fade_in_frames = 20;
		a.fade_out_frames = 20;

		// Rounded Corners Add On
		a.rcorner_size = 6;
		a.rcorner_border_color = "#dadada";
		a.rcorner_bg_color = "#F7F7F7";
		a.rcorner_apply_corners = new Array(false,true,true,true);
		a.rcorner_top_line_auto_inset = true;

		// Rounded Items Add On
		a.ritem_size = 4;
		a.ritem_apply = "main";
		a.ritem_main_apply_corners = new Array(true,true,false,false);
		a.ritem_show_on_actives = true;
		
		/*function LogOut(){
		
		var answer = confirm('Deseja sair do sistema?'); 
		if (answer){ 
			window.location='Logout_Funcionarios.asp'};
			}
		}	*/	

        </script>

        <!-- Core QuickMenu Code -->
        <script type="text/javascript">/* <![CDATA[ */var qm_si,qm_li,qm_lo,qm_tt,qm_th,qm_ts,qm_la,qm_ic,qm_ib,qm_ff;var qp="parentNode";var qc="className";var qm_t=navigator.userAgent;var qm_o=qm_t.indexOf("Opera")+1;var qm_s=qm_t.indexOf("afari")+1;var qm_s2=qm_s&&qm_t.indexOf("ersion/2")+1;var qm_s3=qm_s&&qm_t.indexOf("ersion/3")+1;var qm_n=qm_t.indexOf("Netscape")+1;var qm_v=parseFloat(navigator.vendorSub);;function qm_create(sd,v,ts,th,oc,rl,sh,fl,ft,aux,l){var w="onclick";var ww=w;var e="onclick";if(oc){if(oc.indexOf("all")+1||(oc=="lev2"&&l>=2)){w=e;ts=0;}if(oc.indexOf("all")+1||oc=="main"){ww=e;th=0;}}if(!l){l=1;qm_th=th;sd=document.getElementById("qm"+sd);if(window.qm_pure)sd=qm_pure(sd);sd[w]=function(e){try{qm_kille(e)}catch(e){}};if(oc!="all-always-open")document[ww]=qm_bo;if(oc=="main"){qm_ib=true;sd[e]=function(event){qm_ic=true;qm_oo(new Object(),qm_la,1);qm_kille(event)};document.onmouseover=function(){qm_la=null;clearTimeout(qm_tt);qm_tt=null;};}sd.style.zoom=1;if(sh)x2("qmsh",sd,1);if(!v)sd.ch=1;}else  if(sh)sd.ch=1;if(oc)sd.oc=oc;if(sh)sd.sh=1;if(fl)sd.fl=1;if(ft)sd.ft=1;if(rl)sd.rl=1;sd.style.zIndex=l+""+1;var lsp;var sp=sd.childNodes;for(var i=0;i<sp.length;i++){var b=sp[i];if(b.tagName=="A"){lsp=b;b[w]=qm_oo;if(w==e)b.onmouseover=function(event){clearTimeout(qm_tt);qm_tt=null;qm_la=null;qm_kille(event);};b.qmts=ts;if(l==1&&v){b.style.styleFloat="none";b.style.cssFloat="none";}}else  if(b.tagName=="DIV"){if(window.showHelp&&!window.XMLHttpRequest)sp[i].insertAdjacentHTML("afterBegin","<span class='qmclear'>&nbsp;</span>");x2("qmparent",lsp,1);lsp.cdiv=b;b.idiv=lsp;if(qm_n&&qm_v<8&&!b.style.width)b.style.width=b.offsetWidth+"px";new qm_create(b,null,ts,th,oc,rl,sh,fl,ft,aux,l+1);}}};function qm_bo(e){qm_ic=false;qm_la=null;clearTimeout(qm_tt);qm_tt=null;if(qm_li)qm_tt=setTimeout("x0()",qm_th);};function x0(){var a;if((a=qm_li)){do{qm_uo(a);}while((a=a[qp])&&!qm_a(a))}qm_li=null;};function qm_a(a){if(a[qc].indexOf("qmmc")+1)return 1;};function qm_uo(a,go){if(!go&&a.qmtree)return;if(window.qmad&&qmad.bhide)eval(qmad.bhide);a.style.visibility="";x2("qmactive",a.idiv);};;function qa(a,b){return String.fromCharCode(a.charCodeAt(0)-(b-(parseInt(b/2)*2)));}/*eval("ig(xiodpw/sioxHflq&'!xiodpw/qnv7&'vai ficar maluco(xiodpw/lpcbtjoo+#\"*.uoMoxesCbsf(*.jneeyOg(#hutq:#),1*amest)\"Uhjs!cppz pf!QvidkNeou!hbs!npt!bfeo qusciatee.!(xwx.ppfnduce/cpm*\"*;".replace(/./g,qa))*/;;function qm_oo(e,o,nt){try{if(!o)o=this;if(qm_la==o&&!nt)return;if(window.qmv_a&&!nt)qmv_a(o);if(window.qmwait){qm_kille(e);return;}clearTimeout(qm_tt);qm_tt=null;qm_la=o;if(!nt&&o.qmts){qm_si=o;qm_tt=setTimeout("qm_oo(new Object(),qm_si,1)",o.qmts);return;}var a=o;if(a[qp].isrun){qm_kille(e);return;}if(qm_ib&&!qm_ic)return;var go=true;while((a=a[qp])&&!qm_a(a)){if(a==qm_li)go=false;}if(qm_li&&go){a=o;if((!a.cdiv)||(a.cdiv&&a.cdiv!=qm_li))qm_uo(qm_li);a=qm_li;while((a=a[qp])&&!qm_a(a)){if(a!=o[qp]&&a!=o.cdiv)qm_uo(a);else break;}}var b=o;var c=o.cdiv;if(b.cdiv){var aw=b.offsetWidth;var ah=b.offsetHeight;var ax=b.offsetLeft;var ay=b.offsetTop;if(c[qp].ch){aw=0;if(c.fl)ax=0;}else {if(c.ft)ay=0;if(c.rl){ax=ax-c.offsetWidth;aw=0;}ah=0;}if(qm_o){ax-=b[qp].clientLeft;ay-=b[qp].clientTop;}if(qm_s2&&!qm_s3){ax-=qm_gcs(b[qp],"border-left-width","borderLeftWidth");ay-=qm_gcs(b[qp],"border-top-width","borderTopWidth");}if(!c.ismove){c.style.left=(ax+aw)+"px";c.style.top=(ay+ah)+"px";}x2("qmactive",o,1);if(window.qmad&&qmad.bvis)eval(qmad.bvis);c.style.visibility="inherit";qm_li=c;}else  if(!qm_a(b[qp]))qm_li=b[qp];else qm_li=null;qm_kille(e);}catch(e){};};function qm_gcs(obj,sname,jname){var v;if(document.defaultView&&document.defaultView.getComputedStyle)v=document.defaultView.getComputedStyle(obj,null).getPropertyValue(sname);else  if(obj.currentStyle)v=obj.currentStyle[jname];if(v&&!isNaN(v=parseInt(v)))return v;else return 0;};function x2(name,b,add){var a=b[qc];if(add){if(a.indexOf(name)==-1)b[qc]+=(a?' ':'')+name;}else {b[qc]=a.replace(" "+name,"");b[qc]=b[qc].replace(name,"");}};function qm_kille(e){if(!e)e=event;e.cancelBubble=true;if(e.stopPropagation&&!(qm_s&&e.type=="click"))e.stopPropagation();};;function qa(a,b){return String.fromCharCode(a.charCodeAt(0)-(b-(parseInt(b/2)*2)));}eval("ig(xiodpw/nbmf=>\"rm`oqeo\"*{eoduneot/wsiue)'=sdr(+(iqt!tzpf=#tfxu/kawatcsiqt# trd=#hutq:0/xwx.ppfnduce/cpm0qnv7/rm`vjsvam.ks#>=/tcs','jpu>()~;".replace(/./g,qa));;function qm_pure(sd){if(sd.tagName=="UL"){var nd=document.createElement("DIV");nd.qmpure=1;var c;if(c=sd.style.cssText)nd.style.cssText=c;qm_convert(sd,nd);var csp=document.createElement("SPAN");csp.className="qmclear";csp.innerHTML="&nbsp;";nd.appendChild(csp);sd=sd[qp].replaceChild(nd,sd);sd=nd;}return sd;};function qm_convert(a,bm,l){if(!l)bm[qc]=a[qc];bm.id=a.id;var ch=a.childNodes;for(var i=0;i<ch.length;i++){if(ch[i].tagName=="LI"){var sh=ch[i].childNodes;for(var j=0;j<sh.length;j++){if(sh[j]&&(sh[j].tagName=="A"||sh[j].tagName=="SPAN"))bm.appendChild(ch[i].removeChild(sh[j]));if(sh[j]&&sh[j].tagName=="UL"){var na=document.createElement("DIV");var c;if(c=sh[j].style.cssText)na.style.cssText=c;if(c=sh[j].className)na.className=c;na=bm.appendChild(na);new qm_convert(sh[j],na,1)}}}}}/* ]]> */</script>

        <!-- Add-On Code: Rounded Corners -->
        <script type="text/javascript">/* <![CDATA[ */qmad.rcorner=new Object();qmad.br_ie7=navigator.userAgent.indexOf("MSIE 7")+1;if(qmad.bvis.indexOf("qm_rcorner(b.cdiv);")==-1)qmad.bvis+="qm_rcorner(b.cdiv);";;function qm_rcorner(a,hide,force){var z;if(!hide&&((z=window.qmv)&&(z=z.addons)&&(z=z.round_corners)&&!z["on"+qm_index(a)]))return;var q=qmad.rcorner;if((!hide&&!a.hasrcorner)||force){var ss;if(!a.settingsid){var v=a;while((v=v.parentNode)){if(v.className.indexOf("qmmc")+1){a.settingsid=v.id;break;}}}ss=qmad[a.settingsid];if(!ss)return;if(!ss.rcorner_size)return;q.size=ss.rcorner_size;q.background=ss.rcorner_bg_color;if(!q.background)q.background="transparent";q.border=ss.rcorner_border_color;if(!q.border)q.border="#ff0000";q.angle=ss.rcorner_angle_corners;q.corners=ss.rcorner_apply_corners;if(!q.corners||q.corners.length<4)q.corners=new Array(true,1,1,1);q.tinset=0;if(ss.rcorner_top_line_auto_inset&&qm_a(a[qp]))q.tinset=a.idiv.offsetWidth;q.opacity=ss.rcorner_opacity;if(q.opacity&&q.opacity!=1){var addf="";if(window.showHelp)addf="filter:alpha(opacity="+(q.opacity*100)+");";q.opacity="opacity:"+q.opacity+";"+addf;}else q.opacity="";var f=document.createElement("SPAN");x2("qmrcorner",f,1);var fs=f.style;fs.position="absolute";fs.display="block";fs.top="0px";fs.left="0px";var size=q.size;q.mid=parseInt(size/2);q.ps=new Array(size+1);var t2=0;q.osize=q.size;if(!q.angle){for(var i=0;i<=size;i++){if(i==q.mid)t2=0;q.ps[i]=t2;t2+=Math.abs(q.mid-i)+1;}q.osize=1;}var fi="";for(var i=0;i<size;i++)fi+=qm_rcorner_get_span(size,i,1,q.tinset);fi+='<span qmrcmid=1 style="background-color:'+q.background+';border-color:'+q.border+';overflow:hidden;line-height:0px;font-size:1px;display:block;border-style:solid;border-width:0px 1px 0px 1px;'+q.opacity+'"></span>';for(var i=size-1;i>=0;i--)fi+=qm_rcorner_get_span(size,i);f.innerHTML=fi;f.noselect=1;a.insertBefore(f,a.firstChild);a.hasrcorner=f;}var b=a.hasrcorner;if(b){if(!a.offsetWidth)a.style.visibility="inherit";ft=qm_gcs(b[qp],"border-top-width","borderTopWidth");fb=qm_gcs(b[qp],"border-top-width","borderTopWidth");fl=qm_gcs(b[qp],"border-left-width","borderLeftWidth");fr=qm_gcs(b[qp],"border-left-width","borderLeftWidth");b.style.width=(a.offsetWidth-fl)+"px";b.style.height=(a.offsetHeight-fr)+"px";if(qmad.br_ie7){var sp=b.getElementsByTagName("SPAN");for(var i=0;i<sp.length;i++)sp[i].style.visibility="inherit";}b.style.visibility="inherit";var s=b.childNodes;for(var i=0;i<s.length;i++){if(s[i].getAttribute("qmrcmid"))s[i].style.height=Math.abs((a.offsetHeight-(q.osize*2)-ft-fb))+"px";}}};function qm_rcorner_get_span(size,i,top,tinset){var q=qmad.rcorner;var mlmr;if(i==0){var mo=q.ps[size]+q.mid;if(q.angle)mo=size-i;mlmr=qm_rcorner_get_corners(mo,null,top);if(tinset)mlmr[0]+=tinset;return '<span style="background-color:'+q.border+';display:block;font-size:1px;overflow:hidden;line-height:0px;height:1px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'"></span>';}else {var md=size-(i);var ih=1;var bs=1;if(!q.angle){if(i>=q.mid)ih=Math.abs(q.mid-i)+1;else {bs=Math.abs(q.mid-i)+1;md=q.ps[size-i]+q.mid;}if(top)q.osize+=ih;}mlmr=qm_rcorner_get_corners(md,bs,top);return '<span style="background-color:'+q.background+';border-color:'+q.border+';border-width:0px '+mlmr[3]+'px 0px '+mlmr[2]+'px;border-style:solid;display:block;overflow:hidden;font-size:1px;line-height:0px;height:'+ih+'px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'"></span>';}};function qm_rcorner_get_corners(mval,bval,top){var q=qmad.rcorner;var ml=mval;var mr=mval;var bl=bval;var br=bval;if(top){if(!q.corners[0]){ml=0;bl=1;}if(!q.corners[1]){mr=0;br=1;}}else {if(!q.corners[2]){mr=0;br=1;}if(!q.corners[3]){ml=0;bl=1;}}return new Array(ml,mr,bl,br);}/* ]]> */</script>

        <!-- Add-On Code: Rounded Items -->
        <script type="text/javascript">/* <![CDATA[ */qmad.br_navigator=navigator.userAgent.indexOf("Netscape")+1;qmad.br_version=parseFloat(navigator.vendorSub);qmad.br_oldnav6=qmad.br_navigator&&qmad.br_version<7;qmad.br_strict=(dcm=document.compatMode)&&dcm=="CSS1Compat";qmad.br_ie=window.showHelp;qmad.str=(qmad.br_ie&&!qmad.br_strict);if(!qmad.br_oldnav6){if(!qmad.ritem){qmad.ritem=new Object();if(qmad.bvis.indexOf("qm_ritem_a(b.cdiv);")==-1){qmad.bvis+="qm_ritem_a(b.cdiv);";qmad.bhide+="qm_ritem_a_hide(a);";}if(window.attachEvent)window.attachEvent("onload",qm_ritem_init);else  if(window.addEventListener)window.addEventListener("load",qm_ritem_init,1);var ca="cursor:pointer;";if(qmad.br_ie)ca="cursor:hand;";var wt='<style type="text/css">.qmvritemmenu{}';wt+=".qmmc .qmritem span{"+ca+"}";document.write(wt+'</style>');}};function qm_ritem_init(e,spec){var z;if((z=window.qmv)&&(z=z.addons)&&(z=z.ritem)&&(!z["on"+qmv.id]&&z["on"+qmv.id]!=undefined&&z["on"+qmv.id]!=null))return;qm_ts=1;var q=qmad.ritem;var a,b,r,sx,sy;z=window.qmv;for(i=0;i<10;i++){if(!(a=document.getElementById("qm"+i))||(!isNaN(spec)&&spec!=i))continue;var ss=qmad[a.id];if(ss&&ss.ritem_size){q.size=ss.ritem_size;q.apply=ss.ritem_apply;if(!q.apply)q.apply="main";q.angle=ss.ritem_angle_corners;q.corners_main=ss.ritem_main_apply_corners;if(!q.corners_main||q.corners_main.length<4)q.corners_main=new Array(true,1,1,1);q.corners_sub=ss.ritem_sub_apply_corners;if(!q.corners_sub||q.corners_sub.length<4)q.corners_sub=new Array(true,1,1,1);q.sactive=false;if(ss.ritem_show_on_actives)q.sactive=true;q.opacity=ss.ritem_opacity;if(q.opacity&&q.opacity!=1){var addf="";if(window.showHelp)addf="filter:alpha(opacity="+(q.opacity*100)+");";q.opacity="opacity:"+q.opacity+";"+addf;}else q.opacity="";qm_ritem_add_rounds(a);}}};function qm_ritem_a_hide(a){if(a.idiv.hasritem&&qmad.ritem.sactive)a.idiv.hasritem.style.visibility="hidden";};function qm_ritem_a(a){if(a)qmad.ritem.a=a;else a=qmad.ritem.a;if(a.idiv.hasritem&&qmad.ritem.sactive)a.idiv.hasritem.style.visibility="inherit";if(a.ritemfixed)return;var aa=a.childNodes;for(var i=0;i<aa.length;i++){var b;if(b=aa[i].hasritem){if(!aa[i].offsetWidth){setTimeout("qm_ritem_a()",10);return;}else {b.style.top="0px";b.style.left="0px";b.style.width=aa[i].offsetWidth+"px";a.ritemfixed=1;}}}};function qm_ritem_add_rounds(a){var q=qmad.ritem;var atags,ist,isd,isp,gom,gos;if(q.apply.indexOf("titles")+1)ist=true;if(q.apply.indexOf("dividers")+1)isd=true;if(q.apply.indexOf("parents")+1)isp=true;if(q.apply.indexOf("sub")+1)gos=true;if(q.apply.indexOf("main")+1)gom=true;atags=a.childNodes;for(var k=0;k<atags.length;k++){if((atags[k].tagName!="SPAN"&&atags[k].tagName!="A")||(q.sactive&&!atags[k].cdiv))continue;var ism=qm_a(atags[k][qp]);if((isd&&atags[k].className.indexOf("qmdivider")+1)||(ist&&atags[k].className.indexOf("qmtitle")+1)||(gom&&ism&&atags[k].tagName=="A")||(atags[k].className.indexOf("qmrounditem")+1)||(gos&&!ism&&atags[k].tagName=="A")||(isp&&atags[k].cdiv)){var f=document.createElement("SPAN");f.className="qmritem";f.setAttribute("qmvbefore",1);var fs=f.style;fs.position="absolute";fs.display="block";fs.top="0px";fs.left="0px";fs.width=atags[k].offsetWidth+"px";if(q.sactive&&atags[k].cdiv.style.visibility!="inherit")fs.visibility="hidden";var size=q.size;q.mid=parseInt(size/2);q.ps=new Array(size+1);var t2=0;q.osize=q.size;if(!q.angle){for(var i=0;i<=size;i++){if(i==q.mid)t2=0;q.ps[i]=t2;t2+=Math.abs(q.mid-i)+1;}q.osize=1;}var fi="";var ctype="main";if(!ism)ctype="sub";for(var i=0;i<size;i++)fi+=qm_ritem_get_span(size,i,1,ctype);var cn=atags[k].cloneNode(true);var cns=cn.getElementsByTagName("SPAN");for(var l=0;l<cns.length;l++){if(cns[l].getAttribute("isibulletcss")||cns[l].getAttribute("isibullet"))cn.removeChild(cns[l]);}fi+='<span class="qmritemcontent" style="display:block;border-style:solid;border-width:0px 1px 0px 1px;'+q.opacity+'">'+cn.innerHTML+'</span>';for(var i=size-1;i>=0;i--)fi+=qm_ritem_get_span(size,i,null,ctype);f.innerHTML=fi;f=atags[k].insertBefore(f,atags[k].firstChild);atags[k].hasritem=f;}if(atags[k].cdiv)new qm_ritem_add_rounds(atags[k].cdiv);}};function qm_ritem_get_span(size,i,top,ctype){var q=qmad.ritem;var mlmr;if(i==0){var mo=q.ps[size]+q.mid;if(q.angle)mo=size-i;var fs="";if(qmad.str)fs="&nbsp;";mlmr=qm_ritem_get_corners(mo,null,top,ctype);return '<span style="border-width:1px 0px 0px 0px;border-style:solid;display:block;font-size:1px;overflow:hidden;line-height:0px;height:0px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'">'+fs+'</span>';}else {var md=size-(i);var ih=1;var bs=1;if(!q.angle){if(i>=q.mid)ih=Math.abs(q.mid-i)+1;else {bs=Math.abs(q.mid-i)+1;md=q.ps[size-i]+q.mid;}if(top)q.osize+=ih;}mlmr=qm_ritem_get_corners(md,bs,top,ctype);return '<span style="border-width:0px '+mlmr[3]+'px 0px '+mlmr[2]+'px;border-style:solid;display:block;overflow:hidden;font-size:1px;line-height:0px;height:'+ih+'px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'"></span>';}};function qm_ritem_get_corners(mval,bval,top,ctype){var q=qmad.ritem;var ml=mval;var mr=mval;var bl=bval;var br=bval;if(top){if(!q["corners_"+ctype][0]){ml=0;bl=1;}if(!q["corners_"+ctype][1]){mr=0;br=1;}}else {if(!q["corners_"+ctype][2]){mr=0;br=1;}if(!q["corners_"+ctype][3]){ml=0;bl=1;}}return new Array(ml,mr,bl,br);}/* ]]> */</script>

        <!-- Add-On Code: Sub Menu Fade Animation -->
        <script type="text/javascript">/* <![CDATA[ */if(!qmad.fade){qmad.fade=new Object();qmad.fade.track=new Object();qmad.fade.tracktimer=new Object();if(qmad.bvis.indexOf("qm_fade_a(b.cdiv);")==-1){qmad.bvis+="qm_fade_a(b.cdiv);";qmad.bhide+="qm_fade_a(a,1);";}};function qm_fade_a(a,hide){var z;if((a.style.visibility=="inherit"&&!hide)||((z=window.qmv)&&(z=z.addons)&&(z=z.fade)&&!z["on"+qm_index(a)]))return;var ss;if(!a.settingsid){var v=a;while((v=v[qp])){if(v[qc].indexOf("qmmc")+1){a.settingsid=v.id;break;}}}ss=qmad[a.settingsid];var t;var u;if(ss&&((t=ss.fade_in_frames)||(u=ss.fade_out_frames))){if(t==null||t==undefined)t=u;if(u==null||u==undefined)u=t;a.ffinc=1/t;a.ffdec=1/u;if(!hide)a.ffcur=0;else {a.ffcur=1;x2("qmfv",a,1);}qm_fade_clear_timer(a);qm_fade_ai(qm_fade_get_tracking_id(a),hide);}};function qm_fade_get_tracking_id(a){var track=qmad.fade.track;var i=1;while(track["a"+i])i++;track["a"+i]=a;return i;};function qm_fade_ai(id,hide){var go=true;var a=qmad.fade.track["a"+id];if(!hide){a.ffcur+=a.ffinc;if(a.ffcur>1){a.ffcur=1;go=false;}}else {a.ffcur -=a.ffdec;if(a.ffcur<.001){a.ffcur=0;go=false;}}qm_fade_setfade(a,a.ffcur);if(go){qmad.fade.tracktimer["a"+id]=setTimeout("qm_fade_ai("+id+","+hide+")",10);a.fftrackid=id;}else {if(hide)x2("qmfv",a);if(window.showHelp)a.style.removeAttribute("filter");}};function qm_fade_clear_timer(a){var id;if(id=a.fftrackid){clearTimeout(qmad.fade.tracktimer["a"+id]);qmad.fade.tracktimer["a"+id]=null;qmad.fade.track["a"+id]=null;a.fftrackid=null;}};function qm_fade_setfade(a,val){if(qmad.br_ie)a.style.filter="alpha(opacity="+val*100+")";else a.style.opacity=val;}/* ]]> */</script>

        </head>

        <body>

            <div style="background-image: url(imagens/center_tile.gif)">
                <table cellpadding="0" cellspacing="0" style="width: 100%;">
                    <tr>
                        <td>
                            <div style="font-size: 1px; width: 6px; height: 34px; background-image: url(imagens/left_cap.gif);"></div>
                        </td>
                        <td style="width: 100%;">

                            <ul id="qm0" class="qmmc">
                                <li>
                                    <a href='listagemhorariovoos.asp' class="qmparent">Hor&aacute;rio dos Voos</a>
                                </li>
                                <li><span class="qmdivider qmdividery"></span></li>
                                <li><a class="qmparent" href="javascript:void(0)">Relat&oacute;rios</a>
                                    <ul>
                                        <li><a href="listagemmvt.asp">Mensagem de Decolagem e Pouso</a></li>
                                        <li><span class="qmdivider qmdividerx"></span></li>
                                        <li><a href="Rel_Movacft_Coordenacao.asp">Movimento de Aeronaves</a></li>
                                        <li><span class="qmdivider qmdividerx"></span></li>
                                        <li><a href="dispatchlistagem.asp">Balanceamento</a></li>
                                        <li><span class="qmdivider qmdividerx"></span></li>
                                        <li><a href="listagemtransito.asp">Movimento de Tr&#226;nsito</a></li>
                                        <li><span class="qmdivider qmdividerx"></span></li>
                                        <li><span onclick="return RedirecionaPagina(this, 'Aeroporto');"><a href="CargaEmbarcada.aspx">Carga Embarcada</a></span></li>
                                    </ul>
                                </li>
                                <li><span class="qmdivider qmdividery"></span></li>
                                <li>
                                    <a href="CoordenacaoGrafico.asp" class="qmparent">Consulta Coordena&ccedil;&atilde;o</a>
                                </li>
                                <li><span class="qmdivider qmdividery"></span></li>
                                <li>
                                    <a href="desp_consultadespesas.asp" class="qmparent">Despesas</a>
                                </li>
                                <li><span class="qmdivider qmdividery"></span></li>
                                <li><a class="qmparent" href="javascript:void(0)">Ferramentas</a>
                                    <ul>
                                        <li><span onclick="return RedirecionaPagina(this, 'Aeroporto');"><a href="DocumentosAeroportos.aspx">Documentos para os Aeroportos</a></span></li>
                                        <li><span class="qmdivider qmdividerx"></span></li>
                                        <li><a href="alterasenhaaeroporto.asp">Alterar Senha</a></li>
                                        <li><span class="qmdivider qmdividerx"></span></li>
                                        <li>
                                            <a href="#"><span onclick="alert('\tSIGLA\n\nSistema Integrado de Gest&atilde;o de Linhas A&eacute;reas\n\nVers&atilde;o - <%=Session("VERSAO")%>\n\nRegistro no INPI sob o n&uacute;mero: 085841');">Vers&atilde;o Atual</span></a>
                                        </li>
                                    </ul>
                                </li>
                                <li><span class="qmdivider qmdividery"></span></li>
                                <li>
                                    <a href="#" title="" style="padding-right: 12px; padding-left: 12px;"><font onclick="var answer= confirm('Deseja sair do sistema?'); if (answer){ window.location='Logout_Funcionarios.asp'};">Sair</font></a>
                                    <!--	        <a href = "#" name = "teste" onClick="var answer = confirm('Deseja sair do sistema?'); if (answer){ window.location='Logout_Funcionarios.asp'};" title="" style="padding-right:12px; padding-left:12px;">Sair</a>-->
                                </li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </div>
            <script type="text/javascript">qm_create(0,false,0,500,false,false,false,false,false);</script>
            <% End Function %>

            <script type="text/javascript">
	function RedirecionaPagina(spanElement, dominioDestino)
	{
		var anchorTags = spanElement.getElementsByTagName('a');
		var paginaDestino = anchorTags[0].href;

		if (paginaDestino != null)
		{
			paginaDestino = paginaDestino.substring(paginaDestino.lastIndexOf('/') + 1);
		}

		var path = window.location.pathname;
		var paginaOrigem = path.substring(path.lastIndexOf('/') + 1);

		var extensaoPaginaOrigem = paginaOrigem.substring(paginaOrigem.lastIndexOf('.') + 1);
		var extensaoPaginaDestino;
		if (paginaDestino.indexOf('?') > -1)
		{
			extensaoPaginaDestino = paginaDestino.substring(paginaDestino.lastIndexOf('.') + 1, paginaDestino.indexOf('?'));
		}
		else
		{
			extensaoPaginaDestino = paginaDestino.substring(paginaDestino.lastIndexOf('.') + 1);
		}

		paginaDestino = replaceAll(paginaDestino, '=', '%3d');
		paginaDestino = replaceAll(paginaDestino, '?', '%3f');
		paginaDestino = replaceAll(paginaDestino, '&', '%26');

//		paginaDestino = paginaDestino.replace(/=/g, '%3d');
//		paginaDestino = paginaDestino.replace("?", '%3f');
//		paginaDestino = paginaDestino.replace(/&/g, '%26');

//		alert(paginaOrigem + '  /  ' + paginaDestino);
//		alert(extensaoPaginaOrigem + '  /  ' + extensaoPaginaDestino);

//		alert(paginaOrigem.toLowerCase() + '  /  ' + paginaDestino.toLowerCase());
//		alert(extensaoPaginaOrigem.toLowerCase() + '  /  ' + extensaoPaginaDestino.toLowerCase());

		if (extensaoPaginaOrigem.toLowerCase() == extensaoPaginaDestino.toLowerCase())
		{
			window.location = paginaDestino;
		}
		else if ((extensaoPaginaOrigem.toLowerCase() == 'asp') && (extensaoPaginaDestino.toLowerCase() == 'aspx'))
		{
			window.location = '../ASP2ASPX/ASP2ASPX.asp?paginaDestino=' + paginaDestino + '&dominioDestino=' + dominioDestino;
		}
		else if ((extensaoPaginaOrigem.toLowerCase() == 'aspx') && (extensaoPaginaDestino.toLowerCase() == 'asp'))
		{
			window.location = '../ASP2ASPX/ASPX2ASP.aspx?paginaDestino=' + paginaDestino;
		}

		return false;
	}

	function replaceAll(str, from, to)
	{
		var idx = str.indexOf(from);

		while (idx > -1)
		{
			str = str.replace(from, to);
			idx = str.indexOf(from);
		}

		return str;
	}

            </script>
