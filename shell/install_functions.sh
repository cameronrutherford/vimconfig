
install_zsh()
{
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    if [ ! -d $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting ]
    then
        git clone \
            https://github.com/zsh-users/zsh-syntax-highlighting.git \
            $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
    fi

    if [ ! -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]
    then
        git clone \
            https://github.com/zsh-users/zsh-autosuggestions \
            ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    cat ./shell/zshrc.sh >> $rc
}

install_base()
{
    cat ./shell/baserc.sh >> $rc
    [ -d $HOME/.shell/ ] || mkdir -p $HOME/.shell
    cp ./shell/* $HOME/.shell/
}

install_bash()
{
    [ -d $HOME/.oh-my-bash ] || \
        git clone git://github.com/ohmybash/oh-my-bash.git $HOME/.oh-my-bash
    cat ./shell/ohmybashrc.sh >> $rc
}

install_ctags()
{
    [ -f "./tags/$(uname -n)" ] || {
        echo
        echo "./tags/$(uname -n) tags file not found"
        echo
        exit 1
    }
    echo
    echo Generating Ctags...
    echo

    for path in $(echo $PATH | tr ':' '\n'); do
      if [[ -f $path/ctags ]]; then
          if [[ $($path/ctags --version | grep Exuberant | wc -l) -eq 1 ]]; then
            ctags_path=$path
            echo "Found valid ctags at $path"
            break
          fi
      fi
    done
    if [[ -z "$ctags_path" ]]; then echo 'Could not find exuberant ctags...'; exit 1; fi
    
    [ -f ./tags-file ] && rm ./tags-file
    touch ./tags-file
    while read pth
    do
        echo "Searching path $pth for tags."
        find $pth -name '*' | grep -E '\.(h|hpp)$' | $ctags_path/ctags -f ./tags-file \
            --append \
            --fields=+iaSmKz \
            --extra=+q \
            --c++-kinds=cdefgmstuv \
            --c-kinds=cdefgmstuv \
            --language-force="c++" \
            --langmap=c++:+.tcc. \
            -I "_GLIBCXX_BEGIN_NAMESPACE_VERSION _GLIBCXX_END_NAMESPACE_VERSION _GLIBCXX_VISIBILITY+" \
            -L -
    done < "./tags/$(uname -n)"
    mv ./tags-file $HOME/.vim/tags
    rm $HOME/.ctags
    cat > $HOME/.ctags <<EOD
--recurse=yes
--exclude=.git
--exclude=vendor/*
--exclude=node_modules/*
--exclude=db/*
--exclude=log/*
EOD
}

install_vim()
{
    cp vimrc_base $HOME/.vimrc
    [ -d $HOME/.vim ] || mkdir $HOME/.vim

    cp addressbook $HOME/.vim/
    mkdir -p $HOME/.vim/syntax $HOME/.vim/after/syntax

    if [ -f ~/.vim/syntax/cuda.vim ]
    then
      wget https://raw.githubusercontent.com/bfrg/vim-cuda-syntax/master/syntax/cuda.vim -P ~/.vim/syntax/
    fi

    if [ -f ~/.vim/autoclose.vim ]
    then
      curl "https://www.vim.org/scripts/download_script.php?src_id=10873" > ~/.vim/autoclose.vim
    fi

    echo 'highlight link cudaKernelAngles Operator' >> $HOME/.vim/after/syntax/cuda.vim
    echo 'highlight link cudaStorageClass Statement' >> $HOME/.vim/after/syntax/cuda.vim

    if [ ! -d $HOME/.vim/autoload ]
    then
        curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        vim +PlugInstall +q! +q!
    fi

    [ -d $HOME/.vim/templates ] || mkdir $HOME/.vim/templates

    for i in $(ls templates)
    do
        cp templates/$i $HOME/.vim/templates/$i
    done

    for i in $(ls *.vim)
    do
        cp $i $HOME/.vim/$i
    done
}

install_tmux()
{
    echo
    echo Loading default tmux config...
    echo
    cp tmux.conf $HOME/.tmux.conf
}

install_emacs()
{
  ver=$(emacs --version | head -n 1 | cut -f3 -d' ' | cut -f1 -d.)
  if [[ $ver -lt 24 ]]
  then
    echo
    echo "Emacs version too low. Please use a newer version"
    echo "($ver < 24)"
    echo
  fi
  EMACS_HOME=$HOME/.emacs.d
  [ -d $EMACS_HOME ] || mkdir $EMACS_HOME
  cp ./shell/init.el $EMACS_HOME/init.el

  for path in $(echo $PATH | tr ':' '\n'); do
    if [[ -f $path/ctags ]]; then
        if [[ $($path/ctags --version | grep Exuberant | wc -l) -eq 1 ]]; then
          ctags_path=$path
          echo "Found valid ctags at $path"
          break
        fi
    fi
  done
  if [[ -z "$ctags_path" ]]; then echo 'Could not find exuberant ctags...'; return 1; fi
    
  [ -f ./tags-file ] && rm ./tags-file
  touch ./tags-file
  while read pth
  do
      echo "Searching path $pth for tags."
      $ctags_path/ctags -e -R --append -f ./tags-file $pth
  done < "./tags/$(uname -n)"
  mv ./tags-file $HOME/.emacs.d/tags
  cp ./shell/.clang-format ~/.clang-format
}
