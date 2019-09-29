%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------------------- Study Book Class - by Jonas Frede ----------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------------
% CLASS DEFINITION AND PARAMETERS
%------------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}[2017/4/15]%
\newcommand{\classname}{studybook}%
\ProvidesClass{\classname}[2017/10/31 The Studybook Class]%
\providecommand{\baseclass}{scrbook}%

\RequirePackage{etoolbox}
\RequirePackage{xparse}
\newbool{nolistspace}
\newbool{chapteroneline}
\newbool{listtoc}
\newbool{toctoc}
\newbool{hyperrefsupport}
\booltrue{hyperrefsupport}
\newbool{headsepline}
\newbool{footsepline}

\DeclareOption{nohyperref}{\boolfalse{hyperrefsupport}}
\DeclareOption{nolistspacing}{\booltrue{nolistspace}}
\DeclareOption{liststotoc}{\booltrue{listtoc}}
\DeclareOption{chapterinoneline}{\booltrue{chapteroneline}}
\DeclareOption{toctotoc}{\booltrue{toctoc}}
\DeclareOption{headsepline}{\booltrue{headsepline}}
\DeclareOption{footsepline}{\booltrue{footsepline}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\baseclass}} % Fallback

\ProcessOptions\relax

\LoadClass{\baseclass}

\setkomafont{part}{\Huge\bfseries\rmfamily}
\setkomafont{partnumber}{\Huge\bfseries\rmfamily}
\setkomafont{partentry}{\Large\rmfamily}
\setkomafont{chapter}{\Large\bfseries\rmfamily} % Chapter title
\setkomafont{chapterentry}{\large\bfseries\rmfamily} % Chapter title in toc
\setkomafont{section}{\large\rmfamily}
\setkomafont{sectioning}{\rmfamily\bfseries\boldmath}
\setkomafont{subsection}{\large\rmfamily}
\setkomafont{subsubsection}{\rmfamily}
\setkomafont{descriptionlabel}{\bfseries\rmfamily}
\setkomafont{captionlabel}{\small\bfseries\rmfamily}
\setkomafont{caption}{\small\rmfamily}

\setkomafont{pagehead}{\normalfont\small\itshape}
\setkomafont{pagenumber}{\normalfont}

% Simple interface for the user to customize the chapter titles
\ProvideDocumentCommand{\abovechapterskip}{}{\vspace*{20pt}}
\ProvideDocumentCommand{\chapterbelowskip}{}{\vspace*{40pt}}
\ProvideDocumentCommand{\chapterinbetweenskip}{}{\vspace*{20pt}}
\ProvideDocumentCommand{\autodot}{}{}
\ProvideDocumentCommand{\mdtChapapp}{}{}
\ProvideDocumentCommand{\chapteralign}{}{\raggedright}
\ProvideDocumentCommand{\chapterfont}{}{\usekomafont{chapter}}
\ProvideDocumentCommand{\chapterprefixfont}{}{\usekomafont{chapter}}
\DeclareDocumentCommand{\@makechapterhead}{ m }{
  \abovechapterskip
  {\parindent \z@ \chapteralign \normalfont
    \ifnum \c@secnumdepth >\m@ne
    \if@mainmatter
    \ifbool{chapteroneline}{%
      \chapterfont \mdtChapapp\thechapter\autodot\enspace
    }{%
      \chapterprefixfont \@chapapp\space \thechapter
      \par\nobreak
      \chapterinbetweenskip
    }%
    \fi
    \fi
    \interlinepenalty\@M%
    \chapterfont #1\par\nobreak
    \chapterbelowskip
  }
}
\def\@makeschapterhead#1{%
  \abovechapterskip
  {\parindent \z@ \chapteralign
    \normalfont
    \interlinepenalty\@M
    \chapterfont  #1\par\nobreak
    \chapterbelowskip
  }
}


% Addchap provides unnumbered chapters with an entry in the table of contents as well as an updated header
\ProvideDocumentCommand{\addchap}{ s o m }{%
  \chapter*{#3}%
  \markboth{}{}%
  \IfBooleanTF{#1}{%
  }{%
    \IfNoValueTF{#2}{%
      \addchaptertocentry{#3}%
      \markboth{\MakeMarkcase{#3}}{\MakeMarkcase{#3}}%
    }{%
      \addchaptertocentry{#2}%
      \markboth{\MakeMarkcase{#2}}{\MakeMarkcase{#2}}%
    }%
  }%
}%

\ProvideDocumentCommand{\addsec}{ s o m }{%
  \section*{#3}%
  \markright{}%
  \IfBooleanTF{#1}{%
  }{%
    \IfNoValueTF{#2}{%
      \addcontentsline{toc}{section}{#3}%
      \markright{\MakeMarkcase{#3}}%%
    }{%
      \addcontentsline{toc}{section}{#2}%
      \markright{\MakeMarkcase{#2}}%
    }%
  }%
}%

%------------------------------------------------------------------------------
% CLASS OPTIONS
%------------------------------------------------------------------------------

% If the liststotoc option has been passed to the class, add the lists to the table of contents
\ifbool{listtoc}{%
  \patchcmd{\listoftables}{\@starttoc{lot}}{%
    \addchaptertocentry{\listtablename}\@starttoc{lot}%
  }{}{}%
  \patchcmd{\listoffigures}{\@starttoc{lof}}{%
    \addchaptertocentry{\listfigurename}\@starttoc{lof}%
  }{}{}%
}

% If the toctotoc options has been passed to the class, add the table of contents to the table of contents
\ifbool{toctoc}{%
  \patchcmd{\tableofcontents}{\@starttoc{toc}%
}{%
  \addchaptertocentry{\contentsname}\@starttoc{toc}}{}{}%
}

\patchcmd{\tableofcontents}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\tableofcontents}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoffigures}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoffigures}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoftables}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoftables}{\MakeUppercase}{\MakeMarkcase}{}{}

% If the option `nolistspacing' is given, the spacing in the different lists is reduced to single spacing.
% This option is only useful if the spacing of the document has been changed to onehalfspacing or doublespacing.
\ifbool{nolistspace}{
  \patchcmd{\listoffigures}{%
    \@starttoc{lof}
  }{%
    \begingroup%
    \singlespace\@starttoc{lof}\endgroup%
  }{}{}%
  \patchcmd{\listoftables}{%
    \@starttoc{lot}
  }{%
    \begingroup%
    \singlespace\@starttoc{lot}\endgroup%
  }{}{}%
  \patchcmd{\tableofcontents}{%
    \@starttoc{toc}
  }{%
    \begingroup%
    \singlespace\@starttoc{toc}\endgroup%
  }{}{}%
}{}

%------------------------------------------------------------------------------
% REQUIRED PACKAGES
%------------------------------------------------------------------------------

% Essentials
\RequirePackage{babel} % automatically changing names of document elements by language
\RequirePackage{scrbase} % handling language-dependent names of sections/document elements
\RequirePackage{iflang} % Use \IfLanguageName{<lang>}{<then>}{<else>} together with \selectlanguage{<lang>} macro
\RequirePackage{scrhack} % Loads fixes for various packages
\RequirePackage{longtable} % tables that span multiple pages
\RequirePackage{booktabs} % better table rules
\RequirePackage{array} % similar to booktabs
\RequirePackage{caption} % customising the captions
\captionsetup{justification=centerlast,font=small,labelfont=bf,margin=50pt}

% For the fancy looks
\RequirePackage{mdframed} % frame or surrounding bars for highlighting
\RequirePackage{enumitem} % improved enumerations
\RequirePackage{multicol} % Usage: begin{multicols}{#cols} and end{multicols}, multiple columns in one textblock
\RequirePackage{multirow} % Usage similar to above
\RequirePackage{setspace} % changing line spacing
\RequirePackage{tcolorbox} % colored boxes around envrionments
\RequirePackage{sidenotes} % good package for margin notes, they look like footnotes
\RequirePackage[perpage,marginal,multiple,bottom,stable]{footmisc} % better footnotes
\RequirePackage[defaultlines=3,all]{nowidow} % make better paragraphs with page breaks
\RequirePackage[list=true, labelformat=simple, position=bottom]{subcaption} % better captions and multiple subfigures

% Graphics
\RequirePackage{graphicx} % include images
\graphicspath{{images/}{./}} % specifies where to look for included images
\DeclareGraphicsExtensions{.pdf,.png,.jpg,.eps} % favor .pdf over other extensions

% TikZ
\RequirePackage{tikz} % TikZ-Package for good graphics
\RequirePackage{tikzpagenodes} % define nodes on the page area for pictures
\RequirePackage{tikz-qtree} % combine easy qtree-syntax with TikZ

% Mathematics
\RequirePackage{amsmath} % AMS-package for mathematical stuff
\RequirePackage{amssymb} % AMS additional symbol package
\RequirePackage{amsfonts} % AMS additional fonts package
\RequirePackage{latexsym} % more latex symbols available
\RequirePackage[mathscr]{euscript} % better mathscr symbols
\RequirePackage{mathtools} % collection of abbreviation commands such as \coloneqq
\RequirePackage{nicefrac} % better fractionals in text, use \nicefrac{a}{b}
\RequirePackage{amsthm} % AMS theorem environment, to be used with thmtools
\RequirePackage{thmtools} % awesome theorem environments, using amsthm as backend
\RequirePackage[algoruled,linesnumbered,lined]{algorithm2e} % algorithm environment for writing pseudocode
\RequirePackage{algpseudocode}

% Other
\RequirePackage{xargs} % use fancy command definitions
\RequirePackage{xpatch} % use more fancy command definitions
\RequirePackage{xifthen} % use even more fancy command definitions

%------------------------------------------------------------------------------
% DEFINE CUSTOM INFORMATION COMMANDS
%------------------------------------------------------------------------------

\NewDocumentCommand{\documenttitle} { o m }{%
   \IfValueTF{#1}{\def\shorttitle{#1}}{\def\shorttitle{#2}}%
   \def\@title{#2}%
   \def\doctitle{#2}%
}

\DeclareDocumentCommand { \author     } { m } { \DeclareExpandableDocumentCommand    { \authorname } { } {#1} }
\NewDocumentCommand     { \keywords   } { m } { \DeclareExpandableDocumentCommand { \keywordnames  } { } {#1} }

\newcommand{\checktoopen}{% New command to move content to the next page which prints to the next odd page if twosided mode is active
  \if@openright\cleardoublepage\else\clearpage\fi
  \ifdef{\phantomsection}{\phantomsection}{}% The \phantomsection command is necessary for hyperref to jump to the correct page
}

\NewDocumentCommand{\bhrule}{}{\typeout{--------------------}}
\NewDocumentCommand{\tttypeout}{m}{\bhrule\typeout{\space #1}\bhrule}

\newcommand{\thinRule}{\rule{\textwidth}{0.25pt}} % New command to make the lines in the title page
\newcommand{\decoRule}{\rule{.8\textwidth}{.4pt}} % New command for a rule to be used under figures

% similar to \hrule but above the base line
\def\Hrulefill{\leavevmode\leaders\hrule height 0.8ex depth -0.6ex\hfill\kern0pt}

\setcounter{tocdepth}{3} % The depth to which the document sections are printed to the table of contents
\ProvideDocumentCommand{\addchaptertocentry}{ m }{%
  \addcontentsline{toc}{chapter}{#1}%
}

%------------------------------------------------------------------------------
% COLOURS
%------------------------------------------------------------------------------

\RequirePackage{xcolor} % Required for specifying custom colours, with extended names

\definecolor{mainColor}{HTML}{C50E1F}

%------------------------------------------------------------------------------
% GEOMETRY AND MARGINS
%------------------------------------------------------------------------------

\RequirePackage{geometry}

\raggedbottom % Variable page heights/bottoms

%------------------------------------------------------------------------------
% PENALTIES
%------------------------------------------------------------------------------

\pretolerance=60
\tolerance=2000
\widowpenalty=9999
\doublehyphendemerits=10000 % No consecutive line hyphens
\brokenpenalty=10000 % No broken words across columns/pages
\widowpenalty=9999 % Almost no widows at bottom of page
\clubpenalty=9999 % Almost no orphans at top of page
\interdisplaylinepenalty=100
\predisplaypenalty=50
\interfootnotelinepenalty=9999 % Almost never break footnotes

%------------------------------------------------------------------------------
% HEADERS AND FOOTERS
%------------------------------------------------------------------------------

\RequirePackage{lastpage}
\RequirePackage[markcase=used,automark]{scrlayer-scrpage}
\providepairofpagestyles{simple}{%
  \clearpairofpagestyles%
  \automark[chapter]{chapter}
  \ihead{}% Inner header
  \chead{\Hrulefill\quad \headmark \quad\Hrulefill}% Center header
  \ohead{}% Outer header
  \ifoot{}% Inner footer
  \cfoot[\Hrulefill\quad \pagemark /\pageref{LastPage} \quad\Hrulefill]{\Hrulefill\quad \pagemark /\pageref{LastPage} \quad\Hrulefill}% Center footer
  \ofoot{}% Outer footer
}
\pagestyle{simple}
\providepairofpagestyles[simple]{book}{%
  \automark*[section]{}%
}
\providepairofpagestyles[simple]{review}{%
  \ofoot[\shorttitle/\authorname]{\shorttitle/\authorname}
  \ifoot[\today]{\today}
}
\pagestyle{book}
\ifbool{headsepline}{\KOMAoption{headsepline}{true}}{}
\ifbool{footsepline}{\KOMAoption{footsepline}{true}}{}
\PreventPackageFromLoading[\ClassError{\classname}{Package `fancyhdr' is incompatible\MessageBreak with this class}{The pagesyles are defined using package `scrlayer-scrpage', please consult the\MessageBreak KOMA-script documentation for details.}]{fancyhdr}

\DeclareDocumentCommand\cleardoublepage{}{\clearpage\if@twoside \ifodd\c@page\else
  \hbox{}
  \thispagestyle{empty}
  \newpage
  \if@twocolumn\hbox{}\newpage\fi\fi\fi%
}

%------------------------------------------------------------------------------
% ENVIRONMENTS
%------------------------------------------------------------------------------

% predefined theorem-like styles defined with the thmtools front-end
% using amsthm as the back-end required above TODO: invoke thmtools again

\swapnumbers % "1.2 Definition" (swapnumbers on) or "Definition 1.2" (standard)

% --- Theorems ---
% \newtheoremstyle{name}% name of the style to be used
%  {spaceabove}% measure of space to leave above the theorem. E.g.: 3pt
%  {spacebelow}% measure of space to leave below the theorem. E.g.: 3pt
%  {bodyfont}% name of font to use in the body of the theorem
%  {indent}% measure of space to indent
%  {headfont}% name of head font
%  {headpunctuation}% punctuation between head and body
%  {headspace}% space after theorem head; " " = normal interword space
%  {headspec}% Manually specify head

% Custom Theorem with break
\newtheoremstyle{thmStyle} % Own Style
  {\parsep}   % ABOVESPACE
  {\topsep}   % BELOWSPACE
  {\normalfont\itshape}  % BODYFONT
  {0pt}       % INDENT (empty value is the same as 0pt)
  {\normalfont\bfseries} % HEADFONT
  {}          % HEADPUNCT
  {\newline}  % HEADSPACE.
  {}          % CUSTOM-HEAD-SPEC

\newtheoremstyle{defStyle}
  {\parsep}   % ABOVESPACE
  {\topsep}   % BELOWSPACE
  {\normalfont}  % BODYFONT
  {0pt}       % INDENT (empty value is the same as 0pt)
  {\normalfont\bfseries} % HEADFONT
  {}          % HEADPUNCT
  {\newline}  % HEADSPACE.
  {}          % CUSTOM-HEAD-SPEC


\newtheoremstyle{rmkStyle}
  {\parsep}   % ABOVESPACE
  {\topsep}  % BELOWSPACE
  {\normalfont}  % BODYFONT
  {0pt}       % INDENT (empty value is the same as 0pt)
  {\normalfont\bfseries} % HEADFONT
  {.}         % HEADPUNCT
  {0.5em}     % HEADSPACE. `plain` default: {5pt plus 1pt minus 1pt}
  {}          % CUSTOM-HEAD-SPEC

% Custom Proof
% \qedsymbol will be a colored solid square
\renewcommand\qedsymbol{$\color{mainColor}\blacksquare$}
%\renewenvironment{proof}{{\bfseries Proof:}}{\qed}
\renewenvironment{proof}[1][\proofname]{{\normalfont\bfseries #1: }}{\qed}

% Multilanguage Support - ngerman and english
\newcommand{\theoremname}{}%
\newcommand{\corollaryname}{}%
\newcommand{\examplename}{}%
\newcommand{\remarkname}{}%

\addto\captionsenglish{%
  \renewcommand{\theoremname}{Theorem}%
  \renewcommand{\corollaryname}{Corollary}%
  \renewcommand{\examplename}{Example}%
  \renewcommand{\remarkname}{Remark}%
}
\addto\captionsngerman{%
  \renewcommand{\theoremname}{Satz}%
  \renewcommand{\corollaryname}{Korollar}%
  \renewcommand{\examplename}{Beispiel}%
  \renewcommand{\remarkname}{Bemerkung}%
}


\theoremstyle{thmStyle}
\newtheorem{theorem}{\protect\theoremname}[section] % all use the same counter
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{corollary}[theorem]{\protect\corollaryname}

\theoremstyle{defStyle}
\newtheorem{definition}[theorem]{Definition} % uses same counter as above
\newtheorem{example}[theorem]{\protect\examplename}

\theoremstyle{rmkStyle}
\newtheorem*{remark}{\protect\remarkname} % uncounted/unnumbered remark
\newtheorem*{notation}{Notation}

%------------------------------------------------------------------------------
% OTHER CONFIGURATION
%------------------------------------------------------------------------------

% TODO notes (Usage: \todonote, \todowarning, \todoerror or \todofatal [<options>]{<text>})
\usepackage[english,status=draft,inline,nomargin,marginclue]{fixme}
\fxusetheme{color}
\usepackage{chngcntr}
\newcounter{todocounter} % custom counter inside fixmes
\newcounter{todochaptercounter}
\counterwithin{todochaptercounter}{section}
\newcommand{\todonote}[2][]{\stepcounter{todocounter}\stepcounter{todochaptercounter}\fxnote[#1]{\thetodochaptercounter -(\thetodocounter): #2}}
\newcommand{\todowarning}[2][]{\stepcounter{todocounter}\stepcounter{todochaptercounter}\fxwarning[#1]{\thetodochaptercounter -(\thetodocounter): #2}}
\newcommand{\todoerror}[2][]{\stepcounter{todocounter}\stepcounter{todochaptercounter}\fxerror[#1]{\thetodochaptercounter -(\thetodocounter): #2}}
\newcommand{\todofatal}[2][]{\stepcounter{todocounter}\stepcounter{todochaptercounter}\fxfatal[#1]{\thetodochaptercounter -(\thetodocounter): #2}}

% Lists
\setlist[enumerate]{label={{\rmfamily{\roman*})}},leftmargin=6mm,nosep}
\setlist[itemize]{label={$\vcenter{\hbox{\tiny$\bullet$}}$},leftmargin=6mm,nosep}

%------------------------------------------------------------------------------
% HYPERREF (NEEDS TO BE LAST)
%------------------------------------------------------------------------------

\ifbool{hyperrefsupport}{% If the nohyperref class option has not been specified
\AtEndPreamble{\RequirePackage{hyperref}
\hypersetup{pdfpagemode={UseOutlines},
bookmarksopen=true,
bookmarksnumbered=true,
bookmarksopenlevel=0,
hypertexnames=true,
colorlinks=true, % Set to false to disable coloring links
citecolor=mainColor, % The color of citations
linkcolor=mainColor, % The color of references to document elements (sections, figures, etc)
urlcolor=mainColor, % The color of hyperlinks (URLs)
anchorcolor=mainColor,
pdfstartview={FitV},
breaklinks=true,
unicode=true,
}

\pdfstringdefDisableCommands{% If there is an explicit linebreak in a section heading (or anything printed to the pdf-bookmarks), it is replaced by a space
  \let\\\space%
  }
}
}{% nothing else
}

% -----------------------------------------------------------------------------
\endinput
%------------------------------------------------------------------------------
