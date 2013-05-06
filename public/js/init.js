// canvas data
var canvas, context;

// intervals
var RoomListInterval, GameLoopInterval, GameInfoLoopInterval;

// first init function
function init()
{
	// setup canvas
	canvas = document.getElementById('myCanvas');
	context = canvas.getContext('2d');
	GameState.hoverIndex=-1;
	
	$("#loading").hide();
	
	// bind mouse events
	document.addEventListener('mousemove', mousemove, false);
	document.addEventListener('mouseup', mouseup, false);
	document.addEventListener('dblclick', dblclick, false);
	document.oncontextmenu = new Function("return false;")
	
	// start room list page
	roomListInit();
}

// mouse move event handler
function mousemove(e)
{
	var offset_X = e.clientX-$('#myCanvas').position().left+window.pageXOffset
									- MineArea_x - (MineArea_width - (Mine_Size*Mine_col))/2;
	var offset_Y = e.clientY-$('#myCanvas').position().top+window.pageYOffset
									- MineArea_y - (MineArea_height - (Mine_Size*Mine_row))/2;	
	
	// highlight the block mouse over
	if(offset_X>=0 && offset_X<Mine_Size*Mine_col && offset_Y>=0 && offset_Y<Mine_Size*Mine_row)
	{
		GameState.hoverIndex = Math.floor(offset_Y/Mine_Size)*Mine_col + Math.floor(offset_X/Mine_Size);
	}
	else
	{
		GameState.hoverIndex=-1;
	}
}

// mouse up event handler
function mouseup(e)
{
	if(GameState.status==2 && !GameState.IsLocking)
	{
		var offset_X = e.clientX-$('#myCanvas').position().left+window.pageXOffset
									- MineArea_x - (MineArea_width - (Mine_Size*Mine_col))/2;
		var offset_Y = e.clientY-$('#myCanvas').position().top+window.pageYOffset
									- MineArea_y - (MineArea_height - (Mine_Size*Mine_row))/2;
									
		if(offset_X<0 || offset_X>=Mine_Size*Mine_col || offset_Y<0 || offset_Y>=Mine_Size*Mine_row)
		{
			return;
		}
		var _x = Math.floor(offset_Y/Mine_Size);
		var _y = Math.floor(offset_X/Mine_Size);
		
		// right click to mark the block
		if(e.button==2 && mines[_x*Mine_col + _y] < 0)
		{
			oncontextmenu='return false';
			sign(_x,_y);
		}
		
		// left click to open the block
		else if(e.button==0 && mines[_x*Mine_col + _y] == -2)
		{
			GameState.IsLocking=true;
			open(_x,_y);
		}
	}
}

// double click event handler
function dblclick(e)
{
	// open the mines around the clicked block
	if(GameState.status==2 && !GameState.IsLocking)
	{
		var offset_X = e.clientX-$('#myCanvas').position().left+window.pageXOffset
									- MineArea_x - (MineArea_width - (Mine_Size*Mine_col))/2;
		var offset_Y = e.clientY-$('#myCanvas').position().top+window.pageYOffset
									- MineArea_y - (MineArea_height - (Mine_Size*Mine_row))/2;
		var _x = Math.floor(offset_Y/Mine_Size);
		var _y = Math.floor(offset_X/Mine_Size);
	
		GameState.IsLocking=true;
		open(_x,_y);
	}
}

// call first init function
window.onload = init;
