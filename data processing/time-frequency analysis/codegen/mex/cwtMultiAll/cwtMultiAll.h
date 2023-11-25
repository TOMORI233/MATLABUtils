//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// cwtMultiAll.h
//
// Code generation for function 'cwtMultiAll'
//

#pragma once

// Include files
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

// Custom Header Code

#ifdef __CUDA_ARCH__
#undef printf
#endif

// Function Declarations
void cwtMultiAll(const real_T data[50010], real_T fs, creal_T cwtres[4750950],
                 real_T f[95], real_T coi[5001]);

// End of code generation (cwtMultiAll.h)
