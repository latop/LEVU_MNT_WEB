
var popUpCal2 = {


	selectedMonth: new Date().getMonth(), // 0-11
    selectedYear: new Date().getFullYear(), // 4-digit year
    selectedDay: new Date().getDate(),
    calendarId: 'calendarDiv2',
    inputClass: 'calendarECM2',
	campoEntrada2: String,
    
	init: function () {
				
		// CAPTURO O ID DO CAMPO QUE DEVE RECEBER O RESULTADO DO CALENDÁRIO
		
				for (var ww = 0; ww < document.forms.length; ww++){					
					for (var kk = 0; kk < document.forms[ww].elements.length; kk++) {
						if (document.forms[ww].elements[kk].id == 'botaoCalendario2'){                       //AQUI EU COLOCO O ID DO BOTÃO QUE ESTÁ CHAMANDO O CALENDÁRIO
							kk--;
//							alert(document.forms[ww].elements[kk].id)
							campoEntrada2 = document.forms[ww].elements[kk].id;
							
							break;
						}
					}
					
			  	}
	
		var x = getElementsByClass(popUpCal2.inputClass);        //(popUpCal2.inputClass, document, 'input')
        var y = document.getElementById(popUpCal2.calendarId);
        // set the calendar position based on the input position
        for (var iw=0; iw<x.length; iw++) {
            x[iw].onclick = function () {
				
				if (document.getElementById(campoEntrada2).value.substring(6,10) >=1990 && document.getElementById(campoEntrada2).value.substring(6,10) <= 2030)
					popUpCal2.selectedYear = document.getElementById(campoEntrada2).value.substring(6,10);
				else
					popUpCal2.selectedYear = new Date().getFullYear();					

				if (document.getElementById(campoEntrada2).value.substring(3,5)-1 >= 0 &&  document.getElementById(campoEntrada2).value.substring(3,5)-1 <= 11)
					popUpCal2.selectedMonth = document.getElementById(campoEntrada2).value.substring(3,5) -1;
				else
					popUpCal2.selectedMonth = new Date().getMonth();
					
				if (document.getElementById(campoEntrada2).value.substring(0,2) >= 0 && document.getElementById(campoEntrada2).value.substring(0,2) <=31)
					popUpCal2.selectedDay = document.getElementById(campoEntrada2).value.substring(0,2);
				else
					popUpCal2.selectedDay = new Date().getDay();
                setPos(this, y); // setPos(targetObj,moveObj)
                y.style.display = 'block';
                popUpCal2.drawCalendar(this);
                popUpCal2.setupLinks(this);
            }
        }
    },
    
    drawCalendar: function (inputObj) {
		
		
		
		var html = '';
		html = '<a id="closeCalender2">Fechar Calend&aacute;rio</a>';
		html += '<table cellpadding="0" cellspacing="0" id="linksTable"><tr>';
    	html += '	<td><a id="prevMonth2"><font size=1><< Passado</font></a></td>';
		html += '	<td><a id="nextMonth2"><font size=1>Pr&oacute;ximo >></font></a></td>';
		html += '</tr></table>';
		html += '<table id="calendar2" cellpadding="0" cellspacing="0"><tr>';
		html += '<th colspan="7" class="calendarHeader2">'+getMonthName(popUpCal2.selectedMonth)+' '+popUpCal2.selectedYear+'</th>';
		html += '</tr><tr class="weekDaysTitleRow">';
        var weekDays = new Array('D','S','T','Q','Q','S','S');
        for (var j=0; j<weekDays.length; j++) {
			html += '<td>'+weekDays[j]+'</td>';
        }
		
        var daysInMonth = getDaysInMonth(popUpCal2.selectedYear, popUpCal2.selectedMonth);
        var startDay = getFirstDayofMonth(popUpCal2.selectedYear, popUpCal2.selectedMonth);
        var numRows = 0;
        var printDate = 1;
        if (startDay != 7) {
            numRows = Math.ceil(((startDay+1)+(daysInMonth))/7); // calculate the number of rows to generate
        }
		
        // calculate number of days before calendar starts
        if (startDay != 7) {
            var noPrintDays = startDay + 1; 
        } else {
            var noPrintDays = 0; // if sunday print right away	
        }
		var today = new Date().getDate();
		var thisMonth = new Date().getMonth();
		var thisYear = new Date().getFullYear();
        // create calendar rows
        for (var e=0; e<numRows; e++) {
			html += '<tr class="weekDaysRow">';
            // create calendar days
            for (var f=0; f<7; f++) {
				if ( (printDate == today) 
					 && (popUpCal2.selectedYear == thisYear) 
					 && (popUpCal2.selectedMonth == thisMonth) 
					 && (noPrintDays == 0)) {
					html += '<td id="today2" class="weekDaysCell">';
				} else {
                	html += '<td class="weekDaysCell">';
				}
                if (noPrintDays == 0) {
					if (printDate <= daysInMonth) {
						html += '<a>'+printDate+'</a>';
					}
                    printDate++;
                }
                html += '</td>';
                if(noPrintDays > 0) noPrintDays--;
            }
            html += '</tr>';
        }
		html += '</table>';

        
        // add calendar to element to calendar Div
        var calendarDiv = document.getElementById(popUpCal2.calendarId);
        calendarDiv.innerHTML = html;
        
        // close button link
        document.getElementById('closeCalender2').onclick = function () {
            calendarDiv.style.display = 'none';
		}
		
		// setup next and previous links
        document.getElementById('prevMonth2').onclick = function () {
            popUpCal2.selectedMonth--;
            if (popUpCal2.selectedMonth < 0) {
                popUpCal2.selectedMonth = 11;
                popUpCal2.selectedYear--;
            }
            popUpCal2.drawCalendar(inputObj); 
            popUpCal2.setupLinks(inputObj);
        }
        document.getElementById('nextMonth2').onclick = function () {
            popUpCal2.selectedMonth++;
            if (popUpCal2.selectedMonth > 11) {
                popUpCal2.selectedMonth = 0;
                popUpCal2.selectedYear++;
            }
            popUpCal2.drawCalendar(inputObj); 
            popUpCal2.setupLinks(inputObj);
        }
        
    }, // end drawCalendar function
    
    setupLinks: function (inputObj) {
        // set up link events on calendar table
        var y = document.getElementById('calendar2');        // REFERENCIA A TABELA HTML QUE CRIA O CALENDÁRIO
        var x = y.getElementsByTagName('a');
        for (var i=0; i<x.length; i++) {
            x[i].onmouseover = function () {
                this.parentNode.className = 'weekDaysCellOver';
            }
            x[i].onmouseout = function () {
                this.parentNode.className = 'weekDaysCell';
            }
            x[i].onclick = function () {
                document.getElementById(popUpCal2.calendarId).style.display = 'none';
                popUpCal2.selectedDay = this.innerHTML;
				document.getElementById(campoEntrada2).value = formatDate(popUpCal2.selectedDay, popUpCal2.selectedMonth, popUpCal2.selectedYear);		
							
            }
        }
    }

}
// Add calendar event that has wide browser support
if ( typeof window.addEventListener != "undefined" )
    window.addEventListener( "load", popUpCal2.init, false );
else if ( typeof window.attachEvent != "undefined" )
    window.attachEvent( "onload", popUpCal2.init );
else {
    if ( window.onload != null ) {
        var oldOnload = window.onload;
        window.onload = function ( e ) {
            oldOnload( e );
            popUpCal2.init();
        };
    }
    else
        window.onload = popUpCal2.init;
}

/* Functions Dealing with Dates */

/* Common Scripts */

