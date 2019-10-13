# gco script

Script for git clone and open project in specified JetBrains IDE

## Installation

#### Create Command-line Launcher for JetBrains IDE

* [Idea](https://www.jetbrains.com/help/idea/opening-files-from-command-line.html)  
* [PyCharm](https://www.jetbrains.com/help/pycharm/opening-files-from-command-line.html)
* [Rider](https://www.jetbrains.com/help/rider/Working_with_the_IDE_Features_from_Command_Line.html)
* [Clion](https://www.jetbrains.com/help/clion/opening-files-from-command-line.html)
* [DataGrip](https://www.jetbrains.com/help/datagrip/opening-files-from-command-line.html)
* [AppCode](https://www.jetbrains.com/help/objc/working-with-the-ide-features-from-command-line.html)
* [WebStorm](https://www.jetbrains.com/help/webstorm/opening-files-from-command-line.html)
* [PhpStorm](https://www.jetbrains.com/help/phpstorm/opening-files-from-command-line.html)
* [RubyMine](https://www.jetbrains.com/help/ruby/working-with-the-ide-features-from-command-line.html)

#### Install script

* add gco script to `~/.local/bin/`
* add bash aliases `vi ~/.bash_aliases`
* add needed commands, e.g:
```bash
alias gcow='gco -w'
alias gcop='gco -p'
```

## Usage

* Help: `gco -h`
* `gco -APP URL FOLDER`

By default this script converts any git_url to ssh url (git@), to avoid this: use -o flag

* `gco -APP -o URL FOLDER`

#### Usage examples

* `gco -w URL FOLDER`
* `gco -p URL FOLDER`
* `gco -p -o URL FOLDER`
* `gco -o -w URL FOLDER`

#### Usage examples with bash aliases

* `gcow URL FOLDER`
* `gcow -o URL FOLDER`

## License

* MIT, 2019, [lgg](https://github.com/lgg)
