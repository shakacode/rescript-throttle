open Jest

describe("Throttle", () => {
  open Expect

  test("is called immediately", () => {
    let mockFn = JestJs.fn(_ => ())
    let fn = mockFn->Obj.magic->Throttle.make

    MockJs.fn(fn->Obj.magic, "1")->ignore

    expect(mockFn->MockJs.calls) |> toEqual(["1"])
  })

  testAsync("called once after timeout", finish => {
    let mockFn = JestJs.fn(_ => ())
    let fn = mockFn->Obj.magic->Throttle.make

    MockJs.fn(fn->Obj.magic, ())->ignore

    Js.Global.setTimeout(() => expect(mockFn->MockJs.calls)->toEqual([()], _)->finish, 110)->ignore
  })

  testAsync("called once with provided argument after timeout", finish => {
    let mockFn = JestJs.fn(_ => ())
    let fn = mockFn->Obj.magic->Throttle.make

    MockJs.fn(fn->Obj.magic, "1")->ignore

    Js.Global.setTimeout(() => expect(mockFn->MockJs.calls)->toEqual(["1"], _)->finish, 110)->ignore
  })

  testAsync("called twice with the first and the latest arguments", finish => {
    let mockFn = JestJs.fn(_ => ())
    let fn = mockFn->Obj.magic->Throttle.make

    MockJs.fn(fn->Obj.magic, "1")->ignore
    MockJs.fn(fn->Obj.magic, "2")->ignore
    MockJs.fn(fn->Obj.magic, "3")->ignore
    MockJs.fn(fn->Obj.magic, "4")->ignore
    MockJs.fn(fn->Obj.magic, "5")->ignore

    Js.Global.setTimeout(
      () => expect(mockFn->MockJs.calls)->toEqual(["1", "5"], _)->finish,
      110,
    )->ignore
  })

  testAsync("called once with provided timeout", finish => {
    let mockFn = JestJs.fn(_ => ())
    let fn = mockFn->Obj.magic->Throttle.make(~wait=500, _)

    MockJs.fn(fn->Obj.magic, "1")->ignore

    Js.Global.setTimeout(
      () => expect(mockFn->MockJs.calls)->toEqual(["1"], _) |> finish,
      510,
    )->ignore
  })

  testAsync("can be scheduled", finish => {
    let mockFn = JestJs.fn(_ => ())
    let fn = mockFn |> Obj.magic |> Throttle.makeControlled(~wait=500)

    MockJs.fn(fn.schedule |> Obj.magic, "1") |> ignore

    510
    |> Js.Global.setTimeout(() => expect(mockFn |> MockJs.calls) |> toEqual(["1"]) |> finish)
    |> ignore
  })

  test("can be called immediately", () => {
    let mockFn = JestJs.fn(_ => ())
    let fn = mockFn |> Obj.magic |> Throttle.makeControlled

    MockJs.fn(fn.invoke |> Obj.magic, "1") |> ignore

    expect(mockFn |> MockJs.calls) |> toEqual(["1"])
  })

  testAsync("called before immediate invocation", finish => {
    let mockFn = JestJs.fn(_ => ())
    let fn = mockFn |> Obj.magic |> Throttle.makeControlled

    MockJs.fn(fn.schedule |> Obj.magic, "1") |> ignore
    MockJs.fn(fn.invoke |> Obj.magic, "2") |> ignore

    110
    |> Js.Global.setTimeout(() => expect(mockFn |> MockJs.calls) |> toEqual(["1", "2"]) |> finish)
    |> ignore
  })

  testAsync("can be canceled", finish => {
    let mockFn = JestJs.fn(_ => ())
    let fn = mockFn |> Obj.magic |> Throttle.makeControlled

    MockJs.fn(fn.schedule |> Obj.magic, "1") |> ignore
    MockJs.fn(fn.schedule |> Obj.magic, "2") |> ignore
    fn.cancel()

    110
    |> Js.Global.setTimeout(() => expect(mockFn |> MockJs.calls) |> toEqual(["1"]) |> finish)
    |> ignore
  })

  test("reports scheduled true when invocation is scheduled", () => {
    let mockFn = JestJs.fn(_ => ())
    let fn = mockFn |> Obj.magic |> Throttle.makeControlled

    MockJs.fn(fn.schedule |> Obj.magic, "1") |> ignore

    expect(fn.scheduled()) |> toEqual(true)
  })

  test("reports scheduled false when invocation is not scheduled", () => {
    let mockFn = JestJs.fn(_ => ())
    let fn = mockFn |> Obj.magic |> Throttle.makeControlled

    expect(fn.scheduled()) |> toEqual(false)
  })
})
