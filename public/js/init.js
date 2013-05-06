var canvas, context;

var RoomListInterval, GameLoopInterval, GameInfoLoopInterval;

function init()
{
	canvas = document.getElementById('myCanvas');
	context = canvas.getContext('2d');
	GameState.hoverIndex=-1;
	
	$("#loading").hide();
	document.addEventListener('mousemove', mousemove, false);
	document.addEventListener('mouseup', mouseup, false);
	document.addEventListener('dblclick', dblclick, false);
	document.oncontextmenu = new Function("return false;")
	roomListInit();
}



function mousemove(e)
{
	var offset_X = e.clientX-$('#myCanvas').position().left+window.pageXOffset
									- MineArea_x - (MineArea_width - (Mine_Size*Mine_col))/2;
	var offset_Y = e.clientY-$('#myCanvas').position().top+window.pageYOffset
									- MineArea_y - (MineArea_height - (Mine_Size*Mine_row))/2;					
	if(offset_X>=0 && offset_X<Mine_Size*Mine_col && offset_Y>=0 && offset_Y<Mine_Size*Mine_row)
	{
		GameState.hoverIndex = Math.floor(offset_Y/Mine_Size)*Mine_col + Math.floor(offset_X/Mine_Size);
	}
	else
	{
		GameState.hoverIndex=-1;
	}
}
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
		
		if(e.button==2 && mines[_x*Mine_col + _y] < 0)
		{
		
			oncontextmenu='return false';
			sign(_x,_y);
		}
		else if(e.button==0 && mines[_x*Mine_col + _y] == -2)
		{
			GameState.IsLocking=true;
			open(_x,_y);
		}
		
	}
}
function dblclick(e)
{
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
window.onload = init;
