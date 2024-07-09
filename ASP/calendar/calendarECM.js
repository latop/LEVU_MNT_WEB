/* MarcGrabanski.com */

/* Pop-Up Calendar Built from Scratch by Marc Grabanski */

var popUpCal = {


	selectedMonth: new Date().getMonth(), // 0-11
    selectedYear: new Date().getFullYear(), // 4-digit year
    selectedDay: new Date().getDate(),
    calendarId: 'calendarDiv',
    inputClass: 'calendarECM',
	campoEntrada: String,
    
	init: function () {
				
		// CAPTURO O ID DO CAMPO QUE DEVE RECEBER O RESULTADO DO CALENDÁRIO
		
				for (var w = 0; w < document.forms.length; w++){					
					for (var k = 0; k < document.forms[w].elements.length; k++) {
						if (document.forms[w].elements[k].name == 'botaoCalendario'){                       //AQUI EU COLOCO O ID DO BOTÃO QUE ESTÁ CHAMANDO O CALENDÁRIO
							k--;
							campoEntrada = document.forms[w].elements[k].id;
							
							break;
						}
					}
					
			  	}
	
		var x = getElementsByClass(popUpCal.inputClass);        //(popUpCal.inputClass, document, 'input')
        var y = document.getElementById(popUpCal.calendarId);
        // set the calendar position based on the input position
        for (var i=0; i<x.length; i++) {
            x[i].onclick = function () {
				
				if (document.getElementById(campoEntrada).value.substring(6,10) >=1990 && document.getElementById(campoEntrada).value.substring(6,10) <= 2030)
					popUpCal.selectedYear = document.getElementById(campoEntrada).value.substring(6,10);
				else
					popUpCal.selectedYear = new Date().getFullYear();					

				if (document.getElementById(campoEntrada).value.substring(3,5)-1 >= 0 &&  document.getElementById(campoEntrada).value.substring(3,5)-1 <= 11)
					popUpCal.selectedMonth = document.getElementById(campoEntrada).value.substring(3,5) -1;
				else
					popUpCal.selectedMonth = new Date().getMonth();
					
				if (document.getElementById(campoEntrada).value.substring(0,2) >= 0 && document.getElementById(campoEntrada).value.substring(0,2) <=31)
					popUpCal.selectedDay = document.getElementById(campoEntrada).value.substring(0,2);
				else
					popUpCal.selectedDay = new Date().getDay();
                setPos(this, y); // setPos(targetObj,moveObj)
                y.style.display = 'block';
                popUpCal.drawCalendar(this);
                popUpCal.setupLinks(this);
            }
        }
    },
    
    drawCalendar: function (inputObj) {
		
		
		
		var html = '';
		html = '<a id="closeCalender">Fechar Calend&aacute;rio</a>';
		html += '<table cellpadding="0" cellspacing="0" id="linksTable"><tr>';
    	html += '	<td><a id="prevMonth"><font size=1><< Passado</font></a></td>';
		html += '	<td><a id="nextMonth"><font size=1>Pr&oacute;ximo >></font></a></td>';
		html += '</tr></table>';
		html += '<table id="calendar" cellpadding="0" cellspacing="0"><tr>';
		html += '<th colspan="7" class="calendarHeader">'+getMonthName(popUpCal.selectedMonth)+' '+popUpCal.selectedYear+'</th>';
		html += '</tr><tr class="weekDaysTitleRow">';
        var weekDays = new Array('D','S','T','Q','Q','S','S');
        for (var j=0; j<weekDays.length; j++) {
			html += '<td>'+weekDays[j]+'</td>';
        }
		
        var daysInMonth = getDaysInMonth(popUpCal.selectedYear, popUpCal.selectedMonth);
        var startDay = getFirstDayofMonth(popUpCal.selectedYear, popUpCal.selectedMonth);
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
					 && (popUpCal.selectedYear == thisYear) 
					 && (popUpCal.selectedMonth == thisMonth) 
					 && (noPrintDays == 0)) {
					html += '<td id="today" class="weekDaysCell">';
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
        var calendarDiv = document.getElementById(popUpCal.calendarId);
        calendarDiv.innerHTML = html;
        
        // close button link
        document.getElementById('closeCalender').onclick = function () {
            calendarDiv.style.display = 'none';
		}
		
		// setup next and previous links
        document.getElementById('prevMonth').onclick = function () {
            popUpCal.selectedMonth--;
            if (popUpCal.selectedMonth < 0) {
                popUpCal.selectedMonth = 11;
                popUpCal.selectedYear--;
            }
            popUpCal.drawCalendar(inputObj); 
            popUpCal.setupLinks(inputObj);
        }
        document.getElementById('nextMonth').onclick = function () {
            popUpCal.selectedMonth++;
            if (popUpCal.selectedMonth > 11) {
                popUpCal.selectedMonth = 0;
                popUpCal.selectedYear++;
            }
            popUpCal.drawCalendar(inputObj); 
            popUpCal.setupLinks(inputObj);
        }
        
    }, // end drawCalendar function
    
    setupLinks: function (inputObj) {
        // set up link events on calendar table
        var y = document.getElementById('calendar');        // REFERENCIA A TABELA HTML QUE CRIA O CALENDÁRIO
        var x = y.getElementsByTagName('a');
        for (var i=0; i<x.length; i++) {
            x[i].onmouseover = function () {
                this.parentNode.className = 'weekDaysCellOver';
            }
            x[i].onmouseout = function () {
                this.parentNode.className = 'weekDaysCell';
            }
            x[i].onclick = function () {
                document.getElementById(popUpCal.calendarId).style.display = 'none';
                popUpCal.selectedDay = this.innerHTML;
				document.getElementById(campoEntrada).value = formatDate(popUpCal.selectedDay, popUpCal.selectedMonth, popUpCal.selectedYear);		
							
            }
        }
    }
    
}
// Add calendar event that has wide browser support
if ( typeof window.addEventListener != "undefined" )
    window.addEventListener( "load", popUpCal.init, false );
else if ( typeof window.attachEvent != "undefined" )
    window.attachEvent( "onload", popUpCal.init );
else {
    if ( window.onload != null ) {
        var oldOnload = window.onload;
        window.onload = function ( e ) {
            oldOnload( e );
            popUpCal.init();
        };
    }
    else
        window.onload = popUpCal.init;
}

/* Functions Dealing with Dates */

function formatDate(Day, Month, Year) {
    Month++; // adjust javascript month
    if (Month <10) Month = '0'+Month; // add a zero if less than 10
    if (Day < 10) Day = '0'+Day; // add a zero if less than 10
    var dateString = Day+'/'+Month+'/'+Year;
    return dateString;
}

function getMonthName(month) {
    var monthNames = new Array('Janeiro', 'Fevereiro', 'Mar&ccedil;o', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro');
    return monthNames[month];
}

function getDayName(day) {
    var dayNames = new Array('Segunda', 'Ter&ccedil;a', 'Quarta', 'Quinta', 'Sexta', 'S&aacute;bado', 'Domingo');
    return dayNames[day];
}

function getDaysInMonth(year, month) {
    return 32 - new Date(year, month, 32).getDate();
}

function getFirstDayofMonth(year, month) {
    var day;
    day = new Date(year, month, 0).getDay();
    return day;
}

/* Common Scripts */

function getElementsByClass(searchClass,node,tag) {
    var classElements = new Array();
    if ( node == null ) node = document;
    if ( tag == null ) tag = '*';
    var els = node.getElementsByTagName(tag);
    var elsLen = els.length;
    var pattern = new RegExp("(^|\\s)"+searchClass+"(\\s|$)");
    for (i = 0, j = 0; i < elsLen; i++) {
        if ( pattern.test(els[i].className) ) {
            classElements[j] = els[i];
            j++;
        }
    }
    return classElements;
}

/* Position Functions */

function setPos(targetObj,moveObj) {
    var coors = findPos(targetObj);
    moveObj.style.position = 'absolute';
    moveObj.style.top = coors[1]+20 + 'px';
    moveObj.style.left = coors[0] + 'px';
}

function findPos(obj) {
    var curleft = curtop = 0;
    if (obj.offsetParent) {
        curleft = obj.offsetLeft
        curtop = obj.offsetTop
        while (obj = obj.offsetParent) {
            curleft += obj.offsetLeft
            curtop += obj.offsetTop
        }
    }
    return [curleft,curtop];
}

