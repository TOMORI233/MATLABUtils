//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_cwtMultiAll_mex.cu
//
// Code generation for function '_coder_cwtMultiAll_mex'
//

// Include files
#include "_coder_cwtMultiAll_mex.h"
#include "_coder_cwtMultiAll_api.h"
#include "cwtMultiAll_data.h"
#include "cwtMultiAll_initialize.h"
#include "cwtMultiAll_terminate.h"
#include "rt_nonfinite.h"

// Function Definitions
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&cwtMultiAll_atexit);
  // Module initialization.
  cwtMultiAll_initialize();
  // Dispatch the entry-point.
  unsafe_cwtMultiAll_mexFunction(nlhs, plhs, nrhs, prhs);
  // Module termination.
  cwtMultiAll_terminate();
}

emlrtCTX mexFunctionCreateRootTLS()
{
  emlrtCreateRootTLSR2021a(&emlrtRootTLSGlobal, &emlrtContextGlobal, nullptr, 1,
                           nullptr);
  return emlrtRootTLSGlobal;
}

void unsafe_cwtMultiAll_mexFunction(int32_T nlhs, mxArray *plhs[3],
                                    int32_T nrhs, const mxArray *prhs[2])
{
  const mxArray *outputs[3];
  int32_T b_nlhs;
  // Check for proper number of arguments.
  if (nrhs != 2) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal, "EMLRT:runTime:WrongNumberOfInputs",
                        5, 12, 2, 4, 11, "cwtMultiAll");
  }
  if (nlhs > 3) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal,
                        "EMLRT:runTime:TooManyOutputArguments", 3, 4, 11,
                        "cwtMultiAll");
  }
  // Call the function.
  cwtMultiAll_api(prhs, nlhs, outputs);
  // Copy over outputs to the caller.
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }
  emlrtReturnArrays(b_nlhs, &plhs[0], &outputs[0]);
}

// End of code generation (_coder_cwtMultiAll_mex.cu)
