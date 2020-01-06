## Readme
You need to call the files in this folder from the "original" dotfiles  
For instance, for the **vimrc** file you need to go to _~/.vimrc_ and put
~~~vimscript
source /your/dotfiles/folder/path/vimrc
~~~
in it, and so on
### Vim
The first time you run it on a machine you need to download vim-plug:
~~~vimscript
curl -flo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
~~~
Then you can run :PlugInstall, :PlugUpdate and so on inside the Vim -- [ref][vim-plug-gh]
#### YouCompleteMe (YCM)
You need to go to vim plugins folder and run `install.py` to complete the installation
#### Livedown
You need to install `Node.js` and the Livedown package for it:
~~~bash
npm install -g livedown
~~~
#### Airline, devicons and font-related stuff
Airline requires [Powerline fonts][p-fonts-gh], devicons requires [Nerd fonts][n-fonts-gh]  
Vim (and not gvim!) uses console fonts and console in its turn uses system fonts. To install them, go to the repos above, go to the font you want, download the `.ttf` file, and
1. To install only for current user: put it to the `~/.fonts` folder (if there is no such a folder -- create it) and update your font cache:
~~~bash
fc-cache -fv
~~~
2. To install for all users: the dir is `/usr/share/fonts/truetype/`, the command is the same one but executed as root  

Then choose it in your terminal preferences.
In KDE, the default Konsole font, **Noto Mono**, was supported by the **airline** but not by **devicons**. Its Nerd Font variation is called **NotoMoto Nerd Font**.  
In i3, despite that URxvt itself doesn't go along with vim themes (The problem may be due to its low bit resolution), xfce4-terminal with the system font is already patched (supports both **airline** and **devicons**)
#### Live Latex Preview
It actually took a while to make this work flawlessly. 
* **it is available in AUR.** But I thought that it would be better to manage all the plugins using `vim-plug`
* if you use vim plugin manager, you need to **add `$HOME/.vim/plugged/vim-live-latex-preview/bin` to your `PATH`**, because it uses custom scripts. In case of package manager installation they are just put in `/usr/bin`
* also, if you use plugin manager, **the plugin depends on `mupdf`, `xdotool` and `git`**
* it seems like it was developed for gVim and some things don't work as they should: 

  a general vim reminder: if we're calling a function with `:call func()` (from normal mode), we're entering the Ex, or the command mode and therefore to actually call it we need to put `<CR>` (Enter) at the end (as we were doing when running a command in the editor with the `:`)
  * now, in terminal-based vim (at least - didn't check gVim or neovim) after opening a preview, a blank screen appears. It can be closed with `<CR>` (or `<C-L>`). **This means that after the `<CR>` that closes the function, we need to add another one for closing this annoying window.** It appears that the window only appears when we open/close the window (e.g. `\o`, `\p`), but not when we manipulate its content (e.g. `\-`, `\+`, `\` is the `<LocalLeader>`), so the latter should have only one `<CR>`
  * when opening a preview, we would like to just continue editing the document without manually switching back to vim, and actually the plugins script `mupdf-launch.sh` intend to activate (focus) our editor window back after running the preview. The problem is that it uses `--class` search of `xdotool` along with the `--name` where name is the name of our `.tex` document and class is (surprisingly) `*GVIM`! Regular vim doesn't even have its own class because it runs in the terminal, and I'm not sure that the terminal window of our vim will have name containing our file name. I modified the script to include
	~~~bash
	vim_window_id=$(xdotool getactivewindow)
	~~~
	before we open the pdf and
	~~~bash
	xdotool windowactivate $vim_window_id
	~~~
	at the end of the script. And it just works!  

You may ask why do we need to do all this? Are there any alternatives? There is, it's called (watch those hands) vim-latex-live-preview.  

**Pros:**
* it allows to specify your pdf viewer
* it doesn't have any external scripts  

**Cons:**
* it doesn't update the preview instantly. Here, it's bounded to the vim's `updatetime` and the recommended value is 1000ms, i.e. 1s. In other words, **it autoupdates only once in a second**. And it also produces this flickering reload animation that is very disturbing to me! And does so every second!



[vim-plug-gh]: https://github.com/junegunn/vim-plug
[p-fonts-gh]: https://github.com/powerline/fonts
[n-fonts-gh]: https://github.com/ryanoasis/nerd-fonts

