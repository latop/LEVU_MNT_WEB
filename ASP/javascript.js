VerificaTAB = true;

function SimulaTab(Elemento) {
	if ((Elemento.value.length == Elemento.maxLength) && (VerificaTAB)) {
		var i = 0, j = 0, indice = -1;
		for (i = 0; i < document.forms.length; i++) {
			for (j = 0; j < document.forms[i].elements.length; j++) {
				if (document.forms[i].elements[j].name == Elemento.name) {
					indice = i;
					break;
				}
			}
			if (indice != -1) break;
		}
		for (i = 0; i <= document.forms[indice].elements.length; i++) {
			if (document.forms[indice].elements[i].name == Elemento.name) {
				while ( (document.forms[indice].elements[(i+1)].type == "hidden") &&
					(i < document.forms[indice].elements.length) ) {
					i++;
				}
				document.forms[indice].elements[(i+1)].focus();
				VerificaTAB = false;
				break;
			}
		}
	}
}

function PararTAB(Elemento) {
	VerificaTAB = false;
	Elemento.select();
}

function ChecarTAB() {
	VerificaTAB = true;
}


////////////////////////////////////////////////////////////////////////
// Função para só permitir números
function SoNumeros(keypress, objeto){

  campo = eval (objeto);

  if((keypress < 48) || (keypress > 57)) {
    return false;
  }
}


////////////////////////////////////////////////////////////////////////
// Função para eliminar os espaços vazios antes e depois
// da string passada por parâmetro
function Trim(s)
{
	var l = 0;
	var r = s.length - 1;
	while(l < s.length && s[l] == ' ')
	{
		l++;
	}
	while(r > l && s[r] == ' ')
	{
		r -= 1;
	}
	return s.substring(l, r + 1);
}
