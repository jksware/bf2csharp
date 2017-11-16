using System;
using Antlr4.Runtime;

namespace Brainfuck
{
    static class Program
    {
        static void Main(string[] args)
        {
            try
            {
                ICharStream charStream = CharStreams.fromPath(args[0]);
                var lexer = new bfLexer(charStream);
                var tokenStream = new CommonTokenStream(lexer);
                var parser = new bfParser(tokenStream);
                parser.program();
                Console.WriteLine(parser.FinalProgram);
            }
            catch (Exception e)
            {
                Console.WriteLine("Something happened.\nError: {0}.", e.Message);
            }
        }
    }
}
