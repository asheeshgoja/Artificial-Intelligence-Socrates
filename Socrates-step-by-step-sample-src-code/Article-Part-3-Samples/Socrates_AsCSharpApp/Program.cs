using System;

namespace GetMarriedOrStaySingle_AsCSharpApp
{
    class Program
    {
        static void Main(string[] args)
        {
            CLIPSNet.Environment theEnv = new CLIPSNet.Environment();
            theEnv.Load(@"..\..\..\SocratesKnowledgeBase.clp");
            theEnv.Reset();
            theEnv.Run(-1);
        }
    }
}
