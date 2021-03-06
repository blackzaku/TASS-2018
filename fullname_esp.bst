%%% fullname.bst
%%%
%%% Stuart M. Shieber
%%% Mon Mar 30 17:23:36 EST 1992

%%% Intended for use with the style file "fullname.sty"

%%% Fri Jan  6 12:39:41 1995    
%%% See note below (in function sort.format.names) for alternate
%%% reference sorting method for names with particles.


%%% Modification of BibTeX style file "aaai-named" by Peter
%%% Patel-Schneider
%%% Original header information:

% BibTeX `aaai-named' style file for BibTeX version 0.99c, LaTeX version 2.09
% This version was made by modifying the master file made by
% Oren Patashnik (PATASHNIK@SCORE.STANFORD.EDU)

% Copyright (C) 1985, all rights reserved.
% Modifications Copyright 1988, Peter F. Patel-Schneider
% Copying of this file is authorized only if either
% (1) you make absolutely no changes to your copy, including name, or
% (2) if you do make changes, you name it something other than
% btxbst.doc, plain.bst, unsrt.bst, alpha.bst, and abbrv.bst.
% This restriction helps ensure that all standard styles are identical.

% There are undoubtably bugs in this style.  If you make bug fixes,
% improvements, etc.  please let me know.  My e-mail address is:
%   pfps@spar.slb.com

%   Citation format: [author-last-name, year]
%            [author-last-name and author-last-name, year]
%            [author-last-name {\em et al.}, year]
%
%   Reference list ordering: alphabetical by author or whatever passes
%   for author in the absence of one.
%
% This BibTeX style has support for short (year only) citations.  This
% is done by having the citations actually look like
%         \citename{name-info, }year
% The LaTeX style has to have the following
%     \let\@internalcite\cite
%     \def\cite{\def\citename##1{##1}\@internalcite}
%     \def\shortcite{\def\citename##1{}\@internalcite}
%     \def\@biblabel#1{\def\citename##1{##1}[#1]\hfill}
% which makes \shortcite the macro for short citations.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Changes made by SMS:
%   no emphasis on "et al."
%   "Ph.D." includes periods (not "PhD")
%   moved year to immediately after author's name
% Changes made by SMS for compatability with MIT Press style
%   inverted first and last names for first author
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
  }
  {}
  { label extra.label sort.label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
    { add.period$ write$
      newline$
      "\newblock " write$
    }
    { output.state before.all =
        'write$
        { add.period$ " " * write$ }
      if$
    }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.bibitem}
{ newline$

  "\bibitem[" write$
  label write$
  "]{" write$

  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
    'skip$
    { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {y}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  y
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  y
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

%%% This function reverses the first name in the author list, e.g.,
%%% Dewey, John, Thomas Cheatham, and Elias Howe.
%%% For editor names, no reversal is appropriate, so
%%% format.names.unreversed is used.

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }

    { s nameptr 
       nameptr #1 >
              { "{f.~}{vv~}{ll}{, jj}" }
              { "{vv~}{ll}{, jj}{, f.}" }
       if$
        format.name$ 't :=
      nameptr #1 >
    { namesleft #1 >
%rafa        { ", " * t * }
        { ", " * t * }
        { numnames #2 >
        { "," * }
        'skip$
          if$
          t "otros" =
        { " et~al." * }
        { " y " * t * }
          if$
        }
      if$
    }
    't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.names.unreversed}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }

    { s nameptr "{f.~}{vv~}{ll}{, jj}" format.name$ 't :=

      nameptr #1 >
    { namesleft #1 >
%rafa        { ", " * t * }
        { " " * t * }
        { numnames #2 >
        { "," * }
        'skip$
          if$
          t "otros" =
        { " et~al." * }
        { " y " * t * }
          if$
        }
      if$
    }
    't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
    { ", editores" * }
    { ", editor" * }
      if$
    }
  if$
}

FUNCTION {format.editors.unreversed}
{ editor empty$
    { "" }
    { editor format.names.unreversed
      editor num.names$ #1 >
    { ", editores" * }
    { ", editor" * }
      if$
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }

    { title "t" change.case$ }

  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
    { t #1 #2 substring$ "--" = not
        { "--" *
          t #2 global.max$ substring$ 't :=
        }
        {   { t #1 #1 substring$ "-" = }
        { "-" *
          t #2 global.max$ substring$ 't :=
        }
          while$
        }
      if$
    }
    { t #1 #1 substring$ *
      t #2 global.max$ substring$ 't :=
    }
      if$
    }
  while$
}

FUNCTION {format.date}
{ year empty$
    { month empty$
    { "" }
    { "there's a month but no year in " cite$ * warning$
      month
    }
      if$
    }
    { month empty$
    { "" }
    { month }
      if$
    }
  if$
}

FUNCTION {format.btitle}
{ title emphasize
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { "volumen" volume tie.or.space.connect
      series empty$
    'skip$
    { " de " * series emphasize * }
      if$
      "volumen y numero" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
    { series field.or.null }
    { output.state mid.sentence =
        { "numero" }
        { "Numero" }
      if$
      number tie.or.space.connect
      series empty$
        { "there's a number but no series in " cite$ * warning$ }
        { " en " * series * }
      if$
    }
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
    { edition "l" change.case$ " edici\'on" * }
    { edition "t" change.case$ " edici\'on" * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      y
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
    { #1 'multiresult := }
    { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
    { "p\'aginas" pages n.dashify tie.or.space.connect }
    { "p\'agina" pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.year.label}
{ year extra.label *
}

FUNCTION {format.vol.num.pages}
{ volume field.or.null
  number empty$
    'skip$
    { "(" number * ")" * *
      volume empty$
    { "there's a number but no volume in " cite$ * warning$ }
    'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
    { pop$ format.pages }
    { ":" * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
    { "cap\'itulo" }
    { type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
    'skip$
    { ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
    { "En " booktitle emphasize * }
    { "En " format.editors.unreversed * ", " * booktitle emphasize * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  y y y y y

  key empty$ not y

    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Informe T\'ecnico" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
    { "need key or journal for " cite$ * " to crossref " * crossref *
      warning$
      ""
    }
    { "En {\em " journal * "\/}" * }
      if$
    }
    { "En " key * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
    'skip$
    { editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "otros" =
        { " et~al." * }
        { " y " * editor #2 "{vv~}{ll}" format.name$ * }
      if$
    }
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "En "
    }
    { "Volumen" volume tie.or.space.connect
      " de " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
    { series empty$
        { "need editor, key, or series for " cite$ * " to crossref " *
          crossref * warning$
          "" *
        }
        { "{\em " * series * "\/}" * }
      if$
    }
    { key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
    { booktitle empty$
        { "need editor, key, or booktitle for " cite$ * " to crossref " *
          crossref * warning$
          ""
        }
        { "En {\em " booktitle * "\/}" * }
      if$
    }
    { "En " key * }
      if$
    }
    { "En " format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {article}
{ output.bibitem
  format.authors "autor" output.check
  new.block
  format.year.label "a\~no" output.check
  new.block
  format.title "t\'itulo" output.check
  new.block
  crossref missing$
    { journal emphasize "revista" output.check
      format.vol.num.pages output
      format.date output
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "autor y editor" output.check }
    { format.authors output.nonnull
      crossref missing$
    { "autor y editor" editor either.or.check }
    'skip$
      if$
    }
  if$
  new.block
  format.year.label "a\~no" output.check
  new.block
  format.btitle "t\'itulo" output.check
  crossref missing$
    { format.bvolume output
      new.block
      format.number.series output
      new.sentence
      publisher "editorial" output.check
      address output
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  new.block
  format.year.label "a\~no" output.check
  new.block
  format.title "t\'itulo" output.check
  howpublished address new.block.checkb
  howpublished output
  address output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "autor y editor" output.check }
    { format.authors output.nonnull
      crossref missing$
    { "autor y editor" editor either.or.check }
    'skip$
      if$
    }
  if$
  format.year.label "a\~no" output.check
  new.block
  format.btitle "t\'itulo" output.check
  crossref missing$
    { format.bvolume output
      format.chapter.pages "cap\'ítulo y p\'aginas" output.check
      new.block
      format.number.series output
      new.sentence
      publisher "editorial" output.check
      address output
    }
    { format.chapter.pages "cap\'itulo y p\'aginas" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "autor" output.check
  new.block
  format.year.label "a\~no" output.check
  new.block
  format.title "t\'itulo" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      new.sentence
      publisher "editorial" output.check
      address output
      format.edition output
      format.date output
      format.chapter.pages output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "autor" output.check
  new.block
  format.year.label "a\~no" output.check
  new.block
  format.title "t\'itulo" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.pages output
      address empty$
    { organization publisher new.sentence.checkb
      organization output
      publisher output
      format.date output
    }
    { address output.nonnull
      format.date output
      new.sentence
      organization output
      publisher output
    }
      if$
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {conference} { inproceedings }

%%% SMS  Thu Aug  4 14:45:06 1994   
%%% Moved address to end of entry, rather than between organization
%%% and date, by deleting lines marked %**

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
    'skip$
    { organization output.nonnull
%**   address output
    }
      if$
    }
    { format.authors output.nonnull }
  if$
  format.year.label "a\~no" output.check
  new.block
  new.block
  format.btitle "t\'itulo" output.check
  author empty$
%**   { organization empty$
    { address new.block.checka
      address output
    }
%** 'skip$
%**     if$
%**   }
    { organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "autor" output.check
  new.block
  format.year.label "a\~no" output.check
  new.block
  format.title "t\'itulo" output.check
  new.block
  "Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output 
  new.block
  format.year.label output
  new.block
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  format.date output
  new.block
  note output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "autor" output.check
  new.block
  format.year.label "a\~no" output.check
  new.block
  format.btitle "t\'itulo" output.check
  new.block
  "{Ph.D.} tesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  new.block
  format.year.label "a\~no" output.check
  new.block
  format.btitle "t\'itulo" output.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
    { publisher new.sentence.checka }
    { organization publisher new.sentence.checkb
      organization output
    }
      if$
      publisher output
      format.date output
    }
    { address output.nonnull
      format.date output
      new.sentence
      editor empty$
    'skip$
    { organization output }
      if$
      publisher output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "autor" output.check
  new.block
  format.year.label "a\~no" output.check
  new.block
  format.title "t\'itulo" output.check
  new.block
  format.tr.number output.nonnull
  institution "instituci\'on" output.check
  address output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "autor" output.check
  new.block
  format.year.label "a\~no" output.check
  new.block
  format.title "t\'itulo" output.check
  new.block
  note "nota" output.check
  format.date output
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"Enero"}

MACRO {feb} {"Febrero"}

MACRO {mar} {"Marzo"}

MACRO {apr} {"Abril"}

MACRO {may} {"Mayo"}

MACRO {jun} {"Junio"}

MACRO {jul} {"Julio"}

MACRO {aug} {"Agosto"}

MACRO {sep} {"Septiembre"}

MACRO {oct} {"Octubre"}

MACRO {nov} {"Noviembre"}

MACRO {dec} {"Diciembre"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

INTEGERS { et.al.char.used }

FUNCTION {initialize.et.al.char.used}
{ #0 'et.al.char.used :=
}

EXECUTE {initialize.et.al.char.used}

FUNCTION {format.lab.names}
{ 's :=
  s num.names$ 'numnames :=

  numnames #1 =
    { s #1 "{vv }{ll}" format.name$ }
    { numnames #2 =
        { s #1 "{vv }{ll }y " format.name$ s #2 "{vv }{ll}" format.name$ *
        }
        { numnames #3 = 
             { s #1 "{vv }{ll}, " format.name$ s #2 "{vv }{ll}, y "
        format.name$ * s #3 "{vv }{ll}" format.name$ * }
             { s #1 "{vv }{ll }\bgroup et al.\egroup " format.name$ }
          if$
        }
      if$
    }
  if$

}

%%% SMS   Thu Aug  4 14:39:01 1994  
%%% Modified the label functions below so that they do not limit key
%%% and organization labels to three characters. Original lines left
%%% in as comments, preceded by %**

FUNCTION {author.key.label}
{ author empty$
    { key empty$
    { cite$ #1 #3 substring$ }
%** { key #3 text.prefix$ }
    { key }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
    { key empty$
        { cite$ #1 #3 substring$ }
%**     { key #3 text.prefix$ }
        { key }
      if$
    }
    { editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.key.organization.label}
{ author empty$
    { key empty$
    { organization empty$
        { cite$ #1 #3 substring$ }
%**     { "The " #4 organization chop.word #3 text.prefix$ }
        { "The " #4 organization chop.word }
      if$
    }
%** { key #3 text.prefix$ }
    { key }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.organization.label}
{ editor empty$
    { key empty$
    { organization empty$
        { cite$ #1 #3 substring$ }
%**     { "The " #4 organization chop.word #3 text.prefix$ }
        { "The " #4 organization chop.word }
      if$
    }
%** { key #3 text.prefix$ }
    { key }
      if$
    }
    { editor format.lab.names }
  if$
}

FUNCTION {calc.label}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
    'editor.key.organization.label
    { type$ "manual" =
        'author.key.organization.label
        'author.key.label
      if$
    }
      if$
    }
  if$
  duplicate$

  "\protect\citename{" swap$ * "}" *
%  year field.or.null purify$ *
  year field.or.null *
  'label :=
  year field.or.null purify$ *

  sortify 'sort.label :=
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
    { "   " * }
    'skip$
      if$

      s nameptr "{vv{ } }{ll{ }}{  ff{ }}{  jj{ }}" format.name$ 't :=

%%% To alphabetize using the convention of ignoring particles in
%%% names, use the following line instead of the preceding one.  But
%%% you may first want to check:
%%%
%%%     Mary-Claire van Leunen.  A Handbook for Scholars.  Alfred
%%%     A. Knopf, 1978, page 243ff.
%%%
%%%     The Chicago Manual of Style, 13th edition, University of
%%% Chicago Press, 1982, section 18.102 on "Names with particles".
%%%
%%% for pertinent caveats.

%%%   s nameptr "{ll{ }}{  ff{ }}{vv{ } }{  jj{ }}" format.name$ 't :=

      nameptr numnames = t "otros" = y
    { "et al" * }
    { t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
    { "to sort, need author or key in " cite$ * warning$
      ""
    }
    { key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
    { key empty$
        { "to sort, need author, editor, or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
    { key empty$
        { "to sort, need author, organization, or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
    { key empty$
        { "to sort, need editor, organization, or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {presort}

{ " "
  calc.label
  sort.label
  pop$
  type$ "book" =

  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
    'editor.organization.sort
    { type$ "manual" =
        'author.organization.sort
        'author.sort
      if$
    }
      if$
    }
  if$

  *

  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { longest.label last.sort.label next.extra }

INTEGERS { longest.label.width last.extra.num }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #0 int.to.chr$ 'last.sort.label :=
  "" 'next.extra :=
  #0 'longest.label.width :=
  #0 'last.extra.num :=
}

FUNCTION {forward.pass}
{ last.sort.label sort.label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      sort.label 'last.sort.label :=
    }
  if$
}

FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'extra.label := }
    'skip$
  if$
  label extra.label * 'label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
  extra.label 'next.extra :=
}

EXECUTE {initialize.longest.label}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION {begin.bib}

{ et.al.char.used
    { "\newcommand{\etalchar}[1]{$^{#1}$}" write$ newline$ }
    'skip$
  if$
  preamble$ empty$

    'skip$
    { preamble$ write$ newline$ }
  if$

  "\begin{thebibliography}{" "}" * write$ newline$

}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
