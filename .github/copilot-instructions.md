Remotely executed code need type declaration (casting) in the form of ({type})
Some macros have type hints in their names: _I_ = integer _S_ = string _AS_ = Array of strings etc
I prefer to have function declaration on one line, unless there are a lot of parameters, then linebreaks can be done there. Not having type and function name on different lines.
Variable and function names should be descriptive and not repurposed in the same scope (tmp = 5; a = 5 + tmp; tmp = "apa" ....)

I prefer curly braces for if statements and such, even if it's just a one line statement. The project has lousy indentation, so it can be difficult to process the structure.
