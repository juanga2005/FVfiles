c
c
c     This subroutine assembles all matrices required for the 3D ADI 
c     diffusion solver. This function call the asmblmat1 functions in 
c     each direction and for "Z" it considers an option for using 
c     vertical eddy diffusivity corrections.
c
c
c     =================================================================
      subroutine asmblmat3(maxmx, maxmy,maxmz, mbc, mx, my, mz
     &                     ,SLHSX, SLHSY, SLHSZ, lda, ml, mu
     &                     ,ipvtx,ipvty,ipvtz
     &                     ,info, coux, couy, couz
     &                     ,moptionx, moptiony, moptionz
     &                     ,dx, dy, dz)
c     =================================================================
c
c     a subroutine for assembling left hand side matrices used in
c     implicit euler solver for diffusion terms in 2D

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
c     common block holding diffusion coefficients and options
      common /diffslv3/  z_0, z_low,  alphax, alphay, alphaz, 
     &                   diffL, k_zz_option
c     common block holding deposition coefficients
      common /diffrobin/ W_dep, W_cor, u_set

c     in x direction
c     
      call asmblmat1 (maxmx, mbc, mx, coux, moptionx, SLHSX, lda, dx,
     & 0)
      call factormat1(maxmx, mbc, mx, SLHSX, lda, ml, mu, ipvtx, info)

c     in y direction

      call asmblmat1 (maxmy, mbc, my, couy, moptiony, SLHSY, lda, dy, 
     & 0)
c      write(*,*) W_y
c      read(*,*)
      call factormat1(maxmy, mbc, my, SLHSY, lda, ml, mu, ipvty, info)

c     in z direction
c
c     are we doing k_zz corrections?
      if (k_zz_option .eq. 0) then
c     no! do normal matrix assembly
         write(*,*) 'doing constant k_zz'
c
c     gamma = -2*K/(dz*(w_dep - u_set)) is the coefficient 
c     that is used for robin BC C_0 = C_1*(gamma-1)/(1+gamma)
c     
c     beta = (gamma - 1)/(1+gamma) which is used in 
c     C_0 = beta*C_1 
c     where C_0 is the ghost cell
c
         
         gammaz = -2.0*alphaz/(dz*(W_dep - u_set))
         betaz = (gammaz -1.0)/(1.0+ gammaz)
c         write(*,*) gammaz, betaz
c         read(*,*)

         call asmblmat1 (maxmz, mbc, mz, couz, moptionz, SLHSZ, lda, dz,
     &   betaz)
c      write(*,*) W_z
c      read(*,*)
      elseif (k_zz_option .eq. 1) then
c     yes! assemble matrix with variable k_zz
         write(*,*) 'doing variable k_zz'
         call asmblmat1_corrected_diff (maxmz, mbc, mz, couz, 
     &                      z_0, z_low, diffL, moptionz, SLHSZ, lda, dz)
      else
c     bad input
         write(*,*) 'Asmblmat3: Invalid Option for k_zz corrections'
         read(*,*)
      endif

      call factormat1(maxmz, mbc, mz, SLHSZ, lda, ml, mu, ipvtz, info)

      return
      end
