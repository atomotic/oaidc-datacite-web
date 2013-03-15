oaidc-datacite-web
==================

Minimal ruby/sinatra web application for transforming an oai-dc record into [datacite xml](http://schema.datacite.org/meta/kernel-2.2/index.html) schema and generate a DOI identifier using [DataCite API](https://mds.datacite.org/static/apidoc).

Verify that oai-pmh Identifier verb displays **repositoryIdentifier** and **sampleIdentifier**

**Requirements**: ruby 1.9, redis-server

How to use
----------

* clone the repository

		% git clone https://github.com/atomotic/oaidc-datacite-web.git
* install required gems
	
		% bundle install install --path vendor/bundle
	
* edit **run.rb** with your api credentials. also modify **lib/datacite.rb** to change production or development api endpoint.
	
* start redis server

		% redis-server &
	
* start the application, or deploy the way you like (passenger, unicorn)

		% shotgun run.rb
		
	
		
TODO
----
* improve the logic to guess the oai record identifier from a summary page url
* allow editing of crosswalked metadata with http://codemirror.net/
* better error handling
* improve the xslt for crosswalk oaidc to datacitexml


License
-------
* CC0