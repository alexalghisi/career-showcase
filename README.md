# alexalghisi

Terminal desk for Alghisi Alessandro Paolo. It opens on `cat about_me.txt`. Type `hinge` and the same roles become a sheet of paper: two pins scale it and turn it, and the point between the pins stays where it is.

**Release, already built:** [open the desk](http://127.0.0.1:43123/) · [open the sheet](http://127.0.0.1:43123/?open=hinge&pose=turned)

The same build is in this repository, under `release/web`. No toolchain required:

```bash
./release/serve.sh
```

That serves [http://127.0.0.1:43123/](http://127.0.0.1:43123/).

![desk](media/desk.gif)

The stills below are from that release.

![terminal](media/desk-terminal.png)

![hinge](media/desk-hinge.png)

On a phone the same file just wraps.

![phone](media/desk-phone.png)

## Run from source

```bash
flutter pub get
flutter test
flutter run -d chrome
```

Rebuild the copy that `release/serve.sh` serves:

```bash
flutter build web --release --base-href / --no-wasm-dry-run
rm -rf release/web
cp -a build/web release/web
```

## Commands

| command | |
| --- | --- |
| `help` | the list |
| `whoami` | short bio |
| `experience` | roles, newest first |
| `education` | schools |
| `stack` | what I actually use |
| `projects` | things with my name on them |
| `languages` | spoken |
| `awards` | olympiad and the bac |
| `contact` | LinkedIn, GitHub, Cluj |
| `cat` | print `about_me.txt` again |
| `hinge` | open the sheet |
| `clear` | wipe the scrollback |

Arrow up recalls the previous command. On the sheet, `r` resets the pins and escape goes back.

## Tests

`flutter test` runs the unit tests (the command shell and the pinch math), the widget tests for the desk and the sheet, and an end-to-end pass from the prompt through the sheet and back to contact.

`integration_test/desk_flow_test.dart` is the same journey on a device:

```bash
flutter test integration_test/desk_flow_test.dart -d <device>
```

## Pages

`.github/workflows/check.yml` analyzes, tests, and builds on every push. `.github/workflows/pages.yml` publishes `main`. In the repository settings, set Pages to GitHub Actions.

A user site is [alexalghisi.github.io](https://alexalghisi.github.io/). A project site is `https://alexalghisi.github.io/<repo>/` and needs `--base-href /<repo>/` in that workflow.
