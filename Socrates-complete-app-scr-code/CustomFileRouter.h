#pragma once
using namespace CLIPS;

class CustomFileRouter : public CLIPSCPPRouter
{
	FILE* _resultsFile;
	char* fName;
public:
	CustomFileRouter(char* fileName)
	{
		_resultsFile = NULL;
		fName = fileName;
	}

	int Query(CLIPSCPPEnv *e,char * name)
	{
		if (strcmp(name,fName) == 0) 
		{
			if(_resultsFile == NULL)
				_resultsFile = fopen(fName , "w+");

			return(TRUE);
		}
		return(FALSE); 
	}

	int Print(CLIPSCPPEnv *e,char * name,char *p)
	{
		fputs(p ,_resultsFile);
		return(TRUE);
	}
	
	int Exit(CLIPSCPPEnv *e,int)
	{
		return(TRUE);
	}

	char* GetContents()
	{
		fseek (_resultsFile , 0 , SEEK_END);
		long  lSize = ftell (_resultsFile);
		rewind (_resultsFile);
		char *buffer = (char*) malloc (sizeof(char)*lSize);
		ZeroMemory(buffer,lSize);
		fread (buffer,1,lSize,_resultsFile);
		fclose(_resultsFile);
		_resultsFile = NULL;
		return buffer;
	}
  
};
