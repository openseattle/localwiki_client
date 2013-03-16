LocalwikiClient
===============
[![Build Status](https://travis-ci.org/codeforseattle/localwiki_client.png?branch=master)](https://travis-ci.org/codeforseattle/localwiki_client) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/codeforseattle/localwiki_client)

Synopsis
--------

A thin client for the Localwiki API

http://localwiki.readthedocs.org/en/latest/api.html

Installation
------------

    $ gem install localwiki_client

Usage
-----

## Example

    require 'localwiki_client'

    # read access
    wiki = LocalwikiClient.new 'seattlewiki.net'
    wiki.site_name
    => SeattleWiki
    wiki.count('user')
    => 47

    # write access
    wiki = LocalwikiClient.new 'seattlewiki.net', 'myusername', 'myapikey'
    page_json = {name: 'Current Events', content: 'Coming Soon!'}.to_json
    response = wiki.create('page', page_json)
    response.status
    => 201

Features / Problems
-------------------

* #create, #read (#fetch), #update, #delete provide basic CRUD functionality
* #list fetches all (or with a limit) of a specific type of resource
* #fetch_version retrieves version history for a resource
* a few helper methods exist, more to come
    * #count, #page_by_name, #unique_authors


Compatibility
-------------
 * 2.0.0
 * 1.9.3
 * jruby-19mode
 * rbx-19mode

Contributing
------------

To get your improvements included, please fork and submit a pull request.

Bugs and/or failing tests are very appreciated.

Contributors
------------
Seth Vincent

Brandon Faloona

Helen Canzler

Jerry Frost

Matt Adkins

LICENSE
-------

(The MIT License)

Copyright (c) 2013 Brandon Faloona, Seth Vincent

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
