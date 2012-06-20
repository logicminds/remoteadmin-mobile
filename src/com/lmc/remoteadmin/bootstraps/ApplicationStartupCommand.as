package com.lmc.remoteadmin.bootstraps
{
	import com.lmc.ralib.Events.*;
	import com.lmc.ralib.bootstraps.*;
	import com.lmc.ralib.components.BusyPopUp;
	import com.lmc.ralib.components.BusyPopUpMediator;
	import com.lmc.ralib.components.LicensePopUp;
	import com.lmc.ralib.components.LicensePopUpMediator;
	import com.lmc.ralib.model.AppPreferences;
	import com.lmc.ralib.model.Bookmark;
	import com.lmc.ralib.model.Bookmarks;
	import com.lmc.ralib.view.HomeView;
	import com.lmc.ralib.view.ProfilesView;
	
	import org.robotlegs.mvcs.Command;

	public class ApplicationStartupCommand extends Command
	{
		public function ApplicationStartupCommand()
		{
			super();
		}
		override public function execute():void{
			new BootstrapCommands(commandMap);
			new BootstrapModels(injector);
			createstuff();
			dispatch(new MenuEvent(MenuEvent.GET_HOST_MENU));
			// Check for license Agreement first
			mediatorMap.mapView(LicensePopUp, LicensePopUpMediator,null,false,false);
			this.eventDispatcher.addEventListener(LicenseEvent.RESULT, onLicenseResult);
			dispatch(new LicenseEvent(LicenseEvent.OPEN));
			commandMap.detain(this);
		}
		private function onLicenseResult(event:LicenseEvent):void{
			// find profiles on disk or create new
			this.eventDispatcher.removeEventListener(LicenseEvent.RESULT, onLicenseResult);
			this.eventDispatcher.addEventListener(ProfilesEvent.PROFILESRESULT, onSettingsHandler);
			dispatch(new SettingsServiceEvent(SettingsServiceEvent.READ_REQUEST, "profiles"));
		}
		private function onSettingsHandler(event:ProfilesEvent):void{
			//settings have been read from the disk
			this.eventDispatcher.removeEventListener(ProfilesEvent.PROFILESRESULT, onSettingsHandler);
			var preferences:AppPreferences = injector.getInstance(AppPreferences);
			if (event.data.profiles.length == 0){
				//check if profiles is empty usually this means we started from scratch
				preferences.firstview = com.lmc.ralib.view.ProfilesView;
				//
			}
			else{
				preferences.firstview = com.lmc.ralib.view.HomeView;

			}
			dispatch(new ApplicationEvent(ApplicationEvent.STARTUP_COMMAND_COMPLETE));
			
			commandMap.release(this);

		}
		private function createstuff():void{
			mediatorMap.mapView(BusyPopUp, BusyPopUpMediator,null,false,false);
			// create the SkinnablePopUpContainer
			var busy:BusyPopUp = new BusyPopUp();
			mediatorMap.createMediator(busy);
			// set the styles
			busy.open(this.contextView);
			busy.visible = false;
			
			// Add Bookmarks to local bookmarks model
			var bookmarks:Bookmarks = injector.getInstance(Bookmarks);
			//var b1:Bookmark = new Bookmark();
			//b1.
			//bookmarks.add
			
		}
	}
}