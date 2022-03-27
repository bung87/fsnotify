import base
import filepoll
export filepoll
import xio/macos/coreservices/coreservices
import darwin/core_foundation

const kFSEventStreamEventIdSinceNow = -1
const kFSEventStreamCreateFlagNone = 0

type CFAbsoluteTime = float64 
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
  let pathes = CFArrayCreate(nil, path, 1, nil)
  let latency:CFAbsoluteTime = 3.0
  result = PathEventData(kind: PathKind.Dir)
  result.name = name
  result.cb = cb
  FSEventStreamCreate(nil, myCallback, nil, pathes, kFSEventStreamEventIdSinceNow, latency,kFSEventStreamCreateFlagNone)

proc dircb*(args: pointer = nil) =
  discard
