!>@file   spherical_harmonics.f90
!!@brief  module spherical_harmonics
!!
!!@author H. Matsui
!!@date Programmed in 1997
!!@n    Modified in 2009
!
!> @brief Routines for spherical harmonics and normalization
!!
!!@verbatim
!!      subroutine idx28
!!***********************************************************************
!!*    subroutine for make indices for spherical harmonics
!!*                                     97,12,19
!!***********************************************************************
!!*
!!***********************************************************************
!!*
!!*   g(j,1) , idx(j,1) : index l
!!*   g(j,2) , idx(j,2) : index m
!!*   g(j,3)            : l*(l+1)
!!*   g(j,4)            : (l-1)*l
!!*   g(j,5)            : (l+1)*(l+2)
!!*   g(j,6)            : (2*l+1) / 4
!!*            g(j,6)   : (2*l+1) / 2                    (m = 0)
!!*   g(j,7)            : (2*l+1) / ( 4*l*(l+1) )
!!*            g(j,7)   : (2*l+1) / ( 2*l*(l+1) )        (m = 0)
!!*            g(j,7)   : 1                              (l=m=0)
!!*   g(j,8)            : ( 4*pi*l*(l+1) ) / (2*l+1)
!!*   g(j,9)            : (2*l+1) / ( 4*pi*l*(l+1) )
!!*            g(j,9)   : 1 / 4*pi                       (l=m=0)
!!*   g(j,10)           : ( 4*pi ) / (2*l+1)
!!*   g(j,11)           :  1 / (2*l+1)
!!*   g(j,12)           :  l*(l+1) / (2*l+1)
!!*   g(j,13)           :  1 / (l*(l+1))
!!*            g(j,13)  :    1                           (l=m=0)
!!
!!*   g(j,16)           : (2*l+1) / 4
!!*   g(j,17)           : (2*l+1) / ( 4*l*(l+1) )
!!*            g(j,17)  : 0                              (l=m=0)
!!
!!
!!   Note: g(0,3) = 1/2 for spherical harmonics transform
!!   Note: g(0,13) = 2  for gradient of scalar
!!    (See g_sph_rlm in schmidt_poly_on_rtm_grid.f90)
!!
!!*
!!***********************************************************************
!!*
!!      subroutine spheric(phi)
!!*************************************************************
!!*     lead spherical harmonics
!!*         and differential of spherical harmonics
!!*************************************************************
!!*
!!*************************************************************
!!*
!!*     required subroutine
!!*         dschmidt.f
!!*
!!*************************************************************
!!*
!!*************************************************************
!!*
!!*      p(m,l,0)  : Schmidt Polynomial
!!*      dp(m,l,1) : diffrential of Schmidt Polynomial  dp/dtheta
!!*        phi      :  input longitude phi ( 0 =< phi <= 2*pi )
!!*       work  :   work area
!!*
!!*************************************************************
!!@endverbatim
!*
      module spherical_harmonics
!
      use m_precision
!
      use m_constants
      use m_spherical_harmonics
!
      implicit none
!
!  ---------------------------------------------------------------------
!
      contains
!
!  ---------------------------------------------------------------------
!
      subroutine idx28
!*
      real(kind = kreal) :: pi
      integer(kind = kint) :: l, m, j
!*
!
!* -----  set index -----------------
!*
      pi = four* atan(one)
!
      do l = 0, ltr_tri_sph
        do m = -l, l
          j = l*(l+1) + m
!
          idx(j,1) = l
          idx(j,2) = m
          g(j,1) = dble(l)
          g(j,2) = dble(m)
          g(j,3) = dble( l*(l+1) )
          g(j,4) = dble( (l-1)*l)
          g(j,5) = dble( (l+1)*(l+2) )
!
          g(j,8) =  four*pi * dble( l*(l+1) ) / dble(2*l+1)
!
          g(j,10) = four*pi / dble(2*l+1)
          g(j,11) = one / dble(2*l+1)
          g(j,12) = dble( l*(l+1) ) / dble(2*l+1)
!
          g(j,16) = dble(2*l+1) / four
        end do
      end do
!
!   l = m = 0
      g(0,6) = one / two
      g(0,7) = one
      g(0,9) = one / (four*pi)
      g(0,13) = one
      g(0,17) = zero
!
      do l = 1, ltr_tri_sph
        do m = -l, l
          j = l*(l+1) + m
          if ( m .eq. 0 ) then
            g(j,6) = dble(2*l+1) / two
            g(j,7) = dble(2*l+1) / dble( 2*l*(l+1) )
          else
            g(j,6) = dble(2*l+1) / four
            g(j,7) = dble(2*l+1) / dble( 4*l*(l+1) )
          end if
!
          g(j,9) =  dble(2*l+1) / (four*pi*dble( l*(l+1) ))
          g(j,13) = one / dble( l*(l+1) )
          g(j,17) = dble(2*l+1) / dble( 4*l*(l+1) )
        end do
      end do
!*
      end subroutine idx28
!
!  ---------------------------------------------------------------------
!
      subroutine spheric(phi)
!*
      use m_schmidt_polynomial
!*
      real(kind= kreal), intent(in) :: phi
      integer(kind = kint) :: j, l, m
!
!* ---------- lead spherical harmonics ----------
!*
      s(0,0) = one
      s(0,1) = zero
      s(0,2) = zero
      s(0,3) = zero
!*
      do 20 j = 1 ,jmax_tri_sph
!*
        l = idx(j,1)
        if ( idx(j,2) .lt. 0 ) then
          m = -idx(j,2)
          s(j,0) = p(m,l) * sin( dble(m)*phi )
          s(j,1) = p(m,l) * dble(m) * cos( dble(m)*phi )
          s(j,2) = dp(m,l) * sin( dble(m)*phi )
          s(j,3) = dp(m,l) * dble(m) * cos( dble(m)*phi )
!*
        else if ( idx(j,2) .eq. 0 ) then
          m = idx(j,2)
          s(j,0) = p(m,l)
          s(j,1) = zero
          s(j,2) = dp(m,l)
          s(j,3) = zero
        else
          m = idx(j,2)
          s(j,0) = p(m,l) * cos( dble(m)*phi )
          s(j,1) = - p(m,l) * dble(m) * sin( dble(m)*phi )
          s(j,2) = dp(m,l) * cos( dble(m)*phi )
          s(j,3) = - dp(m,l) * dble(m) * sin( dble(m)*phi )
        endif
!*
  20  continue
!*
      return
      end subroutine spheric
!*
!  ---------------------------------------------------------------------
!
      end module spherical_harmonics
