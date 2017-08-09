c
c     This is one of the Main subroutines for setting up the matrices 
c     used by the diffusion solver. Here the input files are read and
c     appropriate functions for assembling Left Hand Side (LHS) matrices
c     are called. All matrices are then factored and stored.
c
c     Bamdad Hosseini, Jul 2012.
c
c
c     =================================================================
      subroutine ADIdiffsetmat3 (maxmx,maxmy,maxmz,
     &                          meqn,mwaves,mbc,maux,mwork,
     &                          mthlim,q,work,aux,
     &                          SLHSX,SLHSY,SLHSZ,ipvtx,ipvty,ipvtz,
     &                          ml, mu, lda, alphashearval, alphaXval, 
     &     alphaYval,
     &     alphaZval, diffLval, ucutoffval, z_0val)
c     =================================================================
c
c     subroutine for assembling matrices used by the diffusion solver
c     based on input data
c
      implicit double precision (a-h,o-z)

      integer ipvtx, ipvty, ipvtz, info, moptionx, moptiony, moptionz
      dimension SLHSX(lda,maxmx)
      dimension SLHSY(lda,maxmy)
      dimension SLHSZ(lda,maxmz)
      dimension ipvtx(maxmx)
      dimension ipvty(maxmy)
      dimension ipvtz(maxmz)
      dimension moptionx(2)
      dimension moptiony(2)
      dimension moptionz(2)
c     common block holding boundary data for diff slvr
      common /diffbound/ moptionx, moptiony, moptionz

c     common block holding diffusion coefficients (z_0, diffL,
c      k_zz_option are used for vertical eddy diffusivity corrections)
      common /diffslv3/ z_0, z_low, alphax, alphay, alphaz, 
     &                  diffL, k_zz_option
c     ################################################################
c     this entire block is copied from claw3ez.f in order to read input
c     data and set up problem properly
c     ################################################################


      external bc3,rpn3,rpt3,rptt3,src3,b4step3

      dimension    q(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &               1-mbc:maxmz+mbc, meqn)
      dimension  aux(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &               1-mbc:maxmz+mbc, maux)
      dimension work(mwork)
      dimension mthlim(mwaves)
c
      dimension method(7),dtv(5),cflv(4),nv(2),mthbc(6)
      dimension tout(100)
      logical rest
c
      common /restrt_block/ tinitial, iframe
c
      open(55,file='../../claw3ez.data',status='old',form='formatted')
      open(10,file='./fort.info',status='unknown',form='formatted')

      rewind 55
      rewind 10
c
c
c     # Read the input in standard form from claw2ez.data:

c     domain variables
      read(55,*) mx
      read(55,*) my
      read(55,*) mz

c     i/o variables
      read(55,*) nout
      read(55,*) outstyle
      if (outstyle.eq.1) then
          read(55,*) tfinal
          nstepout = 1
        elseif (outstyle.eq.2) then
          read(55,*) (tout(i), i=1,nout)
          nstepout = 1
        elseif (outstyle.eq.3) then
          read(55,*) nstepout, nstop
          nout = nstop
        endif


c     timestepping variables
      read(55,*) dtv(1)
      read(55,*) dtv(2)
      read(55,*) cflv(1)
      read(55,*) cflv(2)
      read(55,*) nv(1)
c


c     # input parameters for clawpack routines
      read(55,*) method(1)
      read(55,*) method(2)
      read(55,*) method(3)
      read(55,*) method(4)
      read(55,*) method(5)
      read(55,*) method(6)
      read(55,*) method(7)

      read(55,*) meqn1
      read(55,*) mwaves1
      read(55,*) (mthlim(mw), mw=1,mwaves1)

      read(55,*) t0
      read(55,*) xlower
      read(55,*) xupper
      read(55,*) ylower
      read(55,*) yupper
      read(55,*) zlower
      read(55,*) zupper
c
      read(55,*) mbc1
      read(55,*) mthbc(1)
      read(55,*) mthbc(2)
      read(55,*) mthbc(3)
      read(55,*) mthbc(4)
      read(55,*) mthbc(5)
      read(55,*) mthbc(6)

c     # check to see if we are restarting:
      rest = .false.
c     # The next two lines may not exist in old versions of claw3ez.data.
c     # Jump over the second read statement if the 1st finds an EOF:
      read(55,*,end=199,err=199) rest
      read(55,*) iframe   !# restart from data in fort.qN file, N=iframe
 199  continue


      if ((mthbc(1).eq.2 .and. mthbc(2).ne.2) .or.
     &    (mthbc(2).eq.2 .and. mthbc(1).ne.2)) then
         write(6,*) '*** ERROR ***  periodic boundary conditions'
         write(6,*) 'require mthbc(1) and mthbc(2) BOTH be set to 2'
         stop
         endif

      if ((mthbc(3).eq.2 .and. mthbc(4).ne.2) .or.
     &    (mthbc(4).eq.2 .and. mthbc(3).ne.2)) then
         write(6,*) '*** ERROR ***  periodic boundary conditions'
         write(6,*) 'require mthbc(3) and mthbc(4) BOTH be set to 2'
         stop
         endif

      if ((mthbc(5).eq.2 .and. mthbc(6).ne.2) .or.
     &    (mthbc(6).eq.2 .and. mthbc(5).ne.2)) then
         write(6,*) '*** ERROR ***  periodic boundary conditions'
         write(6,*) 'require mthbc(5) and mthbc(6) BOTH be set to 2'
         stop
         endif

c     # These values were passed in, but check for consistency:
c
      if (method(7) .ne. maux) then
         write(6,*) '*** ERROR ***  method(7) should equal maux'
         stop
         endif
      if (meqn1 .ne. meqn) then
         write(6,*) '*** ERROR ***  meqn set wrong in input or driver'
         stop
         endif
      if (mwaves1 .ne. mwaves) then
         write(6,*) '*** ERROR ***  mwaves set wrong in input or driver'
         stop
         endif
      if (mbc1 .ne. mbc) then
         write(6,*) '*** ERROR ***  mbc set wrong in input or driver'
         stop
         endif
c
c     # check that enough storage has been allocated:
c
      if (method(5).lt.2) then
          narray = 1   !# only need one qwork array
        else
          narray = 2   !# need two qwork arrays for Strang splitting
        endif

      maxm = max0(maxmx, maxmy, maxmz)
      mwork1 = (maxm+2*mbc)*(46*meqn + mwaves + meqn*mwaves
     &                      + 9*maux + 3)
     &          + narray * (maxmx + 2*mbc) * (maxmy + 2*mbc)
     &                   * (maxmz + 2*mbc) * meqn
c
c
      if (mx.gt.maxmx .or. my.gt.maxmy .or. mz.gt.maxmz .or.
     &    mwork.lt.mwork1) then
c        # insufficient storage
         maxmx1 = max0(mx,maxmx)
         maxmy1 = max0(my,maxmy)
         maxmz1 = max0(mz,maxmz)
         maxm1 = max0(maxmx1,maxmy1,maxmz1)

         mwork1 = (maxm1+2*mbc)*(46*meqn + mwaves + meqn*mwaves
     &                      + 9*maux + 3)
     &          + narray * (maxmx + 2*mbc) * (maxmy + 2*mbc)
     &                   * (maxmz + 2*mbc) * meqn

         write(6,*) ' '
         write(6,*) '*** ERROR *** Insufficient storage allocated'
         write(6,*) 'Recompile after increasing values in driver.f:'
         write(6,611) maxmx1
         write(6,612) maxmy1
         write(6,613) maxmz1
         write(6,614) mwork1
 611     format(/,'parameter (maxmx = ',i5,')')
 612     format('parameter (maxmy = ',i5,')')
 613     format('parameter (maxmz = ',i5,')')
 614     format('parameter (mwork = ',i9,')',/)
         stop
         endif

      call chkmth(method,info)
      if( info .eq. 6) stop
c
      close(unit=55)
      close(unit=10)

c
      write(6,*) 'Setting up matrices...'
      write(6,*) ' '
c
c     # grid spacing
      dx = (xupper - xlower) / float(mx)
      dy = (yupper - ylower) / float(my)
      dz = (zupper - zlower) / float(mz)
c
c     call user's routine to set up problem
c
      call setprob (alphashearval, alphaXval, alphaYval,
     & alphaZval, diffLval, ucutoffval, z_0val)
c     ################################################################
c      write(*,*) 'alphax= ', alphax
      coux = alphax*dtv(1)/(dx*dx)
      write(*,*) 'coux= ', coux !calculate initial alpha*dt/dx^2 in X

c      write(*,*) 'alphay= ', alphay
      couy = alphay*dtv(1)/(dy*dy)
      write(*,*) 'couy= ', couy !calculate initial alpha*dt/dy^2 in Y

c      write(*,*) 'alphaz= ', alphaz
      couz = alphaz*dtv(1)/(dz*dz)
      write(*,*) 'couz= ', couz !calculate initial alpha*dt/dz^2 in Z

c      read(*,*)
c     assemble all matrices and factorize
      call asmblmat3(maxmx, maxmy,maxmz, mbc, mx, my, mz
     &                     ,SLHSX, SLHSY, SLHSZ, lda, ml, mu
     &                     ,ipvtx,ipvty,ipvtz
     &                     ,info, coux, couy, couz
     &                     ,moptionx, moptiony, moptionz
     &                     ,dx, dy, dz)

      return
      end
