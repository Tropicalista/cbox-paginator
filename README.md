# ColdBox pagination made easy!

With this module you can paginate any recordset. The module is primarly developed to work with [qb](https://github.com/coldbox-modules/qb) but it can be used to paginate any query or recordset.

# Installation

To install simply use CommandBox 

    box install cbox-paginator


## Usage

Usage it's really simple:

		// handler Main.cfc
    	query = wirebox.getInstance('QueryBuilder@qb');

		q = query.from('users').paginate(5);

To loop over record:

		rc.users = q.toStruct().data;


To show pagination:

		rc.pag = q.render();
