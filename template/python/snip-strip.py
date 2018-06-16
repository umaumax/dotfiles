strip_left = (lambda text, prefix: text if not text.startswith(prefix) else text[len(prefix):])
strip_right = (lambda text, suffix: text if not text.endswith(suffix) else text[:len(text) - len(suffix)])
strip = (lambda text, prefix, suffix: strip_right(strip_left(text, prefix), suffix))
