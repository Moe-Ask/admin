class SystemInfo {
  static SystemInfo current;

  int operationTime;
  MemoryStats memoryStats;

  SystemInfo({this.operationTime, this.memoryStats});

  SystemInfo.fromJson(Map<String, dynamic> json) {
    operationTime = json['operation_time'];
    memoryStats = json['memory_stats'] != null
        ? MemoryStats.fromJson(json['memory_stats'])
        : null;
  }
}

class MemoryStats {
  int alloc;
  int buckHashSys;
  int gcSys;
  int heapAlloc;
  int heapIdle;
  int heapInuse;
  int heapObjects;
  int heapReleased;
  int heapSys;
  int lastGc;
  int lookups;
  int mCacheInuse;
  int mCacheSys;
  int mSpanInuse;
  int mSpanSys;
  int mallocs;
  int nextGc;
  int numGc;
  int otherSys;
  int pauseTotalNs;
  int stackInuse;
  int stackSys;
  int sys;
  int totalAlloc;

  MemoryStats(
      {this.alloc,
        this.buckHashSys,
        this.gcSys,
        this.heapAlloc,
        this.heapIdle,
        this.heapInuse,
        this.heapObjects,
        this.heapReleased,
        this.heapSys,
        this.lastGc,
        this.lookups,
        this.mCacheInuse,
        this.mCacheSys,
        this.mSpanInuse,
        this.mSpanSys,
        this.mallocs,
        this.nextGc,
        this.numGc,
        this.otherSys,
        this.pauseTotalNs,
        this.stackInuse,
        this.stackSys,
        this.sys,
        this.totalAlloc});

  MemoryStats.fromJson(Map<String, dynamic> json) {
    alloc = json['alloc'];
    buckHashSys = json['buck_hash_sys'];
    gcSys = json['gc_sys'];
    heapAlloc = json['heap_alloc'];
    heapIdle = json['heap_idle'];
    heapInuse = json['heap_inuse'];
    heapObjects = json['heap_objects'];
    heapReleased = json['heap_released'];
    heapSys = json['heap_sys'];
    lastGc = json['last_gc'];
    lookups = json['lookups'];
    mCacheInuse = json['m_cache_inuse'];
    mCacheSys = json['m_cache_sys'];
    mSpanInuse = json['m_span_inuse'];
    mSpanSys = json['m_span_sys'];
    mallocs = json['mallocs'];
    nextGc = json['next_gc'];
    numGc = json['num_gc'];
    otherSys = json['other_sys'];
    pauseTotalNs = json['pause_total_ns'];
    stackInuse = json['stack_inuse'];
    stackSys = json['stack_sys'];
    sys = json['sys'];
    totalAlloc = json['total_alloc'];
  }
}
