package lobby.responses
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	
	import flash.external.ExternalInterface;

	public class CreateRoomResponse extends ServerResponseHandler
	{
		public static const CREATE_ROOM:String = "create_room";
		
		override public function handleServerResponse(event:SFSEvent):void {
			var object:SFSObject = event.params.params as SFSObject;
			
			ExternalInterface.call("start_match", object.getUtfString("room"));
		}
	}
}