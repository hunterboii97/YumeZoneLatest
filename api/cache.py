from cachetools import TTLCache
import threading

# Thread-safe caches with TTL
# Anime/manga data changes rarely — cache for 10 minutes
anime_cache = TTLCache(maxsize=2000, ttl=600)
# Search results — cache for 5 minutes  
search_cache = TTLCache(maxsize=1000, ttl=300)
# Episode data — cache for 30 minutes (very stable)
episode_cache = TTLCache(maxsize=3000, ttl=1800)
# User session data — cache for 2 minutes
user_cache = TTLCache(maxsize=500, ttl=120)

# Lock for thread safety with gevent workers
cache_lock = threading.Lock()

def get_cached(cache, key):
    with cache_lock:
        return cache.get(key)

def set_cached(cache, key, value):
    with cache_lock:
        cache[key] = value
