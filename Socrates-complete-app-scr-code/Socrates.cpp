// Socrates.cpp : Defines the entry point for the console application.
//
#include "clipscpp.h"
#include <stdio.h>
#include <process.h>
#include "resource.h" 
#include "windows.h" 
#include "CustomFileRouter.h" 

using namespace CLIPS;

void CreateTmpClpFileFromResource(char*);
void DisplayResults(CustomFileRouter*, CustomFileRouter*);


int main()
{
	CLIPSCPPEnv theEnv;  
	
	CustomFileRouter* results_fileRouter = new CustomFileRouter("results_file");
	theEnv.AddRouter("results_file",10,results_fileRouter);

	CustomFileRouter* questions_fileRouter = new CustomFileRouter("questions_file");
	theEnv.AddRouter("questions_file",10,questions_fileRouter);

	CreateTmpClpFileFromResource("rule_file");
	theEnv.Load("rule_file");
	DeleteFile("rule_file");	

	do
	{
		system("cls");
		system("color B0");

		//run the expert system
		theEnv.Reset();
		theEnv.Run(-1);

		system("color 47");
		system("cls");


		//display results
		DisplayResults(results_fileRouter,questions_fileRouter);


		printf("\n\n\n\n\n Press any key to run the advisor again. Press 'e' to exit.\n\n");

	}while( 101 != getchar());	

}
 
void DisplayResults(CustomFileRouter* results_fileRouter, CustomFileRouter* questions_fileRouter)
{
	char curDir[500] = "";
	char resultsFinalFilePath[500] = "";
	GetCurrentDirectory(sizeof(curDir),curDir);
	sprintf(resultsFinalFilePath,"start notepad %s\\final_results_file",curDir);


	char* questions = questions_fileRouter->GetContents();
	char* results = results_fileRouter->GetContents();
	printf("\n\n%s",results);

	FILE* fp = fopen("final_results_file","w");
	
	fputs(results,fp);	
	fputs("\n\n\n",fp);
	
	char line[120] = "";
	memset(&line,'\0',sizeof(line));
	memset(&line,'-',sizeof(line)-1);
	fputs(line,fp);
	fputs("\n",fp);

	fputs("These were your responses\n\n",fp);
	fputs(questions,fp);
	fflush(fp);
	fclose(fp);
	system(resultsFinalFilePath);

	free (questions);
	free (results);
}

void CreateTmpClpFileFromResource(char* fileName) 
{     
	DWORD size = 0;     
	const char* data = NULL; 

	HMODULE handle = ::GetModuleHandle(NULL);     
	HRSRC rc = ::FindResource(handle, MAKEINTRESOURCE(IDR_CLP_FILE), MAKEINTRESOURCE(CLIPS_RULE_FILE));     
	HGLOBAL rcData = ::LoadResource(handle, rc);     
	size = ::SizeofResource(handle, rc);     
	data = static_cast<const char*>(::LockResource(rcData)); 

	char* buffer = new char[size+1];     
	::memcpy(buffer, data, size);     
	buffer[size] = 0; 

	FILE* fp;
	fp = fopen(fileName, "w");	
	if (fp!=NULL)
	{
		fputs(buffer, fp);
		fflush(fp);
		fclose(fp);
	}

	delete[] buffer;
} 