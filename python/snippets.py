"""Useful Python code snippets."""
import os
import sys
import json
from pathlib import Path
from datetime import datetime, timedelta
from typing import Any


# --- File Operations ---

def read_file(path: str, encoding: str = 'utf-8') -> str:
    """Read entire file to string."""
    return Path(path).read_text(encoding=encoding)


def write_file(path: str, content: str, encoding: str = 'utf-8') -> None:
    """Write string to file."""
    Path(path).write_text(content, encoding=encoding)


def read_json(path: str) -> Any:
    """Read JSON file."""
    return json.loads(Path(path).read_text())


def write_json(path: str, data: Any, indent: int = 2) -> None:
    """Write JSON file."""
    Path(path).write_text(json.dumps(data, indent=indent, ensure_ascii=False))


# --- Date/Time ---

def days_ago(n: int) -> datetime:
    """Return datetime N days ago."""
    return datetime.now() - timedelta(days=n)


def format_date(dt: datetime, fmt: str = '%Y-%m-%d %H:%M:%S') -> str:
    """Format datetime to string."""
    return dt.strftime(fmt)


def parse_date(s: str, fmt: str = '%Y-%m-%d') -> datetime:
    """Parse date string."""
    return datetime.strptime(s, fmt)


# --- String Utils ---

def truncate(s: str, length: int = 50, suffix: str = '...') -> str:
    """Truncate string with suffix."""
    if len(s) <= length:
        return s
    return s[:length - len(suffix)] + suffix


def slugify(text: str) -> str:
    """Convert text to URL-friendly slug."""
    import re
    text = text.lower().strip()
    text = re.sub(r'[^\w\s-]', '', text)
    text = re.sub(r'[-\s]+', '-', text)
    return text.strip('-')


def camel_to_snake(name: str) -> str:
    """Convert CamelCase to snake_case."""
    import re
    return re.sub(r'(?<!^)(?=[A-Z])', '_', name).lower()


def snake_to_camel(name: str) -> str:
    """Convert snake_case to CamelCase."""
    return ''.join(word.title() for word in name.split('_'))


# --- Environment ---

def get_env(key: str, default: str = '') -> str:
    """Get environment variable with default."""
    return os.environ.get(key, default)


def require_env(key: str) -> str:
    """Get required environment variable or raise."""
    value = os.environ.get(key)
    if value is None:
        raise ValueError(f"Missing required env var: {key}")
    return value


# --- Decorators ---

def retry(max_attempts: int = 3, delay: float = 1.0):
    """Retry decorator with exponential backoff."""
    import time
    def decorator(func):
        def wrapper(*args, **kwargs):
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts - 1:
                        raise
                    time.sleep(delay * (2 ** attempt))
        return wrapper
    return decorator


def timer(func):
    """Time a function execution."""
    import time
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - start
        print(f"{func.__name__}: {elapsed:.4f}s")
        return result
    return wrapper


if __name__ == '__main__':
    print(f"Truncate: {truncate('Hello World this is a long string', 15)}")
    print(f"Slugify: {slugify('Hello World! This is a Test')}")
    print(f"Camel→Snake: {camel_to_snake('MyClassName')}")
    print(f"Snake→Camel: {snake_to_camel('my_class_name')}")
    print(f"Days ago: {days_ago(7).date()}")
