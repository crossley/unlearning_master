float pos(float val);
float cap(float val);
float randn(float mean, float variance);
void vadd(float *source_a, float *source_b, float *dest, int size);
void vsdiv(float *source, float scalar, float *dest, int size);
void dotpr(float *source_a, float *source_b, float *dest, int size);
void vsort_desc(float *source, int size);
int compare_floats_desc(const void *a, const void *b);
void maxmgvi(float *source, float *max_dest, int *max_index, int size);