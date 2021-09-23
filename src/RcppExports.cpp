// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// euclid
double euclid(NumericVector a, NumericVector b);
RcppExport SEXP _RavenR_euclid(SEXP aSEXP, SEXP bSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type a(aSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type b(bSEXP);
    rcpp_result_gen = Rcpp::wrap(euclid(a, b));
    return rcpp_result_gen;
END_RCPP
}
// centroid
NumericVector centroid(NumericVector b);
RcppExport SEXP _RavenR_centroid(SEXP bSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type b(bSEXP);
    rcpp_result_gen = Rcpp::wrap(centroid(b));
    return rcpp_result_gen;
END_RCPP
}
// intersect_line_rectangle
NumericVector intersect_line_rectangle(NumericVector p1, NumericVector p2, NumericVector b);
RcppExport SEXP _RavenR_intersect_line_rectangle(SEXP p1SEXP, SEXP p2SEXP, SEXP bSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type p1(p1SEXP);
    Rcpp::traits::input_parameter< NumericVector >::type p2(p2SEXP);
    Rcpp::traits::input_parameter< NumericVector >::type b(bSEXP);
    rcpp_result_gen = Rcpp::wrap(intersect_line_rectangle(p1, p2, b));
    return rcpp_result_gen;
END_RCPP
}
// repel_boxes
DataFrame repel_boxes(NumericMatrix data_points, double point_padding_x, double point_padding_y, NumericMatrix boxes, NumericVector xlim, NumericVector ylim, double force, int maxiter, std::string direction);
RcppExport SEXP _RavenR_repel_boxes(SEXP data_pointsSEXP, SEXP point_padding_xSEXP, SEXP point_padding_ySEXP, SEXP boxesSEXP, SEXP xlimSEXP, SEXP ylimSEXP, SEXP forceSEXP, SEXP maxiterSEXP, SEXP directionSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type data_points(data_pointsSEXP);
    Rcpp::traits::input_parameter< double >::type point_padding_x(point_padding_xSEXP);
    Rcpp::traits::input_parameter< double >::type point_padding_y(point_padding_ySEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type boxes(boxesSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type xlim(xlimSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type ylim(ylimSEXP);
    Rcpp::traits::input_parameter< double >::type force(forceSEXP);
    Rcpp::traits::input_parameter< int >::type maxiter(maxiterSEXP);
    Rcpp::traits::input_parameter< std::string >::type direction(directionSEXP);
    rcpp_result_gen = Rcpp::wrap(repel_boxes(data_points, point_padding_x, point_padding_y, boxes, xlim, ylim, force, maxiter, direction));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_RavenR_euclid", (DL_FUNC) &_RavenR_euclid, 2},
    {"_RavenR_centroid", (DL_FUNC) &_RavenR_centroid, 1},
    {"_RavenR_intersect_line_rectangle", (DL_FUNC) &_RavenR_intersect_line_rectangle, 3},
    {"_RavenR_repel_boxes", (DL_FUNC) &_RavenR_repel_boxes, 9},
    {NULL, NULL, 0}
};

RcppExport void R_init_RavenR(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}