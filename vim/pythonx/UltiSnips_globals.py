## Python helper functions for UltiSnips

# Provides completion menu for snippets
def complete(t, opts):
  if t:
    opts = [ m for m in opts if m.startswith(t) ]
  if len(opts) == 1:
    return opts[0][len(t):]
  elif len(opts) == 0:
    return ""
  # return os.path.commonprefix(opts) + "  (" + " | ".join(opts) + ")"
  return "  (" + " | ".join(opts) + ")"
