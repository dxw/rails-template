import resolve from '@rollup/plugin-node-resolve'
import commonjs from '@rollup/plugin-commonjs';

import { babel } from '@rollup/plugin-babel';

export default {
  input: 'app/javascript/application.js',
  output: {
    file: 'app/assets/builds/application.js',
    format: 'iife',
    inlineDynamicImports: true,
    sourcemap: true,
  },
  plugins: [
    commonjs(),
    babel({
      babelHelpers: 'runtime',
      exclude: 'node_modules/**',
      presets: [
        [
          '@babel/preset-env', {
            'useBuiltIns': 'usage',
            'corejs': '3'
          }
        ]
      ],
      plugins: ['@babel/plugin-transform-runtime']
    }),
    resolve(),
  ]
}
