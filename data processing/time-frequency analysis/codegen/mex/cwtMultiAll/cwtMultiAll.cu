//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// cwtMultiAll.cu
//
// Code generation for function 'cwtMultiAll'
//

// Include files
#include "cwtMultiAll.h"
#include "cwtMultiAll_data.h"
#include "rt_nonfinite.h"
#include "MWCUFFTPlanManager.hpp"
#include "MWCudaDimUtility.hpp"
#include "cufft.h"
#include <cmath>

// Variable Definitions
static real_T psidft[19200];

static real_T cf[48];

static boolean_T gpuConstsCopied_cwtMultiAll;

// Function Declarations
static __global__ void cwtMultiAll_kernel1(const real_T FourierFactor,
                                           const real_T dv1[400],
                                           const real_T dv[48], real_T b_cf[48],
                                           real_T b_psidft[19200]);

static __global__ void cwtMultiAll_kernel10(creal_T cfsdft[19200]);

static __global__ void cwtMultiAll_kernel11(const creal_T cfsdft[19200],
                                            creal_T cfs[9600]);

static __global__ void cwtMultiAll_kernel12(const creal_T cfs[9600],
                                            const int32_T tIndex,
                                            creal_T cwtres[96000]);

static __global__ void cwtMultiAll_kernel2(const real_T data[2000],
                                           real_T xv[400]);

static __global__ void cwtMultiAll_kernel3(creal_T xdft[400]);

static __global__ void cwtMultiAll_kernel4(const creal_T xdft[400],
                                           creal_T cfsdft[19200],
                                           real_T b_psidft[19200]);

static __global__ void cwtMultiAll_kernel5(const real_T maxwavcf,
                                           const real_T FourierFactor,
                                           real_T coi[200]);

static __global__ void cwtMultiAll_kernel6(real_T b_cf[48], real_T f[48]);

static __global__ void cwtMultiAll_kernel7(const real_T data[2000],
                                           const int32_T tIndex,
                                           real_T xv[400]);

static __global__ void cwtMultiAll_kernel8(creal_T xdft[400]);

static __global__ void cwtMultiAll_kernel9(const creal_T xdft[400],
                                           creal_T cfsdft[19200],
                                           real_T b_psidft[19200]);

// Function Definitions
static __global__ __launch_bounds__(64, 1) void cwtMultiAll_kernel1(
    const real_T FourierFactor, const real_T dv1[400], const real_T dv[48],
    real_T b_cf[48], real_T b_psidft[19200])
{
  uint64_T threadId;
  int32_T kk;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  kk = static_cast<int32_T>(threadId);
  if (kk < 48) {
    for (int32_T jj{0}; jj < 400; jj++) {
      if (jj + 1 > 201) {
        b_psidft[kk + 48 * jj] = 0.0;
      } else {
        b_psidft[kk + 48 * jj] =
            2.0 *
            exp(-0.5 * ((dv[kk] * dv1[jj] - 6.0) * (dv[kk] * dv1[jj] - 6.0))) *
            static_cast<real_T>(dv[kk] * dv1[jj] > 0.0);
      }
      if (jj + 1 == 1) {
        b_cf[kk] = FourierFactor / dv[kk];
      }
    }
  }
}

static __global__
    __launch_bounds__(512, 1) void cwtMultiAll_kernel10(creal_T cfsdft[19200])
{
  uint64_T threadId;
  int32_T b_index;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  b_index = static_cast<int32_T>(threadId);
  if (b_index < 19200) {
    real_T ai;
    real_T im;
    real_T re;
    im = cfsdft[b_index].re;
    ai = cfsdft[b_index].im;
    if (ai == 0.0) {
      re = im / 400.0;
      im = 0.0;
    } else if (im == 0.0) {
      re = 0.0;
      im = ai / 400.0;
    } else {
      re = im / 400.0;
      im = ai / 400.0;
    }
    cfsdft[b_index].re = re;
    cfsdft[b_index].im = im;
  }
}

static __global__ __launch_bounds__(512, 1) void cwtMultiAll_kernel11(
    const creal_T cfsdft[19200], creal_T cfs[9600])
{
  uint64_T threadId;
  int32_T b_index;
  int32_T jj;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  jj = static_cast<int32_T>(threadId % 200ULL);
  b_index =
      static_cast<int32_T>((threadId - static_cast<uint64_T>(jj)) / 200ULL);
  if ((static_cast<int32_T>(b_index < 48)) &&
      (static_cast<int32_T>(jj < 200))) {
    cfs[b_index + 48 * jj] = cfsdft[b_index + 48 * (jj + 100)];
  }
}

static __global__ __launch_bounds__(512, 1) void cwtMultiAll_kernel12(
    const creal_T cfs[9600], const int32_T tIndex, creal_T cwtres[96000])
{
  uint64_T threadId;
  int32_T b_index;
  int32_T kk;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  kk = static_cast<int32_T>(threadId % 48ULL);
  b_index =
      static_cast<int32_T>((threadId - static_cast<uint64_T>(kk)) / 48ULL);
  if ((static_cast<int32_T>(b_index < 200)) &&
      (static_cast<int32_T>(kk < 48))) {
    cwtres[(tIndex + 10 * kk) + 480 * b_index] = cfs[kk + 48 * b_index];
  }
}

static __global__
    __launch_bounds__(416, 1) void cwtMultiAll_kernel2(const real_T data[2000],
                                                       real_T xv[400])
{
  uint64_T threadId;
  int32_T kk;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  kk = static_cast<int32_T>(threadId);
  if (kk < 400) {
    if (kk + 1 < 101) {
      xv[kk] = data[99 - kk];
    } else if (kk + 1 <= 300) {
      xv[kk] = data[kk - 100];
    } else {
      xv[kk] = data[499 - kk];
    }
  }
}

static __global__
    __launch_bounds__(224, 1) void cwtMultiAll_kernel3(creal_T xdft[400])
{
  uint64_T threadId;
  int32_T b_index;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  b_index = static_cast<int32_T>(threadId);
  if (b_index < 199) {
    xdft[399 - b_index].re = xdft[b_index + 1].re;
    xdft[399 - b_index].im = -xdft[b_index + 1].im;
  }
}

static __global__ __launch_bounds__(512, 1) void cwtMultiAll_kernel4(
    const creal_T xdft[400], creal_T cfsdft[19200], real_T b_psidft[19200])
{
  uint64_T threadId;
  int32_T jj;
  int32_T kk;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  jj = static_cast<int32_T>(threadId % 400ULL);
  kk = static_cast<int32_T>((threadId - static_cast<uint64_T>(jj)) / 400ULL);
  if ((static_cast<int32_T>(kk < 48)) && (static_cast<int32_T>(jj < 400))) {
    real_T im;
    im = b_psidft[kk + 48 * jj];
    cfsdft[kk + 48 * jj].re = im * xdft[jj].re;
    cfsdft[kk + 48 * jj].im = im * xdft[jj].im;
  }
}

static __global__ __launch_bounds__(224, 1) void cwtMultiAll_kernel5(
    const real_T maxwavcf, const real_T FourierFactor, real_T coi[200])
{
  uint64_T threadId;
  int32_T kk;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  kk = static_cast<int32_T>(threadId);
  if (kk < 200) {
    real_T im;
    int32_T b_kk;
    if (kk + 1 <= 100) {
      b_kk = kk + 1;
    } else if (kk + 1 == 101) {
      b_kk = 100;
    } else {
      b_kk = 200 - kk;
    }
    im =
        1.0 / (0.74048048969306091 * FourierFactor * static_cast<real_T>(b_kk));
    coi[kk] = im;
    if (im > maxwavcf) {
      coi[kk] = maxwavcf;
    }
  }
}

static __global__ __launch_bounds__(64,
                                    1) void cwtMultiAll_kernel6(real_T b_cf[48],
                                                                real_T f[48])
{
  uint64_T threadId;
  int32_T b_index;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  b_index = static_cast<int32_T>(threadId);
  if (b_index < 48) {
    f[b_index] = b_cf[b_index];
  }
}

static __global__ __launch_bounds__(416, 1) void cwtMultiAll_kernel7(
    const real_T data[2000], const int32_T tIndex, real_T xv[400])
{
  uint64_T threadId;
  int32_T kk;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  kk = static_cast<int32_T>(threadId);
  if (kk < 400) {
    if (kk + 1 < 101) {
      xv[kk] = data[(200 * tIndex - kk) + 99];
    } else if (kk + 1 <= 300) {
      xv[kk] = data[(kk + 200 * tIndex) - 100];
    } else {
      xv[kk] = data[(200 * tIndex - kk) + 499];
    }
  }
}

static __global__
    __launch_bounds__(224, 1) void cwtMultiAll_kernel8(creal_T xdft[400])
{
  uint64_T threadId;
  int32_T b_index;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  b_index = static_cast<int32_T>(threadId);
  if (b_index < 199) {
    xdft[399 - b_index].re = xdft[b_index + 1].re;
    xdft[399 - b_index].im = -xdft[b_index + 1].im;
  }
}

static __global__ __launch_bounds__(512, 1) void cwtMultiAll_kernel9(
    const creal_T xdft[400], creal_T cfsdft[19200], real_T b_psidft[19200])
{
  uint64_T threadId;
  int32_T jj;
  int32_T kk;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  jj = static_cast<int32_T>(threadId % 400ULL);
  kk = static_cast<int32_T>((threadId - static_cast<uint64_T>(jj)) / 400ULL);
  if ((static_cast<int32_T>(kk < 48)) && (static_cast<int32_T>(jj < 400))) {
    real_T im;
    im = b_psidft[kk + 48 * jj];
    cfsdft[kk + 48 * jj].re = im * xdft[jj].re;
    cfsdft[kk + 48 * jj].im = im * xdft[jj].im;
  }
}

void cwtMultiAll(const real_T data[2000], real_T fs, creal_T cwtres[96000],
                 real_T f[48], real_T coi[200])
{
  static const real_T dv1[400]{0.0,
                               0.015707963267948967,
                               0.031415926535897934,
                               0.0471238898038469,
                               0.062831853071795868,
                               0.078539816339744828,
                               0.0942477796076938,
                               0.10995574287564278,
                               0.12566370614359174,
                               0.1413716694115407,
                               0.15707963267948966,
                               0.17278759594743864,
                               0.1884955592153876,
                               0.20420352248333656,
                               0.21991148575128555,
                               0.23561944901923451,
                               0.25132741228718347,
                               0.26703537555513246,
                               0.28274333882308139,
                               0.29845130209103038,
                               0.31415926535897931,
                               0.3298672286269283,
                               0.34557519189487729,
                               0.36128315516282622,
                               0.37699111843077521,
                               0.3926990816987242,
                               0.40840704496667313,
                               0.42411500823462212,
                               0.4398229715025711,
                               0.45553093477052004,
                               0.471238898038469,
                               0.48694686130641796,
                               0.50265482457436694,
                               0.51836278784231593,
                               0.53407075111026492,
                               0.5497787143782138,
                               0.56548667764616278,
                               0.58119464091411177,
                               0.59690260418206076,
                               0.61261056745000975,
                               0.62831853071795862,
                               0.64402649398590761,
                               0.6597344572538566,
                               0.67544242052180559,
                               0.69115038378975457,
                               0.70685834705770356,
                               0.72256631032565244,
                               0.73827427359360143,
                               0.75398223686155041,
                               0.7696902001294994,
                               0.78539816339744839,
                               0.80110612666539727,
                               0.81681408993334625,
                               0.83252205320129524,
                               0.84823001646924423,
                               0.86393797973719322,
                               0.87964594300514221,
                               0.89535390627309108,
                               0.91106186954104007,
                               0.92676983280898906,
                               0.942477796076938,
                               0.958185759344887,
                               0.97389372261283591,
                               0.9896016858807849,
                               1.0053096491487339,
                               1.0210176124166828,
                               1.0367255756846319,
                               1.0524335389525807,
                               1.0681415022205298,
                               1.0838494654884787,
                               1.0995574287564276,
                               1.1152653920243767,
                               1.1309733552923256,
                               1.1466813185602747,
                               1.1623892818282235,
                               1.1780972450961724,
                               1.1938052083641215,
                               1.2095131716320704,
                               1.2252211349000195,
                               1.2409290981679684,
                               1.2566370614359172,
                               1.2723450247038663,
                               1.2880529879718152,
                               1.3037609512397643,
                               1.3194689145077132,
                               1.3351768777756623,
                               1.3508848410436112,
                               1.36659280431156,
                               1.3823007675795091,
                               1.398008730847458,
                               1.4137166941154071,
                               1.429424657383356,
                               1.4451326206513049,
                               1.460840583919254,
                               1.4765485471872029,
                               1.492256510455152,
                               1.5079644737231008,
                               1.5236724369910497,
                               1.5393804002589988,
                               1.5550883635269477,
                               1.5707963267948968,
                               1.5865042900628457,
                               1.6022122533307945,
                               1.6179202165987436,
                               1.6336281798666925,
                               1.6493361431346416,
                               1.6650441064025905,
                               1.6807520696705394,
                               1.6964600329384885,
                               1.7121679962064373,
                               1.7278759594743864,
                               1.7435839227423353,
                               1.7592918860102844,
                               1.7749998492782333,
                               1.7907078125461822,
                               1.8064157758141313,
                               1.8221237390820801,
                               1.8378317023500292,
                               1.8535396656179781,
                               1.869247628885927,
                               1.8849555921538761,
                               1.900663555421825,
                               1.9163715186897741,
                               1.9320794819577229,
                               1.9477874452256718,
                               1.9634954084936209,
                               1.9792033717615698,
                               1.9949113350295189,
                               2.0106192982974678,
                               2.0263272615654166,
                               2.0420352248333655,
                               2.0577431881013148,
                               2.0734511513692637,
                               2.0891591146372126,
                               2.1048670779051615,
                               2.1205750411731104,
                               2.1362830044410597,
                               2.1519909677090086,
                               2.1676989309769574,
                               2.1834068942449063,
                               2.1991148575128552,
                               2.2148228207808045,
                               2.2305307840487534,
                               2.2462387473167023,
                               2.2619467105846511,
                               2.2776546738526,
                               2.2933626371205493,
                               2.3090706003884982,
                               2.3247785636564471,
                               2.340486526924396,
                               2.3561944901923448,
                               2.3719024534602942,
                               2.387610416728243,
                               2.4033183799961919,
                               2.4190263432641408,
                               2.4347343065320897,
                               2.450442269800039,
                               2.4661502330679879,
                               2.4818581963359367,
                               2.4975661596038856,
                               2.5132741228718345,
                               2.5289820861397838,
                               2.5446900494077327,
                               2.5603980126756816,
                               2.5761059759436304,
                               2.5918139392115798,
                               2.6075219024795286,
                               2.6232298657474775,
                               2.6389378290154264,
                               2.6546457922833753,
                               2.6703537555513246,
                               2.6860617188192735,
                               2.7017696820872223,
                               2.7174776453551712,
                               2.73318560862312,
                               2.7488935718910694,
                               2.7646015351590183,
                               2.7803094984269672,
                               2.7960174616949161,
                               2.8117254249628649,
                               2.8274333882308142,
                               2.8431413514987631,
                               2.858849314766712,
                               2.8745572780346609,
                               2.8902652413026098,
                               2.9059732045705591,
                               2.921681167838508,
                               2.9373891311064568,
                               2.9530970943744057,
                               2.9688050576423546,
                               2.9845130209103039,
                               3.0002209841782528,
                               3.0159289474462017,
                               3.0316369107141505,
                               3.0473448739820994,
                               3.0630528372500487,
                               3.0787608005179976,
                               3.0944687637859465,
                               3.1101767270538954,
                               3.1258846903218442,
                               3.1415926535897936,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0,
                               0.0};
  static const real_T dv[48]{
      2.5929415186851879, 2.7790459096353382, 2.9785076571171887,
      3.1922854648593515, 3.4214068460765876, 3.6669730621648822,
      3.9301644158637692, 4.21224592432724,   4.5145733993705948,
      4.838599964117666,  5.1858830373703739, 5.5580918192706745,
      5.9570153142343765, 6.3845709297187012, 6.8428136921531726,
      7.3339461243297626, 7.8603288317275366, 8.424491848654478,
      9.029146798741186,  9.6771999282353285, 10.371766074740744,
      11.116183638541346, 11.914030628468748, 12.769141859437399,
      13.685627384306342, 14.66789224865952,  15.720657663455068,
      16.848983697308949, 18.058293597482365, 19.35439985647065,
      20.743532149481485, 22.232367277082687, 23.828061256937492,
      25.538283718874787, 27.371254768612673, 29.335784497319032,
      31.441315326910129, 33.697967394617891, 36.116587194964723,
      38.708799712941286, 41.487064298962956, 44.464734554165354,
      47.656122513874962, 51.076567437749567, 54.742509537225331,
      58.671568994638044, 62.882630653820236, 67.395934789235753};
  cufftHandle b_fftPlanHandle;
  cufftHandle fftPlanHandle;
  creal_T(*gpu_cfsdft)[19200];
  creal_T(*gpu_cfs)[9600];
  creal_T(*gpu_xdft)[400];
  real_T(*gpu_psidft)[19200];
  real_T(*gpu_xv)[400];
  real_T(*gpu_cf)[48];
  real_T maxwavcf;
  int32_T inembed;
  if (!gpuConstsCopied_cwtMultiAll) {
    gpuConstsCopied_cwtMultiAll = true;
    cudaMemcpy(*dv1_gpu_clone, dv1, sizeof(real_T[400]),
               cudaMemcpyHostToDevice);
    cudaMemcpy(*dv_gpu_clone, dv, sizeof(real_T[48]), cudaMemcpyHostToDevice);
  }
  cudaMalloc(&gpu_cfs, 153600ULL);
  cudaMalloc(&gpu_cfsdft, 307200ULL);
  cudaMalloc(&gpu_xdft, 6400ULL);
  cudaMalloc(&gpu_psidft, 153600ULL);
  cudaMalloc(&gpu_cf, 384ULL);
  cudaMalloc(&gpu_xv, 3200ULL);
  //  Apply cwt to multi-channel data. The result is returned in a
  //  nTrial*nFreq*nTime complex double matrix. This procedure is for
  //  cross-spectral density matrix computation in nonparametric computation of
  //  granger causality.
  //
  //  It can be encoded by gpucoder for parallel computation. See mGpucoder.m
  if (!psidft_not_empty) {
    cudaMemcpy(*gpu_cf, cf, 384ULL, cudaMemcpyHostToDevice);
    cudaMemcpy(*gpu_psidft, psidft, 153600ULL, cudaMemcpyHostToDevice);
    cwtMultiAll_kernel1<<<dim3(1U, 1U, 1U), dim3(64U, 1U, 1U)>>>(
        0.954929658551372 * fs, *dv1_gpu_clone, *dv_gpu_clone, *gpu_cf,
        *gpu_psidft);
    cudaMemcpy(psidft, *gpu_psidft, 153600ULL, cudaMemcpyDeviceToHost);
    cudaMemcpy(cf, *gpu_cf, 384ULL, cudaMemcpyDeviceToHost);
    psidft_not_empty = true;
  }
  cwtMultiAll_kernel2<<<dim3(1U, 1U, 1U), dim3(416U, 1U, 1U)>>>(data, *gpu_xv);
  inembed = 400;
  fftPlanHandle = acquireCUFFTPlan(1, &inembed, &inembed, 1, 1, CUFFT_D2Z, 1);
  cufftExecD2Z(fftPlanHandle, (cufftDoubleReal *)&(*gpu_xv)[0],
               (cufftDoubleComplex *)&(*gpu_xdft)[0]);
  cwtMultiAll_kernel3<<<dim3(1U, 1U, 1U), dim3(224U, 1U, 1U)>>>(*gpu_xdft);
  cudaMemcpy(*gpu_psidft, psidft, 153600ULL, cudaMemcpyHostToDevice);
  cwtMultiAll_kernel4<<<dim3(38U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
      *gpu_xdft, *gpu_cfsdft, *gpu_psidft);
  cudaMemcpy(psidft, *gpu_psidft, 153600ULL, cudaMemcpyDeviceToHost);
  inembed = 400;
  b_fftPlanHandle =
      acquireCUFFTPlan(1, &inembed, &inembed, 48, 1, CUFFT_Z2Z, 48);
  cufftExecZ2Z(b_fftPlanHandle, (cufftDoubleComplex *)&(*gpu_cfsdft)[0],
               (cufftDoubleComplex *)&(*gpu_cfsdft)[0], CUFFT_INVERSE);
  maxwavcf = cf[0];
  for (inembed = 0; inembed < 47; inembed++) {
    boolean_T p;
    if (std::isnan(cf[inembed + 1])) {
      p = false;
    } else if (std::isnan(maxwavcf)) {
      p = true;
    } else {
      p = (maxwavcf < cf[inembed + 1]);
    }
    if (p) {
      maxwavcf = cf[inembed + 1];
    }
  }
  cwtMultiAll_kernel5<<<dim3(1U, 1U, 1U), dim3(224U, 1U, 1U)>>>(maxwavcf,
                                                                1.0 / fs, coi);
  cudaMemcpy(*gpu_cf, cf, 384ULL, cudaMemcpyHostToDevice);
  cwtMultiAll_kernel6<<<dim3(1U, 1U, 1U), dim3(64U, 1U, 1U)>>>(*gpu_cf, f);
  cudaMemcpy(cf, *gpu_cf, 384ULL, cudaMemcpyDeviceToHost);
  for (int32_T tIndex{0}; tIndex < 10; tIndex++) {
    cufftHandle c_fftPlanHandle;
    cufftHandle d_fftPlanHandle;
    cwtMultiAll_kernel7<<<dim3(1U, 1U, 1U), dim3(416U, 1U, 1U)>>>(data, tIndex,
                                                                  *gpu_xv);
    inembed = 400;
    c_fftPlanHandle =
        acquireCUFFTPlan(1, &inembed, &inembed, 1, 1, CUFFT_D2Z, 1);
    cufftExecD2Z(c_fftPlanHandle, (cufftDoubleReal *)&(*gpu_xv)[0],
                 (cufftDoubleComplex *)&(*gpu_xdft)[0]);
    cwtMultiAll_kernel8<<<dim3(1U, 1U, 1U), dim3(224U, 1U, 1U)>>>(*gpu_xdft);
    cudaMemcpy(*gpu_psidft, psidft, 153600ULL, cudaMemcpyHostToDevice);
    cwtMultiAll_kernel9<<<dim3(38U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
        *gpu_xdft, *gpu_cfsdft, *gpu_psidft);
    cudaMemcpy(psidft, *gpu_psidft, 153600ULL, cudaMemcpyDeviceToHost);
    inembed = 400;
    d_fftPlanHandle =
        acquireCUFFTPlan(1, &inembed, &inembed, 48, 1, CUFFT_Z2Z, 48);
    cufftExecZ2Z(d_fftPlanHandle, (cufftDoubleComplex *)&(*gpu_cfsdft)[0],
                 (cufftDoubleComplex *)&(*gpu_cfsdft)[0], CUFFT_INVERSE);
    cwtMultiAll_kernel10<<<dim3(38U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
        *gpu_cfsdft);
    cwtMultiAll_kernel11<<<dim3(19U, 1U, 1U), dim3(512U, 1U, 1U)>>>(*gpu_cfsdft,
                                                                    *gpu_cfs);
    cwtMultiAll_kernel12<<<dim3(19U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
        *gpu_cfs, tIndex, cwtres);
  }
  cudaFree(*gpu_xv);
  cudaFree(*gpu_cf);
  cudaFree(*gpu_psidft);
  cudaFree(*gpu_xdft);
  cudaFree(*gpu_cfsdft);
  cudaFree(*gpu_cfs);
}

// End of code generation (cwtMultiAll.cu)
