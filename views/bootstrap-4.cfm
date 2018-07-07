<cfoutput>
<cfif args.paginator.hasPages()>
    <ul class="pagination" role="navigation">

        <cfif args.paginator.onFirstPage()>
            <li class="page-item disabled" aria-disabled="true" aria-label="@lang('pagination.previous')">
                <span class="page-link" aria-hidden="true">&lsaquo;</span>
            </li>
        <cfelse>
            <li class="page-item">
                <a class="page-link" href="#args.paginator.previousPageUrl() #" rel="prev" aria-label="previous">&lsaquo;</a>
            </li>
        </cfif>

        <cfloop array="#args.elements#" index="i" item="element">
            <cfif !len(element) && !isArray(element)>
                <li class="page-item disabled" aria-disabled="true"><span class="page-link">#element#</span></li>
            </cfif>

            <cfif isArray(element)>
                <cfloop array="#element#" index="a" item="arr">
                    <cfloop collection="#arr#" item="pageNumber">
                        <cfif (pageNumber == args.paginator.getCurrentPage())>
                            <li class="page-item active" aria-current="page"><span class="page-link">#pageNumber#</span></li>
                        <cfelse>
                            <li class="page-item"><a class="page-link" href="#arr[pageNumber]#">#pageNumber#</a></li>
                        </cfif>
                    </cfloop>
                </cfloop>
            </cfif>
        </cfloop>

        <cfif args.paginator.hasMorePages()>
            <li class="page-item">
                <a class="page-link" href="#args.paginator.nextPageUrl() #" rel="next" aria-label="next">&rsaquo;</a>
            </li>
        <cfelse>
            <li class="page-item disabled" aria-disabled="true" aria-label="next">
                <span class="page-link" aria-hidden="true">&rsaquo;</span>
            </li>
        </cfif>
    </ul>
</cfif>
</cfoutput>