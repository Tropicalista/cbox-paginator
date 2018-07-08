component extends="BasePaginator" accessors="true" {

	property name="renderer" inject="provider:coldbox:renderer";
	property name="links" inject="links@cbox-paginator";

	property name="total";
	property name="lastPage";

	function init(){
		return this;
	}

    function build(	items = [], 
			    	total = "", 
			    	perPage = 10, 
			    	currentPage = "", 
			    	struct options = {}
    ){
        for( option in options ){
        	variables[option] = options[option];
        }

        variables.total = arguments.total;
        variables.perPage = arguments.perPage;
        variables.lastPage = max( javacast('int', ceiling( variables.total / variables.perPage ) ), 1);
        variables.currentPage = setCurrentPage( arguments.currentPage );
        variables.path = (variables.path != '/') ? rtrim( variables.path ) : variables.path;
        variables.items = IsInstanceOf( arguments.items, "cfcollection.models.Collection" ) ? arguments.items : Collection().collect(arguments.items);

        return this;
    }

    public function setCurrentPage( currentPage ){
        currentPage = structKeyExists( arguments, currentPage ) ? arguments.currentPage : resolveCurrentPage();

        return isValidPageNumber( currentPage ) ? javacast('int', currentPage) : 1;
    }

	function render( view, data = [] ){
		view = structKeyExists( arguments, 'view' ) ? arguments.view : getDefaultView();
		return renderer.renderView( view=view, args={ 'paginator'=this, 'elements' = elements() }, module="cbox-paginator" );
	}

	function elements( linkBuilder ){
		var links = links.build(this);
        var paging = [
            links['first'],
            isArray(links['slider']) ? "..." : "",
            links['slider'],
            isArray(links['last']) ? "..." : "",
            links['last'],
        ];

        return paging;
	}

    public function nextPageUrl(){
        if ( getLastPage() > getCurrentPage() ) {
            return url( getCurrentPage() + 1 );
        }
    }

    public function hasMorePages(){
        return getCurrentPage() < getLastPage();
    }

    public function toStruct(){
        return {
            'current_page' = getCurrentPage(),
            'data' = items.toArray(),
            'first_page_url' = url(1),
            'from' = firstItem(),
            'last_page' = getLastPage(),
            'last_page_url' = url(getLastPage()),
            'next_page_url' = nextPageUrl(),
            'path' = path,
            'per_page' = getPerPage(),
            'prev_page_url' = previousPageUrl(),
            'to' = lastItem(),
            'total' = getTotal(),
        };
    }

    public function jsonSerialize(){
        return toStruct();
    }

    public function toJson(){
        return serializeJSON( jsonSerialize() );
    }
}