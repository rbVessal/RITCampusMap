package code {
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*;
	
	public class Fetcher extends EventDispatcher{
		private var pXMLLoader:URLLoader;
		private var pURL:String;
		
		public function Fetcher() {
			trace(this + " Constructor called");
		}
		
		public function get url():String{return pURL;}
		
		public function loadXML(urlToDownload:String){
			trace(this + " loadXML() called with urlToDownload=" + urlToDownload);
			pURL = urlToDownload;
			
			// Create pLoader and request and set callback for when XML is loaded
			pXMLLoader = new URLLoader();
			
			// set up event listeners with weak references
			//pXMLLoader.addEventListener(Event.COMPLETE,onXMLLoaded,false,0,true);
			//pXMLLoader.addEventListener(IOErrorEvent.IO_ERROR,onXMLLoadError,false,0,true);
			
			// create a request and load the file
			var request:URLRequest = new URLRequest(urlToDownload);
			trace(request.data);
			pXMLLoader.load(request);
		}
		
		
		private function onXMLLoaded(e:Event){
			trace(this + " onXMLLoaded() called");
			var xml:XML = new XML(e.target.data);
			//trace(this + "onXMLLoaded() - xml=" + xml);
			// Tell Document we're done loading this XML file
			//dispatchEvent(new CustomEvent(CustomEvent.LOAD_COMPLETE,xml));
			destroy();
			
		} // end onXMLLoaded
		
		private function onXMLLoadError(e:Event){
			trace(this + " onXMLLoadError() e=" + e);
			//dispatchEvent(new CustomEvent(CustomEvent.LOAD_ERROR,e));
			destroy();
		}
		
		public function destroy(){
			// clean up and hopefully trigger garbage collection once the Fetcher object goes away
			pXMLLoader = null;
			pURL = null;
		}

	}
	
}
