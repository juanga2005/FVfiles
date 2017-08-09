#
#	Makefile for LINPACK banded matrix solver
#
#
#

FFLAGS = -O
LFLAGS = $(FFLAGS)
F77    = gfortran -c
LINK   = gfortran

.f.o: ; $(F77) $(FFLAGS) $*.f -o $*.o

LINPACKOBJECTS = \
  dgbco.o\
  dgbfa.o\
  dgbsl.o\
  dasum.o\
  daxpy.o\
  ddot.o\
  dscal.o\
  idamax.o\
  dgefa.o\
  dgesl.o\

SOURCES = \
  dgbco.f\
  dgbfa.f\
  dgbsl.f\
  dasum.f\
  daxpy.f\
  ddot.f\
  dscal.f\
  idamax.f\
  dgefa.f\
  dgesl.f\
  
all: $(LINPACKOBJECTS)
	
clean:
	-rm -f $(LINPACKOBJECTS)
	
### DO NOT remove this line - make depends on it ###