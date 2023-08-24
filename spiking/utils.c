#if defined(_MSC_VER)
#include <intrin.h>
#elif defined(__GNUC__) && (defined(__x86_64__) || defined(__i386__))
#include <x86intrin.h>
#endif
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

float pos(float val) {
    return val < 0 ? 0 : val;
}

float cap(float val) {
    if(val < 0.0) val = 0.0;
    if(val > 1.0) val = 1.0;
    
    return val;
}

float randn(float mu, float sigma) {
    float uni_noise = (float) rand()/RAND_MAX;
	float normal_noise = mu - (sigma*sqrt(3.0)/3.14159)*(logf(1.0-uni_noise) - logf(uni_noise));
	return normal_noise;
}

/*
Add together the values in source_a with source_b and store the result in dest
*/

void vadd(float *source_a, float *source_b, float *dest, int size) {
	int i;
	for (i = 0; i < size/4 * 4; i += 4) {
		__m128 va = _mm_loadu_ps(source_a + i);
		__m128 vb = _mm_loadu_ps(source_b + i);
		_mm_storeu_ps(dest + i, _mm_add_ps(va, vb));
	}

	for ( ; i < size; i ++) {
		dest[i] = source_a[i] + source_b[i];
	}
}

/*
Divide all values in source by scalar and store the result in dest
*/

void vsdiv(float *source, float scalar, float *dest, int size) {
	int i; 
	for (i = 0; i < size/4 * 4; i += 4) {
		__m128 vsource = _mm_loadu_ps(source + i);
		__m128 vscalar = _mm_set1_ps(scalar);
		_mm_storeu_ps(dest + i, _mm_div_ps(vsource, vscalar));
	}

	for ( ; i < size; i++) {
		dest[i] = source[i]/scalar;
	}
}

/*
Compute the dot product of source_a and source_b and store the result in dest
*/

void dotpr(float *source_a, float *source_b, float *dest, int size) {
	__m128 vsum = _mm_setzero_ps();
	int i;
	for (i = 0; i < size/4 * 4; i += 4) {
		__m128 va = _mm_loadu_ps(source_a + i);
		__m128 vb = _mm_loadu_ps(source_b + i);
		vsum = _mm_add_ps(vsum, _mm_mul_ps(va, vb));
	}
	float vsum_array[4];
	_mm_storeu_ps(vsum_array, vsum);
	*dest = vsum_array[0] + vsum_array[1] + vsum_array[2] + vsum_array[3];

	for ( ;i < size; i ++) {
		*dest += source_a[i] * source_b[i];
	}
}

/* 
Comparision function for floats
Returns:
	1 if a < b
	0 if a == b
   -1 if a > b
*/

int compare_floats_desc (const void *a, const void *b) {
  const float *fa = (const float *) a;
  const float *fb = (const float *) b;

  return (*fa < *fb) - (*fa > *fb);
}

/* 
Sort the values in source in descending order
*/

void vsort_desc(float *source, int size) {
	qsort(source, size, sizeof(float), compare_floats_desc);
}

/* 
Find the max value of a float array
Store the result in max_dest
Store the index in max_index
*/

void maxmgvi(float *source, float *max_dest, int *max_index, int size) {
	*max_dest = source[0];
	*max_index = 0;
	
	for (int i = 1; i < size; i++) {
		if (abs(source[i]) > abs(*max_dest)) {
			*max_dest = abs(source[i]);
			*max_index = i;
		}
	}
}