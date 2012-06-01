package com.lmc.models
{
	
	
	import com.lmc.Events.ForemanEvent;
	import com.lmc.utils.ApplicationStore;
	import com.lmc.utils.foremanObject;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	public class baseCollection extends ArrayCollection
	{
		public var name:String;
		public var id:int;
		private var foreman:foremanObject;
		private var model:dataModel;
		public var _type:String;
		public var namehash:Dictionary = new Dictionary();
		public function baseCollection(jsonObject:Object, type:String)
		{
			
			super();
			_type = type;
			model = ApplicationStore.services["model"];
			if (! model){
				model = new dataModel();
				model.modelsetup();
				ApplicationStore.services["model"] = model;
				
			}
			foreman = model.getforemanInstance();
			if (jsonObject){
				if (copy(jsonObject)){
					this.dispatchEvent(new Event("COMPLETED"));
				}
			}
		}
		
		
		public function copy(jsonObject:Object):Boolean{
			
			for each (var obj:Object in jsonObject){
				for each (var entity:Object in obj){
					// this extra loop strips off the type so object.typeobject
					this.addItem(entity);
					namehash[entity.id] = entity.name;
				}
				
			}
			this.refresh();
			return true;
		}
		public function refreshdata():Boolean{
			this.removeAll();
			this.getdata();
			return super.refresh();
			
		}
		public function getdata(fqdn:String="", option:String=""):void{
			
			foreman.fqdn = fqdn;
			foreman.option = option;
			foreman.settype(_type);
			foreman.addEventListener(_type+"Refresh", onServiceHandler);
			foreman.refresh();
		}
		protected function onServiceHandler(event:ForemanEvent):void{ 
			foreman.removeEventListener(_type+"Refresh", onServiceHandler);
			if (copy(event.eventdata)){
				this.dispatchEvent(new Event("COMPLETED"));
			}
		}
		
		public function findbyname(name:String):*{
			for each (var obj:Object in this){
				if (obj.name == name){
					return obj;
				}
			}
			return "";
		}
		public function getSearchResults(name:String, query:String,searchtype:String="ForemanSearchResult"):void{
			// will need to refresh the data
			foreman.addEventListener(searchtype, searchHandler);
			foreman.search(this._type, query + name);
		}
		public function searchHandler(event:ForemanEvent):void{
			
		}
	}
	
}