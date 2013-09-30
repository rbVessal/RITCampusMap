package code 
{
	//@author: Rebecca Vessal
	//Professor Jefferson
	//Mobile Game and Web App Seminar
	//Date: 4/16/2012
	//
	//Place.as
	//
	//Place.as contains information about the building that the user currently searched for	
	
	public class Place 
	{
		
		//Declare attributes
		private var name:String;
		private var latitude:String;
		private var longitude:String;
		private var description:String;
		private var fullDescription:String;
		private var imageLocation:String;

		//Parameterized constructor
		public function Place(name:String, latitude:String, longitude:String,  description:String, fullDescription:String, imageLocation:String) 
		{
			// constructor code
			this.name = name;
			this.latitude = latitude;
			this.longitude = longitude;
			this.description = description;
			this.fullDescription = fullDescription;
			this.imageLocation = imageLocation;
		}
		
		//Mutators and getters for attributes
		public function set Name(val:String):void
		{
			this.name = val;
		}
		public function get Name():String
		{
			return this.name;
		}
		
		public function set Latitude(val:String):void
		{
			this.latitude = val;
		}
		public function get Latitude():String
		{
			return this.latitude;
		}
		
		public function set Longitude(val:String):void
		{
			this.longitude = val;
		}
		public function get Longitude():String
		{
			return this.longitude;
		}
		
		public function set Description(val:String):void
		{
			this.description = val;
		}
		public function get Description():String
		{
			return this.description;
		}
		
		public function set FullDescription(val:String):void
		{
			this.fullDescription = val;
		}
		public function get FullDescription():String
		{
			return this.fullDescription;
		}
		
		public function set ImageLocation(val:String):void
		{
			this.imageLocation = val;
		}
		public function get ImageLocation():String
		{
			return this.imageLocation;
		}
		
		
		

	}
	
}
