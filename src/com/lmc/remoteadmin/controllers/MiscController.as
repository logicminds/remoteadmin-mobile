package com.lmc.controllers
{
	
	import com.lmc.Events.ForemanEvent;
	import com.lmc.controllers.baseController;
	import com.lmc.ralib.model.Architectures;
	import com.lmc.ralib.model.Domains;
	import com.lmc.ralib.model.Environments;
	import com.lmc.ralib.model.HardwareModels;
	import com.lmc.models.HostGroups;
	import com.lmc.ralib.model.Media;
	import com.lmc.ralib.model.OperatingSystems;
	import com.lmc.ralib.model.PartitionTables;
	import com.lmc.ralib.model.ProvisioningTemplates;
	import com.lmc.ralib.model.Subnets;
	import com.lmc.utils.foremanObject;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	public class MiscController extends baseController
	{
		[Bindable] protected var _envs:Environments;
		[Bindable] protected var _groups:HostGroups;
		[Bindable] protected var _domains:Domains;
		[Bindable] protected var _subnets:Subnets;
		[Bindable] protected var _arch:Architectures;
		[Bindable] protected var _os:OperatingSystems;
		[Bindable] protected var _media:Media;
		[Bindable] protected var _ptables:PartitionTables;
		[Bindable] protected var _ptemplates:ProvisioningTemplates;
		[Bindable] protected var _hwmodels:HardwareModels;



		public function MiscController(target:IEventDispatcher=null)
		{
			super(target);
			
			// Cache Data with multiple foreman object in object to return items quicker
			_envs = new Environments();
			this._envs.getdata();
			
			_domains = new Domains();
			this._domains.getdata();
			
			_subnets = new Subnets();
			this._subnets.getdata();
			
			_arch = new Architectures();
			this._arch.getdata();
			
			_os = new OperatingSystems();
			this._os.getdata();
			
			_media = new Media();
			this._media.getdata();
			
			_ptables = new PartitionTables();
			this._ptables.getdata();
			
			_hwmodels = new HardwareModels();
			this._hwmodels.getdata();
			
			_ptemplates = new ProvisioningTemplates();
			this._ptemplates.getdata();
			
			_groups = new HostGroups();
			this._groups.addEventListener("COMPLETED", hgHandler);
			this._groups.getdata();
			
			
		}
		private function hgHandler(event:Event):void{
			this._groups.removeEventListener("COMPLETED", hgHandler);
			
		}
		public function get hostgroups():HostGroups{
			return this._groups;
		}
		public function get environments():Environments{
				return _envs;
		}
		
		public function get domains():Domains{
				return _domains;
		}	
	
		public function get subnets():Subnets{
				return this._subnets;
			
		}
		
		public function get arch():Architectures{
				return _arch;
			
		}
		
		public function get operatingsystems():OperatingSystems{
				return _os;
		}
	
		public function get media():Media{
				return _media;
		}
	
		public function get ptables():PartitionTables{
		
			return _ptables;
		}
	
		public function get hwmodels():HardwareModels{
		
			return _hwmodels;
			
		}
	
		public function get provtemplates():ProvisioningTemplates{
		
			return _ptemplates;
			
		}
	
		
		
		
	}
}