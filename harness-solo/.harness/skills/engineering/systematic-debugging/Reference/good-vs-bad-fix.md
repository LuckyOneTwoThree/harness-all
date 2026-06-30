# Systematic Debugging — Good vs Bad Fix Examples

A good fix targets the root cause and is locked in by a regression test. A bad fix silences the symptom and leaves the cause free to resurface.

<Good>
```python
# Root cause: Y initialized after X reads it
# Fix: move Y's init before X's first read
def init():
    y = load_config()        # moved up
    x = build_parser(y)      # now sees config
```
</Good>

<Bad>
```python
# "Fix": guard against the None we observed
def init():
    x = build_parser(y)
    if x is None:
        x = DEFAULT_PARSER   # symptom patched, Y still wrong
```
</Bad>
