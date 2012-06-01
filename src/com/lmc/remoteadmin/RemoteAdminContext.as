package com.lmc.remoteadmin
{
	import com.lmc.ralib.Events.*;
	import com.lmc.remoteadmin.bootstraps.*;
	import com.lmc.ralib.components.*;
	import com.lmc.ralib.controller.*;
	import com.lmc.ralib.model.*;
	import com.lmc.ralib.services.*;
	import com.lmc.ralib.Events.RestClientEvent;
	import com.lmc.ralib.view.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	public class RemoteAdminContext extends Context
	{
		public function RemoteAdminContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		override public function startup():void
		{
			
			// This allows me to preload some data from an esync service
			commandMap.mapEvent(ContextEvent.STARTUP, ApplicationStartupCommand);
			this.addEventListener(ApplicationEvent.STARTUP_COMMAND_COMPLETE, onPreloadComplete);
			this.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
			
		}
		private function onPreloadComplete(event:ApplicationEvent):void{
			this.removeEventListener(ApplicationEvent.STARTUP_COMMAND_COMPLETE, onPreloadComplete);
			// Startup complete
			new BootstrapViewMediators(mediatorMap);
			super.startup();
		}
	}
}