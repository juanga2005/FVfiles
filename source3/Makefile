#
#	General Makefile for the 3D ADI Advec-diff problem
#
#
export PATHLINPACK= './LINPACK_lib'
export PATHCLAW3= './claw3_lib'
export PATHDIFF3= './ADIdiff3_lib'
export PATHMAIN= './main'

all:	

	$(MAKE) $(MFLAGS) -C ./thrd31 all
	$(MAKE) $(MFLAGS) -C ./thrd32 all
	$(MAKE) $(MFLAGS) -C ./thrd33 all
	$(MAKE) $(MFLAGS) -C ./thrd34 all
clean:

	$(MAKE) -C ./thrd31 clean
	$(MAKE) -C ./thrd32 clean
	$(MAKE) -C ./thrd33 clean
	$(MAKE) -C ./thrd34 clean

### DO NOT remove this line - make depends on it ### 