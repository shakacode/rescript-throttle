@@warning("-20-21")

open Jest

module Fn = {
  let make = (~mockFn, ~throttleFn) => {
    mockFn->Obj.magic->throttleFn->Obj.magic->MockJs.fn
  }
}

module Timeout = {
  let default = 100 + 10
  let make = timeout => timeout + 10
}

describe("Throttle", () => {
  open Expect

  test("is called immediately", () => {
    let mockFn = JestJs.inferred_fn()
    let fn = Fn.make(~mockFn, ~throttleFn=Throttle.make(_))

    fn("1")

    expect(mockFn->MockJs.calls)->toEqual(["1"])
  })

  testAsync("called once after timeout", finish => {
    let mockFn = JestJs.inferred_fn()
    let fn = Fn.make(~mockFn, ~throttleFn=Throttle.make(_))

    fn()

    let fx = () => expect(mockFn->MockJs.calls)->toEqual([()])->finish

    fx->setTimeout(Timeout.default)->ignore
  })

  testAsync("called once with provided argument after timeout", finish => {
    let mockFn = JestJs.inferred_fn()
    let fn = Fn.make(~mockFn, ~throttleFn=Throttle.make(_))

    fn("1")

    let fx = () => expect(mockFn->MockJs.calls)->toEqual(["1"])->finish

    fx->setTimeout(Timeout.default)->ignore
  })

  testAsync("called twice with the first and the latest arguments", finish => {
    let mockFn = JestJs.inferred_fn()
    let fn = Fn.make(~mockFn, ~throttleFn=Throttle.make(_))

    fn("1")
    fn("2")
    fn("3")
    fn("4")
    fn("5")

    let fx = () => expect(mockFn->MockJs.calls)->toEqual(["1", "5"])->finish

    fx->setTimeout(Timeout.default)->ignore
  })

  testAsync("called once with provided timeout", finish => {
    let timeout = 500

    let mockFn = JestJs.inferred_fn()
    let fn = Fn.make(~mockFn, ~throttleFn=Throttle.make(~wait=timeout, _))

    fn("1")

    let fx = () => expect(mockFn->MockJs.calls)->toEqual(["1"])->finish

    fx->setTimeout(timeout->Timeout.make)->ignore
  })

  testAsync("can be scheduled", finish => {
    let timeout = 500

    let mockFn = JestJs.inferred_fn()
    let fn: Throttle.throttled<string> = Fn.make(
      ~mockFn,
      ~throttleFn=Throttle.makeControlled(~wait=timeout, _),
    )

    fn.schedule("1")

    let fx = () => expect(mockFn->MockJs.calls)->toEqual(["1"])->finish

    fx->setTimeout(timeout->Timeout.make)->ignore
  })

  test("can be called immediately", () => {
    let mockFn = JestJs.inferred_fn()
    let fn: Throttle.throttled<string> = Fn.make(~mockFn, ~throttleFn=Throttle.makeControlled(_))

    fn.invoke("1")

    expect(mockFn->MockJs.calls)->toEqual(["1"])
  })

  testAsync("called before immediate invocation", finish => {
    let mockFn = JestJs.inferred_fn()
    let fn: Throttle.throttled<string> = Fn.make(~mockFn, ~throttleFn=Throttle.makeControlled(_))

    fn.schedule("1")
    fn.invoke("2")

    let fx = () => expect(mockFn->MockJs.calls)->toEqual(["1", "2"])->finish

    fx->setTimeout(Timeout.default)->ignore
  })

  testAsync("can be canceled", finish => {
    let mockFn = JestJs.inferred_fn()
    let fn: Throttle.throttled<string> = Fn.make(~mockFn, ~throttleFn=Throttle.makeControlled(_))

    fn.schedule("1")
    fn.schedule("2")
    fn.cancel()

    let fx = () => expect(mockFn->MockJs.calls)->toEqual(["1"])->finish

    fx->setTimeout(Timeout.default)->ignore
  })

  test("reports scheduled true when invocation is scheduled", () => {
    let mockFn = JestJs.inferred_fn()
    let fn: Throttle.throttled<string> = Fn.make(~mockFn, ~throttleFn=Throttle.makeControlled(_))

    fn.schedule("1")

    expect(fn.scheduled())->toEqual(true)
  })

  test("reports scheduled false when invocation is not scheduled", () => {
    let mockFn = JestJs.inferred_fn()
    let fn: Throttle.throttled<string> = Fn.make(~mockFn, ~throttleFn=Throttle.makeControlled(_))

    expect(fn.scheduled())->toEqual(false)
  })
})
