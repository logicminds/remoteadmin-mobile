package com.lmc.controllers
{
	import com.lmc.Events.ForemanEvent;
	import com.lmc.ralib.model.Architectures;
	import com.lmc.ralib.model.Host;
	import com.lmc.models.HostGroup;
	import com.lmc.ralib.model.Media;
	import com.lmc.ralib.model.PartitionTables;
	import com.lmc.ralib.model.ProvisioningTemplates;
	import com.lmc.utils.ApplicationStore;
	
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	
	public class ProvisionController extends baseController
	{
		private var proplist:ArrayCollection;
		private var fcontroller:FactsController;
		private var gcontroller:GroupController;
		private var misccontroller:MiscController;
		private var phash:Dictionary = new Dictionary();
		private var ahash:Dictionary = new Dictionary();
		private var selhash:Dictionary = new Dictionary();


		public function ProvisionController(target:IEventDispatcher=null)
		{
			super(target);
			fcontroller = ApplicationStore.services["fcontroller"];
			gcontroller = ApplicationStore.services["gcontroller"];
			misccontroller = ApplicationStore.services["misccontroller"];
			
			if (! fcontroller){
				fcontroller = new FactsController();
				ApplicationStore.services["fcontroller"] = fcontroller;
				
			}
			if (! gcontroller){
				gcontroller = new GroupController();
				ApplicationStore.services["gcontroller"] = gcontroller;
				gcontroller.refresh();
				
				
			}
			if (! misccontroller){
				misccontroller = new MiscController();
				ApplicationStore.services["misccontroller"] = misccontroller;
				
				
				
			}
		}
		private function changeOS(id:int):void{
			
			//change ptables
			var ptables:PartitionTables = new PartitionTables();
			var media:Media = new Media();
			var arch:Architectures = new Architectures();
			var ptemplates:ProvisioningTemplates = new ProvisioningTemplates();
			
			if (id > 0){
				phash["Operating System"] = misccontroller.operatingsystems.namehash[id];
				// resolve the id to an object
				var os:Object = misccontroller.operatingsystems.findbyname(misccontroller.operatingsystems.namehash[id]);
				ptables.copy(os.ptables);
				media.copy(os.medium);
				arch.copy(os.architectures);
				ptemplates.copy(os.config_templates);
				
						
				ahash["ptemplates"] = ptemplates;
				ahash["architectures"] = arch;
				ahash["media"] = media;
				ahash["ptables"] = ptables;
			}
		
			// if id <= 0 these arrays will be empty
			
		}
		private function changeDomain(id:int):void{
			if (id > 0){
				phash["Domain"] = misccontroller.domains.namehash[id];
			}
			
		}
		private function changeHostGroup(id:int):void{
			//change environment
			if (id > 0){
				
				var name:String = gcontroller.hostgroups.namehash[id];
				phash["Host Group"] = name;
				var hg:HostGroup = gcontroller.hostgroups.findbyname(name);
				changeSubnet(hg.subnet_id);
				changeOS(hg.properties.operatingsystem_id); 
			}
			
		}
		private function changeSubnet(id:int):void{
			if (id > 0){
				var item:Object = misccontroller.subnets.findbyname(misccontroller.subnets.namehash[id]);
				phash["Subnet"] = item.name;
				if (item){
					changeDomain(item.domain_id);
				}
			}
		}
		
		public function setProperty(item:Object, type:String, items:Vector.<int>=null):void{
		//this function will set the Property for the given type based on the item based in
			trace(type);
			
			// these are special and require multiple changes that have interdependicies
			switch(type){
				case "Host Group":
					phash[type] = item.name;
					this.changeHostGroup(item.id);
					break;
				case "Subnet":
					phash[type] = item.name;
					this.changeSubnet(item.id);
					break;
				case "Operating System":
					phash[type] = item.name;
					this.changeOS(item.id);
					break;
				default:
					phash[type] = item.name;
					break;
				
			}
		}
		public function getproplist(hc:HostController):void{
			// I am assuming this is only called after gethostdata
			//var subnet:String = misccontroller.subnets[hostdata.properties.subnet_id]
			//var domain:String = misccontroller.domains[hostdata.properties.domain_id];
			//var envs:ArrayCollection = misccontroller.getenvironments();
			var hostdata:Host = hc.hostdata;
			if (! proplist){
				// doesn't exist so lets create
				proplist = new ArrayCollection();
				// Populate the has for each retreival later, lets check to see if any of these are empty first
				if (hostdata.name)
					phash["Host Name"] = hostdata.name;
				
				if (hostdata.properties.hostgroup_id){
					phash["Host Group"] = gcontroller.hostgroups.namehash[hostdata.properties.hostgroup_id];
					ahash["Hostgroups"] = gcontroller.hostgroups;
				}
				if (hostdata.properties.environment.environment.name){
					phash["Environment"] = hostdata.properties.environment.environment.name;
					ahash["Environments"] = misccontroller.environments;
				}
					
				if (hostdata.properties.puppetmaster_name)
					phash["Puppet Master"] = hostdata.properties.puppetmaster_name;
				
				if ( misccontroller.domains.length > 0){
					phash["Domain"] = misccontroller.domains.namehash[hostdata.properties.domain_id];
					ahash["Domains"] = misccontroller.domains;
				}
				if ( misccontroller.subnets.length > 0){
					phash["Subnet"] = misccontroller.subnets.namehash[hostdata.properties.subnet_id];
					ahash["Subnets"] = misccontroller.subnets;
				}
				if (hostdata.properties.ip)
					phash["IP"] = hostdata.properties.ip;
				
				if (hostdata.properties.mac)
					phash["MAC"] = hostdata.properties.mac;
				
				if ( misccontroller.arch.length > 0){
					phash["Architecture"] = misccontroller.arch.namehash[hostdata.properties.architecture_id];
					ahash["architectures"] = misccontroller.arch;
				}
				if ( misccontroller.operatingsystems.length > 0){
					phash["Operating System"] = misccontroller.operatingsystems.namehash[hostdata.properties.operatingsystem_id];
					ahash["os"] = misccontroller.operatingsystems;
				}
				if ( misccontroller.media.length > 0){
					phash["Media"] = misccontroller.media.namehash[hostdata.properties.medium_id];
					ahash["media"] = misccontroller.media;
				}
				if (hostdata.properties.root_pass)
					phash["Root Pass (encrypted)"] = hostdata.properties.root_pass;
				
				if (misccontroller.ptables.length > 0){
					phash["Partition Table"] = misccontroller.ptables.namehash[hostdata.properties.ptable_id];
					ahash["ptables"] = misccontroller.ptables;
				}
				if (misccontroller.hwmodels.length > 0){
					phash["Hardware Model"] = misccontroller.hwmodels.namehash[hostdata.properties.model_id];
					ahash["models"] = misccontroller.hwmodels;
				}
				if (misccontroller.provtemplates.length > 1){
					ahash["bootloaders"] = misccontroller.provtemplates.bootloaders;
					ahash["finishtemplates"] = misccontroller.provtemplates.finishscripts;
					ahash["unattended"] = misccontroller.provtemplates.unattendedscripts;
					ahash["provisionscripts"] = misccontroller.provtemplates.scripts;
					ahash["provisioningsnippets"] = misccontroller.provtemplates.snippets;
					/*
					phash["bootloaders"] = misccontroller.provtemplates.bootloaders;
					phash["finishtemplates"] = misccontroller.provtemplates.finishscripts;
					phash["unattended"] = misccontroller.provtemplates.unattendedscripts;
					phash["provisionscripts"] = misccontroller.provtemplates.scripts;
					phash["provisioningsnippets"] = misccontroller.provtemplates.snippets;
					*/
				}

					//phash["Ptemplates"] = misccontroller.provtemplates[hostdata.properties.model_id].name;
				 
				this.changeHostGroup(hostdata.hostgroup_id);
			}
			else{
				proplist.removeAll();
			}
			
			
			
			proplist.addItem({section:"Primary Settings", type:"Heading"});
			
			proplist.addItem({name:"Host Name", value:phash["Host Name"], type:"Item"});
			proplist.addItem({name:"Host Group", value:phash["Host Group"], type:"Item", list:ahash["Hostgroups"]});
				
			proplist.addItem({name:"Environment", value:phash["Environment"],
				type:"Item", list:ahash["Environments"]});
			proplist.addItem({name:"Puppet Master", value:phash["Puppet Master"], type:"Item"});
			
			proplist.addItem({section:"Network Settings", type:"Heading"});
			proplist.addItem({name:"Domain", value:phash["Domain"], type:"Item", list:ahash["Domains"]});
			proplist.addItem({name:"Subnet", value:phash["Subnet"], type:"Item", list:ahash["Subnets"]});
			proplist.addItem({name:"IP", value:phash["IP"], type:"Item"});
			proplist.addItem({name:"MAC", value:phash["MAC"], type:"Item"});
			
			proplist.addItem({section:"Provisioning Settings", type:"Heading"});
			proplist.addItem({name:"Architecture", value:phash["Architecture"], type:"Item", list:ahash["architectures"]});
			proplist.addItem({name:"Operating System", value:phash["Operating System"], type:"Item", list:ahash["os"]});
			proplist.addItem({name:"Media", value:phash["Media"], type:"Item", list:ahash["media"]});
			proplist.addItem({name:"Partition Table", value:phash["Partition Table"], type:"Item", list:ahash["ptables"]});
			proplist.addItem({name:"Root Pass (encrypted)", value:phash["Root Pass (encrypted)"], type:"Item"});
			proplist.addItem({name:"Hardware Model", value:phash["Hardware Model"], type:"Item", list:ahash["models"]});
			
			proplist.addItem({name:"Boot Loader Template", value:phash["Boot Loader Template"], type:"Item", list:ahash["bootloaders"]});
			proplist.addItem({name:"OS Unattended Script", value:phash["OS Unattended Script"], type:"Item", list:ahash["unattended"]});
			proplist.addItem({name:"OS Finish Scripts", value:phash["OS Finish Scripts"], type:"Item", list:ahash["finishtemplates"]});
			proplist.addItem({name:"OS Provisioning Scripts", value:phash["OS Provisioning Scripts"], 
				type:"Item", list:ahash["provisionscripts"], multi:true, selitems:selhash["provisionscripts"]});
			proplist.addItem({name:"Provisioning Snippets", value:phash["Provisioning Snippets"], 
				type:"Item", list:ahash["provisioningsnippets"], multi:true, selitems:selhash["provisionscripts"]});

			//proplist.addItem({section:"Misc Settings", type:"Heading"});
			//proplist.addItem({name:"Parameters", value:"", type:"Item"});
			//proplist.addItem({name:"Additional Information", value:"", type:"Item"});
			
			dispatchEvent(new ForemanEvent("HostPropsRefresh", proplist));
			
		}
		public function updateHost(hc:HostController):void{
			var props:Object = new Object();
			for each (var obj:* in proplist){
				if (obj.name){
					props[obj.name] = obj.value;
				}
			}
			var hg:HostGroup = gcontroller.hostgroups.findbyname(phash["Host Group"]);
			
			hc.hostdata.properties.name = phash["Host Name"];
			hc.hostdata.properties.hostgroup_id = hg.name;
			hc.hostdata.properties.name = phash["Host Name"];
			hc.hostdata.properties.name = phash["Host Name"];
			hc.hostdata.properties.name = phash["Host Name"];
			hc.hostdata.properties.name = phash["Host Name"];
			hc.hostdata.properties.name = phash["Host Name"];
			hc.hostdata.properties.name = phash["Host Name"];
			hc.hostdata.properties.name = phash["Host Name"];
			hc.hostdata.properties.name = phash["Host Name"];
			hc.hostdata.properties.name = phash["Host Name"];
			hc.hostdata.properties.name = phash["Host Name"];
			hc.hostdata.properties.name = phash["Host Name"];
			hc.updatehostproperties(this.proplist);
		}
	}
}