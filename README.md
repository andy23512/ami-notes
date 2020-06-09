# ami-notes

## Code References

### interpolation-identity

[ami/shaders.interpolation.identity.js at master · FNNDSC/ami](https://github.com/FNNDSC/ami/blob/master/src/shaders/interpolation/shaders.interpolation.identity.js)

### interpolation-trilinear

[ami/shaders.interpolation.trilinear.js at master · FNNDSC/ami](https://github.com/FNNDSC/ami/blob/master/src/shaders/interpolation/shaders.interpolation.trilinear.js)

## GLSL knowledge

### Variable

- `int`: integer

#### Vectors

(n=2,3 or 4)
Can use `.x`, `.y`, `.z`, `.w` to access each component

- `vecn`: n-d vector of single-precision floating-point numbers
  `vecn [variable name] = vecn([value1], [value2], ..., [valuen]);`
- `ivecn`: n-d vector of signed integers
  `ivecn [variable name] = ivecn([value1], [value2], ..., [valuen]);`

### Function

#### Parameter Qualifiers

- `in`: variable value is copied to the function. This is the default value.
- `out`: function cannot read the variable but can write back to the variable.
- `inout`: function can both read from and write to the variable.

### Built-in Functions

- `floor`: returns the nearest integer less than or equal to α
  (if input is vector, will do this component-wise)
- `max`: returns the larger of the two arguments
  (if input is vector, will do this component-wise)
- `max`: returns the smaller of the two arguments
  (if input is vector, will do this component-wise)
- `length`: returns the length of a vector α

### operators

- `vec +- vec`: component-wise add/minus
- `float * vec`: component-wise multiply
