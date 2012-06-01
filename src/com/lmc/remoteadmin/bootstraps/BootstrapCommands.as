package com.lmc.remoteadmin.bootstraps
{
	import com.lmc.ralib.Events.*;
	import com.lmc.ralib.controller.*;
	import com.lmc.ralib.controller.Application.*;
	import com.lmc.ralib.controller.Busy.*;
	import com.lmc.ralib.controller.Host.*;
	import com.lmc.ralib.controller.classes.*;
	import com.lmc.ralib.controller.dashboard.*;
	import com.lmc.ralib.controller.facts.*;
	import com.lmc.ralib.controller.groups.*;
	import com.lmc.ralib.controller.hosts.*;
	import com.lmc.ralib.controller.profiles.*;
	import com.lmc.ralib.controller.reports.*;
	import com.lmc.ralib.Events.RestClientEvent;
	
	import org.robotlegs.core.ICommandMap;
	
	public class BootstrapCommands
	{
		public function BootstrapCommands(commandMap:ICommandMap)
		{
			//Application level
			commandMap.mapEvent(ApplicationEvent.CLEAR_CACHE_REQUEST, ClearCacheRequestCommand);
			commandMap.mapEvent(LicenseEvent.OPEN, OpenLicenseCommand);
			commandMap.mapEvent(LicenseEvent.RESPONSE, SaveLicenseResponseCommand);
			
			// Stage Web View
			//commandMap.mapEvent(StageWebViewEvent.OPEN, OpenStageWebView);
			//commandMap.mapEvent(StageWebViewEvent.CLOSE, OpenStageWebView);
			
			// General Client responses
			commandMap.mapEvent(RestClientEvent.ACCESS_DENIED, ClientAccessDeniedCommand);
			commandMap.mapEvent(RestClientEvent.FAILED_RESULT, ClientFailureCommand);
			
			// Profiles
			commandMap.mapEvent(ProfilesEvent.GET_REQUEST, GetProfileFormCommand);
			commandMap.mapEvent(ProfilesEvent.ADD_REQUEST, AddProfileCommand);
			commandMap.mapEvent(ProfilesViewEvent.ADD, AddProfileCommand);
			commandMap.mapEvent(ProfilesViewEvent.EDIT, EditProfileCommand);
			commandMap.mapEvent(ProfilesViewEvent.REMOVE, RemoveProfileCommand);
			commandMap.mapEvent(SettingsServiceEvent.WRITE_REQUEST, WriteSettingsCommand);
			commandMap.mapEvent(SettingsServiceEvent.READ_REQUEST, ReadSettingsCommand);
			commandMap.mapEvent(SettingsServiceEvent.RESULT, GetStoredProfilesCommand);
			commandMap.mapEvent(ProfilesEvent.CURRENT_PROFILE_REQUEST, GetCurrentProfileCommand);
			commandMap.mapEvent(ProfilesEvent.SET_CURRENT_PROFILE_REQUEST, SetCurrentProfileCommand);
			commandMap.mapEvent(ProfilesEvent.GET_PROFILES_REQUEST, GetProfilesCommand);
			
			// alerts and popups
			commandMap.mapEvent(AlertEvent.OPEN,AlertShowCommand);
			commandMap.mapEvent(DialogPopUpEvent.OPEN, OpenInputDialogCommand);
			commandMap.mapEvent(DialogPopUpEvent.OPEN_USERPASS, OpenInputDialogCommand);


			//Host
			commandMap.mapEvent(ClientRequestEvent.HOSTFACTS, GetHostFactsCommand);
			commandMap.mapEvent(RestClientEvent.HOSTFACTS, GetHostFactsResultCommand);
			commandMap.mapEvent(ClientUpdateRequestEvent.HOST, UpdateHostRequestCommand);
			commandMap.mapEvent(RestClientEvent.UPDATE_HOST, UpdateHostResultCommand);
			commandMap.mapEvent(ClientRequestEvent.HOST, GetHostRequestCommand);
			commandMap.mapEvent(RestClientEvent.HOST, GetHostResultCommand);
			commandMap.mapEvent(DataCorrelationEvent.COMBINED_CLASSES_WITH_HOST_REQUEST, JoinHostClassesCommand);
			commandMap.mapEvent(ClientRequestEvent.HOST_CLASSES, GetHostClassesCommand);

			//Hosts
			commandMap.mapEvent(ClientRequestEvent.HOSTS, GetHostsRequestCommand);
			commandMap.mapEvent(RestClientEvent.HOSTS, GetHostsResultCommand, RestClientEvent);
			commandMap.mapEvent(RestClientEvent.GROUP_HOSTS, FindHostsByGroupResultCommand, RestClientEvent);
			
			//reports
			commandMap.mapEvent(ClientRequestEvent.REPORTS, GetReportsRequestCommand);
			commandMap.mapEvent(RestClientEvent.REPORTS, GetReportsResultCommand);
			commandMap.mapEvent(ReportsViewEvent.PARSE_REPORT, ParseReportCommand);
		
			commandMap.mapEvent(MenuEvent.GET_HOST_MENU, GetHostMenuCommand);
			commandMap.mapEvent(ClientRequestEvent.DASHBORAD, GetDashboardRequestCommand);
			commandMap.mapEvent(RestClientEvent.DASHBOARD, GetDashboardResultCommand);
			commandMap.mapEvent(ReportsViewEvent.REFRESH, RefreshReportsRequestCommand);
			
			//facts
			commandMap.mapEvent(ClientRequestEvent.FACTS, GetFactsRequestCommand);
			commandMap.mapEvent(RestClientEvent.FACTS, GetFactsResultCommand);
			commandMap.mapEvent(ClientRequestEvent.FACTVALUES, GetFactValuesRequestCommand);
			commandMap.mapEvent(RestClientEvent.FACTVALUES, GetFactValuesResultCommand);
			commandMap.mapEvent(FactViewEvent.CREATE_FACT_EMAIL, CreateFactsEmailCommand);
			commandMap.mapEvent(FactViewEvent.CREATE_HOSTS_FACT_EMAIL, CreateFactsEmailCommand);

			
			//hostgroups
			commandMap.mapEvent(ClientRequestEvent.HOSTGROUPS, GetGroupsRequestCommand);
			commandMap.mapEvent(RestClientEvent.HOSTGROUPS, GetGroupsResultCommand);
			commandMap.mapEvent(ClientRequestEvent.HOSTGROUP, GetHostGroupRequestCommand);
			commandMap.mapEvent(RestClientEvent.HOSTGROUP, GetHostGroupResultCommand);
			commandMap.mapEvent(ClientWriteRequestEvent.CREATE_HOSTGROUP, CreateGroupRequestCommand);
			commandMap.mapEvent(RestClientEvent.CREATE_GROUP_RESULT, CreateGroupResultCommand);
			commandMap.mapEvent(ClientUpdateRequestEvent.HOSTGROUP, UpdateHostGroupRequestCommand);
			commandMap.mapEvent(RestClientEvent.UPDATE_HOSTGROUP, UpdateHostGroupResultCommand);
			commandMap.mapEvent(ClientUpdateRequestEvent.MULTIPLE_HOSTGROUP, UpdateMultipleHostGroupRequestCommand);
			commandMap.mapEvent(RestClientEvent.MULTIPLE_HOSTS, UpdateMultipleHostGroupResultCommand);
			commandMap.mapEvent(FactViewEvent.FILTERHOSTGROUPS, FilterFactsByGroupCommand);
			commandMap.mapEvent(DataCorrelationEvent.HOSTS_WITH_HOSTGROUP_REQUEST, JoinHostListandGroupHostListCommand);
			commandMap.mapEvent(SearchEvent.FIND_HOSTS_BY_GROUP, FindHostsByGroupCommand);
			commandMap.mapEvent(DataCorrelationEvent.COMBINED_CLASSES_WITH_GROUP_REQUEST, JoinGroupClasseswithAllClassesCommand);
			commandMap.mapEvent(FilterListLayoutEvent.OPEN, FilterListOpenCommand);

			//Analytics
			commandMap.mapEvent(AnalyticsTrackerEvent.TRACKPAGEVEW, TrackPageViewCommand);
		
			//status
			commandMap.mapEvent(ClientRequestEvent.STATUS, GetClientStatusCommand);
			commandMap.mapEvent(RestClientEvent.STATUS, GetClientStatusResultCommand);
			//puppetclasses
			commandMap.mapEvent(ClientRequestEvent.PUPPETCLASSES, GetClassesRequestCommand);
			commandMap.mapEvent(RestClientEvent.PUPPETCLASSES, GetClassesResultCommand);

		}
	}
}