      subroutine driver(alphashearval, alphaXval, alphaYval,
     & alphaZval, diffLval, ucutoffval, z_0val, nprocess) 
c
c  Generic driver routine for claw3
c
c  Author: Donna Calhoun
c  Date : 3/22/02
c  Version : To be used with Clawpack 4.0
c
      implicit double precision (a-h,o-z)

c     # set parameters for maximum array sizes used in declarations
c     # these must be increased for larger problems.
c
c
      parameter (maxmx =   300)
      parameter (maxmy =   300)
      parameter (maxmz =   300)
      parameter (mwork =  60000000)

      parameter (mbc = 2)
      parameter (meqn = 1)
      parameter (mwaves = 1)
      parameter (maux = 3)

      parameter (ml=1)
      parameter (mu=1)
      parameter (lda=4)

      dimension    q(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &               1-mbc:maxmz+mbc, meqn)

      dimension  aux(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &               1-mbc:maxmz+mbc, maux)

      dimension mthlim(mwaves)
      dimension work(mwork)

c     *************************************************
c     variables used by the diffusion solver
c     *************************************************
c
c     parameters used by the diff slvr
c
c     ipvtx, y, z: are pivoting arrays used by LINPACK
c     moptionx, y, z: are options for boundary conditions
c                     on diffusion solver
c     SLHSX, Y, Z: are factored Left Hand Side Matrices
c
      integer ipvtx, ipvty, ipvtz, info  
      integer moptionx, moptiony, moptionz
      dimension SLHSX(lda,maxmx)
      dimension SLHSY(lda,maxmy)
      dimension SLHSZ(lda,maxmz)
      dimension ipvtx(maxmx)
      dimension ipvty(maxmy)
      dimension ipvtz(maxmz)
      dimension moptionx(2)
      dimension moptiony(2)
      dimension moptionz(2)

c
c     *************************************************
c

c
c     #################################################
c     Ground deposition variables
c     #################################################
c

      dimension depo(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc)


      do 110 ii=1-mbc, maxmx+mbc
         do 111 jj=1-mbc, maxmy+mbc

            depo(ii,jj) = 0.0

 111     continue
 110  continue

      write(*,*) alphashearval, alphaXval, alphaYval,
     & alphaZval, diffLval, ucutoffval, z_0val, nprocess
c      read (*,*)

c
c     depo: is a two dimensional matrix holding value of 
c           ground deposition
c
c     #################################################
c



c     assemble ADI diffusion solver matrices
      call ADIdiffsetmat3 (maxmx,maxmy,maxmz,
     &                          meqn,mwaves,mbc,maux,mwork,
     &                          mthlim,q,work,aux,
     &                          SLHSX,SLHSY,SLHSZ,ipvtx,ipvty,ipvtz,
     &                          ml, mu, lda, alphashearval, alphaXval,
     &     alphaYval,
     &     alphaZval, diffLval, ucutoffval, z_0val)


c     start solving problem.
      call claw3ez(maxmx,maxmy,maxmz,meqn,mwaves,mbc,maux,mwork,
     &                   mthlim,q,work,aux, SLHSX, SLHSY, SLHSZ,
     &                   ipvtx, ipvty, ipvtz, ml, mu, lda, depo,
     &  nprocess,alphashearval, alphaXval, alphaYval,
     &  alphaZval, diffLval, ucutoffval, z_0val )

      return
      end
