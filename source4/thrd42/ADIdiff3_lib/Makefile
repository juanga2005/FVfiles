#
#	Makefile for ADI diffusion solver lib files
#
#
#

FFLAGS = -O -fno-align-commons
LFLAGS = $(FFLAGS)
F77    = gfortran -c
LINK   = gfortran

.f.o: ; $(F77) $(FFLAGS) $*.f -o $*.o
  
ADIDIFF3LIBOBJECTS = \
  ADIdiffsetmat3.o\
  diff3step.o\
  asmblmat1.o\
  asmblmat1_corrected_diff.o\
  factormat1.o\
  asmblmat3.o\
  updatewind3.o

SOURCES = \
  ADIdiffsetmat3.f\
  diff3step.f\
  asmblmat1.f\
  asmblmat1_corrected_diff.f\
  factormat1.f\
  asmblmat3.f\
  updatewind3.f
  
lib: $(ADIDIFF3LIBOBJECTS) 
	
clean:
	-rm -f $(ADIDIFF3LIBOBJECTS)
	
### DO NOT remove this line - make depends on it ###