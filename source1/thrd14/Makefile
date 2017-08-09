#
#	General Makefile for the 3D ADI Advec-diff problem
#
#
export ADVDIFF= /Users/bamdadhosseini/Work/Research/atmossourceinversion_multithread/source1/thrd14
export PATHLINPACK= './LINPACK_lib'
export PATHCLAW3= './claw3_lib'
export PATHDIFF3= './ADIdiff3_lib'
export PATHMAIN= './main'

all:	

	$(MAKE) $(MFLAGS) -C $(PATHLINPACK) all
	$(MAKE) $(MFLAGS) -C $(PATHCLAW3) lib
	$(MAKE) $(MFLAGS) -C $(PATHDIFF3) lib
	$(MAKE) $(MFLAGS) -C $(PATHMAIN) main	
clean:

	$(MAKE) -C $(PATHLINPACK) clean
	$(MAKE) -C $(PATHCLAW3) clean
	$(MAKE) -C $(PATHDIFF3) clean
	$(MAKE) -C $(PATHMAIN) clean

### DO NOT remove this line - make depends on it ### 
