//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_cwtMultiAll_api.cu
//
// Code generation for function '_coder_cwtMultiAll_api'
//

// Include files
#include "_coder_cwtMultiAll_api.h"
#include "cwtMultiAll.h"
#include "cwtMultiAll_data.h"
#include "rt_nonfinite.h"

// Function Declarations
static real_T b_emlrt_marshallIn(const mxArray *src,
                                 const emlrtMsgIdentifier *msgId);

static real_T emlrt_marshallIn(const mxArray *fs, const char_T *identifier);

static real_T emlrt_marshallIn(const mxArray *u,
                               const emlrtMsgIdentifier *parentId);

// Function Definitions
static real_T b_emlrt_marshallIn(const mxArray *src,
                                 const emlrtMsgIdentifier *msgId)
{
  static const int32_T dims{0};
  real_T ret;
  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src,
                          (const char_T *)"double", false, 0U, (void *)&dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T emlrt_marshallIn(const mxArray *fs, const char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = const_cast<const char_T *>(identifier);
  thisId.fParent = nullptr;
  thisId.bParentIsCell = false;
  y = emlrt_marshallIn(emlrtAlias(fs), &thisId);
  emlrtDestroyArray(&fs);
  return y;
}

static real_T emlrt_marshallIn(const mxArray *u,
                               const emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = b_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

void cwtMultiAll_api(const mxArray *const prhs[2], int32_T nlhs,
                     const mxArray *plhs[3])
{
  static const int32_T d_dims[3]{65, 651, 128};
  static const int32_T dims[2]{651, 128};
  static const int32_T b_dims[1]{651};
  static const int32_T c_dims[1]{65};
  const mxGPUArray *data_gpu;
  mxGPUArray *coi_gpu;
  mxGPUArray *cwtres_gpu;
  mxGPUArray *f_gpu;
  real_T(*cwtres)[5416320];
  real_T(*data)[83328];
  real_T(*coi)[651];
  real_T(*f)[65];
  real_T fs;
  // Marshall function inputs
  data_gpu = emlrt_marshallInGPU(
      emlrtRootTLSGlobal, prhs[0], (const char_T *)"data",
      (const char_T *)"double", false, 2, (void *)&dims[0], true);
  data = (real_T(*)[83328])emlrtGPUGetDataReadOnly(data_gpu);
  fs = emlrt_marshallIn(emlrtAliasP(prhs[1]), "fs");
  // Create GpuArrays for outputs
  coi_gpu = emlrtGPUCreateNumericArray((const char_T *)"double", false, 1,
                                       (void *)&b_dims[0]);
  coi = (real_T(*)[651])emlrtGPUGetData(coi_gpu);
  // Create GpuArrays for outputs
  f_gpu = emlrtGPUCreateNumericArray((const char_T *)"double", false, 1,
                                     (void *)&c_dims[0]);
  f = (real_T(*)[65])emlrtGPUGetData(f_gpu);
  // Create GpuArrays for outputs
  cwtres_gpu = emlrtGPUCreateNumericArray((const char_T *)"double", false, 3,
                                          (void *)&d_dims[0]);
  cwtres = (real_T(*)[5416320])emlrtGPUGetData(cwtres_gpu);
  // Invoke the target function
  cwtMultiAll(*data, fs, *cwtres, *f, *coi);
  // Marshall function outputs
  plhs[0] = emlrt_marshallOutGPU(cwtres_gpu);
  emlrtDestroyGPUArray(cwtres_gpu);
  if (nlhs > 1) {
    plhs[1] = emlrt_marshallOutGPU(f_gpu);
  }
  emlrtDestroyGPUArray(f_gpu);
  if (nlhs > 2) {
    plhs[2] = emlrt_marshallOutGPU(coi_gpu);
  }
  emlrtDestroyGPUArray(coi_gpu);
  // Destroy GPUArrays
  emlrtDestroyGPUArray(data_gpu);
}

// End of code generation (_coder_cwtMultiAll_api.cu)
