package com.lmc.remoteadmin.bootstraps
{
	import com.lmc.ralib.menus.Menus;
	import com.lmc.ralib.model.*;
	import com.lmc.ralib.services.*;
	import org.robotlegs.core.IInjector;
	
	public class BootstrapModels
	{
		public function BootstrapModels(injector:IInjector)
		{
			injector.mapSingleton(SettingsService);
			// This is mapped in a command
			injector.mapSingleton(Reports);
			injector.mapSingleton(ProfilesModel);
			injector.mapSingleton(DashModel);
			injector.mapSingleton(Hosts);
			injector.mapSingleton(Menus);
			injector.mapSingleton(AppKeeper);
			injector.mapSingleton(Facts);
			injector.mapSingleton(FactValues);
			injector.mapSingleton(HostGroups);
			injector.mapSingleton(RemoteService);
			// This is used to just inject a value that we will never actually use
			injector.mapSingleton(RemoteServiceBase);
			injector.mapSingleton(PuppetClasses);
			injector.mapSingleton(Analytics);
			injector.mapSingleton(AppPreferences);
		}
	}
}