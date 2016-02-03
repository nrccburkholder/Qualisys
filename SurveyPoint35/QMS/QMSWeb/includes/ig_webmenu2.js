/* 
Infragistics Hierarchical Menu Script 
Version 2.0.5000.103
Copyright (c) 2002 Infragistics, Inc. All Rights Reserved.
Comments:
Functions marked public are for use by developers and are documented and supported.
Functions marked private are for the internal use of the UltraWebTree component and are not 
documented for use by developers and are not supported for use by developers
*/

var ig_menuTree;
var ig_currentMenu;
var ig_currentItem;
var ig_menuPopup = null;
var ig_IE;

// public - Obtains a menu Item object using its id
function igmenu_getItemById(itemId) 
{
	var item=igmenu_getElementById(itemId);
	if(!item)
		return null;
	return new igmenu_initItem(item);
}

// public - Obtains a menu object using its id
function igmenu_getMenuById(menuId) 
{
	return igmenu_menuState[menuId];
}

// public - returns the menu object for the Item Id
function igmenu_getMenuByItemId(itemId) {
	var mn = igmenu_getMenuNameByItemId(itemId);  
	return igmenu_menuState[mn];
}

// public - returns the Menu Name (mn) from an itemId
function igmenu_getMenuNameByItemId(itemId) {
   var menuName = itemId;
   var strArray = menuName.split("_");
   menuName = strArray[0];
   return menuName;
}

// public
function igmenu_linkTo(targetUrl, targetFrame) {

	if(targetUrl.indexOf("javascript") != -1)
	    eval(targetUrl);
	else
	if(targetFrame != null){
		if(igmenu_getElementById(targetFrame) != null) {
			igmenu_getElementById(targetFrame).src = targetUrl;
		}
		else
		if(eval("parent.frames."+targetFrame) != null) {
		   eval("parent.frames."+targetFrame+".location=\""+targetUrl+"\";");
		}
		else {
		   window.open(targetUrl);
		}
	}
	else
	{
	    location.href = targetUrl;
	}
}

// public - Retrieves an element by its tag name in a browser independant way
function igmenu_getElementById(tagName) {
	if(ig_IE)
		return document.all[tagName];
	else
		return document.getElementById(tagName);
}

// Warning: Private functions for internal component usage only
// The functions in this section are not intended for general use and are not supported
// or documented.


// private - Fires an event to client-side script and then to the server is necessary
function igmenu_fireEvent(mn,eventObj,eventString)
{
	var ms=igmenu_menuState[mn];
	var result=false;
	if(eventObj[0]!="")
		result=eval(eventObj[0]+eventString);
	if(ms.MenuLoaded && result!=true && eventObj[1]==1 && !ms.CancelPostBack)
		ms.NeedPostBack=true;
	ms.CancelPostBack=false;
	return result;
}

// private - Performed on page initialization
function igmenu_initialize() {
	ig_IE = (document.all) ? true : false;
	document.onmousedown = function() { igmenu_mouseDown(); }
	document.onmouseup   = function() { igmenu_mouseUp();  }
	ig_currentMenu = null;
	ig_menuTree = null;
	ig_currentItem = null;
	ig_menuPopup = null;
}

var igmenu_menuState=[];
var igmenu_dropDowns;

// private - initializes the menu object on the client
function igmenu_initMenu(menuId) {
   var menuElement = igmenu_getElementById(menuId+"_MainM");
   var menu = new igmenu_menu(menuElement,eval("igmenu_"+menuId+"_Menu"));
   igmenu_menuState[menuId] = menu;
   igmenu_fireEvent(menuId,menu.Events.InitializeMenu,"(\""+menuId+"\");");
   
   if(menu.HideDropDowns==true && igmenu_dropDowns==null) {
		igmenu_dropDowns = document.all.tags("SELECT");
   }
   
   menu.MenuLoaded=true;
   return menu;
}

// private - constructor for the menu object
function igmenu_menu(menuElement,menuProps) {
	this.MenuId = menuElement.id;
	this.MenuElement = menuElement;
	this.UniqueId=menuProps[0];
	this.MenuTarget=menuProps[1];
	this.WebMenuStyle=menuProps[2];
	this.HoverClass=menuProps[4];
	this.TopSelectedClass=menuProps[5];
	
	this.ExpandEffects = new igmenu_expandEffects(menuProps[8], menuProps[9], menuProps[10], menuProps[11], menuProps[12], menuProps[13]);
	this.CheckedImage=menuProps[14];
	this.UncheckedImage=menuProps[15];
	this.HideDropDowns=menuProps[16];
	this.getClientUniqueId = igmenu_getClientUniqueId;

	var uniqueId = this.getClientUniqueId();
	this.Events=new igmenu_events(eval("igmenu_"+uniqueId+"_Events"));
	this.MenuLoaded=false;
	this.NeedPostBack=false;
	this.CancelPostBack=false;
	this.TopHoverStarted=false;
}

// private - event initialization for menu object
function igmenu_events(events)
{
	this.InitializeMenu=events[0];
	this.ItemCheck=events[1];
	this.ItemClick=events[2];
	this.SubMenuDisplay=events[3];
	this.ItemHover=events[4];
}

// private - event initialization for menu object
function igmenu_expandEffects(duration, opacity, type, shadowColor, shadowWidth, delay)
{
	this.Duration=duration;
	this.Opacity=opacity;
	this.Type=type;
	this.ShadowColor=shadowColor;
	this.ShadowWidth=shadowWidth;
	this.Delay=delay;
}

// private - 1.0 compatibility function for hiding select boxes
var igmenu_displayMenu = null;
function igmenu_callDisplayMenu(bShow, id) {
	if(igmenu_displayMenu != null)
		igmenu_displayMenu(bShow, id);
}

// private
function igmenu_getClientUniqueId() {
	var u = this.UniqueId.replace(/:/gi, "");
	u = u.replace(/_/gi, "");
	return u;
}

// private - hides all dropdown select controls for the document.
var ig_hidden=false;
function igmenu_hideDropDowns(bHide) { 
	 if(igmenu_dropDowns == null)
		return;
     if(bHide)
     {
		if(ig_hidden)
			return;
		ig_hidden = true;
         for (i=0; i<igmenu_dropDowns.length;i++)
                 igmenu_dropDowns[i].style.visibility='hidden';
     }
     else
     {
         for (i=0; i<igmenu_dropDowns.length;i++)
         {
                 igmenu_dropDowns[i].style.visibility='visible';
         }
         ig_hidden = false;
     }
}

// private - implements the showing and hiding of submenus
function igmenu_display(subMenu, show) {
	if(show == true) {
		var menu = igmenu_getMenuByItemId(subMenu.id);
		var duration = menu.ExpandEffects.Duration;
		duration = duration/1000;
		var opacity = menu.ExpandEffects.Opacity;
		var type = menu.ExpandEffects.Type;
		var shadowWidth = menu.ExpandEffects.ShadowWidth;
		var shadowColor = menu.ExpandEffects.ShadowColor;
		if(subMenu.style.visibility != "hidden")
			return;
		igmenu_callDisplayMenu(true, subMenu.id);
		var mn=igmenu_getMenuNameByItemId(subMenu.id);
		var ms=igmenu_getMenuByItemId(subMenu.id);
		if(igmenu_fireEvent(mn,ms.Events.SubMenuDisplay,"(\""+mn+"\",\""+subMenu.id+"\", true)"))
			return;

		if(subMenu.style.filter == null) {
			subMenu.style.visibility='visible';
			subMenu.style.display="";
		}
		else 
		if(type != 'NotSet') {
			subMenu.style.filter = "progid:DXImageTransform.Microsoft."+type+"(duration="+duration+");"
			if(shadowWidth > 0)
				subMenu.style.filter += " progid:DXImageTransform.Microsoft.Shadow(Direction=135, Strength="+shadowWidth+",color="+shadowColor+");"
			if(opacity < 100)
				subMenu.style.filter += " progid:DXImageTransform.Microsoft.Alpha(Opacity="+opacity+");"
			if(subMenu.filters[0] != null)
	        	subMenu.filters[0].apply();
			subMenu.style.visibility='visible'
			subMenu.style.display="";
			if(subMenu.filters[0] != null)
				subMenu.filters[0].play();
		}
		else {
			if(shadowWidth > 0)
				subMenu.runtimeStyle.filter = "progid:DXImageTransform.Microsoft.Shadow(Direction=135, Strength="+shadowWidth+",color="+shadowColor+");"
			if(opacity < 100)
				subMenu.runtimeStyle.filter += " progid:DXImageTransform.Microsoft.Alpha(Opacity="+opacity+");"
			subMenu.style.visibility='visible';
			subMenu.style.display="";
		}
		
		if(ig_menuPopup == subMenu) {
			return;
		}
		var screenWidth = document.body.clientWidth;
		var menuWidth = subMenu.clientWidth;
		var menuX = subMenu.offsetLeft;
		if((menuX + menuWidth) > screenWidth) {
			subMenu.style.left=screenWidth-menuWidth + document.body.scrollLeft;
		}
		var screenHeight = document.body.clientHeight;
		var menuHeight = subMenu.clientHeight;
		var menuY = subMenu.offsetTop;
		if((menuY + menuHeight) > screenHeight) {
			subMenu.style.top=screenHeight-menuHeight + document.body.scrollTop;
		}
				
	}
	else {
		igmenu_callDisplayMenu(false, subMenu.id);
		var mn=igmenu_getMenuNameByItemId(subMenu.id);
		var ms=igmenu_getMenuByItemId(subMenu.id);
		if(igmenu_fireEvent(mn,ms.Events.SubMenuDisplay,"(\""+mn+"\",\""+subMenu.id+"\", false)"))
			return;
		subMenu.style.visibility = "hidden";
		subMenu.style.display = "none";
	}
}

// private - clears all submenus from display
function igmenu_clearMenuTree(ms, menu) {
	if(menu == null) {
		menu = ig_menuTree;
		if(menu == null)
			return;
		// UnHover the top menu item
		var currentItemId = menu.getAttribute("igCurrentItem");
		if(currentItemId != null && currentItemId.length > 0) {
			igmenu_unHover(igmenu_getElementById(currentItemId));
		}
		menu.removeAttribute("igCurrentChild");
		menu.removeAttribute("igCurrentItem");
	}

	var childId = menu.getAttribute("childMenu");
	menu.removeAttribute("childMenu");
	while(childId != null && childId.length > 0) {
		var child = igmenu_getElementById(childId);
		igmenu_display(child, false);
		childId = child.getAttribute("childMenu");
		child.removeAttribute("igCurrentChild");
		child.removeAttribute("childMenu");
		var currentItemId = child.getAttribute("igCurrentItem");
		if(currentItemId != null && currentItemId.length > 0) {
			igmenu_unHover(igmenu_getElementById(currentItemId));
		}
		child.removeAttribute("igCurrentItem");
	}
	//igmenu_displayItem = null;
}

// private - clears the descendants of the passed in menu from display
function igmenu_clearDescendants(ms, menu) {
	igmenu_clearMenuTree(ms, menu);
	ig_currentMenu = menu;
}

// private - creates an internal menu tree that has the top level menu as it's first element and adds one table
// object to the chain by setting the "childMenu" attribute of the main menu to the id
// of the table that is the second link of the chain.
function igmenu_treeCreate(ms, tableItem) {
	igmenu_clearMenuTree(ms, null);
	var menuObj = igmenu_getMenuByItemId(tableItem.id);
	var menuElement = menuObj.MenuElement;
	menuElement.setAttribute("childMenu", tableItem.id);
	ig_menuTree = menuElement;
	ig_currentMenu = tableItem;
	if(ms != null) {
		if(ms.HideDropDowns)
			igmenu_hideDropDowns(true);
	}
}

// private - adds a menu to the internal menu tree
function igmenu_menuTreeAdd(subMenu) {
	ig_currentMenu.setAttribute("childMenu", subMenu.id);
	ig_currentMenu = subMenu;
}

// private - implements mouseover event handling for the menu
function igmenu_mouseover(table, evnt) {
	var e;
	if(ig_IE)
		e = event;
	else
		e = evnt;

	var item = igmenu_getTblRow(e);
	if(item == null) {
		var main = e.srcElement.getAttribute("igLevel");
		if(e.srcElement.tagName == "TABLE")
			clearCurrentMenu = false;
		if(main!=null && main.length>0)
			clearCurrentMenu = false;
		return;
	}

	var ms=igmenu_getMenuByItemId(item.id);
	if(ms == null)
		return;
	var currItemId = igmenu_getSubMenu(item).getAttribute("igCurrentItem");
	if(currItemId != null && currItemId.length > 0) {
		igmenu_unHover(igmenu_getElementById(currItemId));
	}
	
	var igSeparator = item.getAttribute("igSep");
	if(igSeparator != null && igSeparator.length > 0) {
		clearCurrentMenu = false;
		return;
	}
	
	igmenu_hover(item);
	
	ig_currentItem = item;
	var childId = item.getAttribute("igChildId");

	// Check that the child is not already being displayed.
	var currentChildId = igmenu_getSubMenu(item).getAttribute("igCurrentChild");
	if(childId != null && childId.length > 0 && childId == currentChildId) {
		igmenu_clearDescendants(ms, igmenu_getElementById(currentChildId));
		var childItemId = igmenu_getElementById(childId).getAttribute("igCurrentItem");
		if(childItemId != null && childItemId.length > 0)
			igmenu_unHover(igmenu_getElementById(childItemId));
		igmenu_getSubMenu(igmenu_getElementById(currentChildId)).removeAttribute("igCurrentChild");
		igmenu_getSubMenu(item).setAttribute("igCurrentItem", item.id);
		return;
	}
	if(childId != null) {
		var igDisabled = item.getAttribute("igDisabled");
		var igtop = item.getAttribute("igTop");
		if(igDisabled != null && igDisabled.length > 0) {
			if(igtop!=null && igtop.length > 0) {
				igmenu_clearMenuTree(ms, null);
			}
			igmenu_getSubMenu(item).setAttribute("igCurrentItem", item.id);
			return;
		}
		if(ms.MenuTarget == 1) {
			if(ms.WebMenuStyle>=2 && ms.TopHoverStarted==false && igtop!=null && igtop.length > 0) {
				return;
			}
		}

		if(ms.MenuTarget == 1 && ms.WebMenuStyle>=1 && igtop!=null && igtop.length > 0) {
			clearTimeout(igmenu_timerId);
			igmenu_displaySubMenu(ms, item, childId, 1);
		}
		else {
			if(igmenu_displayItem != item) {
				igmenu_displayItem = item;
				igmenu_displayChildId = childId;
				clearTimeout(igmenu_timerId);
				igmenu_timerId = setTimeout('igmenu_displayTimeOut()', ms.ExpandEffects.Delay);
			}

		}
		igmenu_getSubMenu(item).setAttribute("igCurrentChild", childId);
		igmenu_getSubMenu(item).setAttribute("igCurrentItem", item.id);
	}
	else {
		igmenu_clearDescendants(ms, igmenu_getSubMenu(item));
		clearTimeout(igmenu_timerId);
		igmenu_getSubMenu(item).removeAttribute("igCurrentChild");
		igmenu_getSubMenu(item).setAttribute("igCurrentItem", item.id);
		igmenu_displayItem = null;
		igmenu_getSubMenu(item).removeAttribute("igCurrentItem");
	}
}

var igmenu_timerId;
var igmenu_displayItem;
var igmenu_lastDisplayItem;
var igmenu_displayChildId;
// private - displays submenus after time expiration
function igmenu_displayTimeOut() {
	if(igmenu_displayItem == null)
		return;

	var ms=igmenu_getMenuByItemId(igmenu_displayItem.id);
	var igtop = igmenu_displayItem.getAttribute("igTop");
	if(ms.MenuTarget >= 2 && igtop != null && igtop.length > 0) {
		igmenu_displaySubMenu(ms, igmenu_displayItem, igmenu_displayChildId, 4);
	}
	else
		igmenu_displaySubMenu(ms, igmenu_displayItem, igmenu_displayChildId, 2);
	
	igmenu_displayChildId = igmenu_displayItem;
}

// private - displays submenus when and where needed
function igmenu_displaySubMenu(ms, parentItem, MenuId, type) {
	var Menu = igmenu_getElementById(MenuId);
	if(type == 1) { // Horizontal Top menu item;
		igmenu_treeCreate(ms, Menu);
		Menu.style.top = igmenu_getTopPos(parentItem)  + parentItem.offsetHeight + 1;	
		Menu.style.left = igmenu_getLeftPos(parentItem); 
		igmenu_display(Menu, true);
	}
	else
	if(type == 2) { // Sub menu item
		igmenu_clearDescendants(ms, igmenu_getSubMenu(parentItem));
		Menu.style.top = igmenu_getTopPos(parentItem);	
		Menu.style.left = igmenu_getLeftPos(parentItem) + parentItem.offsetWidth - 4; 	
		igmenu_display(Menu, true);
		igmenu_menuTreeAdd(Menu);
	}
	else
	if(type == 3) { // Popup Top menu item
		igmenu_treeCreate(ms, Menu);
		igmenu_hover(parentItem);
		Menu.style.top = igmenu_getTopPos(parentItem);	
		Menu.style.left = igmenu_getLeftPos(parentItem) + parentItem.offsetWidth; 	
		igmenu_display(Menu, true);
	}
	if(type == 4) { // Vertical top menu item;
		igmenu_treeCreate(ms, Menu);
		igmenu_hover(parentItem);
		Menu.style.top = igmenu_getTopPos(parentItem);	
		Menu.style.left = igmenu_getLeftPos(parentItem) + parentItem.offsetWidth - 4; 	
		igmenu_display(Menu, true);
	}
	ig_currentItem = parentItem;
}

// private - displays menu item using the hover styles
function igmenu_hover(item)
{
	var hoverClass = item.getAttribute("igHov");
	var topItem = item.getAttribute("igTop");
	clearCurrentMenu = false;

	var mn=igmenu_getMenuNameByItemId(item.id);
	var ms=igmenu_getMenuByItemId(item.id);
	if(igmenu_fireEvent(mn,ms.Events.ItemHover,"(\""+mn+"\",\""+item.id+"\", true)"))
		return;

	if(hoverClass == null || hoverClass.length == 0) {
		var menu = igmenu_getMenuByItemId(item.id);
		if(menu != null)
			hoverClass = menu.HoverClass;
	}
	
	if((topItem != null && topItem.length > 0) 
		&& (ms.MenuTarget == 1 && ms.WebMenuStyle >= 2 && ms.TopHoverStarted == true) && ms.TopSelectedClass.length > 0) {
			hoverClass = ms.TopSelectedClass;
			var topHover = item.getAttribute("igHov");
			if(item.className != "TopHover")
				item.setAttribute("igClass", item.className);
	}
	else
	if(item.className != null && item.className.length > 0) {
		if(hoverClass == item.className)
			return;
		item.setAttribute("igClass", item.className);
	}

	var igDisabled = item.getAttribute("igDisabled");
	if(igDisabled != null && igDisabled.length > 0) {
		hoverClass = item.className;
	}
	
	if(hoverClass.length > 0) {
	    item.className = hoverClass;
	}
	var hoverimage = item.getAttribute("ighovimage");
	if(igDisabled != null && igDisabled.length > 0) 
		return;
	if(hoverimage != null && hoverimage.length > 0) {
		var imgElem = igmenu_getImageElement(item);
		if(imgElem != null) {
			item.setAttribute("igoldhovimage", imgElem.src);
			imgElem.src=hoverimage;
		}
	}
}

// private - obtain the element containing the item image tag
function igmenu_getImageElement(item) {
	var e = item.childNodes[0].childNodes[0];
	if(e.tagName != "IMG")
		return null;
	return e;
}

// private - displays the item using non-hover styles
function igmenu_unHover(item) {
	var mn=igmenu_getMenuNameByItemId(item.id);
	var ms=igmenu_getMenuByItemId(item.id);
	if(igmenu_fireEvent(mn,ms.Events.ItemHover,"(\""+mn+"\",\""+item.id+"\", false)"))
		return;
	item.className = "";
	var prevClass = item.getAttribute("igPrevClass");
	if(prevClass == null) {
		item.className = item.getAttribute("igClass");
	}
	else {
		item.className = prevClass;
	}
	var hoverimage = item.getAttribute("igoldhovimage");
	if(hoverimage != null && hoverimage.length > 0) {
		var imgElem = igmenu_getImageElement(item);
		if(imgElem != null) {
			imgElem.src=hoverimage;
		}
	}
}

var igmenu_clearMenuId;
// private - implements mouseout event handling
function igmenu_mouseout(submenu, evnt) {
	var e;
	if(ig_IE)
		e = event;
	else
		e = evnt;
		
	ig_inMenu = false;	
	var item = igmenu_getTblRow(e);
	if(item == null) {
		return;
	}
		
	var igSeparator = item.getAttribute("igSep");
	if(igSeparator != null && igSeparator.length > 0) {
		clearCurrentMenu = true;
		if(ig_IE) {
			setTimeout('TimerExpired()', 2000);
		}
		return;
	}

	var currItemId = igmenu_getSubMenu(item).getAttribute("igCurrentItem");
	if(currItemId == null || currItemId.length == 0)
	    igmenu_unHover(item);
	clearCurrentMenu = true;
	if(ig_IE)
		igmenu_clearMenuId = setTimeout('TimerExpired()', 2000);
}

// Gets the table row object for which a TD or other element event fired.
// private - obtains the row element associated with the event
function igmenu_getTblRow(evnt) { 
	var item = igmenu_srcElement(evnt);
	while(item.tagName != "TR") {
		var attrib = item.getAttribute("igTop");
		if(item.tagName == "TD" && attrib != null && attrib.length > 0)
			return item;
		if(item.tagName == "TABLE")
			return null;
		item = item.parentNode;
	}
	if(item == null)
		alert("getTblRow Item == null");
	return item;		
}

// private - Gets the table object for which a TD or other element event fired.
function igmenu_getSubMenu(item) {
	while(item.tagName != "TABLE") {
		item = item.parentNode;
	}
	return item;
}

// private
function igmenu_getRightPos(e) {
    var x = e.offsetRight;
    var tmpE = e.offsetParent;
    while (tmpE != null) {
        x += tmpE.offsetRight;
        tmpE = tmpE.offsetParent;
    }
    return x;
}
// private
function igmenu_getLeftPos(element) {
    var x = 0;
    var parent = element;
    while (parent != null) {
        x += parent.offsetLeft;
        parent = parent.offsetParent;
        if(ig_IE)
	        if(parent!=null && parent.onselectstart==null && parent.currentStyle.left != "auto")
				break;
    }
    return x;
}
// private
function igmenu_getTopPos(element) {
    var y = 0;
    var parent = element;
    while(parent != null) {
		y += parent.offsetTop;
        parent = parent.offsetParent;
        if(ig_IE)
			if(parent!=null && parent.onselectstart==null && parent.currentStyle.top != "auto")
				break;
	}
    return y;
}

var clearCurrentMenu = true;
// private - Clears submenus at timer expiration
function TimerExpired() {
	ig_currentItem = null;
	if(clearCurrentMenu) {
		igmenu_clearMenuTree(null, null);
		clearTimeout(igmenu_timerId);
		igmenu_hideDropDowns(false);
	}
}

// private - Handles the mouse down event
function igmenu_mousedown(table, evnt) {
	var e;
	if(ig_IE)
		e = event;
	else
		e = evnt;
	var item=igmenu_getTblRow(e);
	if(item!=null) {
		ig_inMenu = true;
		var igDisabled = item.getAttribute("igDisabled");
		if(igDisabled != null && igDisabled.length > 0) {
			ig_currentItem = null;
			return;
		}
	}
	else
		return;
	var ms=igmenu_getMenuByItemId(item.id);
	if(ms == null)
		return;

	var attrib = item.getAttribute("igTop");
	if(ms.MenuTarget == 1 && ms.WebMenuStyle>=2 && attrib!=null && attrib.length > 0){
		ig_currentItem = item;
		var childId = item.getAttribute("igChildId");
		if(childId!=null && childId.length > 0) {
			var currentChildId = igmenu_getSubMenu(item).getAttribute("igCurrentChild");
			if(childId != null && childId.length > 0 && childId == currentChildId) {
				igmenu_clearMenuTree(ms, null);
				ig_startClick=false;
				ms.TopHoverStarted = false;
				igmenu_hover(item)
				return;
			}
			var oldClass = item.getAttribute("igClass");
			item.setAttribute("igPrevClass", oldClass);
			clearTimeout(igmenu_timerId);
			ms.TopHoverStarted = true;
			igmenu_hover(item)
			igmenu_displaySubMenu(ms, item, childId, 1);
			igmenu_getSubMenu(item).setAttribute("igCurrentChild", childId);
			igmenu_getSubMenu(item).setAttribute("igCurrentItem", item.id);
			return;
		}
	}
	ms.TopHoverStarted=false;
	ig_startClick = true;		
}

var	ig_startClick = false;
// private - Handles the mouse up event
function igmenu_mouseup(table, evnt) {
	var e;
	if(ig_IE)
		e=event;
	else
		e=evnt;
	var item=igmenu_getTblRow(e);
	if(item==null){return;}
	
	var igDisabled = item.getAttribute("igDisabled");
	var igTop = item.getAttribute("igTop");
	var igChildId = item.getAttribute("igChildId");
	var igUrl=item.getAttribute("igUrl");
	if(igDisabled != null && igDisabled.length > 0) 
		return;
	if(igTop == null || igTop.length > 0) 
		if(igChildId != null && igChildId.length > 0) 
			if(igUrl == null || igUrl.length == 0)
				return;

	if(ig_startClick==true){
		var mn=igmenu_getMenuNameByItemId(item.id);
		var ms=igmenu_getMenuByItemId(item.id);
		var checked=item.getAttribute("igChk");
		var checkbox=item.getAttribute("igChkBx");
		igmenu_clearMenuTree(ms, null);
		if(checkbox!=null && checkbox.length>0) {
			var bCheck=(checked != null) && (checked == '0');
			var postCommand="";
			if(igmenu_fireEvent(mn,ms.Events.ItemCheck,"(\""+mn+"\",\""+item.id+"\","+bCheck+")"))
				return;
			
			var bHorizontal;
			var bTop = item.getAttribute("igTop");
			if(bTop != null && bTop.length > 0)
				bTop = true;
			else
				bTop = false;
				
			if(ms.MenuTarget==1 && bTop)
				bHorizontal = true;
			var checkElement;
			if(bHorizontal)
				checkElement = item.childNodes[0];
			else
				checkElement = item.childNodes[0].childNodes[0];
			if(checked!=null && checked=="1") {
				bCheck=false;
				postCommand=":Uncheck";
				if(checkElement.tagName == "IMG")
					checkElement.src=ms.UncheckedImage;
				else
				if(checkElement.tagName == "SPAN")
					checkElement.innerHTML = "";
				item.setAttribute("igChk", "0");
			}
			else {
				if(checkElement.tagName == "IMG")
					checkElement.src=ms.CheckedImage;
				else
				if(checkElement.tagName == "SPAN")
					checkElement.innerHTML = "a";
				bCheck=true;
				postCommand=":Check";
				item.setAttribute("igChk", "1");
			}
			
			if(ms.NeedPostBack)	{
				__doPostBack(ms.UniqueId,item.id+postCommand);
			}
			igmenu_clearMenuTree(ms, null);
			igmenu_updateItemCheck(item.id, bCheck);
			ig_startClick=false;
			return;
		}
		if(igmenu_fireEvent(mn,ms.Events.ItemClick,"(\""+mn+"\",\""+item.id+"\")"))
			return;
		igmenu_clearMenuTree(ms, null);
		igmenu_hideDropDowns(false);
		if(ig_menuPopup != null) {
			ig_menuPopup.style.display = "none";
			ig_menuPopup.style.visibility = "hidden";
			ig_menuPopup = null;
		}
		ig_startClick=false;
		var igFrame=item.getAttribute("igFrame");
		if(igUrl!=null) {
			igmenu_linkTo(igUrl,igFrame) 
			return;
		}
		if(ms.NeedPostBack)
		{
			__doPostBack(ms.UniqueId,item.id+":MenuClick");
			return;
		}
	}
}

// private - Update internal buffer for items that are checked on or off
function igmenu_updateItemCheck(itemId, bChecked){
	var menuName = itemId;
	var strArray = menuName.split("_");
	menuName = strArray[0];
	var formControl = igmenu_getElementById(menuName);
	if(formControl == null)
		return;
	var menuState = formControl.value;

	var newValue;
	var oldValue;
	if(bChecked)
	{
		oldValue = "0";
		newValue = "1";
	}
	else
	{
		oldValue = "1";
		newValue = "0";
	}
	var oldString = itemId + ":Chck=" + oldValue + "<%;";
	var newString = itemId + ":Chck=" + newValue + "<%;";
	if(menuState.search(oldString) >= 0)
		menuState = menuState.replace(oldString, newString);
	else {
	oldString = itemId + ":Chck=" + newValue + "<%;";
	if(menuState.search(oldString) >= 0){
			menuState = menuState.replace(oldString, newString);
		}
		else
			menuState += newString;
	}
	formControl.value = menuState; 
}

var ig_inMenu=false;
// private - Handles the mouse down event
function igmenu_mouseDown() {
	if(ig_inMenu == true) {
		return;		
	}
	
	var ms = null;
	if(ig_currentItem != null) {
		var ms = igmenu_getMenuByItemId(ig_currentItem.id);
		ms.TopHoverStarted=false;
	}
	ig_startClick = false;
	ig_inMenu = false;		
	if(ig_menuPopup != null) {
		igmenu_clearMenuTree(ms, null);
		ig_menuPopup.style.visibility = 'hidden';
		ig_menuPopup = null;
		igmenu_hideDropDowns(false);
	}
	else {
		igmenu_clearMenuTree(ms, null);
		igmenu_hideDropDowns(false);
	}
}

// private - Handles the mouse up event
function igmenu_mouseUp() {
	return;
}

// private - Handles mouse selection for the menu
function igmenu_selectStart() {
	window.event.cancelBubble = true; 
	window.event.returnValue = false; 
	return false;	
}

// private - Displays a submenu in the appropriate position
function igmenu_showMenu(name, evnt) {
	var item = igmenu_getElementById(name + "_MainM");
	if(evnt == null)
		evnt = window.event;
	if(item != null) {
		if(ig_IE) {
			item.style.top = evnt.y - 2 + document.body.scrollTop;	
			item.style.left = evnt.x - 2 + document.body.scrollLeft;
		}
		else {
			item.style.top = evnt.clientY - 2 + document.body.scrollTop;	
			item.style.left = evnt.clientX -2 + document.body.scrollLeft;
		}
		ig_menuPopup = item;
		igmenu_display(item, true);
		ig_currentItem = item;
	}
}

// private - Obtains the proper source element in relation to an event
function igmenu_srcElement(evnt)
{
	var se
	if(evnt.target)
		se=evnt.target;
	else if(evnt.srcElement)
		se=evnt.srcElement;
	while(se && !se.tagName)
		se=se.parentNode;
	return se;
}

// private - Initializes an Item object with properties and method references
function igmenu_initItem(item)
{
	this.element=item;
	this.getElement=igmenu_getElement;
	this.getText=igmenu_getText;
	this.setText=igmenu_setText;
	this.getTag=igmenu_getTag;
	this.setTag=igmenu_setTag;
	this.getHoverClass=igmenu_getHoverClass;
	this.setHoverClass=igmenu_setHoverClass;
	this.getEnabled=igmenu_getEnabled;
	this.setEnabled=igmenu_setEnabled;
	this.getTargetFrame=igmenu_getTargetFrame;
	this.setTargetFrame=igmenu_setTargetFrame;
	this.getTargetUrl=igmenu_getTargetUrl;
	this.setTargetUrl=igmenu_setTargetUrl;
	this.getNextSibling=igmenu_getItemNextSibling;
	this.getPrevSibling=igmenu_getItemPrevSibling;
	this.getFirstChild=igmenu_getItemFirstChild;
	this.getParent=igmenu_getItemParent;
	this.getItems=igmenu_getItemItems;
	this.setChecked=igmenu_setChecked;
	this.getChecked=igmenu_getChecked;
}

// private
function igmenu_getElement() {
	return this.item;
}
// private
function igmenu_getText() {
	if(this.element.tagName == "TR")
		return this.element.childNodes[1].innerHTML;
	else
		return this.element.innerHTML;
}
// private
function igmenu_setText(text) {
	if(this.element.tagName == "TR")
		this.element.childNodes[1].innerHTML = text;
	else
		this.element.innerHTML = text;
}
// private
function igmenu_getTag() {
	var a = this.element.getAttribute("igTag");
	if(a!=null && a.length>0)
		return a;
	else
		return null;
}
// private
function igmenu_setTag(text) {
	this.element.setAtribute("igTag", text);
}
// private
function igmenu_getHoverClass() {
	return this.element.getAttribute("HoverClass")
}
// private
function igmenu_setHoverClass(hoverClass) {
	this.element.setAttribute("HoverClass", hoverClass)
}
// private
function igmenu_getEnabled() {
	return(this.element.getAttribute("nodeDisabled")?false:true);
}
// private
function igmenu_setEnabled(enabled) {
	if(enabled) {
		this.element.removeAttribute("nodeDisabled");
	}
	else {
		this.element.setAttribute("nodeDisabled", "1");
	}
}
// private
function igmenu_getTargetFrame() {
	return(this.element.getAttribute("igFrame")?this.element.getAttribute("igFrame"):"");
}
// private
function igmenu_setTargetFrame(frame) {
	this.element.setAttribute("igFrame", frame)
}
// private
function igmenu_getTargetUrl() {
	return(this.element.getAttribute("igUrl")?this.element.getAttribute("igUrl"):"");
}
// private
function igmenu_setTargetUrl(url) {
	this.element.setAttribute("igUrl", url)
}
// private
function igmenu_setChecked(bChecked) {
	var ms=igmenu_getMenuByItemId(this.element.id);
	var item = this.element;
	var checkbox=item.getAttribute("igChkBx");
	if(checkbox==null && checkbox.length==0) 
		return;

	if(!bChecked) {
		var checkElement = item.childNodes[0].childNodes[0];
		if(checkElement.tagName == "IMG")
			checkElement.src=ms.UncheckedImage;
		else
		if(checkElement.tagName == "DIV")
			checkElement.innerHTML = "";
		item.setAttribute("igChk", "0");
	}
	else {
		item.setAttribute("igChk", "1");
	}
	igmenu_updateItemCheck(this.element.id, bChecked);
}
// private
function igmenu_getChecked(bChecked) {
	var item = this.element;
	var checked=item.getAttribute("igChk");
	var checkbox=item.getAttribute("igChkBx");
	if(checkbox!=null && checkbox.length>0) 
		if(checked!=null && checked.length>0) 
			return true;
	return false;			
}
// private - Implements GetNextSibling for the Item object
function igmenu_getItemNextSibling()
{
	var item = this.element.nextSibling;
	if(item)
		item=igmenu_getItemById(item.id);
	return item;
}

// private - Implements GetPrevSibling for the Item object
function igmenu_getItemPrevSibling()
{
	var item = this.element.prevSibling;
	if(item)
		item=igmenu_getItemById(item.id);
	return item;
}

// private
function igmenu_getItemFirstChild()
{
	var item=null;
	item=igmenu_getItemById(this.element.id+"_1");
	return item;
}

// private
function igmenu_getItemParent()
{
	var item=null;
	var itemName=this.element.id.split("_")
	if(itemName.length>1)
	{
		var parentName=this.element.id.substr(0,this.element.id.length-itemName[itemName.length-1].length-1);
		item=igmenu_getItemById(parentName);
	}
	return item;
}

// private
function igmenu_getItemItems()
{
	var itemAr=new Array();
	var itemCount=0;
	var item=this.GetFirstChild();
	while(item)
	{
		itemAr[itemCount++]=item;
		item=item.GetNextSibling();
	}
	return itemAr;
}

igmenu_initialize();
