c
c     This subroutine is the heart of the diffusion solver
c     given all SLHS left hand side matrices in factored form
c     this subroutine does a single step updating values using diffusion
c     term. 
c
c     =================================================================
      subroutine diff3step (SLHSX,SLHSY,SLHSZ,lda, maxmx, maxmy, maxmz,
     &                mbc, meqn, mx, my, mz, ml, mu,
     &                ipvtx, ipvty, ipvtz, q, meq, aux)
c     =================================================================
c
      implicit double precision (a-h,o-z)
      dimension     q(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &                1-mbc:maxmz+mbc, meqn) ! array of solution
      dimension   aux(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &                1-mbc:maxmz+mbc, *) ! array of aux values
      dimension SLHSX(lda, maxmx) ! LHS matrix in X-direction
      dimension SLHSY(lda, maxmy) ! LHS matrix in Y-direction
      dimension SLHSz(lda, maxmz) ! LHS matrix in Z-direction
c     
c     extra set of arrays used for solutions
      dimension qqx(maxmx)
      dimension qqy(maxmy)
      dimension qqz(maxmz)
c
c     LHS pivoting arrays used by LINPACK solver
      integer ipvtx, ipvty, ipvtz, lda
      dimension ipvtx(maxmx)
      dimension ipvty(maxmy)
      dimension ipvtz(maxmz)

c     we need dtcom to update values properly
      common /comxyzt/ dtcom,dxcom,dycom,dzcom,tcom,icom,jcom,kcom

c     sweep in y direction
      do 301 k=1, mz
        do 201 n=1, mx
            do 101 i=1, my
                qqy(i) = q(n, i, k, meq)
  101       continue

            call dgbsl(SLHSY,lda,my,ml,mu,ipvty,qqy,0)

            do 3301 i=1, my
                q(n, i, k, meq) = qqy(i)
 3301       continue

  201   continue
  301 continue

c     sweep in x direction
      do 302 k=1, mz
        do 202 n=1, my
            do 102 i=1, mx
                qqx(i) = q(i, n, k, meq)
  102       continue

            call dgbsl(SLHSX,lda,mx,ml,mu,ipvtx,qqx,0)

            do 3303 i=1, mx
                q(i, n, k, meq) =qqx(i)
 3303       continue

  202   continue
  302 continue

c     sweep in z direction
      do 303 k=1, mx
        do 203 n=1, my
            do 103 i=1, mz
                qqz(i) = q(k, n, i, meq)
  103       continue

            call dgbsl(SLHSZ,lda,mx,ml,mu,ipvtz,qqz,0)

            do 304 i=1, mz
                q(k, n, i, meq) =qqz(i)
  304       continue

  203   continue
  303 continue

      return
      end
