I had a warning in VSCode that ZLS was built
with another version of `zig` that I use. So, here
the commands I used to update `zls` executable file.

My current version of `zig` is `0.13.0`, hence the
same tag in `zls` source tree has been chosen to
compile in.

The path `~/.config/Code/...` was taken from `Extension Settings` of `Zig Language`.
It can be changed, but I decided to keep as it is.

```bash
mkdir ~/src/zig
cd ~/src/zig/
git clone https://github.com/zigtools/zls.git
cd zls/
git tag
git checkout 0.13.0
zig build -Doptimize=ReleaseSafe
cp -v zig-out/bin/zls ~/.config/Code/User/globalStorage/ziglang.vscode-zig/zls_install/
```
