c     ============================================
      subroutine b4step3(maxmx,maxmy,maxmz,mbc,mx,my,mz,meqn,q,
     &           xlower,ylower,zlower,dx,dy,dz,told,dt,maux,aux,
     &           SLHSX, SLHSY, SLHSZ, ipvtx, ipvty, ipvtz, ml, mu, lda,
     &           depo, method)
c     ============================================
c
c     # called from claw3 before each call to step3.
c     # use to set time-dependent aux arrays or perform other tasks
c     # which must be done every time step.

c
c     # dummy routine 
c
c     
      implicit double precision (a-h,o-z)
      dimension    q(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc,
     &               1-mbc:maxmz+mbc, meqn)
      dimension  aux(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc, 
     &               1-mbc:maxmz+mbc, maux)
      dimension  method(7)

c
c     ##############################################
c     Diff slvr variables
c     ##############################################
c
      integer ipvtx, ipvty, ipvtz
      dimension SLHSX(lda,maxmx)
      dimension SLHSY(lda,maxmy)
      dimension SLHSZ(lda,maxmz)
      dimension ipvtx(maxmx)
      dimension ipvty(maxmy)
      dimension ipvtz(maxmz)
c
c     ##############################################
c

c
c     ##############################################
c     variable wind data from file
c     ##############################################
c
      common /winddata/ windvel, winddir, windtime, readwindfromfile,
     &                  verticalcorrection, alphashear, maxwind       

      dimension windvel(6000)
      dimension winddir(6000)
      dimension windtime(6000)
      ! notice the constant size of these arrays !
      integer readwindfromfile, maxwind
c
c     ##############################################
c

      common /diffslv3/ z_0, z_low, alphax, alphay, alphaz, 
     &                  diffL, k_zz_option
      common /diffbound/ moptionx, moptiony, moptionz

c
c     ##############################################
c     Ground deposition
c     ##############################################
c
      
      dimension depo(1-mbc:maxmx+mbc, 1-mbc:maxmy+mbc)
      common /diffrobin/ W_dep, W_cor, u_set, gamma, beta
      common /comxyzt/ dtcom,dxcom,dycom,dzcom,tcom,icom,jcom,kcom
c
c
c     depo: is a two dimensional matrix holding value of 
c           ground deposition
c
c     ##############################################
c
c     update aux array in case variable wind data is being used
      if (readwindfromfile .eq. 1) then
        call updatewind3 (maxmx, maxmy, maxmz, mbc
     &                   , mx, my, mz, maux, aux)
c        write(*,*) method(1)
c        read(*,*)
        if (method(1) .eq. 1) then

c     cccccccccccccccccccccccccccccccccccccccccc
c     cccccccccccccccccccccccccccccccccccccccccc
c     using variable dt so we need to reconstruct 
c     diffusion matrices
           coux = alphax*dtcom/(dx*dx)
           write(*,*) 'coux= ', coux !calculate initial alpha*dt/dx^2 in X
          write(*,*) 'alphax= ', alphax !calculate initial alpha*dt/dx^2 in

c     write(*,*) 'alphay= ', alphay
           couy = alphay*dtcom/(dy*dy)
           write(*,*) 'couy= ', couy !calculate initial alpha*dt/dy^2 in Y
        write(*,*) 'alphay= ', alphay !calculate initial alpha*dt/dx^2 in


c      write(*,*) 'alphaz= ', alphaz
           couz = alphaz*dtcom/(dz*dz)
           write(*,*) 'couz= ', couz !calculate initial alpha*dt/dz^2 in Z
        write(*,*) 'alphaz= ', alphaz !calculate initial alpha*dt/dx^2 in

      
c           write(*,*)
c           write(*,*) dtcom
c           read(*,*)

c      read(*,*)
c     assemble all matrices and factorize
           call asmblmat3(maxmx, maxmy,maxmz, mbc, mx, my, mz
     &                     ,SLHSX, SLHSY, SLHSZ, lda, ml, mu
     &                     ,ipvtx,ipvty,ipvtz
     &                     ,info, coux, couy, couz
     &                     ,moptionx, moptiony, moptionz
     &                     ,dx, dy, dz)
        
        endif

      endif
      do 80 i=1, meqn
c     ADI slv for each variable
        call diff3step (SLHSX,SLHSY,SLHSZ,lda, maxmx, maxmy, maxmz,
     &                mbc, meqn, mx, my, mz, ml, mu,
     &                ipvtx, ipvty, ipvtz, q, i, aux)
   80 continue


c     ###############################################
c     update ground deposition values
c     ##############################################
      ! we should probably put this in a seperate function
      ! to improve the format of the code
      smaxdep = 0;
c      write(*,*) 'W_cor', W_cor
c      read(*,*)
      do 90 j=1,mx
         do 99 k=1, my
            depo(j,k) = depo(j,k) +dtcom*(-1)*W_dep *(q(j,k,1,1))
            if (smaxdep .le. depo(j,k) ) then
                smaxdep = depo(j,k)
                smaxq = q(j,k,1,1)
            endif
            
   99    continue   
   90 continue  
      write(*,*) 'Maximum Deposition = ', smaxdep, 
     &' @ q= ', smaxq
      

      return
      end
