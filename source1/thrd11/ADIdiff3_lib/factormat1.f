c
c     a subroutine that mainly calls the dgbfa subroutine of LINPACK
c     to factor the banded matrix and set up for solving the system
c
c     =================================================================
      subroutine factormat1(maxmx, mbc, mx, SLHS, lda,
     &  ml, mu, ipvt,  info)
c     =================================================================
c
      implicit double precision (a-h,o-z)

      integer ipvt, info
      dimension SLHS(lda,maxmx)
      dimension ipvt(maxmx)

      call dgbfa(SLHS,lda,mx,ml,mu,ipvt,info)

      return
      end
