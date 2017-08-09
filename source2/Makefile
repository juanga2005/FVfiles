#
#	General Makefile for the 3D ADI Advec-diff problem
#
#
export PATHLINPACK= './LINPACK_lib'
export PATHCLAW3= './claw3_lib'
export PATHDIFF3= './ADIdiff3_lib'
export PATHMAIN= './main'

all:	
	
	$(MAKE) $(MFLAGS) -C ./thrd21 all
	$(MAKE) $(MFLAGS) -C ./thrd22 all
	$(MAKE) $(MFLAGS) -C ./thrd23 all
	$(MAKE) $(MFLAGS) -C ./thrd24 all
clean:

	$(MAKE) -C ./thrd21 clean
	$(MAKE) -C ./thrd22 clean
	$(MAKE) -C ./thrd23 clean
	$(MAKE) -C ./thrd24 clean

### DO NOT remove this line - make depends on it ### 