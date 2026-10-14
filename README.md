# alexalghisi

CV for Alessandro Paolo Alghisi. The roles are on the left. The right column is a short brief for HR: the portrait and the experience that matters in a first read. Plain text a search engine can read.

**Site:** [alexalghisi.github.io](https://alexalghisi.github.io/)

Preview it locally:

```bash
python3 -m http.server 43123 -d site
```

That serves [http://127.0.0.1:43123/](http://127.0.0.1:43123/).

![CV](media/cv-desktop.png)

On a phone the portrait and the highlights sit above the roles.

![phone](media/cv-phone.png)

## Pages

The live page is [alexalghisi.github.io](https://alexalghisi.github.io/), from the `alexalghisi.github.io` repository. `career-showcase` only redirects there.

## Desk

The repository also holds a Flutter desk: a command shell and a sheet you can pinch. It is not the published page.

```bash
flutter pub get
flutter test
flutter run -d chrome
```

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

`flutter test` covers the command shell, the pinch math, the desk widgets, and a check that `site/index.html` stays a CV.

A built copy of the desk is under `release/web`:

```bash
./release/serve.sh
```
