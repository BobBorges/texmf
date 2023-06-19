#!/bin/bash

# USE THIS TO AUTOMATE THE START OF A LATEX PROJECT.
# SET A BASH ALIAS AND USE IT ALL OVER YOUR SYSTEM.




DIR=$1
TEX=$2




make_tex () {

mkdir $DIR
mkdir $DIR/parts

touch $DIR/$TEX.tex
echo '\documentclass[twoside]{article}
\input{article-preamble.sty}
\input{parts/packages.tex}
\input{parts/meta-info.tex}
\begin{document}
    \maketitle
    \frenchspacing
    Hi '$DOCAUTHOR'
    \pagebreak
    \printbibliography
\end{document}' > $DIR/$TEX.tex


touch $DIR/parts/packages.tex
echo '\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[RE]{'$DOCTITLE'}
\fancyhead[LO]{'$DOCAUTHOR'}
\fancyfoot[RE]{\thepage}
\fancyfoot[LO]{\thepage}
\raggedbottom' > $DIR/parts/packages.tex


touch $DIR/parts/meta-info.tex
echo '\title{'$DOCTITLE'}
\author{'$DOCAUTHOR'}
%\affil{Institute of Slavic Studies, Polish Academy of Sciences}
\date{}' > $DIR/parts/meta-info.tex

cd $DIR && pdflatex $TEX &
sleep 2
xreader $DIR/$TEX.pdf &
nohup emacs $DIR &
cd $DIR && exec bash

}




get_author () {
    
    if [ -z ${DOCAUTHOR+x} ]; then
    
        echo "Who's the author of the document?"
        read DOCAUTHOR        
        get_author

    else
        
        make_tex

    fi

}




get_title () {
    
    if [ -z ${DOCTITLE+x} ]; then

        echo "What should be the name of this document?"
        read DOCTITLE
        get_title

    else

        get_author

    fi

}




if [ -z ${TEX+x} ]; then

    echo "You didn't enter the right number of arguments (must be 2). Try again."
    exit 0

else

    get_title

fi
