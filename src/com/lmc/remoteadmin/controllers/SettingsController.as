package com.lmc.controllers
{
	import com.lmc.Events.ForemanEvent;
	import com.lmc.models.Profile;
	import com.lmc.utils.ApplicationStore;
	import com.lmc.utils.foremanObject;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class SettingsController extends EventDispatcher
	{
		public var pcontroller:ProfilesController;
		private var hosttest:foremanObject;
		private var pevent:ForemanEvent;
		public function SettingsController(target:IEventDispatcher=null)
		{
			super(target);
			if (ApplicationStore.services["profilescontroller"]){
				pcontroller =  ApplicationStore.services["profilescontroller"];
			}
			else{
				pcontroller = new ProfilesController();
				ApplicationStore.services["profilescontroller"] = pcontroller;
			}
		}
		
		
		public function checkSettings(p:Object=null):void{
			// this function will dispatch a SettingsStatus to inform the user om what to do
			
			if (!p){
				// profile is null
				pevent = new ForemanEvent("SettingsStatus", {status:"NO_PROFILE"});
				this.dispatchEvent(pevent);
				return;
			}
			var profile:Profile;
			
			if (p){
				profile = new Profile(p);
			}
			else if (pcontroller.currentprofile){
				profile = pcontroller.currentprofile as Profile;
			}
			else{
				// no profile specified
				return;
			}
			
			hosttest = new foremanObject(profile.host,profile.port,"GET", profile.usehttps);
			// set the credentials if using them
			if (profile.credentials != ""){
			//	URLRequestDefaults.authenticate = false;
				hosttest.credentials = profile.credentials;
			}
			hosttest.addEventListener("DashboardRefresh", connectionStatusHandler);
			hosttest.addEventListener("ForemanConnectionFault", connectionFaultHandler);
			hosttest.option = null;
			hosttest.fqdn = null;
			hosttest.settype("dashboard");
			hosttest.refresh();
		}
		
		private function connectionStatusHandler(event:ForemanEvent):void{
			trace("Profile Check: profile connection is good :\)" + event.eventdata.result);
			pevent = new ForemanEvent("SettingsStatus", {status:"CONNECTED"});
			// if the connection is good go to main screen
			// clean up after ourselves
			hosttest.removeEventListener("DashboardRefresh", connectionStatusHandler);
			hosttest.removeEventListener("ForemanConnectionFault", connectionFaultHandler);
			hosttest = null;
			// Verified working order
			this.dispatchEvent(pevent);
			
		}
		private function connectionFaultHandler(event:ForemanEvent):void{
			trace("Profile Check: Connection is Bad of not enough permissions");
			//trace(event.eventdata);
			pevent = new ForemanEvent("SettingsStatus", {status:"CONNECTION_FAULT", error:event.eventdata});
			this.dispatchEvent(pevent);

			hosttest.removeEventListener("DashboardRefresh", connectionStatusHandler);
			hosttest.removeEventListener("ForemanConnectionFault", connectionFaultHandler);
			hosttest = null;
			// connection is bad, select different profile
		}
	}
}

