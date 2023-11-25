//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// cwtMultiAll_initialize.cu
//
// Code generation for function 'cwtMultiAll_initialize'
//

// Include files
#include "cwtMultiAll_initialize.h"
#include "_coder_cwtMultiAll_mex.h"
#include "cwt.h"
#include "cwtMultiAll_data.h"
#include "rt_nonfinite.h"

// Function Declarations
static void cwtMultiAll_once();

// Function Definitions
static void cwtMultiAll_once()
{
  mex_InitInfAndNan();
  psidft_not_empty_init();
  cudaMalloc(&dv1_gpu_clone, sizeof(real_T[400]));
  cudaMalloc(&dv_gpu_clone, sizeof(real_T[48]));
}

void cwtMultiAll_initialize()
{
  mexFunctionCreateRootTLS();
  emlrtClearAllocCountR2012b(emlrtRootTLSGlobal, false, 0U, nullptr);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLicenseCheckR2012b(emlrtRootTLSGlobal,
                          (const char_T *)"distrib_computing_toolbox", 2);
  emlrtLicenseCheckR2012b(emlrtRootTLSGlobal, (const char_T *)"wavelet_toolbox",
                          2);
  if (emlrtFirstTimeR2012b(emlrtRootTLSGlobal)) {
    cwtMultiAll_once();
  }
  emlrtInitGPU(emlrtRootTLSGlobal);
  cudaGetLastError();
}

// End of code generation (cwtMultiAll_initialize.cu)
