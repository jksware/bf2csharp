Brainfuck to C# compiler
========================

The program resulting from this project parses [Brainfuck](https://en.wikipedia.org/wiki/Brainfuck), compiling to C#.

Much of the code is what's left from an assignment at the Compiler's course I received at college, circa 2013. At the time what everyone in my class used was Antlr-3.4, but since [Antlr-4](https://github.com/antlr/antlr4) is available as a Nuget package, it is much easier to run, so I converted it to the latter.

Installation
------------

1. Clone the repository or download the github-generated zip to a directory, uncompress it, and open the solution file with Visual Studio.

2. In Visual Studio, to be able to resolve headers and dependencies, go to View > Other Windows > Package Manager Console. Once the Package Manager opens, clic the Restore button. If that doesn't work, enter the following:

```PowerShell
    Update-Package Antlr4.Runtime.Standard -reinstall
```

3. If that doesn't work, then try:
```PowerShell
    Uninstall-Package Antlr4.Runtime.Standard; Install-Package Antlr4.Runtime.Standard
```

Is there anything cool with this project?
-----------------------------------------
I think so. All of the code C# generation is written in form of actions on the grammar file (bf.g4).

### How's that? 
The following code shows the rule `listOfPlus` of the grammar (which contains some `action`):

```antlr-csharp
listOfPlus
    @init {
        int n = 0;
    }
    @after {
        push_back($"data[cursor] += (char){n};");
    }
    :   PLUS {n++;} (PLUS {n++;})*
    ;

```
This rule is in almost every way equivalent to the Extended Backus Naur Form (EBNF) rule with Antlr actions:

```antlr-csharp
listOfPlus
    :   PLUS * { push_back("data[cursor]++;"); }
    ;
```
But you don't *need* a rule for that!

Yeap, but then you don't produce C#-pseudo-optimized code.

Why is this somehow useful?
---------------------------
If you are asking, probably it is not, at least not for you.

Why it may be useful to others (but not to me)?
-----------------------------------------------
[ANTLR](http://www.antlr.org/) is a powerful tool to try compilers' course various concepts, make domain-specific languages ([DSLs](https://en.wikipedia.org/wiki/Domain-specific_language)) or for some cool project you might be doing, and this grammar can serve as an intro to this amazing lexer and parser generator.

If you are looking for an example in Antlr 3.x, or just a more complete example, look no further than [Yet Another Tiger Compiler](https://github.com/jksware/yatc), this one a semester-long assignment and final project, circa 2014.

Is there any code optimization being applied?
---------------------------------------------
Yes, all commands adjacent, repeated in source that share the same token from {`+`, `-`, `>`, `<`} are "merged" together.

Where do I get Brainfuck sources?
---------------------------------
[Esolang](https://esolangs.org/wiki/Brainfuck) is a good starting point.

Where do I send all those comments and suggestions?
---------------------------------------------------
Nice of you to ask. All complaints should go to `/dev/null`.

Just kidding, just send those comments to [me](mailto:jksware@gmail.com).