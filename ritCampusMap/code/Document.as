package code {
	
	// Imports
	import flash.display.MovieClip;
	import flash.events.*;
	
	// UI scaling and alignment
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	// Detail view
	import flash.media.StageWebView;
	import flash.geom.Rectangle;
	
	// Device Orientation
	import flash.events.StageOrientationEvent;
	import flash.display.StageOrientation;
	
	// User Input
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	// Get XML Data
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	
	// User Location
	import flash.sensors.Geolocation;
	import flash.events.GeolocationEvent;
	import flash.events.StatusEvent;
	
	public class Document extends MovieClip {		
		// Other UI
		private var pStageWebView: StageWebView;
		
		//Data and helper objects
		private var pItemArray: Array = new Array();
		
		//Constant for displaying map
		private static const MAP_URL: String = "http://people.rit.edu/rbv7405/mobileApp/ritGoogleMap.html";
		
		//Constant for web service
		private var WEB_SERVICE_URL: String = "http://maps.rit.edu/proxySearch/?q=ice+cream&wt=xml&indent=on";
		
		//protected static const LAYOUT:XML = <search/>;
		
		//Constants for positioning the stageWebView
		private static const MARGIN: Number = 10;
		private static const TOP: Number = 44;
		private static const IPAD_WIDTH_PORTRAIT: Number = 768;
		private static const IPAD_HEIGHT_PORTRAIT: Number = 1024;
		private static const IPAD_WIDTH_LANDSCAPE: Number = 1024;
		private static const IPAD_HEIGHT_LANDSCAPE: Number = 768;
		
		private var pCurrentIndex: int = 0;
		private var pSearchTextField: TextField;
		
		// Geolocation
		private var pGeolocation: Geolocation;
		
		public function Document() 
		{			
			// constructor code
			stage.align = StageAlign.TOP;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// UI elements
			arrow.x = IPAD_WIDTH_PORTRAIT - arrow.width/2 - MARGIN;
			label.x = label.width / 2 + MARGIN;
			
			pSearchTextField = new TextField();
			pSearchTextField.type = TextFieldType.INPUT;
			pSearchTextField.x = stage.stageWidth / 2 - 300/2;
			pSearchTextField.width = 300;
			pSearchTextField.height = 25;
			pSearchTextField.y = 13;
			
			addChild( pSearchTextField );
			
			pStageWebView = new StageWebView();
			pStageWebView.stage = this.stage;
			pStageWebView.loadURL( MAP_URL );
			//pStageWebView.reload();
			pStageWebView.viewPort = new Rectangle( ( IPAD_WIDTH_PORTRAIT - IPAD_WIDTH_LANDSCAPE ) / 2,
												    TOP,
												    IPAD_WIDTH_LANDSCAPE,
												    IPAD_HEIGHT_PORTRAIT - TOP );
			
			function onPageLoaded(e: Event): void 
			{
				//pStageWebView.stop();
				pStageWebView.removeEventListener( Event.COMPLETE, onPageLoaded );
			}
			
			reload.addEventListener( MouseEvent.CLICK, reloadWebView );
			
			//Load placeholder data
			//pItemArray.push( {"label":"Ben and Jerry's","latitude":"43.083958","longitude":"-77.67448"} );
			
			// Event listeners
			pStageWebView.addEventListener( Event.COMPLETE, onPageLoaded );
			//pStageWebView.addEventListener( Event.
			arrow.addEventListener( MouseEvent.CLICK, getUserLocation );
			stage.addEventListener( StageOrientationEvent.ORIENTATION_CHANGING, doStageOrientationChange );
			stage.addEventListener( KeyboardEvent.KEY_UP, grabTextInput );
		}
		
		private function reloadWebView(e: MouseEvent): void 
		{
			trace('reload');
			pStageWebView.reload();
		}
		
		private function getUserLocation(e: MouseEvent): void 
		{
			trace("get user location");
			
			if(Geolocation.isSupported) 
			{
				//displayMessage("Geolocation is not supported!");
				pGeolocation = new Geolocation();
				pGeolocation .setRequestedUpdateInterval(1);
				//pGeolocation.addEventListener(GeolocationEvent.UPDATE, onGeoLocationUpdate, false, 0, true);
				
				//pGeolocation.addEventListener(StatusEvent.STATUS, onGeoStatusChange, false, 0, true);
				
				//if(pGeolocation.muted) //displayMessage("Geolocation is muted");
			} else
			{
				//displayMessage("Geolocation is not supported on this device :(.");
			}
		}
		
		//Zoom into the default location or the location the user inputted
		private function zoom() 
		{
			//Zoom in on location
			var currentPlace:Place = pItemArray[ pCurrentIndex ];
			var jsCommand:String = "javascript:zoomTo(" 
			+ currentPlace.Latitude + "," +
			currentPlace.Longitude + "," + 
			'\"' + currentPlace.Name + '\"' + "," + 
			'\"' + currentPlace.Description + '\"' + "," +
			'\"' + currentPlace.ImageLocation + '\"' + "," +
			'\"' + currentPlace.FullDescription + '\"' +
			")"; 
			pStageWebView.loadURL(jsCommand);
		}
		
		private function doStageOrientationChange(e:StageOrientationEvent): void 
		{
			trace( "doStageOrientationChange e.beforeOrientation = " + e.beforeOrientation );
			trace( "doStageOrientationChange e.afterOrientation = "+ e.afterOrientation );
			switch ( e.afterOrientation ) 
			{
				case StageOrientation.DEFAULT : 
				{
					break;
				} case StageOrientation.UPSIDE_DOWN : 
				{
					drawPortraitView();
					break;
				} case StageOrientation.ROTATED_RIGHT : 
				{
					break;
				} case StageOrientation.ROTATED_LEFT : 
				{
					drawLandscapeView();
					break;
				}
			}
		}
		
		private function drawPortraitView(): void 
		{
			trace( "drawPortraitView" );
			pStageWebView.viewPort = null;
			
			// Set up new UI for Portrait orientation
			pStageWebView.viewPort = new Rectangle( ( IPAD_WIDTH_PORTRAIT - IPAD_WIDTH_LANDSCAPE ) / 2,
												    TOP,
												    IPAD_WIDTH_LANDSCAPE,
												    IPAD_HEIGHT_PORTRAIT - TOP );
												   
			arrow.x = IPAD_WIDTH_PORTRAIT - arrow.width/2 - MARGIN;
			label.x = label.width / 2 + MARGIN
		}
		
		private function drawLandscapeView(): void 
		{
			trace( "drawLandscapeView" );
			
			// hide StageWebView
			pStageWebView.viewPort = null;
			
			// Set up new UI for Portrait orientation
			pStageWebView.viewPort = new Rectangle( ( IPAD_WIDTH_PORTRAIT - IPAD_WIDTH_LANDSCAPE ) / 2,
												    TOP,
												    IPAD_WIDTH_LANDSCAPE,
												    IPAD_HEIGHT_LANDSCAPE - TOP );
												   
			arrow.x = IPAD_WIDTH_LANDSCAPE - arrow.width / 2 - MARGIN;
			label.x = label.width / 2 + MARGIN
		}
		
		private function loadDataFromWebService() {
			var XMLRequest: URLRequest = new URLRequest( WEB_SERVICE_URL );
			var XMLLoader: URLLoader = new URLLoader( XMLRequest );
			XMLLoader.addEventListener( Event.COMPLETE, onXMLLoaded );	
		}
		
		private function onXMLLoaded(e: Event): void 
		{
			var xml: XML = new XML( e.target.data );
			var allDocs: XMLList = xml.result[ 0 ].doc;
			
			
				//Loop through all doc tags
				for each(var xmlFile: XML in allDocs)
				{
					//Grab values from str tags using XPath Syntax
					var description: String = xmlFile.str.( @name == 'description' ).text();
					//If the user inputs a text that has the full name of the building
					//Check to see if the description tag has the building description which will signify that
					//it is the correct building description
					if(description.substr(0,8) == "Building" && pSearchTextField.text.length > 3)
					{
						parseXML(xmlFile, description);
					}
					else if(pSearchTextField.text.length == 3)
					{
						parseXML(xmlFile, description);
					}
				}
			
	
			zoom();
		}
		
		//Generalized parsing xml based on the user's input of the entire building name or the acronym
		private function parseXML(xml:XML, description:String)
		{
			//Create a data object for each doc
			var placeData: Place;
			
			//Grab values from string tags using XPath Syntax
			var name: String = xml.str.( @name == 'name' ).text();
			var fullDescription: String = xml.str.( @name == 'full_description' ).text();
			var image: String = xml.str.( @name == 'image' ).text();
			
			//Grab values from float tags using XPath Syntax
			var latitude: String = xml.float.( @name == 'latitude' ).text();
			var longitude: String = xml.float.( @name == 'longitude' ).text();
			trace("Name: " + name + "description: " + description + "fullDescription: " + fullDescription + "image: " + image);
			//Add properties to our data object
			placeData = new Place(name, latitude, longitude, description, fullDescription, image);
			
			//Add data object to our item array
			pItemArray.push( placeData );
			//Set the current index to whatever the current search is
			pCurrentIndex = pItemArray.indexOf( placeData );
		}
		
		private function onXMLLoadError(e: Event): void 
		{
			//
		}
		
		private function grabTextInput(keyboardEvent:KeyboardEvent): void 
		{
			var textInput: String = pSearchTextField.text;
			
			
			//Process the user input once they press the enter key			
			if(keyboardEvent.keyCode == Keyboard.ENTER && pSearchTextField.text !== "") 
			{
				//Check to see if the user inputs the abbreviation of a building
				if(pSearchTextField.text.length == 3)
				{
					//Make the search uppercase
					pSearchTextField.text = pSearchTextField.text.toUpperCase();
					WEB_SERVICE_URL = "http://maps.rit.edu/proxySearch/?q=*&wt=xml&indent=on&fq=abbreviation:" + pSearchTextField.text;
				}
				else if(pSearchTextField.text.length > 3)
				{
					WEB_SERVICE_URL = "http://maps.rit.edu/proxySearch/?q=" + pSearchTextField.text + "&wt=xml&indent=on";
				}
				loadDataFromWebService();
			}
		}
		
	}
}