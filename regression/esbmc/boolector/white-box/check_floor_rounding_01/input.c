#include <dsverifier.h>

digital_system ds = {
	.b = { -1.553, 3.119, -1.566 },
	.b_size = 3,
	.a = { 1.00000000, 0.0387300, -0.96 },
	.a_size = 3,
	.sample_time = 0.005
};

implementation impl = {
	.int_bits = 15,
	.frac_bits = 4,
	.min = -6.0,
	.max = 6.0
};

int unit_test(){

	initialization();

	overflow_mode = WRAPAROUND;
	rounding_mode = FLOOR;

	fxp_t a_fxp[ds.a_size];
	fxp_t b_fxp[ds.b_size];

	/* quantize the numerator using fxp */
	fxp_double_to_fxp_array(ds.b, b_fxp, ds.b_size);

	/* quantize the denominator using fxp */
	fxp_double_to_fxp_array(ds.a, a_fxp, ds.a_size);

	double b_qtz[ds.b_size];
	double a_qtz[ds.a_size];

	fxp_to_double_array(b_qtz, b_fxp, ds.b_size);
	fxp_to_double_array(a_qtz, a_fxp, ds.a_size);

	__DSVERIFIER_assert(b_qtz[0] == -1.5625);
	__DSVERIFIER_assert(b_qtz[1] == 3.06250);
	__DSVERIFIER_assert(b_qtz[2] == -1.6250);

	__DSVERIFIER_assert(a_qtz[0] == 1.0);
	__DSVERIFIER_assert(a_qtz[1] == 0.0);
	__DSVERIFIER_assert(a_qtz[2] == -1.0);

}
