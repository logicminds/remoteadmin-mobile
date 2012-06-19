package com.lmc.remoteadmin.bootstraps
{
	import com.lmc.ralib.Events.*;
	import com.lmc.ralib.Events.RestClientEvent;
	import com.lmc.ralib.components.*;
	import com.lmc.ralib.components.charts.*;
	import com.lmc.ralib.controller.*;
	import com.lmc.ralib.model.*;
	import com.lmc.ralib.services.*;
	import com.lmc.ralib.view.*;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;

	public class BootstrapViewMediators
	{
		public function BootstrapViewMediators(mediatorMap:IMediatorMap)
		{
			// Application 
			//mediatorMap.mapView(LicensePopUp, LicensePopUpMediator,null,false,false);
			mediatorMap.mapView(ProfileClientSettingsView, ProfileClientSettingsMediator);
			mediatorMap.mapView(DiagnosticsView, DiagnosticsViewMediator);
			
			// Profile specific
			mediatorMap.mapView(ProfilesView, ProfilesViewMediator);

			mediatorMap.mapView(ProfileList, ProfileListMediator);
			mediatorMap.mapView(ProfileForm, ProfileFormMediator);

			mediatorMap.mapView(ProfileView, ProfileViewMediator);
			
			// Hosts 
			mediatorMap.mapView(HostsList, HostsListMediator);
			mediatorMap.mapView(HostsView, HostsViewMediator);
			
			// Dashboard
			mediatorMap.mapView(HomeView, HomeViewMediator);
			mediatorMap.mapView(DashBoardOverView, DashBoardOverViewMediator);
		
			//Facts
			mediatorMap.mapView(FactsView, FactsViewMediator);
			mediatorMap.mapView(FactView, FactViewMediator);
			mediatorMap.mapView(FactSystemsView, FactSystemsViewMediator);

			//reports
			mediatorMap.mapView(ReportsView, ReportsViewMediator);
			mediatorMap.mapView(ReportView, ReportViewMediator);

			mediatorMap.mapView(MoreView, MoreViewMediator);
			mediatorMap.mapView(remoteadmin_mobile, remoteadmin_mobileMediator);
			mediatorMap.mapView(FilterListlayout, FilterListLayoutMediator, null,false, false);
			mediatorMap.mapView(InputUserDialog, InputUserDialogMediator,null,false,false);
			mediatorMap.mapView(InputDialog, InputDialogMediator,null,false,false);
			
			// Groups
			mediatorMap.mapView(HostGroupsView, HostGroupsViewMediator);
			mediatorMap.mapView(EditGroupView, EditGroupViewMediator);
			mediatorMap.mapView(GroupList, GroupListMediator);
			mediatorMap.mapView(EditClassesGroupView, EditClassesGroupViewMediator);
			mediatorMap.mapView(EditHostsGroupView, EditHostsGroupViewMediator);
			
			mediatorMap.mapView(FilterView, FilterViewMediator);
			mediatorMap.mapView(ListCalloutViewNavigator, ListCalloutViewNavigatorMediator,null, false, false);
		
			//Info View specific
			mediatorMap.mapView(InfoView, InfoViewMediator);
			
			//Host Specific
			mediatorMap.mapView(HostView, HostViewMediator);
			mediatorMap.mapView(HostFactsView, HostFactsViewMediator);
			mediatorMap.mapView(HostClassesView, HostClassesViewMediator);
			mediatorMap.mapView(HostPropertiesView, HostPropertiesViewMediator);

		}
	}
}