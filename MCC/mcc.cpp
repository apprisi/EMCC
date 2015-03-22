#include "mcc.h"

void MCC::CreateMCC(float* realmcc, char* binmcc)
{
	if (ML.size()==0) return;

	get_all_neighbor_minutiae();

	//compute vlaue for each
	int count = 0;
	for(int k=1;k<=N_D;k++)
	{
		for(int j=1;j<=N_S;j++)
		{
			for(int i=1;i<=N_S;i++)
			{
				if (!msk_cell[(j-1)*N_S+(i-1)])
				{
					F[(k-1)*N_S*N_S + (j-1)*N_S + (i-1)] = 0.2;
					B[(k-1)*N_S*N_S + (j-1)*N_S + (i-1)] = -1;
					continue;
				}

				//printf("%d %d %d\r\n", i, j, k);

				float s = 0.;
				for(int m=0;m<nei_minu_index[(j-1)*N_S+(i-1)].size();m++)
				{
					float cms = compute_C_m_S(m, i, j);
					float cmd = compute_C_m_D(m, i, j, k);
					s += (cms * cmd);
				}

				float f = sigmf(s);
				F[(k-1)*N_S*N_S + (j-1)*N_S + (i-1)] = f;
				B[(k-1)*N_S*N_S + (j-1)*N_S + (i-1)] = (s>mu_Phi*0.7?1:0);

				// output
				if(realmcc!=NULL)
				{
					realmcc[count] = f;
				}
				if(binmcc!=NULL)
				{
					binmcc[count] = (s>mu_Phi?1:0);
				}
				count++;
			}
		}
	}

	
}

float MCC::compute_C_m_S(int m, int i, int j)
{
	// cell coordinates w.r.t. central minutiae
	//float x = (i-0.5) * Delta_S - R;
	//float y = (j-0.5) * Delta_S - R;

	//
	//float t = nei_minu_dis_2[(j-1)*N_S+(i-1)][m];
	//float val = exp(-nei_minu_dis_2[(j-1)*N_S+(i-1)][m] / (2.*delta_S*delta_S))
	//	/(delta_S*sqrt(2*PI));
	int h = nei_minu_dis_2[(j-1)*N_S+(i-1)][m] / 3;
	
	return G_S[h];
}

float MCC::compute_C_m_D(int m, int i, int j, int k)
{
	float dtheta = diffangle(ML.at(nei_minu_index[(j-1)*N_S+(i-1)][m]).theta,
		ML.at(0).theta);
	
	float alpha_k = diffangle(dphi[k-1], dtheta);

	// do the integral by lookup table
	int h = (alpha_k+PI) * 256 / (2 * PI);
	h = (h==256)?0:h;

	//if (h<0 || h>255)
	//	printf("Bad h = %d in compute_C_m_D() !\r\n", h);
	return (N_D==5)?G_D5[h]:G_D[h];
}

void MCC::get_all_neighbor_minutiae()
{
	//compute vlaue for each cell in the base
	for(int j=1;j<=N_S;j++)
	{
		for(int i=1;i<=N_S;i++)
		{
			if (!msk_cell[(j-1)*N_S+(i-1)]) continue;

			// the local coordinate w.r.t central minutiae
			float x = (i-0.5) * Delta_S - R;
			float y = (j-0.5) * Delta_S - R;

			nei_minu_index[(j-1)*N_S+(i-1)].clear();
			nei_minu_dis_2[(j-1)*N_S+(i-1)].clear();

			// search all minutiae for this cell
			for(int m=1;m<ML.size();m++)
			{
				float d = ((x-ML.at(m).x) * (x-ML.at(m).x) + (y-ML.at(m).y) * (y-ML.at(m).y));
				if (d<9*delta_S*delta_S)
				{
					nei_minu_index[(j-1)*N_S+(i-1)].push_back(m);
					nei_minu_dis_2[(j-1)*N_S+(i-1)].push_back(d); // store the square distance
				}
			}
			//printf("%d ", nei_minu_index[(j-1)*N_S+(i-1)].size());
		}
		//printf("\r\n");
	}
}

void MCC::get_msk_cell()
{
	//compute vlaue for each cell in the base
	for(int j=1;j<=N_S;j++)
	{
		for(int i=1;i<=N_S;i++)
		{
			float x = (i-0.5) * Delta_S;
			float y = (j-0.5) * Delta_S;
			float d = (x-R) * (x-R) + (y-R) * (y-R);
			if (d<R*R)
			{
				msk_cell[(j-1)*N_S+(i-1)] = 1;
				MCC_Len++;
				//printf("1 ");
			}//else{
				//printf("0 ");
			//}
		}
		//printf("\r\n");
	}

	MCC_Len *= N_D;
}

bool MCC::SaveMCC(const char* filename, char BF)
{
	FILE* f = fopen(filename, "w");
	if(!f)
	{
		printf("Fail to open %s\r\n", filename);
		return false;
	}

	for(int k=N_D;k>=1;k--)
	{
		for(int j=1;j<=N_S;j++)
		{
			for(int i=1;i<=N_S;i++)
			{
				switch(BF)
				{
				case 'F':
					fprintf(f, "%f ", F[(k-1)*N_S*N_S + (j-1)*N_S + (i-1)]);
					break;
				case 'B':
					fprintf(f, "%d ", (int)B[(k-1)*N_S*N_S + (j-1)*N_S + (i-1)]);
					break;
				case 'O':
					if(msk_cell[(j-1)*N_S+(i-1)])
					{
						fprintf(f, "%f ", F[(k-1)*N_S*N_S + (j-1)*N_S + (i-1)]);
					}
					break;
				}
			}
			if(BF!='O')	fprintf(f, "\n");
		}
	}

	fclose(f);
	return true;
}

// Extract MCC for one template
void ExtractMCC(MinuList& ML, int ND, int NS, int R, 
	float *realmcc, char* binmcc, bool Rotation)
{

	// initialization 
	MCC mcc;
	mcc.initialization(R, NS, ND);

	// Get local structure
	vector<MinuList> LocalML;
	ConstructLocalStructure(ML, LocalML, R + mcc.delta_S*3,Rotation);

	//

	for(int k=0;k<ML.size();k++)
	{
		mcc.ML = LocalML[k];
		mcc.CreateMCC(realmcc+mcc.MCC_Len*k, binmcc+mcc.MCC_Len*k);
	}
}

// Batch extract MCC
bool BatchMCC(const char* filelist, const char* savedir_real, const char* savedir_bit,
	int R, int NS, int ND, bool Rotation)
{
	FILE* f = fopen(filelist, "r");
	if(!f)
	{
		printf("Fail to open %s\r\n", filelist);
		return false;
	}

	char strMinu[512];
	char strSave[512];

	MinuList ML;
	MCC mcc;
	mcc.N_D=ND;
    mcc.N_S=NS;
    mcc.R=R;
	mcc.initialization(R, NS, ND);
	int MCCLen = GetMCCLen(R, NS, ND);
    cout << "mcc.MCC_Len="<<mcc.MCC_Len<<endl;

	while(1)
	{
		if(fscanf(f, "%s", strMinu)==EOF)
		{
			break;
		}else{
            // load minutiae list
            int width;
            int height;
            int Res = 500;
			if(!LoadMCCMinutiaeList(strMinu, ML, width, height))
            {
                return false;
            }
            float	*realmcc = new float [MCCLen*ML.size()];
	        char	*binmcc = new char [MCCLen*ML.size()];
			
            // extract mcc
			printf("Extracing MCC for %s...", strMinu);
			ExtractMCC(ML, ND, NS, R, realmcc, binmcc, Rotation);
			printf("Done.\r\n");

            string str(strMinu);
            int k=str.find_last_of("/");
            int i=str.find_last_of(".");
            char title[64]={0};
            memcpy(title, strMinu+k+1, i-k-1);


			//save mcc
			sprintf(strSave, "%s/%s.txt", savedir_real, title);
			//SaveRealMatrix(strSave, realmcc, MCCLen, ML.size());
			SaveMcc(strSave, realmcc, MCCLen, ML.size(), mcc.msk_cell, NS, ND, ML, width, height, Res);
			printf("Real MCC saved to %s \r\n", strSave);

			sprintf(strSave, "%s/%s.txt", savedir_bit, title);
			//SaveBinMatrix(strSave, binmcc, MCCLen, ML.size());
			SaveMcc(strSave, binmcc, MCCLen, ML.size(), mcc.msk_cell, NS, ND, ML, width, height, Res);
			printf("Bit MCC saved to %s \r\n", strSave);
	        
            delete[] realmcc;
	        delete[] binmcc;
		}
	}

	fclose(f);

	return true;
}

int GetMCCLen(float R, int NS, int ND)
{
	float D = 2*R/NS;
	int RT = 0;
	for(int i=1;i<=NS/2;i++)
	{
		for(int j=1;j<=NS/2;j++)
		{
			int x = (i-0.5)*D;
			int y = (j-0.5)*D;
			float dis = (x-R)*(x-R) + (y-R)*(y-R);
			if(dis<=R*R)
			{
				RT++;
			}
		}
	}
	return RT*ND*4;
}
bool LoadMCCMinutiaeList(const char* filename, MinuList& ML, int& width, int& height)
{
	FILE* f = fopen(filename, "r");
	if (!f)
	{
		printf("Open %s fail!\r\n", filename);
		return false;
	}

	ML.clear();

    int res = 0;
    int num = 0;
    fscanf(f, "%d", &width);
    fscanf(f, "%d", &height);
    fscanf(f, "%d", &res);
    fscanf(f, "%d", &num);

	for(int k=0;k<num;k++)
	{
		Minu M;
		int q;
		float theta;
		int e = fscanf(f, "%d %d %f", &M.x, &M.y, &theta);
        if(e==EOF)
        {
            fclose(f);
            return false;
        }
        //theta = (theta==0)?0:(2*3.141593-theta);
		M.theta = theta;
		ML.push_back(M);
	}

	fclose(f);
	return true;
}
bool LoadMinutiaeList(const char* filename, MinuList& ML)
{
	FILE* f = fopen(filename, "r");
	if (!f)
	{
		printf("Open %s fail!\r\n", filename);
		return false;
	}

	ML.clear();

	while(1)
	{
		Minu M;
		int q;
		int t;
		int e = fscanf(f, "%d %d %d %d %d", &M.x, &M.y, &t, &q, &q);
		M.theta = t * PI / 180.;
		if(e==EOF)
		{
			break;
		}else{
			ML.push_back(M);
		}
	}

	fclose(f);
	return true;
}

// get the local minutia
void ConstructLocalStructure(MinuList &ML, vector<MinuList> &LocalML, float R,bool Rotation)
{
	LocalML.clear();
	LocalML.resize(ML.size());

	// find the local minutiae
	for(int i=0;i<ML.size();i++)
	{
		LocalML[i].push_back(ML[i]);

		for(int j=0;j<ML.size();j++)
		{
			if (i==j) continue;
			float d = (ML[i].x - ML[j].x)*(ML[i].x - ML[j].x) + (ML[i].y - ML[j].y)*(ML[i].y - ML[j].y);
			if (d<=R*R)
			{
				LocalML[i].push_back(ML[j]);
			}
		}
	}

	// change to local coordinate system
	for(int i=0;i<ML.size();i++)
	{
		for(int k=0;k<LocalML[i].size();k++)
		{
			float dx = LocalML[i][k].x - ML[i].x;
			float dy = LocalML[i][k].y - ML[i].y;
            if(Rotation) 
            {
                float x = dx * cos(ML[i].theta) - dy * sin(ML[i].theta);
                float y = -dx * sin(ML[i].theta) - dy * cos(ML[i].theta);
                LocalML[i][k].x = x+0.5;
                LocalML[i][k].y = y+0.5;
                LocalML[i][k].theta -= ML[i].theta;
		    }else{
                LocalML[i][k].x = dx;
                LocalML[i][k].y = dy;
            }
        }
	}
}

