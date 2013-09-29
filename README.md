vim-latex-objects
=================

Text objects and motions for Latex editing in Vim.

The following text objects are provided:
- `im`: inside math environment. Recognizes `$`, `\[ ... \]`, `\( ... \)`. Usable as `vim`, `cim`, etc.
- `am`: around math environment. Like `im`, but also selects the math delimiters.
- `ie`: inside environment. Recognizes matching \begin and \end tags.
- `ae`: around environment. Like `ie`, but also selects the lines with \begin and \end on them.
- `%`: jump around between matched begin/end blocks. If the current line does not have one, use default % motion. Works in visual mode.
