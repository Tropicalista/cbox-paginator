component {

    function init(){
    	return this;
    }

    public function build( paginator, onEachSide = 3 ){
    	variables.paginator = arguments.paginator;
        return get( arguments.onEachSide );
    }

    /**
     * Get the window of URLs to be shown.
     *
     * @param  int  onEachSide
     * @return array
     */
    public function get( onEachSide = 3 ){
        if ( variables.paginator.getLastPage() < ( arguments.onEachSide * 2 ) + 6) {
            return getSmallSlider();
        }

        return getUrlSlider( arguments.onEachSide );
    }

    /**
     * Get the slider of URLs there are not enough pages to slide.
     *
     * @return array
     */
    private function getSmallSlider(){
        return {
            'first'  = variables.paginator.getUrlRange( 1, variables.paginator.getLastPage() ),
            'slider' = "",
            'last'   = "",
        };
    }

    /**
     * Create a URL slider links.
     *
     * @param  int  onEachSide
     * @return array
     */
    private function getUrlSlider( onEachSide ){
        var window = onEachSide * 2;

        if ( !hasPages() ) {
            return {'first' = "", 'slider' = "", 'last' = ""};
        }

        // If the current page is very close to the beginning of the page range, we will
        // just render the beginning of the page range, followed by the last 2 of the
        // links in this list, since we will not have room to create a full slider.
        if ( currentPage() <= window ){
            return getSliderTooCloseToBeginning( window );
        }

        // If the current page is close to the ending of the page range we will just get
        // this first couple pages, followed by a larger window of these ending pages
        // since we're too close to the end of the list to create a full on slider.
        elseif ( currentPage() > ( variables.paginator.getLastPage() - window ) ){
            return getSliderTooCloseToEnding( window );
        }

        // If we have enough room on both sides of the current page to build a slider we
        // will surround it with both the beginning and ending caps, with this window
        // of pages in the middle providing a Google style sliding paginator setup.
        return getFullSlider( arguments.onEachSide );
    }

    /**
     * Get the slider of URLs when too close to beginning of window.
     *
     * @param  int  window
     * @return array
     */
    private function getSliderTooCloseToBeginning( window ){
        return {
            'first' = variables.paginator.getUrlRange( 1, arguments.window + 2 ),
            'slider' = "",
            'last' = getFinish(),
        };
    }

    /**
     * Get the slider of URLs when too close to ending of window.
     *
     * @param  int  window
     * @return array
     */
    private function getSliderTooCloseToEnding( window ){
        last = variables.paginator.getUrlRange(
            variables.paginator.getLastPage() - ( arguments.window + 2 ),
            variables.paginator.getLastPage()
        );

        return {
            'first' = getStart(),
            'slider' = "",
            'last' = last,
        };
    }

    /**
     * Get the slider of URLs when a full slider can be made.
     *
     * @param  int  onEachSide
     * @return array
     */
    private function getFullSlider( onEachSide ){
        return {
            'first'  = getStart(),
            'slider' = getAdjacentUrlRange( arguments.onEachSide ),
            'last'   = getFinish(),
        };
    }

    /**
     * Get the page range for the current page window.
     *
     * @param  int  onEachSide
     * @return array
     */
    public function getAdjacentUrlRange( onEachSide ){
        return variables.paginator.getUrlRange(
            currentPage() - arguments.onEachSide,
            currentPage() + arguments.onEachSide
        );
    }

    /**
     * Get the starting URLs of a pagination slider.
     *
     * @return array
     */
    public function getStart(){
        return variables.paginator.getUrlRange( 1, 2 );
    }

    /**
     * Get the ending URLs of a pagination slider.
     *
     * @return array
     */
    public function getFinish(){
        return variables.paginator.getUrlRange(
            variables.paginator.getLastPage() - 1,
            variables.paginator.getLastPage()
        );
    }

    /**
     * Determine if the underlying paginator being presented has pages to show.
     *
     * @return bool
     */
    public function hasPages(){
        return variables.paginator.getLastPage() > 1;
    }

    /**
     * Get the current page from the variables.paginator.
     *
     * @return int
     */
    private function currentPage(){
        return variables.paginator.getCurrentPage();
    }

    /**
     * Get the last page from the variables.paginator.
     *
     * @return int
     */
    private function lastPage(){
        return variables.paginator.getLastPage();
    }

}