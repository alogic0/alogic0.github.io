Do you know that you can read the Zig standard library documentation locally? With Zig 0.14.0, you can simply run the command

```
zig std
```
It will generate the documentation on the fly, run local server and open your browser on an address like `127.0.0.1:39985/` . Then you can stop that server by pressing _Ctrl-C_ in a terminal, but the browser will already have cached all the necessary files, allowing you to continue browsing.

Let's take a closer look at how it works.

To run a web server Zig compiles `${zig_dir}/lib/compiler/std-docs.zig` and saves the resulting executable as `std` whithin the `~/.cache/zig/` directory. Then, it executes this `std` executable, providing it with 3 parameters: the library folder, the path to the Zig executable itself, and the path to the cache directory.
```
zig_dir=/home/oleg/.zig/zig-linux-x86_64-0.14.0
~/.cache/zig/${long_hash}/std  ${zig_dir}/lib  ${zig_dir}/zig 
 ~/.cache/zig
```
You can determine your `zig_dir` by running the command:
```
zig env
``` 
What happens when the browser window opens? `std` sends the browser the static `index.html` and `main.js` files from `lib/docs`, as well as the compiled WASM library from `lib/docs/wasm/`. It also assembles the `.zig` files from the `lib/std` folder and sends them as a `source.tar` archive. The `main.wasm` library parses files form the archive and helps rendering source code. This technique eliminates the need for separate JavaScript files for source code highlighting and precompiled `.html` files for the documentation. It reduces the size of the Zig installation.

If you refresh the page, `std` will check if the library files have changed by comparing their checksums in the cache. If they have not changed, it resends the `source.tar`; otherwise, it recreates the archive and sends the new version.

Now, let's reproduce this process in a separate directory.
```
mkdir doc_test
cd doc_test
cp -v ${zig_dir}/lib/compiler/std-docs.zig .
cp -r ${zig_dir}/lib lib
mkdir cache
zig build-exe std-docs.zig
./std-docs ./lib ${zig_dir}/zig ./cache
```

![Zig std documentation](https://zig.news/uploads/articles/p9kc0c4qla39xp8yiwe3.png)

I hope this has given you a better understanding of the changes Andrew Kelley [made](https://github.com/ziglang/zig/pull/19208) to the Zig Autodoc system.

