/**
 * @file methods/amf/init_rules/given_init.hpp
 * @author Ryan Curtin
 *
 * Initialization rule for alternating matrix factorization (AMF). This simple
 * initialization is performed by assigning a given matrix to W and H.
 *
 * mlpack is free software; you may redistribute it and/or modify it under the
 * terms of the 3-clause BSD license.  You should have received a copy of the
 * 3-clause BSD license along with mlpack.  If not, see
 * http://www.opensource.org/licenses/BSD-3-Clause for more information.
 */
#ifndef MLPACK_METHODS_AMF_INIT_RULES_GIVEN_INIT_HPP
#define MLPACK_METHODS_AMF_INIT_RULES_GIVEN_INIT_HPP

#include <mlpack/prereqs.hpp>

namespace mlpack {
namespace amf {

/**
 * This initialization rule for AMF simply fills the W and H matrices with the
 * matrices given to the constructor of this object.  Note that this object does
 * not use std::move() during the Initialize() method, so it can be reused for
 * multiple AMF objects, but will incur copies of the W and H matrices.
 */
class GivenInitialization
{
 public:
  // Empty constructor required for the InitializeRule template.
  GivenInitialization() : wIsGiven(false), hIsGiven(false) { }

  // Initialize the GivenInitialization object with the given matrices.
  GivenInitialization(const arma::mat& w, const arma::mat& h) :
    w(w), h(h), wIsGiven(true), hIsGiven(true) { }

  // Initialize the GivenInitialization object, taking control of the given
  // matrices.
  GivenInitialization(const arma::mat&& w, const arma::mat&& h) :
    w(std::move(w)),
    h(std::move(h)),
    wIsGiven(true),
    hIsGiven(true)
  { }

  // Initialize either H or W with the given matrix.
  GivenInitialization(const arma::mat& m, const bool whichMatrix = true)
  {
    if (whichMatrix)
    {
      w = m;
      wIsGiven = true;
      hIsGiven = false;
    }
    else
    {
      h = m;
      wIsGiven = false;
      hIsGiven = true;
    }
  }

  // Initialize either H or W, taking control of the given matrix.
  GivenInitialization(const arma::mat&& m, const bool whichMatrix = true)
  {
    if (whichMatrix)
    {
      w = std::move(m);
      wIsGiven = true;
      hIsGiven = false;
    }
    else
    {
      h = std::move(m);
      wIsGiven = false;
      hIsGiven = true;
    }
  }

  /**
   * Fill W and H with given matrices.
   *
   * @param V Input matrix.
   * @param r Rank of decomposition.
   * @param W W matrix, to be initialized to given matrix.
   * @param H H matrix, to be initialized to given matrix.
   */
  template<typename MatType>
  inline void Initialize(const MatType& V,
                         const size_t r,
                         arma::mat& W,
                         arma::mat& H)
  {
    // Make sure the initial W, H matrices are given
    if (!wIsGiven)
    {
      Log::Fatal << "Initial W matrix is not given!" << std::endl;
    }
    if (!hIsGiven)
    {
      Log::Fatal << "Initial H matrix is not given!" << std::endl;
    }

    // Make sure the initial W, H matrices have correct size.
    if (w.n_rows != V.n_rows)
    {
      Log::Fatal << "The number of rows in given W (" <<  w.n_rows
          << ") doesn't equal the number of rows in V (" << V.n_rows
          << ") !" << std::endl;
    }
    if (w.n_cols != r)
    {
      Log::Fatal << "The number of columns in given W (" <<  w.n_cols
          << ") doesn't equal the rank of factorization (" << r
          << ") !" << std::endl;
    }
    if (h.n_cols != V.n_cols)
    {
      Log::Fatal << "The number of columns in given H (" <<  h.n_cols
          << ") doesn't equal the number of columns in V (" << V.n_cols
          << ") !" << std::endl;
    }
    if (h.n_rows != r)
    {
      Log::Fatal << "The number of rows in given H (" <<  h.n_rows
          << ") doesn't equal the rank of factorization (" << r
          << ") !"<< std::endl;
    }

    // Initialize to the given matrices.
    W = w;
    H = h;
  }

  /**
   * Fill W or H with given matrix.
   *
   * @param V Input matrix.
   * @param r Rank of decomposition.
   * @param M W or H matrix, to be initialized to given matrix.
   * @param whichMatrix If true, initialize W. Otherwise, initialize H.
   */
  template<typename MatType>
  inline void InitializeOne(const MatType& V,
                            const size_t r,
                            arma::mat& M,
                            const bool whichMatrix = true)
  {
    if (whichMatrix)
    {
      // Make sure the initial W matrix is given.
      if (!wIsGiven)
      {
        Log::Fatal << "Initial W matrix is not given!" << std::endl;
      }

      // Make sure the initial W matrix has correct size.
      if (w.n_rows != V.n_rows)
      {
        Log::Fatal << "The number of rows in given W (" <<  w.n_rows
            << ") doesn't equal the number of rows in V (" << V.n_rows
            << ") !" << std::endl;
      }
      if (w.n_cols != r)
      {
        Log::Fatal << "The number of columns in given W (" <<  w.n_cols
            << ") doesn't equal the rank of factorization (" << r
            << ") !" << std::endl;
      }

      // Initialize W to the given matrix.
      M = w;
    }
    else
    {
      // Make sure the initial H matrix is given.
      if (!hIsGiven)
      {
        Log::Fatal << "Initial H matrix is not given!" << std::endl;
      }

      // Make sure the initial H matrix has correct size.
      if (h.n_cols != V.n_cols)
      {
        Log::Fatal << "The number of columns in given H (" <<  h.n_cols
            << ") doesn't equal the number of columns in V (" << V.n_cols
            << ") !" << std::endl;
      }
      if (h.n_rows != r)
      {
        Log::Fatal << "The number of rows in given H (" <<  h.n_rows
            << ") doesn't equal the rank of factorization (" << r
            << ") !"<< std::endl;
      }

      // Initialize H to the given matrix.
      M = h;
    }
  }

  //! Serialize the object (in this case, there is nothing to serialize).
  template<typename Archive>
  void serialize(Archive& ar, const unsigned int /* version */)
  {
    ar & CEREAL_NVP(w);
    ar & CEREAL_NVP(h);
  }

 private:
  //! The W matrix for initialization.
  arma::mat w;
  //! The H matrix for initialization.
  arma::mat h;
  //! Whether initial W is given.
  bool wIsGiven;
  //! Whether initial H is given.
  bool hIsGiven;
};

} // namespace amf
} // namespace mlpack

#endif
