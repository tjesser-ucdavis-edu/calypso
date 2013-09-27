!>@file   cal_nonlinear_sph_MHD.f90
!!@brief  module cal_nonlinear_sph_MHD
!!
!!@author H. Matsui
!!@date Programmed in Oct., 2009
!
!>@brief  Evaluate nonlinear terms in spherical coordinate grid
!!
!!@verbatim
!!      subroutine s_cal_nonlinear_sph_MHD
!!      subroutine add_reftemp_advect_sph_MHD
!!@endverbatim
!
      module cal_nonlinear_sph_MHD
!
      use m_precision
!
      use m_constants
      use m_control_parameter
      use m_spheric_parameter
      use m_physical_property
      use m_sph_spectr_data
      use m_sph_phys_address
!
      implicit  none
!
!-----------------------------------------------------------------------
!
      contains
!
!-----------------------------------------------------------------------
!
      subroutine s_cal_nonlinear_sph_MHD
!
      use m_machine_parameter
      use m_spheric_param_smp
      use products_sph_fields_smp
      use const_wz_coriolis_rtp
!
!
!$omp parallel
      if( (irtp%i_m_advect*iflag_t_evo_4_velo) .gt. 0) then
        call cal_rtp_cross_prod_w_coef(coef_velo,                       &
     &      irtp%i_vort, irtp%i_velo, irtp%i_m_advect)
      end if
!
      if( (irtp%i_lorentz*iflag_4_lorentz) .gt. 0) then
        call cal_rtp_cross_prod_w_coef(coef_lor,                        &
     &      irtp%i_current, irtp%i_magne, irtp%i_lorentz)
      end if
!
!
!
      if( (irtp%i_vp_induct*iflag_t_evo_4_magne) .gt. 0) then
        call cal_rtp_cross_prod_w_coef(coef_induct,                     &
     &      irtp%i_velo, irtp%i_magne, irtp%i_vp_induct)
      end if
!
!
      if( (irtp%i_h_flux*iflag_t_evo_4_temp) .gt. 0) then
        call rtp_vec_scalar_prod_w_coef(coef_temp,                      &
     &     irtp%i_velo, irtp%i_temp, irtp%i_h_flux)
      end if
!
      if( (irtp%i_c_flux*iflag_t_evo_4_composit) .gt. 0) then
        call rtp_vec_scalar_prod_w_coef(coef_light,                     &
     &     irtp%i_velo, irtp%i_light, irtp%i_c_flux)
      end if
!
      if( (irtp%i_Coriolis*iflag_4_coriolis) .gt. 0) then
        call cal_wz_coriolis_rtp
      end if
!$omp end parallel
!
      end subroutine s_cal_nonlinear_sph_MHD
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
      subroutine add_reftemp_advect_sph_MHD
!
      use m_schmidt_poly_on_rtm
!
      integer(kind= kint) :: ist, ied, inod, j, k
!
!
      ist = (nlayer_ICB-1)*nidx_rj(2) + 1
      ied = nlayer_CMB * nidx_rj(2)
!$omp parallel do private (inod,j,k)
      do inod = ist, ied
        j = mod((inod-1),nidx_rj(2)) + 1
        k = 1 + (inod- j) / nidx_rj(2)
!
        d_rj(inod,ipol%i_h_advect) = d_rj(inod,ipol%i_h_advect)         &
     &                      + coef_temp * g_sph_rj(j,3) * ar_1d_rj(k,2) &
     &                       * reftemp_rj(k,1) * d_rj(inod,ipol%i_velo)
      end do
!$omp end parallel do
!
      end subroutine add_reftemp_advect_sph_MHD
!
!-----------------------------------------------------------------------
!
      end module cal_nonlinear_sph_MHD