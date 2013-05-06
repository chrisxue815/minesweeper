
// room list page init method
function roomListInit()
{
	$("#RoomList").show();
	$("#RoomCanvas").hide();
	window.clearInterval(GameLoopInterval);
	window.clearInterval(GameInfoLoopInterval);
	RoomListInterval = setInterval(roomListLoop,1000);
}


// run loop every second to get the rooms' list
function roomListLoop()
{
	$.ajax({ 
			type:"get",
			contentType:"text/json",
			dataType:"text",
			url:"/apiv1/rooms",
			success:function(data){		
				
				var _list = JSON.parse(data);
				
				$("#RoomListInfo").html('');
				if(_list.length==0)
				{
					$("#RoomListInfo").html('No Room Existing, You can create one.');
				}
				for(var roomItem in _list)
				{
					var _id = _list[roomItem].id;
					var _num_users = _list[roomItem].num_users;
					$("#RoomListInfo").append(
						"<li class='RoomInfoListCell'>"+
						"<span class='RoomInfoListCellItem ui-icon ui-icon-arrowthick-2-n-s'></span>"+
						"<span class='RoomInfoListCellItem' style='margin-left:10px;'>Room "+_id+"</span>"+
						"<span class='RoomInfoListCellItem' style='margin-left:200px;'>Player "+_num_users+"/2</span>"+
						"<button class='RoomInfoListCellItem' style='margin-left:350px;' onclick='gotoRoom("+_id+")'>Enter</button>"+
						"</li>");
				}
			},
			error:function(a,b,c){
			}
		});
}

// go to a room
function gotoRoom(roomID)
{
	var _data = {id:roomID};
	
	$("#loading").show();
	$.ajax({ 
			type:"post",
			dataType:"text",
			data:_data,
			url:"/apiv1/rooms",
			success:function(data){	
				
				var _result = JSON.parse(data);
				if(_result.result=="succeeded")
				{
					gamePageInit();
				}
				else
				{
					
				}
				
				$("#loading").hide();
			},
			error:function(a,b,c){
				$("#loading").hide();
				
			}
		});
}

//create a room
function createRoom()
{
	$("#loading").show();
	$.ajax({ 
			type:"post",
			contentType:"text/json",
			dataType:"text",
			url:"/apiv1/rooms",
			success:function(data){		
				var _result = JSON.parse(data);
				if(_result.result=="succeeded")
				{
					gamePageInit();
				}
				
				$("#loading").hide();
			},
			error:function(a,b,c){
				$("#loading").hide();
			}
		});
}