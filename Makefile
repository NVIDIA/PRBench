# Copyright (c) 2016, NVIDIA CORPORATION. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

#CUDA_HOME=MY_CUDA_PATH
#MPI_HOME=MY_MPI_PATH
CUB_HOME=cub-1.5.1

CC=$(MPI_HOME)/bin/mpicc
CPP=$(MPI_HOME)/bin/mpic++
LD=$(MPI_HOME)/bin/mpic++

CUDACC=$(CUDA_HOME)/bin/nvcc
CUDA_ARCH=-arch=sm_35
CUDACFLAGS=-m64 -c -O3 --ptxas-options=-v -I$(CUB_HOME) -I$(MPI_HOME)/include

CFLAGS=-W -Wall -Wno-unused-function -Wno-unused-parameter -c -O3 -I$(CUDA_HOME)/include -I$(MPI_HOME)/include
LDFLAGS = -lmpi -L$(CUDA_HOME)/lib64 -lcudart #-lnvToolsExt

OBJ=main.o phsort.o cuda_kernels.o adtp.o utils.o tmp_pool.o

prbench: ${OBJ} global.h Makefile
	${LD} -o prbench ${OBJ} ${LDFLAGS}

%.o: %.c global.h Makefile
	$(CC) $(CFLAGS) $< -o $@

%.o: %.cpp global.h Makefile
	$(CPP) $(CFLAGS) $< -o $@

%.o: %.cu global.h Makefile
	$(CUDACC) $(CUDACFLAGS) $(CUDA_ARCH) $<

clean:
	rm -rf *.o prbench
