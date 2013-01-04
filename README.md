LocalWiki
=========

Synopsis
--------

A thin wrapper around the LocalWiki API

http://localwiki.readthedocs.org/en/latest/api.html

Installation
------------

    $ gem install localwiki

Usage
-----

## Example

    require 'localwiki'
    site = LocalWiki.new 'seattlewiki.net'
    puts site.name
    # => "SeattleWiki"
    puts site.total_resources('user')
    # => "47"

Contributing
------------

To get your improvements included, please fork and submit a pull request.
Bugs and/or failing tests are very appreciated.

LICENSE
-------

(The MIT License)

Copyright (c) 2012 Brandon Faloona, Seth Vincent

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
