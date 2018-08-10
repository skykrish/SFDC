var findConfirm='';
function window_pos(popUpDivVar, popuptype) {
	if (typeof window.innerWidth != 'undefined') {
		viewportwidth = window.innerHeight;
	} else {
		viewportwidth = document.documentElement.clientHeight;
	}
	if ((viewportwidth > document.body.parentNode.scrollWidth) && (viewportwidth > document.body.parentNode.clientWidth)) {
		window_width = viewportwidth;
	} else {
		if (document.body.parentNode.clientWidth > document.body.parentNode.scrollWidth) {
			window_width = document.body.parentNode.clientWidth;
		} else {
			window_width = document.body.parentNode.scrollWidth;
		}
	}
	var popUpDiv = document.getElementById(popUpDivVar);
	window_width=window_width/2-200;
	popUpDiv.style.left = window_width + 'px';
}
var conformok = false;
var flog = false;

function popup(windowname, popuptype, PopupHeader, Popupcontent, PopUpredirectURL) {

	var el = document.getElementById(windowname);

	var type =  popuptype;
	var popupurl = PopUpredirectURL;
	
	
	var atag = document.getElementById("button");
	var blankdiv = document.createElement("div");
	blankdiv.setAttribute("id","blanket");
	document.body.insertBefore(blankdiv, atag); 
	if(popuptype == 'alert')
	{
		
		var newDiv = document.createElement("div");
		var heading = document.createElement("h2");
		var closebutton = document.createElement("a");
		
		var heading_content = document.createTextNode(PopupHeader);
		closebutton.setAttribute("href","#");
	
		closebutton.setAttribute("id","close");
		closebutton.setAttribute("class","close");
	
		newDiv.setAttribute("id", "popUpalert");
		newDiv.setAttribute("class", "popUpDiv");
		var newContent = document.createTextNode(Popupcontent);
		heading.appendChild(heading_content); 
		newDiv.appendChild(closebutton); 
		newDiv.appendChild(heading); 
		newDiv.appendChild(newContent); 
		var currentDiv = document.getElementById("div1");
		document.body.insertBefore(newDiv, currentDiv); 
		
	}
	if(popuptype == 'prompt')
	{
		var newDiv = document.createElement("div");
		var heading = document.createElement("h2");
		var closebutton = document.createElement("a");
		
		var inputbox = document.createElement("input");
		var buttondive = document.createElement("div");
		var buttonoklink =  document.createElement("a");
		var buttoncancellink =  document.createElement("a");
		buttonoklink.setAttribute("href","#");
		buttonoklink.innerHTML = "Ok";
		buttonoklink.setAttribute("id","confirmOK");
		buttoncancellink.setAttribute("href","#");
		buttoncancellink.innerHTML = "Cancel";
		buttoncancellink.setAttribute("id","confirmCancel");
		buttondive.appendChild(buttonoklink);
		buttondive.appendChild(buttoncancellink);
	
		var heading_content = document.createTextNode(PopupHeader);
		closebutton.setAttribute("href","#");
		
		
		closebutton.setAttribute("id","close");
		closebutton.setAttribute("class","close");
		inputbox.setAttribute("type","text");
		inputbox.setAttribute("class","textValue");
		newDiv.setAttribute("id", "popUpprompt");
		newDiv.setAttribute("class", "popUpDiv");
		buttondive.setAttribute("class","butttonlist");
		var newContent = document.createTextNode(Popupcontent);
		heading.appendChild(heading_content); 
		newDiv.appendChild(closebutton); 
		newDiv.appendChild(heading); 
		newDiv.appendChild(newContent); 
		newDiv.appendChild(inputbox); 
		newDiv.appendChild(buttondive);
		var currentDiv = document.getElementById("div1");
		document.body.insertBefore(newDiv, currentDiv); 
		
	}
	if(popuptype == 'confirm')
	{
		var newDiv = document.createElement("div");
		var heading = document.createElement("h2");
		var closebutton = document.createElement("a");
		var inputbox = document.createElement("input");
		var buttondive = document.createElement("div");
		var buttonoklink =  document.createElement("a");
		var buttoncancellink =  document.createElement("a");
		buttonoklink.setAttribute("href","#");
		buttonoklink.setAttribute("id","confirmOK");
		buttonoklink.innerHTML = "Ok";
		buttoncancellink.setAttribute("href","#");
		buttoncancellink.setAttribute("id","confirmCancel");
		buttoncancellink.innerHTML = "Cancel";
		buttondive.appendChild(buttonoklink);
		buttondive.appendChild(buttoncancellink);

		var heading_content = document.createTextNode(PopupHeader);
		closebutton.setAttribute("href","#");
		

		closebutton.setAttribute("id","close");
		closebutton.setAttribute("class","close");
		inputbox.setAttribute("type","text");
		inputbox.setAttribute("class","textValue");
		newDiv.setAttribute("id", "popUpConfirm");
		newDiv.setAttribute("class", "popUpDiv");
		buttondive.setAttribute("class","butttonlist");
		var newContent = document.createTextNode(Popupcontent);
		heading.appendChild(heading_content); 
		newDiv.appendChild(closebutton); 
		newDiv.appendChild(heading); 
		newDiv.appendChild(newContent); 
		newDiv.appendChild(buttondive);
		var currentDiv = document.getElementById("div1");
		document.body.insertBefore(newDiv, currentDiv); 
		
		var confirmOKbutt = document.getElementById('confirmOK');
		conformok = confirmOKbutt.addEventListener("click", function()
		{
			//findConfirm='confirmed';	
			//return true;
			var popupbox = document.getElementById(windowname);
		
			var blonkerBox = document.getElementById("blanket");
			//popupbox.style.display = 'none';
			popupbox.parentNode.removeChild(popupbox);
			blonkerBox.parentNode.removeChild(blonkerBox);
			window.open(popupurl,"_blank", "toolbar=yes, scrollbars=yes, resizable=yes, width=700, height=700");	
			
			
		});
		
		var confirmCancelbutt = document.getElementById('confirmCancel');
		confirmCancelbutt.addEventListener("click", function()
		{
			var popupbox = document.getElementById(windowname);
		
			var blonkerBox = document.getElementById("blanket");
			//popupbox.style.display = 'none';
			popupbox.parentNode.removeChild(popupbox);
			blonkerBox.parentNode.removeChild(blonkerBox);
			

			
			//return false;
		});
	}
	
	var closebutt = document.getElementById('close');
	closebutt.addEventListener("click", function()
	{
		var popupbox = document.getElementById(windowname);
	
		var blonkerBox = document.getElementById("blanket");
		//popupbox.style.display = 'none';
		popupbox.parentNode.removeChild(popupbox);
		blonkerBox.parentNode.removeChild(blonkerBox);
	}, false)
	
	
		//blanket_size(windowname, popuptype);
		//window_pos(windowname, popuptype);
		//toggle('blanket');
		//toggle(windowname, popuptype);	
	
		
}