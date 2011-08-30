package lobby.responses
{
	import com.smartfoxserver.v2.core.SFSEvent;

	public class CreateRoomResponse extends ServerResponseHandler
	{
		public static const CREATE_ROOM:String = "create_room";
		
		override public function handleServerResponse(event:SFSEvent):void {
			
		}
	}
}