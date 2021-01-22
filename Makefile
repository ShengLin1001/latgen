.SUFFIXES : .o .cpp
# compiler and flags
#CC     = g++ #-Wno-unused-result
CC     = /opt/intel/bin/icc
LINK   = $(CC) #-static
CFLAGS = -O3 $(UFLAG) $(DEBUG)
#
OFLAGS = -O3 $(DEBUG)
INC    = $(FFTINC) $(LPKINC) $(USRINC) $(VoroINC)
LIB    = $(FFTLIB) $(LPKLIB) $(USRLIB) $(VoroLIB)
#
# fftw 3 library; not needed by this code
#FFTINC    = -I/opt/fftw/fftw3/include
#FFTLIB    = -L/opt/fftw/fftw3/lib -lfftw3

# Lapack library; not needed by this code
#LPKINC = -I/opt/clapack/3.2.1/include
#LPKLIB = -L/opt/clapack/3.2.1/lib -lclapack -lblas -lf2c -lm

# Voro++
VoroINC = -I/opt/voro/include/voro++
VoroLIB = -L/opt/voro/lib -lvoro++

# User flag
#UFLAG = -DPoly
# Debug flags
#DEBUG = -g
#====================================================================
# executable name
BASE   = latgen
EXE    = ${BASE}

#================= Do not modify the following ======================
# source and rules
SRC = $(wildcard *.cpp)
OBJ = $(SRC:.cpp=.o)
#====================================================================
all:  ${EXE}

${EXE}:  $(OBJ)
	$(LINK) $(OFLAGS) $(OBJ) $(LIB) -o $@

clean: 
	rm -f *.o *~ *.mod ${EXE}

tar:
	rm -f ${BASE}.tar; tar -czvf ${BASE}.tar.gz *.cpp  *.h Makefile README

ver:
	@echo "#define VERSION `git log|grep ^commit|wc -l`" > version.h; cat version.h

.f.o:
	$(FC) $(FFLAGS) $(FREE) $(MPI) ${INC} -c $<
.f90.o:
	$(FC) $(FFLAGS) $(FREE) $(MPI) ${INC} -c $<
.c.o:
	$(CC) $(CFLAGS) -c $<
.cpp.o:
	$(CC) $(CFLAGS) $(INC) -c $<
