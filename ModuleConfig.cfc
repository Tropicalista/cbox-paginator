component {

	// Module Properties
	this.title 				= "cbox-paginator";
	this.author 			= "Francesco Pepe";
	this.webURL 			= "https://github/Tropicalista/cbox-paginator";
	this.description 		= "A cool paginator module for ColdBox";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= false;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Model Namespace
	this.modelNamespace		= "cbox-paginator";
	// CF Mapping
	this.cfmapping			= "paginator";
	// Auto-map models
	this.autoMapModels		= true;
	// Module Dependencies
	this.dependencies 		= [];

	function configure(){

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = ""
		};

		// Custom Declared Interceptors
		interceptors = [
		];

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){

	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

}