puppet-github-face
==================

Description
-----------

A Puppet Face for managing Puppet modules located on GitHub

It's heavily based on Jesse Newland's knife-github-cookbooks Knife
plugin (https://github.com/websterclay/knife-github-cookbooks). He's a
cool guy and you should check out his other work like Rump
(https://github.com/railsmachine/rump).

Requirements
------------

* `git`
* `puppet ~> 2.7.0`

Installation
------------

As yet not packaged as a Gem.

    $ gem install puppet-github-face

Usage
-----

### Installing modules

Say you wanted to install the `yum` modules located at
https://github.com/module/yum. To do so, you'd run the following command:

    $ puppet github install module/yum

The repo at https://github.com/modules/yum will be cloned into a temporary
directory, moved into your module path.

By default, the public `git://` URI will be used. To clone a private repo via
the `git@` URI, pass the `--ssh` option:

    $ puppet github install secret/secret_module --ssh

Conventions
-----------

If the repo you're trying to install is prefixed or suffixed with
`puppet` and/or `modules`, this will be stripped from the repo name. For example, 
running:

    $ puppet faces github install modules/puppet-mysql_module

Will create the modules in the `mysql` directory in the module path.

Author
------

James Turnbull <james@lovedthanlost.net>

With much thanks to Jesse Newland for inspiration.

License
-------

    Author:: James Turnbull (<james@lovedthanlost.net>)
    Copyright:: Copyright (c) 2011 James Turnbull
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
