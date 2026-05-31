from functools import wraps
from flask import make_response

def cache_control(max_age=300):
    """Add cache headers so browsers cache the response."""
    def decorator(f):
        @wraps(f)
        def decorated(*args, **kwargs):
            response = make_response(f(*args, **kwargs))
            response.headers['Cache-Control'] = f'public, max-age={max_age}'
            return response
        return decorated
    return decorator

def no_cache(f):
    """For user-specific pages — never cache."""
    @wraps(f)
    def decorated(*args, **kwargs):
        response = make_response(f(*args, **kwargs))
        response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate'
        return response
    return decorated
