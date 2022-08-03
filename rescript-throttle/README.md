# rescript-throttle

[![version](https://img.shields.io/npm/v/rescript-throttle.svg?style=flat-square)](https://www.npmjs.com/package/rescript-throttle)
[![license](https://img.shields.io/npm/l/rescript-throttle.svg?style=flat-square)](https://www.npmjs.com/package/rescript-throttle)
[![build](https://github.com/shakacode/rescript-throttle/actions/workflows/ci.yml/badge.svg)](https://github.com/shakacode/rescript-throttle/actions/workflows/ci.yml)

Throttle for ReScript. For usage with React, see [`rescript-throttle-react`](https://www.npmjs.com/package/rescript-throttle-react).

> ### ShakaCode
> If you are looking for help with the development and optimization of your project, [ShakaCode](https://www.shakacode.com) can help you to take the reliability and performance of your app to the next level.
>
> If you are a developer interested in working on ReScript / TypeScript / Rust / Ruby on Rails projects, [we're hiring](https://www.shakacode.com/career/)!

## Installation

```sh
# yarn
yarn add rescript-throttle
# or npm
npm install --save rescript-throttle
```

Then add it to `bsconfig.json`:

```json
"bs-dependencies": [
  "rescript-throttle"
]
```

## Usage

```rescript
// Pass function you want to throttle
let fn = Throttle.make(fn)

// You can configure timeout. Default is 100ms.
let fn = Throttle.make(~wait=500, fn)

// This call is throttled
fn()
```

Also, you can get more control over the throttling:

```rescript
let fn = Throttle.makeControlled(fn)

// Schedule invocation
fn.schedule()

// Cancel invocation
fn.cancel()

// Check if invocation is scheduled
fn.scheduled() // => false

// Invoke immediately
fn.invoke()
```

Note that if you invoke immediately all scheduled invocations (if any) are canceled.

## Caveats
#### I need to pass multiple arguments to throttled function
Pack those in a tuple:

```rescript
let fn = Throttle.make(((one, two)) => /* use `one` & `two` */)
fn(("one", "two"))
```

#### It doesn't work, function is not throttled
The result of `Throttle.make(fn)` call **must** be bound to a variable (or a record property, a ref etc) for later invocations. I.e. don't inline `Throttle.make(fn)` calls in `React.useEffect` and such, this won't work since throttled function will be re-created on every re-render:

```rescript
@react.component
let make = () => {
  let (state, dispatch) = reducer->React.useReducer(initialState)

  // Don't do this
  let fn = Throttle.make(() => DoStuff->dispatch)

  React.useEffect(
    () => {
      fn()
      None
    },
  )
}
```

## License

MIT.
