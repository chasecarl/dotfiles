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
#### YouCompleteMe (YMC)
You need to go to vim plugins folder and run `install.py` to complete the installation
#### Livedown
You need to install `Node.js` and the Livedown package for it:
~~~bash
npm install -g livedown
~~~



[vim-plug-gh]: https://github.com/junegunn/vim-plug

