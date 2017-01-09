#!/usr/bin/env python
"""
arma_numpy.pyx: Armadillo/numpy interface functionality.

This file defines a number of functions useful for converting between Armadillo
and numpy objects without actually copying memory.

mlpack is free software; you may redistribute it and/or modify it under the
terms of the 3-clause BSD license.  You should have received a copy of the
3-clause BSD license along with mlpack.  If not, see
http://www.opensource.org/licenses/BSD-3-Clause for more information.
"""
cimport cython
cimport numpy
import numpy

numpy.import_array()

cimport arma

cdef extern from "numpy/arrayobject.h":
  void PyArray_ENABLEFLAGS(numpy.ndarray arr, int flags)

cdef extern from "<mlpack/bindings/python/mlpack/arma_util.hpp>":
  void SetMemState[T](T& m, int state)

cdef arma.Mat[double]* numpy_to_mat_d(numpy.ndarray[numpy.double_t, ndim=2] X):
  """
  Convert a numpy ndarray to a matrix.
  """
  if not (X.flags.c_contiguous or X.flags.owndata):
    # If needed, make a copy where we own the memory.
    X = X.copy(order="C")

  cdef arma.Mat[double]* m = new arma.Mat[double](<double*> X.data, X.shape[1], X.shape[0], False, True)
  return m

cdef arma.Mat[size_t]* numpy_to_mat_s(numpy.ndarray[numpy.uintp_t, ndim=2] X):
  """
  Convert a numpy ndarray to a matrix.
  """
  if not (X.flags.c_contiguous or X.flags.owndata):
    # If needed, make a copy where we own the memory.
    X = X.copy(order="C")

  cdef arma.Mat[size_t]* m = new arma.Mat[size_t](<size_t*> X.data, X.shape[1],
      X.shape[0], False, True)
  return m

cdef numpy.ndarray[numpy.double_t, ndim=2] mat_to_numpy_d(arma.Mat[double]& X):
  """
  Convert an Armadillo object to a numpy ndarray.
  """
  # Extract dimensions.
  cdef numpy.npy_intp dims[2]
  dims[0] = <numpy.npy_intp> X.n_cols
  dims[1] = <numpy.npy_intp> X.n_rows
  cdef numpy.ndarray[numpy.double_t, ndim=2] output = \
      numpy.PyArray_SimpleNewFromData(2, &dims[0], numpy.NPY_DOUBLE, X.memptr())

  # Transfer memory ownership.
  SetMemState[arma.Mat[double]](X, 1)
  PyArray_ENABLEFLAGS(output, numpy.NPY_OWNDATA)

  return output

cdef numpy.ndarray[numpy.uintp_t, ndim=2] mat_to_numpy_s(arma.Mat[size_t]& X):
  """
  Convert an Armadillo object to a numpy ndarray.
  """
  # Extract dimensions.
  cdef numpy.npy_intp dims[2]
  dims[0] = <numpy.npy_intp> X.n_cols
  dims[1] = <numpy.npy_intp> X.n_rows
  cdef numpy.ndarray[numpy.uintp_t, ndim=2] output = \
      numpy.PyArray_SimpleNewFromData(2, &dims[0], numpy.NPY_UINTP, X.memptr())

  # Transfer memory ownership.
  SetMemState[arma.Mat[size_t]](X, 1)
  PyArray_ENABLEFLAGS(output, numpy.NPY_OWNDATA)

  return output

cdef arma.Row[double]* numpy_to_row_d(numpy.ndarray[numpy.double_t, ndim=1] X):
  """
  Convert a numpy one-dimensional ndarray to a row.
  """
  if not (X.flags.c_contiguous or X.flags.owndata):
    # If needed, make a copy where we own the memory.
    X = X.copy(order="C")

  cdef arma.Row[double]* m = new arma.Row[double](<double*> X.data, X.shape[0],
      False, True)
  return m

cdef arma.Row[size_t]* numpy_to_row_s(numpy.ndarray[numpy.uintp_t, ndim=1] X):
  """
  Convert a numpy one-dimensional ndarray to a row.
  """
  if not (X.flags.c_contiguous or X.flags.owndata):
    # If needed, make a copy where we own the memory.
    X = X.copy(order="C")

  cdef arma.Row[size_t]* m = new arma.Row[size_t](<size_t*> X.data, X.shape[0],
      False, True)
  return m

cdef numpy.ndarray[numpy.double_t, ndim=1] row_to_numpy_d(arma.Row[double]& X):
  """
  Convert an Armadillo row vector to a one-dimensional numpy ndarray.
  """
  # Extract dimensions.
  cdef numpy.npy_intp dim = <numpy.npy_intp> X.n_elem
  cdef numpy.ndarray[numpy.double_t, ndim=1] output = \
      numpy.PyArray_SimpleNewFromData(1, &dim, numpy.NPY_DOUBLE, X.memptr())

  # Transfer memory ownership.
  SetMemState[arma.Row[double]](X, 1)
  PyArray_ENABLEFLAGS(output, numpy.NPY_OWNDATA)

  return output

cdef numpy.ndarray[numpy.uintp_t, ndim=1] row_to_numpy_s(arma.Row[size_t]& X):
  """
  Convert an Armadillo row vector to a one-dimensional numpy ndarray.
  """
  # Extract dimensions.
  cdef numpy.npy_intp dim = <numpy.npy_intp> X.n_elem
  cdef numpy.ndarray[numpy.uintp_t, ndim=1] output = \
      numpy.PyArray_SimpleNewFromData(1, &dim, numpy.NPY_UINTP, X.memptr())

  # Transfer memory ownership.
  SetMemState[arma.Row[size_t]](X, 1)
  PyArray_ENABLEFLAGS(output, numpy.NPY_OWNDATA)

  return output

cdef arma.Col[double]* numpy_to_col_d(numpy.ndarray[numpy.double_t, ndim=1] X):
  """
  Convert a numpy one-dimensional ndarray to a column vector.
  """
  if not (X.flags.c_contiguous or X.flags.owndata):
    # If needed, make a copy where we own the memory.
    X = X.copy(order="C")

  cdef arma.Col[double]* m = new arma.Col[double](<double*> X.data, X.shape[0],
      False, True)
  return m

cdef arma.Col[size_t]* numpy_to_col_s(numpy.ndarray[numpy.uintp_t, ndim=1] X):
  """
  Convert a numpy one-dimensional ndarray to a column vector.
  """
  if not (X.flags.c_contiguous or X.flags.owndata):
    # If needed, make a copy where we own the memory.
    X = X.copy(order="C")

  cdef arma.Col[size_t]* m = new arma.Col[size_t](<size_t*> X.data, X.shape[0],
      False, True)
  return m

cdef numpy.ndarray[numpy.double_t, ndim=1] col_to_numpy_d(arma.Col[double]& X):
  """
  Convert an Armadillo column vector to a one-dimensional numpy ndarray.
  """
  # Extract dimension.
  cdef numpy.npy_intp dim = <numpy.npy_intp> X.n_elem
  cdef numpy.ndarray[numpy.double_t, ndim=1] output = \
      numpy.PyArray_SimpleNewFromData(1, &dim, numpy.NPY_DOUBLE, X.memptr())

  # Transfer memory ownership.
  SetMemState[arma.Col[double]](X, 1)
  PyArray_ENABLEFLAGS(output, numpy.NPY_OWNDATA)

  return output

cdef numpy.ndarray[numpy.uintp_t, ndim=1] col_to_numpy_s(arma.Col[size_t]& X):
  """
  Convert an Armadillo column vector to a one-dimensional numpy ndarray.
  """
  # Extract dimension.
  cdef numpy.npy_intp dim = <numpy.npy_intp> X.n_elem
  cdef numpy.ndarray[numpy.uintp_t, ndim=1] output = \
      numpy.PyArray_SimpleNewFromData(1, &dim, numpy.NPY_UINTP, X.memptr())

  # Transfer memory ownership.
  SetMemState[arma.Col[size_t]](X, 1)
  PyArray_ENABLEFLAGS(output, numpy.NPY_OWNDATA)

  return output
