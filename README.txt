The gincltex Package
Copyright (c) 2011-2022 -- Martin Scharrer <martin.scharrer@web.de>

This small package builds on the standard LaTeX packages graphic
and/or graphicx and allows external LaTeX source files to be included like
graphic files, i.e. adds support for the `.tex' extension.

    \includegraphics[<options>]{somefile.tex}

Some of the lower level operations like clipping and trimming are implemented
using the authors other package 'adjustbox' which supports native pdflatex support
and itself uses the 'pgf' package for other output formats.

