# Static 
**Static** is a simple static website builder based on **Haml**, **Sass**, and
**CoffeeScript**, instead of HTML, CSS, and JavaScript.

- **The first rule** of **Static** is you do not talk about **Static**.
- **The second rule** of **Static** is you DO NOT talk about **Static**!
- **The third rule** of **Static** is if someone yells "stop!", goes limp or taps out, the fight is over.
- **The fourth rule** of **Static** is only two guys to a fight.

## Static is Not so Static
**Static** is not so static after all.  With jQuery support for AJAX, sites
built with **Static** can be just as dynamic as any site.  **Static** actually
improves the construction of full feature web apps by completely separating
server logic from the design, layout and interactivity of the web pages.  

Using **Static** for web apps frees you to choose any backed technology, or even
rely completely on 3rd party APIs.  

## Features

* Fully configured toolset, zero configuration.
* Scriptable SVG image creation.
* Bootstrap & jQuery included.
* Optimized, minified output.
* Simple gnu make based build system.
* File watcher for automated build-on-save.
* Matching Docker based server container (optional).
* Supports static and dynamic websites via AJAX.

## Tools
Static uses these tools.

**[haml][1]** - Beautiful, DRY, well-indented, clear markup.

**[sass][2]** - The most mature, stable, and powerful professional grade css extension language.

**[coffeescript][3]** - A little language that compiles into JavaScript.

**[rvm][4]** - Easily install, manage and work with multiple ruby environments.

**[bundler][5]** - The best way to manage your application's dependencies.

**[npm][6]** - The package manager for JavaScript. Build amazing things.   

**[uglify-js][7]** - A JavaScript parser/compressor/beautifier.

**[zopfli][8]** - A compression library programmed to perform very good.


[1]: http://haml.info
[2]: http://sass-lang.com
[3]: http://coffeescript.org
[4]: https://rvm.io
[5]: http://bundler.io
[6]: https://www.npmjs.com
[7]: https://github.com/mishoo/UglifyJS
[8]: https://github.com/google/zopfli

## Installation

1. Clone the repo

    git clone https://github.com/JoshuaKolden/Static.git

2. Install [rvm](https://rvm.io), if you don't have it installed already.

    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    \curl -sSL https://get.rvm.io | bash -s stable

3. With rvm installed, `cd`-ing into the folder should cause rvm to install the requirements.

    cd Static

4. Install fswatch

    brew install fswatch

5. Install CoffeeScript

    npm install -g coffee-script



## License 

This library is licensed under the The MIT License. See the LICENSE file for more information.

