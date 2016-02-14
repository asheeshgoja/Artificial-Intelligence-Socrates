#include "C:\Program Files\CLIPS\Projects\Source\Integration\clipscpp.h"
#pragma comment(lib, "C:\\Program Files\\CLIPS\\Projects\\Libraries\\Microsoft\\CLIPSCPP.lib")

int main()
{	
	CLIPS::CLIPSCPPEnv theEnv;  
	theEnv.Load("..//SocratesKnowledgeBase.clp");
	theEnv.Reset();
	theEnv.Run(-1);
	return 0;
}