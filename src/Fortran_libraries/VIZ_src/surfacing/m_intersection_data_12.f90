!
!     module m_intersection_data_12
!
      module m_intersection_data_12
!
!      Written by H. Matsui on june, 2006
!
      use m_precision
!
      implicit none
!
!
!   4 nodes which have differrent sign on triangle and remote one
!      (one triangle and hexagonal ... 4 triangles)
!
!     flag = 1: c-c_ref >= 0
!     flag = 1: c-c_ref < 0
!
!       12345678: boundary...8 of 12: triangle and hexa
!                   (1-2-3); (4-5-3), (5-2-3), (5-1-2)
! 154:  01011001: 1-2, 4-1, 1-5; 7-8, 3-4, 2-3, 2-6, 5-6:
!                   1-4- 9; 7-3-2-10-5
!                   1-4- 9; 10-5-2, 5-3-2, 5-7-3
! 169:  10010101: 8-5, 5-6, 1-5; 3-4, 1-2, 2-6, 6-7, 7-8
!                   8-5- 9; 3-1-10-6-7
!                   8-5- 9; 6-7-10, 7-1-10, 7-3-1
!  89:  10011010: 7-8, 8-5, 4-8; 1-2, 5-6, 6-7, 3-7, 3-4
!                   7-8-12; 1-5-6-11-3
!                   7-8-12; 11-3-6, 3-5-6, 3-1-5
! 149:  10101001: 4-1, 3-4, 4-8; 5-6, 7-8, 3-7, 2-3, 1-2
!                   4-3-12; 5-7-11-2-1
!                   4-3-12; 2-1-11, 1-7-11, 1-5-7
!
! 101:  10100110: 2-3, 1-2, 2-6; 7-8, 5-6, 1-5, 4-1, 3-4
!                   2-1-10; 7-5- 9-4-3
!                   2-1-10; 4-3- 9, 3-5- 9, 3-7-5
! 106:  01010110: 3-4, 2-3, 3-7; 5-6, 1-2, 4-1, 4-8, 7-8
!                   3-2-11; 5-1-4-12-7
!                   3-2-11; 12-7-4, 7-1-4, 7-5-1
! 166:  01100101: 6-7, 7-8, 3-7; 1-2, 3-4, 4-8, 8-5, 5-6
!                   6-7-11; 1-3-12-8-5
!                   6-7-11; 8-5-12, 5-3-12, 5-1-3
!  86:  01101010: 5-6, 6-7, 2-6; 3-4, 7-8, 8-5, 1-5, 1-2
!                   5-6-10; 3-7-8- 9-1
!                   5-6-10; 9-1-8, 1-7-8, 1-3-7
!
!  58:  01011100: 1-2, 4-1, 1-5; 6-7, 8-5, 4-8, 3-4, 2-3
!                   1-4- 9; 6-8-12-3-2
!                   1-4- 9; 3-2-12, 2-8-12, 2-6-8
!  53:  10101100: 2-3, 1-2, 2-6; 8-5, 4-1, 3-4, 3-7, 6-7
!                   2-1-10; 8-4-3-11-6
!                   2-1-10; 11-6-3, 6-4-3, 6-8-4
!  83:  11001010: 5-6, 6-7, 2-6; 4-1, 2-3, 3-7, 7-8, 8-5
!                   5-6-10; 4-2-11-7-8
!                   5-6-10; 7-8-11, 8-2-11, 8-4-2
! 163:  11000101: 8-5, 5-6, 1-5; 2-3, 6-7, 7-8, 4-8, 4-1
!                   8-5- 9; 2-6-7-12-4
!                   8-5- 9; 12-4-7, 4-6-7, 4-2-6
!
! 197:  10100011: 4-1, 3-4, 4-8; 6-7, 2-3, 1-2, 1-5, 8-5
!                   4-3-12; 6-2-1- 9-8
!                   4-3-12; 9-8-1, 8-2-1, 8-6-2
!  92:  00111010: 7-8, 8-5, 4-8; 2-3, 4-1, 1-5, 5-6, 6-7
!                   7-8-12; 2-4- 9-5-6
!                   7-8-12; 5-6- 9, 6-4- 9, 6-2-4
! 172:  00110101: 6-7, 7-8, 3-7; 4-1, 8-5, 5-6, 2-6, 2-3; 
!                   6-7-11;   4-8-5-10-2
!                   6-7-11; 10-2-5, 2-8-5, 2-4-8
! 202:  01010011: 3-4, 2-3, 3-7; 8-5, 6-7, 2-6, 1-2, 4-1
!                   3-2-11; 8-6-10-1-4
!                   3-2-11; 1-4-10, 4-6-10, 4-8-6
!
!  30:  01111000: 1-2, 4-1, 1-5; 3-7, 2-6, 5-6, 8-5, 4-8
!                   1-4- 9; 11-10-5-8-12
!                   1-4- 9; 8-12-5, 12-10-5, 12-11-10
! 135:  11100001: 4-1, 3-4, 4-8; 2-6, 1-5, 8-5, 7-8, 3-7
!                   4-3-12; 10- 9-8-7-11
!                   4-3-12; 7-11-8, 11- 9-8, 11-10- 9
!  75:  11010010: 3-4, 2-3, 3-7; 1-5, 4-8, 7-8, 6-7, 2-6
!                   3-2-11; 9-12-7-6-10
!                   3-2-11; 6-10-7, 10-12-7, 10- 9-12
!  45:  10110100: 2-3, 1-2, 2-6; 4-8, 3-7, 6-7, 5-6, 1-5
!                   2-1-10; 12-11-6-5- 9
!                   2-1-10; 5- 9-6,  9-11-6,  9-12-11
!
! 225:  10000111: 8-5, 5-6, 1-5; 3-7, 4-8, 4-1, 1-2, 2-6
!                   8-5- 9; 11-12-4-1-10
!                   8-5- 9; 1-10-4, 10-12-4, 10-11-12
! 210:  01001011: 5-6, 6-7, 2-6; 4-8, 1-5, 1-2, 2-3, 3-7
!                   5-6-10; 12- 9-1-2-11
!                   5-6-10; 2-11-1, 11- 9-1, 11-12- 9
! 180:  00101101: 6-7, 7-8, 3-7; 1-5, 2-6, 2-3, 3-4, 4-8
!                   6-7-11; 9-10-2-3-12
!                   6-7-11; 3-12-2, 12-10-2, 12- 9-10
! 120:  00011110: 7-8, 8-5, 4-8; 2-6, 3-7, 3-4, 4-1, 1-5
!                   7-8-12; 10-11-3-4- 9
!                   7-8-12; 4- 9-3,  9-11-3,  9-10-11
!
!
      integer(kind = kint), parameter, private :: nnod_tri = 3
      integer(kind = kint), parameter, private :: nnod_pen = 5
!
      integer(kind = kint), parameter :: nkind_etype_12 = 24
      integer(kind = kint), parameter :: num_patch_12 =   4
      integer(kind = kint), parameter :: itri_2_patch_12(9)             &
     &     = (/4, 5, 3,    5, 2, 3,    5, 1, 2/)
!
      integer(kind = kint), parameter                                   &
     &   :: iflag_psf_etype_12(nkind_etype_12)                          &
     &     = (/154, 169,  89, 149,    101, 106, 166,  86,               &
     &          58,  53,  83, 163,    197,  92, 172, 202,               &
     &          30, 135,  75,  45,    225, 210, 180, 120/)
!
!
      integer(kind = kint), parameter                                   &
     &        :: iedge_tri_12(nnod_tri, nkind_etype_12)                 &
     &      = reshape(                                                  &
     &       (/ 1, 4,  9,   8, 5,  9,    7, 8, 12,   4, 3, 12,          &
     &          2, 1, 10,   3, 2, 11,    6, 7, 11,   5, 6, 10,          &
     &          1, 4,  9,   2, 1, 10,    5, 6, 10,   8, 5,  9,          &
     &          4, 3, 12,   7, 8, 12,    6, 7, 11,   3, 2, 11,          &
     &          1, 4,  9,   4, 3, 12,    3, 2, 11,   2, 1, 10,          &
     &          8, 5,  9,   5, 6, 10,    6, 7, 11,   7, 8, 12/),        &
     &       shape=(/nnod_tri, nkind_etype_12/) )
!
      integer(kind = kint), parameter                                   &
     &        :: iedge_pen_12(nnod_pen, nkind_etype_12)                 &
     &      = reshape(                                                  &
     &       (/ 7,  3,  2, 10,  5,      3,  1, 10,  6,  7,              &
     &          1,  5,  6, 11,  3,      5,  7, 11,  2,  1,              &
     &          7,  5,  9,  4,  3,      5,  1,  4, 12,  7,              &
     &          1,  3, 12,  8,  5,      3,  7,  8,  9,  1,              &
     &          6,  8, 12,  3,  2,      8,  4,  3, 11,  6,              &
     &          4,  2, 11,  7,  8,      2,  6,  7, 12,  4,              &
     &          6,  2,  1,  9,  8,      2,  4,  9,  5,  6,              &
     &          4,  8,  5, 10,  2,      8,  6, 10,  1,  4,              &
     &         11, 10,  5,  8, 12,     10,  9,  8,  7, 11,              &
     &          9, 12,  7,  6, 10,     12, 11,  6,  5,  9,              &
     &         11, 12,  4,  1, 10,     12,  9,  1,  2, 11,              &
     &          9, 10,  2,  3, 12,     10, 11,  3,  4,  9/),            &
     &       shape=(/nnod_pen, nkind_etype_12/) )
!
      integer(kind = kint), parameter                                   &
     &        :: iedge_4_patch_12(nnod_tri,num_patch_12,nkind_etype_12) &
     &      = reshape(                                                  &
     &       (/ 1, 4,  9,     10,  5,  2,    5,  3,  2,    5,  7,  3,   &
     &          8, 5,  9,      6,  7, 10,    7,  1, 10,    7,  3,  1,   &
     &          7, 8, 12,     11,  3,  6,    3,  5,  6,    3,  1,  5,   &
     &          4, 3, 12,      2,  1, 11,    1,  7, 11,    1,  5,  7,   &
     &          2, 1, 10,      4,  3,  9,    3,  5,  9,    3,  7,  5,   &
     &          3, 2, 11,     12,  7,  4,    7,  1,  4,    7,  5,  1,   &
     &          6, 7, 11,      8,  5, 12,    5,  3, 12,    5,  1,  3,   &
     &          5, 6, 10,      9,  1,  8,    1,  7,  8,    1,  3,  7,   &
     &          1, 4,  9,      3,  2, 12,    2,  8, 12,    2,  6,  8,   &
     &          2, 1, 10,     11,  6,  3,    6,  4,  3,    6,  8,  4,   &
     &          5, 6, 10,      7,  8, 11,    8,  2, 11,    8,  4,  2,   &
     &          8, 5,  9,     12,  4,  7,    4,  6,  7,    4,  2,  6,   &
     &          4, 3, 12,      9,  8,  1,    8,  2,  1,    8,  6,  2,   &
     &          7, 8, 12,      5,  6,  9,    6,  4,  9,    6,  2,  4,   &
     &          6, 7, 11,     10,  2,  5,    2,  8,  5,    2,  4,  8,   &
     &          3, 2, 11,      1,  4, 10,    4,  6, 10,    4,  8,  6,   &
     &          1, 4,  9,      8, 12,  5,   12, 10,  5,   12, 11, 10,   &
     &          4, 3, 12,      7, 11,  8,   11,  9,  8,   11, 10,  9,   &
     &          3, 2, 11,      6, 10,  7,   10, 12,  7,   10,  9, 12,   &
     &          2, 1, 10,      5,  9,  6,    9, 11,  6,    9, 12, 11,   &
     &          8, 5,  9,      1, 10,  4,   10, 12,  4,   10, 11, 12,   &
     &          5, 6, 10,      2, 11,  1,   11,  9,  1,   11, 12,  9,   &
     &          6, 7, 11,      3, 12,  2,   12, 10,  2,   12,  9, 10,   &
     &          7, 8, 12,      4,  9,  3,    9, 11,  3,    9, 10, 11/), &
     &       shape=(/nnod_tri,num_patch_12,nkind_etype_12/) )
!
      end module m_intersection_data_12