How to add syntax highlighting to Gedit.

This line of commands works for Ubuntu 24.04 .

```bash
mkdir -p .local/share/libgedit-gtksourceview-300/language-specs
cd .local/share/libgedit-gtksourceview-300/language-specs
wget https://gist.githubusercontent.com/deingithub/f40e2f3b75a4daf471cd8847be14d966/raw/8b0bf765a1fb56384a0d5b3ee88cf2ceb765d486/zig.lang
```
Re-run your `gedit`. Now you should have `zig` in the list of supported languages.

![screenshot](./2025-04/zig_highlight.png | width=100)

If version of `gtksourceview` is changed, then check its name in the `/usr/share` and modify your `.local/share` folder name accordingly.

