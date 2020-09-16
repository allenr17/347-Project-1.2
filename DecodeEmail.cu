#include <stdio.h>
#include <iostream>
#include <fstream>
using namespace std;


__global__ void decode(char *msg);

int main(int argc, char *argv[]){

    if (argc > 2){
        cout << "You have entered too many arguments, the program will now exit.\n";
        exit(0);
    }else if(argc == 1){
        cout << "You have entered too few arguments, the program will now exit.\n";
        exit(0);
    }

    char* filename = argv[1];

    cout << "File name: " << filename << '\n';

    char *r;
    char *dev_r;
    r = (char*)malloc(sizeof(char) * (256));
    cudaMalloc((void**)&dev_r, sizeof(char) * (256));

    cout << r << '\n';

    FILE *file;
    file = fopen(filename, "r");

    if (file){

        cout << "File opened" << '\n';

        fscanf(file, "%s,", r);

        cout << "File scanned\n";
        
    }else{
        cout << "That file does not exist, the program will now exit.\n";
        exit(0);
    }
    
    cout << "Original Text:\n" << r << "\n\n";

    cudaMemcpy(dev_r, r, sizeof(char) * (256), cudaMemcpyHostToDevice);

    decode<<<1, (sizeof(char) * (256))>>>(dev_r);

    cudaDeviceSynchronize();

    cudaMemcpy(r, dev_r, sizeof(char) * (256), cudaMemcpyDeviceToHost);

    cout << "Decoded Text:\n" << r << '\n';

    cudaFree(dev_r);
    free(r);

    exit(0);

}

__global__ void decode(char *m){
    int i = threadIdx.x;
    int temp = -1;
    if (int(m[i]) != 0){
        temp = int(m[i]);
        temp -= 1;
        m[i] = char(temp);
    }

}


