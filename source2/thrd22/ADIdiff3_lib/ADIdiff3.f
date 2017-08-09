c
c     This is a more comprehensive function that does few iterations of 
c     the diffusion solver between writing output files.
c
c     Bamdad Hosseini, Jul 2012.
c
c     =================================================================
      subroutine ADIdiff3(maxmx, maxmy, maxmz, mx, my, mz, meqn,
     &                    mbc, maux,mwork,q,aux,
     &                  SLHSX, SLHSY, SLHSZ, lda, tstart, tend, dtv,
     &                  ml, mu, ipvtx, ipvty, ipvtz)

      implicit double precision (a-h,o-z)
      dimension     q(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &                1-mbc:maxmz+mbc, meqn)
      dimension   aux(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &                1-mbc:maxmz+mbc, *)
      dimension dtv(5)

      dimension SLHSX(lda, maxmx) !L.H.S matrix in x-direction
      dimension SLHSY(lda, maxmy) !L.H.S matrix in y-direction
      dimension SLHSZ(lda, maxmz) !L.H.S matrix in z-direction
c     holds the left hand side matrix
      integer ipvtx, ipvty, ipvtz, info

      dimension ipvtx(maxmx) !pivoting vector for x-direction
      dimension ipvty(maxmy) !pivoting vector for y-direction
      dimension ipvtz(maxmz) !pivoting vector for z-direction
c     variables used for factoring the banded left hand side matrix

      dt = dtv(1)
      t = tstart

      if (tend .lt. tstart) then
c         # single step mode
          write(*,*) 'single step mode'
          maxn = 1
      else
          maxn = (tend - tstart + 1d-10) / dt
          if (dabs(maxn*dt - (tend-tstart)) .gt.
     &                          1d-5*(tend-tstart)) then
c                # dt doesn't divide time interval integer number of times
             info = 2
             write(*,*) 'info=2'
             go to 900
          endif
      endif
c
c     =========
c     Main loop
c     =========
c
      write(*,*) 't= ', t
      do 100 n=1, maxn

c     swipe for each variable
        do 80 i=1, meqn

        call diff3step (SLHSX, SLHSY, SLHSZ, lda, maxmx, maxmy, maxmz,
     &                mbc, meqn, mx, my, mz, ml, mu,
     &                ipvtx, ipvty, ipvtz, q, i, aux)

   80   continue
        t = t+dt
        write(*,*) 't: ', t
  100 continue
      tend = t

  900 return
      end
