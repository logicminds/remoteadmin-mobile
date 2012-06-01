package com.lmc.controllers
{
	import com.lmc.Events.ForemanEvent;
	import com.lmc.components.AlertBox;
	import com.lmc.ralib.model.certificate;
	import com.lmc.models.dataModel;
	import com.lmc.ralib.model.smartproxy;
	import com.lmc.utils.ApplicationStore;
	import com.lmc.utils.ToastUtil;
	import com.lmc.utils.foremanObject;
	import com.lmc.utils.foremanloader;
	import com.lmc.Events.ForemanEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import spark.components.Application;
	
	public class CertController extends EventDispatcher
	{
	    private var model:dataModel;
		private var sp:smartproxy;
		private var sproxies:Array;
		private var event:ForemanEvent;
		//private var toaster:ToastUtil = new ToastUtil(this. as DisplayObject)
		private var floader:foremanloader
		private var foreman:foremanObject;
		[Binding] public var certs:ArrayCollection;
		public function CertController()
		{
			super();
			model = ApplicationStore.services["model"];
			if (! model){
				model = new dataModel();
				model.modelsetup();
				ApplicationStore.services["model"] = model;
			}
			foreman = model.getforemanInstance();
			initdata();
			
		}
		private function refreshCerts():void{
			// check for value in cache
			certs = ApplicationStore.services["certs"];
			foreman.addEventListener("ProxyFailure", spFaultHandler);

			// Make a call to the proxy to get the certificates
			if (certs == null){
				foreman.addEventListener("CertRefresh", certHandler);
				foreman.getproxyinfo(this.sp.id);
			}
			else{
				trace("Certs cache hit");
				this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
			}
		}
		public function refresh():void{
			foreman.addEventListener("CertRefresh", certHandler);
			foreman.getproxyinfo(this.sp.id);
		}
		public function revoke(cert:certificate):void{
			update(cert.name, "DELETE");
		}
		public function clean(cert:certificate):void{
			update(cert.name, "DELETE");
		}
		public function accept(cert:certificate):void{
			update(cert.name, "PUT");
		}
		private function update(resource:String, type:String):void{
			if (!floader){
				floader = new foremanloader();
			}
			var obj:Object = new Object();
			obj.smart_proxy_id = sp.id.toString();
			obj.id = resource;
			var url:String= "/smart_proxies/" + sp.id + "/puppetca/" + resource;
			floader.setrequest(url, obj,type);
			floader.addEventListener("SuccessfulChange", onSuccess);
			floader.addEventListener("FailedChange", onFailure);

			floader.send();
		}
		private function onSuccess(event:Event):void{
			floader.removeEventListener("SuccessfulChange", onSuccess);
			//toaster.popToast("Certificate change successful");
			event = new ForemanEvent("ProxyStatus", "CHANGE_SUCCESS");
			this.dispatchEvent(event);

			this.refresh();
			
			
		}
		private function spFaultHandler(event:ForemanEvent):void{
			foreman.removeEventListener("ForemanConnectionFault", spFaultHandler);
			event = new ForemanEvent("ProxyStatus", "PROXY_UNREACHABLE");
			this.dispatchEvent(event);
		}
		private function onFailure(event:Event):void{
			floader.removeEventListener("FailedChange", onFailure);
			event = new ForemanEvent("ProxyStatus", "CHANGE_FAILED");
			this.dispatchEvent(event);

		//	toaster.popToast("Certificate change failed");
		}
		
		private function initdata():void{
			
			sproxies = ApplicationStore.services["sproxies"];
			if (sproxies == null){
				// no proxies defined, get proxies
				foreman.addEventListener("ProxyRefresh", proxyHandler);
				foreman.getproxyinfo(0,"proxylist");

				return;
				
			}
			else if (sproxies.length == 0){
				event = new ForemanEvent("ProxyStatus", "NO_PROXIES_DEFINED");
				// popup alert saying no proxies defined
				this.dispatchEvent(event);
				return;
			}
			else {
				var spnum:int = sproxies.length;
				if (spnum > 1){
					// ask user which proxy to use
					event = new ForemanEvent("ProxyStatus", "MULTIPLE_PROXIES_DEFINED");
					this.dispatchEvent(event);
				}
				for (var n:int=0; n < spnum; n++){
					if (n == 0){
						// by default use first proxy
						var temp:Object = sproxies[n];
						sp = new smartproxy(temp.smart_proxy);
						
					}
					else{
						event = new ForemanEvent("ProxyStatus", "NO_PROXIES_DEFINED");
						this.dispatchEvent(event);

					}
				}
				refreshCerts();

			}
		}
		private function certHandler(event:ForemanEvent):void{
			foreman.removeEventListener("CertRefresh", certHandler);
			
			certs = event.eventdata as ArrayCollection;
			ApplicationStore.services["certs"] = this.certs;
			certs.refresh();
			this.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
		}
	
		private function proxyHandler(event:ForemanEvent):void{
			foreman.removeEventListener("ProxyRefresh", proxyHandler);
			var num:int = event.eventdata.length;
			sproxies = event.eventdata as Array;
			ApplicationStore.services["sproxies"] = sproxies;
			initdata();
			
		}
		
		
	}
}