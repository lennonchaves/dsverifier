#include <dsverifier.h>

int unit_test(){
   double a[3] = { 1.0, -1.9, 0.8925 };
   double out[3];
   generate_delta_coefficients(a, out, 3, 0.1);
   assert((0.009 < out[0]) && (out[0] < 0.011));
   assert((0.009 < out[1]) && (out[1] < 0.011));
   assert((-0.0073 > out[2]) && (out[2] > -0.0075));
   return 0;
}
