c     Implicite Euler matrix assembler
c
c
c     ===============================================================
      subroutine asmblmat1 (maxmx, mbc, mx, cou, moption, SLHS, lda,dx,
     & beta)
c     ===============================================================
c
c     this subroutine assembles the matrix that is required for solution
c     of the one dimensional diffusion solver using Implicit Euler for
c     time stepping.
c
c     maxmx: maximum number of FV cells
c     mbc: number of ghost cells used for boundary conditions
c     mx: number of cells used for computations
c     moption: (currently a dummy variable) holds options for different
c             storage options, boundary conditions etc.
c     SLHS: the laft hand side matrix stored in LINPACK format. For
c             more info on the storage format look at:
c             www.netlib.org/linpack
c
      implicit double precision (a-h,o-z)

      dimension SLHS(lda,maxmx)
      integer moption
      dimension moption(2)

      common /diffrobin/ W_dep, W_cor
      common /diffslv3/ z_0, z_low, alphax, alphay, alphaz, 
     &                  diffL, k_zz_option

      do 20 j = 3, (mx-2)
          SLHS(2,j) = -1*cou
          SLHS(3,j) = 2*cou + 1
          SLHS(4,j) = -1*cou
   20 continue

c     boundary conditions on x- lower
      if (moption(1) .eq. 1) then
c     Dirichlet
         SLHS(3,1) = 1 + 3.0*cou
         SLHS(4,1) = -1.0*cou
         SLHS(2,2) = -1.0*cou
         SLHS(3,2) = 2.0*cou +1
         SLHS(4,2) = -1.0*cou
      else if (moption(1) .eq. 2) then
c     Neumann
         SLHS(3,1) = 1 + cou
         SLHS(4,1) = -1*cou
         SLHS(2,2) = -1*cou
         SLHS(3,2) = 2.0*cou +1
         SLHS(4,2) = -1.0*cou
      else if (moption(1) .eq. 3) then
c     Robin
         SLHS(3,1) = 1 + (2.0 - beta)*cou
         SLHS(4,1) = -1*cou
         SLHS(2,2) = -1*cou
         SLHS(3,2) = 1+ 2.0*cou
         SLHS(4,2) = -1.0*cou
      else
         write(*,*) 'asmblmat1: Boundary condition on lower face
     & unidentified'
         read(*,*)
      end if

c     boundary conditions on x- upper
      if (moption(2) .eq. 1) then
c     Dirichlet
         SLHS(2, mx-1) = -1.0*cou
         SLHS(3, mx-1) = 2.0*cou +1
         SLHS(2, mx) = -1.0*cou
         SLHS(2, mx) = -1.0*cou
         SLHS(3, mx) = 1 + 3.0*cou
      else if (moption(2) .eq. 2) then
c     Neumann 
         SLHS(2, mx-1) = -1.0*cou
         SLHS(3, mx-1) = 2.0*cou +1
         SLHS(4, mx-1) = -1.0*cou
         SLHS(2, mx) = -1.0*cou
         SLHS(3, mx) = 1 + cou
      else
         write(*,*) 'asmblmat1: Boundary condition on upper face
     &    unidentified'
         read(*,*)
      end if

      return
      end
