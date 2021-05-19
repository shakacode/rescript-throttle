# rescript-throttle-react

[![version](https://img.shields.io/npm/v/rescript-throttle-react.svg?style=flat-square)](https://www.npmjs.com/package/rescript-throttle-react)
[![license](https://img.shields.io/npm/l/rescript-throttle-react.svg?style=flat-square)](https://www.npmjs.com/package/rescript-throttle-react)
[![build](https://github.com/shakacode/rescript-throttle/actions/workflows/ci.yml/badge.svg)](https://github.com/shakacode/rescript-throttle/actions/workflows/ci.yml)

Throttle hooks for `@rescript/react`.

## Installation

```shell
# yarn
yarn add rescript-throttle-react
# or npm
npm install --save rescript-throttle-react
```

Then add it to `bsconfig.json`:

```json
"bs-dependencies": [
  "rescript-throttle-react"
]
```

## Usage

```rescript
// With default timeout (100ms)
let fn = ReactThrottle.useThrottled(fn)

// With configured timeout
let fn = ReactThrottle.useThrottled(~wait=250, fn)

// Controlled hook
let fn = ReactThrottle.useControlled(fn)
```

See [`rescript-throttle`](https://www.npmjs.com/package/rescript-throttle) for more details.

## License

MIT.
