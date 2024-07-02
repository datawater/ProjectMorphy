# Project Morphy
An open source DGT Style chess board (WIP)

### Disclaimer
This project has been put on hold due to my other projecrs interfering;
however, I due plan to continue working on it.
<br>

## Building
Depedencies Required for building:
- [Crystal](https://crystal-lang.org/)
- [Sqlite3](https://www.sqlite.org/)

Install the shards depedencies
```bash
shards install
```

Build (Dev)
```
shards build
```

Build (Release)
```
shards build -p -t -v --release --mcpu=native --threads=8
```
