strip_right = (lambda text, suffix: text if not text.endswith(suffix) else text[:len(text) - len(suffix)])
