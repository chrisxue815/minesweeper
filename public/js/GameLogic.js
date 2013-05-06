
// when game is ready, draw this method
function ready(context, opponents)
{
	var offset_x = MineArea_x + (MineArea_width - (Mine_Size*Mine_row))/2;
	var offset_y = MineArea_y + (MineArea_height - (Mine_Size*Mine_col))/2;
	
	// display all the mines
	for(var i=0; i<Mine_row; i++)
	{
		for(var j=0; j<Mine_col; j++)
		{
			var mine = new Image();
			
			if(Math.floor(i*Mine_col + j) == Math.floor(GameState.hoverIndex)){
				mine.src = 'image/highlight.gif';
			}
			else
				mine.src = 'image/normal.gif';
				
			context.drawImage(mine, offset_x+(Mine_Size*j), offset_y+(Mine_Size*i), Mine_Size, Mine_Size);
		}
	}
	
	// display all the opponents
	for(var opponent in opponents)
	{
		var oppBack = new Image();
		oppBack.src = 'image/opponentBack.gif';
		context.drawImage(oppBack, 30, 30 + 150*opponent, 120, 100);
		
		var oppPro = new Image();
		oppPro.src = 'image/opponentProcess.gif';
		context.drawImage(oppPro, 31, 31 + 150*opponent, 118, 98);
		
		// display opponent's name
		context.fillStyle = 'black';
		context.font = '20px Arial';
		if(opponents[opponent].name.length>15)
			opponents[opponent].name = opponents[opponent].name.substring(0,12)+"...";
		context.fillText(opponents[opponent].name, 20, 150 + 150*opponent);
		
		// whether he is ready
		if(opponents[opponent].ready)
			context.fillText("Ready!", 50, 80 + 150*opponent);
		
		else
			context.fillText("Not Ready", 40, 80 + 150*opponent);
	}
}

// when the game is counting down to start
function counting(context)
{
		if(GameState.Counting>=0)
		{
			var countImg = new Image();
			countImg.src = "image/"+GameState.Counting+".gif";
			context.drawImage(countImg, 400, 200, 100, 100);
		}
}

// when the game is playing
function playing(context, opponents, mines)
{
	$("#TimeSpent").html("Time Spent: "+GameState.Counting+" secs.");
	var offset_x = MineArea_x + (MineArea_width - (Mine_Size*Mine_row))/2;
	var offset_y = MineArea_y + (MineArea_height - (Mine_Size*Mine_col))/2;
	
	for(var i=0; i<Mine_row; i++)
	{
		for(var j=0; j<Mine_col; j++)
		{
			var mine = new Image();
			var _value = mines[i*Mine_col+j];
			if(_value==-2)
			{
				if(Math.floor(i*Mine_col + j) == Math.floor(GameState.hoverIndex)){
					mine.src = 'image/highlight.gif';
				}
				else
					mine.src = 'image/normal.gif';
			}
			else if(_value==-1)
			{
				mine.src = 'image/flag.gif';
			}
			else if(_value>=0 && _value<=9)
			{
				mine.src = "image/"+_value+".gif";
			}
			context.drawImage(mine, offset_x+(Mine_Size*j), offset_y+(Mine_Size*i), Mine_Size, Mine_Size);
		}
	}
	
	for(var opponent in opponents)
	{
		var oppBack = new Image();
		oppBack.src = 'image/opponentBack.gif';
		context.drawImage(oppBack, 30, 30 + 150*opponent, 120, 100);
		
		var oppPro = new Image();
		oppPro.src = 'image/opponentProcess.gif';
		context.drawImage(oppPro, 31, 31 + 150*opponent + 98 - 98*opponents[opponent].num_opened/216, 118, 98*opponents[opponent].num_opened/216);
		
		context.fillStyle = 'black';
		context.font = '20px Arial';
		
		if(opponents[opponent].name.length>15)
			opponents[opponent].name = opponents[opponent].name.substring(0,12)+"...";
		context.fillText(opponents[opponent].name, 20, 150 + 150*opponent);
		
		context.fillText(Math.round((opponents[opponent].num_opened/216)*100)+"%", 60, 80 + 150*opponent);
		
	}
}

// set ready or cancel
function toggleReady()
{
	if(GameState.status!=0)
	{
		alert("Game Already Start!");
		return;
	}
	
	var _data = {ready:true};
	if(me.ready)
	{
		_data.ready=false;
		me.ready = false;
	}
	else
	{
		me.ready = true;
	}
		
	$.ajax({ 
		type:"put",
		dataType:"json",
		data:_data,
		url:"/apiv1/rooms/current"
	});
}


function gameQuit()
{
	var quitFlag = window.confirm("Are you sure to quit the game?"); 
	
	if (quitFlag) { 
		$.ajax({ 
			type:"delete",
			url:"/apiv1/rooms/current"
		});
		roomListInit();
	}
}

// when the game starts, the system first open a block automatically
function firstOpen(mines)
{
	$.ajax({ 
			type:"get",
			contentType:"text/json",
			dataType:"text",
			url:"/apiv1/games/current",
			success:function(data){		
				var _list = JSON.parse(data);
				for(var mineItem in _list)
				{
					var _x = _list[mineItem].x;
					var _y = _list[mineItem].y;
					var _value = _list[mineItem].value;
					mines[_y*Mine_col + _x] = _value;	
				}
			},
			error:function(a,b,c){
			}
		});
}

// restart all the blocks
function restart()
{
	for(var i=0; i<Mine_row; i++)
	{
		for(var j=0; j<Mine_col; j++)
		{
			mines[i*Mine_col + j] = -2;
		}
	}
	$("#TimeSpent").html("");
	
	$.ajax({ 
			type:"get",
			contentType:"text/json",
			dataType:"text",
			url:"/apiv1/rooms/last",
			success:function(data){		
				
				var _lastRoomInfo = JSON.parse(data);
				
				if(_lastRoomInfo.me.num_opened==216)
				{
					win();
				}
				else
				{
					var _users = _lastRoomInfo.users;
					for(var _user in _users)
					{
						if(_users[_user].num_opened==216)
						{
							lose(_users[_user].name);
						}
					}
				}
			},
			error:function(a,b,c){
			}
		});
}

function win()
{
	alert("Congratulations! You win!");
	GameState.status=0;
}

function lose(winnerName)
{
	alert("Sorry, You lose!  The winner is "+winnerName+".");
	GameState.status=0;
}


// left click on the block to open it
function open(_x,_y)
{
	var _data = {operation:"open", x:_y, y:_x};
	
	$.ajax({ 
		type:"put",
		dataType:"text",
		data:_data,
		url:"/apiv1/games/current",
		success:function(data){		
				
				var _list = JSON.parse(data);
				
				for(var mineItem in _list)
				{
					var _x = _list[mineItem].x;
					var _y = _list[mineItem].y;
					var _value = _list[mineItem].value;
					mines[_y*Mine_col + _x] = _value;
					
					// if it is a mine, call bomb method
					if(_value == "mine")
					{
						mines[_y*Mine_col + _x] = 9;
						bomb();
						return;
					}
				}
				GameState.IsLocking=false;
			},
			error:function(a,b,c){
				GameState.IsLocking=false;
			}
	});
}

// right click on the block, to sign or unsign it
function sign(_x,_y)
{
	var _data = {operation:"mark", x:_y, y:_x};
	if(mines[_x*Mine_col + _y] == -1)
	{
		mines[_x*Mine_col + _y] = -2;
		_data.operation = 'unmark';
	}
	else
	{
		mines[_x*Mine_col + _y] = -1;
	}
		
	$.ajax({ 
		type:"put",
		dataType:"json",
		data:_data,
		url:"/apiv1/games/current"
	});
}

// when click on a mine, call it
function bomb()
{
	alert("Sorry, you click the mine! Restart Again!");
	for(var i=0; i<Mine_row; i++)
	{
		for(var j=0; j<Mine_col; j++)
		{
			mines[i*Mine_col + j] = -2;
		}
	}
	firstOpen(mines);
	GameState.IsLocking=false;
}


