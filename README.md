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



[vim-plug-gh]: https://github.com/junegunn/vim-plug
[p-fonts-gh]: https://github.com/powerline/fonts
[n-fonts-gh]: https://github.com/ryanoasis/nerd-fonts

