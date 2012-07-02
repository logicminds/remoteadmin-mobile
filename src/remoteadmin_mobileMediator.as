package 
{
	import com.lmc.ralib.Events.ApplicationEvent;
	import com.lmc.ralib.Events.BusyPopupEvent;
	import com.lmc.ralib.Events.MenuEvent;
	import com.lmc.ralib.Events.ProfilesEvent;
	import com.lmc.ralib.Events.SettingsServiceEvent;
	import com.lmc.ralib.components.ViewMediatorBase;
	import com.lmc.ralib.menus.Menus;
	import com.lmc.ralib.model.AppPreferences;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.Application;

	public class remoteadmin_mobileMediator extends ViewMediatorBase
	{
		[Inject] public var preferences:AppPreferences;
		[Inject] public var view:remoteadmin_mobile;
		[Inject] public var menu:Menus;
		
		public function remoteadmin_mobileMediator()
		{
			super();

		}
		override public function onRegister():void{
			// set the firstView
			//view.homenav.firstView = preferences.firstview;
			//view.homenav.popToFirstView();
			//view.homenav.pushView(preferences.firstview);
			dispatch(new BusyPopupEvent(BusyPopupEvent.CLOSE));
			// listen for events
			//this.addContextListener(ApplicationEvent.LOAD_FIRST_VIEW, setView);
			

		}
		private function setView(event:ApplicationEvent):void{
			//TODO make the firstview not use the home nav if setting up profiles
			//view.homenav.firstView = event.firstview;
			//view.homenav.popAll();
			//view.homenav.pushView(event.firstview);
			

		}
	}
}