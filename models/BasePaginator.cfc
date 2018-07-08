component accessors="true" {
    
    property name="collection" inject="collect@CFCollection";
    property name="controller" inject="coldbox";

    //All of the items being paginated.
    property name="items";
    //The number of items to be shown per page.
    property name="perPage";
    //The current page being "viewed".
    property name="currentPage";
    //The base path to assign to all URLs.
    property name="path" default="/";
    //The query parameters to add to all URLs.
    property name="query" type="struct";
    //The URL fragment to add to all URLs.
    property name="fragment" default="";
    //The query string variable used to store the page.
    property name="pageName" default="page";
    //The default pagination view.
    property name="defaultView" default='bootstrap-4';
    //The default "simple" pagination view.
    property name="defaultSimpleView" default='simple-bootstrap-4';
	
	function init(){
		return this;
	}

    public function isValidPageNumber( page ){
        return arguments.page >= 1 && isNumeric( arguments.page ) !== false;
    }

    public function previousPageUrl(){
        if ( variables.currentPage > 1 ) {
            return url( variables.currentPage - 1 );
        }
    }

    public function getUrlRange( start, end ){
        return collection().range( arguments.start, arguments.end + 1 ).map( function ( page ) {
            return { "#page#" = url( page ) };
        }).toArray();
    }

    public function url( page ){
        if ( arguments.page <= 0 ) {
            arguments.page = 1;
        }

        // If we have any extra query string key / value pairs that need to be added
        // onto the URL, we will put them in query string form and then attach it
        // to the URL. This allows for extra information like sortings storage.
        var parameters = { "#variables.pageName#" = arguments.page };

        if ( structKeyExists( variables, 'query' ) && structCount( getQuery() ) > 0 ) {
            parameters = structAppend( variables.query, parameters );
        }
        var qstr = Find( "?", getPath() ) > 0 ? "&" : "?";

        return variables.path  
        			& qstr 
        			& StructToQueryString( parameters ) 
                    & buildFragment();
    }

    public function getFragment( fragment = "" ){
        if ( !len( arguments.fragment ) ) {
            return variables.fragment;
        }

        setFragment( arguments.fragment );

        return this;
    }

    public function appends( key, value = "" ){
        if ( isArray( arguments.key ) ) {
            return appendArray( arguments.key );
        }

        return addQuery( arguments.key, arguments.value );
    }

    protected function appendArray( struct keys ){
        for( var k in arguments.keys ){
        	addQuery( k, keys[k] );
        }

        return this;
    }

    public function getItems(){
        return variables.items.all();
    }

    public function resolveCurrentPage( pageName = 'page', default = 1 ){
    	if( structKeyExists( url, 'page' ) && isNumeric(url.page) && url.page > 1 ){
    		return url.page;
    	}

        return arguments.default;
    }

    public function resolveCurrentPath( default = '/' ){
        var event = getController().getRequestService().getContext();

        return  event.getHTMLBaseURL() & event.getCurrentRoutedURL();
    }

    public function withPath( path ){
        setPath( arguments.path );
    }

    public function buildFragment(){
        return len( getFragment() ) ? '##' & getFragment() : '';
    }

    public function firstItem(){
        return count() > 0 ? ( variables.currentPage - 1 ) * variables.perPage + 1 : "";
    }

    public function count(){
    	return variables.items.count();
    }

    public function lastItem(){
        return count() > 0 ? firstItem() + count() - 1 : "";
    }

    public function onFirstPage(){
        return getCurrentPage() <= 1;
    }

    public function hasPages(){
        return getCurrentPage() != 1 || hasMorePages();
    }

    public function toStruct(){
        return {
            'current_page' = getCurrentPage(),
            'data' = variables.items,
            'first_page_url' = variables.url(1),
            'from' = variables.firstItem(),
            'last_page' = variables.nextPageUrl(),
            'last_page_url' = variables.nextPageUrl(),
            'next_page_url' = variables.nextPageUrl(),
            'path' = variables.path,
            'per_page' = getPerPage(),
            'prev_page_url' = previousPageUrl(),
            'to' = variables.lastItem(),
        };
    }

    function StructToQueryString( urlStruct ) {

        var qstr = "";
        var delim1 = "=";
        var delim2 = "&";

        switch (ArrayLen(Arguments)) {
            case "3":
                delim2 = Arguments[3];
            case "2":
                delim1 = Arguments[2];
        }

        for ( key in urlStruct ) {
            qstr = ListAppend( qstr, URLEncodedFormat( LCase(key) ) & delim1 & URLEncodedFormat( urlStruct[key]), delim2 );
        }

        return qstr;
    }

}