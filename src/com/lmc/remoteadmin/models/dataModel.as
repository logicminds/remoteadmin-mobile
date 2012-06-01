package com.lmc.models
{
	import com.lmc.Events.ForemanEvent;
	import com.lmc.utils.ApplicationStore;
	import com.lmc.utils.foremanObject;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;
	import mx.utils.Base64Encoder;
	import mx.utils.ObjectUtil;
	public class dataModel extends EventDispatcher
	{
		
		
		private var hostname:String;
		private var hostport:String;
		
		//The is the foreman object used to retreive alot of the puppet data
		[Bindable] public var foreman:foremanObject;
		
		// This will hold all the puppet classes
		[Bindable] public var puppetclasses:ArrayCollection = new ArrayCollection();
		
		// This will hold all the hosts under puppet control
		[Bindable] public var puppethosts:ArrayCollection = new ArrayCollection();
		
		[Bindable] public var hostgroups:ArrayCollection = new ArrayCollection();
		
		// going to use this to write data to disk or persistant memory
		// this would keep us from having to use the network all the time
		private var settings:SharedObject = SharedObject.getLocal("settings");
		public var usehttps:Boolean = false;
		private var classes_foreman:foremanObject;
		private var hosts_foreman:foremanObject;
		private var hostgroups_foreman:foremanObject;
		private var credentials:String = null;
		private var myprofile:Profile;
		private var _status:Boolean = false;
		public function dataModel()
		{
			// This is a simple class that will hold all the 
			//data so we can pass it around easier
			
			super();
			
		}
		public function get profile():Profile{
			return this.myprofile;
		}
		public function getforemanInstance():foremanObject{
			var finstance:foremanObject;
			//create the foreman object used for one time lookups used throught the program
			finstance = new foremanObject(this.hostname,this.hostport,null,this.usehttps);
			// set credentails if any
			if (this.credentials){
				finstance.credentials = this.credentials;
			}
			return finstance;
		}
		public function modelsetup():void{
			// Get this from the Settings object that is saved on the local device
			if (settings.data.currentprofile){
				this.hostname = settings.data.currentprofile.host;
				this.hostport = settings.data.currentprofile.port;
				this.usehttps = settings.data.currentprofile.usehttps;
				this.myprofile = new Profile(settings.data.currentprofile);
				// set credentails if any
				
			//	URLRequestDefaults.authenticate = false;
				if (this.myprofile.credentials != ""){
					this.credentials = this.myprofile.credentials;
					
				}
			trace("Settings is consuming " + (settings.size / 1000 ) + "KB of space");
			//trace("appdata is consuming " + (appdata.size / 1000) + "KB of space");
			this.foreman = getforemanInstance();
			// set the listeners to we can be informed about connection status
			foreman.addEventListener("ForemanStatus", connectionStatusHandler);
			foreman.addEventListener("ForemanConnectionFault", connectionFaultHandler);
			
			// We need to define multiple connections in order to get data independently
			
			//classes
			classes_foreman = new foremanObject(this.hostname,this.hostport,null,this.usehttps);
			
			classes_foreman.addEventListener("ForemanClassesRefresh", classHandler);
			// set credentails if any
			if (this.credentials){
				this.classes_foreman.credentials = this.credentials;
			}
			//hosts
			hosts_foreman = new foremanObject(this.hostname,this.hostport,null,this.usehttps);
			
			hosts_foreman.addEventListener("hostsRefresh", hostsHandler);
			// set credentails if any
			if (this.credentials){
				this.hosts_foreman.credentials = this.credentials;
			}
			//hostgroups
			hostgroups_foreman = new foremanObject(this.hostname,this.hostport,null,this.usehttps);
			hostgroups_foreman.addEventListener("hostgroupsRefresh", hostgroupsHandler);
			// set credentails if any
			if (this.credentials){
				this.hostgroups_foreman.credentials = this.credentials;
			}
			}
		}
		public function cachedata():void{
			this.refreshhosts();

			this.refreshclasses();
			this.refreshhostgroups();

			
			
		}
		public function get status():Boolean{
			return _status;
			
		}
		private function connectionStatusHandler(event:ForemanEvent):void{
			trace("connection is good via data model :\)");
			this._status = true;
			this.dispatchEvent(new ForemanEvent("dmForemanStatus", event.eventdata));
		}
		
		private function connectionFaultHandler(event:ForemanEvent):void{
			trace("Connection is Bad");
			trace("There was a problem connecting to the Foreman host" + "host: " + this.host+":"+this.port);
			this._status = false;
			this.dispatchEvent(new ForemanEvent("dmForemanConnectionFault", event.eventdata));
		}
		public function checkstatus():void{
			// foreman will throw event, this function just sends the status command
			foreman.settype("home");
			foreman.option = "status";
			foreman.refresh();
			
		}
		public function refreshclasses():void{
			// should we want to refresh the classes this will fetch the data from the server
				classes_foreman.settype("puppetclasses");
				classes_foreman.refresh();
			
			// turn on wait thingy
			
		} 
		public function refreshhostgroups():void{
			// should we want to refresh the classes this will fetch the data from the server
			
				hostgroups_foreman.settype("hostgroups");
				hostgroups_foreman.refresh();
			
			// turn on wait thingy
			
		}
		public function refreshhosts():void{
			// should we want to refresh the classes this will fetch the data from the server
				hosts_foreman.settype("hosts");
				hosts_foreman.refresh();
			
			
			// turn on wait thingy

		}
		private function clone(source:ArrayCollection):ArrayCollection{
			// the foreman.data object gets reused often so we can't bind to it
			var temp:ArrayCollection = new ArrayCollection();
			for each (var item:Object in source){
				temp.addItem(item);
			}
			return temp;
		}
		private function classHandler(event:ForemanEvent):void{
			
		//	puppetclasses = event.eventdata as ArrayCollection;
		
		}
		private function hostsHandler(event:ForemanEvent):void{
			//puppethosts = hosts_foreman.hosts as ArrayCollection;
			puppethosts = event.eventdata as ArrayCollection;
			//appdata.data.puppethosts = puppethosts;
			//ApplicationStore.services["hosts"] = puppethosts;
			//appdata.flush();
			// turn off wait thingy
		}
		
		private function hostgroupsHandler(event:Event):void{
			hostgroups = hostgroups_foreman.data as ArrayCollection;
			//appdata.data.hostgroups = hostgroups;
			//ApplicationStore.services["hostgroups"] = hostgroups;
			//appdata.flush();
			// turn off wait thingy
			
		}
		public function get host():String{
			return this.hostname;
		}
		public function get port():String{
			return this.hostport;
		}
	}
}