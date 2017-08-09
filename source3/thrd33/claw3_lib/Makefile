#
#		Makefile for the clawpack code:
#
#	To compile the claw3 library files type:       make lib
#       (from the lib sub-directory)
#
FFLAGS = -O
LFLAGS =
F77 = gfortran -c
F90 = gfortran

.f.o: ; $(F77) $(FFLAGS) $*.f -o $*.o

CLAW3LIBOBJECTS = \
  claw3ez.o \
  bc3.o \
  claw3.o \
  step3.o \
  step3ds.o \
  dimsp3.o \
  flux3.o \
  copyq3.o \
  chkmth.o \
  inlinelimiter.o \
  limiter.o \
  philim.o \
  fdisc.o \
  restart3.o

SOURCES = \
  claw3ez.f \
  bc3.f \
  claw3.f \
  step3.f \
  step3ds.f \
  dimsp3.f \
  flux3.f \
  copyq3.f \
  chkmth.f \
  inlinelimiter.f \
  limiter.f \
  philim.f \
  fdisc.f \
  restart3.f

lib: $(CLAW3LIBOBJECTS)

clean:
	-rm -f $(CLAW3LIBOBJECTS)

### DO NOT remove this line - make depends on it ###
