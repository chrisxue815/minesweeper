var mines;
var opponents;
var me;
var MineArea_x=280;
var MineArea_y=0;
var MineArea_width=500;
var MineArea_height=500;
var Mine_row = 16;
var Mine_col = 16;
var Mine_Signed = 0;
var Mine_Size = 30;
var Mine_Count = 40;

var background;

// game page init method
function gamePageInit()
{
	$("#RoomList").hide();
	$("#RoomCanvas").show();
	
	mines = new Array();
	for(var i=0; i<Mine_row; i++)
	{
		for(var j=0; j<Mine_col; j++)
		{
			mines[i*Mine_col + j] = -2;
		}
	}
	
	opponents = new Array();
	
	GameState.status = 0;
	
	window.clearInterval(RoomListInterval);
	GameLoopInterval = setInterval(gameLoop,25);
	GameInfoLoopInterval = setInterval(gameInfoLoop,1000);
}


// game info loop, run every second to get the room's information
function gameInfoLoop()
{
	$.ajax({ 
			type:"get",
			contentType:"text/json",
			dataType:"text",
			url:"/apiv1/rooms/current",
			success:function(data){		
				
				var _roomInfo = JSON.parse(data);
				
				if(_roomInfo.state == "waiting")
				{	
					// if the game is back to waiting, restart the game
					if(GameState.status==2)
					{
							restart();
					}
					GameState.status=0;
				}
				else if(_roomInfo.state == "running")
				{
					if(_roomInfo.time_played<0)
					{
						GameState.status=1;
						GameState.Counting = -Math.floor(_roomInfo.time_played);
					}
					else if(Math.floor(_roomInfo.time_played)==0 && GameState.status==1)
					{
						firstOpen(mines);
						GameState.status=2;
					}
					else
					{
						GameState.Counting = Math.floor(_roomInfo.time_played);
						GameState.status=2;
					}
				}
				$("#GameUserName").html("Hello: "+_roomInfo.me.name);
				$("#GameRoomID").html("Room: "+_roomInfo.id);
				me = _roomInfo.me;
				if(me.ready)
				{
					$("#readyBtn").html("Cancel");
				}
				else
				{
					$("#readyBtn").html("Ready");
				}
				opponents = new Array();
				for(var opponent in _roomInfo.users)
				{
					var _name = _roomInfo.users[opponent].name;
					var _ready = _roomInfo.users[opponent].ready;
					
					if(_name)
					{
						opponents.push(_roomInfo.users[opponent]);
					}
				}
			},
			error:function(a,b,c){
			}
		});
}

// run game loop to draw 
function gameLoop()
{
	context.save(); 
	
	background = new Image();
	background.src = 'image/background.gif';
	
	context.drawImage(background, MineArea_x, MineArea_y, MineArea_width, MineArea_height);
	
	context.drawImage(background, 0, MineArea_y, 200, MineArea_height);
	
	if(GameState.status==0)
	{
		ready(context, opponents);
		
	}
	else if(GameState.status==1)
	{
		ready(context, opponents);
		counting(context);
	}
	else if(GameState.status==2)
	{
		playing(context, opponents, mines);
	}
	context.restore();
}

// Game State infos
function GameState()
{
	GameState.status=0;
	GameState.Counting=0;
	GameState.hoverIndex=-1;
	GameState.IsLocking=false;
}