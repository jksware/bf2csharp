grammar bf;

options
{
    language = CSharp;
}

@lexer::header {}
@lexer::modifier { public }
@lexer::ctorModifier { public }
@lexer::members
{
}


@parser::modifier { public }
@parser::header
{
    using System;
    using System.Text;
}

@parser::members
{
    #region { @parser::members }
    private const string BeginPart = 
@"
using System;
namespace Brainfuck.UserGenerated
{
    class Program
    {
        static void Main(string[] args)
        {
            char[] data = new char[30000];
            int cursor = 0;
";
    
    private const string EndPart = 
@"
        }
    }
}";
            
    private StringBuilder sb = new StringBuilder();
    private string _program;
    public string FinalProgram { get { return _program; } }
    
    private byte _indent = 3;
    private void push_back(string code)
    {
        sb.Append(' ', _indent * 4);
        sb.AppendLine(code);
    }
    #endregion
}


LBRACKET    : '[';
RBRACKET    : ']';
PLUS        : '+';
MINUS       : '-';
LT          : '<';
GT          : '>';
OUT         : '.';
IN          : ',';
WS          : (~('[' | ']' | '+' | '-' | '<' | '>' | '.' | ','))+ -> skip;

program 
    @after {
        var temp = sb.ToString();
        _program = BeginPart + temp + EndPart;
    }
    :   block* EOF
    ;

block
    :   LBRACKET { push_back("while(data[cursor] != 0) {"); _indent++; } block* RBRACKET { _indent--; push_back("}"); }
    |   listOfPlus
    |   listOfMinus
    |   listOfLt
    |   GT { push_back("cursor = (cursor + 1) % data.Length;"); }
    |   IN { push_back("data[cursor] = (char)Console.Read();"); }
    |   OUT { push_back("Console.Write(data[cursor]);"); }
    ;

listOfPlus
    @init {
        int n = 0;
    }
    @after {
        push_back($"data[cursor] += (char){n};");
    }
    :   PLUS {n++;} (PLUS {n++;})*
    ;

listOfMinus
    @init {
        int n = 0;
    }
    @after {
        push_back($"data[cursor] -= (char){n};");
    }
    :   MINUS {n++;} (MINUS {n++;})*
    ;

listOfLt
    @init {
        int n = 0;
    }
    @after {
        push_back($"cursor = (cursor + data.Length - {n}) % data.Length;");
    }
    :   LT {n++;} (LT {n++;})*
    ;

listOfGt
    @init {
        int n = 0;
    }
    @after {
        push_back($"cursor = (cursor + {n}) % data.Length;");    
    }
    :   GT {n++;} (GT {n++;})*
    ;
