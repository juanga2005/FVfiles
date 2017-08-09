#
#               Makefile for main AdvDiff3 code:
#

FFLAGS = -O -fno-align-commons
LFLAGS = $(FFLAGS)
F77    = gfortran -c
LINK   = gfortran
HDFLIBS = -L/usr/local/hdf/lib -lmfhdf -ldf -ljpeg -lz

.f.o: ; $(F77) $(FFLAGS) $*.f -o $*.o

OBJECTS = \
  openMPdriver.o\
  driver.o \
  qinit.o \
  rpn3adv.o \
  rpt3adv.o \
  rptt3adv.o\
  setprob.o\
  setaux.o\
  b4step3.o\
  src3.o\
  out3.o
  
LINPACKOBJECTS = \
  $(ADVDIFF)/LINPACK_lib/dgbco.o\
  $(ADVDIFF)/LINPACK_lib/dgbfa.o\
  $(ADVDIFF)/LINPACK_lib/dgbsl.o\
  $(ADVDIFF)/LINPACK_lib/dasum.o\
  $(ADVDIFF)/LINPACK_lib/daxpy.o\
  $(ADVDIFF)/LINPACK_lib/ddot.o\
  $(ADVDIFF)/LINPACK_lib/dscal.o\
  $(ADVDIFF)/LINPACK_lib/idamax.o\
  $(ADVDIFF)/LINPACK_lib/dgefa.o\
  $(ADVDIFF)/LINPACK_lib/dgesl.o

CLAW3LIBOBJECTS = \
  $(ADVDIFF)/claw3_lib/claw3ez.o \
  $(ADVDIFF)/claw3_lib/bc3.o \
  $(ADVDIFF)/claw3_lib/chkmth.o \
  $(ADVDIFF)/claw3_lib/claw3.o \
  $(ADVDIFF)/claw3_lib/step3.o \
  $(ADVDIFF)/claw3_lib/step3ds.o \
  $(ADVDIFF)/claw3_lib/dimsp3.o \
  $(ADVDIFF)/claw3_lib/flux3.o \
  $(ADVDIFF)/claw3_lib/copyq3.o \
  $(ADVDIFF)/claw3_lib/limiter.o \
  $(ADVDIFF)/claw3_lib/philim.o \
  $(ADVDIFF)/claw3_lib/restart3.o \
  
ADIDIFF3LIBOBJECTS = \
  $(ADVDIFF)/ADIdiff3_lib/ADIdiffsetmat3.o\
  $(ADVDIFF)/ADIdiff3_lib/diff3step.o\
  $(ADVDIFF)/ADIdiff3_lib/asmblmat1.o\
  $(ADVDIFF)/ADIdiff3_lib/factormat1.o\
  $(ADVDIFF)/ADIdiff3_lib/asmblmat3.o\
  $(ADVDIFF)/ADIdiff3_lib/updatewind3.o\
  $(ADVDIFF)/ADIdiff3_lib/asmblmat1_corrected_diff.o

SOURCES = \
  openMPdriver.f\
  driver.f \
  qinit.f \
  rpn3adv.f \
  rpt3adv.f \
  rptt3adv.f\
  setprob.f\
  setaux.f\
  b4step3.f\
  src3.f\
  out3.f

main: $(OBJECTS) 
	$(LINK) $(LFLAGS) $(LINPACKOBJECTS) $(CLAW3LIBOBJECTS) \
	$(ADIDIFF3LIBOBJECTS) $(OBJECTS) -o main

clean:
	-rm -f $(OBJECTS) main
	-rm -f $(OBJECTS)

### DO NOT remove this line - make depends on it ###
