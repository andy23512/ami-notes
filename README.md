# ami-notes

## Formula References

### Tricosine interpolation

## References

### Identity interpolation

Code: [ami/shaders.interpolation.identity.js at master · FNNDSC/ami](https://github.com/FNNDSC/ami/blob/master/src/shaders/interpolation/shaders.interpolation.identity.js)

### Trilinear interpolation

Code: [ami/shaders.interpolation.trilinear.js at master · FNNDSC/ami](https://github.com/FNNDSC/ami/blob/master/src/shaders/interpolation/shaders.interpolation.trilinear.js)
Formula: [Trilinear interpolation - Wikipedia](https://en.wikipedia.org/wiki/Trilinear_interpolation)

### Tricosine interpolation

Code: [procedural-planet/material.js at master · prolearner/procedural-planet](https://github.com/prolearner/procedural-planet/blob/master/shader/material.js)
Formula: [Digital Filtering And Compression In Image Processing And Volume Rendering](https://people.redhat.com/jnovy/files/dissertation-jnovy.pdf)

### Tricubic interpolation

Code: [sharevol/index.html at master · OKaluza/sharevol](https://github.com/OKaluza/sharevol/blob/master/index.html#L317)
Formula: [Efficient GPU-Based Texture Interpolation using Uniform B-Splines](http://mate.tue.nl/mate/pdfs/10318.pdf)

## GLSL knowledge

### Variable

- `int`: integer
- `float`: float

#### Vectors

(n=2,3 or 4)
Can use `.x`, `.y`, `.z`, `.w` to access each component
`.xyz`: swizzling

- `vecn`: n-d vector of single-precision floating-point numbers
  `vecn [variable name] = vecn([value1], [value2], ..., [valuen]);`
- `ivecn`: n-d vector of signed integers
  `ivecn [variable name] = ivecn([value1], [value2], ..., [valuen]);`

### Qualifiers

- `varying`: The qualifier varying are used to define variables that can pass values from the vertex shader to the fragment shader.
- `uniform`: The qualifier uniform defines a read-only variable that remains the same over an extended period of time. The same variables can be defined in both the vertex and fragment shader.

### Function

```
[return type] [function name]([function parameters]) {
  [function content]
}
```

#### Parameter Qualifiers

- `in`: variable value is copied to the function. This is the default value.
- `out`: function cannot read the variable but can write back to the variable.
- `inout`: function can both read from and write to the variable.

### Built-in Functions

#### Trigonometric

- `sin(a)`: trigonometric sine function
- `cos(a)`: trigonometric cosine function

#### Exponential

- `pow(a, b)`: return a^b. Results are undefined if α < 0 or α = 0 and &beta <= 0.

#### Common

- `floor(a)`: returns the nearest integer less than or equal to a
  (if input is vector, will do this component-wise)
- `max(a, b)`: returns the larger of the two arguments
  (if input is vector, will do this component-wise)
- `min(a, b)`: returns the smaller of the two arguments
  (if input is vector, will do this component-wise)
- `mod(a, b)`: equivalent to a%b in Java
- `fract(a)`: compute the fractional part of the argument
- `mix(a, b, c)`: returns the linear blend of a and b. i.e. `a * (1 - c) + b * c`

#### Geometric

- `length(a)`: returns the length of a vector a
- `dot(a, b)`: returns the dot product of a and b
- `normalize(a)`: returns the normalized vector of α. i.e. α with a length of 1.

### operators

- `vec +- vec`: component-wise add/minus
- `float * vec`: component-wise multiply
