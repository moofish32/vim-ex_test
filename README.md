# ExTest.vim

This is a lightweight ExTest runner for Vim and MacVim.

## Installation

Recommended installation with [vundle](https://github.com/gmarik/vundle):

```vim
Plugin 'moofish32/vim-ex_test'
```

If using zsh on OS X it may be necessary to move `/etc/zshenv` to `/etc/zshrc`.

## Configuration

### Key mappings

Add your preferred key mappings to your `.vimrc` file.

```vim
" ExTest.vim mappings
map <Leader>t :call RunCurrentTestFile()<CR>
map <Leader>s :call RunNearestTest()<CR>
map <Leader>l :call RunLastTest()<CR>
map <Leader>a :call RunAllTests()<CR>
```

### Custom command

Overwrite the `g:ex_test_command` variable to execute a custom command.

Example:

```vim
let g:ex_test_command = "mix test --cover /tmp/cover {test}"
```

This `g:ex_test_command` variable can be used to support any number of test
runners or pre-loaders. For example, to use
[Dispatch](https://github.com/tpope/vim-dispatch):

```vim
let g:ex_test_command = "Dispatch mix test {test}"
```

### Custom runners

Overwrite the `g:ex_test_runner` variable to set a custom launch script. At the
moment there are two MacVim-specific runners, i.e. `os_x_terminal` and
`os_x_iterm`. The default is `os_x_terminal`, but you can set this to anything
you want, provided you include the appropriate script inside the plugin's
`bin/` directory.

#### iTerm instead of Terminal

If you use iTerm, you can set `g:ex_test_runner` to use the included iterm
launching script. This will run the specs in the last session of the current
terminal.

```vim
let g:ex_test_runner = "os_x_iterm"
```

If you use the iTerm2 nightlies, the `os_x_iterm` runner will not work
(due to AppleScript incompatibilities between the old and new versions of iTerm2).

Instead use the `os_x_iterm2` runner, configure it like so:

```vim
let g:ex_test_runner = "os_x_iterm2"
```

## Running tests

Tests are written using [`vim-vspec`](https://github.com/kana/vim-vspec)
and run with [`vim-flavor`](https://github.com/kana/vim-flavor).

Install the `vim-flavor` gem, install the dependencies and run the tests:

```
gem install vim-flavor
vim-flavor install
rake
```

Credits
-------

This is really just a name change on the great work by: 

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

rspec.vim is maintained by [thoughtbot, inc](http://thoughtbot.com/community)
and [contributors](https://github.com/thoughtbot/vim-rspec/graphs/contributors)
like you. Thank you!

It was strongly influenced by Gary Bernhardt's [Destroy All
Software](https://www.destroyallsoftware.com/screencasts) screencasts.

The names and logos for thoughtbot are trademarks of thoughtbot, inc.

## License

ExText.vim is free software, and may be
redistributed under the terms specified in the `LICENSE` file.

