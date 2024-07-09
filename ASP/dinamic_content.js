try{
    xmlhttp = new XMLHttpRequest();
}catch(ee){
    try{
        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
    }catch(e){
        try{
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }catch(E){
            xmlhttp = false;
        }
    }
}


fila=[];
ifila=0;

function ajax(url, functionretorno, div){
    
    fila[fila.length]=[url,functionretorno, div];

    if((ifila+1)==fila.length)ajaxRun();
}


function ajaxRun(){
	var url;
	url = fila[ifila][0] + "id=" + new Date().getTime();

    xmlhttp.open("GET", url, true);	
    xmlhttp.onreadystatechange=function() {
        if (xmlhttp.readyState==4){

			if(fila[ifila][1] != "") {				
				eval(fila[ifila][1] + '(xmlhttp.responseText);');
			} else {
	            retorno=unescape(xmlhttp.responseText.replace(/\+/g," "));
	            document.getElementById(fila[ifila][2]).innerHTML=retorno;
			}

            ifila++
            if(ifila<fila.length)setTimeout("ajaxRun()",20);
        }
    }

    xmlhttp.send(null);
}