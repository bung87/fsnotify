import base
import filepoll
export filepoll
import xio/macos/coreservices/coreservices
import darwin/core_foundation

{.pragma: coreservices, header: "CoreServices/CoreServices.h".}

const kFSEventStreamEventIdSinceNow = -1
const kFSEventStreamCreateFlagNone = 0

type CFAbsoluteTime = float64 

proc FSEventStreamCreate*[T](
  allocator: CFAllocatorRef,
  callback: FSEventStreamCallback,
  context: ptr FSEventStreamContext,
  pathsToWatch: CFArray[T],
  sinceWhen: FSEventStreamEventId | int,
  latency: CFTimeInterval,
  flags: FSEventStreamCreateFlags
): FSEventStreamRef {.coreservices, importc: "FSEventStreamCreate".}

proc myCallback(
    streamRef: ConstFSEventStreamRef,
    clientCallBackInfo: pointer,
    numEvents: size_t,
    eventPaths: pointer,
    eventFlags: ptr FSEventStreamEventFlags,
    eventIds: ptr FSEventStreamEventId) =
  discard

proc initDirEventData*(name: string, cb: EventCallback): PathEventData =
  let path = CFStringCreate(name)
  let pathes = CFArrayCreate(nil, path.unsafeAddr, 1, nil)
  let latency:CFAbsoluteTime = 3.0
  result = PathEventData(kind: PathKind.Dir)
  result.name = name
  result.cb = cb
  discard FSEventStreamCreate(nil, myCallback, nil, pathes, kFSEventStreamEventIdSinceNow, latency,kFSEventStreamCreateFlagNone)

proc dircb*(args: pointer = nil) =
  discard
