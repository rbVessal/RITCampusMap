/*
We need this CustomEvent class because Fetcher wants to send each
XML file back to the Document once the file has loaded.
A standard Event object can only send an event, but not any additional data.

The pData instance variable holds the data for us.
*/

package code
{
	import flash.events.Event;

	public class CustomEvent extends Event
	{
		private var pData:*;
		
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const LOAD_ERROR:String = "loadError";
		
		public function get data():* 
		{ 
			return pData;
		}
		
		public function CustomEvent(type:String, data:*)
		{
			pData = data;
			super(type);
		}
		
	}
}