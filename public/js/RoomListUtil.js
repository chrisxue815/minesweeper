
function roomListInit()
{
	$("#RoomList").show();
	$("#RoomCanvas").hide();
	window.clearInterval(GameLoopInterval);
	window.clearInterval(GameInfoLoopInterval);
	RoomListInterval = setInterval(roomListLoop,1000);
}

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
				for(var roomItem in _list)
				{
					var _id = _list[roomItem].id;
					var _num_users = _list[roomItem].num_users;
					$("#RoomListInfo").append(
						"<li class='RoomInfoListCell'>"+
						"<span class='RoomInfoListCellItem ui-icon ui-icon-arrowthick-2-n-s'></span>"+
						"<span class='RoomInfoListCellItem' style='margin-left:10px;'>Room "+_id+"</span>"+
						"<span class='RoomInfoListCellItem' style='margin-left:150px;'>Player "+_num_users+"/2</span>"+
						"<button class='RoomInfoListCellItem' style='margin-left:250px;' onclick='gotoRoom("+_id+")'>Enter</button>"+
						"</li>");
				}
			},
			error:function(a,b,c){
			}
		});
}

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