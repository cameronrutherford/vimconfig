" Asher Mancinelli
"
" Some helpful abbreviations:
"
"
" Python abbreviations
iabbrev pyfn def func(params):
iabbrev pyfor for i in thing:
iabbrev pyclass class Thing:
iabbrev pymain :read ~/.vim/template.py
iabbrev scipy <BS>import pandas as pd
iabbrev osxplt <BS>import matplotlib

" Bash / shell abbreviations
iabbrev sbatch #!/usr/bin/env bash
iabbrev bashfor for i in "${arrayName[@]}"

" C-Style abbreviations
iabbrev fori for (i=low; i<high; i++)
iabbrev forj for (j=low; j<high; j++)
iabbrev fork for (k=low; k<high; k++)
iabbrev printarr for (i=0; i<arr_len; i++)
iabbrev cfn void name()
iabbrev cmain :read ~/.vim/template.c
iabbrev dbg #ifdef __DEBUG
iabbrev inc #include <>
iabbrev incall #include <stdio.h>
iabbrev csign /*
iabbrev cmpi :read ~/.vim/mpi_template.c
iabbrev header ggO#ifndef ###

" Misc abbreviations
iabbrev htmll k:read ~/.vim/template.html
inoreabbrev @g ashermancinelli@gmail.com
inoreabbrev @p asher.mancinelli@pnnl.gov