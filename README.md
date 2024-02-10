# Sample PHP REST API with Slim Framework

## Stack

-   PHP (see version in composer.json)
-   [Slim Framework](https://www.slimframework.com/)
-   [Composer](https://getcomposer.org/)

## Getting Started

Install PHP. With macOS [Homebrew](https://brew.sh/):

```shell
brew install php@8.3 # use version in composer.json
```

Install the package manager [composer](https://getcomposer.org/doc/00-intro.md).

Install dependencies:

```shell
composer install
```

To start the web server:

```shell
cd public/
php -S localhost:8888
```

### Using the Debugger in VSCode

Install VSCode's [PHP Debug extension](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug).

Install [XDebug](https://xdebug.org/docs/install). Be sure to read the "Issues on macOS" and see [this StackOverflow post](https://stackoverflow.com/questions/68944020/why-does-the-installation-of-xdebug-on-my-mac-not-work/73818341#73818341).

Next, find the location of your PHP configuration file:

```shell
php -i | grep ".ini"
```

You can add this below to your "Loaded Configuration File". However, I recommend that you create a new file "xdebug.ini" file inside of the "Scan this dir for additional .ini files" directory.

```ini
zend_extension=xdebug

[xdebug]
xdebug.mode=debug
xdebug.client_host=127.0.0.1
xdebug.client_port=9003
xdebug.start_with_request=yes
```

To confirm that XDebug is configured, either run `php -i` or create a php file with `<?php phpinfo()`. You should see the XDebug is enabled and a checkmark by "Step Debugger". For example:

```
__   __   _      _
\ \ / /  | |    | |
 \ V / __| | ___| |__  _   _  __ _
  > < / _` |/ _ \ '_ \| | | |/ _` |
 / . \ (_| |  __/ |_) | |_| | (_| |
/_/ \_\__,_|\___|_.__/ \__,_|\__, |
                              __/ |
                             |___/

Version => 3.3.1
Support Xdebug on Patreon, GitHub, or as a business: https://xdebug.org/support

             Enabled Features (through 'xdebug.mode' setting)
Feature => Enabled/Disabled
Development Helpers => ✘ disabled
Coverage => ✘ disabled
GC Stats => ✘ disabled
Profiler => ✘ disabled
Step Debugger => ✔ enabled
Tracing => ✘ disabled
```

You can now use the [debugger and breakpoints in VSCode](https://code.visualstudio.com/docs/editor/debugging).
