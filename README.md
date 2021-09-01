# Pushdown

home
: http://hg.sr.ht/~ged/Pushdown

code
: http://hg.sr.ht/~ged/Pushdown

github
: https://github.com/ged/pushdown

docs
: http://deveiate.org/code/pushdown


## Description

A pushdown automaton toolkit for Ruby. It's based on [the State Manager from
the Amethyst project][amethyst-state-manager].

It's still mostly experimental.


## Prerequisites

* Ruby


## Installation

    $ gem install pushdown


## Contributing

You can check out the current development source with Mercurial via its
[project page](http://bitbucket.org/ged/pushdown). Or if you prefer
Git, via [its Github mirror](https://github.com/ged/pushdown).

After checking out the source, run:

    $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the API documentation.


## Author(s)

* Michael Granger <ged@faeriemud.org>

While Pushdown does not contain any [Amethyst Game Engine][amethyst] source code, it does borrow heavily from its ideas and nomenclature. Many thanks to the Amethyst team for the inspiration.

Thanks also to Alyssa Verkade for the initial idea.


## License

This gem includes code from the rspec-expectations gem, used under the
terms of the MIT License:

    Copyright (c) 2012 David Chelimsky, Myron Marston
    Copyright (c) 2006 David Chelimsky, The RSpec Development Team
    Copyright (c) 2005 Steven Baker
    
    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:
    
    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


Pushdown itself is:

Copyright (c) 2019-2021, Michael Granger
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the author/s, nor the names of the project's
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[amethyst]: https://amethyst.rs/
[amethyst-state-manager]: https://book.amethyst.rs/stable/concepts/state.html#state-manager

